import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/fake_climate_repository.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repo = FakeClimateRepository();

  test('every metric ends today exactly at its current reading', () async {
    for (final metric in ClimateMetric.values) {
      final series = await repo.getSeries(metric, UsagePeriod.today);

      expect(
        series.points.last.y,
        series.reading.value,
        reason: '${metric.name} should end at its current value',
      );
    }
  });

  test('the chart and the card show the same samples', () async {
    final today = await repo.getToday();
    final series = await repo.getSeries(
      ClimateMetric.temperature,
      UsagePeriod.today,
    );

    expect(series.ys, today.trendOf(ClimateMetric.temperature).values);
  });

  test('the periods have 118, 7 and 30 points', () async {
    final day = await repo.getSeries(ClimateMetric.humidity, UsagePeriod.today);
    final week = await repo.getSeries(ClimateMetric.humidity, UsagePeriod.week);
    final month = await repo.getSeries(
      ClimateMetric.humidity,
      UsagePeriod.month,
    );

    expect(day.points, hasLength(118));
    expect(week.points, hasLength(7));
    expect(month.points, hasLength(30));
  });

  test('week and month end at the current reading too', () async {
    for (final period in [UsagePeriod.week, UsagePeriod.month]) {
      final series = await repo.getSeries(ClimateMetric.co2, period);

      expect(series.points.last.y, series.reading.value);
    }
  });

  test('the temperature of the week stays inside its target band', () async {
    final series = await repo.getSeries(
      ClimateMetric.temperature,
      UsagePeriod.week,
    );

    expect(series.ys.every((v) => v >= 22 && v <= 26), true);
  });

  test('temperature rose 1.2 degrees since 06:00 on the chart', () async {
    final series = await repo.getSeries(
      ClimateMetric.temperature,
      UsagePeriod.today,
    );

    expect(series.changeSince(360), closeTo(1.2, 1e-9));
  });
}
