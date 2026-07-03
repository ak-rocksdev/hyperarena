import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/features/coach/data/models/enrollment.dart';
import 'package:hyperarena/features/coach/data/models/session_progress_detail.dart';
import 'package:hyperarena/features/coach/data/models/session_recommendation.dart';
import 'package:hyperarena/features/coach/presentation/widgets/enrollment_dialog.dart';
import 'package:hyperarena/features/coach/presentation/widgets/student_grading_panel.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/shared/widgets/scrim_icon_button.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';

class CoachSessionDetailScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const CoachSessionDetailScreen({super.key, required this.sessionId});

  @override
  ConsumerState<CoachSessionDetailScreen> createState() =>
      _CoachSessionDetailScreenState();
}

class _CoachSessionDetailScreenState
    extends ConsumerState<CoachSessionDetailScreen> {
  bool _saving = false;
  bool _initialized = false;
  bool _draftsHydrated = false;

  /// Whether attendance is currently in edit mode.
  bool _editMode = false;

  /// Currently expanded student profile id, or null when none. Single-expanded
  /// pattern keeps the screen scannable on mobile.
  int? _expandedStudentId;

  /// Per-student grading drafts. Persists across collapse/expand within the
  /// screen lifecycle so the coach doesn't lose work in progress.
  final Map<int, StudentGradingDraft> _drafts = {};

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(coachSessionDetailProvider(widget.sessionId));

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: detailAsync.when(
        loading: () => _buildShimmer(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () =>
              ref.invalidate(coachSessionDetailProvider(widget.sessionId)),
        ),
        data: (session) {
          _initAttendanceState(session);
          return _buildContent(session);
        },
      ),
    );
  }

  /// Seed the local attendance map from existing server data (once).
  void _initAttendanceState(CoachSession session) {
    if (_initialized) return;
    _initialized = true;

    final existing = <String, String>{};
    for (final a in session.attendances) {
      existing[a.studentProfileId] = a.status;
    }
    // Defer the provider write until after this build completes.
    Future.microtask(() {
      ref.read(attendanceLocalStateProvider(widget.sessionId).notifier).state =
          existing;
    });

    // Existing attendance starts read-only; an empty list on a started
    // session jumps straight into edit mode so the coach can fill it in.
    _editMode = existing.isEmpty && _canEditAttendance(session);
  }

  /// Coach may edit attendance any time once the session has started — no
  /// upper bound. Filling attendance late is the primary use case.
  bool _canEditAttendance(CoachSession session) {
    return DateTime.now().isAfter(session.startAt);
  }

  Widget _buildShimmer() {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, title: Text('Detail Sesi')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 80),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Hydrates the per-student grading drafts from the server's existing
  /// progress on the first build that has data. Subsequent saves invalidate
  /// the provider but we keep the local draft (server is source of truth on
  /// next screen open).
  void _hydrateDrafts(SessionProgressDetail detail) {
    if (_draftsHydrated) return;
    _draftsHydrated = true;
    // Hydration races user input: if the user expands a panel and starts
    // editing while the progress fetch is still in flight, this method runs
    // afterward. Use ??= / emptiness checks so server values only seed
    // empty fields and never overwrite in-progress edits.
    for (final sp in detail.sessionProgress) {
      final id = int.parse(sp.studentProfileId);
      final draft = _drafts.putIfAbsent(id, StudentGradingDraft.new);
      draft.overallStatus ??= sp.status;
      draft.overallScore ??= sp.score;
      if (draft.notes.isEmpty) draft.notes = sp.notes ?? '';
    }
    for (final s in detail.skillProgress) {
      final id = int.parse(s.studentProfileId);
      final draft = _drafts.putIfAbsent(id, StudentGradingDraft.new);
      draft.skills.putIfAbsent(
        int.parse(s.levelSkillId),
        () => SkillEntry(status: s.status, score: s.score),
      );
    }
  }

  StudentGradingDraft _draftFor(int studentProfileId) {
    return _drafts.putIfAbsent(studentProfileId, StudentGradingDraft.new);
  }

  Widget _buildContent(CoachSession session) {
    final localAttendance =
        ref.watch(attendanceLocalStateProvider(widget.sessionId));
    final canEdit = _canEditAttendance(session);

    // Hydrate drafts from server-side progress on first arrival.
    final progressAsync =
        ref.watch(coachSessionProgressProvider(widget.sessionId));
    progressAsync.whenData(_hydrateDrafts);

    final activeStudents = session.sessionStudents
        .where((s) => s.cancelledAt == null)
        .toList();
    final hasChanges = _hasUnsavedChanges(session, localAttendance);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              automaticallyImplyLeading: false,
              leading: ScrimIconButton(
                icon: Icons.arrow_back,
                semanticLabel: 'Kembali',
                onPressed: () => Navigator.maybePop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    SessionHero(
                      photoUrls: session.photoUrls,
                      photoPath: session.photoPath,
                      size: SessionHeroSize.lg,
                      borderRadius: 0,
                      enableZoom: true,
                      heroTag: 'coach-session-hero-${session.id}',
                    ),
                    // Keeps the back button legible over the top of the photo.
                    const HeroTopScrim(),
                    // Gradient scrim so the title stays readable on light photos.
                    const IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCC000000)],
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppDimensions.screenHorizontal,
                        right: AppDimensions.screenHorizontal,
                        bottom: AppDimensions.lg,
                      ),
                      child: IgnorePointer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (session.type != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusSm),
                                ),
                                child: Text(
                                  _sessionTypeLabel(session.type!),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            const SizedBox(height: AppDimensions.sm),
                            Text(
                              session.safeTitle,
                              style: AppTypography.headingLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.xs),
                            Row(
                              children: [
                                const Icon(Icons.schedule,
                                    size: 16, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  Formatters.formatDateTimeCompact(
                                      session.startAt),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.md),
                                const Icon(Icons.timer_outlined,
                                    size: 16, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  '${session.durationMinutes} menit',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.lg),

                    // ── Info cards row ──────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.people_outline,
                            label: 'Peserta',
                            value:
                                '${activeStudents.length}/${session.capacity}',
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.event_outlined,
                            label: 'Status',
                            value: _statusLabel(session.status),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // ── Venue with map ──────────────────────
                    if (session.venue != null)
                      VenueLocationSection(
                        venueName: session.venue!.name,
                        address: session.venue!.location?.address,
                        lat: session.venue!.location?.lat,
                        lng: session.venue!.location?.lng,
                      ),

                    // ── Notes ────────────────────────────────
                    if (session.notes != null &&
                        session.notes!.isNotEmpty) ...[
                      Text('Catatan', style: AppTypography.titleMedium),
                      const SizedBox(height: AppDimensions.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.md),
                        decoration: BoxDecoration(
                          color: AppSurfaces.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: Text(
                          session.notes!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                    ],

                    // ── Attendance header ───────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kehadiran', style: AppTypography.titleMedium),
                        if (canEdit &&
                            !_editMode &&
                            session.attendances.isNotEmpty)
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _editMode = true),
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // ── Student list with attendance toggles ─
                    if (activeStudents.isEmpty)
                      _EmptyStudents()
                    else
                      ...activeStudents.map((student) {
                        final profileId = student.studentProfileId;
                        final currentStatus = localAttendance[profileId];
                        return _StudentAttendanceRow(
                          student: student,
                          status: currentStatus,
                          editable: _editMode && canEdit,
                          onStatusChanged: (newStatus) {
                            final map = Map<String, String>.from(
                              ref.read(attendanceLocalStateProvider(
                                  widget.sessionId)),
                            );
                            map[profileId] = newStatus;
                            ref
                                .read(attendanceLocalStateProvider(
                                        widget.sessionId)
                                    .notifier)
                                .state = map;
                          },
                        );
                      }),

                    // ── Recommendations panel ─────────────
                    if (canEdit && activeStudents.isNotEmpty)
                      _RecommendationsCard(
                        sessionId: widget.sessionId,
                        students: activeStudents,
                      ),

                    // ── Grading section (past sessions only) ─
                    if (canEdit && activeStudents.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.lg),
                      Row(
                        children: [
                          Text('Penilaian Peserta',
                              style: AppTypography.titleMedium),
                          const SizedBox(width: AppDimensions.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.xs,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neutral50,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                            child: Text(
                              'Tap siswa untuk menilai',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      ...activeStudents.map((student) {
                        final id = int.parse(student.studentProfileId);
                        return _GradingCard(
                          key: ValueKey('grade-$id'),
                          student: student,
                          sessionId: widget.sessionId,
                          expanded: _expandedStudentId == id,
                          draft: _draftFor(id),
                          onToggle: () => setState(() {
                            _expandedStudentId =
                                _expandedStudentId == id ? null : id;
                          }),
                          onSaved: () => setState(() {
                            _expandedStudentId = null;
                          }),
                          onDraftChanged: () => setState(() {}),
                        );
                      }),
                    ],

                    // Bottom padding for sticky bar
                    SizedBox(
                      // Sticky save button (when shown) eats ~80px; when
                      // hidden, leave generous breathing room so the last
                      // card isn't crowded against the bottom navbar.
                      height: (_editMode && canEdit && hasChanges)
                          ? 100
                          : AppDimensions.xxxl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Sticky save button ─────────────────────────
        if (_editMode && canEdit && hasChanges)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              decoration: BoxDecoration(
                color: AppSurfaces.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _saving
                        ? null
                        : () => _handleSave(session),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Simpan Kehadiran'),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _hasUnsavedChanges(
      CoachSession session, Map<String, String> localAttendance) {
    final serverMap = <String, String>{
      for (final a in session.attendances) a.studentProfileId: a.status,
    };
    if (localAttendance.length != serverMap.length) return true;
    for (final entry in localAttendance.entries) {
      if (serverMap[entry.key] != entry.value) return true;
    }
    return false;
  }

  Future<void> _handleSave(CoachSession session) async {
    AppHaptics.tap();
    if (_saving) return;
    setState(() => _saving = true);

    final localAttendance =
        ref.read(attendanceLocalStateProvider(widget.sessionId));
    final attendances = localAttendance.entries
        .map((e) => {
              'student_profile_id': int.parse(e.key),
              'status': e.value,
            })
        .toList();

    try {
      final repo = ref.read(coachSessionRepoProvider);
      await repo.bulkSaveAttendance(int.parse(widget.sessionId), attendances);

      ref.invalidate(coachSessionDetailProvider(widget.sessionId));
      // Schedule list caches the row's `completion_state` and may also
      // need to drop a finished session from "Mendatang" once all
      // attendance is filled. Invalidate so navigating back shows fresh
      // data instead of relying on the next manual pull-to-refresh.
      ref.invalidate(coachSessionListProvider);
      _initialized = false;

      if (mounted) {
        setState(() {
          _saving = false;
          _editMode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kehadiran berhasil disimpan'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan kehadiran'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _sessionTypeLabel(String type) => switch (type) {
        'private' => 'Privat',
        'group' => 'Grup',
        'clinic' => 'Klinik',
        _ => type,
      };

  String _statusLabel(String? status) => switch (status) {
        'scheduled' => 'Terjadwal',
        'in_progress' => 'Berlangsung',
        'completed' => 'Selesai',
        'cancelled' => 'Dibatalkan',
        _ => status ?? '-',
      };
}

// ── Reusable widgets ────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  )),
              Text(value,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 40, color: AppColors.neutral400),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Belum ada peserta terdaftar',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentAttendanceRow extends StatelessWidget {
  final CoachSessionStudent student;
  final String? status;
  final bool editable;
  final ValueChanged<String> onStatusChanged;

  const _StudentAttendanceRow({
    required this.student,
    required this.status,
    required this.editable,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final profile = student.studentProfile;
    final name = Formatters.fullName(
      profile?.firstName,
      profile?.lastName,
      fallback: 'Peserta',
    );
    final photoUrl = profile?.photoUrls?['sm'];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          children: [
            // Student info row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary100,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? Text(
                          Formatters.initials(name),
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(name, style: AppTypography.bodyMedium),
                ),
                if (!editable && status != null)
                  _StatusBadge(status: status!),
              ],
            ),

            // Segmented toggle (editable mode)
            if (editable) ...[
              const SizedBox(height: AppDimensions.sm),
              _AttendanceSegmented(
                value: status,
                onChanged: onStatusChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      'present' => (AppColors.successLight, AppColors.success, 'Hadir'),
      'absent' => (
          AppColors.error.withValues(alpha: 0.1),
          AppColors.error,
          'Absen'
        ),
      'late' => (
          AppColors.warning.withValues(alpha: 0.1),
          AppColors.warning,
          'Terlambat'
        ),
      _ => (AppColors.neutral100, AppColors.textTertiary, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// One student in the grading list. Header row stays visible; tapping it
/// toggles the inline `StudentGradingPanel` accordion below. Three-dot menu
/// gives access to enrollment management (enroll / change program/level /
/// withdraw).
class _GradingCard extends ConsumerWidget {
  final CoachSessionStudent student;
  final String sessionId;
  final bool expanded;
  final StudentGradingDraft draft;
  final VoidCallback onToggle;
  final VoidCallback onSaved;
  final VoidCallback onDraftChanged;

  const _GradingCard({
    super.key,
    required this.student,
    required this.sessionId,
    required this.expanded,
    required this.draft,
    required this.onToggle,
    required this.onSaved,
    required this.onDraftChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = student.studentProfile;
    final name = Formatters.fullName(
      profile?.firstName,
      profile?.lastName,
      fallback: 'Peserta',
    );
    final photoUrl = profile?.photoUrls?['sm'];
    final id = int.parse(student.studentProfileId);
    final enrollmentAsync = ref.watch(coachStudentEnrollmentProvider(id));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: expanded
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.neutral200,
            width: expanded ? 1.4 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary100,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl == null
                          ? Text(
                              Formatters.initials(name),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(height: 2),
                          enrollmentAsync.when(
                            loading: () => Text(
                              '…',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            error: (_, _) => const SizedBox.shrink(),
                            data: (enrollment) {
                              if (enrollment == null) {
                                return Text(
                                  'Belum terdaftar di program',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              }
                              final level =
                                  enrollment.currentLevel?.name;
                              return Text(
                                level == null
                                    ? enrollment.program?.name ?? '—'
                                    : '${enrollment.program?.name ?? ""} · $level',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (draft.isReady)
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppDimensions.xs),
                        child: Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppColors.success,
                        ),
                      ),
                    PopupMenuButton<_StudentMenuAction>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (action) async {
                        final enrollment = enrollmentAsync.valueOrNull;
                        switch (action) {
                          case _StudentMenuAction.enroll:
                            await EnrollmentDialog.show(
                              context: context,
                              studentProfileId: id,
                              studentName: name,
                            );
                            break;
                          case _StudentMenuAction.changeProgram:
                            await EnrollmentDialog.show(
                              context: context,
                              studentProfileId: id,
                              studentName: name,
                              existing: enrollment,
                            );
                            break;
                          case _StudentMenuAction.withdraw:
                            if (enrollment != null && context.mounted) {
                              await _confirmWithdraw(
                                  context, ref, enrollment, name);
                            }
                            break;
                        }
                      },
                      itemBuilder: (_) {
                        final enrollment = enrollmentAsync.valueOrNull;
                        return enrollment == null
                            ? const [
                                PopupMenuItem(
                                  value: _StudentMenuAction.enroll,
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(Icons.school_outlined),
                                    title: Text('Daftarkan ke Program'),
                                  ),
                                ),
                              ]
                            : const [
                                PopupMenuItem(
                                  value: _StudentMenuAction.changeProgram,
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(Icons.edit_outlined),
                                    title: Text('Ubah Program / Level'),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: _StudentMenuAction.withdraw,
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.exit_to_app_outlined,
                                      color: AppColors.error,
                                    ),
                                    title: Text(
                                      'Tarik dari Program',
                                      style: TextStyle(
                                          color: AppColors.error),
                                    ),
                                  ),
                                ),
                              ];
                      },
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.expand_more,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              child: expanded
                  ? StudentGradingPanel(
                      sessionId: sessionId,
                      studentProfileId: id,
                      studentName: name,
                      draft: draft,
                      onChanged: onDraftChanged,
                      onSaved: onSaved,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmWithdraw(
    BuildContext context,
    WidgetRef ref,
    Enrollment enrollment,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tarik dari Program?'),
        content: Text(
          '$name akan dikeluarkan dari ${enrollment.program?.name ?? "program"}. '
          'Riwayat penilaian tetap tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton.tonal(
            onPressed: () {
              AppHaptics.tap();
              Navigator.pop(ctx, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tarik'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(coachEnrollmentRepoProvider)
          .withdraw(int.parse(enrollment.id));
      final spId = int.parse(enrollment.studentProfileId);
      ref.invalidate(coachStudentEnrollmentProvider(spId));
      // Level skills cache is keyed by (studentProfileId, levelId). Drop it
      // for this student's previous level so re-enrolling at the same level
      // forces a fresh fetch instead of replaying stale skills.
      if (enrollment.currentLevelId != null) {
        ref.invalidate(coachStudentLevelSkillsProvider((
          studentProfileId: spId,
          levelId: int.parse(enrollment.currentLevelId!),
        )));
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name ditarik dari program.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

enum _StudentMenuAction { enroll, changeProgram, withdraw }

class _AttendanceSegmented extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _AttendanceSegmented({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'present',
          label: Text('Hadir'),
          icon: Icon(Icons.check_circle_outline, size: 16),
        ),
        ButtonSegment(
          value: 'absent',
          label: Text('Absen'),
          icon: Icon(Icons.cancel_outlined, size: 16),
        ),
        ButtonSegment(
          value: 'late',
          label: Text('Terlambat'),
          icon: Icon(Icons.schedule, size: 16),
        ),
      ],
      selected: value != null ? {value!} : <String>{},
      emptySelectionAllowed: true,
      onSelectionChanged: (set) {
        if (set.isNotEmpty) onChanged(set.first);
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(AppTypography.labelSmall),
      ),
    );
  }
}


/// "Fokus yang Disarankan" — per-student curriculum recommendations grouped
/// into 3 buckets: needs work (`focus`), new skills (`introduce`), review.
/// Outer collapsible card; each student card collapses independently inside.
/// Mirrors the web `SessionRecommendations.vue` structure.
class _RecommendationsCard extends ConsumerStatefulWidget {
  final String sessionId;
  final List<CoachSessionStudent> students;

  const _RecommendationsCard({
    required this.sessionId,
    required this.students,
  });

  @override
  ConsumerState<_RecommendationsCard> createState() =>
      _RecommendationsCardState();
}

class _RecommendationsCardState extends ConsumerState<_RecommendationsCard> {
  bool _open = false;
  final Set<String> _expanded = {};
  late Map<String, String> _nameById;

  @override
  void initState() {
    super.initState();
    _rebuildNameIndex();
  }

  @override
  void didUpdateWidget(covariant _RecommendationsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.students, widget.students)) {
      _rebuildNameIndex();
    }
  }

  void _rebuildNameIndex() {
    _nameById = {
      for (final s in widget.students)
        s.studentProfileId: Formatters.fullName(
          s.studentProfile?.firstName,
          s.studentProfile?.lastName,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(coachSessionRecommendationsProvider(widget.sessionId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(items.length),
              if (_open) ...[
                const SizedBox(height: AppDimensions.sm),
                ...items.map((rec) => _StudentRecommendation(
                      key: ValueKey('rec-${rec.studentProfileId}'),
                      rec: rec,
                      studentName: _nameById[rec.studentProfileId] ??
                          'Siswa #${rec.studentProfileId}',
                      expanded: _expanded.contains(rec.studentProfileId),
                      onToggle: () => setState(() {
                        if (_expanded.contains(rec.studentProfileId)) {
                          _expanded.remove(rec.studentProfileId);
                        } else {
                          _expanded.add(rec.studentProfileId);
                        }
                      }),
                    )),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return InkWell(
      onTap: () => setState(() => _open = !_open),
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.accent50,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
              color: AppColors.accent200.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline,
                size: 18, color: AppColors.accent700),
            const SizedBox(width: AppDimensions.sm),
            Text(
              'Fokus yang Disarankan',
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.accent900,
              ),
            ),
            const SizedBox(width: AppDimensions.xs),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.accent200,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                count.toString(),
                style: AppTypography.caption.copyWith(
                  color: AppColors.accent900,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              child:
                  Icon(Icons.expand_more, size: 16, color: AppColors.accent700),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single source of truth for the three recommendation buckets — collapsed
/// pill label, expanded section label, theme color, accessor, and whether
/// to show score on chips. Drives both `_CountPill`s in the collapsed row
/// and `_SkillBucket`s in the expanded body.
class _Bucket {
  final String pillLabel;
  final String sectionLabel;
  final Color color;
  final List<RecommendationSkill> Function(SessionRecommendation) skills;
  final bool showScore;

  const _Bucket({
    required this.pillLabel,
    required this.sectionLabel,
    required this.color,
    required this.skills,
    this.showScore = false,
  });
}

final List<_Bucket> _recommendationBuckets = [
  _Bucket(
    pillLabel: 'fokus',
    sectionLabel: 'PERLU LATIHAN',
    color: AppColors.warning,
    skills: (r) => r.focus,
    showScore: true,
  ),
  _Bucket(
    pillLabel: 'baru',
    sectionLabel: 'SKILL BARU',
    color: AppColors.primary,
    skills: (r) => r.introduce,
  ),
  _Bucket(
    pillLabel: 'review',
    sectionLabel: 'REVIEW',
    color: AppColors.success,
    skills: (r) => r.review,
  ),
];

class _StudentRecommendation extends StatelessWidget {
  final SessionRecommendation rec;
  final String studentName;
  final bool expanded;
  final VoidCallback onToggle;

  const _StudentRecommendation({
    super.key,
    required this.rec,
    required this.studentName,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (rec.hasEnrollment &&
                            (rec.programName != null ||
                                rec.levelName != null))
                          Text(
                            [rec.programName, rec.levelName]
                                .whereType<String>()
                                .where((s) => s.isNotEmpty)
                                .join(' · '),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (!rec.hasEnrollment)
                          Text(
                            'Belum terdaftar di program',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!expanded && rec.hasAny)
                    ..._recommendationBuckets.expand((b) {
                      final list = b.skills(rec);
                      if (list.isEmpty) return const <Widget>[];
                      return [
                        const SizedBox(width: 4),
                        _CountPill(
                          count: list.length,
                          label: b.pillLabel,
                          color: b.color,
                        ),
                      ];
                    }),
                  const SizedBox(width: AppDimensions.xs),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more,
                        size: 16, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) _buildExpandedBody(),
        ],
      ),
    );
  }

  Widget _buildExpandedBody() {
    if (!rec.hasEnrollment) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        margin: const EdgeInsets.fromLTRB(
          AppDimensions.md,
          0,
          AppDimensions.md,
          AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                size: 14, color: AppColors.warningDark),
            const SizedBox(width: AppDimensions.xs),
            Expanded(
              child: Text(
                'Daftarkan ke program untuk melihat rekomendasi.',
                style: AppTypography.caption
                    .copyWith(color: AppColors.warningDark),
              ),
            ),
          ],
        ),
      );
    }
    if (!rec.hasAny) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        margin: const EdgeInsets.fromLTRB(
          AppDimensions.md,
          0,
          AppDimensions.md,
          AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline,
                size: 14, color: AppColors.success),
            const SizedBox(width: AppDimensions.xs),
            Expanded(
              child: Text(
                'Sudah menguasai semua skill di level ini.',
                style: AppTypography.caption
                    .copyWith(color: AppColors.success),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        0,
        AppDimensions.md,
        AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final b in _recommendationBuckets)
            if (b.skills(rec).isNotEmpty)
              _SkillBucket(
                label: b.sectionLabel,
                color: b.color,
                skills: b.skills(rec),
                showScore: b.showScore,
              ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _CountPill({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        '$count $label',
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _SkillBucket extends StatelessWidget {
  final String label;
  final Color color;
  final List<RecommendationSkill> skills;
  final bool showScore;

  const _SkillBucket({
    required this.label,
    required this.color,
    required this.skills,
    this.showScore = false,
  });

  @override
  Widget build(BuildContext context) {
    // Cache shaded colors so we don't allocate 5 Color objects per chip.
    final bg = color.withValues(alpha: 0.08);
    final borderColor = color.withValues(alpha: 0.3);
    final muted = color.withValues(alpha: 0.7);
    final faint = color.withValues(alpha: 0.5);
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skills.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (s.category != null && s.category!.isNotEmpty) ...[
                      Text(
                        s.category!,
                        style: AppTypography.caption.copyWith(
                          color: muted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: AppTypography.caption.copyWith(
                          color: faint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    Text(
                      s.skillName,
                      style: AppTypography.caption.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                    if (showScore && s.score != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '${s.score}/10',
                        style: AppTypography.caption.copyWith(
                          color: muted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
