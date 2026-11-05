import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
      };
}
