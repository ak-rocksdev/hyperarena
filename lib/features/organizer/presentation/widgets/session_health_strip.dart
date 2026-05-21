import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

/// 3-card health strip: Peserta / Belum bayar / Harga.
///
/// Each card shows a small label, a prominent value (warning-toned when
/// flagged), and a one-line subtitle.
class SessionHealthStrip extends ConsumerWidget {
  const SessionHealthStrip({super.key, required this.session});

  final OpenSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final pending = session.health.pendingPayments;
    final price = session.pricing?.effectivePrice ?? session.pricePerPerson;

    return Row(
      children: [
        Expanded(
          child: _Cell(
            label: 'Peserta',
            value: '${session.currentPlayers}/${session.maxPlayers}',
            sub: session.health.isLowSignupRisk
                ? 'kuota rendah'
                : (session.currentPlayers >= session.maxPlayers
                    ? 'penuh'
                    : null),
            warn: session.health.isLowSignupRisk,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Cell(
            label: 'Belum bayar',
            value: '$pending',
            sub: pending > 0 ? 'perlu konfirmasi' : 'tidak ada',
            warn: pending > 0,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Cell(
            label: 'Harga',
            value: Formatters.formatCurrencyCompact(price, currency),
            sub: 'per peserta',
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.label,
    required this.value,
    this.sub,
    this.warn = false,
  });

  final String label;
  final String value;
  final String? sub;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: warn ? AppColors.warningDark : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(
              sub!,
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
    );
  }
}
