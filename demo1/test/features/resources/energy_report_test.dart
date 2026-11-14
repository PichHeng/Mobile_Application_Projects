import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = EnergyReport(
  series: UsageSeries(
    points: [UsagePoint('a', 18.4)],
    previousTotal: 20.9,
    budget: 22,
  ),
  ratePerKwh: 0.18,
  consumers: [
    EnergyConsumer(kind: ConsumerKind.growLights, detail: '', kwh: 10.8),
    EnergyConsumer(kind: ConsumerKind.ventilation, detail: '', kwh: 4.2),
    EnergyConsumer(kind: ConsumerKind.irrigation, detail: '', kwh: 2.1),
    EnergyConsumer(kind: ConsumerKind.climateControl, detail: '', kwh: 1.3),
  ],
);

void main() {
  test('estimated cost is total times the rate', () {
    expect(_today.estimatedCost, closeTo(3.312, 0.0001));
  });

  test('saved kWh is previous minus current', () {
    expect(_today.savedKwh, closeTo(2.5, 0.0001));
  });

  test('saved kWh is negative when usage grew', () {
    const report = EnergyReport(
      series: UsageSeries(points: [UsagePoint('a', 25)], previousTotal: 20),
      ratePerKwh: 0.18,
      consumers: [],
    );

    expect(report.savedKwh, closeTo(-5, 0.0001));
  });

  test('consumers add up to the design total of 18.4', () {
    expect(_today.consumersTotal, closeTo(18.4, 0.0001));
  });

  test('grow lights are 59 percent of the total', () {
    expect(_today.sharePercent(_today.consumers.first), 59);
  });

  test('the four shares add up to 100', () {
    final sum = _today.consumers
        .map(_today.sharePercent)
        .fold<int>(0, (a, b) => a + b);

    expect(sum, 100);
  });

  test('share is 0 when there are no consumers', () {
    const empty = EnergyReport(
      series: UsageSeries(points: [], previousTotal: 0),
      ratePerKwh: 0.18,
      consumers: [],
    );
    const lone = EnergyConsumer(
      kind: ConsumerKind.growLights,
      detail: '',
      kwh: 5,
    );

    expect(empty.sharePercent(lone), 0);
  });
}
