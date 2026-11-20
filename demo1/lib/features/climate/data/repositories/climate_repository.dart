import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';

abstract class ClimateRepository {
  Future<ClimateToday> getToday();
  Future<ClimateSeries> getSeries(ClimateMetric metric, UsagePeriod period);
}
