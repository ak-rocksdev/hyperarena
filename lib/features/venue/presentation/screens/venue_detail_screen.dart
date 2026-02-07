import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/venue/presentation/widgets/court_card.dart';
import 'package:hyperarena/features/venue/presentation/widgets/facility_chips.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';

class VenueDetailScreen extends ConsumerWidget {
  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueAsync = ref.watch(venueDetailProvider(venueId));

    return Scaffold(
      body: AsyncValueWidget(
        value: venueAsync,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(venueDetailProvider(venueId)),
        ),
        data: (venue) {
          return CustomScrollView(
            slivers: [
              // Expandable photo app bar
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: venue.photos.isNotEmpty
                        ? venue.photos.first
                        : 'https://picsum.photos/seed/default/800/450',
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.neutral100,
                      child: const Icon(Icons.image, size: 48),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.all(AppDimensions.screenHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + verified
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              venue.name,
                              style: AppTypography.headingLarge,
                            ),
                          ),
                          if (venue.isVerified)
                            Icon(Icons.verified,
                                size: 24, color: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),

                      // Address
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${venue.address}, ${venue.city}',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),

                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star,
                              size: 18, color: const Color(0xFFFFC107)),
                          const SizedBox(width: 4),
                          Text(
                            venue.avgRating.toStringAsFixed(1),
                            style: AppTypography.titleSmall,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${venue.totalReviews} ulasan)',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.base),

                      // Facilities
                      if (venue.facilities.isNotEmpty) ...[
                        FacilityChips(facilities: venue.facilities),
                        const SizedBox(height: AppDimensions.base),
                      ],

                      // Description
                      Text(venue.description, style: AppTypography.bodyMedium),
                      const SizedBox(height: AppDimensions.xl),

                      // Courts section
                      Text(
                        'Lapangan Tersedia',
                        style: AppTypography.headingSmall,
                      ),
                      const SizedBox(height: AppDimensions.md),
                    ],
                  ),
                ),
              ),

              // Court list
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppDimensions.sm),
                      child: CourtCard(court: venue.courts[i]),
                    ),
                    childCount: venue.courts.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.screenBottom),
              ),
            ],
          );
        },
      ),
    );
  }
}
