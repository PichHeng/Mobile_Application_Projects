import 'package:demo1/core/widgets/sparkline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<double> values) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Sparkline(values: values)),
    ),
  );
}

void main() {
  testWidgets('renders a long series without errors', (tester) async {
    await _pump(tester, [for (var i = 0; i < 118; i++) 20.0 + i % 5]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a flat line without errors', (tester) async {
    await _pump(tester, [5, 5, 5, 5]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a single value without errors', (tester) async {
    await _pump(tester, [3]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an empty list renders no chart and no errors', (tester) async {
    await _pump(tester, []);

    expect(find.byType(LineChart), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
