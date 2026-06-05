import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:intl/intl.dart';

/// Compact prev/next period selector with a tappable center label that opens
/// a month picker. Stays at the very top of the wallet screen — its position
/// is fixed so the user always knows "what period am I looking at?".
class WalletPeriodSelector extends ConsumerWidget {
  const WalletPeriodSelector({super.key});

  static const _earliestYear = 2025; // adjust if coach onboarding pre-dates this

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(walletPeriodProvider);
    final dt = _parsePeriod(period);
    final isCurrentMonth = _isCurrentMonth(dt);
    final isEarliest = _isEarliestMonth(dt);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.sm,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            _ChevronButton(
              icon: Icons.chevron_left_rounded,
              enabled: !isEarliest,
              onTap: isEarliest
                  ? null
                  : () => _shift(ref, dt, -1),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                onTap: () => _openPicker(context, ref, dt),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.yMMMM('id').format(dt),
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _ChevronButton(
              icon: Icons.chevron_right_rounded,
              enabled: !isCurrentMonth,
              onTap: isCurrentMonth ? null : () => _shift(ref, dt, 1),
            ),
          ],
        ),
      ),
    );
  }

  void _shift(WidgetRef ref, DateTime current, int monthsDelta) {
    final next = DateTime(current.year, current.month + monthsDelta);
    ref.read(walletPeriodProvider.notifier).state = _formatPeriod(next);
  }

  Future<void> _openPicker(
    BuildContext context,
    WidgetRef ref,
    DateTime current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(_earliestYear),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      locale: const Locale('id'),
    );
    if (picked != null) {
      ref.read(walletPeriodProvider.notifier).state = _formatPeriod(picked);
    }
  }

  static DateTime _parsePeriod(String period) {
    final parts = period.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  static String _formatPeriod(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

  static bool _isCurrentMonth(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month;
  }

  static bool _isEarliestMonth(DateTime dt) =>
      dt.year == _earliestYear && dt.month == 1;
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: onTap,
        child: Icon(
          icon,
          size: 22,
          color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
        ),
      ),
    );
  }
}
