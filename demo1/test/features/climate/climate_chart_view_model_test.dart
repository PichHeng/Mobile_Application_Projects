import 'dart:async';

import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/climate/presentation/viewmodels/climate_chart_view_model.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

ClimateSeries _series(ClimateMetric metric, UsagePeriod period) =>
    ClimateSeries(
      metric: metric,
      period: period,
      reading: const RangedReading(value: 1, min: 0, max: 2),
      points: const [ChartPoint(0, 1)],
    );

class _Repository implements ClimateRepository {
  _Repository({this.shouldFail = false, this.manual = false});

  final bool shouldFail;
  final bool manual;
  final Map<String, Completer<ClimateSeries>> completers = {};
  int calls = 0;

  static String key(ClimateMetric m, UsagePeriod p) => '${m.name}-${p.name}';

  @override
  Future<ClimateSeries> getSeries(ClimateMetric metric, UsagePeriod period) {
    calls++;
    if (manual) {
      final completer = Completer<ClimateSeries>();
      completers[key(metric, period)] = completer;
      return completer.future;
    }
    if (shouldFail) return Future.error(Exception('offline'));
    return Future.value(_series(metric, period));
  }

  @override
  Future<ClimateToday> getToday() =>
      throw UnimplementedError('not used in these tests');
}

void main() {
  test('it starts on temperature and today', () async {
    final vm = ClimateChartViewModel(_Repository());

    await vm.load();

    expect(vm.metric, ClimateMetric.temperature);
    expect(vm.period, UsagePeriod.today);
    expect(vm.series?.metric, ClimateMetric.temperature);
    expect(vm.isLoading, false);
  });

  test('choosing a metric loads that metric and keeps the period', () async {
    final vm = ClimateChartViewModel(_Repository());
    await vm.load();
    await vm.selectPeriod(UsagePeriod.week);

    await vm.selectMetric(ClimateMetric.humidity);

    expect(vm.metric, ClimateMetric.humidity);
    expect(vm.period, UsagePeriod.week);
    expect(vm.series?.metric, ClimateMetric.humidity);
    expect(vm.series?.period, UsagePeriod.week);
  });

  test('choosing a period keeps the metric', () async {
    final vm = ClimateChartViewModel(_Repository());
    await vm.load();
    await vm.selectMetric(ClimateMetric.co2);

    await vm.selectPeriod(UsagePeriod.month);

    expect(vm.metric, ClimateMetric.co2);
    expect(vm.series?.period, UsagePeriod.month);
  });

  test('choosing the current metric does not reload', () async {
    final repo = _Repository();
    final vm = ClimateChartViewModel(repo);
    await vm.load();

    await vm.selectMetric(ClimateMetric.temperature);

    expect(repo.calls, 1);
  });

  test('a stale response never overwrites a newer metric', () async {
    final repo = _Repository(manual: true);
    final vm = ClimateChartViewModel(repo);

    final first = vm.selectMetric(ClimateMetric.humidity);
    final second = vm.selectMetric(ClimateMetric.co2);

    // ចម្លើយ co2 (ថ្មី) មកដល់មុន ហើយ humidity (ចាស់) មកដល់ក្រោយ
    repo.completers[_Repository.key(ClimateMetric.co2, UsagePeriod.today)]!
        .complete(_series(ClimateMetric.co2, UsagePeriod.today));
    repo.completers[_Repository.key(ClimateMetric.humidity, UsagePeriod.today)]!
        .complete(_series(ClimateMetric.humidity, UsagePeriod.today));
    await Future.wait([first, second]);

    expect(vm.metric, ClimateMetric.co2);
    expect(vm.series?.metric, ClimateMetric.co2);
    expect(vm.isLoading, false);
  });

  test('a failure sets a network error and no series', () async {
    final vm = ClimateChartViewModel(_Repository(shouldFail: true));

    await vm.load();

    expect(vm.series, isNull);
    expect(vm.error, ReportError.network);
    expect(vm.isLoading, false);
  });
}
