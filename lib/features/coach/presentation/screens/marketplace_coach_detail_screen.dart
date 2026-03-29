import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/shared/widgets/sport_label_chip.dart';

/// Simple marketplace coach detail screen.
/// Receives [MarketplaceCoach] via GoRouter extra.
class MarketplaceCoachDetailScreen extends StatelessWidget {
  final MarketplaceCoach coach;

  const MarketplaceCoachDetailScreen({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final name = coach.user?.name ?? 'Coach';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
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
                      // Avatar
                      CircleAvatar(
                        radius: AppDimensions.avatarXl / 2,
                        backgroundImage: coach.user?.photoUrls?['lg'] != null
                            ? NetworkImage(coach.user!.photoUrls!['lg']!)
                            : null,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: coach.user?.photoUrls == null
                            ? Text(
                                Formatters.initials(name),
                                style: AppTypography.displayMedium.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.lg),

                  // Name
                  Text(name, style: AppTypography.headingLarge),
                  const SizedBox(height: AppDimensions.sm),

                  // Sport chip
                  if (coach.sport != null)
                    SportLabelChip(label: coach.sport!.name),
                  const SizedBox(height: AppDimensions.lg),

                  // Rate per session
                  if (coach.ratePerSession != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payments_outlined,
                              color: AppColors.primary),
                          const SizedBox(width: AppDimensions.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tarif per Sesi',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  )),
                              Text(
                                Formatters.formatRupiah(coach.ratePerSession!),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],

                  // Bio section
                  if (coach.bio != null && coach.bio!.isNotEmpty) ...[
                    Text('Tentang', style: AppTypography.titleMedium),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      coach.bio!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],

                  // Coming soon placeholder
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.xl),
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_month_outlined,
                            size: 48, color: AppColors.neutral400),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Jadwal & Sesi',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'Jadwal coaching dan sesi tersedia segera hadir',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.screenBottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
