import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/parent.dart';

/// Outcome of an authentication call.
class AuthResult {
  const AuthResult._({required this.success, this.message, this.parent});

  const AuthResult.success(Parent parent) : this._(success: true, parent: parent);

  /// A successful call that returns a message rather than a parent, such as a
  /// password reset request.
  const AuthResult.ok(String message) : this._(success: true, message: message);

  const AuthResult.failure(String message)
      : this._(success: false, message: message);

  final bool success;
  final String? message;
  final Parent? parent;
}

/// Authentication against the School Pro backend. The backend matches the
/// identifier against either the e-mail or the assigned Login ID, and rejects
/// any account whose role is not `parent`.
class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<AuthResult> login({
    required String parentId,
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
              'identifier': parentId,
              'password': password,
              'role': ApiConfig.role,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = _decode(response.body);

      if (response.statusCode == 200) {
        final userJson = data['user'];
        if (userJson is! Map<String, dynamic>) {
          return const AuthResult.failure(
            'Unexpected response from the server. Please try again.',
          );
        }

        final parent = Parent.fromJson(userJson);
        await _persistSession(
          parent: parent,
          accessToken: data['access_token'] as String?,
          refreshToken: data['refresh_token'] as String?,
        );
        return AuthResult.success(parent);
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

  /// The parent's profile: name, designation, address and contact details.
  /// Returns null when the call fails.
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

  Future<void> logout() async {
    try {
      await apiClient
          .post(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logoutPath}'))
          .timeout(ApiConfig.timeout);
    } catch (_) {
      // The local session is cleared regardless of whether the call succeeds.
    }
    await ApiClient.clearSession();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthStorageKeys.refreshToken) != null;
  }

  static Future<String?> storedParentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthStorageKeys.parentName);
  }

  Future<void> _persistSession({
    required Parent parent,
    required String? accessToken,
    required String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await prefs.setString(AuthStorageKeys.accessToken, accessToken);
    }
    if (refreshToken != null) {
      await prefs.setString(AuthStorageKeys.refreshToken, refreshToken);
    }
    for (final entry in parent.toStorageMap().entries) {
      await prefs.setString(entry.key, entry.value);
    }
  }

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return const {};
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }

  /// Turns a failed response into a message that is safe to show the user.
  String _messageFor(int statusCode, Map<String, dynamic> data) {
    final serverMessage = data['message'];
    if (serverMessage is String && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    switch (statusCode) {
      case 401:
        return 'Invalid Login ID or password.';
      case 403:
        return 'This account is not registered as a parent.';
      case 422:
        return 'Please check your Login ID and password.';
      case 429:
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return statusCode >= 500
            ? 'The server is unavailable right now. Please try again later.'
            : 'Login failed. Please try again.';
    }
  }
}
