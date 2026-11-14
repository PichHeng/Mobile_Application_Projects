class ResourceSummary {
  const ResourceSummary({
    required this.energyKwh,
    required this.energyChangeVsYesterday,
    required this.waterLitres,
    required this.waterAllowanceUsed,
    required this.fertilizerLitres,
  });

  final double energyKwh;
  // -0.12 មានន័យថាតិចជាង ១២% ធៀបនឹងម្សិលមិញ
  final double energyChangeVsYesterday;
  final double waterLitres;
  // 0.77 មានន័យថាប្រើអស់ ៧៧% នៃកូតាប្រចាំថ្ងៃ
  final double waterAllowanceUsed;
  final double fertilizerLitres;
}

class PlantHealthSummary {
  const PlantHealthSummary({
    required this.healthy,
    required this.watch,
    required this.attention,
  });

  final int healthy;
  final int watch;
  final int attention;

  int get total => healthy + watch + attention;

  int get healthyPercent => total == 0 ? 0 : (healthy / total * 100).round();
}

class RootsInsignt {
  const RootsInsignt({required this.soilTemperature, this.lowMoistureZone});
  final double soilTemperature;
  // null មានន័យថាគ្មានតំបន់ណាខ្វះសំណើម
  final String? lowMoistureZone;
}

class MoistureAlert {
  const MoistureAlert({
    required this.zoneName,
    required this.cropName,
    required this.moisture,
    required this.targetMin,
    required this.targetMax,
    required this.nextIrrigation,
  });
  final String zoneName;
  final String cropName;
  final double moisture;
  final double targetMin;
  final double targetMax;
  final DateTime nextIrrigation;
}

class RootsInsight {
  const RootsInsight({required this.soilTemperature, this.lowMoistureZone});

  final double soilTemperature;

  /// null មានន័យថាគ្មានតំបន់ណាខ្វះសំណើម
  final String? lowMoistureZone;
}

class OverviewSummary {
  const OverviewSummary({
    required this.zoneCount,
    required this.resources,
    required this.health,
    required this.roots,
    required this.alerts,
  });

  final int zoneCount;
  final ResourceSummary resources;
  final PlantHealthSummary health;
  final RootsInsight roots;
  final List<MoistureAlert> alerts;
}
