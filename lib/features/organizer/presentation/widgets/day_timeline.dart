import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// "Jadwal" section — vertical timeline of today's sessions.
///
/// Each row:
///   `[time]   |•|   [session card or dashed empty]`
///
/// Empty state when [sessions] is empty: single dashed row inviting a new
/// session via the FAB equivalent.
class DayTimeline extends ConsumerWidget {
  const DayTimeline({
    super.key,
    required this.sessions,
    this.hoursOnCourt,
  });

  final List<OpenSession> sessions;

  /// From `stats.hoursOnCourtToday` — null until BE deploys.
  final int? hoursOnCourt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.lg,
        AppDimensions.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Jadwal',
            subtitle: hoursOnCourt != null
                ? '$hoursOnCourt jam di lapangan'
                : null,
            linkLabel: sessions.isNotEmpty ? 'Semua' : null,
            onLinkTap: sessions.isNotEmpty
                ? () => context.go(AppRoutes.organizerSessions)
                : null,
          ),
          const SizedBox(height: AppDimensions.sm),
          if (sessions.isEmpty)
            _EmptyRow()
          else
            for (var i = 0; i < sessions.length; i++)
              _TimelineRow(
                session: sessions[i],
                isLast: i == sessions.length - 1,
              ),
        ],
      ),
    );
  }
}

class _TimelineRow extends ConsumerWidget {
  const _TimelineRow({required this.session, required this.isLast});

  final OpenSession session;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sportFg = sportTheme.color(session.sport);
    final sportBg = sportTheme.backgroundColor(session.sport);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time column
          SizedBox(
            width: 56,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    session.startTime,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    session.endTime,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Vertical line + dot
          SizedBox(
            width: 14,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(width: 2, color: AppColors.border),
                Positioned(
                  top: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: sportFg,
                      shape: BoxShape.circle,
                      border: Border.all(color: sportBg, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Session card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppDimensions.md,
              ),
              child: _SessionCard(session: session),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({required this.session});

  final OpenSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final pendingCount = session.health.pendingPayments;
    final currency = ref.watch(tenantCurrencyProvider);
    final totalPrice = session.pricePerPerson * session.currentPlayers;

    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(AppRoutes.organizerSessionDetail(session.id)),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _SportChip(sport: session.sport, theme: sportTheme),
                  const Spacer(),
                  if (pendingCount > 0)
                    _StatusPill(
                      label: '$pendingCount perlu konfirmasi',
                      bg: AppColors.warningLight,
                      fg: AppColors.warningDark,
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                session.safeTitle,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      session.venueName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _AvatarStack(names: session.participantNames),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    '${session.currentPlayers}/${session.maxPlayers}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Spacer(),
                  MoneyText(
                    Formatters.formatCurrencyCompact(totalPrice, currency),
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maskWidth: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  const _SportChip({required this.sport, required this.theme});

  final Sport sport;
  final SportThemeExtension theme;

  static const _labels = {
    Sport.tennis: 'TENIS',
    Sport.padel: 'PADEL',
    Sport.badminton: 'BADMINTON',
    Sport.futsal: 'FUTSAL',
    Sport.basketball: 'BASKET',
    Sport.volleyball: 'VOLI',
    Sport.tableTennis: 'TENIS MEJA',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: theme.backgroundColor(sport),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.color(sport),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _labels[sport] ?? sport.name.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: theme.textColor(sport),
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
  const _StatusPill({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
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
          fontWeight: FontWeight.w600,
          fontSize: 11,
          height: 1,
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.names});

  final List<String> names;

  static const _palette = [
    Color(0xFF1F7A74),
    Color(0xFF7C3AED),
    Color(0xFF0EA5E9),
    Color(0xFFF97316),
    Color(0xFFEC4899),
    Color(0xFF65A30D),
    Color(0xFFEF4444),
  ];

  Color _hashColor(String initials) {
    var h = 0;
    for (final c in initials.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return _palette[h % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    const max = 4;
    final visible = names.take(max).toList();
    final extra = names.length > max ? names.length - max : 0;

    return SizedBox(
      height: 24,
      width: visible.length * 17.0 + (extra > 0 ? 17 : 0),
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * 17.0,
              child: _Avatar(
                initials: Formatters.initials(visible[i]),
                color: _hashColor(visible[i]),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: visible.length * 17.0,
              child: _Avatar(
                initials: '+$extra',
                color: AppColors.neutral300,
                fg: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initials,
    required this.color,
    this.fg = Colors.white,
  });

  final String initials;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppSurfaces.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.labelMedium.copyWith(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Tidak ada sesi hari ini',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '+ Tambah',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
