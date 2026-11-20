import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/climate/presentation/viewmodels/climate_view_model.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/presentation/viewmodels/period_report_view_model.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements ClimateRepository {
  _Repository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<ClimateToday> getToday() async {
    if (shouldFail) throw Exception('offline');
    return const ClimateToday(
      sampleIntervalMinutes: 5,
      trends: [
        ClimateTrend(
          metric: ClimateMetric.temperature,
          reading: RangedReading(value: 24.6, min: 22, max: 26),
          samples: [ClimateSample(0, 22.4), ClimateSample(581, 24.6)],
        ),
      ],
    );
  }

  @override
  Future<ClimateSeries> getSeries(ClimateMetric metric, UsagePeriod period) =>
      throw UnimplementedError('not used in these test');
}

void main() {
  test('nothing is known before the data has loaded', () {
    final vm = ClimateViewModel(_Repository());

    expect(vm.today, isNull);
    expect(vm.isLoading, true);
  });

  test('load success fills the data and stops loading', () async {
    final vm = ClimateViewModel(_Repository());

    await vm.load();

    expect(vm.today, isNotNull);
    expect(vm.error, isNull);
    expect(vm.isLoading, false);
  });

  test('load failure sets a network error and no data', () async {
    final vm = ClimateViewModel(_Repository(shouldFail: true));

    await vm.load();

    expect(vm.today, isNull);
    expect(vm.error, ReportError.network);
    expect(vm.isLoading, false);
  });

  test('now follows the injected clock', () {
    final vm = ClimateViewModel(
      _Repository(),
      clock: () => DateTime(2026, 6, 12, 9, 41),
    );

    expect(vm.now, DateTime(2026, 6, 12, 9, 41));
  });
}
