import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Organizer-side member profile. Same hero/KPI/enrollment/performance/skills
/// layout as the coach's read-only detail, plus two financial sections that
/// only the organizer needs:
///
/// - **RINGKASAN KEUANGAN** — 3 KPIs (bayar bulan ini, tagihan pending,
///   total transaksi) sit between the engagement KPI strip and the
///   enrollment card.
/// - **RIWAYAT PEMBAYARAN** — chronological list of recent purchases with
///   amount, status pill, and tap-to-view-proof.
/// - Session history rows pick up a payment chip alongside the attendance
///   pill.
///
/// Stub data; wires to `GET /v1/admin/students/{id}/detail` (BE Issue 19.3)
/// when that ships.
class OrganizerMemberDetailScreen extends ConsumerWidget {
  final String memberId;

  const OrganizerMemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = _stubDetail;
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: CustomScrollView(
        slivers: [
          _Hero(detail: detail),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontal,
                AppDimensions.lg,
                AppDimensions.screenHorizontal,
                AppDimensions.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _EngagementKpiStrip(detail: detail),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('RINGKASAN KEUANGAN'),
                  const SizedBox(height: AppDimensions.sm),
                  _FinancialKpiStrip(detail: detail),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('ENROLLMENT'),
                  const SizedBox(height: AppDimensions.sm),
                  _EnrollmentCard(detail: detail),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('PERFORMA TERKINI'),
                  const SizedBox(height: AppDimensions.sm),
                  _TrendStrip(trend: detail.recentTrend),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('PROGRES KEAHLIAN'),
                  const SizedBox(height: AppDimensions.sm),
                  _SkillBreakdown(breakdown: detail.skillBreakdown),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('RIWAYAT PEMBAYARAN'),
                  const SizedBox(height: AppDimensions.sm),
                  _PaymentHistoryList(payments: detail.paymentHistory),
                  const SizedBox(height: AppDimensions.xl),
                  _SectionLabel('RIWAYAT SESI'),
                  const SizedBox(height: AppDimensions.sm),
                  _SessionHistoryList(history: detail.sessionHistory),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero ────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final _StubMemberDetail detail;

  const _Hero({required this.detail});

  @override
  Widget build(BuildContext context) {
    final ageText =
        detail.age != null ? '${detail.age} tahun' : 'Umur Not Set';
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary900,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: LayoutBuilder(builder: (_, c) {
          final collapsed = c.biggest.height < 120;
          return AnimatedOpacity(
            opacity: collapsed ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Text(
              detail.fullName,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppSurfaces.primaryGradient,
              ),
            ),
            // Tappable centered avatar — Hero target syncs with the list
            // row so the transition is shared.
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ZoomableAvatar(
                  heroTag: 'member-${detail.studentProfileId}',
                  imageUrl: detail.photoUrl,
                  fallbackInitials: Formatters.initials(detail.fullName),
                  radius: 56,
                  bgColor: Colors.white.withValues(alpha: 0.18),
                  fgColor: Colors.white,
                  caption: detail.fullName,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              left: AppDimensions.screenHorizontal,
              right: AppDimensions.screenHorizontal,
              bottom: AppDimensions.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: AppDimensions.xs,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _HeroChip(
                          label: ageText, icon: Icons.cake_outlined),
                      if (detail.gender != null)
                        _HeroChip(
                          label: _genderLabel(detail.gender!),
                          icon: detail.gender == 'female'
                              ? Icons.female
                              : Icons.male,
                        ),
                      if (detail.assignedCoachName != null)
                        _HeroChip(
                          label: 'Coach ${detail.assignedCoachName!}',
                          icon: Icons.sports,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    detail.fullName,
                    style: AppTypography.headingLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _genderLabel(String g) =>
      switch (g) { 'male' => 'Pria', 'female' => 'Wanita', _ => g };
}

class _HeroChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HeroChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
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
  final _StubMemberDetail detail;

  const _EngagementKpiStrip({required this.detail});

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
                value: detail.totalSessions.toString(),
                label: 'Sesi diikuti',
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value: '${(detail.attendanceRate * 100).round()}%',
                label: 'Tingkat hadir',
                color: detail.attendanceRate >= 0.85
                    ? AppColors.success
                    : detail.attendanceRate >= 0.7
                        ? AppColors.warning
                        : AppColors.error,
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value:
                    '${detail.skillsMasteredCount}/${detail.skillsTotalCount}',
                label: 'Skill dikuasai',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Financial KPI strip (organizer-only) ───────────────────────────

class _FinancialKpiStrip extends StatelessWidget {
  final _StubMemberDetail detail;

  const _FinancialKpiStrip({required this.detail});

  @override
  Widget build(BuildContext context) {
    final outstanding = detail.outstandingAmount;
    final hasOutstanding = outstanding > 0;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.lg,
        horizontal: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: hasOutstanding
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.neutral200,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _KpiTile(
                value: Formatters.formatRupiahCompact(detail.paidThisMonth),
                label: 'Bayar bulan ini',
                color: AppColors.success,
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value: hasOutstanding
                    ? Formatters.formatRupiahCompact(outstanding)
                    : '—',
                label: hasOutstanding
                    ? '${detail.outstandingCount} tagihan'
                    : 'Tidak ada tagihan',
                color: hasOutstanding ? AppColors.error : AppColors.success,
              ),
            ),
            const _KpiDivider(),
            Expanded(
              child: _KpiTile(
                value: detail.paymentHistory.length.toString(),
                label: 'Total transaksi',
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

// ── Enrollment card ────────────────────────────────────────────────

class _EnrollmentCard extends StatelessWidget {
  final _StubMemberDetail detail;

  const _EnrollmentCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    if (detail.programName == null) {
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
            Icon(Icons.info_outline,
                size: 18, color: AppColors.warningDark),
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
                  detail.programName!,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail.levelName ?? 'Tanpa level',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (detail.assignedCoachName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Diasuh oleh Coach ${detail.assignedCoachName!}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
                if (detail.enrolledAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Bergabung ${Formatters.formatDate(detail.enrolledAt!)}',
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

// ── Trend strip ────────────────────────────────────────────────────

class _TrendStrip extends StatelessWidget {
  final List<_StubTrend> trend;

  const _TrendStrip({required this.trend});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return _EmptyCard(text: 'Belum ada penilaian tersimpan.');
    }
    return Row(
      children: [
        for (var i = 0; i < trend.length; i++) ...[
          Expanded(child: _TrendCard(item: trend[i])),
          if (i < trend.length - 1)
            const SizedBox(width: AppDimensions.sm),
        ],
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final _StubTrend item;

  const _TrendCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(item.status);
    final delta = item.deltaFromPrev;
    final arrow = delta == null
        ? null
        : delta > 0
            ? Icons.arrow_upward
            : delta < 0
                ? Icons.arrow_downward
                : Icons.remove;
    final arrowColor = delta == null
        ? AppColors.textTertiary
        : delta > 0
            ? AppColors.success
            : delta < 0
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
            Formatters.formatDateShort(item.date),
            style: AppTypography.caption
                .copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppDimensions.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.score?.toString() ?? '—',
                style: AppTypography.headingMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              if (item.score != null)
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
  final List<_StubSkillCategory> breakdown;

  const _SkillBreakdown({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return _EmptyCard(text: 'Belum ada data progres skill.');
    }
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
  final _StubSkillCategory item;

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
  final List<_StubPayment> payments;

  const _PaymentHistoryList({required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return _EmptyCard(text: 'Belum ada transaksi tercatat.');
    }
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
  final _StubPayment payment;

  const _PaymentRow({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _paymentColor(payment.status).withValues(alpha: 0.1),
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
                  payment.description,
                  style: AppTypography.bodySmall
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatDate(payment.date),
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Formatters.formatRupiah(payment.amount),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              _PaymentStatusPill(status: payment.status),
            ],
          ),
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
    final label = _paymentLabel(status);
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

// ── Session history ────────────────────────────────────────────────

class _SessionHistoryList extends StatelessWidget {
  final List<_StubSession> history;

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
  final _StubSession session;

  const _SessionRow({required this.session});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
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
                      session.startAt.day.toString(),
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    Text(
                      _shortMonth(session.startAt.month),
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
                      session.venueName,
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
                        if (session.paymentStatus != null)
                          _PaymentStatusPill(status: session.paymentStatus!),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
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

Color _paymentColor(String status) {
  return switch (status) {
    'pending_payment' || 'pending_confirmation' => AppColors.warning,
    'confirmed_transfer' || 'confirmed_credit' || 'paid' => AppColors.success,
    'rejected' || 'refunded' => AppColors.error,
    _ => AppColors.textSecondary,
  };
}

String _paymentLabel(String status) {
  return switch (status) {
    'pending_payment' => 'Menunggu Bayar',
    'pending_confirmation' => 'Cek Bukti',
    'confirmed_transfer' => 'Lunas',
    'confirmed_credit' => 'Lunas (Kredit)',
    'paid' => 'Lunas',
    'rejected' => 'Ditolak',
    'refunded' => 'Refund',
    _ => status,
  };
}

// ── Stub data ──────────────────────────────────────────────────────

class _StubMemberDetail {
  final int studentProfileId;
  final String fullName;
  final int? age;
  final String? gender;
  final String? photoUrl;
  final String? programName;
  final String? levelName;
  final String? assignedCoachName;
  final DateTime? enrolledAt;
  final int totalSessions;
  final double attendanceRate;
  final int skillsMasteredCount;
  final int skillsTotalCount;
  final int paidThisMonth;
  final int outstandingAmount;
  final int outstandingCount;
  final List<_StubTrend> recentTrend;
  final List<_StubSkillCategory> skillBreakdown;
  final List<_StubPayment> paymentHistory;
  final List<_StubSession> sessionHistory;

  const _StubMemberDetail({
    required this.studentProfileId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.photoUrl,
    required this.programName,
    required this.levelName,
    required this.assignedCoachName,
    required this.enrolledAt,
    required this.totalSessions,
    required this.attendanceRate,
    required this.skillsMasteredCount,
    required this.skillsTotalCount,
    required this.paidThisMonth,
    required this.outstandingAmount,
    required this.outstandingCount,
    required this.recentTrend,
    required this.skillBreakdown,
    required this.paymentHistory,
    required this.sessionHistory,
  });
}

class _StubTrend {
  final DateTime date;
  final String? status;
  final int? score;
  final int? deltaFromPrev;

  const _StubTrend({
    required this.date,
    required this.status,
    required this.score,
    required this.deltaFromPrev,
  });
}

class _StubSkillCategory {
  final String category;
  final int achievedCount;
  final int totalCount;

  const _StubSkillCategory({
    required this.category,
    required this.achievedCount,
    required this.totalCount,
  });
}

class _StubPayment {
  final int id;
  final DateTime date;
  final int amount;
  final String description;
  final String status;

  const _StubPayment({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
  });
}

class _StubSession {
  final int sessionId;
  final DateTime startAt;
  final String venueName;
  final String? attendanceStatus;
  final String? paymentStatus;

  const _StubSession({
    required this.sessionId,
    required this.startAt,
    required this.venueName,
    required this.attendanceStatus,
    required this.paymentStatus,
  });
}

final _StubMemberDetail _stubDetail = _StubMemberDetail(
  studentProfileId: 72,
  fullName: 'Alsac Wijaya',
  age: 11,
  gender: 'male',
  photoUrl: null,
  programName: 'Class Newbie to Beginner',
  levelName: 'Newbie to Lower Beginner',
  assignedCoachName: 'Haris',
  enrolledAt: DateTime(2025, 11, 3),
  totalSessions: 8,
  attendanceRate: 0.75,
  skillsMasteredCount: 3,
  skillsTotalCount: 12,
  paidThisMonth: 450000,
  outstandingAmount: 150000,
  outstandingCount: 1,
  recentTrend: [
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: 'progressing',
      score: 5,
      deltaFromPrev: null,
    ),
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: 'progressing',
      score: 6,
      deltaFromPrev: 1,
    ),
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'good',
      score: 7,
      deltaFromPrev: 1,
    ),
  ],
  skillBreakdown: const [
    _StubSkillCategory(
        category: 'Forehand', achievedCount: 2, totalCount: 4),
    _StubSkillCategory(
        category: 'Backhand', achievedCount: 1, totalCount: 4),
    _StubSkillCategory(category: 'Serve', achievedCount: 0, totalCount: 2),
    _StubSkillCategory(
        category: 'Footwork', achievedCount: 0, totalCount: 2),
  ],
  paymentHistory: [
    _StubPayment(
      id: 412,
      date: DateTime.now().subtract(const Duration(days: 14)),
      amount: 150000,
      description: 'Sesi Tenis 18 Apr — Court 2',
      status: 'pending_payment',
    ),
    _StubPayment(
      id: 411,
      date: DateTime.now().subtract(const Duration(days: 21)),
      amount: 150000,
      description: 'Sesi Tenis 11 Apr — Court 1',
      status: 'confirmed_transfer',
    ),
    _StubPayment(
      id: 410,
      date: DateTime.now().subtract(const Duration(days: 28)),
      amount: 150000,
      description: 'Sesi Tenis 4 Apr — Court 1',
      status: 'confirmed_transfer',
    ),
    _StubPayment(
      id: 409,
      date: DateTime.now().subtract(const Duration(days: 35)),
      amount: 150000,
      description: 'Sesi Tenis 28 Mar — Court 1',
      status: 'confirmed_credit',
    ),
  ],
  sessionHistory: [
    _StubSession(
      sessionId: 88,
      startAt: DateTime.now().subtract(const Duration(days: 1)),
      venueName: 'Lapangan Petenis Kelana — Court 2',
      attendanceStatus: 'present',
      paymentStatus: 'pending_payment',
    ),
    _StubSession(
      sessionId: 87,
      startAt: DateTime.now().subtract(const Duration(days: 7)),
      venueName: 'Lapangan Petenis Kelana — Court 1',
      attendanceStatus: 'present',
      paymentStatus: 'confirmed_transfer',
    ),
    _StubSession(
      sessionId: 86,
      startAt: DateTime.now().subtract(const Duration(days: 14)),
      venueName: 'Lapangan Petenis Kelana — Court 1',
      attendanceStatus: 'late',
      paymentStatus: 'confirmed_transfer',
    ),
    _StubSession(
      sessionId: 80,
      startAt: DateTime.now().subtract(const Duration(days: 28)),
      venueName: 'Lapangan Petenis Kelana — Court 2',
      attendanceStatus: 'absent',
      paymentStatus: 'confirmed_credit',
    ),
  ],
);
