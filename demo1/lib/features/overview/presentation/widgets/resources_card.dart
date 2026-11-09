import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:flutter/material.dart';

class ResourcesCard extends StatelessWidget {
  const ResourcesCard({super.key, required this.resources});

  final ResourceSummary resources;

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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          _ResourceRow(
            icon: Icons.bloodtype_outlined,
            title: 'Energy',
            subtitle: _energyNote(resources.energyChangeVsYesterday),
            value: formatReading(resources.energyKwh),
            unit: 'kWh',
          ),
          const SizedBox(height: AppSpacing.md),
          _ResourceRow(
            icon: Icons.water_drop_outlined,
            title: 'Water',
            subtitle: '$waterPercent% of daily allowance',
            value: formatReading(resources.waterLitres),
            unit: 'L',
          ),
          const SizedBox(height: AppSpacing.md),
          _ResourceRow(
            icon: Icons.science_outlined,
            title: 'Fertilizer',
            subtitle: 'Concentrate used today',
            value: formatReading(resources.fertilizerLitres),
            unit: 'L',
          ),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String unit;

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
              Text(subtitle, style: AppType.caption),
            ],
          ),
        ),
        Text(value, style: AppType.metricValue.copyWith(fontSize: 24)),
        const SizedBox(width: 4),
        Text(unit, style: AppType.caption),
        const SizedBox(width: AppSpacing.sm),
        const Icon(Icons.chevron_right, size: 20, color: AppColors.forestInk),
      ],
    );
  }
}
