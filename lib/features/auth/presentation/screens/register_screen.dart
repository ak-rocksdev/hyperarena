import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/validators.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/app_text_field.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+62');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go(AppRoutes.sportSelection);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    if (!config.useMockData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.construction, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: AppDimensions.base),
                Text(
                  'Pendaftaran akan tersedia segera',
                  style: AppTypography.headingSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Fitur pendaftaran sedang dalam pengembangan.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xl),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Kembali ke Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Soft branded header
                Container(
                  padding: const EdgeInsets.only(
                    top: AppDimensions.xl,
                    bottom: AppDimensions.xl,
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
                        Icons.person_add_outlined,
                        size: 72,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'Buat Akun Baru',
                        style: AppTypography.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Isi data di bawah untuk mulai bermain',
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
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: Validators.required,
                      ),
                      const SizedBox(height: AppDimensions.base),

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
                        controller: _phoneController,
                        label: 'Nomor Telepon',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: AppDimensions.base),

                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: Validators.minLength(6),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.base),

                      AppTextField(
                        controller: _confirmPasswordController,
                        label: 'Konfirmasi Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator:
                            Validators.passwordMatch(_passwordController.text),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSm),
                          boxShadow: AppShadows.colored,
                        ),
                        child: AppButton(
                          label: 'Daftar',
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
                            'Sudah punya akun? ',
                            style: AppTypography.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              'Masuk',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.xl),
                      Text(
                        'Beta Release v0.0.1',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.base),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
