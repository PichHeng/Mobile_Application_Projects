import 'package:demo1/core/utils/reading_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('whole numbers have no decimals', () {
    expect(formatReading(68), '68');
  });

  test('fractions keep one decimal', () {
    expect(formatReading(24.6), '24.6');
  });

  test('thousands use a separator', () {
    expect(formatReading(1000), '1,000');
  });
}
