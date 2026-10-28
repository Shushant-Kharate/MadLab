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
  testWidgets('layout navigation returns to home', (t) async {
    await t.pumpWidget(const MyApp());
    await t.ensureVisible(find.text('Open second screen'));
    await t.tap(find.text('Open second screen'));
    await t.pumpAndSettle();
    expect(find.text('Back to Home'), findsOneWidget);
    await t.tap(find.text('Back to Home'));
    await t.pumpAndSettle();
    expect(find.text('Open second screen'), findsOneWidget);
  });
}
