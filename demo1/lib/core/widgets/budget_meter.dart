import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:flutter/material.dart';

class BudgetMeter extends StatelessWidget {
  const BudgetMeter({
    super.key,
    required this.title,
    required this.used,
    required this.budget,
    required this.unit,
  });

  final String title;
  final double used;
  final double budget;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final remaining = budget - used;
    final isOver = remaining < 0;
    final fraction = budget <= 0
        ? 1.0
        : (used / budget).clamp(0.0, 1.0).toDouble();
    final fill = isOver ? AppColors.warning : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: AppType.body)),
            Text(
              '${formatReading(used)} / ${formatReading(budget)} $unit ',
              style: AppType.bodyStrong.copyWith(fontSize: 14),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: SizedBox(
            height: 8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.mintTint),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fraction,
                  child: ColoredBox(color: fill),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                isOver
                    ? '${formatReading(remaining.abs())} $unit over'
                    : '${formatReading(remaining)} $unit remaining',
                style: AppType.caption,
              ),
            ),
            Text(
              isOver ? 'Over budget' : 'within Budget',
              style: AppType.caption.copyWith(
                color: fill,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
