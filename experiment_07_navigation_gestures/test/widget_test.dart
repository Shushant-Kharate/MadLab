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
  testWidgets('named routes and gestures work', (t) async {
    await t.pumpWidget(const MyApp());
    await t.tap(find.text('Open second screen'));
    await t.pumpAndSettle();
    expect(find.text('Hello from Home'), findsOneWidget);
    await t.tap(find.text('Back to Home'));
    await t.pumpAndSettle();
    final target = find.text('Tap / double tap / long press / swipe');
    await t.tap(target);
    await t.pump(const Duration(milliseconds: 350));
    await t.pumpAndSettle();
    expect(find.text('Tap (1)'), findsOneWidget);
    await t.tap(target);
    await t.pump(const Duration(milliseconds: 80));
    await t.tap(target);
    await t.pumpAndSettle();
    expect(find.text('Double tap'), findsOneWidget);
    await t.longPress(target);
    await t.pumpAndSettle();
    expect(find.text('Long press'), findsOneWidget);
    await t.fling(target, const Offset(-150, 0), 1000);
    await t.pumpAndSettle();
    expect(find.text('Swipe left'), findsOneWidget);
  });
}
