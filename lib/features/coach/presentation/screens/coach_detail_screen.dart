import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/utils/launcher_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/presentation/widgets/package_card.dart';
import 'package:hyperarena/features/coach/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_detail_provider.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

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

                    // ── Ulasan (Review Aggregate) section ──
                    Text('Ulasan', style: AppTypography.titleMedium),
                    const SizedBox(height: AppDimensions.md),
                    AsyncValueWidget<CoachRatingAggregate>(
                      value: ref.watch(coachRatingProvider(coach.id)),
                      data: (aggregate) {
                        if (aggregate.totalReviews == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.md,
                            ),
                            child: Center(
                              child: Text(
                                'Belum ada ulasan',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            // Average rating + stars + count
                            Row(
                              children: [
                                Text(
                                  aggregate.averageRating.toStringAsFixed(1),
                                  style: AppTypography.displayMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RatingStars(
                                      rating: aggregate.averageRating,
                                    ),
                                    const SizedBox(height: AppDimensions.xs),
                                    Text(
                                      '${aggregate.totalReviews} ulasan',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.md),
                            // Distribution bars (5 → 1)
                            ...List.generate(5, (i) {
                              final star = 5 - i;
                              final count =
                                  aggregate.distribution[star] ?? 0;
                              final fraction = aggregate.totalReviews > 0
                                  ? count / aggregate.totalReviews
                                  : 0.0;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppDimensions.xs,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      child: Text(
                                        '$star',
                                        style: AppTypography.caption,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.xs),
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: AppDimensions.sm),
                                    Expanded(
                                      child: Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.neutral100,
                                          borderRadius:
                                              BorderRadius.circular(
                                            AppDimensions.radiusFull,
                                          ),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: fraction,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                AppDimensions.radiusFull,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.sm),
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '$count',
                                        style:
                                            AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: AppDimensions.md),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => context.push(
                                  AppRoutes.coachReviews(coach.id),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMd,
                                    ),
                                  ),
                                ),
                                child: const Text('Lihat Semua Ulasan'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.lg),

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
                                      context.push(AppRoutes.coachBooking);
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
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  LauncherHelpers.openWhatsApp(
                    '+6281234567890',
                    message:
                        'Halo Coach ${coach.name}, saya tertarik dengan jasa coaching Anda di HyperArena',
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
            ),
          ),
        ),
      ],
    );
  }
}
