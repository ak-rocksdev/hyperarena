import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Reusable card for displaying an organizer's open session with health
/// indicators, fill-rate bar, and action button.
class OrganizerSessionCard extends StatelessWidget {
  const OrganizerSessionCard({
    super.key,
    required this.session,
    this.onTap,
  });

  final OpenSession session;
  final VoidCallback? onTap;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool get _hasHealthProblems =>
      session.health.pendingPayments > 0 ||
      session.health.isJoinDeadlineAtRisk ||
      session.health.isLowSignupRisk;

  /// Critical = 2 or more active health problems simultaneously.
  bool get _hasCriticalIssues {
    var count = 0;
    if (session.health.pendingPayments > 0) count++;
    if (session.health.isJoinDeadlineAtRisk) count++;
    if (session.health.isLowSignupRisk) count++;
    return count >= 2;
  }

  double get _fillRate =>
      session.maxPlayers > 0 ? session.currentPlayers / session.maxPlayers : 0;

  // ---------------------------------------------------------------------------
  // Status pill
  // ---------------------------------------------------------------------------

  ({Color color, String label}) _statusPill() => switch (session.status) {
        OpenSessionStatus.open => (
            color: AppColors.primary,
            label: 'Terjadwal',
          ),
        OpenSessionStatus.full => (
            color: AppColors.warning,
            label: 'Penuh',
          ),
        OpenSessionStatus.confirmed => (
            color: AppColors.success,
            label: 'Terkonfirmasi',
          ),
        OpenSessionStatus.cancelled => (
            color: AppColors.error,
            label: 'Dibatalkan',
          ),
        OpenSessionStatus.completed => (
            color: AppColors.neutral400,
            label: 'Selesai',
          ),
      };

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final sportExt = Theme.of(context).extension<SportThemeExtension>()!;
    final sportColor = sportExt.color(session.sport);
    final accentBarColor = _hasCriticalIssues ? AppColors.error : sportColor;

    return GestureDetector(
      onTap: onTap ?? () => context.push(AppRoutes.organizerSessionDetail(session.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Sport accent bar ──────────────────────────────────
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentBarColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLg),
                    bottomLeft: Radius.circular(AppDimensions.radiusLg),
                  ),
                ),
              ),

              // ── Content area ─────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(),
                      const SizedBox(height: AppDimensions.sm),
                      _buildMetaRow(),
                      _buildFillRateBar(sportColor),
                      if (_hasHealthProblems) ...[
                        const SizedBox(height: AppDimensions.sm),
                        _buildHealthChips(),
                      ],
                      const SizedBox(height: AppDimensions.sm),
                      _buildBottomRow(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-builders
  // ---------------------------------------------------------------------------

  Widget _buildTopRow() {
    final pill = _statusPill();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            session.title,
            style: AppTypography.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: pill.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            pill.label,
            style: AppTypography.labelSmall.copyWith(color: pill.color),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow() {
    final items = <Widget>[
      _metaItem(Icons.location_on, session.venueName),
      _metaItem(Icons.calendar_today, Formatters.formatDateShort(session.date)),
      _metaItem(
        Icons.access_time,
        Formatters.formatTimeRange(session.startTime, session.endTime),
      ),
    ];

    return Wrap(
      spacing: AppDimensions.md,
      runSpacing: AppDimensions.xs,
      children: items,
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.neutral400),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFillRateBar(Color sportColor) {
    return Column(
      children: [
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: _fillRate.clamp(0.0, 1.0),
                    backgroundColor: AppColors.neutral100,
                    valueColor: AlwaysStoppedAnimation<Color>(sportColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              '${session.currentPlayers}/${session.maxPlayers} pemain',
              style: AppTypography.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthChips() {
    final chips = <Widget>[];

    if (session.health.pendingPayments > 0) {
      chips.add(_healthChip(
        '${session.health.pendingPayments} belum bayar',
        AppColors.warning,
      ));
    }
    if (session.health.isJoinDeadlineAtRisk) {
      chips.add(_healthChip('Deadline segera', AppColors.warning));
    }
    if (session.health.isLowSignupRisk) {
      chips.add(_healthChip('Kuota rendah', AppColors.warning));
    }

    return Wrap(
      spacing: AppDimensions.xs,
      runSpacing: AppDimensions.xs,
      children: chips,
    );
  }

  Widget _healthChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: Formatters.formatRupiah(session.pricePerPerson),
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '/orang',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
        if (session.status != OpenSessionStatus.cancelled)
          FilledButton.tonal(
            onPressed: onTap ??
                () => context.push(
                      AppRoutes.organizerSessionDetail(session.id),
                    ),
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Kelola'),
          )
        else
          Text(
            'Dibatalkan',
            style: AppTypography.caption.copyWith(color: AppColors.neutral400),
          ),
      ],
    );
  }
}
