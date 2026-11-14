import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:flutter_test/flutter_test.dart';

WaterZone _zone(double moisture, {double litres = 10}) => WaterZone(
  letter: 'A',
  name: 'Test',
  moisture: moisture,
  targetMin: 35,
  targetMax: 50,
  mode: IrrigationMode.auto,
  litres: litres,
);

void main() {
  test('a zone below its minimum is dry', () {
    expect(_zone(28).isDry, true);
  });

  test('a zone exactly at its minimum is not dry ', () {
    expect(_zone(35).isDry, false);
  });

  test('zonesTotal adds the litres of every zone', () {
    final report = WaterReport(
      series: const UsageSeries(points: [], previousTotal: 0),
      zones: [
        _zone(40, litres: 96),
        _zone(28, litres: 102),
        _zone(38, litres: 48),
      ],
      openValves: 0,
    );
    expect(report.zonesTotal, closeTo(246, 0.0001));
  });

  test('all valves closed only when noen are open', () {
    const series = UsageSeries(points: [], previousTotal: 0);
    expect(
      const WaterReport(
        series: series,
        zones: [],
        openValves: 0,
      ).allValvesClosed,
      true,
    );
    expect(
      const WaterReport(
        series: series,
        zones: [],
        openValves: 1,
      ).allValvesClosed,
      false,
    );
  });

  test('the design numbers: 74 L left and 8 percent less', () {
    const series = UsageSeries(
      points: [UsagePoint('a', 246)],
      previousTotal: 267.4,
      budget: 320,
    );
    expect(series.budgetRemaining, closeTo(74, 0.0001));
    expect(series.changeVsPrevious, closeTo(-0.08, 0.0001));
  });
}
