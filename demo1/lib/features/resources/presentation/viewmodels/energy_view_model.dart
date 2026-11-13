import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:flutter/foundation.dart';

enum EnergyError { network }

class EnergyViewModel extends ChangeNotifier {
  EnergyViewModel(this._repository);

  final ResourceUsageRepository _repository;

  UsagePeriod _period = UsagePeriod.today;
  UsageSeries? _series;
  bool _isLoading = true;
  EnergyError? _error;
  bool _disposed = false;
  int _requestId = 0;

  UsagePeriod get period => _period;
  UsageSeries? get series => _series;
  bool get isLoading => _isLoading;
  EnergyError? get error => _error;

  Future<void> selectPeriod(UsagePeriod period) async {
    if (period == _period && _error == null) return;
    _period = period;
    _series = null; // កុំបង្ហាញទិន្នន័យរបស់រយៈពេលមុនក្រោមផ្ទាំងថ្មី
    await load();
  }

  Future<void> load() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getEnergy(_period);
      if (requestId != _requestId) return; // ចម្លើយចាស់ មិនយកទេ
      _series = result;
    } catch (_) {
      if (requestId != _requestId) return;
      _error = EnergyError.network;
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
