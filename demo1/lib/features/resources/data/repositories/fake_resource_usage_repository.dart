import 'package:demo1/features/greenhouse/data/mock/mock_energy.dart';
import 'package:demo1/features/greenhouse/data/mock/mock_water.dart';
import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';

class FakeResourceUsageRepository implements ResourceUsageRepository {
  static const double _ratePerKwh = 0.18;

  static const _kinds = [
    ConsumerKind.growLights,
    ConsumerKind.ventilation,
    ConsumerKind.irrigation,
    ConsumerKind.climateControl,
  ];
  static const _details = [
    '6 fixtures · scheduled',
    '2 fans · automatic',
    'Main pump · 3 cycles',
    'Heating · standby',
  ];
  static const _baseKwh = [10.8, 4.2, 2.1, 1.3];

  // ===== Energy =====

  @override
  Future<EnergyReport> getEnergy(UsagePeriod period) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final series = switch (period) {
      UsagePeriod.today => _energyToday(),
      UsagePeriod.week => _energyWeek(),
      UsagePeriod.month => _energyMonth(),
    };
    return EnergyReport(
      series: series,
      ratePerKwh: _ratePerKwh,
      consumers: _consumers(series.total),
    );
  }

  UsageSeries _energyToday() {
    return UsageSeries(
      points: _hourly(mockEnergyTodayHourly),
      previousTotal: mockEnergyYesterday,
      budget: 22,
    );
  }

  UsageSeries _energyWeek() {
    return UsageSeries(
      points: _weekdays(const [19.8, 21.4, 20.2, 22.1, 19.5, 20.9, 18.4]),
      previousTotal: 148,
    );
  }

  UsageSeries _energyMonth() {
    return UsageSeries(
      points: [
        for (var i = 0; i < 30; i++)
          UsagePoint('${i + 1}', 17 + (i % 7) * 0.9 + (i % 3) * 0.4),
      ],
      previousTotal: 560,
    );
  }

  List<EnergyConsumer> _consumers(double total) {
    final baseTotal = _baseKwh.fold<double>(0, (sum, v) => sum + v);
    final factor = total / baseTotal;
    return [
      for (var i = 0; i < _kinds.length; i++)
        EnergyConsumer(
          kind: _kinds[i],
          detail: _details[i],
          kwh: _baseKwh[i] * factor,
        ),
    ];
  }

  // ===== Water =====

  @override
  Future<WaterReport> getWater(UsagePeriod period) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final series = switch (period) {
      UsagePeriod.today => UsageSeries(
        points: _hourly(mockWaterTodayHourly),
        previousTotal: mockWaterYesterday,
        budget: mockWaterAllowance,
      ),
      UsagePeriod.week => UsageSeries(
        points: _weekdays(const [265, 280, 255, 290, 270, 267.4, 246]),
        previousTotal: 1950,
      ),
      UsagePeriod.month => UsageSeries(
        points: [
          for (var i = 0; i < 30; i++)
            UsagePoint('${i + 1}', 250 + (i % 7) * 6 + (i % 3) * 3),
        ],
        previousTotal: 7800,
      ),
    };
    return WaterReport(
      series: series,
      zones: _zones(series.total),
      openValves: 0,
    );
  }

  // លីត្រថ្ងៃនេះ: A=96, B=102, C=48 (បូក ២៤៦) ពង្រីកតាមរយៈពេល
  List<WaterZone> _zones(double total) {
    const baseLitres = [96.0, 102.0, 48.0];
    const baseTotal = 246.0;
    final factor = total / baseTotal;

    WaterZone zone(int i, String letter, String name, double moisture) {
      return WaterZone(
        letter: letter,
        name: name,
        moisture: moisture,
        targetMin: 35,
        targetMax: 50,
        mode: IrrigationMode.auto,
        litres: baseLitres[i] * factor,
      );
    }

    return [
      zone(0, 'A', 'Leafy greens', 42),
      zone(1, 'B', 'Tomatoes', 28),
      zone(2, 'C', 'Herbs', 38),
    ];
  }

  // ===== ជំនួយរួម =====

  List<UsagePoint> _hourly(List<double> values) => [
    for (var i = 0; i < values.length; i++)
      UsagePoint('${i.toString().padLeft(2, '0')}:00', values[i]),
  ];

  List<UsagePoint> _weekdays(List<double> values) {
    const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return [
      for (var i = 0; i < days.length; i++) UsagePoint(days[i], values[i]),
    ];
  }
}
