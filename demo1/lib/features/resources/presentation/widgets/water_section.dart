import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/delta_chip.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/data/repositories/irrigation_repository.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/usage_labels.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_controls_view_model.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_view_model.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_card.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_line_chart.dart';
import 'package:demo1/features/resources/presentation/widgets/water_io_section.dart';
// import 'package:demo1/features/resources/presentation/widgets/water_io_section.dart';
import 'package:demo1/features/resources/presentation/widgets/water_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterSection extends StatelessWidget {
  const WaterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              WaterViewModel(ctx.read<ResourceUsageRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              WaterControlsViewModel(ctx.read<IrrigationRepository>())..load(),
        ),
      ],
      child: const Column(
        children: [
          _WaterUsageCard(),
          _ZonesSection(),
          WaterInputsSection(),
          WaterOutputsSection(),
          WaterScheduleSection(),
        ],
      ),
    );
  }
}

class _WaterUsageCard extends StatelessWidget {
  const _WaterUsageCard();

  String _unit(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'L today',
    UsagePeriod.week => 'L in 7 days',
    UsagePeriod.month => 'L in 30 days',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterViewModel>();

    return UsageCard(
      title: 'Water used',
      period: vm.period,
      onPeriodChanged: vm.selectPeriod,
      series: vm.series,
      hasError: vm.error != null,
      onRetry: vm.load,
      unit: _unit(vm.period),
      loadingHeight: 200,
      chartBuilder: (s) => UsageLineChart(points: s.cumulativePoints),
      trailingBuilder: (s) => DeltaChip(
        change: s.changeVsPrevious,
        suffix: comparisonLabel(vm.period),
      ),
      captionBuilder: (s) {
        final left = s.budgetRemaining;
        return left == null
            ? 'Cumulative usage'
            : "Cumulative usage · ${formatReading(left)} L left in today's allowance";
      },
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
