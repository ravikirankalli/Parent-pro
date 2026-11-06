/// Single place to configure where Parent Pro talks to the backend.
///
/// The backend is the School Pro Laravel app.
///
/// A parent has no login of their own: they sign in with one of their
/// children's Student ID and password, so this app authenticates as role
/// `student`. The admin panel decides which children a parent covers.
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

  /// Role this app authenticates as — a child's student account.
  static const String role = 'student';

  static const Duration timeout = Duration(seconds: 20);

  static const String loginPath = '/login';
  static const String refreshTokenPath = '/refresh-token';
  static const String logoutPath = '/logout';
  static const String forgotPasswordPath = '/forgot-password';
  static const String profilePath = '/student/profile';
}
