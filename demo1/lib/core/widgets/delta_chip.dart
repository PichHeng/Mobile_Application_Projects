import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

class DeltaChip extends StatelessWidget {
  const DeltaChip({
    super.key,
    required this.change,
    required this.suffix,
    this.lowerIsBetter = true,
  });

  /// -0.12 do it decreased 12%
  final double change;
  final String suffix;

  /// true សម្រាប់ថាមពល/ទឹក/ជី (ប្រើតិច = ល្អ)
  final bool lowerIsBetter;
  @override
  Widget build(BuildContext context) {
    final percent = (change.abs() * 100).round();
    final isGood = percent == 0 || (lowerIsBetter ? change < 0 : change > 0);
    final color = isGood ? AppColors.primary : AppColors.warning;
    final background = isGood ? AppColors.mintTint : AppColors.creamAlert;
    final text = percent == 0 ? 'No Chnage $suffix' : '$percent% $suffix';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (percent != 0) ...[
            Icon(
              change < 0 ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: color,
            ),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.chip.copyWith(color: color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
