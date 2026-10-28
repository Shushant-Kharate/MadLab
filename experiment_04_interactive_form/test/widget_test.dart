import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad_lab/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('renders at mobile and desktop widths without overflow', (
    tester,
  ) async {
    for (final width in [360.0, 1200.0]) {
      await tester.binding.setSurfaceSize(Size(width, 900));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  });
  testWidgets('form rejects invalid values then submits and resets', (t) async {
    await t.pumpWidget(const MyApp());
    await t.tap(find.text('Submit'));
    await t.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);
    await t.enterText(find.byType(TextFormField).at(0), 'Student');
    await t.enterText(find.byType(TextFormField).at(1), 'invalid');
    await t.tap(find.text('Submit'));
    await t.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);
    await t.enterText(find.byType(TextFormField).at(1), 'student@example.com');
    await t.tap(find.byType(Checkbox));
    await t.tap(find.text('Submit'));
    await t.pumpAndSettle();
    expect(find.textContaining('Registration successful'), findsOneWidget);
    await t.tap(find.text('Reset'));
    await t.pumpAndSettle();
    expect(find.textContaining('Registration successful'), findsNothing);
  });
}
