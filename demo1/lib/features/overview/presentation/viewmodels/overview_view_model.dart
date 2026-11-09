import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:demo1/features/greenhouse/data/repositories/greenhouse_repository.dart';
import 'package:flutter/foundation.dart';

enum DayPart { morning, afternoon, evening }

enum OverviewError { network }

class OverviewViewModel extends ChangeNotifier {
  OverviewViewModel(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final GreenhouseRepository _repository;
  final DateTime Function() _clock;

  bool _isLoading = true;
  bool _disposed = false;
  GreenhouseClimate? _climate;
  OverviewSummary? _summary;
  OverviewError? _error;

  bool get isLoading => _isLoading;
  GreenhouseClimate? get climate => _climate;
  OverviewSummary? get summary => _summary;
  OverviewError? get error => _error;
  bool get hasData => _climate != null && _summary != null;

  DateTime get today => _clock();

  DayPart get dayPart {
    final hour = _clock().hour;
    if (hour < 12) return DayPart.morning;
    if (hour < 17) return DayPart.afternoon;
    return DayPart.evening;
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait<Object>([
        _repository.getClimate(),
        _repository.getOverview(),
      ]);
      _climate = results[0] as GreenhouseClimate;
      _summary = results[1] as OverviewSummary;
    } catch (_) {
      _error = OverviewError.network;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
