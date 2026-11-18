import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';

class FakeDosingRepository implements DosingRepository {
  @override
  Future<DosingSnapshot> getSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const DosingSnapshot(
      recipe: FertilizerRecipe(
        name: 'Balance growth',
        partA: DosingPart(
          letter: 'a',
          name: 'Calcium base',
          remainingLitres: 6.4,
          doseMlPerLitre: 2,
        ),
        partB: DosingPart(
          letter: 'B',
          name: 'NPK blend',
          remainingLitres: 6.0,
          doseMlPerLitre: 2,
        ),
        nextMix: DailyTime(12, 0),
        nextMixWaterLitres: 40,
      ),
      inputs: DosingInputs(
        ec: RangedReading(value: 1.8, min: 1.6, max: 2.2),
        ph: RangedReading(value: 6.2, min: 5.8, max: 6.5),
        tankPercent: 72,
      ),
    );
  }
}
