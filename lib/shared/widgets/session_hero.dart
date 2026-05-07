import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';

/// Hero image variant — picks the right URL from a `photo_urls` map.
/// See the BE handoff doc for size guidance:
/// - [sm] background blur / placeholder (320×180)
/// - [md] list / card thumbnail (640×360)
/// - [lg] detail-page hero, no zoom (1280×720)
/// - [xl] pinch-zoom / fullscreen / lightbox (2560×1440)
///
/// Never shrink an [xl] URL into a list thumbnail — wastes 5× the bytes
/// and warms the cache with the wrong size for the next renderer.
enum SessionHeroSize { sm, md, lg, xl }

/// 16:9 hero/thumbnail for a coaching session. Three render modes,
/// determined automatically from the inputs:
///
/// 1. **Real session photo** — `photoUrls` set AND `photoPath != null`
///    → cover-fit the image into the 16:9 box.
/// 2. **Tenant-logo fallback** — `photoUrls` set but `photoPath == null`
///    → BE returned the tenant logo (square); we render it centered on
///    [brandColor] (or [tenantBrandColorProvider] when not passed) so
///    the layout still fills 16:9. Matches the Vue `SessionHero` Vue
///    component pixel-for-pixel.
/// 3. **Empty** — `photoUrls == null` → neutral "No image" placeholder.
///
/// Mirrors the BE-side decision tree in
/// `Session::getPhotoUrlsAttribute()` (Issue 2026-05-07).
class SessionHero extends ConsumerWidget {
  /// 4-size URL map from the BE — `{sm, md, lg, xl}`.
  final Map<String, String>? photoUrls;

  /// Raw `photo_path` from the session record. When null the URLs (if
  /// any) point at the tenant logo, NOT a session photo — flips render
  /// mode to the centered-logo fallback layout.
  final String? photoPath;

  /// Which size to load. Caller picks per context — see [SessionHeroSize]
  /// docs for the size-by-context table.
  final SessionHeroSize size;

  /// Hex color (`#RRGGBB`) for the fallback-mode background. Defaults to
  /// the auth-state `tenantBrandColorProvider` when omitted; pass
  /// explicitly for cross-tenant marketplace contexts where the rendered
  /// session belongs to a different tenant than the viewer.
  final String? brandColor;

  /// Border radius of the hero container. Cards typically use
  /// [AppDimensions.radiusMd]; full-bleed details may want 0 for
  /// edge-to-edge.
  final double borderRadius;

  /// Optional tap callback — wraps the hero in an [InkWell]. Mutually
  /// exclusive with [enableZoom]; if both are passed, [onTap] wins.
  final VoidCallback? onTap;

  /// When true AND this is a real session photo (not fallback), tapping
  /// opens a fullscreen Hero-animated InteractiveViewer using the `xl`
  /// URL (or the largest available). No effect on fallback mode (the
  /// tenant logo is square + already small, pinch-zoom adds nothing).
  final bool enableZoom;

  /// Hero tag for the fullscreen viewer. Required when [enableZoom] is
  /// true so the open/close animation has continuity. Pass a
  /// per-session unique tag like `'session-hero-${session.id}'`.
  final String? heroTag;

  const SessionHero({
    super.key,
    required this.photoUrls,
    this.photoPath,
    this.size = SessionHeroSize.md,
    this.brandColor,
    this.borderRadius = AppDimensions.radiusMd,
    this.onTap,
    this.enableZoom = false,
    this.heroTag,
  });

  String? get _url => photoUrls?[size.name];
  String? get _xlUrl =>
      photoUrls?['xl'] ?? photoUrls?['lg'] ?? photoUrls?['md'];
  bool get _isFallback => photoUrls != null && photoPath == null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = _url;
    final radius = BorderRadius.circular(borderRadius);

    Widget content;
    if (url == null) {
      content = _Empty(borderRadius: borderRadius);
    } else if (_isFallback) {
      final String bg = brandColor ?? ref.watch(tenantBrandColorProvider);
      content = _Fallback(
        url: url,
        brandColor: _parseHex(bg),
        borderRadius: borderRadius,
      );
    } else {
      content = _Cover(
        url: url,
        borderRadius: borderRadius,
        heroTag: enableZoom ? heroTag : null,
      );
    }

    final canZoom = enableZoom && !_isFallback && _xlUrl != null;
    final effectiveTap = onTap ??
        (canZoom
            ? () => _openZoom(context, _xlUrl!, heroTag ?? _xlUrl!)
            : null);

    if (effectiveTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveTap,
          borderRadius: radius,
          child: content,
        ),
      );
    }
    return AspectRatio(aspectRatio: 16 / 9, child: content);
  }

  void _openZoom(BuildContext context, String xlUrl, String tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, _, _) => _FullscreenViewer(url: xlUrl, heroTag: tag),
      ),
    );
  }

  static Color _parseHex(String hex) {
    final s = hex.replaceFirst('#', '');
    if (s.length != 6) return const Color(0xFF0F172A);
    return Color(int.parse('FF$s', radix: 16));
  }
}

class _Cover extends StatelessWidget {
  final String url;
  final double borderRadius;
  final String? heroTag;
  const _Cover({required this.url, required this.borderRadius, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.neutral100),
      errorWidget: (_, _, _) => _Empty(borderRadius: borderRadius),
    );
    final clipped = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
    if (heroTag == null) return clipped;
    return Hero(tag: heroTag!, child: clipped);
  }
}

class _FullscreenViewer extends StatelessWidget {
  final String url;
  final String heroTag;

  const _FullscreenViewer({required this.url, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) => Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  final String url;
  final Color brandColor;
  final double borderRadius;

  const _Fallback({
    required this.url,
    required this.brandColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: brandColor,
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.33,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (_, _) => const SizedBox.shrink(),
            errorWidget: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final double borderRadius;
  const _Empty({required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined,
          size: AppDimensions.iconMd, color: AppColors.textTertiary),
    );
  }
}

/// Convenience caption for hero contexts that show a label below the
/// image (e.g. session list cards). Pulls `displayTitle` with sensible
/// fallbacks so a stale FE rendering an old BE response still works.
String resolveSessionDisplayTitle({
  String? displayTitle,
  String? title,
  String? autoName,
}) {
  if (displayTitle != null && displayTitle.isNotEmpty) return displayTitle;
  if (title != null && title.isNotEmpty) return title;
  return autoName ?? 'Sesi Latihan';
}

/// Convenience overlay for the lg/xl hero context: gradient + title text.
/// Optional widget — drop into the SessionHero `child` slot or render
/// adjacent depending on layout.
class SessionHeroOverlay extends StatelessWidget {
  final String displayTitle;
  final String? subtitle;
  final EdgeInsetsGeometry padding;

  const SessionHeroOverlay({
    super.key,
    required this.displayTitle,
    this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimensions.md,
      AppDimensions.md,
      AppDimensions.md,
      AppDimensions.md,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0xCC000000)],
          stops: [0.4, 1.0],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTitle,
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.xxs),
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
