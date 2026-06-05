import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// One row in the Withdrawal History screen. Tap → detail screen.
/// Status pill on the top-right is the most important visual element —
/// "Ditolak" must be impossible to miss without being garish.
class WithdrawalRequestRow extends StatelessWidget {
  const WithdrawalRequestRow({
    super.key,
    required this.request,
    required this.currency,
  });

  final PayoutRequest request;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteForStatus(request.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Material(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () => context.push(
            AppRoutes.coachWithdrawalDetail(request.id),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.base),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Formatters.formatDate(request.requestedAt),
                        style: AppTypography.caption,
                      ),
                    ),
                    _StatusPill(
                      label: palette.label,
                      bg: palette.background,
                      fg: palette.foreground,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        Formatters.formatCurrency(
                          request.totalAmountCents,
                          currency,
                        ),
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    if (request.linkedSessionCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '${request.linkedSessionCount} sesi',
                          style: AppTypography.caption,
                        ),
                      ),
                  ],
                ),
                if (request.status == 'rejected' &&
                    request.rejectionNote != null) ...[
                  const SizedBox(height: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: AppColors.errorDark,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Ada catatan dari admin · ketuk untuk lihat',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.errorDark,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static _StatusPalette _paletteForStatus(String status) => switch (status) {
        'pending' => const _StatusPalette(
            label: 'Menunggu',
            background: AppColors.warningLight,
            foreground: AppColors.warningDark,
          ),
        'approved' => const _StatusPalette(
            label: 'Disetujui',
            background: AppColors.infoLight,
            foreground: AppColors.infoDark,
          ),
        'rejected' => const _StatusPalette(
            label: 'Ditolak',
            background: AppColors.errorLight,
            foreground: AppColors.errorDark,
          ),
        'cancelled' => const _StatusPalette(
            label: 'Dibatalkan',
            background: AppColors.neutral100,
            foreground: AppColors.textSecondary,
          ),
        _ => const _StatusPalette(
            label: '—',
            background: AppColors.neutral100,
            foreground: AppColors.textSecondary,
          ),
      };
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.bg,
    required this.fg,
  });
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _StatusPalette {
  const _StatusPalette({
    required this.label,
    required this.background,
    required this.foreground,
  });
  final String label;
  final Color background;
  final Color foreground;
}
