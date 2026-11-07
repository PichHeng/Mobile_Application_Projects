import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_text_styles.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/glass_text_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // បណ្តោះអាសន្ន: មេរៀនទី ៤ នឹងផ្លាស់ទៅ ViewModel
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          const ColoredBox(color: AppColors.scrim),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: AppSpacing.xxl),
                  const Text(
                    'Login to your account',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GlassTextField(
                    hint: 'Enter your username',
                    icon: Icons.person_outline,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  GlassTextField(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                              checkColor: AppColors.textOnButton,
                              fillColor: WidgetStateProperty.resolveWith(
                                (states) =>
                                    states.contains(WidgetState.selected)
                                    ? AppColors.buttonSurface
                                    : AppColors.glassFill,
                              ),
                              side: const BorderSide(
                                color: AppColors.glassBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small / 2,
                                ),
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                'remember me',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "don't have an account?",
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(label: 'Sign In', onPressed: () {}),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.brandDark,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: const Icon(
                Icons.eco_outlined,
                color: AppColors.textOnDark,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text('Plants', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.md),
            child: Text(
              'Welcome to plants world\nManage & Care',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ),
        ),
      ],
    );
  }
}
