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
  testWidgets('counter reset and recoverable failure work', (t) async {
    await t.pumpWidget(const MyApp());
    await t.tap(find.text('Test Button'));
    await t.pump();
    expect(find.text('1'), findsOneWidget);
    await t.tap(find.text('Reset counter'));
    await t.pump();
    expect(find.text('0'), findsOneWidget);
    await t.tap(find.text('Test recovery'));
    await t.pump();
    expect(
      find.text('Recovered safely from a simulated failure'),
      findsOneWidget,
    );
  });
}
