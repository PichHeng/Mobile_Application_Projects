import 'package:demo1/core/utils/axis_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('temperature 22 to 26 gives the design axis 20 to 28 step 4', () {
    final range = niceRange(22, 26);

    expect(range.min, closeTo(20, 1e-9));
    expect(range.max, closeTo(28, 1e-9));
    expect(range.step, closeTo(4, 1e-9));
  });

  test('humidity 60 to 75 gives 45 to 90 step 15', () {
    final range = niceRange(60, 75);

    expect(range.min, closeTo(45, 1e-9));
    expect(range.max, closeTo(90, 1e-9));
    expect(range.step, closeTo(15, 1e-9));
  });

  test('the range always contains the values it was asked for', () {
    const cases = [
      (22.0, 26.0),
      (60.0, 75.0),
      (350.0, 500.0),
      (700.0, 1000.0),
      (0.0, 3.7),
      (-4.0, 6.0),
      (5.0, 5.0),
    ];

    for (final (lo, hi) in cases) {
      final range = niceRange(lo, hi);

      expect(range.min <= lo, true, reason: 'min for ($lo, $hi)');
      expect(range.max >= hi, true, reason: 'max for ($lo, $hi)');
      expect(range.step > 0, true, reason: 'step for ($lo, $hi)');
    }
  });

  test('min and max are whole multiples of the step', () {
    final range = niceRange(350, 500);

    expect((range.min / range.step) % 1, closeTo(0, 1e-9));
    expect((range.max / range.step) % 1, closeTo(0, 1e-9));
  });

  test('a flat line still gets a usable range', () {
    final range = niceRange(5, 5);

    expect(range.max > range.min, true);
    expect(range.min <= 5, true);
    expect(range.max >= 5, true);
  });
}
