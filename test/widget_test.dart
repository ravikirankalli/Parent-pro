import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parent_pro/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('Splash screen renders the ParentPro wordmark',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
