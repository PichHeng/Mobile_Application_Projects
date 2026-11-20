import 'dart:math' as math;

class AxisScale {
  const AxisScale({required this.max, required this.step});

  final double max;
  final double step;
}

class AxisRange {
  const AxisRange({required this.min, required this.max, required this.step});
  final double min;
  final double max;
  final double step;
}

double _niceStep(double raw) {
  final magnitude = math.pow(
    10,
    (math.log(raw) / math.ln10).floor().toDouble(),
  );
  final normalized = raw / magnitude;
  const candidates = [1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0];
  final nice = candidates.firstWhere(
    (c) => c >= normalized - 1e-9,
    orElse: () => 10.0,
  );
  return nice * magnitude;
}

/// រកកំពូលអ័ក្ស និងចន្លោះ ដែលជាលេខស្អាត
/// ឧទាហរណ៍ 3.7 -> max 4, step 2

AxisScale niceScale(double maxValue, {int intervals = 2}) {
  assert(intervals >= 1);
  if (maxValue <= 0) {
    return AxisScale(max: intervals.toDouble(), step: 1);
  }

  final step = _niceStep(maxValue / intervals);
  return AxisScale(max: step * intervals, step: step);
}

/// អ័ក្សដែលគ្របដណ្តប់ [lo, hi] បូកគម្លាត ដោយ min និង max ជាពហុគុណនៃ step
/// ឧទាហរណ៍ (22, 26) -> 20..28 ជំហាន 4
AxisRange niceRange(
  double lo,
  double hi, {
  int intervals = 2,
  double pad = 0.5,
}) {
  assert(intervals >= 1);
  assert(hi >= lo);
  // បន្ទាត់ត្រង់ (lo == hi) ទទួលបាន ±1 ដើម្បីកុំឱ្យជួរសូន្យ
  if (hi - lo < 1e-9) {
    lo -= 1;
    hi += 1;
  }

  final span = hi - lo;
  final paddedLo = lo - span * pad;
  final paddedHi = hi - span * pad;

  final step = _niceStep((paddedHi - paddedLo) / intervals);

  // 1e-9 ការពារកំហុសចំណុចអណ្តែត: 19.999999 មិនគួរធ្លាក់ទៅ 16
  final min = (paddedLo / step + 1e-9).floor() * step;
  final max = (paddedHi / step - 1e-9).ceil() * step;
  return AxisRange(min: min, max: max, step: step);
}

/// បង្ហាញ label រៀងរាល់ប៉ុន្មានចំណុច ដើម្បីឪ្យមានប្រហែល 4 label
int axisLabelStep(int count) => math.max(1, (count / 4)).ceil();
