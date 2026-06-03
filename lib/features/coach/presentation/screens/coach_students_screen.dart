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
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/club/providers/club_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/utils/debouncer.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Coach roster — distinct students across all sessions where the auth
/// coach was assigned. Wired to `GET /v1/coach/students` (BE Issue 19.1).
class CoachStudentsScreen extends ConsumerStatefulWidget {
  const CoachStudentsScreen({super.key});

  @override
  ConsumerState<CoachStudentsScreen> createState() =>
      _CoachStudentsScreenState();
}

class _CoachStudentsScreenState extends ConsumerState<CoachStudentsScreen> {
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
      ref.read(coachStudentsListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      ref
          .read(coachStudentsListProvider.notifier)
          .loadInitial(search: value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coachStudentsListProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: const Text('Murid Saya'),
        elevation: 0,
        backgroundColor: AppSurfaces.surface,
      ),
      // Header strip + search sit OUTSIDE the scrollable area so they
      // pin while the roster scrolls. Pull-to-refresh lives on the list.
      body: Column(
        children: [
          _buildHeaderStrip(state),
          _buildSearch(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(coachStudentsListProvider.notifier)
                  .loadInitial(search: _searchController.text.trim()),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  ..._buildBody(state),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.lg),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBody(CoachStudentsListState state) {
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
              onRetry: () => ref
                  .read(coachStudentsListProvider.notifier)
                  .loadInitial(search: _searchController.text.trim()),
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
            icon: Icons.people_outline,
            message: _searchController.text.isEmpty
                ? 'Belum ada murid yang sudah ikut sesi.'
                : 'Tidak ada murid yang cocok dengan "${_searchController.text}".',
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
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i >= state.items.length) {
              return const ListLoadingIndicator();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: _StudentRosterCard(student: state.items[i]),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildHeaderStrip(CoachStudentsListState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
        AppDimensions.screenHorizontal,
        AppDimensions.md,
      ),
      decoration: const BoxDecoration(
        color: AppSurfaces.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.neutral100, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            // Prefer BE-supplied total; fallback to loaded length while
            // older BE responses propagate.
            (state.total ?? state.items.length).toString(),
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MURID AKTIF',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
                Text(
                  'Berdasarkan sesi yang Anda asuh',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (_, value, _) {
          return TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari murid…',
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
          );
        },
      ),
    );
  }
}

class _StudentRosterCard extends StatelessWidget {
  final CoachStudentRosterItem student;

  const _StudentRosterCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(student.latestProgress?.status);
    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () =>
            context.push(AppRoutes.coachStudent(student.studentProfileId)),
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
                    padding: const EdgeInsets.all(AppDimensions.md),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ZoomableAvatar(
          heroTag: 'student-${student.studentProfileId}',
          imageUrl: student.photoUrls?['md'] ?? student.photoUrls?['sm'],
          fallbackInitials: Formatters.initials(student.fullName),
          radius: 22,
          caption: student.fullName,
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student.fullName,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                student.age != null ? '${student.age} tahun' : 'Umur Not Set',
                style: AppTypography.caption.copyWith(
                  color: student.age != null
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                  fontStyle: student.age == null ? FontStyle.italic : null,
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
    final program = student.enrollment?.programName;
    if (program == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 56),
        child: Text(
          'Belum terdaftar di program',
          style: AppTypography.caption.copyWith(
            color: AppColors.warning,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    final level = student.enrollment?.levelName;
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Row(
        children: [
          Icon(Icons.book_outlined, size: 12, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              level == null ? program : '$program · $level',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(Color accent) {
    final isUngraded = student.latestProgress == null;
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
              color: isUngraded
                  ? AppColors.warningLight
                  : accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _statusLabel(student.latestProgress?.status),
              style: AppTypography.caption.copyWith(
                color: isUngraded ? AppColors.warningDark : accent,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
          _MetaDot(),
          Text(
            student.lastSessionAt == null
                ? 'Belum ada sesi'
                : Formatters.relativeDate(student.lastSessionAt!),
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          _MetaDot(),
          Text(
            '${student.totalSessionsWithCoach} sesi',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          _MetaDot(),
          Text(
            'Hadir ${(student.attendanceRate * 100).round()}%',
            style: AppTypography.caption.copyWith(
              color: student.attendanceRate >= 0.85
                  ? AppColors.success
                  : student.attendanceRate >= 0.7
                  ? AppColors.warning
                  : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
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
