import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/child_slot.dart';

/// Outcome of an authentication call.
class AuthResult {
  const AuthResult._({required this.success, this.message, this.slot});

  const AuthResult.success(ChildSlot slot) : this._(success: true, slot: slot);

  const AuthResult.ok(String message) : this._(success: true, message: message);

  const AuthResult.failure(String message)
      : this._(success: false, message: message);

  final bool success;
  final String? message;
  final ChildSlot? slot;
}

/// Parent Pro authentication.
///
/// A parent has no account of their own. They sign in with one of their
/// children's Student ID and password, so this talks to the backend as role
/// `student`. Up to three children are kept as slots on the login screen; the
/// child's refresh token is saved so the parent can tap back in without
/// retyping anything. The password itself is never stored.
class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// How many children the login screen offers.
  static const int slotCount = 3;

  // ---------------------------------------------------------------- slots

  static Future<List<ChildSlot>> loadSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = ChildSlot.decodeList(prefs.getString(AuthStorageKeys.slots));

    return List<ChildSlot>.generate(slotCount, (i) {
      return saved.firstWhere(
        (s) => s.index == i,
        orElse: () => ChildSlot(index: i, studentId: '', name: '', refreshToken: ''),
      );
    });
  }

  static Future<void> _saveSlot(ChildSlot slot) async {
    final prefs = await SharedPreferences.getInstance();
    final slots = (await loadSlots()).where((s) => !s.isEmpty).toList()
      ..removeWhere((s) => s.index == slot.index)
      ..add(slot);
    await prefs.setString(AuthStorageKeys.slots, ChildSlot.encodeList(slots));
  }

  /// Forget a saved child. Used by "remove" on the login screen.
  static Future<void> forgetSlot(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final slots = (await loadSlots())
        .where((s) => !s.isEmpty && s.index != index)
        .toList();
    await prefs.setString(AuthStorageKeys.slots, ChildSlot.encodeList(slots));
  }

  // ---------------------------------------------------------------- login

  /// First sign-in for a slot: the parent types the child's ID and password.
  Future<AuthResult> signInWithPassword({
    required int slotIndex,
    required String studentId,
    required String password,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginPath}');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'identifier': studentId,
              'password': password,
              'role': ApiConfig.role,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        final user = data['user'];
        if (user is! Map<String, dynamic>) {
          return const AuthResult.failure(
            'Unexpected response from the server. Please try again.',
          );
        }

        final slot = ChildSlot(
          index: slotIndex,
          studentId: user['user_id']?.toString() ?? studentId,
          name: user['name']?.toString() ?? '',
          refreshToken: data['refresh_token']?.toString() ?? '',
        );

        await _saveSlot(slot);
        await _activate(slot, data['access_token']?.toString());
        return AuthResult.success(slot);
      }

      return AuthResult.failure(_messageFor(response.statusCode, data));
    } on TimeoutException {
      return const AuthResult.failure(
        'The server took too long to respond. Please try again.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'No internet connection. Please check your network and try again.',
      );
    } on FormatException {
      return const AuthResult.failure(
        'Unexpected response from the server. Please try again.',
      );
    } catch (_) {
      return const AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  /// Tapping a slot that has already been used: exchange its refresh token for
  /// a fresh access token, so no password is needed.
  Future<AuthResult> signInToSlot(ChildSlot slot) async {
    if (slot.isEmpty) {
      return const AuthResult.failure('This student has not been set up yet.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshTokenPath}');

    try {
      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${slot.refreshToken}',
          'Accept': 'application/json',
        },
      ).timeout(ApiConfig.timeout);

      final data = _decode(response.body);

      if (response.statusCode == 200 && data['access_token'] != null) {
        await _activate(slot, data['access_token'].toString());
        return AuthResult.success(slot);
      }

      // The saved session has expired or been revoked: drop it so the slot
      // asks for the password again rather than failing forever.
      await forgetSlot(slot.index);
      return AuthResult.failure(
        'Saved sign-in for ${slot.label} has expired. Please enter the '
        'password again.',
      );
    } on TimeoutException {
      return const AuthResult.failure(
        'The server took too long to respond. Please try again.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'No internet connection. Please check your network and try again.',
      );
    } catch (_) {
      return const AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  Future<AuthResult> requestPasswordReset(String email) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.forgotPasswordPath}');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(ApiConfig.timeout);

      final data = _decode(response.body);
      if (response.statusCode == 200) {
        return AuthResult.ok(
          data['message'] as String? ??
              'If the e-mail exists, a reset code has been sent.',
        );
      }
      return AuthResult.failure(_messageFor(response.statusCode, data));
    } on SocketException {
      return const AuthResult.failure(
        'No internet connection. Please check your network and try again.',
      );
    } catch (_) {
      return const AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  // --------------------------------------------------------------- session

  Future<void> _activate(ChildSlot slot, String? accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await prefs.setString(AuthStorageKeys.accessToken, accessToken);
    }
    await prefs.setString(AuthStorageKeys.refreshToken, slot.refreshToken);
    await prefs.setString(AuthStorageKeys.activeStudentId, slot.studentId);
    await prefs.setString(AuthStorageKeys.activeStudentName, slot.name);
    await prefs.setInt(AuthStorageKeys.activeSlot, slot.index);
  }

  /// Ends the current session. The saved slots are kept, so the parent can tap
  /// a child and go straight back in.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in AuthStorageKeys.all) {
      await prefs.remove(key);
    }
  }

  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthStorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  /// Name of the child currently being viewed, for the header and the drawer.
  static Future<String?> activeStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthStorageKeys.activeStudentName);
  }

  /// The signed-in child's profile. Returns null when the call fails.
  Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      final response = await apiClient
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profilePath}'))
          .timeout(ApiConfig.timeout);
      if (response.statusCode != 200) return null;
      return _decode(response.body);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return const {};
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }

  String _messageFor(int statusCode, Map<String, dynamic> data) {
    final serverMessage = data['message'];
    if (serverMessage is String && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    switch (statusCode) {
      case 401:
        return 'Invalid Student ID or password.';
      case 403:
        return 'Those are not student credentials. Use your child\'s Student '
            'ID and password.';
      case 422:
        return 'Please check the Student ID and password.';
      case 429:
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return statusCode >= 500
            ? 'The server is unavailable right now. Please try again later.'
            : 'Login failed. Please try again.';
    }
  }
}
