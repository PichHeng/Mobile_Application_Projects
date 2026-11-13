import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_bar_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, int count) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UsageBarChart(
          points: [
            for (var i = 0; i < count; i++) UsagePoint('$i', 1.0 + i % 4),
          ],
        ),
      ),
    ),
  );
}

void main() {
  for (final count in [10, 7, 30]) {
    testWidgets('renders $count points without errors', (tester) async {
      await _pump(tester, count);
      expect(find.byType(BarChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('an Empty list renders no chart and no errors', (tester) async {
    await _pump(tester, 0);

    expect(find.byType(BarChart), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
