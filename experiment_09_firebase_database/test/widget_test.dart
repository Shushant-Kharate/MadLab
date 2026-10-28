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
  testWidgets(
    'local student CRUD persists and unconfigured Firebase stays local',
    (t) async {
      await t.pumpWidget(const MyApp());
      await t.pumpAndSettle();
      await t.tap(find.text('Save Student'));
      await t.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);
      await t.enterText(find.byType(TextFormField).at(0), 'Ada');
      await t.enterText(find.byType(TextFormField).at(1), 'ada@example.com');
      await t.tap(find.text('Save Student'));
      await t.pumpAndSettle();
      expect(find.text('Ada'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
      await t.pumpWidget(const MyApp());
      await t.pumpAndSettle();
      expect(find.text('Ada'), findsOneWidget);
      await t.tap(find.text('Connect Firebase'));
      await t.pumpAndSettle();
      expect(find.textContaining('Supply the four'), findsOneWidget);
      await t.ensureVisible(find.byTooltip('Delete student'));
      await t.tap(find.byTooltip('Delete student'));
      await t.pumpAndSettle();
      expect(find.text('No students found'), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('students'), '[]');
    },
  );
}
