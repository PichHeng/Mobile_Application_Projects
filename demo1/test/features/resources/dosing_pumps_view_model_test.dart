import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/dosing_view_model.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_scheduler.dart';

DosingSnapshot _snapshot({double tank = 72}) => DosingSnapshot(
  recipe: const FertilizerRecipe(
    name: 'Balanced growth',
    partA: DosingPart(
      letter: 'A',
      name: 'Calcium base',
      remainingLitres: 6.4,
      doseMlPerLitre: 2,
    ),
    partB: DosingPart(
      letter: 'B',
      name: 'NPK blend',
      remainingLitres: 6.0,
      doseMlPerLitre: 2,
    ),
    nextMix: DailyTime(12, 0),
    nextMixWaterLitres: 40,
  ),
  inputs: DosingInputs(
    ec: const RangedReading(value: 1.8, min: 1.6, max: 2.2),
    ph: const RangedReading(value: 6.2, min: 5.8, max: 6.5),
    tankPercent: tank,
  ),
  pumps: const [
    DosingPump(id: 'a', title: 'Pump A', code: 'OUT 05', usedTodayLitres: 0.9),
    DosingPump(id: 'b', title: 'Pump B', code: 'OUT 06', usedTodayLitres: 0.9),
    DosingPump(
      id: 'flush',
      title: 'Flush pump',
      code: 'OUT 07',
      manualOnly: true,
    ),
  ],
);

class _Repository implements DosingRepository {
  DosingSnapshot snapshot = _snapshot();
  bool shouldFail = false;

  @override
  Future<DosingSnapshot> getSnapshot() async {
    if (shouldFail) throw Exception('offline');
    return snapshot;
  }
}

Future<DosingViewModel> _ready(
  _Repository repo,
  FakeScheduler scheduler,
) async {
  final vm = DosingViewModel(repo, scheduler: scheduler.call);
  await vm.load();
  return vm;
}

void main() {
  late _Repository repo;
  late FakeScheduler scheduler;

  setUp(() {
    repo = _Repository();
    scheduler = FakeScheduler();
  });

  test('the pumps are loaded and nothing is selected at first', () async {
    final vm = await _ready(repo, scheduler);

    expect(vm.pumps, hasLength(3));
    expect(vm.selectedPumpId, isNull);
    expect(vm.canStartPrime, false);
  });

  test('choosing Manual on pump A selects only pump A', () async {
    final vm = await _ready(repo, scheduler);

    vm.setMode('a', IrrigationMode.manual);

    expect(vm.selectedPumpId, 'a');
    expect(vm.modeOf('a'), IrrigationMode.manual);
    expect(vm.modeOf('b'), IrrigationMode.auto);
    expect(vm.canStartPrime, true);
  });

  test('choosing Manual on B moves the selection away from A', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    vm.setMode('b', IrrigationMode.manual);

    expect(vm.selectedPumpId, 'b');
    expect(vm.modeOf('a'), IrrigationMode.auto);
  });

  test('choosing Auto on the selected pump clears the selection', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    vm.setMode('a', IrrigationMode.auto);

    expect(vm.selectedPumpId, isNull);
    expect(vm.canStartPrime, false);
  });

  test('the maintenance pump is always Manual and cannot go to Auto', () async {
    final vm = await _ready(repo, scheduler);

    vm.setMode('flush', IrrigationMode.auto);

    expect(vm.modeOf('flush'), IrrigationMode.manual);
    expect(vm.selectedPumpId, isNull);
  });

  test('the maintenance pump can still be selected to run', () async {
    final vm = await _ready(repo, scheduler);

    vm.setMode('flush', IrrigationMode.manual);

    expect(vm.selectedPumpId, 'flush');
    expect(vm.canStartPrime, true);
  });

  test('a prime switches on only the selected pump', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    vm.startPrime();

    expect(vm.isRunning, true);
    expect(vm.isOn('a'), true);
    expect(vm.isOn('b'), false);
    expect(vm.isOn('flush'), false);
  });

  test('a prime is limited to ten seconds', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    vm.startPrime();

    expect(scheduler.lastDuration, const Duration(seconds: 10));
  });

  test('when the time is up the pump stops and the selection clears', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    scheduler.fire!();

    expect(vm.isRunning, false);
    expect(vm.isOn('a'), false);
    expect(vm.selectedPumpId, isNull);
  });

  test('stopping early cancels the timer', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    vm.stopPrime();

    expect(scheduler.timer!.cancelled, true);
    expect(vm.isRunning, false);
  });

  test('the selection cannot change while a prime is running', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    vm.setMode('b', IrrigationMode.manual);

    expect(vm.selectedPumpId, 'a');
  });

  test('a low tank blocks the prime and never schedules a timer', () async {
    repo.snapshot = _snapshot(tank: 12);
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    vm.startPrime();

    expect(vm.isBlocked, true);
    expect(vm.isRunning, false);
    expect(scheduler.calls, 0);
  });

  test('a tank exactly at the limit does not block', () async {
    repo.snapshot = _snapshot(tank: 20);
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);

    expect(vm.isBlocked, false);
    expect(vm.canStartPrime, true);
  });

  test('the tank falling too low during a prime stops it', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    repo.snapshot = _snapshot(tank: 15);
    await vm.load();

    expect(vm.isRunning, false);
    expect(vm.isOn('a'), false);
    expect(scheduler.timer!.cancelled, true);
  });

  test('failing to read the sensors stops a prime and disables it', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    repo.shouldFail = true;
    await vm.load();

    expect(vm.error, ReportError.network);
    expect(vm.isRunning, false);

    vm.setMode('a', IrrigationMode.manual);
    expect(vm.canStartPrime, false);
  });

  test('disposing cancels a running timer', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('a', IrrigationMode.manual);
    vm.startPrime();

    vm.dispose();

    expect(scheduler.timer!.cancelled, true);
  });
}
