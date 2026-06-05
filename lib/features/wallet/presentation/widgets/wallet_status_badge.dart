import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Per-row payout status pill. Shared by WalletSessionRow + History rows so
/// the color contract is enforced in one place.
enum WalletStatusKind {
  /// `status='pending'` AND `request_id IS NULL` — coach can cairkan now.
  /// Per-row treatment uses warning palette: "needs your attention".
  belumDicairkan,

  /// In transit — `status='pending'` with `request_id` OR `status='approved'`.
  /// Coach has no action; just waiting on admin/bank.
  diproses,

  /// `status='paid'` — money is in the bank.
  sudahDicairkan,
}

class WalletStatusBadge extends StatelessWidget {
  const WalletStatusBadge({super.key, required this.kind, this.compact = false});

  final WalletStatusKind kind;
  final bool compact;

  static String labelOf(WalletStatusKind kind) => switch (kind) {
        WalletStatusKind.belumDicairkan => 'Belum dicairkan',
        WalletStatusKind.diproses => 'Diproses',
        WalletStatusKind.sudahDicairkan => 'Sudah dicairkan',
      };

  /// Maps a Payout's `status` + `request_id` to a kind. Single source of
  /// truth — every status pill in the wallet feature flows through here.
  static WalletStatusKind fromPayout({
    required String status,
    required int? requestId,
  }) {
    switch (status) {
      case 'paid':
        return WalletStatusKind.sudahDicairkan;
      case 'approved':
        return WalletStatusKind.diproses;
      case 'pending':
        return requestId == null
            ? WalletStatusKind.belumDicairkan
            : WalletStatusKind.diproses;
      default:
        return WalletStatusKind.diproses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(kind);
    final padH = compact ? AppDimensions.sm : AppDimensions.md;
    final padV = compact ? 3.0 : 5.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: palette.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            labelOf(kind),
            style: AppTypography.labelSmall.copyWith(
              color: palette.foreground,
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  static _Palette _paletteFor(WalletStatusKind kind) => switch (kind) {
        WalletStatusKind.belumDicairkan => const _Palette(
            background: AppColors.warningLight,
            foreground: AppColors.warningDark,
          ),
        WalletStatusKind.diproses => const _Palette(
            background: AppColors.neutral100,
            foreground: AppColors.textSecondary,
          ),
        WalletStatusKind.sudahDicairkan => const _Palette(
            background: AppColors.successLight,
            foreground: AppColors.successDark,
          ),
      };
}

class _Palette {
  const _Palette({required this.background, required this.foreground});
  final Color background;
  final Color foreground;
}
