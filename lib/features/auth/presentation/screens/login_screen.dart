import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_users.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/validators.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/app_text_field.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final useMock = ref.read(appConfigProvider).useMockData;
    // Pre-fill with mock credentials for fast dev login
    _emailController = TextEditingController(
      text: useMock ? MockUsers.currentUser.email : '',
    );
    _passwordController = TextEditingController(
      text: useMock ? MockUsers.mockPassword : '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
      // Router redirect handles navigation by role automatically
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _quickLogin(String email) {
    _emailController.text = email;
    _passwordController.text = MockUsers.mockPassword;
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Soft branded header
                  Container(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.xxl,
                      bottom: AppDimensions.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppDimensions.radiusXl),
                        bottomRight: Radius.circular(AppDimensions.radiusXl),
                      ),
                      boxShadow: AppShadows.xs,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_tennis,
                          size: 72,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Masuk ke HyperArena',
                          style: AppTypography.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'Booking lapangan olahraga jadi mudah',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxl),

                  // Form fields
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'contoh@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: AppDimensions.base),

                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: Validators.minLength(6),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xl),

                        // Button with colored glow
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSm),
                            boxShadow: AppShadows.colored,
                          ),
                          child: AppButton(
                            label: 'Masuk',
                            isLarge: true,
                            isLoading: _isLoading,
                            onPressed: _submit,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.base),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: AppTypography.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () => context.go('/auth/register'),
                              child: Text(
                                'Daftar',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Quick login buttons (mock only)
                        if (ref.read(appConfigProvider).useMockData) ...[
                          const SizedBox(height: AppDimensions.xl),
                          Divider(color: AppColors.neutral200),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            'Quick Login (Mock)',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Row(
                            children: [
                              Expanded(
                                child: _QuickLoginButton(
                                  label: 'Player',
                                  icon: Icons.person,
                                  color: AppColors.primary,
                                  onPressed: _isLoading
                                      ? null
                                      : () => _quickLogin(MockUsers.currentUser.email),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.sm),
                              Expanded(
                                child: _QuickLoginButton(
                                  label: 'Coach',
                                  icon: Icons.sports,
                                  color: AppColors.secondary,
                                  onPressed: _isLoading
                                      ? null
                                      : () => _quickLogin(MockUsers.coachUser.email),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Row(
                            children: [
                              Expanded(
                                child: _QuickLoginButton(
                                  label: 'Host',
                                  icon: Icons.event,
                                  color: AppColors.accent,
                                  onPressed: _isLoading
                                      ? null
                                      : () => _quickLogin(MockUsers.organizerUser.email),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.sm),
                              Expanded(
                                child: _QuickLoginButton(
                                  label: 'Owner',
                                  icon: Icons.store,
                                  color: AppColors.neutral500,
                                  onPressed: _isLoading
                                      ? null
                                      : () => _quickLogin(MockUsers.ownerUser.email),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppDimensions.xxl),
                        Text(
                          'Beta Release v0.0.1',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _QuickLoginButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      ),
    );
  }
}
