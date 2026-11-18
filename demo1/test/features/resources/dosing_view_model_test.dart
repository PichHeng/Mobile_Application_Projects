import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/repositories/dosing_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/dosing_view_model.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

DosingSnapshot _snapshot({double tank = 72}) => DosingSnapshot(
  recipe: const FertilizerRecipe(
    name: 'Balanced growth',
    partA: DosingPart(
      letter: 'A',
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
    ec: const RangedReading(value: 1.8, min: 1.6, max: 2.2),
    ph: const RangedReading(value: 6.2, min: 5.8, max: 6.5),
    tankPercent: tank,
  ),
);

class _Repository implements DosingRepository {
  _Repository({this.shouldFail = false, this.tank = 72});

  final bool shouldFail;
  final double tank;

  @override
  Future<DosingSnapshot> getSnapshot() async {
    if (shouldFail) throw Exception('offline');
    return _snapshot(tank: tank);
  }
}

void main() {
  test('nothing is known before the data has loaded', () {
    final vm = DosingViewModel(_Repository());

    expect(vm.recipe, isNull);
    expect(vm.nextMixStart, isNull);
    expect(vm.isTankLow, false);
  });

  test('load success fills the recipe and the inputs', () async {
    final vm = DosingViewModel(_Repository());

    await vm.load();

    expect(vm.recipe?.name, 'Balanced growth');
    expect(vm.inputs, isNotNull);
    expect(vm.error, isNull);
    expect(vm.isLoading, false);
  });

  test('load failure sets a network error and no data', () async {
    final vm = DosingViewModel(_Repository(shouldFail: true));

    await vm.load();

    expect(vm.recipe, isNull);
    expect(vm.error, ReportError.network);
    expect(vm.isLoading, false);
  });

  test('before noon the next mix is today at 12:00', () async {
    final vm = DosingViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 9, 41),
    );
    await vm.load();

    expect(vm.nextMixStart, DateTime(2026, 6, 12, 12, 0));
    expect(vm.nextMixIsToday, true);
  });

  test('after noon the next mix is tomorrow at 12:00', () async {
    final vm = DosingViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 13, 0),
    );
    await vm.load();

    expect(vm.nextMixStart, DateTime(2026, 6, 13, 12, 0));
    expect(vm.nextMixIsToday, false);
  });

  test('a low tank is reported by the view model', () async {
    final vm = DosingViewModel(_Repository(tank: 12));

    await vm.load();

    expect(vm.isTankLow, true);
  });
}
