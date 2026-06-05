import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_status_badge.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// One session-earning row in the Wallet feed. Tappable when the payout is
/// linked to a session — pushes the existing coach session detail screen so
/// the coach can see attendance, students, time, etc. Per spec Non-Goal #4
/// there is no per-session "Cairkan" action — withdrawal stays batched at the
/// period level via the hero CTA.
class WalletSessionRow extends StatelessWidget {
  const WalletSessionRow({super.key, required this.payout});

  final CoachPayout payout;

  @override
  Widget build(BuildContext context) {
    final kind = WalletStatusBadge.fromPayout(
      status: payout.status,
      requestId: payout.requestId,
    );

    final sessionTitle = _sessionTitle();
    final dateLabel = _dateLabel();
    final amount = Formatters.formatCurrency(payout.amount, payout.currency);
    final sessionId = payout.sessionId;

    final card = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppSurfaces.surfaceHighlight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_tennis_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionTitle,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(dateLabel, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTypography.priceSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              WalletStatusBadge(kind: kind, compact: true),
            ],
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: sessionId == null
          ? card
          : Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                onTap: () {
                  AppHaptics.tap();
                  context.push(AppRoutes.coachSessionDetail('$sessionId'));
                },
                child: card,
              ),
            ),
    );
  }

  String _sessionTitle() {
    final meta = payout.sessionMeta;
    if (meta == null) return 'Sesi #${payout.sessionId ?? payout.id}';
    final type = meta['type'] as String?;
    final typeLabel = switch (type) {
      'private' => 'Privat',
      'trial' => 'Trial',
      _ => 'Grup',
    };
    return 'Sesi $typeLabel';
  }

  String _dateLabel() {
    final meta = payout.sessionMeta;
    DateTime? when;
    if (meta != null && meta['start_at'] != null) {
      when = DateTime.tryParse(meta['start_at'] as String);
    }
    when ??= payout.createdAt;
    return Formatters.formatDateTimeCompact(when);
  }
}
