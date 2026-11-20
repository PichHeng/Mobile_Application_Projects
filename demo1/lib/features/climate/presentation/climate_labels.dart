import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';
import 'package:flutter/material.dart';

String metricLabel(ClimateMetric m) => switch (m) {
  ClimateMetric.temperature => 'Temerature',
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
  ClimateMetric.co2 => 'ppm ·  CO2 concentration',
};

String targetText(ClimateTrend trend) {
  final r = trend.reading;
  final range = '${formatReading(r.min)}–${formatReading(r.max)}';
  return trend.metric == ClimateMetric.humidity
      ? 'Target $range% RH'
      : 'Target $range ${metricUnit(trend.metric)}';
}

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
