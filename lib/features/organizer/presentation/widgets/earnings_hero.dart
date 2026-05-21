import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/shared/providers/money_visibility_provider.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

enum EarningsPeriod { week, month, all, custom }

/// White-card hero for the earnings detail screen.
///
/// Layout:
///   [period chips ──────────────────────────]
///   PENDAPATAN BERSIH · {period}    [eye]
///   Rp 22.400.000
///   dari 24 sesi · +17,3% vs bulan lalu
///   [bar chart]
///
/// Optional [weeklyChart] is rendered as 12 vertical bars; hidden when null
/// or empty. [deltaVsPrev] hidden when null. [sessionCount] hidden when null.
class EarningsHero extends ConsumerWidget {
  const EarningsHero({
    super.key,
    required this.period,
    required this.netAmount,
    required this.periodLabel,
    required this.onPeriodChange,
    required this.onPickCustomRange,
    this.customRangeLabel,
    this.sessionCount,
    this.deltaVsPrev,
    this.weeklyChart = const <double>[],
  });

  final EarningsPeriod period;
  final int netAmount;

  /// Uppercase label fragment for the hero, e.g. "MEI 2026" or "MINGGU INI"
  final String periodLabel;

  final ValueChanged<EarningsPeriod> onPeriodChange;
  final VoidCallback onPickCustomRange;

  /// Shown on the "Pilih" chip when active and a range is set.
  final String? customRangeLabel;

  final int? sessionCount;
  final double? deltaVsPrev;
  final List<double> weeklyChart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final visible = ref.watch(moneyVisibilityProvider);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _PeriodChip(
                  label: 'Minggu',
                  active: period == EarningsPeriod.week,
                  onTap: () => onPeriodChange(EarningsPeriod.week),
                ),
                const SizedBox(width: 6),
                _PeriodChip(
                  label: 'Bulan ini',
                  active: period == EarningsPeriod.month,
                  onTap: () => onPeriodChange(EarningsPeriod.month),
                ),
                const SizedBox(width: 6),
                _PeriodChip(
                  label: 'Semua',
                  active: period == EarningsPeriod.all,
                  onTap: () => onPeriodChange(EarningsPeriod.all),
                ),
                const SizedBox(width: 6),
                _PeriodChip(
                  label: period == EarningsPeriod.custom &&
                          customRangeLabel != null
                      ? customRangeLabel!
                      : 'Pilih',
                  active: period == EarningsPeriod.custom,
                  leadingIcon: Icons.calendar_today_outlined,
                  onTap: onPickCustomRange,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  'PENDAPATAN BERSIH · ${periodLabel.toUpperCase()}',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    fontSize: 10,
                  ),
                ),
              ),
              _EyeToggleSmall(visible: visible),
            ],
          ),
          const SizedBox(height: 4),
          MoneyText(
            Formatters.formatCurrency(netAmount, currency),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.05,
              letterSpacing: -0.8,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Always render the caption row (with placeholder text when
          // delta/sessionCount are BE-pending) so the hero stays stable.
          const SizedBox(height: 4),
          _CaptionLine(
            sessionCount: sessionCount,
            deltaVsPrev: deltaVsPrev,
          ),
          // Bar chart always reserves space — empty muted bars + small
          // caption when BE has not delivered `weeklyChart` yet.
          const SizedBox(height: AppDimensions.base),
          _MiniBarChart(data: weeklyChart),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : AppColors.textSecondary;
    return Material(
      color: active ? AppColors.primary : AppColors.neutral100,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 13, color: fg),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaptionLine extends StatelessWidget {
  const _CaptionLine({required this.sessionCount, required this.deltaVsPrev});

  final int? sessionCount;
  final double? deltaVsPrev;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textSecondary,
    );
    final positive = (deltaVsPrev ?? 0) >= 0;
    final deltaColor = positive ? AppColors.successDark : AppColors.errorDark;

    final sessionText = sessionCount != null ? '$sessionCount sesi' : '— sesi';

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'dari '),
          TextSpan(
            text: sessionText,
            style: baseStyle.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const TextSpan(text: ' · '),
          if (deltaVsPrev != null)
            TextSpan(
              text:
                  '${positive ? '+' : ''}${deltaVsPrev!.toStringAsFixed(1).replaceAll('.', ',')}% vs bulan lalu',
              style: baseStyle.copyWith(
                color: deltaColor,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            TextSpan(text: 'vs bulan lalu', style: baseStyle),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart({required this.data});

  final List<double> data;

  @override
  Widget build(BuildContext context) {
    // Empty placeholder: 12 short muted bars + caption.
    if (data.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 12; i++) ...[
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  if (i < 11) const SizedBox(width: 4),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tren mingguan akan tampil setelah backend update',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ],
      );
    }

    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final highlightIdx = data.length - 2;

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < data.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: maxVal > 0 ? (data[i] / maxVal) * 60 : 0,
                    decoration: BoxDecoration(
                      color: i == highlightIdx
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${i + 1}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (i < data.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _EyeToggleSmall extends ConsumerWidget {
  const _EyeToggleSmall({required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.neutral100,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => ref.read(moneyVisibilityProvider.notifier).toggle(),
        child: SizedBox(
          width: 26,
          height: 26,
          child: Icon(
            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 13,
          ),
        ),
      ),
    );
  }
}
