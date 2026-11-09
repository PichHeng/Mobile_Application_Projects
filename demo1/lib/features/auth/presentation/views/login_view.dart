import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_text_styles.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/glass_text_field.dart';
import 'package:demo1/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    final vm = context.read<LoginViewModel>();
    final ok = await vm.signIn(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login success')));
    }
  }

  String _errorText(LoginError error) {
    switch (error) {
      case LoginError.emptyIdentifier:
        return 'Please enter your phone number or email';
      case LoginError.passwordTooShort:
        return 'Password must be at least 6 characters';
      case LoginError.invalidCredentials:
        return 'Wrong phone/email or password';
      case LoginError.network:
        return 'Something went wrong. Please try again';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

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
                    hint: 'Phone number or email',
                    icon: Icons.person_outline,
                    controller: _identifierController,
                  ),
                  const SizedBox(height: AppSpacing.fieldGap),
                  GlassTextField(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  if (vm.error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _errorText(vm.error!),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: vm.rememberMe,
                              onChanged: (v) => vm.toggleRememberMe(v ?? false),
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
                        onPressed: () {
                          // TODO មេរៀនទី ៥: ទៅទំព័រ Sign Up
                        },
                        child: const Text(
                          "don't have an account?",
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Sign In',
                    isLoading: vm.isLoading,
                    onPressed: _onSignIn,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'I want to inform you all your privacy will be saved '
                      'onto our database and we will provide you a safety '
                      'use for this app',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption,
                    ),
                  ),
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
