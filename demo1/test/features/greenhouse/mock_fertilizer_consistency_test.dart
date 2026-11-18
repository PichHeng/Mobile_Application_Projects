import 'package:demo1/features/greenhouse/data/repositories/fake_greenhouse_repository.dart';
import 'package:demo1/features/resources/data/models/fertilizer_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/fake_resource_usage_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('overview and fertilizer page agree on todays fertilizer', () async {
    final overview = await FakeGreenhouseRepository().getOverview();
    final fertilizer = await FakeResourceUsageRepository().getFertillizer(
      UsagePeriod.today,
    );

    expect(
      overview.resources.fertilizerLitres,
      closeTo(fertilizer.series.total, 0.0001),
    );
    expect(fertilizer.series.total, closeTo(1.8, 0.0001));
  });

  test('todays fertilizer is on the daily plan', () async {
    final fertilizer = await FakeResourceUsageRepository().getFertillizer(
      UsagePeriod.today,
    );

    expect(fertilizer.planStatus, PlanStatus.onPlan);
  });

  test('the cumulative chart ends at the total', () async {
    final fertilizer = await FakeResourceUsageRepository().getFertillizer(
      UsagePeriod.today,
    );

    expect(
      fertilizer.series.cumulativePoints.last.value,
      closeTo(fertilizer.series.total, 0.0001),
    );
  });

  test('the last day of the week equals todays total', () async {
    final repo = FakeResourceUsageRepository();
    final today = await repo.getFertillizer(UsagePeriod.today);
    final week = await repo.getFertillizer(UsagePeriod.week);

    expect(week.series.points.last.value, closeTo(today.series.total, 0.0001));
  });
}
