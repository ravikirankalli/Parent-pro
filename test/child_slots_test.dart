import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parent_pro/features/auth/data/auth_service.dart';
import 'package:parent_pro/features/auth/data/models/child_slot.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('login screen always offers three slots, empty by default', () async {
    final slots = await AuthService.loadSlots();

    expect(slots, hasLength(3));
    expect(slots.every((s) => s.isEmpty), isTrue);
    expect(slots.map((s) => s.label), ['Student 1', 'Student 2', 'Student 3']);
  });

  test('a saved child keeps its place and shows its name', () async {
    SharedPreferences.setMockInitialValues({
      'parent_child_slots': ChildSlot.encodeList(const [
        ChildSlot(
          index: 1,
          studentId: 'DPS1A.KK',
          name: 'Kamal Kumar',
          refreshToken: 'token-abc',
        ),
      ]),
    });

    final slots = await AuthService.loadSlots();

    expect(slots[0].isEmpty, isTrue);
    expect(slots[1].isEmpty, isFalse);
    expect(slots[1].label, 'Kamal Kumar');
    expect(slots[1].studentId, 'DPS1A.KK');
    expect(slots[2].isEmpty, isTrue);
  });

  test('forgetting a child frees its slot and leaves the others', () async {
    SharedPreferences.setMockInitialValues({
      'parent_child_slots': ChildSlot.encodeList(const [
        ChildSlot(index: 0, studentId: 'A', name: 'Asha', refreshToken: 't1'),
        ChildSlot(index: 2, studentId: 'B', name: 'Bala', refreshToken: 't2'),
      ]),
    });

    await AuthService.forgetSlot(0);
    final slots = await AuthService.loadSlots();

    expect(slots[0].isEmpty, isTrue);
    expect(slots[2].label, 'Bala');
  });

  test('a slot stores the refresh token, never the password', () {
    const slot = ChildSlot(
      index: 0,
      studentId: 'DPS1A.KK',
      name: 'Kamal',
      refreshToken: 'token-abc',
    );

    expect(slot.toJson().keys, isNot(contains('password')));
    expect(slot.toJson()['refresh_token'], 'token-abc');
  });
}
