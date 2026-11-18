// heart of the units
import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:flutter/material.dart';

/// ប័ណ្ណ "usage" ដែលប្រើដោយ Energy, Water និង Fertilizer
/// ខុសគ្នាត្រង់ chart, ធាតុខាងស្តាំលេខធំ, caption និងបាតប័ណ្ណ
/// ដែលអ្នកប្រើផ្តល់ជា builder
class UsageCard extends StatelessWidget {
  const UsageCard({
    super.key,
    required this.title,
    required this.period,
    required this.onPeriodChanged,
    required this.series,
    required this.hasError,
    required this.onRetry,
    required this.unit,
    required this.chartBuilder,
    this.trailingBuilder,
    this.captionBuilder,
    this.footerBuilder,
    this.loadingHeight = 260,
  });
  final String title;
  final UsagePeriod period;
  final ValueChanged<UsagePeriod> onPeriodChanged;

  /// null មានន័យថាកំពុងផ្ទុក
  final UsageSeries? series;
  final bool hasError;
  final VoidCallback onRetry;
  final String unit;
  final double loadingHeight;
  final Widget Function(UsageSeries series) chartBuilder;
  final Widget? Function(UsageSeries series)? trailingBuilder;
  final String? Function(UsageSeries series)? captionBuilder;
  final Widget? Function(UsageSeries series)? footerBuilder;

  static const _periods = [
    UsagePeriod.today,
    UsagePeriod.week,
    UsagePeriod.month,
  ];

  @override
  Widget build(BuildContext context) {
    final data = series;
    final trailing = data == null ? null : trailingBuilder?.call(data);
    final caption = data == null ? null : captionBuilder?.call(data);
    final footer = data == null ? null : footerBuilder?.call(data);

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
              Expanded(child: Text(title, style: AppType.bodyStrong)),
              SizedBox(
                width: 210,
                child: PillTabs(
                  compact: true,
                  labels: const ['Today', '7 days', 'Month'],
                  selectedIndex: _periods.indexOf(period),
                  onChanged: (i) => onPeriodChanged(_periods[i]),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasError)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Could not load data', style: AppType.bodyStrong),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: 'Try again', onPressed: onRetry),
              ],
            )
          else if (data == null)
            SizedBox(
              height: loadingHeight,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatReading(data.total),
                          style: AppType.metricValue,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            unit,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppType.label,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trailing,
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            chartBuilder(data),
            if (caption != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(caption, style: AppType.caption),
            ],
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.md),
              footer,
            ],
          ],
        ],
      ),
    );
  }
}
