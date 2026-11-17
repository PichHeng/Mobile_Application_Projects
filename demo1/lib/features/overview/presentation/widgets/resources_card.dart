import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:flutter/material.dart';

class ResourcesCard extends StatelessWidget {
  const ResourcesCard({
    super.key,
    required this.resources,
    this.onEnergyTap,
    this.onWaterTap,
    this.onFertilizerTap,
  });

  final ResourceSummary resources;
  final VoidCallback? onEnergyTap;
  final VoidCallback? onWaterTap;
  final VoidCallback? onFertilizerTap;

  String _energyNote(double change) {
    final percent = (change.abs() * 100).round();
    if (percent == 0) return 'Same as yesterday';
    return change < 0
        ? '$percent% less than yesterday'
        : '$percent% more than yesterday';
  }

  @override
  Widget build(BuildContext context) {
    final waterPercent = (resources.waterAllowanceUsed * 100).round();

    return Material(
      color: AppColors.cardSurface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          _ResourceRow(
            icon: Icons.bolt_outlined,
            title: 'Energy',
            subtitle: _energyNote(resources.energyChangeVsYesterday),
            value: formatReading(resources.energyKwh),
            unit: 'kWh',
            onTap: onEnergyTap,
          ),
          _ResourceRow(
            icon: Icons.water_drop_outlined,
            title: 'Water',
            subtitle: '$waterPercent% of daily allowance',
            value: formatReading(resources.waterLitres),
            unit: 'L',
            onTap: onWaterTap,
          ),
          _ResourceRow(
            icon: Icons.science_outlined,
            title: 'Fertilizer',
            subtitle: 'Concentrate used today',
            value: formatReading(resources.fertilizerLitres),
            unit: 'L',
            onTap: onFertilizerTap,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            IconTile(icon: icon),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppType.bodyStrong),
                  Text(subtitle, style: AppType.caption),
                ],
              ),
            ),
            Text(value, style: AppType.metricValue.copyWith(fontSize: 24)),
            const SizedBox(width: 4),
            Text(unit, style: AppType.caption),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.forestInk,
            ),
          ],
        ),
      ),
    );
  }
}
