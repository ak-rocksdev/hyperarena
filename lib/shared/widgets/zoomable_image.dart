import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Tappable rectangular image with full-screen pinch-to-zoom. Sibling of
/// `ZoomableAvatar`, used for payment proofs (bank receipts, transfer
/// screenshots) where a circular crop would clip the relevant data.
///
/// Tap the thumbnail → opens a transparent route with a barrier-darkened
/// backdrop and a centered `InteractiveViewer` (pinch 1×–4×). The thumbnail
/// itself is constrained — pass [thumbnailHeight] / [thumbnailFit] for
/// the call-site rendering.
class ZoomableImage extends StatelessWidget {
  /// Shared tag between the thumbnail and the zoomed view.
  final String heroTag;

  /// Network image URL (required — `null` callers should hide the widget
  /// upstream rather than passing null here).
  final String imageUrl;

  /// Optional caption shown beneath the photo in the zoom overlay (e.g. the
  /// transaction description).
  final String? caption;

  /// Thumbnail height. Width follows the parent constraints + [thumbnailFit].
  final double thumbnailHeight;

  /// How the thumbnail fits inside its slot.
  final BoxFit thumbnailFit;

  /// Border radius applied to both the thumbnail and the zoomed view.
  final double borderRadius;

  const ZoomableImage({
    super.key,
    required this.heroTag,
    required this.imageUrl,
    this.caption,
    this.thumbnailHeight = 80,
    this.thumbnailFit = BoxFit.cover,
    this.borderRadius = AppDimensions.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openZoom(context),
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: _flightShuttle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(
            imageUrl,
            height: thumbnailHeight,
            width: double.infinity,
            fit: thumbnailFit,
            errorBuilder: (_, _, _) => Container(
              height: thumbnailHeight,
              color: AppColors.neutral100,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: AppColors.neutral400,
              ),
            ),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                height: thumbnailHeight,
                color: AppColors.neutral100,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openZoom(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.92),
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, _, _) => _ZoomedView(
          heroTag: heroTag,
          imageUrl: imageUrl,
          caption: caption,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final toHero = toHeroContext.widget as Hero;
    return Material(color: Colors.transparent, child: toHero.child);
  }
}

class _ZoomedView extends StatelessWidget {
  final String heroTag;
  final String imageUrl;
  final String? caption;
  final double borderRadius;

  const _ZoomedView({
    required this.heroTag,
    required this.imageUrl,
    required this.caption,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Hero(
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Container(
                              width: 280,
                              height: 200,
                              color: AppColors.neutral800,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.neutral400,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (caption != null) ...[
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    caption!,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
