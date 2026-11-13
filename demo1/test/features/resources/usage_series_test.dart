import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('total adds all points', () {
    const series = UsageSeries(
      points: [UsagePoint('a', 1.5), UsagePoint('b', 2.5)],
      previousTotal: 0,
    );

    expect(series.total, closeTo(4.0, 0.0001));
  });

  test('change is relative to the previous total', () {
    const series = UsageSeries(
      points: [UsagePoint('a', 90)],
      previousTotal: 100,
    );

    expect(series.changeVsPrevious, closeTo(-0.1, 0.0001));
  });

  test('change is 0 when the previous total is 0', () {
    const series = UsageSeries(points: [UsagePoint('a', 90)], previousTotal: 0);

    expect(series.changeVsPrevious, 0);
  });

  test('budget remaining is null without a budget', () {
    const noBudget = UsageSeries(
      points: [UsagePoint('a', 18.4)],
      previousTotal: 20,
    );
    const withBudget = UsageSeries(
      points: [UsagePoint('a', 18.4)],
      previousTotal: 20,
      budget: 22,
    );

    expect(noBudget.budgetRemaining, isNull);
    expect(withBudget.budgetRemaining, closeTo(3.6, 0.0001));
  });

  test('isWithinBudget includes the limit itself', () {
    const exactly = UsageSeries(
      points: [UsagePoint('a', 22)],
      previousTotal: 20,
      budget: 22,
    );
    const over = UsageSeries(
      points: [UsagePoint('a', 22.1)],
      previousTotal: 20,
      budget: 22,
    );

    expect(exactly.isWithinBudget, true);
    expect(over.isWithinBudget, false);
  });
}
