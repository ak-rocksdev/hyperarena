import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OwnerVenueListScreen extends ConsumerWidget {
  const OwnerVenueListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(ownerVenuesProvider);
    final issuesAsync = ref.watch(ownerAvailabilityIssuesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Venue Saya')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ownerVenuesProvider);
          ref.invalidate(ownerAvailabilityIssuesProvider);
        },
        child: AsyncValueWidget(
          value: venuesAsync,
          data: (venues) {
            if (venues.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  EmptyState(
                    message: 'Belum ada venue yang dikelola',
                    icon: Icons.storefront_outlined,
                  ),
                ],
              );
            }
            return AsyncValueWidget(
              value: issuesAsync,
              loading: () => _VenueListBody(venues: venues, issueVenueIds: {}),
              data: (issues) {
                final issueVenueIds =
                    issues.map((i) => i.venueId).toSet();
                return _VenueListBody(
                  venues: venues,
                  issueVenueIds: issueVenueIds,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _VenueListBody extends StatelessWidget {
  const _VenueListBody({
    required this.venues,
    required this.issueVenueIds,
  });

  final List<Venue> venues;
  final Set<String> issueVenueIds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.screenTop,
      ),
      itemCount: venues.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.md),
      itemBuilder: (context, index) {
        final venue = venues[index];
        final hasIssues = issueVenueIds.contains(venue.id);
        final occupancy = (venue.courts.length * 0.2).clamp(0.3, 0.9);

        return _VenueCard(
          venue: venue,
          hasIssues: hasIssues,
          occupancy: occupancy,
        );
      },
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.venue,
    required this.hasIssues,
    required this.occupancy,
  });

  final Venue venue;
  final bool hasIssues;
  final double occupancy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.ownerVenueDetail(venue.id)),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            // Venue icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Icon(
                Icons.stadium_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconMd,
              ),
            ),
            const SizedBox(width: AppDimensions.md),

            // Name, city, court count, occupancy bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: AppTypography.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: AppDimensions.xxs),
                  Text(venue.city, style: AppTypography.caption),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: [
                      Text(
                        '${venue.courts.length} lapangan',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                          child: LinearProgressIndicator(
                            value: occupancy,
                            minHeight: 6,
                            backgroundColor: AppColors.neutral100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              occupancy >= 0.8
                                  ? AppColors.success
                                  : AppColors.primary400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        '${(occupancy * 100).toInt()}%',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.md),

            // Status dot
            Container(
              width: AppDimensions.badgeDot,
              height: AppDimensions.badgeDot,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasIssues ? AppColors.warning : AppColors.success,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: AppColors.neutral400,
              size: AppDimensions.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
