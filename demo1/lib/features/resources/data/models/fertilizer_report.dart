import 'package:demo1/features/resources/data/models/usage_series.dart';

enum PlanStatus { onPlan, overPlan, underPlan }

class FertilizerReport {
  const FertilizerReport({
    required this.series,
    required this.plannedLitres,
    required this.mixPreparedLitres,
  });

  final UsageSeries series;

  /// ចំនួនដែលផែនការគ្រោងប្រើរហូតដល់ពេលនេះ
  final double plannedLitres;

  /// ទឹកលាយជីដែលបានរៀបចំ (បែងចែកជា A + B)
  final double mixPreparedLitres;

  static const double tolerance = 0.1;
  PlanStatus get planStatus {
    if (plannedLitres <= 0) {
      return series.total > 0 ? PlanStatus.overPlan : PlanStatus.onPlan;
    }
    final ratio = series.total / plannedLitres;
    if (ratio > 1 + tolerance) return PlanStatus.overPlan;
    if (ratio < 1 - tolerance) return PlanStatus.underPlan;
    return PlanStatus.onPlan;
  }
}
