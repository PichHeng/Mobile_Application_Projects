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

class OverviewSummary {
  const OverviewSummary({required this.zoneCount, required this.resources});

  final int zoneCount;
  final ResourceSummary resources;
}
