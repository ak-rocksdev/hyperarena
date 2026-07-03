import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/launcher_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/review/data/models/venue_rating_aggregate.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/presentation/widgets/venue_review_card.dart';
import 'package:hyperarena/features/review/providers/venue_review_providers.dart';
import 'package:hyperarena/features/venue/presentation/widgets/court_card.dart';
import 'package:hyperarena/features/venue/presentation/widgets/facility_chips.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';
import 'package:hyperarena/shared/widgets/scrim_icon_button.dart';
import 'package:hyperarena/routing/app_routes.dart';

class VenueDetailScreen extends ConsumerWidget {
  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  void _showPhotoViewer(
      BuildContext context, List<String> photos, int initialIndex) {
    showDialog(
      context: context,
      builder: (_) => _PhotoViewerDialog(
        photos: photos,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueAsync = ref.watch(venueDetailProvider(venueId));

    return Scaffold(
      body: AsyncValueWidget(
        value: venueAsync,
        loading: () => ShimmerLoading.card(),
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
                systemOverlayStyle: SystemUiOverlayStyle.light,
                automaticallyImplyLeading: false,
                leading: ScrimIconButton(
                  icon: Icons.arrow_back,
                  semanticLabel: 'Kembali',
                  onPressed: () => Navigator.maybePop(context),
                ),
                  flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: venue.photos.isNotEmpty
                            ? venue.photos.first
                            : 'https://picsum.photos/seed/default/800/450',
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.neutral100,
                          child: const Icon(Icons.image, size: 48),
                        ),
                      ),
                      const HeroTopScrim(),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppSurfaces.darkOverlay,
                          ),
                        ),
                      ),
                    ],
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
                              size: 18, color: AppColors.starRating),
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
                      const SizedBox(height: AppDimensions.md),

                      // WhatsApp contact button
                      if (venue.whatsappNumber != null ||
                          venue.phone != null)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              final phone =
                                  venue.whatsappNumber ?? venue.phone!;
                              LauncherHelpers.openWhatsApp(
                                phone,
                                message:
                                    'Halo, saya ingin bertanya tentang ${venue.name}',
                              );
                            },
                            icon: const Icon(Icons.chat_outlined),
                            label: const Text('Hubungi via WhatsApp'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.whatsappGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(
                                0,
                                AppDimensions.buttonHeightMd,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppDimensions.base),

                      // Facilities
                      if (venue.facilities.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimensions.md),
                          decoration: BoxDecoration(
                            color: AppSurfaces.surfaceHighlight,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd),
                          ),
                          child: FacilityChips(
                              facilities: venue.facilities),
                        ),
                        const SizedBox(height: AppDimensions.base),
                      ],

                      // Gallery
                      if (venue.photos.length > 1) ...[
                        Text('Foto', style: AppTypography.headingSmall),
                        const SizedBox(height: AppDimensions.md),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: venue.photos.length,
                            itemBuilder: (_, i) => Padding(
                              padding: EdgeInsets.only(
                                right: i < venue.photos.length - 1
                                    ? AppDimensions.sm
                                    : 0,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMd),
                                  onTap: () => _showPhotoViewer(
                                      context, venue.photos, i),
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusMd),
                                      boxShadow: AppShadows.xs,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: CachedNetworkImage(
                                      imageUrl: venue.photos[i],
                                      fit: BoxFit.cover,
                                      errorWidget: (_, _, _) => Container(
                                        color: AppColors.neutral100,
                                        child: const Icon(Icons.image, size: 24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                      child: CourtCard(court: venue.courts[i], venue: venue),
                    ),
                    childCount: venue.courts.length,
                  ),
                ),
              ),

              // Reviews section
              SliverToBoxAdapter(
                child: _VenueRatingSection(venueId: venue.id),
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

class _VenueRatingSection extends ConsumerWidget {
  final String venueId;

  const _VenueRatingSection({required this.venueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAsync = ref.watch(venueRatingProvider(venueId));
    final reviewsAsync = ref.watch(venueReviewsProvider(venueId));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.xl),

          // Section title
          Text('Ulasan', style: AppTypography.headingSmall),
          const SizedBox(height: AppDimensions.md),

          // Rating aggregate
          ratingAsync.when(
            loading: () => ShimmerLoading.card(),
            error: (_, _) => const SizedBox.shrink(),
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
                        color: AppColors.neutral600,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  // Average rating + stars + distribution
                  _buildRatingAggregate(aggregate),
                  const SizedBox(height: AppDimensions.md),

                  // Recent reviews (latest 3)
                  reviewsAsync.whenOrNull(
                        data: (reviews) {
                          final recent = reviews.take(3).toList();
                          if (recent.isEmpty) return const SizedBox.shrink();
                          return Column(
                            children: [
                              ...recent.map((r) => VenueReviewCard(review: r)),
                            ],
                          );
                        },
                      ) ??
                      const SizedBox.shrink(),

                  const SizedBox(height: AppDimensions.md),

                  // "Lihat Semua Ulasan" button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push(
                        AppRoutes.venueReviews(venueId),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                      ),
                      child: Text(
                        'Lihat Semua Ulasan (${aggregate.totalReviews})',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAggregate(VenueRatingAggregate aggregate) {
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
                  rating: 0,
                  showAverage: true,
                  averageRating: aggregate.averageRating,
                  size: 20,
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
        // Distribution bars (5 -> 1)
        ...List.generate(5, (i) {
          final star = 5 - i;
          final count = aggregate.distribution[star] ?? 0;
          final fraction = aggregate.totalReviews > 0
              ? count / aggregate.totalReviews
              : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.xs),
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: fraction,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(
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
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _PhotoViewerDialog extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const _PhotoViewerDialog({
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<_PhotoViewerDialog> createState() => _PhotoViewerDialogState();
}

class _PhotoViewerDialogState extends State<_PhotoViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          // Photo PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) => InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.photos[i],
                  fit: BoxFit.contain,
                  errorWidget: (_, _, _) => Icon(
                    Icons.image,
                    size: 48,
                    color: AppColors.neutral400,
                  ),
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppDimensions.sm,
            right: AppDimensions.base,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Page indicator
          if (widget.photos.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + AppDimensions.xl,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photos.length, (i) {
                  return Container(
                    width: i == _currentIndex ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == _currentIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
