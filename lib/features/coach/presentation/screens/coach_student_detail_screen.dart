import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';

/// Read-only student profile for the coach. Mirrors the visual language of
/// the session detail screen (editorial small-caps section labels,
/// status-coded color treatments). Stub data for the scaffolding pass — wires
/// to `GET /v1/coach/students/{id}` (BE Issue 19) once that endpoint ships.
class CoachStudentDetailScreen extends ConsumerWidget {
  final String studentId;

  const CoachStudentDetailScreen({super.key, required this.studentId});

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
                  _KpiStrip(detail: detail),
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
  final _StubDetail detail;

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
            // Photo or coloured fallback.
            if (detail.photoUrl != null)
              Image.network(detail.photoUrl!, fit: BoxFit.cover)
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: AppSurfaces.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    Formatters.initials(detail.fullName),
                    style: AppTypography.headingLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 96,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                    ),
                  ),
                ),
              ),
            // Bottom gradient for text legibility.
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
            // Name overlay — bottom-left aligned, player-card feel.
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
                      _HeroChip(label: ageText, icon: Icons.cake_outlined),
                      if (detail.gender != null)
                        _HeroChip(
                          label: _genderLabel(detail.gender!),
                          icon: detail.gender == 'female'
                              ? Icons.female
                              : Icons.male,
                        ),
                      if (detail.sport != null)
                        _HeroChip(
                          label: detail.sport!,
                          icon: Icons.sports_tennis,
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
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

// ── KPI strip ───────────────────────────────────────────────────────

class _KpiStrip extends StatelessWidget {
  final _StubDetail detail;

  const _KpiStrip({required this.detail});

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
          style: AppTypography.headingMedium.copyWith(
            color: color ?? AppColors.primary900,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
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

// ── Enrollment card ─────────────────────────────────────────────────

class _EnrollmentCard extends StatelessWidget {
  final _StubDetail detail;

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
                  detail.levelName == null
                      ? 'Tanpa level'
                      : detail.levelName!,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
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

// ── Trend strip ─────────────────────────────────────────────────────

class _TrendStrip extends StatelessWidget {
  final List<_StubTrend> trend;

  const _TrendStrip({required this.trend});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Text(
          'Belum ada penilaian tersimpan.',
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textTertiary),
        ),
      );
    }
    return Row(
      children: [
        for (var i = 0; i < trend.length; i++) ...[
          Expanded(child: _TrendCard(item: trend[i])),
          if (i < trend.length - 1) const SizedBox(width: AppDimensions.sm),
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
                item.score?.toString() ?? _statusShort(item.status),
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
              if (arrow != null)
                Icon(arrow, size: 16, color: arrowColor),
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
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Text(
          'Belum ada data progres skill.',
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textTertiary),
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
    final ratio = item.totalCount == 0 ? 0.0 : item.achievedCount / item.totalCount;
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

// ── Session history ────────────────────────────────────────────────

class _SessionHistoryList extends StatelessWidget {
  final List<_StubSession> history;

  const _SessionHistoryList({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Text(
          'Belum ada sesi yang tercatat.',
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textTertiary),
        ),
      );
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
        onTap: () => _SessionResultSheet.show(context, session),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              // Date column — emphasis on day number, tabular feel.
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
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _AttendancePill(status: session.attendanceStatus),
                        if (session.assessmentStatus != null) ...[
                          const SizedBox(width: 4),
                          _AssessmentPill(
                            status: session.assessmentStatus,
                            score: session.assessmentScore,
                          ),
                        ],
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
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
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
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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

class _AssessmentPill extends StatelessWidget {
  final String? status;
  final int? score;

  const _AssessmentPill({required this.status, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final text = score != null
        ? '$score/10'
        : _statusShort(status);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Read-only assessment modal ─────────────────────────────────────

class _SessionResultSheet extends StatelessWidget {
  final _StubSession session;

  const _SessionResultSheet({required this.session});

  static void show(BuildContext context, _StubSession session) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => _SessionResultSheet(session: session),
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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                Formatters.formatDateLong(session.startAt),
                style: AppTypography.caption
                    .copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 2),
              Text(
                session.venueName,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              _OverallScore(session: session),
              if (session.assessmentNotes != null &&
                  session.assessmentNotes!.isNotEmpty) ...[
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
                    session.assessmentNotes!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              if (session.skillResults.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.lg),
                _SectionLabel('PROGRES PER-SKILL'),
                const SizedBox(height: AppDimensions.sm),
                ...session.skillResults.map(_buildSkillRow),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillRow(_StubSkillResult skill) {
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
                if (skill.category != null)
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

class _OverallScore extends StatelessWidget {
  final _StubSession session;

  const _OverallScore({required this.session});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(session.assessmentStatus);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          if (session.assessmentScore != null) ...[
            Text(
              session.assessmentScore.toString(),
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
              _statusLabel(session.assessmentStatus),
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

// ── Color helpers ───────────────────────────────────────────────────

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

String _statusShort(String? status) {
  return switch (status) {
    'needs_work' => 'Latihan',
    'progressing' => 'Tumbuh',
    'good' => 'Baik',
    'excellent' => 'Top',
    _ => '—',
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

// ── Stub data ───────────────────────────────────────────────────────

class _StubDetail {
  final int studentProfileId;
  final String fullName;
  final int? age;
  final String? gender;
  final String? sport;
  final String? photoUrl;
  final String? programName;
  final String? levelName;
  final DateTime? enrolledAt;
  final int totalSessions;
  final double attendanceRate;
  final int skillsMasteredCount;
  final int skillsTotalCount;
  final List<_StubTrend> recentTrend;
  final List<_StubSkillCategory> skillBreakdown;
  final List<_StubSession> sessionHistory;

  const _StubDetail({
    required this.studentProfileId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.sport,
    required this.photoUrl,
    required this.programName,
    required this.levelName,
    required this.enrolledAt,
    required this.totalSessions,
    required this.attendanceRate,
    required this.skillsMasteredCount,
    required this.skillsTotalCount,
    required this.recentTrend,
    required this.skillBreakdown,
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

class _StubSession {
  final int sessionId;
  final DateTime startAt;
  final String venueName;
  final String? attendanceStatus;
  final String? assessmentStatus;
  final int? assessmentScore;
  final String? assessmentNotes;
  final List<_StubSkillResult> skillResults;

  const _StubSession({
    required this.sessionId,
    required this.startAt,
    required this.venueName,
    required this.attendanceStatus,
    required this.assessmentStatus,
    required this.assessmentScore,
    required this.assessmentNotes,
    required this.skillResults,
  });
}

class _StubSkillResult {
  final String skillName;
  final String? category;
  final String? status;
  final int? score;

  const _StubSkillResult({
    required this.skillName,
    required this.category,
    required this.status,
    required this.score,
  });
}

final _StubDetail _stubDetail = _StubDetail(
  studentProfileId: 71,
  fullName: 'Fauziah Putri',
  age: 14,
  gender: 'female',
  sport: 'Tenis',
  photoUrl: null,
  programName: 'Class Newbie to Beginner',
  levelName: 'Newbie to Lower Beginner',
  enrolledAt: DateTime(2025, 8, 15),
  totalSessions: 12,
  attendanceRate: 0.92,
  skillsMasteredCount: 5,
  skillsTotalCount: 12,
  recentTrend: [
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: 'progressing',
      score: 6,
      deltaFromPrev: null,
    ),
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: 'good',
      score: 7,
      deltaFromPrev: 1,
    ),
    _StubTrend(
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'good',
      score: 8,
      deltaFromPrev: 1,
    ),
  ],
  skillBreakdown: const [
    _StubSkillCategory(
      category: 'Forehand',
      achievedCount: 3,
      totalCount: 4,
    ),
    _StubSkillCategory(
      category: 'Backhand',
      achievedCount: 1,
      totalCount: 4,
    ),
    _StubSkillCategory(
      category: 'Serve',
      achievedCount: 1,
      totalCount: 2,
    ),
    _StubSkillCategory(
      category: 'Footwork',
      achievedCount: 0,
      totalCount: 2,
    ),
  ],
  sessionHistory: [
    _StubSession(
      sessionId: 88,
      startAt: DateTime.now().subtract(const Duration(days: 3)),
      venueName: 'Lapangan Petenis Kelana — Court 2',
      attendanceStatus: 'present',
      assessmentStatus: 'good',
      assessmentScore: 8,
      assessmentNotes:
          'Forehand semakin konsisten. Footwork perlu lebih cepat saat retreat.',
      skillResults: const [
        _StubSkillResult(
          skillName: 'Forehand Consistency',
          category: 'Forehand',
          status: 'achieved',
          score: 8,
        ),
        _StubSkillResult(
          skillName: 'Forehand Volley',
          category: 'Forehand',
          status: 'in_progress',
          score: 6,
        ),
        _StubSkillResult(
          skillName: 'Ready Position & Footwork',
          category: 'Footwork',
          status: 'in_progress',
          score: 5,
        ),
      ],
    ),
    _StubSession(
      sessionId: 87,
      startAt: DateTime.now().subtract(const Duration(days: 7)),
      venueName: 'Lapangan Petenis Kelana — Court 1',
      attendanceStatus: 'present',
      assessmentStatus: 'good',
      assessmentScore: 7,
      assessmentNotes: 'Good progress on serve.',
      skillResults: const [
        _StubSkillResult(
          skillName: 'Continental Serve Grip',
          category: 'Serve',
          status: 'achieved',
          score: 7,
        ),
      ],
    ),
    _StubSession(
      sessionId: 86,
      startAt: DateTime.now().subtract(const Duration(days: 14)),
      venueName: 'Lapangan Petenis Kelana — Court 1',
      attendanceStatus: 'late',
      assessmentStatus: 'progressing',
      assessmentScore: 6,
      assessmentNotes: null,
      skillResults: const [],
    ),
    _StubSession(
      sessionId: 80,
      startAt: DateTime.now().subtract(const Duration(days: 21)),
      venueName: 'Lapangan Petenis Kelana — Court 2',
      attendanceStatus: 'absent',
      assessmentStatus: null,
      assessmentScore: null,
      assessmentNotes: null,
      skillResults: const [],
    ),
  ],
);
