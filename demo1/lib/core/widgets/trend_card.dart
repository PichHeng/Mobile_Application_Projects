import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/widgets/sparkline.dart';
import 'package:flutter/material.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.caption,
    required this.targetText,
    required this.values,
    this.isInRange = true,
  });

  final String label;
  final IconData icon;
  final String value;
  final String caption;
  final String targetText;
  final List<double> values;
  final bool isInRange;

  @override
  Widget build(BuildContext context) {
    final tone = isInRange ? AppColors.primary : AppColors.warning;

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
                  label,
                  style: AppType.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 20, color: AppColors.forestInk),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, maxLines: 1, style: AppType.metricValue),
          ),
          Text(
            caption,
            style: AppType.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          Sparkline(values: values, color: tone),
          const SizedBox(height: AppSpacing.sm),
          Text(
            targetText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.caption.copyWith(
              color: tone,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
