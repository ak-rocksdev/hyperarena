import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/club_hero.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Anggota Klub — tenant-wide member roster for the organizer. Shares the
/// "Athletic Field Notebook" visual language with the coach side, but the
/// information hierarchy is reordered for the organizer's financial-steward
/// lens: a triage filter row, a financial-ticker header, and a single
/// canonical payment signal per card (right-side ribbon when there's an
/// outstanding tagihan — no avatar dot, no bottom banner).
///
/// Stub data; will be wired to `GET /v1/admin/students` (existing list) +
/// `GET /v1/admin/students/{id}/detail` (BE Issue 19.3) once that ships.
class OrganizerMembersScreen extends ConsumerStatefulWidget {
  const OrganizerMembersScreen({super.key});

  @override
  ConsumerState<OrganizerMembersScreen> createState() =>
      _OrganizerMembersScreenState();
}

enum _MemberFilter { all, owing, active, inactive }

class _OrganizerMembersScreenState
    extends ConsumerState<OrganizerMembersScreen> {
  String _query = '';
  _MemberFilter _filter = _MemberFilter.all;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_StubMember> _applyFilter(List<_StubMember> all) {
    final searchMatched = _query.isEmpty
        ? all
        : all
            .where((m) =>
                m.fullName.toLowerCase().contains(_query.toLowerCase()))
            .toList();
    final filtered = switch (_filter) {
      _MemberFilter.all => searchMatched,
      _MemberFilter.owing =>
        searchMatched.where((m) => m.outstandingCount > 0).toList(),
      _MemberFilter.active => searchMatched
          .where((m) =>
              m.lastSessionAt != null &&
              DateTime.now().difference(m.lastSessionAt!).inDays <= 30)
          .toList(),
      _MemberFilter.inactive => searchMatched
          .where((m) =>
              m.lastSessionAt == null ||
              DateTime.now().difference(m.lastSessionAt!).inDays > 30)
          .toList(),
    };
    // Filter-aware implicit sort.
    final sorted = [...filtered];
    switch (_filter) {
      case _MemberFilter.owing:
        sorted.sort(
            (a, b) => b.outstandingAmount.compareTo(a.outstandingAmount));
      case _MemberFilter.inactive:
        sorted.sort((a, b) {
          final aDate = a.lastSessionAt ?? DateTime(1970);
          final bDate = b.lastSessionAt ?? DateTime(1970);
          return aDate.compareTo(bDate);
        });
      case _MemberFilter.all || _MemberFilter.active:
        // Newest engagement first for daily scan.
        sorted.sort((a, b) {
          final aDate = a.lastSessionAt ?? DateTime(1970);
          final bDate = b.lastSessionAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final all = _stubMembers;
    final filtered = _applyFilter(all);

    final activeCount = all
        .where((m) =>
            m.lastSessionAt != null &&
            DateTime.now().difference(m.lastSessionAt!).inDays <= 30)
        .length;
    final outstandingTotal =
        all.fold<int>(0, (sum, m) => sum + m.outstandingAmount);
    final outstandingCount =
        all.where((m) => m.outstandingCount > 0).length;

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      // Hero handles its own dark background; no AppBar so the gradient
      // bleeds to the status bar for a more dashboard-y feel.
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // Layer 1 — club identity
          const SliverToBoxAdapter(
            child: ClubHero(
              name: 'Petenis Kelana',
              sport: 'Tenis',
              subtitle: 'Jakarta',
            ),
          ),
          // Layer 2 — vital stats ticker (overlaps the hero by 24px so the
          // card "lifts out" of the dark band — gives the screen depth).
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -AppDimensions.lg),
              child: ClubStatsStrip(
                activeMembers: activeCount,
                activeCoaches: 4,
                sessionsThisMonth: 18,
                outstandingTotal: outstandingTotal,
                outstandingCount: outstandingCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontal,
                AppDimensions.lg,
                AppDimensions.screenHorizontal,
                AppDimensions.sm,
              ),
              child: Row(
                children: [
                  Text(
                    'ANGGOTA',
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
              ),
            ),
          ),
          // Layer 3 — roster (filter + search + cards)
          SliverToBoxAdapter(
            child: _FilterRow(
              filter: _filter,
              counts: {
                _MemberFilter.all: all.length,
                _MemberFilter.owing: outstandingCount,
                _MemberFilter.active: activeCount,
                _MemberFilter.inactive: all.length - activeCount,
              },
              onChanged: (f) => setState(() => _filter = f),
            ),
          ),
          SliverToBoxAdapter(child: _buildSearch()),
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.groups_outlined,
                message: _query.isNotEmpty
                    ? 'Tidak ada anggota yang cocok dengan "$_query".'
                    : switch (_filter) {
                        _MemberFilter.owing =>
                          'Tidak ada anggota dengan tagihan tertunggak. 🎉',
                        _MemberFilter.active =>
                          'Belum ada anggota yang aktif 30 hari terakhir.',
                        _MemberFilter.inactive =>
                          'Semua anggota aktif. Bagus!',
                        _MemberFilter.all =>
                          'Belum ada anggota terdaftar.',
                      },
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontal,
              ),
              sliver: SliverList.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: _MemberCard(member: filtered[i]),
                ),
              ),
            ),
          const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.lg)),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      color: AppSurfaces.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.md,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v.trim()),
        decoration: InputDecoration(
          hintText: 'Cari anggota…',
          prefixIcon: const Icon(Icons.search,
              color: AppColors.textTertiary, size: 18),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          filled: true,
          fillColor: AppColors.neutral50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.neutral200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.neutral200),
          ),
        ),
      ),
    );
  }
}

/// Triage filter strip. Each chip shows a count so the organizer can
/// scan-and-decide before tapping. The "Menunggak" chip pulls the eye via
/// the error tint when count > 0 — fades to neutral when zero.
class _FilterRow extends StatelessWidget {
  final _MemberFilter filter;
  final Map<_MemberFilter, int> counts;
  final ValueChanged<_MemberFilter> onChanged;

  const _FilterRow({
    required this.filter,
    required this.counts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppSurfaces.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in _MemberFilter.values) ...[
              _FilterChip(
                label: _filterLabel(f),
                count: counts[f] ?? 0,
                selected: filter == f,
                emphasis: f == _MemberFilter.owing && (counts[f] ?? 0) > 0,
                onTap: () => onChanged(f),
              ),
              if (f != _MemberFilter.values.last)
                const SizedBox(width: AppDimensions.xs),
            ],
          ],
        ),
      ),
    );
  }

  String _filterLabel(_MemberFilter f) => switch (f) {
        _MemberFilter.all => 'Semua',
        _MemberFilter.owing => 'Menunggak',
        _MemberFilter.active => 'Aktif',
        _MemberFilter.inactive => 'Tidak Aktif',
      };
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final bool emphasis;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.emphasis,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = emphasis ? AppColors.error : AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: selected
                ? activeColor
                : (emphasis
                    ? AppColors.error.withValues(alpha: 0.06)
                    : AppColors.neutral50),
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: selected
                  ? activeColor
                  : (emphasis
                      ? AppColors.error.withValues(alpha: 0.3)
                      : AppColors.neutral200),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: selected
                      ? Colors.white
                      : (emphasis ? AppColors.error : AppColors.textPrimary),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (emphasis
                          ? AppColors.error.withValues(alpha: 0.15)
                          : AppColors.neutral200),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  count.toString(),
                  style: AppTypography.caption.copyWith(
                    color: selected
                        ? Colors.white
                        : (emphasis
                            ? AppColors.error
                            : AppColors.textSecondary),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final _StubMember member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(member.latestStatus);
    final hasOutstanding = member.outstandingCount > 0;

    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(
          AppRoutes.organizerMember(member.studentProfileId.toString()),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.neutral200, width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusLg),
                      bottomLeft: Radius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.sm,
                      AppDimensions.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeaderRow(),
                              const SizedBox(height: AppDimensions.xs),
                              _buildEnrollmentLine(),
                              const SizedBox(height: AppDimensions.sm),
                              _buildMetaRow(accent),
                            ],
                          ),
                        ),
                        if (hasOutstanding) ...[
                          const SizedBox(width: AppDimensions.sm),
                          _OutstandingRibbon(
                            amount: member.outstandingAmount,
                            since: member.oldestOutstandingAt,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        ZoomableAvatar(
          heroTag: 'member-${member.studentProfileId}',
          imageUrl: member.photoUrl,
          fallbackInitials: Formatters.initials(member.fullName),
          radius: 22,
          caption: member.fullName,
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                member.fullName,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                member.age != null ? '${member.age} tahun' : 'Umur Not Set',
                style: AppTypography.caption.copyWith(
                  color: member.age != null
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                  fontStyle: member.age == null ? FontStyle.italic : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnrollmentLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Row(
        children: [
          Icon(Icons.book_outlined,
              size: 12, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _enrollmentSubtitle(),
              style: AppTypography.caption.copyWith(
                color: member.programName == null
                    ? AppColors.warning
                    : AppColors.textSecondary,
                fontStyle: member.programName == null
                    ? FontStyle.italic
                    : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _enrollmentSubtitle() {
    if (member.programName == null) return 'Belum terdaftar di program';
    final parts = <String>[
      if (member.levelName != null)
        '${member.programName!} · ${member.levelName!}'
      else
        member.programName!,
      if (member.assignedCoachName != null)
        'Coach ${member.assignedCoachName!}',
    ];
    return parts.join(' · ');
  }

  Widget _buildMetaRow(Color accent) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Wrap(
        spacing: AppDimensions.xs,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xs, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _statusLabel(member.latestStatus),
              style: AppTypography.caption.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
          _MetaDot(),
          Text(
            member.lastSessionAt == null
                ? 'Belum ada sesi'
                : Formatters.relativeDate(member.lastSessionAt!),
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary),
          ),
          _MetaDot(),
          Text(
            '${member.totalSessions} sesi',
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    return switch (status) {
      'needs_work' => AppColors.error,
      'progressing' => AppColors.warning,
      'good' => AppColors.success,
      'excellent' => AppColors.primary,
      _ => AppColors.neutral300,
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
}

/// Right-side ribbon shown only when there's an outstanding tagihan.
/// Single canonical signal for payment health (replaces avatar-dot + bottom
/// banner pair). The status-accent left bar already provides the urgency
/// color cue, so this ribbon stays tonal — filled error for the amount,
/// muted age line below.
class _OutstandingRibbon extends StatelessWidget {
  final int amount;
  final DateTime? since;

  const _OutstandingRibbon({required this.amount, required this.since});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long,
                  size: 12, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                Formatters.formatRupiahCompact(amount),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.errorDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (since != null) ...[
            const SizedBox(height: 2),
            Text(
              Formatters.relativeDate(since!),
              style: AppTypography.caption.copyWith(
                color: AppColors.error.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Stub data ───────────────────────────────────────────────────────
//
// Replace with `GET /v1/admin/students` (existing list) + per-row
// payment summary from `GET /v1/admin/students/{id}/detail` (BE Issue 19.3).

class _StubMember {
  final int studentProfileId;
  final String fullName;
  final int? age;
  final String? photoUrl;
  final String? programName;
  final String? levelName;
  final String? assignedCoachName;
  final DateTime? lastSessionAt;
  final String? latestStatus;
  final int totalSessions;
  final int outstandingCount;
  final int outstandingAmount;
  final DateTime? oldestOutstandingAt;

  const _StubMember({
    required this.studentProfileId,
    required this.fullName,
    required this.age,
    required this.photoUrl,
    required this.programName,
    required this.levelName,
    required this.assignedCoachName,
    required this.lastSessionAt,
    required this.latestStatus,
    required this.totalSessions,
    required this.outstandingCount,
    required this.outstandingAmount,
    required this.oldestOutstandingAt,
  });
}

final List<_StubMember> _stubMembers = [
  _StubMember(
    studentProfileId: 71,
    fullName: 'Fauziah Putri',
    age: 14,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Newbie to Lower Beginner',
    assignedCoachName: 'Haris',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 3)),
    latestStatus: 'good',
    totalSessions: 12,
    outstandingCount: 0,
    outstandingAmount: 0,
    oldestOutstandingAt: null,
  ),
  _StubMember(
    studentProfileId: 72,
    fullName: 'Alsac Wijaya',
    age: 11,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Newbie to Lower Beginner',
    assignedCoachName: 'Haris',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 1)),
    latestStatus: 'progressing',
    totalSessions: 8,
    outstandingCount: 1,
    outstandingAmount: 150000,
    oldestOutstandingAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
  _StubMember(
    studentProfileId: 73,
    fullName: 'Nabilla Hasanah',
    age: null,
    photoUrl: null,
    programName: 'Class Intermediate',
    levelName: 'Mid-Beginner to Intermediate',
    assignedCoachName: 'Sari',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 14)),
    latestStatus: 'needs_work',
    totalSessions: 5,
    outstandingCount: 2,
    outstandingAmount: 300000,
    oldestOutstandingAt: DateTime.now().subtract(const Duration(days: 35)),
  ),
  _StubMember(
    studentProfileId: 74,
    fullName: 'Okta Pratama',
    age: 16,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Lower to Mid-Beginner',
    assignedCoachName: 'Haris',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 7)),
    latestStatus: 'excellent',
    totalSessions: 18,
    outstandingCount: 0,
    outstandingAmount: 0,
    oldestOutstandingAt: null,
  ),
  _StubMember(
    studentProfileId: 75,
    fullName: 'Bintang Maulana',
    age: 9,
    photoUrl: null,
    programName: null,
    levelName: null,
    assignedCoachName: null,
    lastSessionAt: DateTime.now().subtract(const Duration(days: 45)),
    latestStatus: null,
    totalSessions: 2,
    outstandingCount: 0,
    outstandingAmount: 0,
    oldestOutstandingAt: null,
  ),
];
