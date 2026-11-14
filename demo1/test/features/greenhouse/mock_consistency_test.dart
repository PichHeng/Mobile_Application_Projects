import 'package:demo1/features/greenhouse/data/repositories/fake_greenhouse_repository.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/fake_resource_usage_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('overview and energy page agree on todays energy', () async {
    final overview = await FakeGreenhouseRepository().getOverview();
    final energy = await FakeResourceUsageRepository().getEnergy(
      UsagePeriod.today,
    );

    expect(overview.resources.energyKwh, closeTo(energy.series.total, 0.0001));
    expect(
      overview.resources.energyChangeVsYesterday,
      closeTo(energy.series.changeVsPrevious, 0.0001),
    );
  });

  test('overview and water page agree on todays water', () async {
    final overview = await FakeGreenhouseRepository().getOverview();
    final water = await FakeResourceUsageRepository().getWater(
      UsagePeriod.today,
    );

    expect(overview.resources.waterLitres, closeTo(water.series.total, 0.001));
    expect(
      overview.resources.waterAllowanceUsed,
      closeTo(water.series.total / water.series.budget!, 0.0001),
    );
  });

  test('the three zones add up to the totla water used today', () async {
    final water = await FakeResourceUsageRepository().getWater(
      UsagePeriod.today,
    );
    expect(water.zonesTotal, closeTo(water.series.total, 0.0001));
  });

  test('energy consumers add up to the totla energy used today', () async {
    final energy = await FakeResourceUsageRepository().getEnergy(
      UsagePeriod.today,
    );
    expect(energy.consumersTotal, closeTo(energy.series.total, 0.0001));
  });
}
