import 'dart:async';

/// ការដំណើរការមានដែនកំណត់ពេលវេលា (ឧ. តេស្តដោយដៃ ២ នាទី, prime ១០ វិនាទី)
/// ត្រូវបានបិទដោយខ្លួនឯងពេលអស់ពេល ឬដោយដៃ
class TimedRun {
  TimedRun({
    required this.limit,
    Timer Function(Duration, void Function())? scheduler,
  }) : _schedule = scheduler ?? Timer.new;

  final Duration limit;
  final Timer Function(Duration, void Function()) _schedule;

  Timer? _timer;
  bool _running = false;
  bool get isRunning => _running;

  /// ចាប់ផ្តើម។ ហៅម្តងទៀតពេលកំពុងដំណើរការមិនធ្វើអ្វី (មិនបង្កើត timer ស្ទួន)
  void start(void Function() onExpire) {
    if (_running) return;
    _running = true;
    _timer = _schedule(limit, onExpire);
  }

  // បិទ ហើយលុប timer។ ត្រឡប់ true ប្រសិនបើវាកំពុងដំណើរការ
  bool stop() {
    _timer?.cancel();
    _timer = null;
    final wasRunning = _running;
    _running = false;
    return wasRunning;
  }

  void dispose() => stop();
}
