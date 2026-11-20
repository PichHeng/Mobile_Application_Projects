import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/material.dart';

String metricLabel(ClimateMetric m) => switch (m) {
  ClimateMetric.temperature => 'Temperature',
  ClimateMetric.humidity => 'Humidity',
  ClimateMetric.light => 'Light · PPFD',
  ClimateMetric.co2 => 'Carbon dioxide',
};

IconData metricIcon(ClimateMetric m) => switch (m) {
  ClimateMetric.temperature => Icons.thermostat,
  ClimateMetric.humidity => Icons.water_drop_outlined,
  ClimateMetric.light => Icons.wb_sunny_outlined,
  ClimateMetric.co2 => Icons.air,
};

String metricUnit(ClimateMetric m) => switch (m) {
  ClimateMetric.temperature => '°C',
  ClimateMetric.humidity => '%',
  ClimateMetric.light => 'µmol/m²/s',
  ClimateMetric.co2 => 'ppm',
};

/// ខ្ញុំប្រើ "CO2" ធម្មតា ព្រោះមិនប្រាកដថា font មានអក្សរ ₂
String metricCaption(ClimateMetric m) => switch (m) {
  ClimateMetric.temperature => '°C · greenhouse average',
  ClimateMetric.humidity => '% RH · relative humidity',
  ClimateMetric.light => 'µmol/m²/s · at canopy',
  ClimateMetric.co2 => 'ppm · CO2 concentration',
};

/// "22–26 °C", "60–75% RH", "700–1,000 ppm"
String rangeText(ClimateMetric m, RangedReading r) {
  final range = '${formatReading(r.min)}–${formatReading(r.max)}';
  return m == ClimateMetric.humidity ? '$range% RH' : '$range ${metricUnit(m)}';
}

String targetText(ClimateTrend trend) =>
    'Target ${rangeText(trend.metric, trend.reading)}';

/// 581 -> "09:41"
String formatMinute(int minute) =>
    DailyTime(minute ~/ 60, minute % 60).format();

String trendsCaption(ClimateToday today) {
  final title = today.lastMinute < 12 * 60
      ? 'Morning trends'
      : "Today's trends";
  return '$title, ${formatMinute(today.firstMinute)}–'
      '${formatMinute(today.lastMinute)} · '
      '${today.sampleIntervalMinutes}-minute sample interval';
}

// ===== "A closer look" =====

const _weekdays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

/// label អ័ក្ស X: ថ្ងៃនេះជាម៉ោង, 7 ថ្ងៃជាឈ្មោះថ្ងៃ, ខែជាលេខថ្ងៃ
String Function(double x) xLabelFor(UsagePeriod p) => switch (p) {
  UsagePeriod.today => (x) => formatMinute(x.round()),
  UsagePeriod.week => (x) => _weekdays[x.round().clamp(0, 6).toInt()],
  UsagePeriod.month => (x) => '${x.round() + 1}',
};

/// label បង្ហាញត្រង់ x = 0, interval, 2×interval...
double xIntervalFor(UsagePeriod p) => switch (p) {
  UsagePeriod.today => 180,
  UsagePeriod.week => 2,
  UsagePeriod.month => 8,
};

bool _pastSix(ClimateSeries s) => s.points.isNotEmpty && s.points.last.x >= 360;

/// ថ្ងៃនេះ ប្រៀបធៀបនឹង 06:00 (ឬ 00:00 បើមុនម៉ោង 06:00)។ ផ្សេងទៀតប្រៀបធៀបនឹងចំណុចដំបូង
double changeAnchorX(ClimateSeries s) {
  if (s.points.isEmpty) return 0;
  if (s.period == UsagePeriod.today && _pastSix(s)) return 360;
  return s.points.first.x;
}

String sinceLabel(ClimateSeries s) => switch (s.period) {
  UsagePeriod.today => _pastSix(s) ? '06:00' : '00:00',
  UsagePeriod.week => '7 days ago',
  UsagePeriod.month => '30 days ago',
};

/// លេខធំ: ថ្ងៃនេះជាតម្លៃបច្ចុប្បន្ន ផ្សេងទៀតជាមធ្យម
double? shownValue(ClimateSeries s) =>
    s.period == UsagePeriod.today ? s.reading.value : s.average;

String valueSuffix(ClimateSeries s) =>
    '${metricUnit(s.metric)} ${s.period == UsagePeriod.today ? 'now' : 'avg'}';

/// "↑ 1.2 °C since 06:00" (icon ញែកដោយឡែក)
({IconData? icon, String text})? changeLine(ClimateSeries s) {
  final change = s.changeSince(changeAnchorX(s));
  if (change == null) return null;

  // បង្គត់មួយខ្ទង់ ដើម្បីកុំឱ្យ 0.04 បង្ហាញជា "0.0 °C"
  final rounded = (change.abs() * 10).round() / 10;
  final since = sinceLabel(s);

  if (rounded == 0) return (icon: null, text: 'No change since $since');

  return (
    icon: change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
    text: '${formatReading(rounded)} ${metricUnit(s.metric)} since $since',
  );
}

// ===== Ventilation =====

/// អត្ថបទមកពី target ពិត មិនមែនអត្ថបទថេរ
String? ventilationText(ClimateToday today) {
  final temp = today.readingOf(ClimateMetric.temperature);
  final hum = today.readingOf(ClimateMetric.humidity);
  if (temp == null || hum == null) return null;

  if (!today.ventilationAuto) {
    return 'Ventilation is in Manual. Automatic fan control is off.';
  }
  return 'Ventilation is in Auto. Fans increase above '
      '${formatReading(temp.max)} °C or ${formatReading(hum.max)}% RH, '
      'helping protect a comfortable canopy.';
}
