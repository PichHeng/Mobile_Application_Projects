import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/repositories/fake_climate_repository.dart';
import 'package:demo1/features/greenhouse/data/repositories/fake_greenhouse_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the sparkline ends exactly at the current reading', () async {
    final today = await FakeClimateRepository().getToday();

    for (final trend in today.trends) {
      expect(
        trend.samples.last.value,
        trend.reading.value,
        reason: '${trend.metric.name} should end at its current value',
      );
    }
  });

  test('overview and climate page agree on every reading', () async {
    final overview = await FakeGreenhouseRepository().getClimate();
    final today = await FakeClimateRepository().getToday();

    expect(
      today.trendOf(ClimateMetric.temperature).reading.value,
      overview.temperature.value,
    );
    expect(
      today.trendOf(ClimateMetric.humidity).reading.value,
      overview.humidity.value,
    );
    expect(
      today.trendOf(ClimateMetric.light).reading.value,
      overview.light.value,
    );
    expect(today.trendOf(ClimateMetric.co2).reading.value, overview.co2.value);
  });

  test('all four readings are in range as in the design', () async {
    final today = await FakeClimateRepository().getToday();

    expect(today.inRangeCount, 4);
    expect(today.allInRange, true);
  });

  test('temperature rose 1.2 degrees since 06:00', () async {
    final today = await FakeClimateRepository().getToday();

    expect(
      today.trendOf(ClimateMetric.temperature).changeSince(360),
      closeTo(1.2, 0.0001),
    );
  });

  test('samples run every 5 minutes from 00:00 to 09:41', () async {
    final today = await FakeClimateRepository().getToday();
    final samples = today.trendOf(ClimateMetric.temperature).samples;

    expect(today.sampleIntervalMinutes, 5);
    expect(samples.first.minute, 0);
    expect(samples.last.minute, 581);
    expect(samples, hasLength(118));
  });
}
