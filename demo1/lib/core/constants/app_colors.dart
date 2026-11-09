import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ស្រទាប់ ១: Palette (ពណ៌ឆៅ)
  static const Color forestDeep = Color(0xFF163F32);
  static const Color forestShadow = Color(0xFF203B30);
  static const Color leafGreen = Color(0xFF286448);
  static const Color leafLight = Color(0xFFA1D99B);
  static const Color limePale = Color(0xFFD9EAA9);
  static const Color soilBrown = Color(0xFF9A662D);
  static const Color nightNavy = Color(0xFF111D2B);
  static const Color stoneGrey = Color(0xFF748078);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  // ស្រទាប់ ២: Semantic (តួនាទី)
  // ម៉ាកយីហោ
  static const Color primary = leafGreen;
  static const Color primaryDark = forestDeep;
  static const Color secondary = leafLight;
  static const Color accent = soilBrown;
  static const Color highlight = limePale;
  static const Color brandDark = nightNavy; // ផ្ទៃ logo

  // ផ្ទៃ
  static const Color surfaceDark = forestShadow;
  static const Color buttonSurface = white; // ប៊ូតុង Sign In

  // អក្សរ
  static const Color textPrimary = black;
  static const Color textOnDark = white;
  static const Color textOnButton = nightNavy; // អក្សរលើប៊ូតុងស
  static const Color textMuted = stoneGrey;

  // ============================================================
  // GLASS (ប្រើជាមួយ Glassmorphism)
  // 0x33 ≈ 20% opacity, 0x66 ≈ 40% opacity
  // ============================================================
  static const Color glassFill = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x66FFFFFF);
  static const Color glassHint = Color(0xB3FFFFFF); // ~70% សម្រាប់ placeholder

  // new colors
  static const Color scrim = Color(0x26000000); // ខ្មៅ ~15%
  static const Color error = Color(0xFFFFB4A9); // ក្រហមស្រាល អានបានលើរូបស្លឹកឈើ

  // ===== Verdant (ទំព័រក្នុង app) =====
  static const Color pageBackground = Color(0xFFF5F4EC);
  static const Color cardSurface = Color(0xFFFFFDF7);
  static const Color forestInk = Color(0xFF234E3F);
  static const Color forestInkSoft = Color(0xFF233F34);
  static const Color mintTint = Color(0xFFE6ECDD);
  static const Color creamAlert = Color(0xFFF5EACF);
  static const Color sage = Color(0xFF9FAF7D);

  static const Color inkMuted = stoneGrey; // អក្សរប្រផេះ
  static const Color warning = soilBrown; // ព្រមាន "Needs care"
}
