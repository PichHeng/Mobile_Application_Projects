import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/daily_time.dart';

class DosingPart {
  const DosingPart({
    required this.letter,
    required this.name,
    required this.remainingLitres,
    required this.doseMlPerLitre,
  });

  final String letter;
  final String name;
  final double remainingLitres;
  final double doseMlPerLitre;
}

class FertilizerRecipe {
  const FertilizerRecipe({
    required this.name,
    required this.partA,
    required this.partB,
    required this.nextMix,
    required this.nextMixWaterLitres,
  });
  final String name;
  final DosingPart partA;
  final DosingPart partB;
  final DailyTime nextMix;
  final double nextMixWaterLitres;

  /// 2 + 2 = 4 mL ក្នុងទឹក ១ លីត្រ
  double get concentrateMlPerLitre =>
      partA.doseMlPerLitre + partB.doseMlPerLitre;

  /// 4 mL/L × 40 L = 160 mL
  double get nextMixConcentrateMl => concentrateMlPerLitre * nextMixWaterLitres;

  /// "1:1 mix" ពេលដូសទាំងពីរស្មើគ្នា
  bool get isEvenMix =>
      (partA.doseMlPerLitre - partB.doseMlPerLitre).abs() < 1e-9;
}

class DosingInputs {
  const DosingInputs({
    required this.ec,
    required this.ph,
    required this.tankPercent,
  });

  /// mS/cm
  final RangedReading ec;
  final RangedReading ph;
  final double tankPercent;
}

class DosingLimits {
  const DosingLimits({this.minTankPercent = 20});

  /// ទាបជាងនេះ interlock ឈប់ដូស ("falls below 20%")
  final double minTankPercent;

  /// ស្មើព្រំដែនពិតជាមិនទាន់ទាប ដូចពាក្យ "below"
  bool isTankLow(DosingInputs inputs) => inputs.tankPercent < minTankPercent;
}

class DosingSnapshot {
  const DosingSnapshot({required this.recipe, required this.inputs});

  final FertilizerRecipe recipe;
  final DosingInputs inputs;
}
