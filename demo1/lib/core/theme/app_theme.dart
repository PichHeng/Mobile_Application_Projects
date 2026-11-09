import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_text_styles.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// Theme លំនាំដើមរបស់ app (Verdant: ក្រែម + បៃតងចាស់)
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'DMSans',
      fontFamilyFallback: const ['KantumruyPro'],
      scaffoldBackgroundColor: AppColors.pageBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forestInk,
        primary: AppColors.forestInk,
        onPrimary: AppColors.white,
        secondary: AppColors.sage,
        onSecondary: AppColors.forestInk,
        surface: AppColors.cardSurface,
        onSurface: AppColors.forestInk,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.mintTint,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: 'DMSans',
            fontFamilyFallback: const ['KantumruyPro'],
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.forestInk : AppColors.inkMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.forestInk : AppColors.inkMuted,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestInk,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          elevation: 0,
          textStyle: AppType.bodyStrong,
        ),
      ),
    );
  }

  /// Theme សម្រាប់ទំព័រ Login (កញ្ចក់ លើរូបស្លឹកឈើ)
  static ThemeData get glass {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Jua',
      fontFamilyFallback: const ['KantumruyPro'],
      scaffoldBackgroundColor: AppColors.primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textOnDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonSurface,
          foregroundColor: AppColors.textOnButton,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          elevation: 0,
          textStyle: AppTextStyles.button,
        ),
      ),
    );
  }
}
