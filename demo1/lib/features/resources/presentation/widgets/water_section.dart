import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/delta_chip.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/usage_labels.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterSection extends StatelessWidget {
  const WaterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          WaterViewModel(ctx.read<ResourceUsageRepository>())..load(),
      child: const Column(children: [_UsageCard(), _ZonesSection()]),
    );
  }
}

class _UsageCard extends StatelessWidget {
  const _UsageCard();

  static const _periods = [
    UsagePeriod.today,
    UsagePeriod.week,
    UsagePeriod.month,
  ];

  String _unit(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'L today',
    UsagePeriod.week => 'L in 7 days',
    UsagePeriod.month => 'L in 30 days',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterViewModel>();
    final series = vm.series;
    final left = series?.budgetRemaining;

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
                child: Text('Water used', style: AppType.bodyStrong),
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
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else ...[
            Row(
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatReading(series.total),
                        style: AppType.metricValue,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _unit(vm.period),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.label,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DeltaChip(
                  change: series.changeVsPrevious,
                  suffix: comparisonLabel(vm.period),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mintTint,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Text(
                'Chart arrives in the next lesson',
                style: AppType.caption,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              left == null
                  ? 'Cumulative usage'
                  : 'Cumulative usage · ${formatReading(left)} L left '
                        "in today's allowance",
              style: AppType.caption,
            ),
          ],
        ],
      ),
    );
  }
}

class _ZonesSection extends StatelessWidget {
  const _ZonesSection();

  String _usedLabel(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'used today',
    UsagePeriod.week => 'used in 7 days',
    UsagePeriod.month => 'used in 30 days',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterViewModel>();
    final report = vm.report;
    if (report == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'Irrigation zones',
          trailingText: report.allValvesClosed
              ? 'All valves closed'
              : '${report.openValves} valves open',
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            children: [
              for (var i = 0; i < report.zones.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.md),
                _ZoneRow(
                  zone: report.zones[i],
                  usedLabel: _usedLabel(vm.period),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({required this.zone, required this.usedLabel});

  final WaterZone zone;
  final String usedLabel;

  @override
  Widget build(BuildContext context) {
    final dry = zone.isDry;
    final mode = zone.mode == IrrigationMode.auto ? 'Auto' : 'Manual';

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: dry ? AppColors.creamAlert : AppColors.mintTint,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Text(
            zone.letter,
            style: AppType.bodyStrong.copyWith(
              color: dry ? AppColors.warning : AppColors.forestInk,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(zone.name, style: AppType.bodyStrong),
              Text(
                'Moisture ${formatReading(zone.moisture)}% · $mode',
                style: AppType.caption.copyWith(
                  color: dry ? AppColors.warning : null,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${formatReading(zone.litres)} L', style: AppType.bodyStrong),
            Text(usedLabel, style: AppType.caption),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(
          dry ? Icons.warning_amber_rounded : Icons.chevron_right,
          size: 20,
          color: dry ? AppColors.warning : AppColors.forestInk,
        ),
      ],
    );
  }
}
