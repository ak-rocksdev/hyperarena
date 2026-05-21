import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/features/club/providers/club_providers.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/member_financial_kpi_strip.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/member_hero_with_outstanding.dart';
import 'package:hyperarena/shared/widgets/session_result_sheet.dart';
import 'package:hyperarena/shared/widgets/zoomable_image.dart';

/// Organizer-side member profile. Wired to `GET /v1/admin/students/{id}/detail`
/// (Issue 19.3). Same hero/KPIs/enrollment/performance/skills as coach
/// detail (19.2) plus two financial sections only the organizer sees.
class OrganizerMemberDetailScreen extends ConsumerWidget {
  final String memberId;

  const OrganizerMemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(memberId);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.lg),
            child: Text('ID anggota tidak valid.'),
          ),
        ),
      );
    }
    final async = ref.watch(adminStudentDetailProvider(id));
    final tenantCurrency = ref.watch(tenantCurrencyProvider);
    return async.when(
      loading: () => const _LoadingScaffold(),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(adminStudentDetailProvider(id)),
        ),
      ),
      data: (detail) =>
          _Body(detail: detail, tenantCurrency: tenantCurrency),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: AppColors.primary900),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        children: [
          ShimmerLoading.card(height: 240),
          const SizedBox(height: AppDimensions.lg),
          ShimmerLoading.card(height: 90),
          const SizedBox(height: AppDimensions.lg),
          ShimmerLoading.card(height: 90),
          const SizedBox(height: AppDimensions.lg),
          ShimmerLoading.card(height: 240),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AdminStudentDetail detail;
  final String tenantCurrency;

  const _Body({required this.detail, required this.tenantCurrency});

  @override
  Widget build(BuildContext context) {
    final hasOutstanding = detail.financialStats.outstandingAmount > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Teal hero — keep system status bar icons light/white.
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.neutral50,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            MemberHeroWithOutstanding(
              student: detail.student,
              financial: detail.financialStats,
            ),
            // When the outstanding banner overlaps (negative bottom margin
            // of -28 in the hero), reserve extra space here so the banner
            // doesn't overlap the next section.
            SizedBox(height: hasOutstanding ? 48 : AppDimensions.lg),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontal,
                0,
                AppDimensions.screenHorizontal,
                AppDimensions.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionLabel('RINGKASAN KEUANGAN'),
                  const SizedBox(height: AppDimensions.sm),
                  MemberFinancialKpiStrip(financial: detail.financialStats),
                  if (detail.paymentHistory.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.xl),
                    _SectionLabel('RIWAYAT PEMBAYARAN'),
                    const SizedBox(height: AppDimensions.sm),
                    _PaymentHistoryList(payments: detail.paymentHistory),
                  ],
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('ENROLLMENT'),
                  const SizedBox(height: AppDimensions.sm),
                  _EnrollmentCard(enrollment: detail.student.enrollment),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('AKTIVITAS'),
                  const SizedBox(height: AppDimensions.sm),
                  _EngagementKpiStrip(stats: detail.student.stats),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('PERFORMA TERKINI'),
                  const SizedBox(height: AppDimensions.sm),
                  _TrendStrip(trend: detail.recentTrend),
                  if (detail.skillBreakdown.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.xl),
                    _SectionLabel('PROGRES KEAHLIAN'),
                    const SizedBox(height: AppDimensions.sm),
                    _SkillBreakdown(breakdown: detail.skillBreakdown),
                  ],
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('RIWAYAT SESI'),
                  const SizedBox(height: AppDimensions.sm),
                  _SessionHistoryList(history: detail.sessionHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppTypography.caption.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        const Expanded(
          child: ColoredBox(
            color: AppColors.neutral200,
            child: SizedBox(height: 1),
          ),
        ),
      ],
    );
  }
}

// ── Engagement KPI strip ───────────────────────────────────────────

class _EngagementKpiStrip extends StatelessWidget {
  final StudentEngagementStats stats;

  const _EngagementKpiStrip({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.lg,
        horizontal: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _KpiTile(
                value: stats.totalSessions.toString(),
                label: 'Sesi diikuti',
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value: '${(stats.attendanceRate * 100).round()}%',
                label: 'Tingkat hadir',
                color: stats.attendanceRate >= 0.85
                    ? AppColors.success
                    : stats.attendanceRate >= 0.7
                        ? AppColors.warning
                        : AppColors.error,
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value:
                    '${stats.skillsMasteredCount}/${stats.skillsTotalCount}',
                label: 'Skill dikuasai',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _KpiTile({
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color ?? AppColors.primary900,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _KpiDivider extends StatelessWidget {
  const _KpiDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      color: AppColors.neutral100,
      thickness: 1,
      width: 1,
      indent: 4,
      endIndent: 4,
    );
  }
}

// ── Enrollment ─────────────────────────────────────────────────────

class _EnrollmentCard extends StatelessWidget {
  final StudentDetailEnrollment? enrollment;

  const _EnrollmentCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    if (enrollment == null) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border:
              Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: AppColors.warningDark),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(
                'Belum terdaftar di program coaching.',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.warningDark),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(Icons.school_outlined,
                size: 18, color: AppColors.primary700),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  enrollment!.programName ?? '—',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enrollment!.levelName ?? 'Tanpa level',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (enrollment!.enrolledAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Bergabung ${Formatters.formatDate(enrollment!.enrolledAt!)}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trend ──────────────────────────────────────────────────────────

class _TrendStrip extends StatelessWidget {
  final List<AssessmentTrendPoint> trend;

  const _TrendStrip({required this.trend});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return _EmptyCard(text: 'Belum ada penilaian tersimpan.');
    }
    final pointsWithDelta = <(AssessmentTrendPoint, int?)>[];
    int? prev;
    for (final p in trend) {
      pointsWithDelta.add((p, prev == null ? null : (p.score ?? 0) - prev));
      prev = p.score;
    }
    return Row(
      children: [
        for (var i = 0; i < pointsWithDelta.length; i++) ...[
          Expanded(
            child: _TrendCard(
              point: pointsWithDelta[i].$1,
              delta: pointsWithDelta[i].$2,
            ),
          ),
          if (i < pointsWithDelta.length - 1)
            const SizedBox(width: AppDimensions.sm),
        ],
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final AssessmentTrendPoint point;
  final int? delta;

  const _TrendCard({required this.point, required this.delta});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(point.status);
    final arrow = delta == null
        ? null
        : delta! > 0
            ? Icons.arrow_upward
            : delta! < 0
                ? Icons.arrow_downward
                : Icons.remove;
    final arrowColor = delta == null
        ? AppColors.textTertiary
        : delta! > 0
            ? AppColors.success
            : delta! < 0
                ? AppColors.error
                : AppColors.textTertiary;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            point.date != null
                ? Formatters.formatDateShort(point.date!)
                : '—',
            style: AppTypography.caption
                .copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppDimensions.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                point.score?.toString() ?? '—',
                style: AppTypography.headingMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              if (point.score != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 2),
                  child: Text(
                    '/10',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ),
              const Spacer(),
              if (arrow != null) Icon(arrow, size: 16, color: arrowColor),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Skill breakdown ────────────────────────────────────────────────

class _SkillBreakdown extends StatelessWidget {
  final List<SkillCategoryProgress> breakdown;

  const _SkillBreakdown({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < breakdown.length; i++) ...[
            _SkillCategoryRow(item: breakdown[i]),
            if (i < breakdown.length - 1)
              const SizedBox(height: AppDimensions.md),
          ],
        ],
      ),
    );
  }
}

class _SkillCategoryRow extends StatelessWidget {
  final SkillCategoryProgress item;

  const _SkillCategoryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final ratio =
        item.totalCount == 0 ? 0.0 : item.achievedCount / item.totalCount;
    final color = ratio >= 0.7
        ? AppColors.success
        : ratio >= 0.4
            ? AppColors.warning
            : AppColors.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.category,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${item.achievedCount} / ${item.totalCount}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: AppColors.neutral100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ── Payment history ────────────────────────────────────────────────

class _PaymentHistoryList extends StatelessWidget {
  final List<PaymentHistoryItem> payments;

  const _PaymentHistoryList({required this.payments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < payments.length; i++) ...[
            _PaymentRow(payment: payments[i]),
            if (i < payments.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.neutral100,
                indent: AppDimensions.md,
                endIndent: AppDimensions.md,
              ),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final PaymentHistoryItem payment;

  const _PaymentRow({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _paymentColor(payment.status)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  Icons.receipt_long,
                  size: 18,
                  color: _paymentColor(payment.status),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      payment.description ?? 'Pembayaran',
                      style: AppTypography.bodySmall
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (payment.date != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatDate(payment.date!),
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Formatters.formatCurrency(
                        payment.amount, payment.currency),
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  if (payment.status != null)
                    _PaymentStatusPill(status: payment.status!),
                ],
              ),
            ],
          ),
          if (payment.paymentProofUrl != null) ...[
            const SizedBox(height: AppDimensions.sm),
            ZoomableImage(
              heroTag: 'proof-${payment.purchaseId}',
              imageUrl: payment.paymentProofUrl!,
              caption: payment.description,
              thumbnailHeight: 100,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        _paymentLabel(status),
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Session history ────────────────────────────────────────────────

class _SessionHistoryList extends StatelessWidget {
  final List<SessionHistoryItem> history;

  const _SessionHistoryList({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return _EmptyCard(text: 'Belum ada sesi yang tercatat.');
    }
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < history.length; i++) ...[
            _SessionRow(session: history[i]),
            if (i < history.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.neutral100,
                indent: AppDimensions.md,
                endIndent: AppDimensions.md,
              ),
          ],
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final SessionHistoryItem session;

  const _SessionRow({required this.session});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => SessionResultSheet.show(context, session),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.startAt?.day.toString() ?? '—',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    Text(
                      session.startAt != null
                          ? _shortMonth(session.startAt!.month)
                          : '',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.venueName ?? 'Sesi',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        _AttendancePill(status: session.attendanceStatus),
                        if (session.payment?.status != null)
                          _PaymentStatusPill(status: session.payment!.status!),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  static String _shortMonth(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return names[(m - 1).clamp(0, 11)].toUpperCase();
  }
}

class _AttendancePill extends StatelessWidget {
  final String? status;

  const _AttendancePill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'present' => (AppColors.success, 'Hadir'),
      'late' => (AppColors.warning, 'Telat'),
      'absent' => (AppColors.error, 'Absen'),
      _ => (AppColors.neutral300, 'Belum dicatat'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Empty card helper ──────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  final String text;

  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Text(
        text,
        style: AppTypography.bodySmall
            .copyWith(color: AppColors.textTertiary),
      ),
    );
  }
}

// ── Color helpers ──────────────────────────────────────────────────

Color _statusColor(String? status) {
  return switch (status) {
    'needs_work' => AppColors.error,
    'progressing' => AppColors.warning,
    'good' => AppColors.success,
    'excellent' => AppColors.primary,
    _ => AppColors.neutral500,
  };
}

Color _paymentColor(String? status) {
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
    'confirmed_credit' => 'Lunas (Kredit)',
    'rejected' => 'Ditolak',
    _ => status,
  };
}
