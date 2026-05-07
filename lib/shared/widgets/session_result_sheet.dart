import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/widgets/zoomable_image.dart';

/// Read-only modal showing one session's assessment + skill progress for
/// a student. Used by both coach side (`CoachStudentDetailScreen`) and
/// organizer side (`OrganizerMemberDetailScreen`). Consumes the BE 19.2 /
/// 19.3 `session_history[]` item directly.
class SessionResultSheet extends StatelessWidget {
  final SessionHistoryItem session;

  const SessionResultSheet({super.key, required this.session});

  /// Pushes the sheet via `showModalBottomSheet` with a draggable wrapper.
  /// Use this from the parent screen on row tap; do not place the widget
  /// inline.
  static void show(BuildContext context, SessionHistoryItem session) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, _) => SessionResultSheet(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.lg,
            AppDimensions.md,
            AppDimensions.lg,
            AppDimensions.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DragHandle(),
              const SizedBox(height: AppDimensions.md),
              if (session.startAt != null)
                Text(
                  Formatters.formatDateLong(session.startAt!),
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              const SizedBox(height: 2),
              Text(
                session.venueName ?? 'Sesi',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (session.assignedCoach?.name != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Diasuh oleh ${session.assignedCoach!.name}',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
              const SizedBox(height: AppDimensions.lg),

              if (session.assessment != null)
                _OverallScore(assessment: session.assessment!)
              else
                _NoAssessmentNotice(),

              if (session.assessment?.notes != null &&
                  session.assessment!.notes!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.lg),
                _SectionLabel('CATATAN PELATIH'),
                const SizedBox(height: AppDimensions.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    session.assessment!.notes!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              // Payment block — admin scope only. Hide when no payment
              // info or when proof URL is null AND amount is zero (credit).
              if (session.payment != null &&
                  (session.payment!.paymentProofUrl != null ||
                      session.payment!.amountPaid > 0)) ...[
                const SizedBox(height: AppDimensions.lg),
                _SectionLabel('PEMBAYARAN'),
                const SizedBox(height: AppDimensions.sm),
                _PaymentSection(
                  payment: session.payment!,
                  sessionId: session.sessionId,
                ),
              ],

              if (session.skillResults.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.lg),
                _SectionLabel('PROGRES PER-SKILL'),
                const SizedBox(height: AppDimensions.sm),
                ...session.skillResults.map(_SkillRow.new),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        color: AppColors.textTertiary,
        fontWeight: FontWeight.w700,
        fontSize: 10,
        letterSpacing: 1.6,
      ),
    );
  }
}

class _OverallScore extends StatelessWidget {
  final SessionAssessment assessment;

  const _OverallScore({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(assessment.status);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          if (assessment.score != null) ...[
            Text(
              assessment.score.toString(),
              style: AppTypography.headingLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 48,
                height: 1,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '/10',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textTertiary),
              ),
            ),
            const Spacer(),
          ] else
            const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _statusLabel(assessment.status),
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoAssessmentNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 16, color: AppColors.textTertiary),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              'Penilaian untuk sesi ini belum tersedia.',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment row inside the result sheet. Shows status pill + amount + proof
/// thumbnail (tap to zoom). Hidden entirely upstream when no payment info.
class _PaymentSection extends StatelessWidget {
  final SessionPayment payment;
  final String sessionId;

  const _PaymentSection({required this.payment, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.neutral200),
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
                      payment.amountPaid > 0
                          ? Formatters.formatCurrency(payment.amountPaid, payment.currency)
                          : 'Dibayar dengan kredit',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (payment.paidAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Dibayar ${Formatters.formatDate(payment.paidAt!)}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              if (payment.status != null)
                _PaymentStatusPill(status: payment.status!),
            ],
          ),
          if (payment.paymentProofUrl != null) ...[
            const SizedBox(height: AppDimensions.md),
            Text(
              'Bukti Transfer',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            ZoomableImage(
              heroTag: 'payment-proof-$sessionId',
              imageUrl: payment.paymentProofUrl!,
              caption: payment.amountPaid > 0
                  ? Formatters.formatCurrency(payment.amountPaid, payment.currency)
                  : null,
              thumbnailHeight: 140,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentStatusPill extends StatelessWidget {
  final String status;

  const _PaymentStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _paymentColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        _paymentLabel(status),
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final SessionSkillResult skill;

  const _SkillRow(this.skill);

  @override
  Widget build(BuildContext context) {
    final color = _skillStatusColor(skill.status);
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (skill.category != null && skill.category!.isNotEmpty)
                  Text(
                    skill.category!.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: color.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                Text(
                  skill.skillName,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (skill.score != null)
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.sm),
              child: Text(
                '${skill.score}',
                style: AppTypography.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _skillStatusLabel(skill.status),
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Color + label helpers ──────────────────────────────────────────

Color _statusColor(String? status) {
  return switch (status) {
    'needs_work' => AppColors.error,
    'progressing' => AppColors.warning,
    'good' => AppColors.success,
    'excellent' => AppColors.primary,
    _ => AppColors.neutral500,
  };
}

String _statusLabel(String? status) {
  return switch (status) {
    'needs_work' => 'Perlu Latihan',
    'progressing' => 'Berkembang',
    'good' => 'Baik',
    'excellent' => 'Sangat Baik',
    _ => 'Belum Dinilai',
  };
}

Color _skillStatusColor(String? s) {
  return switch (s) {
    'achieved' => AppColors.success,
    'in_progress' => AppColors.warning,
    'not_started' => AppColors.neutral500,
    _ => AppColors.neutral500,
  };
}

String _skillStatusLabel(String? s) {
  return switch (s) {
    'achieved' => 'Mahir',
    'in_progress' => 'Berkembang',
    'not_started' => 'Belum',
    _ => '—',
  };
}

Color _paymentColor(String status) {
  return switch (status) {
    'pending_payment' || 'pending_confirmation' => AppColors.warning,
    'confirmed_transfer' || 'confirmed_credit' => AppColors.success,
    'rejected' => AppColors.error,
    _ => AppColors.textSecondary,
  };
}

String _paymentLabel(String status) {
  return switch (status) {
    'pending_payment' => 'Menunggu Bayar',
    'pending_confirmation' => 'Cek Bukti',
    'confirmed_transfer' => 'Lunas',
    'confirmed_credit' => 'Kredit',
    'rejected' => 'Ditolak',
    _ => status,
  };
}
