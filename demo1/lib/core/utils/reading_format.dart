import 'package:intl/intl.dart';

// 68 -> "68", 24.6", 1000 -> "1,000"
String formatReading(double value) {
  final isWhole = value == value.roundToDouble();
  final format = isWhole ? NumberFormat("#,##0") : NumberFormat("#,##0.0");
  return format.format(value);
}
