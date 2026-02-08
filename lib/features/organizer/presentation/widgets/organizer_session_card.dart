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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
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
    final h = session.health;

    if (h.pendingPayments > 0) {
      final amountStr = h.pendingPaymentAmount > 0
          ? ' (${Formatters.formatRupiahCompact(h.pendingPaymentAmount)})'
          : '';
      chips.add(_healthChip(
        '${h.pendingPayments} belum bayar$amountStr',
        AppColors.warning,
      ));
    }
    if (h.timeToStart != null && h.timeToStart!.inHours <= 24) {
      chips.add(_healthChip(
        'Mulai ${_formatCountdown(h.timeToStart!)}',
        AppColors.info,
      ));
    } else if (h.isJoinDeadlineAtRisk) {
      chips.add(_healthChip('Deadline segera', AppColors.warning));
    }
    if (h.isLowSignupRisk) {
      chips.add(_healthChip(
        '${h.slotsRemaining} slot lagi',
        AppColors.warning,
      ));
    }

    return Wrap(
      spacing: AppDimensions.xs,
      runSpacing: AppDimensions.xs,
      children: chips,
    );
  }

  static String _formatCountdown(Duration d) {
    if (d.inDays > 0) return '${d.inDays} hari lagi';
    if (d.inHours > 0) return '${d.inHours} jam lagi';
    return '${d.inMinutes} menit lagi';
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
    if (session.status == OpenSessionStatus.cancelled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _priceLabel(),
          Text(
            'Dibatalkan',
            style: AppTypography.caption.copyWith(color: AppColors.neutral400),
          ),
        ],
      );
    }

    return Row(
      children: [
        _priceLabel(),
        const Spacer(),
        // Quick action: Undang (share invite)
        _QuickActionButton(
          icon: Icons.share_outlined,
          label: 'Undang',
          onPressed: () {
            // Phase 5+: share invite link via Share Sheet / deep link
          },
        ),
        const SizedBox(width: AppDimensions.xs),
        // Quick action: Ingatkan (send payment reminder)
        if (session.health.pendingPayments > 0) ...[
          _QuickActionButton(
            icon: Icons.notifications_outlined,
            label: 'Ingatkan',
            onPressed: () {
              // Phase 5+: send payment reminder via push notification
            },
          ),
          const SizedBox(width: AppDimensions.xs),
        ],
        // Overflow menu
        SizedBox(
          width: 32,
          height: 32,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: const Icon(Icons.more_vert, color: AppColors.neutral400),
            onSelected: (value) {
              switch (value) {
                case 'manage':
                  context.push(AppRoutes.organizerSessionDetail(session.id));
                case 'reschedule':
                  // Phase 5+: reschedule flow with date/time picker
                  break;
                case 'duplicate':
                  // Phase 5+: duplicate session (pre-fill create form)
                  break;
                case 'cancel':
                  // Phase 5+: cancel session with confirmation dialog
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'manage', child: Text('Kelola')),
              const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplikat')),
              const PopupMenuItem(value: 'cancel', child: Text('Batalkan')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceLabel() {
    return Text.rich(
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
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          visualDensity: VisualDensity.compact,
          textStyle: AppTypography.labelSmall,
        ),
      ),
    );
  }
}
