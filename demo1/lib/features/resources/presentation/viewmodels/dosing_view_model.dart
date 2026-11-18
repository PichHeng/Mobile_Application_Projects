import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter/foundation.dart';

class DosingViewModel extends ChangeNotifier {
  DosingViewModel(
    this._repository, {
    this.limits = const DosingLimits(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DosingRepository _repository;
  final DateTime Function() _clock;
  final DosingLimits limits;

  DosingSnapshot? _snapshot;
  bool _isLoading = true;
  ReportError? _error;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  ReportError? get error => _error;
  FertilizerRecipe? get recipe => _snapshot?.recipe;
  DosingInputs? get inputs => _snapshot?.inputs;

  bool get isTankLow {
    final i = inputs;
    return i != null && limits.isTankLow(i);
  }

  DateTime? get nextMixStart => recipe?.nextMix.nextOccurrence(_clock());

  bool get nextMixIsToday {
    final start = nextMixStart;
    if (start == null) return false;
    final now = _clock();
    return start.year == now.year &&
        start.month == now.month &&
        start.day == now.day;
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _snapshot = await _repository.getSnapshot();
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
