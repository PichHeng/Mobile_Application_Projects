import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';

class FakeResourceUsageRepository implements ResourceUsageRepository {
  @override
  Future<UsageSeries> getEnergy(UsagePeriod peroid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return switch (peroid) {
      UsagePeriod.today => _today(),
      UsagePeriod.week => _week(),
      UsagePeriod.month => _month(),
    };
  }

  UsageSeries _today() {
    const values = [0.8, 0.6, 0.9, 0.7, 1.3, 1.6, 2.7, 3.5, 3.7, 2.6];
    return UsageSeries(
      points: [
        for (var i = 0; i < values.length; i++)
          UsagePoint('${i.toString().padLeft(2, '0')}:00', values[i]),
      ],
      previousTotal: 20.9,
      budget: 22,
    );
  }

  UsageSeries _week() {
    const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    const values = [19.8, 21.4, 20.2, 22.1, 19.5, 20.9, 18.4];
    return UsageSeries(
      points: [
        for (var i = 0; i < days.length; i++) UsagePoint(days[i], values[i]),
      ],
      previousTotal: 148,
    );
  }

  UsageSeries _month() {
    return UsageSeries(
      points: [
        for (var i = 0; i < 30; i++)
          UsagePoint('${i + 1}', 17 + (i % 7) * 0.9 + (i * 3) * 0.4),
      ],
      previousTotal: 560,
    );
  }
}
