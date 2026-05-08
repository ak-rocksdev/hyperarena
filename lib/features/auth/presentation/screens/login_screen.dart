import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/validators.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/app_text_field.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    AppHaptics.tap();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
      // Router redirect handles navigation by role automatically
    } on ValidationException catch (e) {
      if (mounted) {
        // Backend returns 422 for invalid credentials with errors.email
        final emailError = e.errors['email']?.firstOrNull as String?;
        final message = emailError ?? e.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } on UnauthorizedException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi kadaluarsa, silakan login ulang')),
        );
      }
    } on ServerException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server sedang bermasalah, coba lagi')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message.isNotEmpty ? e.message : 'Login gagal')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login gagal, coba lagi')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                        const SizedBox(height: AppDimensions.xs),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.forgotPassword),
                            child: Text(
                              'Lupa Password?',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: AppTypography.bodyMedium,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () => context.go(AppRoutes.register),
                                child: Text(
                                  'Daftar',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

