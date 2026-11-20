import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:flutter_test/flutter_test.dart';

const _trend = ClimateTrend(
  metric: ClimateMetric.temperature,
  reading: RangedReading(value: 24.6, min: 22, max: 26),
  samples: [
    ClimateSample(0, 22.4),
    ClimateSample(300, 23.0),
    ClimateSample(360, 23.4),
    ClimateSample(581, 24.6),
  ],
);

ClimateTrend _trendWith(ClimateMetric metric, double value) => ClimateTrend(
  metric: metric,
  reading: RangedReading(value: value, min: 22, max: 26),
  samples: const [ClimateSample(0, 1), ClimateSample(100, 2)],
);

void main() {
  test('valueAt finds the sample exactly at that minute', () {
    expect(_trend.valueAt(360), 23.4);
  });

  test('valueAt uses the last sample before the minute', () {
    expect(_trend.valueAt(359), 23.0);
  });

  test('valueAt is null before the first sample', () {
    expect(_trend.valueAt(-1), isNull);
  });

  test('changeSince 06:00 is 1.2 degrees', () {
    expect(_trend.changeSince(360), closeTo(1.2, 0.0001));
  });

  test('changeSince is null when there is no earlier sample', () {
    expect(_trend.changeSince(-5), isNull);
  });

  test('values lists every sample value in order', () {
    expect(_trend.values, [22.4, 23.0, 23.4, 24.6]);
  });

  test('inRangeCount counts only readings inside their target', () {
    final today = ClimateToday(
      sampleIntervalMinutes: 5,
      trends: [
        _trendWith(ClimateMetric.temperature, 24),
        _trendWith(ClimateMetric.humidity, 30),
      ],
    );

    expect(today.inRangeCount, 1);
    expect(today.total, 2);
    expect(today.allInRange, false);
  });

  test('allInRange is false when there are no trends at all', () {
    const empty = ClimateToday(trends: [], sampleIntervalMinutes: 5);

    expect(empty.allInRange, false);
    expect(empty.lastMinute, 0);
  });

  test('trendOf finds a metric and reports the last minute', () {
    final today = ClimateToday(
      sampleIntervalMinutes: 5,
      trends: [_trendWith(ClimateMetric.light, 24)],
    );

    expect(today.trendOf(ClimateMetric.light).metric, ClimateMetric.light);
    expect(today.lastMinute, 100);
    expect(() => today.trendOf(ClimateMetric.co2), throwsStateError);
  });
}
