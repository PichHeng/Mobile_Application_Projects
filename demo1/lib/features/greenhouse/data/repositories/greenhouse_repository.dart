import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';

abstract class GreenhouseRepository {
  Future<GreenhouseClimate> getClimate();
  Future<OverviewSummary> getOverview();
}
