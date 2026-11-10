import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.creamAlert,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 22,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppType.bodyStrong.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: AppType.body),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warning,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    actionLabel,
                    style: AppType.bodyStrong.copyWith(
                      color: AppColors.warning,
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
