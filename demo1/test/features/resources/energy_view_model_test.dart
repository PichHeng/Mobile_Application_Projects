import 'dart:async';

import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/energy_view_model.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

EnergyReport _reportWith(double value) => EnergyReport(
  series: UsageSeries(points: [UsagePoint('x', value)], previousTotal: 10),
  ratePerKwh: 0.18,
  consumers: const [],
);

class _StubRepository implements ResourceUsageRepository {
  _StubRepository({this.shouldFail = false, this.manual = false});

  final bool shouldFail;
  final bool manual;
  final Map<UsagePeriod, Completer<EnergyReport>> completers = {};
  int calls = 0;

  @override
  Future<EnergyReport> getEnergy(UsagePeriod period) {
    calls++;
    if (manual) {
      final completer = Completer<EnergyReport>();
      completers[period] = completer;
      return completer.future;
    }
    if (shouldFail) return Future.error(Exception('offline'));
    return Future.value(_reportWith(period.index + 1.0));
  }

  @override
  Future<WaterReport> getWater(UsagePeriod period) =>
      throw UnimplementedError('not used in these tests');
}

void main() {
  test('load success fills the report and stops loading', () async {
    final vm = EnergyViewModel(_StubRepository());
    await vm.load();
    expect(vm.report, isNotNull);
    expect(vm.series, isNotNull);
    expect(vm.error, isNull);
    expect(vm.isLoading, false);
    expect(vm.period, UsagePeriod.today);
  });

  test('load failure sets a network error and no report', () async {
    final vm = EnergyViewModel(_StubRepository(shouldFail: true));

    await vm.load();

    expect(vm.report, isNull);
    expect(vm.error, ReportError.network);
    expect(vm.isLoading, false);
  });

  test('selectPeriod switches period and loads new data', () async {
    final vm = EnergyViewModel(_StubRepository());
    await vm.load();
    await vm.selectPeriod(UsagePeriod.week);
    expect(vm.period, UsagePeriod.week);
    expect(vm.series?.total, closeTo(2.0, 0.0001));
  });

  test('selecting the current period does not reload', () async {
    final repo = _StubRepository();
    final vm = EnergyViewModel(repo);
    await vm.load();
    await vm.selectPeriod(UsagePeriod.today);
    expect(repo.calls, 1);
  });

  test('a stale repsonse never overwrites a newers one', () async {
    final repo = _StubRepository(manual: true);
    final vm = EnergyViewModel(repo);

    final weekRequest = vm.selectPeriod(UsagePeriod.week);
    final monthRequest = vm.selectPeriod(UsagePeriod.month);

    repo.completers[UsagePeriod.month]!.complete(_reportWith(30));
    repo.completers[UsagePeriod.week]!.complete(_reportWith(7));
    await Future.wait([weekRequest, monthRequest]);

    expect(vm.period, UsagePeriod.month);
    expect(vm.series?.total, closeTo(30, 0.0001));
    expect(vm.isLoading, false);
  });
}
