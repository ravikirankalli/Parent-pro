import 'dart:convert';

/// One of the saved child slots on the login screen.
///
/// A parent has no login of their own: they sign in with a child's own Student
/// ID and password. Once a slot has been used, the refresh token is kept so the
/// parent can tap straight back in.
///
/// The child's **password is deliberately not stored**. Only the long-lived
/// refresh token is, which the backend can revoke.
class ChildSlot {
  const ChildSlot({
    required this.index,
    required this.studentId,
    required this.name,
    required this.refreshToken,
  });

  /// 0, 1 or 2 — the slot's position on the login screen.
  final int index;

  /// The student's login id, e.g. `DPS1A.KK`.
  final String studentId;
  final String name;
  final String refreshToken;

  bool get isEmpty => refreshToken.isEmpty;

  /// The label under the avatar: the child's name once known.
  String get label => name.isNotEmpty ? name : 'Student ${index + 1}';

  Map<String, dynamic> toJson() => {
        'index': index,
        'student_id': studentId,
        'name': name,
        'refresh_token': refreshToken,
      };

  factory ChildSlot.fromJson(Map<String, dynamic> json) => ChildSlot(
        index: json['index'] as int? ?? 0,
        studentId: json['student_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        refreshToken: json['refresh_token']?.toString() ?? '',
      );

  static String encodeList(List<ChildSlot> slots) =>
      jsonEncode(slots.map((s) => s.toJson()).toList());

  static List<ChildSlot> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ChildSlot.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}

/// Keys used for the locally persisted session.
class AuthStorageKeys {
  AuthStorageKeys._();

  /// Tokens for the child currently signed in.
  static const String accessToken = 'parent_access_token';
  static const String refreshToken = 'parent_refresh_token';

  /// The child currently being viewed.
  static const String activeStudentId = 'parent_active_student_id';
  static const String activeStudentName = 'parent_active_student_name';
  static const String activeSlot = 'parent_active_slot';

  /// The saved slots, as a JSON list.
  static const String slots = 'parent_child_slots';

  /// Cleared on logout. The saved slots survive, so the parent can tap back in.
  static const List<String> all = [
    accessToken,
    refreshToken,
    activeStudentId,
    activeStudentName,
    activeSlot,
  ];
}
