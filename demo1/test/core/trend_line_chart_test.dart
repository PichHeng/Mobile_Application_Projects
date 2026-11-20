import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/core/widgets/trend_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<ChartPoint> points) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: TrendLineChart(
          points: points,
          bandMin: 22,
          bandMax: 26,
          xInterval: 180,
          xLabel: (x) => x.round().toString(),
          unit: '°C',
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders a full day of samples without errors', (tester) async {
    await _pump(tester, [
      for (var i = 0; i < 118; i++) ChartPoint(i * 5.0, 22 + (i % 7) * 0.5),
    ]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders values far outside the band', (tester) async {
    await _pump(tester, const [ChartPoint(0, 10), ChartPoint(180, 40)]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a flat line inside the band', (tester) async {
    await _pump(tester, const [
      ChartPoint(0, 24),
      ChartPoint(90, 24),
      ChartPoint(180, 24),
    ]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a single point without errors', (tester) async {
    await _pump(tester, const [ChartPoint(0, 24)]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an empty list renders no chart and no errors', (tester) async {
    await _pump(tester, const []);

    expect(find.byType(LineChart), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
