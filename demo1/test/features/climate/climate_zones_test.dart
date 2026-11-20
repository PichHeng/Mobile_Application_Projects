import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/fake_climate_repository.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:flutter_test/flutter_test.dart';

ClimateToday _today({bool auto = true}) => ClimateToday(
  sampleIntervalMinutes: 5,
  ventilationAuto: auto,
  trends: const [
    ClimateTrend(
      metric: ClimateMetric.temperature,
      reading: RangedReading(value: 24.6, min: 22, max: 26),
      samples: [ClimateSample(0, 1)],
    ),
    ClimateTrend(
      metric: ClimateMetric.humidity,
      reading: RangedReading(value: 68, min: 60, max: 75),
      samples: [ClimateSample(0, 1)],
    ),
  ],
);

ClimateZone _zone(double temp, double humidity) => ClimateZone(
  letter: 'X',
  name: 'Test',
  temperature: temp,
  humidity: humidity,
);

void main() {
  test('a zone inside both targets is in range', () {
    expect(_today().zoneInRange(_zone(24, 70)), true);
  });

  test('a zone that is too hot is out of range', () {
    expect(_today().zoneInRange(_zone(27, 70)), false);
  });

  test('a zone that is too dry is out of range', () {
    expect(_today().zoneInRange(_zone(24, 55)), false);
  });

  test('a zone exactly on a limit is still in range', () {
    expect(_today().zoneInRange(_zone(26, 75)), true);
    expect(_today().zoneInRange(_zone(22, 60)), true);
  });

  test('without targets no zone can be called in range', () {
    const empty = ClimateToday(trends: [], sampleIntervalMinutes: 5);

    expect(empty.zoneInRange(_zone(24, 70)), false);
    expect(empty.readingOf(ClimateMetric.co2), isNull);
  });

  test(
    'the three design zones all average to the greenhouse reading',
    () async {
      final today = await FakeClimateRepository().getToday();
      final temps = today.zones.map((z) => z.temperature);
      final humidities = today.zones.map((z) => z.humidity);

      final meanTemp = temps.reduce((a, b) => a + b) / today.zones.length;
      final meanHumidity =
          humidities.reduce((a, b) => a + b) / today.zones.length;

      expect(
        meanTemp,
        closeTo(today.trendOf(ClimateMetric.temperature).reading.value, 0.05),
      );
      expect(
        meanHumidity,
        closeTo(today.trendOf(ClimateMetric.humidity).reading.value, 0.05),
      );
    },
  );

  test('every design zone is in range', () async {
    final today = await FakeClimateRepository().getToday();

    expect(today.zones.every(today.zoneInRange), true);
  });

  test('ventilation text uses the real target limits', () {
    expect(
      ventilationText(_today()),
      'Ventilation is in Auto. Fans increase above 26 °C or 75% RH, '
      'helping protect a comfortable canopy.',
    );
  });

  test('manual ventilation does not promise automatic fans', () {
    expect(
      ventilationText(_today(auto: false)),
      'Ventilation is in Manual. Automatic fan control is off.',
    );
  });

  test('no text without temperature and humidity targets', () {
    const empty = ClimateToday(trends: [], sampleIntervalMinutes: 5);

    expect(ventilationText(empty), isNull);
  });
}
