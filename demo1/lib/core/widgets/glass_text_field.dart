import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_text_styles.dart';
import 'package:demo1/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class GlassTextField extends StatefulWidget {
  const GlassTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        style: AppTextStyles.body,
        cursorColor: AppColors.textOnDark,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: AppTextStyles.hint,
          prefixIcon: Icon(widget.icon, color: AppColors.textOnDark),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textOnDark,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
    );
  }
}
