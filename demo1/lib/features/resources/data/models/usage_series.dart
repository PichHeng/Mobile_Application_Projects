enum UsagePeriod { today, week, month }

class UsagePoint {
  const UsagePoint(this.label, this.value);

  final String label;
  final double value;
}

class UsageSeries {
  const UsageSeries({
    required this.points,
    required this.previousTotal,
    this.budget,
  });

  final List<UsagePoint> points;

  /// សរុបនៃរយៈពេលមុន (ម្សិលមិញ, ៧ ថ្ងៃមុន...) សម្រាប់ប្រៀបធៀប
  final double previousTotal;

  /// null​ មានន័យថារយៈពេលគ្មានថវិកា (មានតែ "Today")
  final double? budget;
  double get total => points.fold<double>(0, (sum, p) => sum + p.value);

  /// ចំណុចបូកបន្ត: [1, 2, 3] -> [1, 3, 6] ដោយរក្សាស្លាកដើម
  List<UsagePoint> get cumulativePoints {
    final result = <UsagePoint>[];
    var running = 0.0;
    for (final p in points) {
      running += p.value;
      result.add(UsagePoint(p.label, running));
    }
    return result;
  }

  /// -0.22 មានន័យថាតិចជាង ១២% ធៀបនឹងរយះពេលមុន
  double get changeVsPrevious =>
      previousTotal == 0 ? 0 : (total - previousTotal) / previousTotal;

  double? get budgetRemaining {
    final b = budget;
    return b == null ? null : b - total;
  }

  bool get isWithinBudget {
    final b = budget;
    return b == null || total <= b;
  }
}
