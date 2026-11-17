import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:flutter_test/flutter_test.dart';

WaterInputs _inputs({double litres = 620, double pressure = 2.1}) =>
    WaterInputs(
      reservoirLitres: litres,
      reservoirCapacityLitres: 1000,
      linePressureBar: pressure,
      flowLitresPerMin: 0,
    );

void main() {
  const limits = SafetyLimits();

  test('620 L in a 1000 L tank is 62 percent', () {
    expect(_inputs().reservoirPercent, 62);
  });

  test('a tank with no capacity is 0 percent', () {
    const broken = WaterInputs(
      reservoirLitres: 10,
      reservoirCapacityLitres: 0,
      linePressureBar: 1,
      flowLitresPerMin: 0,
    );
    expect(broken.reservoirPercent, 0);
  });

  test('normal readings have no blockers', () {
    expect(limits.blockers(_inputs()), isEmpty);
  });

  test('reservoir below 15 percent blocks', () {
    expect(limits.blockers(_inputs(litres: 149)), [SafetyBlock.reservoirLow]);
  });

  test('reservoir exactly at 15 percent does not block', () {
    expect(limits.blockers(_inputs(litres: 150)), isEmpty);
  });
  test('pressure above 3 bar block but exatly 3 does not', () {
    expect(limits.blockers(_inputs(pressure: 3.1)), [SafetyBlock.pressureHigh]);
  });

  test('both problems are reported together', () {
    expect(limits.blockers(_inputs(litres: 100, pressure: 3.5)), [
      SafetyBlock.reservoirLow,
      SafetyBlock.pressureHigh,
    ]);
  });
}
