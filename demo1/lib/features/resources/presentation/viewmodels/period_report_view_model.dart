import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/foundation.dart';

enum ReportError { network }

/// ViewModel ទូទៅសម្រាប់ទំព័រណាដែលមាន Today / 7 days / Month
/// T ជាប្រភេទទិន្នន័យ (EnergyReport, WaterReport, ClimateSeries...)
class PeriodReportViewModel<T> extends ChangeNotifier {
  PeriodReportViewModel([Future<T> Function(UsagePeriod period)? fetch])
    : _fetch = fetch;

  final Future<T> Function(UsagePeriod period)? _fetch;

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

  /// subclass អាច override ដើម្បីប្រើស្ថានភាពបន្ថែម (ឧ. metric)
  @protected
  Future<T> fetch(UsagePeriod period) {
    final f = _fetch;
    if (f == null) {
      throw UnimplementedError('Pass a fetch function or override fetch()');
    }
    return f(period);
  }

  /// លុបទិន្នន័យចាស់ ហើយផ្ទុកថ្មី
  @protected
  Future<void> refresh() async {
    _data = null;
    await load();
  }

  Future<void> selectPeriod(UsagePeriod period) async {
    if (period == _period && _error == null) return;
    _period = period;
    await refresh();
  }

  Future<void> load() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await fetch(_period);
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
