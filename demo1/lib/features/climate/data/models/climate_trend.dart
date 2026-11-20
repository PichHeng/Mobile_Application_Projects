import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';

enum ClimateMetric { temperature, humidity, light, co2 }

class ClimateSample {
  const ClimateSample(this.minute, this.value);

  /// នាទីចាប់ពីពាក់កណ្តាលអធ្រាត្រ: 581 = 09:41
  final int minute;
  final double value;
}

class ClimateTrend {
  const ClimateTrend({
    required this.metric,
    required this.reading,
    required this.samples,
  });

  final ClimateMetric metric;
  final RangedReading reading;
  final List<ClimateSample> samples;

  List<double> get values => [for (final s in samples) s.value];

  double? valueAt(int minute) {
    double? found;
    for (final s in samples) {
      if (s.minute > minute) break;
      found = s.value;
    }
    return found;
  }

  double? changeSince(int minute) {
    final before = valueAt(minute);
    return before == null ? null : reading.value - before;
  }
}

class ClimateToday {
  const ClimateToday({
    required this.trends,
    required this.sampleIntervalMinutes,
  });
  final List<ClimateTrend> trends;
  final int sampleIntervalMinutes;

  int get total => trends.length;
  int get inRangeCount => trends.where((t) => t.reading.isInRange).length;
  bool get allInRange => total > 0 && inRangeCount == total;

  int get firstMinute => trends.isEmpty || trends.first.samples.isEmpty
      ? 0
      : trends.first.samples.first.minute;
  int get lastMinute => trends.isEmpty || trends.first.samples.isEmpty
      ? 0
      : trends.first.samples.last.minute;

  ClimateTrend trendOf(ClimateMetric metric) =>
      trends.firstWhere((t) => t.metric == metric);
}
