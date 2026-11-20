import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ClimateSeries _series(
  UsagePeriod period,
  List<ChartPoint> points, {
  ClimateMetric metric = ClimateMetric.temperature,
}) => ClimateSeries(
  metric: metric,
  period: period,
  reading: const RangedReading(value: 24.6, min: 22, max: 26),
  points: points,
);

void main() {
  test('x labels for today are clock times', () {
    final label = xLabelFor(UsagePeriod.today);

    expect(label(0), '00:00');
    expect(label(180), '03:00');
    expect(label(581), '09:41');
  });

  test('x labels for the week are weekday names', () {
    final label = xLabelFor(UsagePeriod.week);

    expect(label(0), 'Sat');
    expect(label(6), 'Fri');
    expect(label(9), 'Fri'); // ក្រៅជួរមិនបោះកំហុស
  });

  test('x labels for the month are day numbers', () {
    final label = xLabelFor(UsagePeriod.month);

    expect(label(0), '1');
    expect(label(29), '30');
  });

  test('label intervals are 180 minutes, 2 days and 8 days', () {
    expect(xIntervalFor(UsagePeriod.today), 180);
    expect(xIntervalFor(UsagePeriod.week), 2);
    expect(xIntervalFor(UsagePeriod.month), 8);
  });

  test('today compares with 06:00 once it is past six', () {
    final series = _series(UsagePeriod.today, const [
      ChartPoint(0, 22.4),
      ChartPoint(360, 23.4),
      ChartPoint(581, 24.6),
    ]);

    expect(changeAnchorX(series), 360);
    expect(sinceLabel(series), '06:00');
  });

  test('before six today compares with the first sample', () {
    final series = _series(UsagePeriod.today, const [
      ChartPoint(0, 22.4),
      ChartPoint(200, 22.9),
    ]);

    expect(changeAnchorX(series), 0);
    expect(sinceLabel(series), '00:00');
  });

  test('week and month compare with their first point', () {
    final week = _series(UsagePeriod.week, const [
      ChartPoint(0, 23),
      ChartPoint(6, 24),
    ]);
    final month = _series(UsagePeriod.month, const [
      ChartPoint(0, 23),
      ChartPoint(29, 24),
    ]);

    expect(sinceLabel(week), '7 days ago');
    expect(sinceLabel(month), '30 days ago');
    expect(changeAnchorX(week), 0);
  });

  test('a rise shows an up arrow and the design text', () {
    final series = _series(UsagePeriod.today, const [
      ChartPoint(360, 23.4),
      ChartPoint(581, 24.6),
    ]);

    final line = changeLine(series)!;

    expect(line.icon, Icons.arrow_upward);
    expect(line.text, '1.2 °C since 06:00');
  });

  test('a fall shows a down arrow', () {
    final series = _series(UsagePeriod.today, const [
      ChartPoint(360, 25.0),
      ChartPoint(581, 24.0),
    ]);

    expect(changeLine(series)!.icon, Icons.arrow_downward);
  });

  test('a tiny change is reported as no change', () {
    final series = _series(UsagePeriod.today, const [
      ChartPoint(360, 24.60),
      ChartPoint(581, 24.62),
    ]);

    final line = changeLine(series)!;

    expect(line.icon, isNull);
    expect(line.text, 'No change since 06:00');
  });

  test('an empty series has no change line', () {
    expect(changeLine(_series(UsagePeriod.today, const [])), isNull);
  });

  test('today shows the current value as now, others the average', () {
    const points = [ChartPoint(0, 20), ChartPoint(1, 30)];
    final today = _series(UsagePeriod.today, points);
    final week = _series(UsagePeriod.week, points);

    expect(shownValue(today), 24.6);
    expect(valueSuffix(today), '°C now');
    expect(shownValue(week), closeTo(25, 1e-9));
    expect(valueSuffix(week), '°C avg');
  });

  test('the legend range text matches the design', () {
    const reading = RangedReading(value: 24.6, min: 22, max: 26);

    expect(rangeText(ClimateMetric.temperature, reading), '22–26 °C');
  });
}
