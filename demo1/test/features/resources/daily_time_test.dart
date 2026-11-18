import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const noon = DailyTime(12, 0);

  test('before the time, the next occurrence is today', () {
    expect(
      noon.nextOccurrence(DateTime(2026, 6, 12, 9, 41)),
      DateTime(2026, 6, 12, 12, 0),
    );
  });

  test('after the time, the next occurrence is tomorrow', () {
    expect(
      noon.nextOccurrence(DateTime(2026, 6, 12, 13, 0)),
      DateTime(2026, 6, 13, 12, 0),
    );
  });

  test('exactly at the time counts as already happened', () {
    expect(
      noon.nextOccurrence(DateTime(2026, 6, 12, 12, 0)),
      DateTime(2026, 6, 13, 12, 0),
    );
  });

  test('tomorrow rolls over the end of the month', () {
    expect(
      noon.nextOccurrence(DateTime(2026, 6, 30, 13, 0)),
      DateTime(2026, 7, 1, 12, 0),
    );
  });

  test('tomorrow rolls over the end of the year', () {
    expect(
      noon.nextOccurrence(DateTime(2026, 12, 31, 23, 0)),
      DateTime(2027, 1, 1, 12, 0),
    );
  });

  test('an impossible time is rejected', () {
    expect(() => DailyTime(24, 0), throwsAssertionError);
    expect(() => DailyTime(10, 60), throwsAssertionError);
  });
}
