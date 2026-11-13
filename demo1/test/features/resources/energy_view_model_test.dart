import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/energy_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeResourceUsageRepository implements ResourceUsageRepository {
  @override
  Future<UsageSeries> getEnergy(UsagePeriod period) async {
    return const UsageSeries(
      points: [UsagePoint('today', 12)],
      previousTotal: 10,
    );
  }

  // If ResourceUsageRepository has other required methods, implement them here.
}

void main() {
  test('load gets energy data from the repository', () async {
    final viewModel = EnergyViewModel(FakeResourceUsageRepository());

    await viewModel.load();

    expect(viewModel.series?.total, 12);
    expect(viewModel.isLoading, false);
    expect(viewModel.error, isNull);

    viewModel.dispose();
  });
}
