import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/club/data/models/admin_student_roster_item.dart';
import 'package:hyperarena/features/club/data/models/club_summary.dart';
import 'package:hyperarena/features/club/providers/club_providers.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/club_hero.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/utils/debouncer.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Anggota Klub — tenant-wide roster for the organizer. 3-layer dashboard:
/// club identity hero (19.4) → vital stats ticker (19.4) → member roster
/// (19.5). The roster card shows the organizer's lens: who's progressing,
/// who's behind on payments, and which coach is grading them.
class OrganizerMembersScreen extends ConsumerStatefulWidget {
  const OrganizerMembersScreen({super.key});

  @override
  ConsumerState<OrganizerMembersScreen> createState() =>
      _OrganizerMembersScreenState();
}

class _OrganizerMembersScreenState
    extends ConsumerState<OrganizerMembersScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminRosterListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      ref
          .read(adminRosterListProvider.notifier)
          .loadInitial(search: value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(clubSummaryProvider);
    final listState = ref.watch(adminRosterListProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(clubSummaryProvider);
          await ref.read(adminRosterListProvider.notifier).loadInitial();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: summaryAsync.when(
                loading: _buildHeroLoading,
                error: (e, _) => _buildHeroError(context, ref, e),
                data: (s) => ClubHero(
                  name: s.tenant.name,
                  logoUrls: s.tenant.logoUrls,
                  sport: s.tenant.sportName,
                  subtitle: s.tenant.city,
                ),
              ),
            ),
            // Stats ticker — sits below the hero with explicit breathing
            // room above (no overlap; the prior Transform.translate-based
            // overlap merged the card visually with the hero).
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimensions.lg),
                child: summaryAsync.when(
                  loading: _buildStatsLoading,
                  error: (_, _) => const SizedBox.shrink(),
                  data: (s) =>
                      _ClubStatsCard(stats: s.stats, currency: currency),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildSectionLabel(listState)),
            SliverToBoxAdapter(child: _buildSearch()),
            ..._buildList(listState, currency),
            const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.lg)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLoading() {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ),
    );
  }

  Widget _buildHeroError(BuildContext context, WidgetRef ref, Object e) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Gagal memuat data klub',
            style: AppTypography.bodySmall.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.xs),
          TextButton(
            onPressed: () => ref.invalidate(clubSummaryProvider),
            child: const Text('Coba lagi',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsLoading() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral100, width: 1),
      ),
      child: ShimmerLoading.card(height: 60),
    );
  }

  Widget _buildSectionLabel(AdminRosterListState state) {
    return Padding(
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
          if (state.items.isNotEmpty) ...[
            const SizedBox(width: AppDimensions.xs),
            Text(
              '· ${state.items.length}${state.hasMore ? '+' : ''}',
              style: AppTypography.caption
                  .copyWith(color: AppColors.textTertiary, fontSize: 10),
            ),
          ],
          const SizedBox(width: AppDimensions.sm),
          const Expanded(
            child: ColoredBox(
              color: AppColors.neutral200,
              child: SizedBox(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.md,
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (_, value, _) {
          return TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari anggota…',
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.textTertiary, size: 18),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close,
                          size: 16, color: AppColors.textTertiary),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      tooltip: 'Hapus pencarian',
                      visualDensity: VisualDensity.compact,
                    ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md),
              filled: true,
              fillColor: AppSurfaces.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                borderSide: const BorderSide(color: AppColors.neutral200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                borderSide: const BorderSide(color: AppColors.neutral200),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildList(AdminRosterListState state, String currency) {
    if (state.isLoading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal),
          sliver: SliverList.builder(
            itemCount: 4,
            itemBuilder: (_, _) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: ShimmerLoading.card(height: 110),
            ),
          ),
        ),
      ];
    }
    if (state.error != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: ErrorView(
              error: state.error!,
              onRetry: () =>
                  ref.read(adminRosterListProvider.notifier).loadInitial(),
            ),
          ),
        ),
      ];
    }
    if (state.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.groups_outlined,
            message: state.search.isEmpty
                ? 'Belum ada anggota terdaftar.'
                : 'Tidak ada anggota yang cocok dengan "${state.search}".',
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontal),
        sliver: SliverList.builder(
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i >= state.items.length) {
              return const ListLoadingIndicator();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: _MemberRosterCard(
                member: state.items[i],
                currency: currency,
              ),
            );
          },
        ),
      ),
    ];
  }
}

class _ClubStatsCard extends StatelessWidget {
  final ClubStats stats;
  final String currency;

  const _ClubStatsCard({required this.stats, required this.currency});

  @override
  Widget build(BuildContext context) {
    final hasOutstanding = stats.outstandingTotal > 0;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'ANGGOTA',
                value: stats.activeMembersCount.toString(),
                hint: 'aktif 30 hari',
                color: AppColors.primary900,
              ),
            ),
            _Divider(),
            Expanded(
              child: _StatTile(
                label: 'COACH',
                value: stats.activeCoachesCount.toString(),
                hint: 'mengasuh sesi',
                color: AppColors.primary900,
              ),
            ),
            _Divider(),
            Expanded(
              child: _StatTile(
                label: 'SESI / BULAN',
                value: stats.sessionsThisMonth.toString(),
                hint: 'bulan berjalan',
                color: AppColors.primary900,
              ),
            ),
            _Divider(),
            Expanded(
              child: _StatTile(
                label: 'TAGIHAN',
                value: hasOutstanding
                    ? Formatters.formatCurrencyCompact(
                        stats.outstandingTotal, currency)
                    : '—',
                hint: hasOutstanding
                    ? '${stats.outstandingCount} anggota'
                    : 'semua lunas',
                color: hasOutstanding
                    ? AppColors.error
                    : AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.hint,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (_, t, _) {
        return Opacity(
          opacity: t,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTypography.headingMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppColors.neutral100,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

/// Organizer-side member card. Carries the same Athletic Field Notebook
/// language as `_StudentRosterCard` (coach side) but with two financial-
/// stewardship signals layered in: a red dot on the avatar when there's
/// outstanding balance, and a footer banner with the amount + count when
/// the row owes money. Coach assignment chip sits on the enrollment line
/// so the organizer can see *who* is grading at a glance.
class _MemberRosterCard extends StatelessWidget {
  final AdminStudentRosterItem member;
  final String currency;

  const _MemberRosterCard({required this.member, required this.currency});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(member.latestProgress?.status);
    final hasOutstanding = member.outstandingCount > 0;
    final accentBar = hasOutstanding ? AppColors.error : accent;
    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () =>
            context.push(AppRoutes.organizerMember(member.studentProfileId)),
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
                    color: accentBar,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusLg),
                      bottomLeft: Radius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.md,
                          AppDimensions.md,
                          AppDimensions.md,
                          AppDimensions.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeaderRow(hasOutstanding),
                            const SizedBox(height: AppDimensions.xs),
                            _buildEnrollmentLine(),
                            const SizedBox(height: AppDimensions.sm),
                            _buildMetaRow(accent),
                          ],
                        ),
                      ),
                      if (hasOutstanding) _OutstandingBanner(
                        amount: member.outstandingAmount,
                        count: member.outstandingCount,
                        oldestAt: member.oldestOutstandingAt,
                        currency: currency,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(bool hasOutstanding) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ZoomableAvatar(
              heroTag: 'member-${member.studentProfileId}',
              imageUrl: member.photoUrls?['md'] ?? member.photoUrls?['sm'],
              fallbackInitials: Formatters.initials(member.fullName),
              radius: 22,
              caption: member.fullName,
            ),
            if (hasOutstanding)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppSurfaces.surface, width: 2),
                  ),
                ),
              ),
          ],
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
        Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
      ],
    );
  }

  Widget _buildEnrollmentLine() {
    final program = member.enrollment?.programName;
    final coach = member.assignedCoach?.name;
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            program == null ? Icons.info_outline : Icons.book_outlined,
            size: 12,
            color: program == null ? AppColors.warning : AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              program == null
                  ? 'Belum terdaftar di program'
                  : (member.enrollment?.levelName == null
                      ? program
                      : '$program · ${member.enrollment!.levelName}'),
              style: AppTypography.caption.copyWith(
                color: program == null
                    ? AppColors.warning
                    : AppColors.textSecondary,
                fontStyle: program == null ? FontStyle.italic : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (coach != null) ...[
            const SizedBox(width: AppDimensions.xs),
            _CoachChip(name: coach),
          ],
        ],
      ),
    );
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
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _statusLabel(member.latestProgress?.status),
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
          if (member.totalSessions > 0) ...[
            _MetaDot(),
            Text(
              'Hadir ${(member.attendanceRate * 100).round()}%',
              style: AppTypography.caption.copyWith(
                color: member.attendanceRate >= 0.85
                    ? AppColors.success
                    : member.attendanceRate >= 0.7
                        ? AppColors.warning
                        : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoachChip extends StatelessWidget {
  final String name;
  const _CoachChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports, size: 10, color: AppColors.primary700),
          const SizedBox(width: 3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90),
            child: Text(
              _shortCoachName(name),
              style: AppTypography.caption.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// "Haris Mustamsikin" → "Coach Haris". Strips honorific prefixes that
  /// would otherwise compete for chip width.
  String _shortCoachName(String full) {
    final cleaned = full
        .replaceFirst(RegExp(r'^(Coach|Pelatih|Pak|Bu)\s+', caseSensitive: false), '')
        .trim();
    final firstName = cleaned.split(RegExp(r'\s+')).first;
    return 'Coach $firstName';
  }
}

class _OutstandingBanner extends StatelessWidget {
  final int amount;
  final int count;
  final DateTime? oldestAt;
  final String currency;

  const _OutstandingBanner({
    required this.amount,
    required this.count,
    required this.oldestAt,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md, vertical: AppDimensions.xs),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        border: Border(
          top: BorderSide(color: AppColors.error.withValues(alpha: 0.18)),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusLg - 1),
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 12, color: AppColors.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppTypography.caption.copyWith(
                  color: AppColors.error,
                  fontSize: 11,
                ),
                children: [
                  TextSpan(
                    text: Formatters.formatCurrencyCompact(amount, currency),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' · $count tagihan menunggak'),
                  if (oldestAt != null)
                    TextSpan(
                      text: ' sejak ${Formatters.formatDateShort(oldestAt!)}',
                      style: TextStyle(
                        color: AppColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

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
