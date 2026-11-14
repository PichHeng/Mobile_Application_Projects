import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';

class EnergyViewModel extends PeriodReportViewModel<EnergyReport> {
  EnergyViewModel(ResourceUsageRepository repository)
    : super(repository.getEnergy);

  EnergyReport? get report => data;
  UsageSeries? get series => data?.series;
}
