import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/organizer/data/models/session_financial.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// Settlement breakdown card for the session detail screen.
///
/// Layout:
///   ┌──────────────────────────────┐
///   │ PENDAPATAN BERSIH (PROYEKSI) │
///   │ Rp 250.000        [+34%]     │   ← tinted bg (green/red)
///   ├──────────────────────────────┤
///   │ PENDAPATAN          Rp 750k  │
///   │   Pembayaran (3×)   Rp 750k  │
///   │   Refund                  —  │
///   ├──────────────────────────────┤
///   │ BIAYA               −Rp 800k │
///   │   Honor pelatih    −Rp 800k  │
///   └──────────────────────────────┘
class SessionSettlementCard extends StatelessWidget {
  const SessionSettlementCard({super.key, required this.financial});

  final SessionFinancial financial;

  @override
  Widget build(BuildContext context) {
    final currency = financial.currency;

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _NetTopBlock(net: financial.net, currency: currency),
          _Group(
            label: 'PENDAPATAN',
            accent: AppColors.successDark,
            side: financial.revenue,
            currency: currency,
          ),
          if (financial.cost.total > 0 ||
              financial.cost.systemTracked.streams.isNotEmpty ||
              financial.cost.custom.entries.isNotEmpty)
            _Group(
              label: 'BIAYA',
              accent: AppColors.errorDark,
              side: financial.cost,
              currency: currency,
              negative: true,
            ),
        ],
      ),
    );
  }
}

class _NetTopBlock extends StatelessWidget {
  const _NetTopBlock({required this.net, required this.currency});

  final FinancialNet net;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isPositive = net.amount >= 0;
    final tintBg = isPositive
        ? const Color(0xFFF0FDF4) // light-green wash
        : const Color(0xFFFEF7F2); // light-red wash
    final numberColor = isPositive ? AppColors.successDark : AppColors.errorDark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      color: tintBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PENDAPATAN BERSIH (PROYEKSI)',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                MoneyText(
                  (isPositive ? '+' : '') +
                      Formatters.formatCurrency(net.amount, currency),
                  style: AppTypography.displaySmall.copyWith(
                    color: numberColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.05,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          if (net.marginPercent != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFFECACA),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                '${net.marginPercent! >= 0 ? '+' : ''}${net.marginPercent}%',
                style: AppTypography.labelMedium.copyWith(
                  color: numberColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.label,
    required this.accent,
    required this.side,
    required this.currency,
    this.negative = false,
  });

  final String label;
  final Color accent;
  final FinancialSide side;
  final String currency;
  final bool negative;

  String _signed(int v) => negative
      ? (v == 0 ? '—' : '− ${Formatters.formatCurrency(v.abs(), currency)}')
      : Formatters.formatCurrency(v, currency);

  @override
  Widget build(BuildContext context) {
    final streams = side.systemTracked.streams;
    final entries = side.custom.entries;
    final total = side.total;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.overline.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    fontSize: 10,
                  ),
                ),
              ),
              MoneyText(
                _signed(total),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final stream in streams)
            _Line(
              label: stream.displayLabel,
              valueText: _signed(stream.amount),
              muted: stream.amount == 0,
            ),
          for (final entry in entries)
            _Line(
              label: entry.category?.name ?? 'Entri kustom',
              sub: entry.notes,
              valueText: _signed(entry.amount),
              muted: entry.amount == 0,
            ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.valueText,
    this.sub,
    this.muted = false,
  });

  final String label;
  final String valueText;
  final String? sub;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final opacity = muted ? 0.55 : 1.0;
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  if (sub != null && sub!.isNotEmpty)
                    Text(
                      sub!,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            MoneyText(
              valueText,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
