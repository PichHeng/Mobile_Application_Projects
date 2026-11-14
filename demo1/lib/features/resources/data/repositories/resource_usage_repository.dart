import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';

abstract class ResourceUsageRepository {
  Future<EnergyReport> getEnergy(UsagePeriod period);
  Future<WaterReport> getWater(UsagePeriod period);
}
