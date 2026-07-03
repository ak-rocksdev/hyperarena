import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/scrim_icon_button.dart';
import 'package:hyperarena/shared/widgets/sport_label_chip.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';

class MarketplaceVenueDetailScreen extends ConsumerWidget {
  final String venueId;

  const MarketplaceVenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueAsync = ref.watch(marketplaceVenueDetailProvider(venueId));

    return Scaffold(
      body: venueAsync.when(
        loading: () => Center(child: ShimmerLoading.card(height: 300)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: AppDimensions.md),
              Text('Gagal memuat detail lapangan',
                  style: AppTypography.bodyMedium),
              const SizedBox(height: AppDimensions.md),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(marketplaceVenueDetailProvider(venueId)),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (venue) => _VenueDetailBody(venue: venue),
      ),
    );
  }
}

class _VenueDetailBody extends StatelessWidget {
  final MarketplaceVenue venue;

  const _VenueDetailBody({required this.venue});

  @override
  Widget build(BuildContext context) {
    final hasPhotos = venue.photos.isNotEmpty;
    // Hero image: prefer uploaded photos (gallery-tappable). Fall back to
    // BE-resolved cover_image_url (typically a Google Street View shot at
    // the venue's lat/lng) — same fallback chain as the web admin.
    final heroUrl =
        hasPhotos ? venue.photos.first.url : venue.coverImageUrl;

    return CustomScrollView(
      slivers: [
        // Photo app bar — first photo as hero, tap opens fullscreen viewer.
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
                if (heroUrl != null)
                  GestureDetector(
                    // Only the uploaded-photo path opens the gallery viewer;
                    // Street View fallback is a single image, no carousel.
                    onTap: hasPhotos
                        ? () => _showPhotoViewer(
                              context,
                              venue.photos.map((p) => p.url).toList(),
                              0,
                            )
                        : null,
                    child: Hero(
                      tag: 'venue-photo-${venue.id}-0',
                      child: CachedNetworkImage(
                        imageUrl: heroUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            Container(color: AppColors.neutral100),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.neutral100,
                          child: const Icon(Icons.image, size: 48),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    color: AppColors.neutral100,
                    child: const Icon(Icons.sports, size: 64),
                  ),
                const HeroTopScrim(),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppSurfaces.darkOverlay,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue name
                Text(venue.name, style: AppTypography.headingLarge),
                const SizedBox(height: AppDimensions.sm),

                // Sport chip
                if (venue.sport != null)
                  SportLabelChip(label: venue.sport!.name),
                const SizedBox(height: AppDimensions.lg),

                // Photo gallery
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
                        child: GestureDetector(
                          onTap: () => _showPhotoViewer(
                            context,
                            venue.photos.map((p) => p.url).toList(),
                            i,
                          ),
                          child: Hero(
                            tag: 'venue-photo-${venue.id}-$i',
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMd),
                                boxShadow: AppShadows.xs,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: venue.photos[i].url,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(
                                  color: AppColors.neutral100,
                                ),
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
                  const SizedBox(height: AppDimensions.xl),
                ],

                // Location section with embedded map
                if (venue.location != null)
                  VenueLocationSection(
                    venueName: venue.location!.name,
                    address: venue.location!.address,
                    lat: venue.location!.lat,
                    lng: venue.location!.lng,
                  ),

                const SizedBox(height: AppDimensions.screenBottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoViewer(
      BuildContext context, List<String> photos, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) => _PhotoViewerDialog(
          photos: photos,
          initialIndex: initialIndex,
          venueId: venue.id,
        ),
      ),
    );
  }
}

class _PhotoViewerDialog extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  final String venueId;

  const _PhotoViewerDialog({
    required this.photos,
    required this.initialIndex,
    required this.venueId,
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: 'venue-photo-${widget.venueId}-$i',
                  child: CachedNetworkImage(
                    imageUrl: widget.photos[i],
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) => Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppDimensions.sm,
            right: AppDimensions.base,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (widget.photos.length > 1)
            Positioned(
              bottom:
                  MediaQuery.of(context).padding.bottom + AppDimensions.xl,
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
