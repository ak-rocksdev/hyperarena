import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// Flat action queue used on the dashboard.
///
/// Shows top [maxItems] items sorted by severity then dueAt. Each row is a
/// single action with a 4px left severity bar, type icon, title + meta
/// amount, sub + countdown, and chevron. Tapping routes to the session's
/// participants screen when `sessionId` is set.
///
/// Note: this is a simpler, denser variant of [ActionQueueWidget] suited
/// to the dashboard top-of-screen real estate. The full grouped/batch
/// variant remains in `action_queue_widget.dart` for use in the inbox
/// screen (when that route lands).
class DashboardActionList extends ConsumerWidget {
  const DashboardActionList({
    super.key,
    required this.items,
    this.maxItems = 3,
  });

  final List<OrganizerActionItem> items;
  final int maxItems;

  static const _typeIcon = {
    OrganizerActionType.confirmPayment: Icons.payments_outlined,
    OrganizerActionType.sessionRisk: Icons.warning_amber_outlined,
    OrganizerActionType.refundRequest: Icons.undo_outlined,
    OrganizerActionType.waitlistDecision: Icons.confirmation_number_outlined,
    OrganizerActionType.dispute: Icons.gavel_outlined,
    OrganizerActionType.ownerIssue: Icons.business_outlined,
  };

  static int _compareUrgency(OrganizerActionItem a, OrganizerActionItem b) {
    final sevDelta = b.severity.index - a.severity.index;
    if (sevDelta != 0) return sevDelta;
    final aDue = a.dueAt, bDue = b.dueAt;
    if (aDue == null && bDue == null) return 0;
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final sorted = [...items]..sort(_compareUrgency);
    final visible = sorted.take(maxItems).toList();

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
            title: 'Perlu tindakan',
            count: items.length,
            linkLabel: items.length > maxItems ? 'Semua' : null,
            // organizerInbox route is reserved in AppRoutes but no shell
            // route is registered yet — leave the link visual-only until
            // the inbox screen lands (see DEFERRED-WORK §C2).
            onLinkTap: null,
          ),
          const SizedBox(height: AppDimensions.sm),
          for (var i = 0; i < visible.length; i++) ...[
            _ActionRow(item: visible[i]),
            if (i < visible.length - 1) const SizedBox(height: AppDimensions.sm),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.item});

  final OrganizerActionItem item;

  Color _severityBar() => switch (item.severity) {
        OrganizerActionSeverity.high => AppColors.error,
        OrganizerActionSeverity.medium => AppColors.warning,
        OrganizerActionSeverity.low => AppColors.info,
      };

  Color _severityBg() => switch (item.severity) {
        OrganizerActionSeverity.high => AppColors.errorLight,
        OrganizerActionSeverity.medium => AppColors.warningLight,
        OrganizerActionSeverity.low => AppColors.infoLight,
      };

  Color _severityText() => switch (item.severity) {
        OrganizerActionSeverity.high => AppColors.errorDark,
        OrganizerActionSeverity.medium => AppColors.warningDark,
        OrganizerActionSeverity.low => AppColors.infoDark,
      };

  static String _formatCountdown(Duration d) {
    if (d.inDays > 0) return '${d.inDays} hari lagi';
    if (d.inHours > 0) return '${d.inHours} jam lagi';
    return '${d.inMinutes} menit lagi';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionId = item.sessionId;
    final currency = ref.watch(tenantCurrencyProvider);
    final amount = item.amountImpact;
    final icon =
        DashboardActionList._typeIcon[item.type] ?? Icons.task_alt_outlined;

    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: sessionId != null
            ? () => context.push(AppRoutes.organizerParticipants(sessionId))
            : null,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: _severityBar()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _severityBg(),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSm,
                          ),
                        ),
                        child: Icon(icon, size: 18, color: _severityText()),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (amount != null && amount > 0) ...[
                                  const SizedBox(width: AppDimensions.sm),
                                  MoneyText(
                                    Formatters.formatCurrency(amount, currency),
                                    style: AppTypography.labelMedium.copyWith(
                                      color: _severityText(),
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                    maskWidth: 4,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.subtitle,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (item.timeToStart != null) ...[
                                  const SizedBox(width: AppDimensions.sm),
                                  Icon(
                                    Icons.schedule,
                                    size: 11,
                                    color: _severityBar(),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    _formatCountdown(item.timeToStart!),
                                    style: AppTypography.labelMedium.copyWith(
                                      color: _severityBar(),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (sessionId != null)
                        const Padding(
                          padding: EdgeInsets.only(left: AppDimensions.xs),
                          child: Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.neutral400,
                          ),
                        ),
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
}
