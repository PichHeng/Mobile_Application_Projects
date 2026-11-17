class ScheduledCycle {
  const ScheduledCycle({
    required this.zoneName,
    required this.cropName,
    required this.hour,
    required this.minute,
    required this.durationMinutes,
    required this.litresPerMinute,
  });

  final String zoneName;
  final String cropName;
  final int hour;
  final int minute;
  final int durationMinutes;
  final double litresPerMinute;

  double get estimatedLitres => durationMinutes * litresPerMinute;

  /// លើកបន្ទាប់ដែលវាដំណើរការ (រៀងរាល់ថ្ងៃ)។
  /// ស្មើពេលបច្ចុប្បន្នពិតប្រាកដ ចាត់ថាបានចាប់ផ្តើមហើយ ដូច្នេះទៅថ្ងៃស្អែក។
  DateTime nextRun(DateTime now) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now)) return today;
    return DateTime(now.year, now.month, now.day + 1, hour, minute);
  }
}

class UpcomingCycle {
  const UpcomingCycle(this.cycle, this.start);

  final ScheduledCycle cycle;
  final DateTime start;
}

class IrrigationSchedule {
  const IrrigationSchedule(this.cycles);

  final List<ScheduledCycle> cycles;

  /// តម្រៀបតាមលំដាប់ពេលវេលា លើកដែលជិតបំផុតមុន
  List<UpcomingCycle> upcoming(DateTime now) {
    final list = [for (final c in cycles) UpcomingCycle(c, c.nextRun(now))];
    list.sort((a, b) => a.start.compareTo(b.start));
    return list;
  }
}
