import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_climate.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
  
class FakeClimateRepository implements ClimateRepository {
  static const int _intervalMinutes = 5;
  static const int _nowMinute = 581; // 09:41

  // មធ្យមប្រចាំថ្ងៃ និងភាពប្រែប្រួល សម្រាប់ទិន្នន័យ 7 ថ្ងៃ និង 30 ថ្ងៃ
  static const Map<ClimateMetric, double> _base = {
    ClimateMetric.temperature: 23.6,
    ClimateMetric.humidity: 66,
    ClimateMetric.light: 400,
    ClimateMetric.co2: 800,
  };
  static const Map<ClimateMetric, double> _spread = {
    ClimateMetric.temperature: 0.2,
    ClimateMetric.humidity: 1,
    ClimateMetric.light: 12,
    ClimateMetric.co2: 9,
  };

  @override
  Future<ClimateToday> getToday() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return ClimateToday(
      sampleIntervalMinutes: _intervalMinutes,
      trends: _todayTrends(),
      // មធ្យម: 24.57 °C ≈ 24.6 និង 68 % RH ត្រូវនឹង greenhouse ទាំងមូល
      zones: const [
        ClimateZone(
          letter: 'A',
          name: 'Leafy greens',
          temperature: 24.2,
          humidity: 70,
        ),
        ClimateZone(
          letter: 'B',
          name: 'Tomatoes',
          temperature: 25.4,
          humidity: 65,
        ),
        ClimateZone(
          letter: 'C',
          name: 'Herbs',
          temperature: 24.1,
          humidity: 69,
        ),
      ],
      ventilationAuto: true,
    );
  }

  @override
  Future<ClimateSeries> getSeries(
    ClimateMetric metric,
    UsagePeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final trend = _todayTrends().firstWhere((t) => t.metric == metric);
    final points = switch (period) {
      UsagePeriod.today => [
        for (final s in trend.samples) ChartPoint(s.minute.toDouble(), s.value),
      ],
      UsagePeriod.week => _history(metric, trend, 7),
      UsagePeriod.month => _history(metric, trend, 30),
    };

    return ClimateSeries(
      metric: metric,
      period: period,
      reading: trend.reading,
      points: points,
    );
  }

  /// ថ្ងៃមុនៗ: មធ្យម ± ភាពប្រែប្រួលកំណត់ជាមុន។ ថ្ងៃចុងក្រោយ = តម្លៃបច្ចុប្បន្ន
  List<ChartPoint> _history(
    ClimateMetric metric,
    ClimateTrend trend,
    int count,
  ) {
    final base = _base[metric]!;
    final spread = _spread[metric]!;

    return [
      for (var i = 0; i < count - 1; i++)
        ChartPoint(i.toDouble(), base + (((i * 7) % 11) - 5) * spread),
      ChartPoint((count - 1).toDouble(), trend.reading.value),
    ];
  }

  List<ClimateTrend> _todayTrends() {
    // សំណាកគ្រប់ ៥ នាទី ពី 00:00 ដល់ 09:40 ហើយសំណាកចុងក្រោយនៅ 09:41
    final minutes = [
      for (var m = 0; m <= 580; m += _intervalMinutes) m,
      _nowMinute,
    ];

    ClimateTrend trend(
      ClimateMetric metric,
      RangedReading reading,
      List<(int, double)> anchors,
    ) {
      return ClimateTrend(
        metric: metric,
        reading: reading,
        samples: [
          for (final m in minutes) ClimateSample(m, _interpolate(anchors, m)),
        ],
      );
    }

    // ចំណុចយុថ្កាចុងក្រោយប្រើតម្លៃបច្ចុប្បន្នពី mock តែមួយ
    // ដូច្នេះបន្ទាត់ចប់ត្រង់លេខធំជានិច្ច
    return [
      trend(ClimateMetric.temperature, mockTemperature, [
        (0, 22.4),
        (120, 22.2),
        (240, 22.6),
        (360, 23.4), // → "↑ 1.2 °C since 06:00"
        (480, 24.3),
        (_nowMinute, mockTemperature.value),
      ]),
      trend(ClimateMetric.humidity, mockHumidity, [
        (0, 70),
        (60, 72),
        (120, 69),
        (180, 73),
        (240, 70),
        (300, 66),
        (360, 64),
        (420, 62),
        (480, 65),
        (540, 67),
        (_nowMinute, mockHumidity.value),
      ]),
      trend(ClimateMetric.light, mockLight, [
        (0, 80),
        (180, 80),
        (240, 120),
        (300, 180),
        (360, 230),
        (420, 330),
        (480, 370),
        (540, 410),
        (_nowMinute, mockLight.value),
      ]),
      trend(ClimateMetric.co2, mockCo2, [
        (0, 760),
        (45, 700),
        (90, 820),
        (150, 900),
        (220, 790),
        (280, 705),
        (340, 760),
        (400, 720),
        (480, 790),
        (_nowMinute, mockCo2.value),
      ]),
    ];
  }

  /// បន្ទាត់ត្រង់រវាងចំណុចយុថ្កា
  double _interpolate(List<(int, double)> anchors, int minute) {
    if (minute >= anchors.last.$1) return anchors.last.$2;

    for (var i = 1; i < anchors.length; i++) {
      final (m0, v0) = anchors[i - 1];
      final (m1, v1) = anchors[i];
      if (minute <= m1) {
        final t = (minute - m0) / (m1 - m0);
        return v0 + (v1 - v0) * t;
      }
    }
    return anchors.last.$2;
  }
}
