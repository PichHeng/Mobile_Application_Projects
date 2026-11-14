import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';
import 'package:demo1/features/overview/presentation/viewmodels/overview_view_model.dart';
// import 'package:demo1/features/overview/presentation/views/overview_view.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubRepository implements GreenhouseRepository {
  _StubRepository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<GreenhouseClimate> getClimate() async {
    if (shouldFail) throw Exception('Sensor offline');
    return const GreenhouseClimate(
      temperature: RangedReading(value: 24.6, min: 22, max: 26),
      humidity: RangedReading(value: 68, min: 60, max: 75),
      light: RangedReading(value: 420, min: 350, max: 500),
      co2: RangedReading(value: 812, min: 700, max: 1000),
    );
  }

  @override
  Future<OverviewSummary> getOverview() async {
    if (shouldFail) throw Exception('sensor offline');
    return const OverviewSummary(
      zoneCount: 3,
      resources: ResourceSummary(
        energyKwh: 18.4,
        energyChangeVsYesterday: -0.12,
        waterLitres: 246,
        waterAllowanceUsed: 0.77,
        fertilizerLitres: 1.8,
      ),
      health: PlantHealthSummary(healthy: 114, watch: 8, attention: 2),
      roots: RootsInsight(soilTemperature: 20.8),
      alerts: [],
    );
  }
}

void main() {
  test('load sucess files both climae and summary', () async {
    final vm = OverviewViewModel(_StubRepository());
    await vm.load();

    expect(vm.hasData, true);
    expect(vm.summary?.zoneCount, 3);
    expect(vm.error, isNull);
    expect(vm.isLoading, false);
  });

  test('load failure sets network error and no data', () async {
    final vm = OverviewViewModel(_StubRepository(shouldFail: true));

    await vm.load();

    expect(vm.hasData, false);
    expect(vm.error, OverviewError.network);
    expect(vm.isLoading, false);
  });

  test('daypart is morning at 09:41', () {
    final vm = OverviewViewModel(
      _StubRepository(),
      clock: () => DateTime(2026, 6, 12, 9, 41),
    );
    expect(vm.dayPart, DayPart.morning);
  });

  test('dayPart is afternoon at 14:00', () {
    final vm = OverviewViewModel(
      _StubRepository(),
      clock: () => DateTime(2026, 6, 12, 14, 0),
    );
    expect(vm.dayPart, DayPart.afternoon);
  });

  test('dayPart is evening at 20:00', () {
    final vm = OverviewViewModel(
      _StubRepository(),
      clock: () => DateTime(2026, 6, 12, 20, 0),
    );
    expect(vm.dayPart, DayPart.evening);
  });

  test('RangedReading incldues its boundaries', () {
    const atMax = RangedReading(value: 26, min: 22, max: 26);
    const tooHigh = RangedReading(value: 30, min: 22, max: 26);

    expect(atMax.isInRange, true);
    expect(tooHigh.isInRange, false);
  });
}
