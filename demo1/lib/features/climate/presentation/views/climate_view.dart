import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/readings_footer.dart';
import 'package:demo1/core/widgets/screen_top_bar.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/core/widgets/status_chip.dart';
import 'package:demo1/core/widgets/trend_card.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/data/repositories/climate_repository.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:demo1/features/climate/presentation/viewmodels/climate_chart_view_model.dart';
import 'package:demo1/features/climate/presentation/viewmodels/climate_view_model.dart';
import 'package:demo1/features/climate/presentation/widgets/breathe_banner.dart';
import 'package:demo1/features/climate/presentation/widgets/closer_look_section.dart';
import 'package:demo1/features/climate/presentation/widgets/zone_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClimateView extends StatelessWidget {
  const ClimateView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              ClimateViewModel(ctx.read<ClimateRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ClimateChartViewModel(ctx.read<ClimateRepository>())..load(),
        ),
      ],
      child: const _ClimateBody(),
    );
  }
}

class _ClimateBody extends StatelessWidget {
  const _ClimateBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClimateViewModel>();
    final today = vm.today;

    return Scaffold(
      body: SafeArea(
        child: today == null
            ? _Placeholder(vm: vm)
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  const ScreenTopBar(),
                  const SizedBox(height: AppSpacing.md),
                  const Text('A climate for growth', style: AppType.headline),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Ambient monitoring · Greenhouse 01',
                    style: AppType.label,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Summary(today: today),
                  const SizedBox(height: AppSpacing.md),
                  _TrendGrid(today: today),
                  const SizedBox(height: AppSpacing.sm),
                  Text(trendsCaption(today), style: AppType.caption),
                  const SizedBox(height: AppSpacing.xl),
                  const CloserLookSection(),
                  if (today.zones.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: 'Across the greenhouse'),
                    const SizedBox(height: AppSpacing.md),
                    ZoneTable(today: today),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  BreatheBanner(today: today),
                  const SizedBox(height: AppSpacing.xl),
                  ReadingsFooter(time: vm.now),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.vm});

  final ClimateViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load data', style: AppType.bodyStrong),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Try again', onPressed: () => vm.load()),
            ],
          ),
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.today});

  final ClimateToday today;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.home_work_outlined,
          size: 20,
          color: AppColors.forestInk,
        ),
        const SizedBox(width: AppSpacing.sm),
        // ឥឡូវនេះជាស្លាកប៉ុណ្ណោះ មិនមែន dropdown ពិតទេ
        const Expanded(child: Text('All zones', style: AppType.bodyStrong)),
        StatusChip(
          label: '${today.inRangeCount} of ${today.total} in range',
          tone: today.allInRange ? ChipTone.good : ChipTone.warning,
        ),
      ],
    );
  }
}

class _TrendGrid extends StatelessWidget {
  const _TrendGrid({required this.today});

  final ClimateToday today;

  Widget _card(ClimateMetric metric) {
    final trend = today.trendOf(metric);
    return TrendCard(
      label: metricLabel(metric),
      icon: metricIcon(metric),
      value: formatReading(trend.reading.value),
      caption: metricCaption(metric),
      targetText: targetText(trend),
      values: trend.values,
      isInRange: trend.reading.isInRange,
    );
  }

  Widget _row(ClimateMetric a, ClimateMetric b) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _card(a)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _card(b)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(ClimateMetric.temperature, ClimateMetric.humidity),
        const SizedBox(height: AppSpacing.md),
        _row(ClimateMetric.light, ClimateMetric.co2),
      ],
    );
  }
}
