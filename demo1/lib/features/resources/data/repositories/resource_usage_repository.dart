import 'package:demo1/features/resources/data/models/usage_series.dart';

abstract class ResourceUsageRepository {
  Future<UsageSeries> getEnergy(UsagePeriod peroid);
}
