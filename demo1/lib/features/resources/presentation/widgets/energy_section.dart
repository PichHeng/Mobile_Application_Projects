import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/widgets/budget_meter.dart';
import 'package:demo1/core/widgets/delta_chip.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/usage_labels.dart';
import 'package:demo1/features/resources/presentation/viewmodels/energy_view_model.dart';
import 'package:demo1/features/resources/presentation/widgets/energy_details.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_bar_chart.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnergySection extends StatelessWidget {
  const EnergySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          EnergyViewModel(ctx.read<ResourceUsageRepository>())..load(),
      child: const Column(children: [_EnergyUsageCard(), EnergyDetails()]),
    );
  }
}

class _EnergyUsageCard extends StatelessWidget {
  const _EnergyUsageCard();

  String _caption(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'Hourly usage · last hour in progress',
    UsagePeriod.week => 'Daily usage · today in progress',
    UsagePeriod.month => 'Daily usage · last 30 days',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnergyViewModel>();

    return UsageCard(
      title: 'Electricity consumed',
      period: vm.period,
      onPeriodChange: vm.selectPeriod,
      series: vm.series,
      hasError: vm.error != null,
      onRetry: vm.load,
      unit: 'kWh',
      chartBuilder: (s) => UsageBarChart(points: s.points),
      trailingBuilder: (s) => DeltaChip(
        change: s.changeVsPrevious,
        suffix: comparisonLabel(vm.period),
      ),
      captionBuilder: (_) => _caption(vm.period),
      footerBuilder: (s) {
        final budget = s.budget;
        if (budget == null) return null;
        return Column(
          children: [
            const Divider(color: AppColors.mintTint, height: 1),
            const SizedBox(height: AppSpacing.md),
            BudgetMeter(
              title: 'Daily budget',
              used: s.total,
              budget: budget,
              unit: 'kWh',
            ),
          ],
        );
      },
    );
  }
}
