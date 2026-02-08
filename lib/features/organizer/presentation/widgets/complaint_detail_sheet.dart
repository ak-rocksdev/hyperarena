import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

/// Bottom sheet that shows full complaint details for an organizer.
///
/// Displays: player info, complaint reason, amount at stake, evidence,
/// timeline, and resolution actions.
class ComplaintDetailSheet extends StatelessWidget {
  const ComplaintDetailSheet({
    super.key,
    required this.participant,
    required this.sessionTitle,
    required this.pricePerPerson,
    this.onConfirmPayment,
    this.onRefund,
    this.onReject,
    this.onContactPlayer,
  });

  final SessionParticipant participant;
  final String sessionTitle;
  final int pricePerPerson;
  final VoidCallback? onConfirmPayment;
  final VoidCallback? onRefund;
  final VoidCallback? onReject;
  final VoidCallback? onContactPlayer;

  static Future<void> show(
    BuildContext context, {
    required SessionParticipant participant,
    required String sessionTitle,
    required int pricePerPerson,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXl),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: ComplaintDetailSheet(
              participant: participant,
              sessionTitle: sessionTitle,
              pricePerPerson: pricePerPerson,
            ),
          ),
        ),
      ),
    );
  }

  String get _complaintCategory {
    final reason = (participant.disputeReason ?? '').toLowerCase();
    if (reason.contains('transfer') || reason.contains('bayar')) {
      return 'Masalah Pembayaran';
    }
    if (reason.contains('lapangan') || reason.contains('venue')) {
      return 'Ketidaksesuaian Venue';
    }
    if (reason.contains('level') || reason.contains('pemula')) {
      return 'Ketidaksesuaian Level';
    }
    return 'Komplain Umum';
  }

  IconData get _complaintIcon {
    final reason = (participant.disputeReason ?? '').toLowerCase();
    if (reason.contains('transfer') || reason.contains('bayar')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (reason.contains('lapangan') || reason.contains('venue')) {
      return Icons.location_off_outlined;
    }
    if (reason.contains('level') || reason.contains('pemula')) {
      return Icons.signal_cellular_alt;
    }
    return Icons.report_problem_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.sm,
        AppDimensions.lg,
        AppDimensions.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ───────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppDimensions.base),
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ────────────────────────────────────────
          _buildHeader(),
          const SizedBox(height: AppDimensions.lg),

          // ── Player info ───────────────────────────────────
          _buildSection(
            'Pemain',
            Icons.person_outline,
            _buildPlayerInfo(),
          ),
          const SizedBox(height: AppDimensions.base),

          // ── Session info ──────────────────────────────────
          _buildSection(
            'Sesi',
            Icons.sports,
            _buildSessionInfo(),
          ),
          const SizedBox(height: AppDimensions.base),

          // ── Complaint reason ──────────────────────────────
          _buildSection(
            'Alasan Komplain',
            Icons.chat_bubble_outline,
            _buildComplaintReason(),
          ),
          const SizedBox(height: AppDimensions.base),

          // ── Financial impact ──────────────────────────────
          _buildSection(
            'Dampak Keuangan',
            Icons.monetization_on_outlined,
            _buildFinancialImpact(),
          ),
          const SizedBox(height: AppDimensions.base),

          // ── Timeline ──────────────────────────────────────
          _buildSection(
            'Kronologi',
            Icons.timeline,
            _buildTimeline(),
          ),
          const SizedBox(height: AppDimensions.xl),

          // ── Resolution actions ────────────────────────────
          _buildResolutionActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(_complaintIcon, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _complaintCategory,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.errorDark,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    'Menunggu Penyelesaian',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.neutral400),
            const SizedBox(width: AppDimensions.xs),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        content,
      ],
    );
  }

  Widget _buildPlayerInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary100,
            child: Text(
              participant.playerName.isNotEmpty
                  ? participant.playerName[0].toUpperCase()
                  : '?',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(participant.playerName, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Text(
                  'Bergabung ${_formatRelativeTime(participant.joinedAt)}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            participant.paymentMethod.name.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.event, size: 18, color: AppColors.neutral500),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(sessionTitle, style: AppTypography.bodyMedium),
          ),
          Text(
            Formatters.formatRupiah(pricePerPerson),
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppSurfaces.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Text(
            participant.disputeReason ?? 'Tidak ada keterangan dari pemain.',
            style: AppTypography.bodyMedium,
          ),
        ),
        if (participant.evidenceUrl != null) ...[
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Row(
              children: [
                Icon(Icons.image_outlined, size: 18, color: AppColors.info),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Bukti terlampir dari pemain',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.infoDark,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: AppColors.info,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialImpact() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Column(
        children: [
          _financeRow(
            'Harga sesi per orang',
            Formatters.formatRupiah(pricePerPerson),
            AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          _financeRow(
            'Sudah dibayar pemain',
            Formatters.formatRupiah(participant.paidAmount),
            participant.paidAmount > 0
                ? AppColors.success
                : AppColors.neutral400,
          ),
          const SizedBox(height: AppDimensions.sm),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: AppDimensions.sm),
          _financeRow(
            'Dana ditahan',
            Formatters.formatRupiah(participant.paidAmount),
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _financeRow(String label, String amount, Color amountColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Text(
          amount,
          style: AppTypography.titleSmall.copyWith(color: amountColor),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    final events = <_TimelineEvent>[];
    events.add(_TimelineEvent(
      time: participant.joinedAt,
      label: 'Pemain mendaftar sesi',
      icon: Icons.person_add_outlined,
    ));
    if (participant.paidAt != null) {
      events.add(_TimelineEvent(
        time: participant.paidAt!,
        label: 'Pembayaran ${Formatters.formatRupiah(participant.paidAmount)}',
        icon: Icons.payment,
      ));
    }
    // Estimate dispute time as ~2 hours after join
    events.add(_TimelineEvent(
      time: participant.joinedAt.add(const Duration(hours: 2)),
      label: 'Komplain diajukan',
      icon: Icons.report_outlined,
      isHighlight: true,
    ));

    return Column(
      children: [
        for (var i = 0; i < events.length; i++)
          _buildTimelineItem(events[i], isLast: i == events.length - 1),
      ],
    );
  }

  Widget _buildTimelineItem(_TimelineEvent event, {bool isLast = false}) {
    final color = event.isHighlight ? AppColors.error : AppColors.neutral400;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: event.isHighlight
                      ? AppColors.error
                      : AppColors.neutral300,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: event.isHighlight
                        ? AppColors.errorDark
                        : AppColors.neutral400,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 28,
                  color: AppColors.neutral200,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: AppTypography.bodySmall.copyWith(
                    color: event.isHighlight
                        ? AppColors.error
                        : AppColors.textPrimary,
                    fontWeight:
                        event.isHighlight ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                Text(
                  _formatRelativeTime(event.time),
                  style: AppTypography.caption.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResolutionActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.gavel, size: 16, color: AppColors.neutral400),
            const SizedBox(width: AppDimensions.xs),
            Text(
              'Tindakan Penyelesaian',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),

        // Primary action — depends on complaint category
        if (_complaintCategory == 'Masalah Pembayaran') ...[
          _buildActionCard(
            icon: Icons.check_circle_outline,
            label: 'Konfirmasi Pembayaran',
            description: 'Tandai pembayaran pemain sebagai terverifikasi. '
                'Dana akan masuk ke saldo tersedia.',
            color: AppColors.success,
            onTap: () {
              Navigator.of(context).pop();
              onConfirmPayment?.call();
            },
          ),
          const SizedBox(height: AppDimensions.sm),
        ],

        _buildActionCard(
          icon: Icons.replay,
          label: 'Refund ke Pemain',
          description:
              'Kembalikan ${Formatters.formatRupiah(participant.paidAmount)} '
              'ke pemain. Cocok jika keluhan valid dan sesi tidak sesuai.',
          color: AppColors.warning,
          onTap: () {
            Navigator.of(context).pop();
            onRefund?.call();
          },
        ),
        const SizedBox(height: AppDimensions.sm),

        _buildActionCard(
          icon: Icons.chat_outlined,
          label: 'Hubungi Pemain',
          description: 'Kirim pesan ke pemain untuk klarifikasi masalah '
              'sebelum mengambil keputusan.',
          color: AppColors.primary,
          onTap: () {
            Navigator.of(context).pop();
            onContactPlayer?.call();
          },
        ),
        const SizedBox(height: AppDimensions.sm),

        _buildActionCard(
          icon: Icons.cancel_outlined,
          label: 'Tolak Komplain',
          description: 'Jika keluhan tidak berdasar, tolak dan lepaskan '
              'dana ke saldo tersedia.',
          color: AppColors.neutral500,
          onTap: () {
            Navigator.of(context).pop();
            onReject?.call();
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.titleSmall.copyWith(color: color),
                  ),
                  const SizedBox(height: 2),
                  Text(description, style: AppTypography.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: color),
          ],
        ),
      ),
    );
  }

  static String _formatRelativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} hari yang lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam yang lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit yang lalu';
    return 'Baru saja';
  }
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.time,
    required this.label,
    required this.icon,
    this.isHighlight = false,
  });

  final DateTime time;
  final String label;
  final IconData icon;
  final bool isHighlight;
}
