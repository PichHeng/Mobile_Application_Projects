import 'package:demo1/features/resources/data/models/irrigation_schedule.dart';
import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:demo1/features/resources/data/repositories/irrigation_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_controls_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements IrrigationRepository {
  @override
  Future<IrrigationSnapshot> getSnapshot() async {
    return const IrrigationSnapshot(
      inputs: WaterInputs(
        reservoirLitres: 620,
        reservoirCapacityLitres: 1000,
        linePressureBar: 2.1,
        flowLitresPerMin: 0,
      ),
      outputs: [],
      schedule: IrrigationSchedule([
        ScheduledCycle(
          zoneName: 'Zone A',
          cropName: 'Leafy greens',
          hour: 11,
          minute: 0,
          durationMinutes: 8,
          litresPerMinute: 6,
        ),
        ScheduledCycle(
          zoneName: 'Zone B',
          cropName: 'Tomatoes',
          hour: 10,
          minute: 30,
          durationMinutes: 6,
          litresPerMinute: 6,
        ),
      ]),
    );
  }
}

void main() {
  test('nothing is upcoming before the data has loaded', () {
    final vm = WaterControlsViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 9, 41),
    );

    expect(vm.upcomingCycles, isEmpty);
  });

  test('the next cycle follows the injected clock in the morning', () async {
    final vm = WaterControlsViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 9, 41),
    );
    await vm.load();

    expect(vm.upcomingCycles.first.cycle.zoneName, 'Zone B');
    expect(vm.upcomingCycles[1].cycle.zoneName, 'Zone A');
  });

  test('the next cycle changes as the day moves on', () async {
    final vm = WaterControlsViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 10, 45),
    );
    await vm.load();

    expect(vm.upcomingCycles.first.cycle.zoneName, 'Zone A');
  });
}
