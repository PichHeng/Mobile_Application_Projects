import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/core/widgets/segmented_bar.dart';
import 'package:demo1/features/resources/data/models/energy_report.dart';
import 'package:demo1/features/resources/presentation/usage_labels.dart';
import 'package:demo1/features/resources/presentation/viewmodels/energy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnergyDetails extends StatelessWidget {
  const EnergyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnergyViewModel>();
    final report = vm.report;
    if (report == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        _StatsRow(report: report, comparison: comparisonLabel(vm.period)),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'Where it goes',
          trailingText: '${report.consumers.length} systems',
        ),
        const SizedBox(height: AppSpacing.md),
        _BreakdownCard(report: report),
        const SizedBox(height: AppSpacing.lg),
        const _DaylightBanner(),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.report, required this.comparison});

  final EnergyReport report;
  final String comparison;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final saved = report.savedKwh;
    final isSaving = saved >= 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.paid_outlined,
              value: money.format(report.estimatedCost),
              caption: 'Est. cost · ${money.format(report.ratePerKwh)}/kWh',
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _StatTile(
              icon: Icons.eco_outlined,
              value: '${formatReading(saved.abs())} kWh',
              caption: '${isSaving ? 'Saved' : 'Extra'} $comparison',
              captionColor: isSaving ? null : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.caption,
    this.captionColor,
  });

  final IconData icon;
  final String value;
  final String caption;
  final Color? captionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.mintTint,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.forestInk),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: AppType.metricValue.copyWith(fontSize: 28),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(caption, style: AppType.caption.copyWith(color: captionColor)),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.report});

  final EnergyReport report;

  static const _barColors = [
    AppColors.forestInk,
    AppColors.primary,
    AppColors.sage,
    AppColors.healthWatch,
  ];

  static String _title(ConsumerKind kind) => switch (kind) {
    ConsumerKind.growLights => 'Grow lights',
    ConsumerKind.ventilation => 'Ventilation',
    ConsumerKind.irrigation => 'Irrigation',
    ConsumerKind.climateControl => 'Climate control',
  };

  static IconData _icon(ConsumerKind kind) => switch (kind) {
    ConsumerKind.growLights => Icons.light_mode_outlined,
    ConsumerKind.ventilation => Icons.air,
    ConsumerKind.irrigation => Icons.water_drop_outlined,
    ConsumerKind.climateControl => Icons.thermostat,
  };

  @override
  Widget build(BuildContext context) {
    final consumers = report.consumers;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          SegmentedBar(
            gap: 3,
            segments: [
              for (var i = 0; i < consumers.length; i++)
                BarSegment(
                  (consumers[i].kwh * 100).round(),
                  _barColors[i % _barColors.length],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < consumers.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            _ConsumerRow(
              icon: _icon(consumers[i].kind),
              title: _title(consumers[i].kind),
              detail: consumers[i].detail,
              kwh: formatReading(consumers[i].kwh),
              percent: report.sharePercent(consumers[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConsumerRow extends StatelessWidget {
  const _ConsumerRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.kwh,
    required this.percent,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String kwh;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconTile(icon: icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppType.bodyStrong),
              Text(detail, style: AppType.caption),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$kwh kWh', style: AppType.bodyStrong),
            Text('$percent% of total', style: AppType.caption),
          ],
        ),
      ],
    );
  }
}

class _DaylightBanner extends StatelessWidget {
  const _DaylightBanner();

  @override
  Widget build(BuildContext context) {
    final soft = AppColors.white.withValues(alpha: 0.75);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.forestInk,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                size: 20,
                color: AppColors.white,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Working with the daylight',
                  style: AppType.bodyStrong.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // អត្ថបទថេរសម្រាប់ mock។ ក្រោយមកវាមកពីកាលវិភាគពិត
          Text(
            'Grow lights are dimmed to 65% while natural light is strong. '
            'The next scheduled switch-off is at 18:00.',
            style: AppType.body.copyWith(color: soft),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {
              // TODO: ទៅទំព័រកាលវិភាគភ្លើង
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.white,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'View lighting schedule',
                    style: AppType.bodyStrong.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
