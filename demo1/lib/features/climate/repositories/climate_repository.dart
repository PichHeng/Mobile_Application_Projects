import 'package:demo1/features/climate/data/models/climate_trend.dart';

abstract class ClimateRepository {
  Future<ClimateToday> getToday();
}
