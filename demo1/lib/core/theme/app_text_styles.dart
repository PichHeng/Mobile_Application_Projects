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

  static const TextStyle subtitle = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 20,
    height: 1.4,
    color: AppColors.textOnDark,
  );

  // ⚠️ ពណ៌ងងឹត ព្រោះប៊ូតុងមានផ្ទៃស
  static const TextStyle button = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 20,
    height: 1.4,
    color: AppColors.textOnButton,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    height: 1.5,
    color: AppColors.textOnDark,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    height: 1.5,
    color: AppColors.glassHint,
  );

  // ១២ មិនមែន ១០ ដើម្បីងាយអានក្រោមពន្លឺថ្ងៃ
  static const TextStyle caption = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 12,
    height: 1.5,
    color: AppColors.textOnDark,
  );

  static const TextStyle link = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    height: 1.5,
    color: AppColors.textOnDark,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.textOnDark,
  );
}
