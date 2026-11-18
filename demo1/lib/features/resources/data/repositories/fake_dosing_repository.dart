import 'package:demo1/features/greenhouse/data/mock/mock_fertilizer.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';

class FakeDosingRepository implements DosingRepository {
  static const double _doseA = 2;
  static const double _doseB = 2;

  @override
  Future<DosingSnapshot> getSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final total = mockFertillizerTodayHourly.fold<double>(0, (s, v) => s + v);
    const share = _doseA + _doseB;

    return DosingSnapshot(
      recipe: const FertilizerRecipe(
        name: 'Balanced growth',
        partA: DosingPart(
          letter: 'A',
          name: 'Calcium base',
          remainingLitres: 6.4,
          doseMlPerLitre: _doseA,
        ),
        partB: DosingPart(
          letter: 'B',
          name: 'NPK blend',
          remainingLitres: 6.0,
          doseMlPerLitre: _doseB,
        ),
        nextMix: DailyTime(12, 0),
        nextMixWaterLitres: 40,
      ),
      inputs: const DosingInputs(
        ec: RangedReading(value: 1.8, min: 1.6, max: 2.2),
        ph: RangedReading(value: 6.2, min: 5.8, max: 6.5),
        tankPercent: 72,
      ),
      pumps: [
        DosingPump(
          id: 'pump_a',
          title: 'Dosing pump A',
          code: 'OUT 05 · Calcium base',
          usedTodayLitres: total * _doseA / share,
        ),
        DosingPump(
          id: 'pump_b',
          title: 'Dosing pump B',
          code: 'OUT 06 · NPK blend',
          usedTodayLitres: total * _doseB / share,
        ),
        const DosingPump(
          id: 'flush',
          title: 'Flush pump',
          code: 'OUT 07 · Maintenance only',
          manualOnly: true,
        ),
      ],
      mixingPauseSeconds: 60,
      lastMix: const DailyTime(9, 10),
    );
  }
}
