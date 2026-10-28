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
  testWidgets('favorite and counter are interactive', (t) async {
    await t.pumpWidget(const MyApp());
    await t.tap(find.byTooltip('Toggle favorite'));
    await t.pump();
    expect(find.text('Flutter is a favorite!'), findsOneWidget);
    await t.ensureVisible(find.text('Click me: 0'));
    await t.tap(find.text('Click me: 0'));
    await t.pump();
    expect(find.text('Click me: 1'), findsOneWidget);
  });
}
