import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Tappable avatar/logo that opens a full-screen pinch-to-zoom viewer with
/// a Hero transition. Use anywhere avatars or club logos appear so the user
/// can verify identity at scale (sports profile photos are often grainy
/// thumbnails — full-bleed reveal makes them legible).
///
/// Keep [heroTag] unique per route; reuse the same [heroTag] inside the
/// viewer so the transition is smooth. The viewer is opened by this widget
/// internally — callers don't manage navigation.
class ZoomableAvatar extends StatelessWidget {
  /// Shared tag between the small avatar and the zoomed view.
  final String heroTag;

  /// Network image URL. When null, [fallbackInitials] renders on
  /// [bgColor].
  final String? imageUrl;

  /// Initials shown when [imageUrl] is null. Defaults to a `?`.
  final String fallbackInitials;

  /// Background color when no image. Defaults to primary50.
  final Color? bgColor;

  /// Text color for fallback initials. Defaults to primary700.
  final Color? fgColor;

  /// Avatar diameter at the call-site.
  final double radius;

  /// Optional caption shown beneath the photo in the zoom overlay
  /// (e.g. the student's name). Helps when the photo alone isn't enough.
  final String? caption;

  /// Optional decoration ring around the avatar (matches existing
  /// status-ring patterns in the app).
  final Color? ringColor;

  /// Optional small badge overlay on the avatar (bottom-right). Use for
  /// tiny status indicators — e.g. an outstanding-payment dot.
  final Widget? badge;

  const ZoomableAvatar({
    super.key,
    required this.heroTag,
    this.imageUrl,
    this.fallbackInitials = '?',
    this.bgColor,
    this.fgColor,
    this.radius = 22,
    this.caption,
    this.ringColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Hero(
      tag: heroTag,
      flightShuttleBuilder: _flightShuttle,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor ?? AppColors.primary50,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: imageUrl == null
            ? Text(
                fallbackInitials,
                style: AppTypography.labelMedium.copyWith(
                  color: fgColor ?? AppColors.primary700,
                  fontWeight: FontWeight.w700,
                  fontSize: radius * 0.55,
                ),
              )
            : null,
      ),
    );

    final wrapped = ringColor != null
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor!, width: 2),
            ),
            padding: const EdgeInsets.all(2),
            child: inner,
          )
        : inner;

    return GestureDetector(
      onTap: () => _openZoom(context),
      child: badge == null
          ? wrapped
          : Stack(
              clipBehavior: Clip.none,
              children: [
                wrapped,
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: badge!,
                ),
              ],
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
          fallbackInitials: fallbackInitials,
          bgColor: bgColor,
          fgColor: fgColor,
          caption: caption,
        ),
      ),
    );
  }

  /// Keep the avatar perfectly circular through the flight (Hero's default
  /// can stretch when source/target shapes differ).
  Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final toHero = toHeroContext.widget as Hero;
    return Material(
      color: Colors.transparent,
      child: ClipOval(child: toHero.child),
    );
  }
}

class _ZoomedView extends StatelessWidget {
  final String heroTag;
  final String? imageUrl;
  final String fallbackInitials;
  final Color? bgColor;
  final Color? fgColor;
  final String? caption;

  const _ZoomedView({
    required this.heroTag,
    required this.imageUrl,
    required this.fallbackInitials,
    required this.bgColor,
    required this.fgColor,
    required this.caption,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: heroTag,
                child: Material(
                  color: Colors.transparent,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: ClipOval(
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _buildFallback(),
                              )
                            : _buildFallback(),
                      ),
                    ),
                  ),
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: AppDimensions.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Text(
                    caption!,
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: bgColor ?? AppColors.primary50,
      alignment: Alignment.center,
      child: Text(
        fallbackInitials,
        style: AppTypography.headingLarge.copyWith(
          color: fgColor ?? AppColors.primary700,
          fontSize: 96,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
        ),
      ),
    );
  }
}
