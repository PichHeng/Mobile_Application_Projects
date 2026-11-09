import 'package:demo1/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppType {
  AppType._();

  // ចាំបាច់សម្រាប់ភាសាខ្មែរនៅពេលក្រោយ
  static const List<String> _fallback = ['KantumruyPro'];

  // ===== Serif (Lora) =====
  static const TextStyle brand = TextStyle(
    fontFamily: 'Lora',
    fontFamilyFallback: _fallback,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.forestInk,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: 'Lora',
    fontFamilyFallback: _fallback,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.forestInk,
  );

  // ===== Sans (DM Sans) =====
  static const TextStyle section = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.forestInk,
  );

  static const TextStyle metricValue = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.1,
    color: AppColors.forestInk,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.forestInk,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.forestInk,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: 'DMSans',
    fontFamilyFallback: _fallback,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.forestInk,
  );
}
