import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';
import 'package:hyperarena/shared/widgets/zoomable_image.dart';

/// Redesigned bottom sheet for confirming a participant's payment proof.
///
/// Layout (top → bottom):
///   ─── handle
///   [Avatar] Name              [×]
///           Session title
///   ┌────────────────────────────┐
///   │ JUMLAH KLAIM    METODE     │
///   │ Rp 250.000     Transfer BCA│
///   ├────────────────────────────┤
///   │  ✓ Nominal cocok           │  (or warning when mismatched)
///   ├────────────────────────────┤
///   │ BUKTI TRANSFER             │
///   │ [zoomable image]           │
///   ├────────────────────────────┤
///   │ [Tolak] [Tandai Lunas]     │
///
/// Use [show] static method — handles `showModalBottomSheet` plumbing.
class PaymentProofSheet extends ConsumerWidget {
  const PaymentProofSheet({
    super.key,
    required this.participant,
    required this.sessionTitle,
    required this.expectedAmount,
    required this.onConfirm,
    required this.onReject,
  });

  final SessionParticipant participant;
  final String sessionTitle;

  /// Expected price per peer (resolved via `session.pricing` or
  /// `pricePerPerson`). Used to compute the nominal match indicator.
  final int expectedAmount;

  /// Called when "Tandai Lunas" is tapped. Sheet is auto-popped first.
  final Future<void> Function() onConfirm;

  /// Called when "Tolak" is tapped. Sheet is auto-popped first. Caller is
  /// responsible for collecting a rejection reason if needed.
  final VoidCallback onReject;

  static Future<void> show({
    required BuildContext context,
    required SessionParticipant participant,
    required String sessionTitle,
    required int expectedAmount,
    required Future<void> Function() onConfirm,
    required VoidCallback onReject,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentProofSheet(
        participant: participant,
        sessionTitle: sessionTitle,
        expectedAmount: expectedAmount,
        onConfirm: onConfirm,
        onReject: onReject,
      ),
    );
  }

  String _methodLabel() => switch (participant.paymentMethod) {
        PaymentMethodType.qris => 'QRIS',
        PaymentMethodType.bankTransfer => 'Transfer Bank',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final claimed = participant.paidAmount;
    final isMatch =
        expectedAmount > 0 && claimed > 0 && claimed == expectedAmount;
    final isUnderpaid = claimed > 0 && claimed < expectedAmount;
    final initials = Formatters.initials(participant.playerName);

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            ),
            // Header: avatar + name + session + close
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.sm,
                AppDimensions.md,
                AppDimensions.md,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary50,
                    child: Text(
                      initials,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          participant.playerName,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sessionTitle,
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Amount block grid
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.base),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'JUMLAH KLAIM',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          MoneyText(
                            Formatters.formatCurrency(claimed, currency),
                            style: AppTypography.headingMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'METODE',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _methodLabel(),
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (participant.paidAt != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              Formatters.formatDateTimeCompact(
                                  participant.paidAt!),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Match check / mismatch warning
            if (expectedAmount > 0 && claimed > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.lg,
                  AppDimensions.md,
                  AppDimensions.lg,
                  0,
                ),
                child: _MatchCheckBanner(
                  isMatch: isMatch,
                  isUnderpaid: isUnderpaid,
                  expectedAmount: expectedAmount,
                  claimed: claimed,
                  currency: currency,
                ),
              ),
            // Proof preview
            if (participant.evidenceUrl != null &&
                participant.evidenceUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.lg,
                  AppDimensions.md,
                  AppDimensions.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BUKTI TRANSFER',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Tap untuk perbesar',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    ZoomableImage(
                      heroTag: 'payment-proof-${participant.id}',
                      imageUrl: participant.evidenceUrl!,
                      thumbnailHeight: 180,
                    ),
                  ],
                ),
              ),
            // Action buttons — Tolak (1) + Tandai Lunas (2)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.lg,
                AppDimensions.lg,
                AppDimensions.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onReject();
                      },
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorDark,
                        side: BorderSide(color: AppColors.border, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        textStyle: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await onConfirm();
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Tandai Lunas'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        textStyle: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCheckBanner extends StatelessWidget {
  const _MatchCheckBanner({
    required this.isMatch,
    required this.isUnderpaid,
    required this.expectedAmount,
    required this.claimed,
    required this.currency,
  });

  final bool isMatch;
  final bool isUnderpaid;
  final int expectedAmount;
  final int claimed;
  final String currency;

  @override
  Widget build(BuildContext context) {
    if (isMatch) {
      return _ChipRow(
        icon: Icons.check_circle,
        iconColor: AppColors.successDark,
        bg: AppColors.successLight,
        fg: AppColors.successDark,
        text: 'Nominal cocok dengan tagihan',
      );
    }

    // Mismatch — show the delta so organizer sees the gap.
    final delta = claimed - expectedAmount;
    final deltaText = delta > 0
        ? 'Kelebihan ${Formatters.formatCurrencyCompact(delta, currency)}'
        : 'Kurang ${Formatters.formatCurrencyCompact(delta.abs(), currency)}';

    return _ChipRow(
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.warningDark,
      bg: AppColors.warningLight,
      fg: AppColors.warningDark,
      text: 'Nominal tidak cocok · $deltaText',
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.fg,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;
  final Color fg;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
