import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadingsFooter extends StatelessWidget {
  const ReadingsFooter({super.key, required this.time});
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 14,
          color: AppColors.inkMuted,
        ),
        const SizedBox(width: 6),
        Text(
          'Illustrative readings . ${DateFormat('d MMM, HH:mm').format(time)}',
          style: AppType.caption,
        ),
      ],
    );
  }
}
