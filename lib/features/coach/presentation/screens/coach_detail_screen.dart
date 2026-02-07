import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/presentation/widgets/package_card.dart';
import 'package:hyperarena/features/coach/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_detail_provider.dart';

class CoachDetailScreen extends ConsumerWidget {
  final String coachId;

  const CoachDetailScreen({super.key, required this.coachId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coachAsync = ref.watch(coachDetailProvider(coachId));
    final packagesAsync = ref.watch(coachPackagesProvider(coachId));

    return Scaffold(
      body: AsyncValueWidget(
        value: coachAsync,
        data: (coach) => _CoachDetailBody(
          coach: coach,
          packagesAsync: packagesAsync,
        ),
      ),
    );
  }
}

class _CoachDetailBody extends ConsumerWidget {
  final Coach coach;
  final AsyncValue<List<CoachPackage>> packagesAsync;

  const _CoachDetailBody({
    required this.coach,
    required this.packagesAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamificationTheme =
        Theme.of(context).extension<GamificationThemeExtension>()!;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Sliver App Bar ──────────────────────────────────────
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppSurfaces.primaryGradient,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppDimensions.huge),
                        // Large avatar circle
                        CircleAvatar(
                          radius: AppDimensions.avatarXl / 2,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            coach.name.substring(0, 1).toUpperCase(),
                            style: AppTypography.displayMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.lg),

                    // Name + verified badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            coach.name,
                            style: AppTypography.headingLarge,
                          ),
                        ),
                        if (coach.isVerified) ...[
                          const SizedBox(width: AppDimensions.sm),
                          Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: AppDimensions.iconMd,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Level badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xs,
                      ),
                      decoration: BoxDecoration(
                        color: gamificationTheme.levelBackgroundColor(
                          coach.level,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: Text(
                        GamificationHelpers.tierLabel(coach.level),
                        style: AppTypography.badge.copyWith(
                          color: gamificationTheme.levelTextColor(coach.level),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    // Rating + reviews + students
                    Row(
                      children: [
                        RatingStars(rating: coach.rating),
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          '${coach.rating.toStringAsFixed(1)} (${coach.totalReviews} ulasan)',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Students count
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: AppDimensions.iconSm,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          '${coach.totalStudents} murid',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // City row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppDimensions.iconSm,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          coach.city,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Bio section
                    Text('Tentang', style: AppTypography.titleMedium),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      coach.bio,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Sport pills
                    Text('Olahraga', style: AppTypography.titleMedium),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: AppDimensions.sm,
                      runSpacing: AppDimensions.sm,
                      children: coach.sports.map((sport) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md,
                            vertical: AppDimensions.xs,
                          ),
                          decoration: BoxDecoration(
                            color: sportTheme.backgroundColor(sport),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            SportChipSelector.sportLabel(sport),
                            style: AppTypography.labelMedium.copyWith(
                              color: sportTheme.textColor(sport),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Certifications
                    if (coach.certifications.isNotEmpty) ...[
                      Text('Sertifikasi', style: AppTypography.titleMedium),
                      const SizedBox(height: AppDimensions.sm),
                      Wrap(
                        spacing: AppDimensions.sm,
                        runSpacing: AppDimensions.sm,
                        children: coach.certifications.map((cert) {
                          return Chip(
                            label: Text(
                              cert,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            backgroundColor: AppColors.neutral100,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                    ],

                    // Packages section
                    Text('Paket Coaching', style: AppTypography.titleMedium),
                    const SizedBox(height: AppDimensions.md),

                    // Package list
                    AsyncValueWidget(
                      value: packagesAsync,
                      data: (packages) {
                        if (packages.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.xl,
                            ),
                            child: Center(
                              child: Text(
                                'Belum ada paket tersedia',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: packages
                              .where((p) => p.isActive)
                              .map((pkg) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppDimensions.md,
                                  ),
                                  child: PackageCard(
                                    package: pkg,
                                    onSelect: () {
                                      ref
                                          .read(
                                            coachBookingProvider.notifier,
                                          )
                                          .setCoach(coach);
                                      ref
                                          .read(
                                            coachBookingProvider.notifier,
                                          )
                                          .selectPackage(pkg);
                                      context.push('/coach/booking');
                                    },
                                  ),
                                );
                              })
                              .toList(),
                        );
                      },
                    ),

                    // Bottom clearance for the fixed bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Bottom bar ──────────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
              left: AppDimensions.screenHorizontal,
              right: AppDimensions.screenHorizontal,
              top: AppDimensions.base,
              bottom: MediaQuery.of(context).padding.bottom + AppDimensions.base,
            ),
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              boxShadow: AppShadows.bottomNav,
            ),
            child: Row(
              children: [
                // Hourly rate
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Formatters.formatRupiah(coach.hourlyRate),
                        style: AppTypography.priceLarge,
                      ),
                      Text('/jam', style: AppTypography.caption),
                    ],
                  ),
                ),
                // Contact button
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Fitur hubungi coach segera hadir',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Hubungi Coach'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, AppDimensions.buttonHeightMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
