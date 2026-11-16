class WaterInputs {
  const WaterInputs({
    required this.reservoirLitres,
    required this.reservoirCapacityLitres,
    required this.linePressureBar,
    required this.flowLitresPerMin,
  });

  final double reservoirLitres;
  final double reservoirCapacityLitres;
  final double linePressureBar;
  final double flowLitresPerMin;

  /// 620 L in 1000 L = 20%
  double get reservoirPercent => reservoirCapacityLitres <= 0
      ? 0
      : reservoirLitres * 100 / reservoirCapacityLitres;
}

enum SafetyBlock { reservoirLow, pressureHigh }

class SafetyLimits {
  const SafetyLimits({this.minReservoirPercent = 15, this.maxPressureBar = 3});

  final double minReservoirPercent;
  final double maxPressureBar;

  /// ស្មើព្រំដែនពិតជាមិនទាន់ប្លុក ("below 15%" និង "above 3 bar")
  List<SafetyBlock> blockers(WaterInputs inputs) => [
    if (inputs.reservoirPercent < minReservoirPercent) SafetyBlock.reservoirLow,
    if (inputs.linePressureBar > maxPressureBar) SafetyBlock.pressureHigh,
  ];
}

class OutputDef {
  const OutputDef({required this.id, required this.title, required this.code});
  final String id;
  final String title;
  final String code;
}

class IrrigationSnapshot {
  const IrrigationSnapshot({required this.inputs, required this.outputs});
  final WaterInputs inputs;
  final List<OutputDef> outputs;
}
