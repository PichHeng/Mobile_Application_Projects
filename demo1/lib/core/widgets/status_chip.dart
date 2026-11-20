import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

enum ChipTone { good, warning }

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.tone = ChipTone.good});

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final good = tone == ChipTone.good;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: good ? AppColors.mintTint : AppColors.creamAlert,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.chip.copyWith(
          color: good ? AppColors.primary : AppColors.warning,
        ),
      ),
    );
  }
}
