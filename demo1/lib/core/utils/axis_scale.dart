import 'dart:math' as math;

class AxisScale {
  const AxisScale({required this.max, required this.step});

  final double max;
  final double step;
}

/// រកកំពូលអ័ក្ស និងចន្លោះ ដែលជាលេខស្អាត
/// ឧទាហរណ៍ 3.7 -> max 4, step 2

AxisScale niceScale(double maxValue, {int intervals = 2}) {
  assert(intervals >= 1);
  if (maxValue <= 0) {
    return AxisScale(max: intervals.toDouble(), step: 1);
  }

  final raw = maxValue / intervals;
  final magnitude = math
      .pow(10, (math.log(raw) / math.ln10).floor())
      .toDouble();
  final normalized = raw / magnitude;

  const candidates = [1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0];
  final nice = candidates.firstWhere(
    (c) => c >= normalized - 1e-9,
    orElse: () => 10.0,
  );

  final step = nice * magnitude;
  return AxisScale(max: step * intervals, step: step);
}
