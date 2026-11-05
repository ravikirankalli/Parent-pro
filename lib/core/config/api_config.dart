/// Single place to configure where Parent Pro talks to the backend.
///
/// The backend is the School Pro Laravel app. Login is role-gated: an account
/// whose role is not `parent` is rejected with 403, which keeps students,
/// teachers and staff out of this app.
class ApiConfig {
  ApiConfig._();

  /// Override at build time:
  /// `flutter run --dart-define=API_BASE_URL=http://10.0.2.2/school_pro/public/api`
  ///
  /// 10.0.2.2 is the host machine as seen from the Android emulator.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://coral-cassowary-543563.hostingersite.com/api',
  );

  /// Role this app authenticates as.
  static const String role = 'parent';

  static const Duration timeout = Duration(seconds: 20);

  static const String loginPath = '/login';
  static const String refreshTokenPath = '/refresh-token';
  static const String logoutPath = '/logout';
  static const String forgotPasswordPath = '/forgot-password';
  static const String profilePath = '/parent/profile';
}
