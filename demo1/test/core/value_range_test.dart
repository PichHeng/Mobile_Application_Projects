import 'package:demo1/core/utils/value_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('padding adds ten percent of the span on each side', () {
    final range = paddedRange([10, 20]);

    expect(range.min, closeTo(9, 1e-9));
    expect(range.max, closeTo(21, 1e-9));
  });

  test('a flat line gets one unit above and below', () {
    final range = paddedRange([5, 5, 5]);

    expect(range.min, closeTo(4, 1e-9));
    expect(range.max, closeTo(6, 1e-9));
  });

  test('a single value is treated as flat', () {
    final range = paddedRange([7]);

    expect(range.min, closeTo(6, 1e-9));
    expect(range.max, closeTo(8, 1e-9));
  });

  test('no values give a safe 0 to 1 range', () {
    final range = paddedRange([]);

    expect(range.min, 0);
    expect(range.max, 1);
  });
}
