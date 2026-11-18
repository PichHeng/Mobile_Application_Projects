import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/fake_dosing_repository.dart';
import 'package:demo1/features/resources/data/repositories/fake_resource_usage_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the two dosing pumps add up to the fertilizer used today', () async {
    final snapshot = await FakeDosingRepository().getSnapshot();
    final usage = await FakeResourceUsageRepository().getFertillizer(
      UsagePeriod.today,
    );

    final sum = snapshot.pumps.fold<double>(
      0,
      (s, p) => s + (p.usedTodayLitres ?? 0),
    );

    expect(sum, closeTo(usage.series.total, 0.0001));
  });

  test('each pump used 0.9 litres, as in the design', () async {
    final snapshot = await FakeDosingRepository().getSnapshot();

    expect(snapshot.pumps[0].usedTodayLitres, closeTo(0.9, 0.0001));
    expect(snapshot.pumps[1].usedTodayLitres, closeTo(0.9, 0.0001));
  });

  test('the flush pump is maintenance only and has no daily use', () async {
    final snapshot = await FakeDosingRepository().getSnapshot();
    final flush = snapshot.pumps.last;

    expect(flush.manualOnly, true);
    expect(flush.usedTodayLitres, isNull);
  });
}
