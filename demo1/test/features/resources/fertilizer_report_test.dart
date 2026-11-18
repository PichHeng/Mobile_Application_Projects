import 'package:demo1/features/resources/data/models/fertilizer_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

FertilizerReport _report(double used, double planned) => FertilizerReport(
  series: UsageSeries(points: [UsagePoint('x', used)], previousTotal: 0),
  plannedLitres: planned,
  mixPreparedLitres: 450,
);

void main() {
  test('using almost exactly the plan is on plan', () {
    expect(_report(1.9, 1.8).planStatus, PlanStatus.onPlan);
    expect(_report(1.8, 1.8).planStatus, PlanStatus.onPlan);
  });

  test('using clearly more than planned is over plan', () {
    expect(_report(2.4, 1.8).planStatus, PlanStatus.overPlan);
  });

  test('using clearly less than planned is under plan', () {
    expect(_report(1.2, 1.8).planStatus, PlanStatus.underPlan);
  });
  test('no plan and no use is on plan', () {
    expect(_report(0, 0).planStatus, PlanStatus.onPlan);
  });
  test('no plan but some use is over plan', () {
    expect(_report(1, 0).planStatus, PlanStatus.overPlan);
  });
}
