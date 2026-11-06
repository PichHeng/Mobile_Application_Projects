import 'package:demo1/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _family = 'Jua';
  static const List<String> _fallback = ['KantumruyPro'];

  static const TextStyle title = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 32,
    height: 1.4,
    color: AppColors.textOnDark,
  );
}
