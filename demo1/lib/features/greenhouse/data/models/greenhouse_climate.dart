class RangedReading {
  const RangedReading({
    required this.value,
    required this.min,
    required this.max,
  });

  final double value;
  final double min;
  final double max;

  bool get isInRange => value >= min && value <= max;
}

class GreenhouseClimate {
  const GreenhouseClimate({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.co2,
  });

  final RangedReading temperature;
  final RangedReading humidity;
  final RangedReading light;
  final RangedReading co2;
}
