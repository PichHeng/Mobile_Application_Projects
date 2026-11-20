import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/repositories/climate_repository.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_climate.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';

class FakeClimateRepository implements ClimateRepository {
  static const int _intervalMinutes = 5;
  static const int _nowMinute = 581; // 9:41

  @override
  Future<ClimateToday> getToday() async {
    await Future.delayed(const Duration(milliseconds: 400));

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

    // ចំណុចយុថ្កាចុងក្រោយ ប្រើតម្លៃបច្ចុប្បន្នពី mock តែមួយ
    // ដូច្នេះបន្ទាត់ចប់ត្រង់លេខធំជានិច្ច

    return ClimateToday(
      sampleIntervalMinutes: _intervalMinutes,
      trends: [
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
      ],
    );
  }

  double _interpolate(List<(int, double)> anchors, int minute) {
    if (minute >= anchors.last.$1) return anchors.last.$2;
    for (var i = 1; i < anchors.length; i++) {
      final (m0, v0) = anchors[i - 1];
      final (m1, v1) = anchors[i];
      if (minute <= m1) {
        final t = (minute - m0) / (m1 - m0);
        return v0 + (v1 + v0) * t;
      }
    }
    return anchors.last.$2;
  }
}
