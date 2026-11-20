import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

ClimateSeries _series(List<ChartPoint> points) => ClimateSeries(
  metric: ClimateMetric.temperature,
  period: UsagePeriod.today,
  reading: const RangedReading(value: 24.6, min: 22, max: 26),
  points: points,
);

final _today = _series(const [
  ChartPoint(0, 22.4),
  ChartPoint(300, 23.0),
  ChartPoint(360, 23.4),
  ChartPoint(581, 24.6),
]);

void main() {
  test('latest is the last point', () {
    expect(_today.latest, 24.6);
  });

  test('average adds up the values and divides by the count', () {
    final series = _series(const [ChartPoint(0, 10), ChartPoint(1, 20)]);

    expect(series.average, closeTo(15, 1e-9));
  });

  test('valueAt uses the last point at or before x', () {
    expect(_today.valueAt(360), 23.4);
    expect(_today.valueAt(359), 23.0);
    expect(_today.valueAt(-1), isNull);
  });

  test('changeSince 06:00 is 1.2 degrees', () {
    expect(_today.changeSince(360), closeTo(1.2, 1e-9));
  });

  test('an empty series has nothing to report', () {
    final empty = _series(const []);

    expect(empty.latest, isNull);
    expect(empty.average, isNull);
    expect(empty.changeSince(0), isNull);
  });

  test('ys lists the values in order', () {
    expect(_today.ys, [22.4, 23.0, 23.4, 24.6]);
  });
}
