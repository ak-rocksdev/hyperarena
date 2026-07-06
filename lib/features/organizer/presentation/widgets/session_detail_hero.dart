import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/shared/widgets/scrim_icon_button.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';

/// Sport-tinted detail hero card. Layout (top to bottom):
///   1. Session photo (if available — via [SessionHero]); otherwise solid
///      sport-tinted band.
///   2. Sport chip + status pill row.
///   3. Title (heading).
///   4. Venue / date / time / price info rows.
class SessionDetailHero extends ConsumerWidget {
  const SessionDetailHero({super.key, required this.session});

  final OpenSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sportColor = sportTheme.color(session.sport);
    final sportBg = sportTheme.backgroundColor(session.sport);
    final sportText = sportTheme.textColor(session.sport);
    final currency = ref.watch(tenantCurrencyProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SessionHero(
                photoUrls: session.photoUrls,
                photoPath: session.photoPath,
                size: SessionHeroSize.lg,
                borderRadius: 0,
                enableZoom: true,
                heroTag: 'organizer-session-hero-${session.id}',
              ),
              Positioned(
                top: AppDimensions.sm,
                right: AppDimensions.sm,
                child: Builder(
                  builder: (context) => ScrimIconButton(
                    icon: Icons.photo_camera_outlined,
                    semanticLabel: 'Ubah sampul',
                    onPressed: () => editSessionCover(
                      context,
                      ref,
                      sessionId: session.id,
                      hasPhoto: session.photoPath != null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content area gets a subtle sport-tinted top gradient so the
          // session feels "themed" without overwhelming the body text.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  sportBg.withValues(alpha: 0.55),
                  AppSurfaces.surface,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
            padding: const EdgeInsets.all(AppDimensions.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SportPill(
                      label: SportChipSelector.sportLabel(session.sport),
                      fg: sportText,
                      bg: sportBg,
                      dotColor: sportColor,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    _StatusPill(status: session.status),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  session.safeTitle,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: session.venueName,
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: Formatters.formatDate(session.date),
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  text: Formatters.formatTimeRange(
                    session.startTime,
                    session.endTime,
                  ),
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.attach_money_outlined,
                  text: Formatters.sessionPriceLabel(
                    effectivePrice: session.pricing?.effectivePrice,
                    paymentMode: session.pricing?.paymentMode,
                    creditRequired: session.pricing?.creditRequired,
                    currency: session.pricing?.currency,
                    fallbackAmount: session.pricePerPerson,
                    tenantCurrency: currency,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  const _SportPill({
    required this.label,
    required this.fg,
    required this.bg,
    required this.dotColor,
  });

  final String label;
  final Color fg;
  final Color bg;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final OpenSessionStatus status;

  (Color, Color, String) _styleAndLabel() => switch (status) {
        OpenSessionStatus.open => (
            AppColors.infoLight,
            AppColors.infoDark,
            'Terbuka'
          ),
        OpenSessionStatus.full => (
            AppColors.successLight,
            AppColors.successDark,
            'Penuh'
          ),
        OpenSessionStatus.confirmed => (
            AppColors.successLight,
            AppColors.successDark,
            'Dikonfirmasi'
          ),
        OpenSessionStatus.cancelled => (
            AppColors.neutral100,
            AppColors.neutral600,
            'Dibatalkan'
          ),
        OpenSessionStatus.completed => (
            AppColors.primary50,
            AppColors.primary700,
            'Selesai'
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _styleAndLabel();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
