import 'package:demo1/core/utils/axis_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ten points show a label every three', () {
    expect(axisLabelStep(10), 3);
  });
  test('seven points show a label every two', () {
    expect(axisLabelStep(7), 2);
  });
  test('thirty points show a label every eight', () {
    expect(axisLabelStep(30), 8);
  });
  test('four points or fewer show every label', () {
    expect(axisLabelStep(4), 1);
    expect(axisLabelStep(1), 1);
  });
  test('zero points do not produce a zero step', () {
    expect(axisLabelStep(0), 1);
  });
}
