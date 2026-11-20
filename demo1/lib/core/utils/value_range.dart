import 'dart:math' as math;

class ValueRange {
  const ValueRange(this.min, this.max);

  final double min;
  final double max;
}

/// ជួរតម្លៃសម្រាប់ sparkline បូកគម្លាតតិចតួចពីរខាង
/// បន្ទាត់ត្រង់ (min == max) ទទួលបាន ±1 ដើម្បីកុំឱ្យចែកនឹងសូន្យ
ValueRange paddedRange(List<double> values, {double padding = 0.1}) {
  if (values.isEmpty) return const ValueRange(0, 1);

  final lo = values.reduce(math.min);
  final hi = values.reduce(math.max);
  if (hi - lo < 1e-9) return ValueRange(lo - 1, hi + 1);
  final pad = (hi - lo) * padding;
  return ValueRange(lo - pad, hi + pad);
}
