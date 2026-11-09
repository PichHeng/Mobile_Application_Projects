import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ClimateView extends StatelessWidget {
  const ClimateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Climate',
            style: AppTextStyles.title.copyWith(color: AppColors.forestInk),
          ),
        ),
      ),
    );
  }
}
