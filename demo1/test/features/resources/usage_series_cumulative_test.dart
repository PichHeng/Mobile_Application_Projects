import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const series = UsageSeries(
    points: [UsagePoint('a', 1), UsagePoint('b', 2), UsagePoint('c', 3)],
    previousTotal: 0,
  );

  test('cumulative points keep adding up', () {
    final values = series.cumulativePoints.map((p) => p.value).toList();
    expect(values, [1, 3, 6]);
  });
  test('cumulative points keep the original labels', () {
    final labels = series.cumulativePoints.map((p) => p.label).toList();
    expect(labels, ['a', 'b', 'c']);
  });
  test('the last cumulative value equals the total', () {
    expect(series.cumulativePoints.last.value, closeTo(series.total, 0.0001));
  });
  test('no points give no cumulative points', () {
    const empty = UsageSeries(points: [], previousTotal: 0);
    expect(empty.cumulativePoints, isEmpty);
  });
}
