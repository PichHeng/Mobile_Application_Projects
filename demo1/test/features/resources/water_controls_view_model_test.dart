import 'dart:async';

import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/irrigation_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_controls_view_model.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

IrrigationSnapshot _snapshot({double litres = 620, double pressure = 2.1}) {
  return IrrigationSnapshot(
    inputs: WaterInputs(
      reservoirLitres: litres,
      reservoirCapacityLitres: 1000,
      linePressureBar: pressure,
      flowLitresPerMin: 0,
    ),
    outputs: const [
      OutputDef(id: 'pump', title: 'Pump', code: 'OUT 01'),
      OutputDef(id: 'valve', title: 'Valve', code: 'OUT 03'),
    ],
  );
}

class _StubRepository implements IrrigationRepository {
  IrrigationSnapshot snapshot = _snapshot();
  bool shouldFail = false;

  @override
  Future<IrrigationSnapshot> getSnapshot() async {
    if (shouldFail) throw Exception('offline');
    return snapshot;
  }
}

class _FakeTimer implements Timer {
  bool cancelled = false;

  @override
  void cancel() => cancelled = true;

  @override
  bool get isActive => !cancelled;

  @override
  int get tick => 0;
}

class _Scheduler {
  int calls = 0;
  Duration? lastDuration;
  void Function()? fire;
  _FakeTimer? timer;

  Timer call(Duration duration, void Function() callback) {
    calls++;
    lastDuration = duration;
    fire = callback;
    return timer = _FakeTimer();
  }
}

Future<WaterControlsViewModel> _ready(
  _StubRepository repo,
  _Scheduler scheduler,
) async {
  final vm = WaterControlsViewModel(repo, scheduler: scheduler.call);
  await vm.load();
  return vm;
}

void main() {
  late _StubRepository repo;
  late _Scheduler scheduler;

  setUp(() {
    repo = _StubRepository();
    scheduler = _Scheduler();
  });

  test(
    'load fills inputs and outputs but cannot start without Manual',
    () async {
      final vm = await _ready(repo, scheduler);

      expect(vm.inputs, isNotNull);
      expect(vm.outputs, hasLength(2));
      expect(vm.canStartTest, false);
      expect(vm.error, isNull);
    },
  );

  test('choosing Manual on one output allows a test', () async {
    final vm = await _ready(repo, scheduler);

    vm.setMode('pump', IrrigationMode.manual);

    expect(vm.hasManualOutputs, true);
    expect(vm.canStartTest, true);
  });

  test('a test switches on only the Manual outputs', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);

    vm.startTest();

    expect(vm.isRunning, true);
    expect(vm.isOn('pump'), true);
    expect(vm.isOn('valve'), false);
  });

  test('the test is limited to two minutes', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);

    vm.startTest();

    expect(scheduler.lastDuration, const Duration(minutes: 2));
  });

  test(
    'when the time limit fires everything returns to Auto and off',
    () async {
      final vm = await _ready(repo, scheduler);
      vm.setMode('pump', IrrigationMode.manual);
      vm.startTest();

      scheduler.fire!();

      expect(vm.isRunning, false);
      expect(vm.isOn('pump'), false);
      expect(vm.modeOf('pump'), IrrigationMode.auto);
    },
  );

  test('stopping early cancels the timer and returns to Auto', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);
    vm.startTest();

    vm.stopTest();

    expect(scheduler.timer!.cancelled, true);
    expect(vm.isRunning, false);
    expect(vm.modeOf('pump'), IrrigationMode.auto);
  });

  test('the mode cannot change while a test is running', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);
    vm.startTest();

    vm.setMode('valve', IrrigationMode.manual);

    expect(vm.modeOf('valve'), IrrigationMode.auto);
  });

  test('a low reservoir blocks the test', () async {
    repo.snapshot = _snapshot(litres: 120);
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);

    expect(vm.blockers, [SafetyBlock.reservoirLow]);
    expect(vm.canStartTest, false);
  });

  test('high pressure blocks the test', () async {
    repo.snapshot = _snapshot(pressure: 3.4);
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);

    expect(vm.blockers, [SafetyBlock.pressureHigh]);
    expect(vm.canStartTest, false);
  });

  test('a blocked test never schedules a timer', () async {
    repo.snapshot = _snapshot(litres: 120);
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);

    vm.startTest();

    expect(vm.isRunning, false);
    expect(scheduler.calls, 0);
  });

  test('sensors turning unsafe during a test stops it', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);
    vm.startTest();

    repo.snapshot = _snapshot(pressure: 3.6);
    await vm.load();

    expect(vm.isRunning, false);
    expect(vm.isOn('pump'), false);
    expect(scheduler.timer!.cancelled, true);
  });

  test(
    'failing to read sensors stops a running test and disables controls',
    () async {
      final vm = await _ready(repo, scheduler);
      vm.setMode('pump', IrrigationMode.manual);
      vm.startTest();

      repo.shouldFail = true;
      await vm.load();

      expect(vm.error, ReportError.network);
      expect(vm.isRunning, false);

      vm.setMode('pump', IrrigationMode.manual);
      expect(vm.canStartTest, false);
    },
  );

  test('disposing cancels a running timer', () async {
    final vm = await _ready(repo, scheduler);
    vm.setMode('pump', IrrigationMode.manual);
    vm.startTest();

    vm.dispose();

    expect(scheduler.timer!.cancelled, true);
  });
}
