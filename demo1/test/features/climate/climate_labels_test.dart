import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:flutter_test/flutter_test.dart';

ClimateTrend _trend(ClimateMetric metric, double min, double max) =>
    ClimateTrend(
      metric: metric,
      reading: RangedReading(value: (min + max) / 2, min: min, max: max),
      samples: const [ClimateSample(0, 1), ClimateSample(581, 2)],
    );

ClimateToday _todayEndingAt(int minute) => ClimateToday(
  sampleIntervalMinutes: 5,
  trends: [
    ClimateTrend(
      metric: ClimateMetric.temperature,
      reading: const RangedReading(value: 24, min: 22, max: 26),
      samples: [const ClimateSample(0, 1), ClimateSample(minute, 2)],
    ),
  ],
);

void main() {
  test('temperature target matches the design', () {
    expect(
      targetText(_trend(ClimateMetric.temperature, 22, 26)),
      'Target 22–26 °C',
    );
  });

  test('humidity target ends with % RH', () {
    expect(
      targetText(_trend(ClimateMetric.humidity, 60, 75)),
      'Target 60–75% RH',
    );
  });

  test('CO2 target uses a thousands separator', () {
    expect(
      targetText(_trend(ClimateMetric.co2, 700, 1000)),
      'Target 700–1,000 ppm',
    );
  });

  test('formatMinute turns minutes into a clock time', () {
    expect(formatMinute(581), '09:41');
    expect(formatMinute(0), '00:00');
    expect(formatMinute(1439), '23:59');
  });

  test('before noon the trends are called morning trends', () {
    expect(
      trendsCaption(_todayEndingAt(581)),
      'Morning trends, 00:00–09:41 · 5-minute sample interval',
    );
  });

  test('after noon the trends are called todays trends', () {
    expect(
      trendsCaption(_todayEndingAt(800)),
      "Today's trends, 00:00–13:20 · 5-minute sample interval",
    );
  });
}
