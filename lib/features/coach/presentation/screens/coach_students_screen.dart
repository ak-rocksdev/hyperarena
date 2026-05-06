import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Coach's roster — distinct students across all sessions where the
/// authenticated coach was assigned. List uses status-coded left-edge accents
/// for at-a-glance recency + performance scanning. Stub data for the
/// scaffolding pass; will be wired to `GET /v1/coach/students` (BE Issue 19)
/// once that endpoint ships.
class CoachStudentsScreen extends ConsumerStatefulWidget {
  const CoachStudentsScreen({super.key});

  @override
  ConsumerState<CoachStudentsScreen> createState() =>
      _CoachStudentsScreenState();
}

class _CoachStudentsScreenState
    extends ConsumerState<CoachStudentsScreen> {
  String _query = '';
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

  @override
  Widget build(BuildContext context) {
    final all = _stubStudents;
    final filtered = _query.isEmpty
        ? all
        : all
            .where((s) =>
                s.fullName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: const Text('Murid Saya'),
        elevation: 0,
        backgroundColor: AppSurfaces.surface,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderStrip(all.length)),
          SliverToBoxAdapter(child: _buildSearch()),
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.people_outline,
                message: _query.isEmpty
                    ? 'Belum ada murid yang sudah ikut sesi.'
                    : 'Tidak ada murid yang cocok dengan "$_query".',
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
                  child: _StudentRosterCard(student: filtered[i]),
                ),
              ),
            ),
          const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.lg)),
        ],
      ),
    );
  }

  Widget _buildHeaderStrip(int count) {
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
          // Big count, tabular feel.
          Text(
            count.toString(),
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
                  '8 minggu terakhir',
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
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v.trim()),
        decoration: InputDecoration(
          hintText: 'Cari murid…',
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

class _StudentRosterCard extends StatelessWidget {
  final _StubStudent student;

  const _StudentRosterCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(student.latestStatus);
    return Material(
      color: AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(
          AppRoutes.coachStudent(student.studentProfileId.toString()),
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
                // Status-colored accent bar — pre-attentive scanning.
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
          imageUrl: student.photoUrl,
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
        Icon(Icons.chevron_right,
            size: 18, color: AppColors.textTertiary),
      ],
    );
  }

  Widget _buildEnrollmentLine() {
    if (student.programName == null) {
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
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Row(
        children: [
          Icon(Icons.book_outlined,
              size: 12, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              student.levelName == null
                  ? student.programName!
                  : '${student.programName!} · ${student.levelName!}',
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
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Wrap(
        spacing: AppDimensions.xs,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Status pill — semantic, color-coded.
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xs, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              _statusLabel(student.latestStatus),
              style: AppTypography.caption.copyWith(
                color: accent,
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
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary),
          ),
          _MetaDot(),
          Text(
            '${student.totalSessions} sesi',
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary),
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

// ── Stub data ───────────────────────────────────────────────────────
//
// Replace with `GET /v1/coach/students` once BE Issue 19 ships.

class _StubStudent {
  final int studentProfileId;
  final String fullName;
  final int? age;
  final String? photoUrl;
  final String? programName;
  final String? levelName;
  final DateTime? lastSessionAt;
  final String? latestStatus;
  final int totalSessions;
  final double attendanceRate;

  const _StubStudent({
    required this.studentProfileId,
    required this.fullName,
    required this.age,
    required this.photoUrl,
    required this.programName,
    required this.levelName,
    required this.lastSessionAt,
    required this.latestStatus,
    required this.totalSessions,
    required this.attendanceRate,
  });
}

final List<_StubStudent> _stubStudents = [
  _StubStudent(
    studentProfileId: 71,
    fullName: 'Fauziah Putri',
    age: 14,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Newbie to Lower Beginner',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 3)),
    latestStatus: 'good',
    totalSessions: 12,
    attendanceRate: 0.92,
  ),
  _StubStudent(
    studentProfileId: 72,
    fullName: 'Alsac Wijaya',
    age: 11,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Newbie to Lower Beginner',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 1)),
    latestStatus: 'progressing',
    totalSessions: 8,
    attendanceRate: 0.75,
  ),
  _StubStudent(
    studentProfileId: 73,
    fullName: 'Nabilla Hasanah',
    age: null,
    photoUrl: null,
    programName: 'Class Intermediate',
    levelName: 'Mid-Beginner to Intermediate',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 14)),
    latestStatus: 'needs_work',
    totalSessions: 5,
    attendanceRate: 0.6,
  ),
  _StubStudent(
    studentProfileId: 74,
    fullName: 'Okta Pratama',
    age: 16,
    photoUrl: null,
    programName: 'Class Newbie to Beginner',
    levelName: 'Lower to Mid-Beginner',
    lastSessionAt: DateTime.now().subtract(const Duration(days: 7)),
    latestStatus: 'excellent',
    totalSessions: 18,
    attendanceRate: 0.96,
  ),
  _StubStudent(
    studentProfileId: 75,
    fullName: 'Bintang Maulana',
    age: 9,
    photoUrl: null,
    programName: null,
    levelName: null,
    lastSessionAt: DateTime.now().subtract(const Duration(days: 30)),
    latestStatus: null,
    totalSessions: 2,
    attendanceRate: 1.0,
  ),
];
