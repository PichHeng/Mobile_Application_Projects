import 'dart:async';

import 'package:demo1/core/utils/timed_run.dart';
import 'package:demo1/features/resources/data/models/irrigation_schedule.dart';
import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/irrigation_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter/foundation.dart';

class WaterControlsViewModel extends ChangeNotifier {
  WaterControlsViewModel(
    this._repository, {
    this.limits = const SafetyLimits(),
    this.testLimit = const Duration(minutes: 2),
    Timer Function(Duration, void Function())? scheduler,
    DateTime Function()? clock,
  }) : _run = TimedRun(limit: testLimit, scheduler: scheduler),
       _clock = clock ?? DateTime.now;

  final IrrigationRepository _repository;
  final TimedRun _run;
  final DateTime Function() _clock;
  final SafetyLimits limits;
  final Duration testLimit;

  IrrigationSnapshot? _snapshot;
  final Map<String, IrrigationMode> _modes = {};
  bool _isLoading = true;
  ReportError? _error;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isRunning => _run.isRunning;
  ReportError? get error => _error;
  WaterInputs? get inputs => _snapshot?.inputs;
  List<OutputDef> get outputs => _snapshot?.outputs ?? const [];

  DateTime get now => _clock();

  List<UpcomingCycle> get upcomingCycles =>
      _snapshot?.schedule.upcoming(_clock()) ?? const [];

  IrrigationMode modeOf(String id) => _modes[id] ?? IrrigationMode.auto;

  /// បើកតែពេលតេស្តកំពុងដំណើរការ ហើយ output នោះជា Manual
  bool isOn(String id) => isRunning && modeOf(id) == IrrigationMode.manual;

  List<SafetyBlock> get blockers {
    final i = inputs;
    return i == null ? const [] : limits.blockers(i);
  }

  bool get hasManualOutputs =>
      outputs.any((o) => modeOf(o.id) == IrrigationMode.manual);

  /// មិនអាចចាប់ផ្តើមបាន ប្រសិនបើមិនអាចបញ្ជាក់សុវត្ថិភាព (error ឬគ្មានទិន្នន័យ)
  bool get canStartTest =>
      !isRunning &&
      _error == null &&
      inputs != null &&
      blockers.isEmpty &&
      hasManualOutputs;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _snapshot = await _repository.getSnapshot();
      if (isRunning && blockers.isNotEmpty) stopTest();
    } catch (_) {
      _error = ReportError.network;
      // អានមិនបាន = មិនអាចបញ្ជាក់សុវត្ថិភាព ដូច្នេះឈប់
      if (isRunning) stopTest();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setMode(String id, IrrigationMode mode) {
    if (isRunning) return;
    _modes[id] = mode;
    notifyListeners();
  }

  void startTest() {
    if (!canStartTest) return;
    _run.start(stopTest);
    notifyListeners();
  }

  void stopTest() {
    if (!_run.stop()) return;
    _modes.clear(); // ត្រឡប់ទៅ Auto
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _run.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
