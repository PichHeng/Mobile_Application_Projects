import 'package:demo1/features/greenhouse/data/mock/mock_energy.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_water.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_fertilizer.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_climate.dart';

class FakeGreenhouseRepository implements GreenhouseRepository {
  @override
  Future<GreenhouseClimate> getClimate() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const GreenhouseClimate(
      temperature: mockTemperature,
      humidity: mockHumidity,
      light: mockLight,
      co2: mockCo2,
    );
  }

  @override
  Future<OverviewSummary> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final energyToday = mockEnergyTodayHourly.fold<double>(
      0,
      (sum, v) => sum + v,
    );
    final waterToday = mockWaterTodayHourly.fold<double>(
      0,
      (sum, v) => sum + v,
    );
    final fertilizerToday = mockFertillizerTodayHourly.fold<double>(
      0,
      (sum, v) => sum + v,
    );

    return OverviewSummary(
      zoneCount: 3,
      resources: ResourceSummary(
        energyKwh: energyToday,
        energyChangeVsYesterday:
            (energyToday - mockEnergyYesterday) / mockEnergyYesterday,
        waterLitres: waterToday,
        waterAllowanceUsed: waterToday / mockWaterAllowance,
        fertilizerLitres: fertilizerToday,
      ),
      health: const PlantHealthSummary(healthy: 114, watch: 8, attention: 2),
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
