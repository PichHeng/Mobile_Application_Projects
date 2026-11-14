import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';

class WaterViewModel extends PeriodReportViewModel<WaterReport> {
  WaterViewModel(ResourceUsageRepository repository)
    : super(repository.getWater);

  WaterReport? get report => data;
  UsageSeries? get series => data?.series;
}
