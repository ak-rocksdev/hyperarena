import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Groups action items by category and renders each group as a collapsible
/// task card with a primary action button.
class ActionQueueWidget extends ConsumerWidget {
  const ActionQueueWidget({super.key, required this.items});

  final List<OrganizerActionItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final currency = ref.watch(tenantCurrencyProvider);
    final groups = _groupItems(items, currency);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perlu Tindakan', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.sm),
        for (final group in groups) ...[
          _ActionGroupCard(group: group),
          const SizedBox(height: AppDimensions.sm),
        ],
      ],
    );
  }

  List<_ActionGroup> _groupItems(
      List<OrganizerActionItem> items, String currency) {
    final paymentItems = items
        .where((i) => i.type == OrganizerActionType.confirmPayment)
        .toList();
    final riskItems =
        items.where((i) => i.type == OrganizerActionType.sessionRisk).toList();
    final disputeItems =
        items.where((i) => i.type == OrganizerActionType.dispute).toList();

    final groups = <_ActionGroup>[];
    if (paymentItems.isNotEmpty) {
      final totalAmount =
          paymentItems.fold<int>(0, (sum, i) => sum + (i.amountImpact ?? 0));
      groups.add(_ActionGroup(
        icon: Icons.payment,
        label: 'Pembayaran Tertunda',
        color: AppColors.warning,
        count: paymentItems.length,
        impactText: totalAmount > 0
            ? '${_totalParticipantCount(paymentItems)} pemain · ${Formatters.formatCurrencyCompact(totalAmount, currency)}'
            : '${paymentItems.length} sesi',
        actionLabel: 'Ingatkan Semua',
        items: paymentItems,
        onAction: () {
          // Phase 5+: send payment reminders via push notification
        },
      ));
    }
    if (riskItems.isNotEmpty) {
      final nearest = riskItems
          .where((i) => i.timeToStart != null)
          .fold<Duration?>(null, (min, i) {
        if (min == null || i.timeToStart! < min) return i.timeToStart;
        return min;
      });
      final impactText = nearest != null
          ? '${riskItems.length} sesi · Terdekat mulai ${_formatDuration(nearest)}'
          : '${riskItems.length} sesi';
      groups.add(_ActionGroup(
        icon: Icons.people_outline,
        label: 'Kuota Rendah',
        color: AppColors.accent,
        count: riskItems.length,
        impactText: impactText,
        actionLabel: 'Undang Pemain',
        items: riskItems,
        onAction: () {
          // Phase 5+: share invite links via Share Sheet / deep link
        },
      ));
    }
    if (disputeItems.isNotEmpty) {
      groups.add(_ActionGroup(
        icon: Icons.gavel,
        label: 'Komplain',
        color: AppColors.error,
        count: disputeItems.length,
        impactText: '${disputeItems.length} kasus',
        actionLabel: 'Selesaikan',
        items: disputeItems,
        onAction: () {
          // Phase 5+: navigate to dispute resolution screen
        },
      ));
    }
    return groups;
  }

  int _totalParticipantCount(List<OrganizerActionItem> items) {
    // Extract participant count from title like "Konfirmasi 2 pembayaran"
    var total = 0;
    for (final item in items) {
      final match = RegExp(r'(\d+)').firstMatch(item.title);
      if (match != null) total += int.parse(match.group(1)!);
    }
    return total;
  }

  static String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays} hari lagi';
    if (d.inHours > 0) return '${d.inHours} jam lagi';
    return '${d.inMinutes} menit lagi';
  }
}

class _ActionGroup {
  const _ActionGroup({
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
    required this.impactText,
    required this.actionLabel,
    required this.items,
    required this.onAction,
  });

  final IconData icon;
  final String label;
  final Color color;
  final int count;
  final String impactText;
  final String actionLabel;
  final List<OrganizerActionItem> items;
  final VoidCallback onAction;
}

class _ActionGroupCard extends StatefulWidget {
  const _ActionGroupCard({required this.group});

  final _ActionGroup group;

  @override
  State<_ActionGroupCard> createState() => _ActionGroupCardState();
}

class _ActionGroupCardState extends State<_ActionGroupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.group;

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          // ── Summary row ─────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: g.color.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(g.icon, size: 20, color: g.color),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.label, style: AppTypography.titleSmall),
                        const SizedBox(height: 2),
                        Text(
                          g.impactText,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: g.onAction,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      backgroundColor: g.color.withValues(alpha: 0.1),
                      foregroundColor: g.color,
                    ),
                    child: Text(g.actionLabel),
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: AppColors.neutral400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded detail rows ────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(height: 1, color: AppColors.neutral100),
                for (final item in g.items)
                  _ActionItemDetail(item: item, color: g.color),
              ],
            ),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _ActionItemDetail extends ConsumerWidget {
  const _ActionItemDetail({required this.item, required this.color});

  final OrganizerActionItem item;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionId = item.sessionId;
    final currency = ref.watch(tenantCurrencyProvider);

    return InkWell(
      onTap: sessionId != null
          ? () => context.push(AppRoutes.organizerParticipants(sessionId))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.base,
          vertical: AppDimensions.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTypography.bodySmall),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      style: AppTypography.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (item.amountImpact != null && item.amountImpact! > 0)
                    Text(
                      Formatters.formatCurrencyCompact(item.amountImpact!, currency),
                      style: AppTypography.caption.copyWith(color: color),
                    ),
                ],
              ),
            ),
            if (item.timeToStart != null)
              Text(
                ActionQueueWidget._formatDuration(item.timeToStart!),
                style: AppTypography.caption,
              ),
            if (sessionId != null)
              Padding(
                padding: const EdgeInsets.only(left: AppDimensions.xs),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.neutral400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
