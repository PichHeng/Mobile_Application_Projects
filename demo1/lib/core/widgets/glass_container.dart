import 'dart:ui';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_glass.dart';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.medium,
    this.padding,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppGlass.blur, sigmaY: AppGlass.blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: radius,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: child,
        ),
      ),
    );
  }
}
