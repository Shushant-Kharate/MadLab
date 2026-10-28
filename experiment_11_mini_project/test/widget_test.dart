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
    'planner creates, completes, filters, reloads and deletes tasks',
    (t) async {
      await t.pumpWidget(const MyApp());
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextFormField), 'Learn Dart');
      await t.tap(find.text('Add task'));
      await t.pumpAndSettle();
      expect(find.text('Learn Dart'), findsOneWidget);
      await t.tap(find.byType(Checkbox));
      await t.pumpAndSettle();
      expect(find.text('1 / 1 tasks complete'), findsOneWidget);
      await t.tap(find.text('Pending'));
      await t.pumpAndSettle();
      expect(find.text('Learn Dart'), findsNothing);
      await t.tap(find.text('Completed'));
      await t.pumpAndSettle();
      await t.tap(find.text('Learn Dart'));
      await t.pumpAndSettle();
      expect(find.text('Task details'), findsOneWidget);
      await t.pageBack();
      await t.pumpAndSettle();
      await t.pumpWidget(const SizedBox.shrink());
      await t.pumpWidget(const MyApp());
      await t.pumpAndSettle();
      expect(find.text('Learn Dart'), findsOneWidget);
      await t.tap(find.byTooltip('Delete task'));
      await t.pumpAndSettle();
      expect(find.text('Learn Dart'), findsNothing);
    },
  );
}
