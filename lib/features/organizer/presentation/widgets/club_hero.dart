import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Club identity hero — logo (or initial monogram fallback) + name + sport.
/// Logo is tappable for full-screen zoom (shared `Hero` tag).
///
/// Accepts a `logoUrls` map directly from the BE 19.4 `Tenant::logo_urls`
/// accessor (`md` for the 72-px hero render is plenty); pass null for the
/// monogram fallback.
class ClubHero extends StatelessWidget {
  final String name;
  final Map<String, String>? logoUrls;
  final String? sport;
  final String? subtitle;

  const ClubHero({
    super.key,
    required this.name,
    this.logoUrls,
    this.sport,
    this.subtitle,
  });

  static const _heroTag = 'club-logo';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // slate-900 — deep, clubhouse feel
            Color(0xFF1E3A8A), // primary900
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.lg,
        AppDimensions.screenHorizontal,
        AppDimensions.lg,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZoomableAvatar(
              heroTag: _heroTag,
              imageUrl: logoUrls?['md'] ?? logoUrls?['lg'],
              fallbackInitials: Formatters.initials(name),
              radius: 36,
              bgColor: Colors.white.withValues(alpha: 0.12),
              fgColor: Colors.white,
              caption: name,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KLUB SAYA',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: AppTypography.headingMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (sport != null || subtitle != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Wrap(
                      spacing: AppDimensions.xs,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (sport != null)
                          _MetaChip(
                            label: sport!,
                            icon: Icons.sports_tennis,
                          ),
                        if (subtitle != null)
                          _MetaChip(
                            label: subtitle!,
                            icon: Icons.location_on_outlined,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
