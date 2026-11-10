import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailingText,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppType.section)),
        if (trailingText != null)
          Text(
            trailingText!,
            style: AppType.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          )
        else if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: AppType.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
      ],
    );
  }
}
