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
import 'package:hyperarena/shared/providers/money_visibility_provider.dart';
import 'package:hyperarena/shared/utils/debouncer.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';
import 'package:hyperarena/shared/widgets/pinned_list_header.dart';
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

/// Quick-filter chip for the roster. `outstanding` is the financial-collection
/// shortcut every organizer reaches for first; `noCoach` and `unrated` surface
/// roster gaps the organizer is responsible for closing.
enum _RosterFilter { all, outstanding, noCoach, unrated }

/// Sort key for the roster. Default is `activity` (most recently seen first),
/// but switching the filter to `outstanding` auto-flips this to `debt` so the
/// organizer lands on the biggest debt without an extra tap.
enum _RosterSort { activity, debt, name }

/// Pinned header height — section label + search + filter row + sort row at
/// default text scale. Bump this if any of the four rows grows.
const double _kPinnedHeaderHeight = 184;

class _OrganizerMembersScreenState
    extends ConsumerState<OrganizerMembersScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer();
  _RosterFilter _filter = _RosterFilter.all;
  _RosterSort _sort = _RosterSort.activity;

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
            // Section label + search + filter chips pin to the top once
            // scrolled past, so the count + search + filter stay reachable
            // while the user browses deep into the roster. Height fits
            // worst case (filter row visible).
            PinnedListHeader(
              height: _kPinnedHeaderHeight,
              background: AppColors.neutral50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionLabel(listState),
                  _buildSearch(),
                  _buildFilterRow(listState),
                  _buildSortRow(listState),
                ],
              ),
            ),
            ..._buildList(listState, currency),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.lg)),
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
            child: const Text(
              'Coba lagi',
              style: TextStyle(color: Colors.white),
            ),
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
              '· ${state.total ?? state.items.length}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
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
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textTertiary,
                size: 18,
              ),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      tooltip: 'Hapus pencarian',
                      visualDensity: VisualDensity.compact,
                    ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
              ),
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

  /// Client-side filter + sort atop the paginated `state.items`. Counts are
  /// only over the currently-loaded page — fine for a v1, but the next
  /// iteration should push these as query params to
  /// `GET /v1/admin/students/roster` so counts and ordering reflect the
  /// whole tenant, not just what's been scrolled.
  List<AdminStudentRosterItem> _applyFilterAndSort(
    List<AdminStudentRosterItem> src,
  ) {
    final filtered = switch (_filter) {
      _RosterFilter.all => src,
      _RosterFilter.outstanding =>
        src.where((m) => m.outstandingCount > 0).toList(growable: false),
      _RosterFilter.noCoach =>
        src.where((m) => m.assignedCoach?.name == null).toList(growable: false),
      _RosterFilter.unrated =>
        src
            .where((m) => m.latestProgress?.status == null)
            .toList(growable: false),
    };
    final sorted = [...filtered];
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    sorted.sort(
      (a, b) => switch (_sort) {
        _RosterSort.activity => (b.lastSessionAt ?? epoch).compareTo(
          a.lastSessionAt ?? epoch,
        ),
        _RosterSort.debt => b.outstandingAmount.compareTo(a.outstandingAmount),
        _RosterSort.name => a.fullName.toLowerCase().compareTo(
          b.fullName.toLowerCase(),
        ),
      },
    );
    return sorted;
  }

  Widget _buildFilterRow(AdminRosterListState state) {
    if (state.isLoading || state.error != null || state.items.isEmpty) {
      return const SizedBox.shrink();
    }
    final outstanding = state.items.where((m) => m.outstandingCount > 0).length;
    final noCoach = state.items
        .where((m) => m.assignedCoach?.name == null)
        .length;
    final unrated = state.items
        .where((m) => m.latestProgress?.status == null)
        .length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _RosterFilterChip(
              label: 'Semua',
              isSelected: _filter == _RosterFilter.all,
              onTap: () => setState(() => _filter = _RosterFilter.all),
            ),
            const SizedBox(width: AppDimensions.xs),
            _RosterFilterChip(
              label: 'Menunggak',
              count: outstanding,
              tone: _RosterFilterTone.error,
              isSelected: _filter == _RosterFilter.outstanding,
              onTap: () => setState(() {
                _filter = _RosterFilter.outstanding;
                // Auto-flip sort: when the organizer pivots to collection
                // mode, biggest debt is what they want first.
                if (_sort == _RosterSort.activity) _sort = _RosterSort.debt;
              }),
            ),
            const SizedBox(width: AppDimensions.xs),
            _RosterFilterChip(
              label: 'Tanpa coach',
              count: noCoach,
              tone: _RosterFilterTone.warning,
              isSelected: _filter == _RosterFilter.noCoach,
              onTap: () => setState(() => _filter = _RosterFilter.noCoach),
            ),
            const SizedBox(width: AppDimensions.xs),
            _RosterFilterChip(
              label: 'Belum dinilai',
              count: unrated,
              tone: _RosterFilterTone.neutral,
              isSelected: _filter == _RosterFilter.unrated,
              onTap: () => setState(() => _filter = _RosterFilter.unrated),
            ),
          ],
        ),
      ),
    );
  }

  /// Editorial small-caps sort selector. Renders as a single text row
  /// ("URUTKAN: Aktivitas · Tagihan · Nama") where the active key is
  /// underlined with a 1.5px primary-toned bar — matches the Athletic
  /// Field Notebook language without introducing a dropdown chrome.
  Widget _buildSortRow(AdminRosterListState state) {
    if (state.isLoading || state.error != null || state.items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        0,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      child: Row(
        children: [
          Text(
            'URUTKAN',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          _SortKey(
            label: 'Aktivitas',
            isActive: _sort == _RosterSort.activity,
            onTap: () => setState(() => _sort = _RosterSort.activity),
          ),
          const _SortDivider(),
          _SortKey(
            label: 'Tagihan',
            isActive: _sort == _RosterSort.debt,
            onTap: () => setState(() => _sort = _RosterSort.debt),
          ),
          const _SortDivider(),
          _SortKey(
            label: 'Nama',
            isActive: _sort == _RosterSort.name,
            onTap: () => setState(() => _sort = _RosterSort.name),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList(AdminRosterListState state, String currency) {
    if (state.isLoading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontal,
          ),
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
    final filtered = _applyFilterAndSort(state.items);
    if (filtered.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.filter_alt_off_outlined,
            message: switch (_filter) {
              _RosterFilter.outstanding =>
                'Tidak ada anggota yang menunggak. Semua lunas pada halaman ini.',
              _RosterFilter.noCoach =>
                'Semua anggota di halaman ini sudah punya coach.',
              _RosterFilter.unrated =>
                'Semua anggota di halaman ini sudah dinilai.',
              _RosterFilter.all => 'Tidak ada anggota.',
            },
            actionLabel: 'Tampilkan semua',
            onAction: () => setState(() => _filter = _RosterFilter.all),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal,
        ),
        sliver: SliverList.builder(
          itemCount: filtered.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i >= filtered.length) {
              return const ListLoadingIndicator();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: _MemberRosterCard(member: filtered[i], currency: currency),
            );
          },
        ),
      ),
    ];
  }
}

enum _RosterFilterTone { neutral, error, warning }

class _SortKey extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SortKey({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary900 : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary900 : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _SortDivider extends StatelessWidget {
  const _SortDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      child: Text(
        '·',
        style: AppTypography.caption.copyWith(
          color: AppColors.neutral300,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _RosterFilterChip extends StatelessWidget {
  final String label;
  final int? count;
  final _RosterFilterTone tone;
  final bool isSelected;
  final VoidCallback onTap;

  const _RosterFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.tone = _RosterFilterTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final accent = switch (tone) {
      _RosterFilterTone.error => AppColors.error,
      _RosterFilterTone.warning => AppColors.warning,
      _RosterFilterTone.neutral => AppColors.primary700,
    };
    final fg = isSelected ? Colors.white : accent;
    final bg = isSelected ? accent : AppSurfaces.surface;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: isSelected ? accent : AppColors.neutral200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(width: 6),
                Text(
                  count.toString(),
                  style: AppTypography.caption.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ClubStatsCard extends ConsumerWidget {
  final ClubStats stats;
  final String currency;

  const _ClubStatsCard({required this.stats, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasOutstanding = stats.outstandingTotal > 0;
    final moneyVisible = ref.watch(moneyVisibilityProvider);
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
                value: stats.totalMembersCount.toString(),
                hint: 'total terdaftar',
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
                    ? (moneyVisible
                          ? Formatters.formatCurrencyCompact(
                              stats.outstandingTotal,
                              currency,
                            )
                          : MoneyText.maskFormatted(
                              Formatters.formatCurrencyCompact(
                                stats.outstandingTotal,
                                currency,
                              ),
                              4,
                            ))
                    : '—',
                hint: hasOutstanding
                    ? '${stats.outstandingCount} anggota'
                    : 'semua lunas',
                color: hasOutstanding ? AppColors.error : AppColors.success,
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
                    color: accent,
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
                      if (hasOutstanding)
                        _OutstandingBanner(
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
    final unenrolled = member.enrollment == null;
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
              Row(
                children: [
                  Flexible(
                    child: Text(
                      member.fullName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (unenrolled) ...[
                    const SizedBox(width: AppDimensions.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.warning, width: 1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm,
                        ),
                      ),
                      child: Text(
                        'TANPA PROGRAM',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
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
    final program = member.enrollment?.programName;
    // Unenrolled state is signalled by the TANPA PROGRAM chip on the header
    // row — this row collapses to avoid double-flagging the same fact.
    if (program == null) return const SizedBox.shrink();
    final level = member.enrollment?.levelName;
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Text(
        level == null ? program : '$program · $level',
        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMetaRow(Color accent) {
    final lastSession = member.lastSessionAt == null
        ? 'Belum ada sesi'
        : Formatters.relativeDate(member.lastSessionAt!);
    final coach = member.assignedCoach?.name;
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Wrap(
        spacing: AppDimensions.xs,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.xs,
              vertical: 2,
            ),
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
          if (coach != null) _CoachChip(name: coach),
          Text(
            '· $lastSession · ${member.totalSessions} sesi',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
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
    final shortName = _shortCoachName(name);
    final initial = Formatters.initials(name).characters.firstOrNull ?? 'C';
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary700,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial.toUpperCase(),
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 9,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90),
            child: Text(
              shortName,
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

  /// "Haris Mustamsikin" → "Coach Haris". Strips repeated honorific
  /// prefixes ("Pak Coach Haris" → "Coach Haris") so we never render
  /// "Coach Coach …".
  String _shortCoachName(String full) {
    final cleaned = full
        .replaceFirst(
          RegExp(r'^(?:(?:Coach|Pelatih|Pak|Bu)\s+)+', caseSensitive: false),
          '',
        )
        .trim();
    if (cleaned.isEmpty) return 'Coach';
    final firstName = cleaned.split(RegExp(r'\s+')).first;
    return 'Coach $firstName';
  }
}

class _OutstandingBanner extends ConsumerWidget {
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

  // Aging ramp — fresh debt reads muted, stale debt reads bold-and-loud so
  // the eye finds the worst row first when the list is long.
  int? get _ageDays =>
      oldestAt == null ? null : DateTime.now().difference(oldestAt!).inDays;

  Color get _ageColor {
    final d = _ageDays;
    if (d == null) return AppColors.error.withValues(alpha: 0.7);
    if (d < 7) return AppColors.error.withValues(alpha: 0.55);
    return AppColors.error;
  }

  FontWeight get _ageWeight =>
      (_ageDays ?? 0) >= 30 ? FontWeight.w700 : FontWeight.w400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyVisible = ref.watch(moneyVisibilityProvider);
    // The leading currency prefix is rendered separately as an editorial
    // "Rp" stamp, so we feed the body cell only the digit portion.
    final parts = Formatters.splitCurrency(amount, currency);
    final amountText = moneyVisible ? parts.number : '••••';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        border: Border(
          top: BorderSide(color: AppColors.error.withValues(alpha: 0.18)),
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Text.rich(
        TextSpan(
          style: AppTypography.caption.copyWith(
            color: AppColors.error,
            fontSize: 11,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          children: [
            TextSpan(
              text: '${parts.prefix} ',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            TextSpan(
              text: amountText,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '  ·  $count tagihan'),
            if (oldestAt != null)
              TextSpan(
                text: '  ·  sejak ${Formatters.formatDateShort(oldestAt!)}',
                style: TextStyle(color: _ageColor, fontWeight: _ageWeight),
              ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
