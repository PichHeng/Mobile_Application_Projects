import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';

class ClimateSeries {
  const ClimateSeries({
    required this.metric,
    required this.period,
    required this.reading,
    required this.points,
  });

  final ClimateMetric metric;
  final UsagePeriod period;

  // តម្លៃបច្ចុប្បន្ន និង target (target បង្កើត band)
  final RangedReading reading;
  // តម្រៀបតាម x ពីតូចទៅធំ
  final List<ChartPoint> points;
  List<double> get ys => [for (final p in points) p.y];
  double? get latest => points.isEmpty ? null : points.last.y;
  double? get average => points.isEmpty
      ? null
      : ys.fold<double>(0, (sum, v) => sum + v) / points.length;

  // តម្លៃចុងក្រោយនៅ x នោះ​ or មុនវា។ null បើមិនទាន់មានទិន្នន័យ
double? valueAt(double x) {
    double? found;
    for (final p in points) {
      if (p.x > x) break;
      found = p.y;
    }
    return found;
  }

  // ការប្ដូរពី x នោះដល់ចុងក្រោយ: 24.6 - 23.4 = 1.2
  double? changeSince(double x) {
    final before = valueAt(x);
    final now = latest;
    if (before == null || now == null) return null;
    return now - before;
  }
}
