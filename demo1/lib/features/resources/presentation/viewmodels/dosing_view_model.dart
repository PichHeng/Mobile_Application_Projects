import 'dart:async';

import 'package:demo1/core/utils/timed_run.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter/foundation.dart';

class DosingViewModel extends ChangeNotifier {
  DosingViewModel(
    this._repository, {
    this.limits = const DosingLimits(),
    this.primeLimit = const Duration(seconds: 10),
    Timer Function(Duration, void Function())? scheduler,
    DateTime Function()? clock,
  }) : _run = TimedRun(limit: primeLimit, scheduler: scheduler),
       _clock = clock ?? DateTime.now;

  final DosingRepository _repository;
  final TimedRun _run;
  final DateTime Function() _clock;
  final DosingLimits limits;
  final Duration primeLimit;

  DosingSnapshot? _snapshot;
  String? _selectedId;
  bool _isLoading = true;
  ReportError? _error;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  ReportError? get error => _error;
  FertilizerRecipe? get recipe => _snapshot?.recipe;
  DosingInputs? get inputs => _snapshot?.inputs;
  List<DosingPump> get pumps => _snapshot?.pumps ?? const [];
  int get mixingPauseSeconds => _snapshot?.mixingPauseSeconds ?? 0;
  DailyTime? get lastMix => _snapshot?.lastMix;

  bool get isRunning => _run.isRunning;
  String? get selectedPumpId => _selectedId;

  bool get isTankLow {
    final i = inputs;
    return i != null && limits.isTankLow(i);
  }

  /// មិនអាចបញ្ជាក់សុវត្ថិភាព ឬ interlock សកម្ម
  bool get isBlocked => _error != null || isTankLow;

  DateTime? get nextMixStart => recipe?.nextMix.nextOccurrence(_clock());

  bool get nextMixIsToday {
    final start = nextMixStart;
    if (start == null) return false;
    final now = _clock();
    return start.year == now.year &&
        start.month == now.month &&
        start.day == now.day;
  }

  DosingPump? _pumpById(String id) {
    for (final p in pumps) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// pump ថែទាំជា Manual ជានិច្ច។ pump ដូសជា Manual តែពេលត្រូវបានជ្រើស
  IrrigationMode modeOf(String id) {
    final pump = _pumpById(id);
    if (pump == null) return IrrigationMode.auto;
    return pump.manualOnly || id == _selectedId
        ? IrrigationMode.manual
        : IrrigationMode.auto;
  }

  bool isOn(String id) => isRunning && id == _selectedId;

  /// ជ្រើសបានតែ ១ pump ព្រោះ A និង B មិនត្រូវដំណើរការជាមួយគ្នា
  bool get canStartPrime =>
      !isRunning &&
      _error == null &&
      inputs != null &&
      !isTankLow &&
      _selectedId != null;

  void setMode(String id, IrrigationMode mode) {
    if (isRunning) return;
    final pump = _pumpById(id);
    if (pump == null) return;

    if (mode == IrrigationMode.manual) {
      _selectedId = id;
    } else {
      if (pump.manualOnly) return;
      if (_selectedId == id) _selectedId = null;
    }
    notifyListeners();
  }

  void startPrime() {
    if (!canStartPrime) return;
    _run.start(stopPrime);
    notifyListeners();
  }

  void stopPrime() {
    if (!_run.stop()) return;
    _selectedId = null; // ត្រឡប់ទៅ Auto
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _snapshot = await _repository.getSnapshot();
      if (isRunning && isTankLow) stopPrime();
    } catch (_) {
      _error = ReportError.network;
      // អានមិនបាន = មិនអាចបញ្ជាក់សុវត្ថិភាព ដូច្នេះឈប់
      if (isRunning) stopPrime();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
