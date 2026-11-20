import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({super.key, this.title = "Greenhouse 01"});
  final String title;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/overview');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: () => _back(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.forestInk),
        ),
        Text(title, style: AppType.body),
        const Spacer(),
        const StatusChip(label: 'DEMO'),
      ],
    );
  }
}
