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
import 'package:hyperarena/features/club/data/models/admin_student_summary.dart';
import 'package:hyperarena/features/club/data/models/club_summary.dart';
import 'package:hyperarena/features/club/providers/club_providers.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/club_hero.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/utils/debouncer.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Anggota Klub — tenant-wide roster for the organizer. 3-layer dashboard:
/// club identity hero → vital stats ticker → member roster.
///
/// Hero + stats consume `GET /v1/admin/club/summary` (Issue 19.4). The
/// roster falls back to existing `GET /v1/admin/students` (thin shape)
/// until BE Issue 19.5 ships the per-row aggregates — at that point this
/// screen swaps to the richer card design without other code changes.
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
      ref.read(adminStudentsListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      ref
          .read(adminStudentsListProvider.notifier)
          .loadInitial(search: value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(clubSummaryProvider);
    final listState = ref.watch(adminStudentsListProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(clubSummaryProvider);
          await ref.read(adminStudentsListProvider.notifier).loadInitial();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Hero
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
            // Stats ticker (overlaps hero by 24px for depth)
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -AppDimensions.lg),
                child: summaryAsync.when(
                  loading: _buildStatsLoading,
                  error: (_, _) => const SizedBox.shrink(),
                  data: (s) => _ClubStatsCard(stats: s.stats),
                ),
              ),
            ),
            // Editorial section break
            SliverToBoxAdapter(child: _buildSectionLabel(listState)),
            SliverToBoxAdapter(child: _buildSearch()),
            // Member list
            ..._buildList(listState),
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
      margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: ShimmerLoading.card(height: 60),
    );
  }

  Widget _buildSectionLabel(AdminStudentsListState state) {
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
          if (state.total > 0) ...[
            const SizedBox(width: AppDimensions.xs),
            Text(
              '· ${state.total} total',
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

  List<Widget> _buildList(AdminStudentsListState state) {
    if (state.isLoading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal),
          sliver: SliverList.builder(
            itemCount: 4,
            itemBuilder: (_, _) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: ShimmerLoading.card(height: 90),
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
                  ref.read(adminStudentsListProvider.notifier).loadInitial(),
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
              child: _MemberCard(member: state.items[i]),
            );
          },
        ),
      ),
    ];
  }
}

class _ClubStatsCard extends StatelessWidget {
  final ClubStats stats;

  const _ClubStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final hasOutstanding = stats.outstandingTotal > 0;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                    ? Formatters.formatRupiahCompact(stats.outstandingTotal)
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
        // Subtle scale-in cue on first paint.
        final opacity = t;
        return Opacity(
          opacity: opacity,
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

/// Compact card for the organizer roster while 19.5 is pending. Displays
/// the data `/admin/students` actually returns (identity + gender + joined
/// date). Once 19.5 ships, this will swap to a richer card with status
/// pill, attendance %, and outstanding ribbon — see `coach_students_screen`
/// for the full pattern.
class _MemberCard extends StatelessWidget {
  final AdminStudentSummary member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final fullName = Formatters.fullName(member.firstName, member.lastName);
    final age = Formatters.ageInYears(member.dateOfBirth);
    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(AppRoutes.organizerMember(member.id)),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.neutral200, width: 1),
          ),
          child: Row(
            children: [
              ZoomableAvatar(
                heroTag: 'member-${member.id}',
                imageUrl:
                    member.photoUrls?['md'] ?? member.photoUrls?['sm'],
                fallbackInitials: Formatters.initials(fullName),
                radius: 22,
                caption: fullName,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fullName,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (member.gender != null) ...[
                          const SizedBox(width: AppDimensions.xs),
                          _GenderChip(gender: member.gender!),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          age != null ? '$age tahun' : 'Umur Not Set',
                          style: AppTypography.caption.copyWith(
                            color: age != null
                                ? AppColors.textSecondary
                                : AppColors.textTertiary,
                            fontStyle:
                                age == null ? FontStyle.italic : null,
                          ),
                        ),
                        if (member.createdAt != null) ...[
                          const _MetaDot(),
                          Text(
                            'Anggota sejak ${Formatters.formatDateShort(member.createdAt!)}',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textTertiary),
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
}

class _GenderChip extends StatelessWidget {
  final String gender;
  const _GenderChip({required this.gender});

  @override
  Widget build(BuildContext context) {
    final isFemale = gender == 'female';
    final color = isFemale ? const Color(0xFFEC4899) : AppColors.primary700;
    final label = isFemale ? 'Wanita' : (gender == 'male' ? 'Pria' : gender);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
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
