class DailyTime {
  const DailyTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  final int hour;
  final int minute;

  /// 9:05 -> "09:05"
  String format() =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';

  /// លើកបន្ទាប់ដែលម៉ោងនេះមកដល់ (រៀងរាល់ថ្ងៃ)
  /// ស្មើពេលបច្ចុប្បន្នពិតប្រាកដ ចាត់ថាបានមកដល់ហើយ ដូច្នេះទៅថ្ងៃស្អែក
  DateTime nextOccurrence(DateTime now) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now)) return today;
    return DateTime(now.year, now.month, now.day + 1, hour, minute);
  }
}
