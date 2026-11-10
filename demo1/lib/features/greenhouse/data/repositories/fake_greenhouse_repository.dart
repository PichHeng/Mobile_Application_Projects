import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';

class FakeGreenhouseRepository implements GreenhouseRepository {
  @override
  Future<GreenhouseClimate> getClimate() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const GreenhouseClimate(
      temperature: RangedReading(value: 24.6, min: 22, max: 26),
      humidity: RangedReading(value: 68, min: 60, max: 75),
      light: RangedReading(value: 420, min: 350, max: 500),
      co2: RangedReading(value: 812, min: 700, max: 1000),
    );
  }

  @override
  Future<OverviewSummary> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return OverviewSummary(
      zoneCount: 3,
      resources: const ResourceSummary(
        energyKwh: 18.4,
        energyChangeVsYesterday: -0.12,
        waterLitres: 246,
        waterAllowanceUsed: 0.77,
        fertilizerLitres: 1.8,
      ),
      health: const PlanthealthSummary(healthy: 114, watch: 8, attention: 2),
      roots: const RootsInsight(
        soilTemperature: 20.8,
        lowMoistureZone: 'Zone B',
      ),
      alerts: [
        MoistureAlert(
          zoneName: 'Zone B',
          cropName: 'Tomato',
          moisture: 28,
          targetMin: 35,
          targetMax: 50,
          nextIrrigation: DateTime(2026, 6, 12, 10, 30),
        ),
      ],
    );
  }
}
