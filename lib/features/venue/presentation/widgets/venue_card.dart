import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;

  const VenueCard({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sports = venue.courts.map((c) => c.sportType).toSet();

    // Calculate price range from courts
    const minPrice = 100000;
    const maxPrice = 150000;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/venue/${venue.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue photo
            AspectRatio(
              aspectRatio: AppDimensions.imageAspectVenue,
              child: CachedNetworkImage(
                imageUrl: venue.photos.isNotEmpty
                    ? venue.photos.first
                    : 'https://picsum.photos/seed/default/800/450',
                fit: BoxFit.cover,
                placeholder: (_, _) => ShimmerLoading.card(height: 200),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.neutral100,
                  child: const Icon(Icons.image, size: 48),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + verified
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: AppTypography.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (venue.isVerified)
                        Icon(Icons.verified, size: 18, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),

                  // Address
                  Text(
                    venue.address,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // Rating + sport chips + price
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: const Color(0xFFFFC107)),
                      const SizedBox(width: 2),
                      Text(
                        venue.avgRating.toStringAsFixed(1),
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${venue.totalReviews})',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      Text(
                        '${Formatters.formatRupiah(minPrice)}–${Formatters.formatRupiah(maxPrice)}',
                        style: AppTypography.priceSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // Sport chips
                  Wrap(
                    spacing: AppDimensions.xs,
                    children: sports.map((sport) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: sportTheme.backgroundColor(sport),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXs),
                        ),
                        child: Text(
                          SportChipSelector.sportLabel(sport),
                          style: AppTypography.badge.copyWith(
                            color: sportTheme.textColor(sport),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
