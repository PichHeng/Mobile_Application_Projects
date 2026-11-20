import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/core/widgets/trend_line_chart.dart';
import 'package:demo1/features/climate/data/models/climate_series.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:demo1/features/climate/presentation/viewmodels/climate_chart_view_model.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CloserLookSection extends StatelessWidget {
  const CloserLookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClimateChartViewModel>();

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('A closer look', style: AppType.section),
            ),
            PopupMenuButton<ClimateMetric>(
              tooltip: 'Choose a measurement',
              onSelected: vm.selectMetric,
              itemBuilder: (_) => [
                for (final m in ClimateMetric.values)
                  PopupMenuItem(value: m, child: Text(metricLabel(m))),
              ],
              child: SizedBox(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      metricLabel(vm.metric),
                      style: AppType.chip.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(
                      Icons.expand_more,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ChartCard(vm: vm),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.vm});

  final ClimateChartViewModel vm;

  static const _periods = [
    UsagePeriod.today,
    UsagePeriod.week,
    UsagePeriod.month,
  ];

  @override
  Widget build(BuildContext context) {
    final series = vm.series;

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
              Expanded(
                child: Text(
                  metricLabel(vm.metric),
                  style: AppType.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
            _ValueRow(series: series),
            const SizedBox(height: AppSpacing.lg),
            TrendLineChart(
              points: series.points,
              bandMin: series.reading.min,
              bandMax: series.reading.max,
              xInterval: xIntervalFor(series.period),
              xLabel: xLabelFor(series.period),
              unit: metricUnit(series.metric),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Shaded band: target '
                    '${rangeText(series.metric, series.reading)}',
                    style: AppType.caption,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.series});

  final ClimateSeries series;

  @override
  Widget build(BuildContext context) {
    final shown = shownValue(series);
    final change = changeLine(series);

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              shown == null ? '–' : formatReading(shown),
              style: AppType.metricValue,
            ),
            const SizedBox(width: 6),
            Text(valueSuffix(series), style: AppType.label),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: change == null
                ? const SizedBox.shrink()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (change.icon != null) ...[
                        Icon(change.icon, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          change.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
