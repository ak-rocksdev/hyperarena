import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:hyperarena/features/wallet/utils/wallet_period.dart';

class CoachWithdrawalDetailScreen extends ConsumerWidget {
  const CoachWithdrawalDetailScreen({super.key, required this.requestId});

  final int requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(withdrawalDetailProvider(requestId));
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      backgroundColor: AppSurfaces.background,
      appBar: AppBar(
        title: const Text('Detail Pencairan'),
        backgroundColor: AppSurfaces.background,
        scrolledUnderElevation: 0,
      ),
      body: async.when(
        data: (req) => _Body(request: req, currency: currency),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => _ErrorView(
          onRetry: () => ref.invalidate(withdrawalDetailProvider(requestId)),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.request, required this.currency});
  final PayoutRequest request;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final hasRejection = request.status == 'rejected' &&
        request.rejectionNote != null &&
        request.rejectionNote!.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
      children: [
        _HeaderCard(request: request, currency: currency),
        if (hasRejection) ...[
          const SizedBox(height: AppDimensions.base),
          _RejectionBlock(note: request.rejectionNote!),
        ],
        if (request.processedAt != null) ...[
          const SizedBox(height: AppDimensions.base),
          _ProcessedBlock(request: request),
        ],
        const SizedBox(height: AppDimensions.xl),
        _SessionsSection(request: request, currency: currency),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.request, required this.currency});
  final PayoutRequest request;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final statusPalette = _statusPalette(request.status);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUMLAH',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.formatCurrency(
                        request.totalAmountCents,
                        currency,
                      ),
                      style: AppTypography.numberMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusPalette.bg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  statusPalette.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: statusPalette.fg,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppDimensions.lg),
          _kv('Periode', WalletPeriod.longLabel(request.period)),
          const SizedBox(height: AppDimensions.sm),
          _kv(
            'Diajukan',
            Formatters.formatDateTimeCompact(request.requestedAt),
          ),
        ],
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: AppTypography.caption),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  static _StatusPalette _statusPalette(String status) => switch (status) {
        'pending' => const _StatusPalette(
            label: 'MENUNGGU',
            bg: AppColors.warningLight,
            fg: AppColors.warningDark,
          ),
        'approved' => const _StatusPalette(
            label: 'DISETUJUI',
            bg: AppColors.infoLight,
            fg: AppColors.infoDark,
          ),
        'rejected' => const _StatusPalette(
            label: 'DITOLAK',
            bg: AppColors.errorLight,
            fg: AppColors.errorDark,
          ),
        'cancelled' => const _StatusPalette(
            label: 'DIBATALKAN',
            bg: AppColors.neutral100,
            fg: AppColors.textSecondary,
          ),
        _ => const _StatusPalette(
            label: '—',
            bg: AppColors.neutral100,
            fg: AppColors.textSecondary,
          ),
      };
}

class _StatusPalette {
  const _StatusPalette({
    required this.label,
    required this.bg,
    required this.fg,
  });
  final String label;
  final Color bg;
  final Color fg;
}

/// The single most important block when present — admin's rejection note.
/// Uses error palette + icon to be impossible to miss without being garish.
class _RejectionBlock extends StatelessWidget {
  const _RejectionBlock({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_rounded,
                  color: AppColors.errorDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Text(
                'Catatan Penolakan',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.errorDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            note,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.errorDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessedBlock extends StatelessWidget {
  const _ProcessedBlock({required this.request});
  final PayoutRequest request;

  @override
  Widget build(BuildContext context) {
    final adminName = (request.processedBy?['name'] as String?) ?? 'Admin';
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodySmall,
                children: [
                  const TextSpan(text: 'Diproses oleh '),
                  TextSpan(
                    text: adminName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' · ${Formatters.formatDateTimeCompact(request.processedAt!)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionsSection extends StatelessWidget {
  const _SessionsSection({required this.request, required this.currency});
  final PayoutRequest request;
  final String currency;

  @override
  Widget build(BuildContext context) {
    if (request.payouts.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimensions.xs),
          child: Row(
            children: [
              Text(
                'Sesi dalam permintaan',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppSurfaces.surfaceHighlight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '${request.payouts.length}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Container(
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              for (var i = 0; i < request.payouts.length; i++) ...[
                _SessionRow(payout: request.payouts[i], currency: currency),
                if (i < request.payouts.length - 1)
                  const Divider(
                    color: AppColors.borderLight,
                    height: 1,
                    indent: AppDimensions.base,
                    endIndent: AppDimensions.base,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.payout, required this.currency});
  final CoachPayout payout;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sessionLabel(payout),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatDate(_when(payout)),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            Formatters.formatCurrency(payout.amount, currency),
            style: AppTypography.priceSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  static String _sessionLabel(CoachPayout p) {
    final meta = p.sessionMeta;
    if (meta == null) return 'Sesi #${p.sessionId ?? p.id}';
    final type = meta['type'] as String?;
    return switch (type) {
      'private' => 'Sesi Privat',
      'trial' => 'Sesi Trial',
      _ => 'Sesi Grup',
    };
  }

  static DateTime _when(CoachPayout p) {
    final meta = p.sessionMeta;
    if (meta != null && meta['start_at'] != null) {
      final parsed = DateTime.tryParse(meta['start_at'] as String);
      if (parsed != null) return parsed;
    }
    return p.createdAt;
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.error),
          const SizedBox(height: AppDimensions.sm),
          const Text('Gagal memuat detail'),
          const SizedBox(height: AppDimensions.sm),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}
