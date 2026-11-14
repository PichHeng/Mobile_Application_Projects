import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/foundation.dart';

enum ReportError { network }

/// ViewModel ទូទៅសម្រាប់ទំព័រណាដែលមាន Today / 7 days / Month
/// T ជាប្រភេទរបាយការណ៍ (EnergyReport, WaterReport...)

class PeriodReportViewModel<T> extends ChangeNotifier {
  PeriodReportViewModel(this._fetch);

  final Future<T> Function(UsagePeriod period) _fetch;

  UsagePeriod _period = UsagePeriod.today;
  T? _data;
  bool _isLoading = true;
  ReportError? _error;
  bool _disposed = false;
  int _requestId = 0;

  UsagePeriod get period => _period;
  T? get data => _data;
  bool get isLoading => _isLoading;
  ReportError? get error => _error;

  Future<void> selectPeriod(UsagePeriod period) async {
    if (period == _period && _error == null) return;
    _period = period;
    _data = null;
    await load();
  }

  Future<void> load() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _fetch(_period);
      if (requestId != _requestId) return;
      _data = result;
    } catch (_) {
      if (requestId != _requestId) return;
      _error = ReportError.network;
    } finally {
      if (requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
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
