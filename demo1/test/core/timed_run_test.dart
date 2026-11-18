import 'package:demo1/core/utils/timed_run.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_scheduler.dart';

void main() {
  late FakeScheduler scheduler;
  late TimedRun run;
  late int expired;

  setUp(() {
    scheduler = FakeScheduler();
    run = TimedRun(
      limit: const Duration(seconds: 10),
      scheduler: scheduler.call,
    );
    expired = 0;
  });

  test('start schedules one timer with the limit', () {
    run.start(() => expired++);

    expect(run.isRunning, true);
    expect(scheduler.calls, 1);
    expect(scheduler.lastDuration, const Duration(seconds: 10));
  });

  test('starting twice does not schedule a second timer', () {
    run.start(() => expired++);
    run.start(() => expired++);

    expect(scheduler.calls, 1);
  });

  test('when the time is up the expire callback runs', () {
    run.start(() => expired++);

    scheduler.fire!();

    expect(expired, 1);
  });

  test('stop cancels the timer and reports it was running', () {
    run.start(() => expired++);

    final wasRunning = run.stop();

    expect(wasRunning, true);
    expect(run.isRunning, false);
    expect(scheduler.timer!.cancelled, true);
  });

  test('stop when nothing runs reports false', () {
    expect(run.stop(), false);
  });

  test('dispose cancels a running timer', () {
    run.start(() => expired++);

    run.dispose();

    expect(scheduler.timer!.cancelled, true);
  });

  test('it can start again after being stopped', () {
    run.start(() => expired++);
    run.stop();
    run.start(() => expired++);

    expect(scheduler.calls, 2);
    expect(run.isRunning, true);
  });
}
