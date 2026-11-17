import 'package:demo1/features/resources/data/models/irrigation_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

const _zoneB = ScheduledCycle(
  zoneName: 'Zone B',
  cropName: 'Tomatoes',
  hour: 10,
  minute: 30,
  durationMinutes: 6,
  litresPerMinute: 6,
);

const _zoneA = ScheduledCycle(
  zoneName: 'Zone A',
  cropName: 'Leafy greens',
  hour: 11,
  minute: 0,
  durationMinutes: 8,
  litresPerMinute: 6,
);

void main() {
  test('6 minutes at 6 L per minute is 36 litres', () {
    expect(_zoneB.estimatedLitres, closeTo(36, 0.0001));
  });

  test('before the start time the next run is today', () {
    final next = _zoneB.nextRun(DateTime(2026, 6, 12, 9, 41));

    expect(next, DateTime(2026, 6, 12, 10, 30));
  });

  test('after the start time the next run is tomorrow', () {
    final next = _zoneB.nextRun(DateTime(2026, 6, 12, 10, 45));

    expect(next, DateTime(2026, 6, 13, 10, 30));
  });

  test('exactly at the start time counts as already started', () {
    final next = _zoneB.nextRun(DateTime(2026, 6, 12, 10, 30));

    expect(next, DateTime(2026, 6, 13, 10, 30));
  });

  test('tomorrow rolls over the end of the month', () {
    final next = _zoneB.nextRun(DateTime(2026, 6, 30, 23, 0));

    expect(next, DateTime(2026, 7, 1, 10, 30));
  });

  test('upcoming is sorted by time whatever the list order', () {
    const schedule = IrrigationSchedule([_zoneA, _zoneB]);

    final upcoming = schedule.upcoming(DateTime(2026, 6, 12, 9, 41));

    expect(upcoming.map((u) => u.cycle.zoneName).toList(), [
      'Zone B',
      'Zone A',
    ]);
  });

  test('upcoming wraps to tomorrow for cycles that already ran', () {
    const schedule = IrrigationSchedule([_zoneA, _zoneB]);

    final upcoming = schedule.upcoming(DateTime(2026, 6, 12, 10, 45));

    expect(upcoming.first.cycle.zoneName, 'Zone A');
    expect(upcoming.first.start, DateTime(2026, 6, 12, 11, 0));
    expect(upcoming.last.cycle.zoneName, 'Zone B');
    expect(upcoming.last.start, DateTime(2026, 6, 13, 10, 30));
  });

  test('an empty schedule has nothing upcoming', () {
    const schedule = IrrigationSchedule([]);

    expect(schedule.upcoming(DateTime(2026, 6, 12)), isEmpty);
  });
}
