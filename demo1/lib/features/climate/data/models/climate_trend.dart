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
  // តម្លៃបច្ចុប្បន្ន និង target
  final RangedReading reading;
  // តម្រៀបតាមនាទីពីតូចទៅធំ
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

// តម្លៃមធ្យមរបស់តំបន់មួយ (ឧ. B Tomatoes)
class ClimateZone {
  const ClimateZone({
    required this.letter,
    required this.name,
    required this.temperature,
    required this.humidity,
  });
  final String letter;
  final String name;
  final double temperature;
  final double humidity;
}

class ClimateToday {
  const ClimateToday({
    required this.trends,
    required this.sampleIntervalMinutes,
    this.zones = const [],
    this.ventilationAuto = true,
  });
  final List<ClimateTrend> trends;
  final int sampleIntervalMinutes;
  final List<ClimateZone> zones;
  final bool ventilationAuto;

  int get total => trends.length;
  int get inRangeCount => trends.where((t) => t.reading.isInRange).length;
  bool get allInRange => total > 0 && inRangeCount == total;

  int get firstMinute => trends.isEmpty || trends.first.samples.isEmpty
      ? 0
      : trends.first.samples.first.minute;
  int get lastMinute => trends.isEmpty || trends.first.samples.isEmpty
      ? 0
      : trends.first.samples.last.minute;

  /// បោះ StateError ប្រសិនបើមិនមាន metric នោះ
  ClimateTrend trendOf(ClimateMetric metric) =>
      trends.firstWhere((t) => t.metric == metric);

  // null ប្រសិនបើមិនមាន​ metric នោះ (មិនបោះកំហុស)
  RangedReading? readingOf(ClimateMetric metric) {
    for (final t in trends) {
      if (t.metric == metric) return t.reading;
    }
    return null;
  }

  static bool _within(double v, RangedReading r) => v >= r.min && v <= r.max;

  // តំបន់នៅក្នុងកម្រិត ពេលសីតុណ្ហភាព និងសំណើមពីរក្នុង target
  // ស្មើរព្រំដែនពិតរាប់ជាក្នុងកម្រិត ដូច RangedReading
  bool zoneInRange(ClimateZone zone) {
    final temp = readingOf(ClimateMetric.temperature);
    final hum = readingOf(ClimateMetric.humidity);
    if (temp == null || hum == null) return false;
    return _within(zone.temperature, temp) && _within(zone.humidity, hum);
  }
}
