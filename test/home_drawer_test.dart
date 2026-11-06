import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parent_pro/features/home/presentation/home_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({
        'parent_active_student_name': 'Kamal Kumar',
      }));

  testWidgets('menu opens a drawer offering log out', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('Switch student'), findsOneWidget);
    expect(find.text('Kamal Kumar'), findsOneWidget);
  });
}
