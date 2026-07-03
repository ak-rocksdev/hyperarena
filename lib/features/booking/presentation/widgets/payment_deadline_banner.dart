import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';

/// Amber "pay before" banner with a live countdown for a booking that is
/// awaiting payment. Flips to a red "expired" state the moment [expiresAt]
/// passes — so the deadline is visible BEFORE it lapses, not only after.
///
/// Ticks locally every second; drives the display off the absolute [expiresAt]
/// each tick, so it stays accurate across rebuilds and re-entries.
class PaymentDeadlineBanner extends StatefulWidget {
  const PaymentDeadlineBanner({super.key, required this.expiresAt});

  final DateTime expiresAt;

  @override
  State<PaymentDeadlineBanner> createState() => _PaymentDeadlineBannerState();
}

class _PaymentDeadlineBannerState extends State<PaymentDeadlineBanner> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _compute();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final r = _compute();
      setState(() => _remaining = r);
      if (r == Duration.zero) _timer?.cancel();
    });
  }

  Duration _compute() {
    final r = widget.expiresAt.difference(DateTime.now());
    return r.isNegative ? Duration.zero : r;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '${h.toString().padLeft(2, '0')}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final bg = expired ? AppColors.errorLight : AppColors.warningLight;
    final fg = expired ? AppColors.errorDark : AppColors.warningDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            expired ? Icons.timer_off_rounded : Icons.timer_rounded,
            size: 20,
            color: fg,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expired
                      ? 'Batas waktu pembayaran berakhir'
                      : 'Selesaikan pembayaran',
                  style: AppTypography.titleSmall.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expired
                      ? 'Booking ini akan dibatalkan otomatis. Silakan pesan ulang.'
                      : 'Bayar sebelum ${Formatters.formatDateTimeCompact(widget.expiresAt)}',
                  style: AppTypography.caption.copyWith(color: fg),
                ),
              ],
            ),
          ),
          if (!expired) ...[
            const SizedBox(width: AppDimensions.sm),
            Text(
              _fmt(_remaining),
              style: AppTypography.titleMedium.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
