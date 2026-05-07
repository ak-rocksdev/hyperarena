import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_animations.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/providers/session_join_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class SessionConfirmationScreen extends ConsumerStatefulWidget {
  const SessionConfirmationScreen({super.key});

  @override
  ConsumerState<SessionConfirmationScreen> createState() =>
      _SessionConfirmationScreenState();
}

class _SessionConfirmationScreenState
    extends ConsumerState<SessionConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.elastic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final joinState = ref.watch(sessionJoinProvider);
    final session = joinState.session;
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated success icon
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.md,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 48,
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              Text(
                'Berhasil Bergabung!',
                style: AppTypography.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),

              Text(
                'Kamu sudah terdaftar di sesi ini',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xl),

              // Summary card
              if (session != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.base),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLg),
                    boxShadow: AppShadows.sm,
                  ),
                  child: Column(
                    children: [
                      Text(
                        session.title,
                        style: AppTypography.titleSmall,
                      ),
                      Text(
                        session.venueName,
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        Formatters.formatDate(session.date),
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        Formatters.formatTimeRange(
                            session.startTime, session.endTime),
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        Formatters.formatCurrency(session.pricePerPerson, currency),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Buttons
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: AppShadows.colored,
                ),
                child: AppButton(
                  label: 'Kembali ke Explore',
                  isLarge: true,
                  onPressed: () {
                    ref.read(sessionJoinProvider.notifier).reset();
                    context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Kembali ke Beranda',
                  variant: AppButtonVariant.outlined,
                  isLarge: true,
                  onPressed: () {
                    ref.read(sessionJoinProvider.notifier).reset();
                    context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
