import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter/foundation.dart';

class ClimateViewModel extends ChangeNotifier {
  ClimateViewModel(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final ClimateRepository _repository;
  final DateTime Function() _clock;

  ClimateToday? _today;
  bool _isLoading = true;
  ReportError? _error;
  bool _disposed = false;

  ClimateToday? get today => _today;
  bool get isLoading => _isLoading;
  ReportError? get error => _error;
  DateTime get now => _clock();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _today = await _repository.getToday();
    } catch (_) {
      _error = ReportError.network;
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
