import 'dart:async';

class FakeTimer implements Timer {
  bool cancelled = false;

  @override
  void cancel() => cancelled = true;

  @override
  bool get isActive => !cancelled;

  @override
  int get tick => 0;
}

/// ជំនួស Timer ពិត។ តេស្តហៅ `fire` ដោយដៃ ដើម្បីក្លែងថាអស់ពេល
class FakeScheduler {
  int calls = 0;
  Duration? lastDuration;
  void Function()? fire;
  FakeTimer? timer;

  Timer call(Duration duration, void Function() callback) {
    calls++;
    lastDuration = duration;
    fire = callback;
    return timer = FakeTimer();
  }
}
