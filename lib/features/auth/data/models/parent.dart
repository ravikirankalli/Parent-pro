/// The authenticated parent, as returned by `/login`.
class Parent {
  const Parent({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.parentCode,
    this.schoolId,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  /// The `user_id` the parent types on the login screen, e.g. `PR-1234`.
  final String? parentCode;
  final String? schoolId;

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      parentCode: json['user_id']?.toString(),
      schoolId: json['school_id']?.toString(),
    );
  }

  Map<String, String> toStorageMap() => {
        AuthStorageKeys.parentId: id,
        AuthStorageKeys.parentName: name,
        AuthStorageKeys.parentEmail: email,
        AuthStorageKeys.parentRole: role,
        AuthStorageKeys.parentCode: parentCode ?? '',
        AuthStorageKeys.schoolId: schoolId ?? '',
      };
}

/// Keys used for the locally persisted session.
class AuthStorageKeys {
  AuthStorageKeys._();

  static const String accessToken = 'parent_access_token';
  static const String refreshToken = 'parent_refresh_token';
  static const String parentId = 'parent_id';
  static const String parentName = 'parent_name';
  static const String parentEmail = 'parent_email';
  static const String parentRole = 'parent_role';
  static const String parentCode = 'parent_code';
  static const String schoolId = 'parent_school_id';

  static const List<String> all = [
    accessToken,
    refreshToken,
    parentId,
    parentName,
    parentEmail,
    parentRole,
    parentCode,
    schoolId,
  ];
}
