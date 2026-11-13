import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('total adds all three groups', () {
    const health = PlantHealthSummary(healthy: 114, watch: 8, attention: 2);

    expect(health.total, 124);
  });

  test('healthyPercent rounds 114 of 124 to 92', () {
    const health = PlantHealthSummary(healthy: 114, watch: 8, attention: 2);

    expect(health.healthyPercent, 92);
  });

  test('healthyPercent is 0 when there are no plants', () {
    const health = PlantHealthSummary(healthy: 0, watch: 0, attention: 0);

    expect(health.healthyPercent, 0);
  });
}
