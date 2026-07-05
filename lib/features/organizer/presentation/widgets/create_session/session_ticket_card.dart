import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_type_cards.dart';

/// The signature element: a live preview of the session shaped like a venue
/// ticket stub — notched sides and a dashed tear line — that fills in as the
/// organizer schedules. Booking a court is a ticket; this makes "Terbitkan"
/// feel like publishing a real thing rather than submitting a form.
class SessionTicketCard extends StatelessWidget {
  const SessionTicketCard({
    super.key,
    required this.type,
    required this.title,
    required this.whenLine,
    required this.capacityText,
    required this.priceText,
  });

  final SessionType type;

  /// null/empty → shows a placeholder title.
  final String? title;

  /// null → schedule not set yet.
  final String? whenLine;
  final String capacityText;
  final String priceText;

  static const double _footerH = 58;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;

    return ClipPath(
      clipper: const _TicketClipper(footerH: _footerH, notchRadius: 9),
      child: Container(
        decoration: BoxDecoration(color: AppSurfaces.surface, boxShadow: AppShadows.md),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stub head: eyebrow, type badge, title, schedule ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.base,
                      AppDimensions.base, AppDimensions.base, AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _TypeBadge(type: type),
                          const Spacer(),
                          Text(
                            'PREVIEW',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        hasTitle ? title!.trim() : 'Sesi tanpa judul',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headingSmall.copyWith(
                          color: hasTitle
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 16,
                            color: whenLine != null
                                ? AppColors.primary
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              whenLine ?? 'Jadwal belum diatur',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                color: whenLine != null
                                    ? AppColors.textSecondary
                                    : AppColors.textTertiary,
                                fontWeight: whenLine != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Stub foot: capacity + price ──
                SizedBox(
                  height: _footerH,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppDimensions.base, 0,
                        AppDimensions.base, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _FootStat(
                            label: 'Kapasitas',
                            value: capacityText,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: AppColors.neutral100,
                        ),
                        const SizedBox(width: AppDimensions.base),
                        _FootStat(
                          label: 'Harga',
                          value: priceText,
                          alignEnd: true,
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // ── Dashed tear line, sitting on the notch centres ──
            Positioned(
              left: AppDimensions.md,
              right: AppDimensions.md,
              bottom: _footerH,
              child: const _DashedLine(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final SessionType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            type.label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FootStat extends StatelessWidget {
  const _FootStat({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.overline.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleSmall.copyWith(
            color: emphasize ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 5.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dash,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Rounded card with two semicircular notches punched at the tear line so the
/// stub reads as a torn ticket.
class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper({required this.footerH, required this.notchRadius});

  final double footerH;
  final double notchRadius;

  @override
  Path getClip(Size size) {
    final body = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(AppDimensions.radiusLg),
      ));
    final notchY = size.height - footerH;
    final notches = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(0, notchY), radius: notchRadius))
      ..addOval(Rect.fromCircle(
          center: Offset(size.width, notchY), radius: notchRadius));
    return Path.combine(PathOperation.difference, body, notches);
  }

  @override
  bool shouldReclip(_TicketClipper oldClipper) =>
      oldClipper.footerH != footerH || oldClipper.notchRadius != notchRadius;
}
