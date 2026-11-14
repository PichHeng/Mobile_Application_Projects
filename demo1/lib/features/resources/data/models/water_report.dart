import 'package:demo1/features/resources/data/models/usage_series.dart';

enum IrrigationMode { auto, manual }

class WaterZone {
  const WaterZone({
    required this.letter,
    required this.name,
    required this.moisture,
    required this.targetMin,
    required this.targetMax,
    required this.mode,
    required this.litres,
  });
  final String letter;
  final String name;
  final double moisture;
  final double targetMin;
  final double targetMax;
  final IrrigationMode mode;
  final double litres;

  /// ស្មើព្រំដែនទាប មិនទាន់ចាត់ជាស្ងួត
  bool get isDry => moisture < targetMin;
}

class WaterReport {
  const WaterReport({
    required this.series,
    required this.zones,
    required this.openValves,
  });

  final UsageSeries series;
  final List<WaterZone> zones;
  final int openValves;
  bool get allValvesClosed => openValves == 0;
  double get zonesTotal => zones.fold<double>(0, (sum, z) => sum + z.litres);
}
