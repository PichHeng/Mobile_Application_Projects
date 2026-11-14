import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/widgets/segmented_bar.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({super.key, required this.health});
  final PlantHealthSummary health;

  @override
  Widget build(BuildContext context) {
    final soft = AppColors.white.withValues(alpha: 0.7);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Healthy plants',
                      style: AppType.label.copyWith(color: soft),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${health.healthyPercent}%',
                          style: AppType.metricValue.copyWith(
                            color: AppColors.white,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            '${health.healthy} of ${health.total} plants',
                            style: AppType.label.copyWith(color: soft),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.spa_outlined, size: 32, color: soft),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedBar(
            segments: [
              BarSegment(health.healthy, AppColors.healthHealthy),
              BarSegment(health.watch, AppColors.healthWatch),
              BarSegment(health.attention, AppColors.healthAttenstion),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${health.watch} to watch · '
            '${health.attention} need a closer look',
            style: AppType.caption.copyWith(color: soft),
          ),
        ],
      ),
    );
  }
}
