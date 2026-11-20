import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';

class ClimateChartViewModel extends PeriodReportViewModel<ClimateSeries> {
  ClimateChartViewModel(this._repository);

  final ClimateRepository _repository;
  ClimateMetric _metric = ClimateMetric.temperature;
  ClimateMetric get metric => _metric;
  ClimateSeries? get series => data;

  @override
  Future<ClimateSeries> fetch(UsagePeriod period) =>
      _repository.getSeries(_metric, period);

  Future<void> selectMetric(ClimateMetric metric) async {
    if (metric == _metric && error == null) return;
    _metric = metric;
    await refresh();
  }
}
