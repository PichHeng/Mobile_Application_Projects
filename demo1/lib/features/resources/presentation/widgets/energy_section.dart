import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/budget_meter.dart';
import 'package:demo1/core/widgets/delta_chip.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/energy_view_model.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnergySection extends StatelessWidget {
  const EnergySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          EnergyViewModel(ctx.read<ResourceUsageRepository>())..load(),
      child: const _EnergyBody(),
    );
  }
}

class _EnergyBody extends StatelessWidget {
  const _EnergyBody();

  static const _periods = [
    UsagePeriod.today,
    UsagePeriod.week,
    UsagePeriod.month,
  ];

  String _comparison(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'vs yesterday',
    UsagePeriod.week => 'vs previous 7 days',
    UsagePeriod.month => 'vs previous 30 days',
  };

  String _caption(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'Hourly usage · last hour in progress',
    UsagePeriod.week => 'Daily usage · today in progress',
    UsagePeriod.month => 'Daily usage · last 30 days',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnergyViewModel>();
    final series = vm.series;
    final budget = series?.budget;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Electricity consumed', style: AppType.bodyStrong),
              ),
              SizedBox(
                width: 210,
                child: PillTabs(
                  compact: true,
                  labels: const ['Today', '7 days', 'Month'],
                  selectedIndex: _periods.indexOf(vm.period),
                  onChanged: (i) => vm.selectPeriod(_periods[i]),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (vm.error != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Could not load data', style: AppType.bodyStrong),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: 'Try again', onPressed: () => vm.load()),
              ],
            )
          else if (series == null)
            const SizedBox(
              height: 260,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else ...[
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      formatReading(series.total),
                      style: AppType.metricValue,
                    ),
                    const SizedBox(width: 6),
                    const Text('kWh', style: AppType.label),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DeltaChip(
                      change: series.changeVsPrevious,
                      suffix: _comparison(vm.period),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            UsageBarChart(points: series.points),
            const SizedBox(height: AppSpacing.sm),
            Text(_caption(vm.period), style: AppType.caption),
            if (budget != null) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(color: AppColors.mintTint, height: 1),
              const SizedBox(height: AppSpacing.md),
              BudgetMeter(
                title: 'Daily budget',
                used: series.total,
                budget: budget,
                unit: 'kWh',
              ),
            ],
          ],
        ],
      ),
    );
  }
}
