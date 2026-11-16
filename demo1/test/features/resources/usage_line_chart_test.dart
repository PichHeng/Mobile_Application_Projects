import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, int count) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UsageLineChart(
          points: [
            for (var i = 0; i < count; i++) UsagePoint('$i', 10.0 * (i + 1)),
          ],
        ),
      ),
    ),
  );
}

void main() {
  for (final count in [10, 7, 30, 1]) {
    testWidgets('renders $count points without errors', (tester) async {
      await _pump(tester, count);

      expect(find.byType(LineChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('amn empty list renders no chart and no errors', (tester) async {
    await _pump(tester, 0);
    expect(find.byType(LineChart), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
