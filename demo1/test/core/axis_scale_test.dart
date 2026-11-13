import 'package:demo1/core/utils/axis_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('3.7 gets a max of 4 with a stpe of 2', () {
    final scale = niceScale(3.7);
    expect(scale.max, closeTo(4, 0.0001));
    expect(scale.step, closeTo(2, 0.0001));
  });

  test('22.1 gets a max of 30 with a step of 15', () {
    final scale = niceScale(22.1);
    expect(scale.max, closeTo(30, 0.0001));
    expect(scale.step, closeTo(15, 0.0001));
  });

  test('a value exactly aon a nice step does not grow', () {
    final scale = niceScale(4);
    expect(scale.max, closeTo(4, 0.0001));
  });

  test('a value just above a step moves to the next nice step', () {
    final scale = niceScale(4.2);
    expect(scale.step, closeTo(2.5, 0.0001));
    expect(scale.max, closeTo(5, 0.0001));
  });
  test('zero or negative values get a safe default', () {
    expect(niceScale(0).max, 2);
  expect(niceScale(-5).max, 2);
  });
}
