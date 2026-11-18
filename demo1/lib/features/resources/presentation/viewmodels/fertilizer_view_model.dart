import 'package:demo1/features/resources/data/models/fertilizer_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';

class FertilizerViewModel extends PeriodReportViewModel<FertilizerReport> {
  FertilizerViewModel(ResourceUsageRepository repository)
    : super(repository.getFertillizer);

  FertilizerReport? get report => data;
  UsageSeries? get series => data?.series;
}
