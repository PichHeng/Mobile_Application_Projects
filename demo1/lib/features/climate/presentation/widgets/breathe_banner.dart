import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:demo1/features/climate/presentation/climate_labels.dart';
import 'package:flutter/material.dart';

class BreatheBanner extends StatelessWidget {
  const BreatheBanner({super.key, required this.today});
  final ClimateToday today;

  @override
  Widget build(BuildContext context) {
    final text = ventilationText(today);
    if (text == null) return const SizedBox.shrink();
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
              const Icon(Icons.air, size: 20, color: AppColors.white),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Letting the greenhouse breath',
                  style: AppType.bodyStrong.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: AppType.body.copyWith(color: soft)),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {
              // ???
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
                    'Manage climate targets',
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
