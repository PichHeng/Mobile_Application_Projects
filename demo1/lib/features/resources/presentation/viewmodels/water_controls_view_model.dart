import 'dart:async';

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
  }) : _schedule = scheduler ?? Timer.new;

  final IrrigationRepository _repository;
  final Timer Function(Duration, void Function()) _schedule;
  final SafetyLimits limits;
  final Duration testLimit;

  IrrigationSnapshot? _snapshot;
  final Map<String, IrrigationMode> _modes = {};
  bool _isRunning = false;
  bool _isLoading = true;
  ReportError? _error;
  Timer? _timer;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isRunning => _isRunning;
  ReportError? get error => _error;
  WaterInputs? get inputs => _snapshot?.inputs;
  List<OutputDef> get outputs => _snapshot?.outputs ?? const [];

  IrrigationMode modeOf(String id) => _modes[id] ?? IrrigationMode.auto;

  /// បើកតែពេលតេស្តកំពុងដំណើរការ ហើយ output នោះជា Manual
  bool isOn(String id) => _isRunning && modeOf(id) == IrrigationMode.manual;

  List<SafetyBlock> get blockers {
    final i = inputs;
    return i == null ? const [] : limits.blockers(i);
  }

  bool get hasManualOutputs =>
      outputs.any((o) => modeOf(o.id) == IrrigationMode.manual);

  /// មិនអាចចាប់ផ្តើមបាន ប្រសិនបើមិនអាចបញ្ជាក់សុវត្ថិភាព (error ឬគ្មានទិន្នន័យ)
  bool get canStartTest =>
      !_isRunning &&
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
      if (_isRunning && blockers.isNotEmpty) stopTest();
    } catch (_) {
      _error = ReportError.network;
      // អានមិនបាន = មិនអាចបញ្ជាក់សុវត្ថិភាព ដូច្នេះឈប់
      if (_isRunning) stopTest();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setMode(String id, IrrigationMode mode) {
    if (_isRunning) return;
    _modes[id] = mode;
    notifyListeners();
  }

  void startTest() {
    if (!canStartTest) return;
    _isRunning = true;
    _timer = _schedule(testLimit, stopTest);
    notifyListeners();
  }

  void stopTest() {
    _timer?.cancel();
    _timer = null;
    if (!_isRunning) return;
    _isRunning = false;
    _modes.clear(); // ត្រឡប់ទៅ Auto
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
