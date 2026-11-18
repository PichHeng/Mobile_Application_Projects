import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';

DosingPart _part(double dose) => DosingPart(
  letter: 'A',
  name: 'Test',
  remainingLitres: 5,
  doseMlPerLitre: dose,
);

FertilizerRecipe _recipe(double doseA, double doseB) => FertilizerRecipe(
  name: 'Test',
  partA: _part(doseA),
  partB: _part(doseB),
  nextMix: const DailyTime(12, 0),
  nextMixWaterLitres: 40,
);

DosingInputs _inputs(double tank) => DosingInputs(
  ec: const RangedReading(value: 1.8, min: 1.6, max: 2.2),
  ph: const RangedReading(value: 6.2, min: 5.8, max: 6.5),
  tankPercent: tank,
);

void main() {
  test('2 + 2 mL per litre over 40 litres is 160 mL', () {
    expect(_recipe(2, 2).nextMixConcentrateMl, closeTo(160, 0.0001));
  });

  test('equal doses make an even 1:1 mix', () {
    expect(_recipe(2, 2).isEvenMix, true);
    expect(_recipe(2, 3).isEvenMix, false);
  });

  test('the tank is low only below the limit', () {
    const limits = DosingLimits();

    expect(limits.isTankLow(_inputs(19.9)), true);
    expect(limits.isTankLow(_inputs(20)), false);
    expect(limits.isTankLow(_inputs(72)), false);
  });

  test('the design readings are inside their targets', () {
    final inputs = _inputs(72);

    expect(inputs.ec.isInRange, true);
    expect(inputs.ph.isInRange, true);
  });
}
