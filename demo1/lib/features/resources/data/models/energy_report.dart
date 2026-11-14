import 'package:demo1/features/resources/data/models/usage_series.dart';

enum ConsumerKind { growLights, ventilation, irrigation, climateControl }

class EnergyConsumer {
  const EnergyConsumer({
    required this.kind,
    required this.detail,
    required this.kwh,
  });

  final ConsumerKind kind;

  /// ព័ត៌មានពីការកំណត់ greenhouse ឧ. "6 fixtures · scheduled"
  final String detail;

  final double kwh;
}

class EnergyReport {
  const EnergyReport({
    required this.series,
    required this.ratePerKwh,
    required this.consumers,
  });

  final UsageSeries series;
  final double ratePerKwh;
  final List<EnergyConsumer> consumers;

  double get estimatedCost => series.total * ratePerKwh;

  /// វិជ្ជមាន = ចំណេញ, អវិជ្ជមាន = ប្រើច្រើនជាងមុន
  double get savedKwh => series.previousTotal - series.total;

  double get consumersTotal =>
      consumers.fold<double>(0, (sum, c) => sum + c.kwh);

  int sharePercent(EnergyConsumer consumer) =>
      consumersTotal == 0 ? 0 : (consumer.kwh / consumersTotal * 100).round();
}
