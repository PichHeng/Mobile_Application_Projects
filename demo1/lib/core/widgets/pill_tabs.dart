import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

class PillTabs extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.compact = false,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// true = ទម្រង់តូច (ផ្ទៃសក្នុងផ្លូវបៃតងស្រាល)
  /// false = ទម្រង់ធំ (ផ្ទៃបៃតងចាស់)
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 40.0 : 48.0;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.mintTint,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selectedIndex,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selectedIndex
                          ? (compact
                                ? AppColors.cardSurface
                                : AppColors.forestInk)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.chip.copyWith(
                        fontSize: 14,
                        color: i == selectedIndex
                            ? (compact ? AppColors.forestInk : AppColors.white)
                            : (compact
                                  ? AppColors.inkMuted
                                  : AppColors.forestInk),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
