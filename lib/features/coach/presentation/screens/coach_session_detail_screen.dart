import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
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

  /// Whether attendance is currently in edit mode.
  bool _editMode = false;

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
    // Defer state update to after build
    Future.microtask(() {
      ref.read(attendanceLocalStateProvider(widget.sessionId).notifier).state =
          existing;
    });

    // If attendance already exists, start read-only.
    // Otherwise auto-enter edit mode for sessions that have started.
    if (existing.isNotEmpty) {
      _editMode = false;
    } else {
      _editMode = _canEditAttendance(session);
    }
  }

  /// Coach may edit attendance any time once the session has started — no
  /// upper bound. Filling attendance late is the primary use case.
  bool _canEditAttendance(CoachSession session) {
    return DateTime.now().isAfter(session.startAt.toLocal());
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

  Widget _buildContent(CoachSession session) {
    final localAttendance =
        ref.watch(attendanceLocalStateProvider(widget.sessionId));
    final canEdit = _canEditAttendance(session);

    // Active (non-cancelled) students only
    final activeStudents = session.sessionStudents
        .where((s) => s.cancelledAt == null)
        .toList();

    // Check if there are any unsaved local changes
    final hasChanges = _hasUnsavedChanges(session, localAttendance);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppSurfaces.primaryGradient,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppDimensions.screenHorizontal,
                      right: AppDimensions.screenHorizontal,
                      bottom: AppDimensions.lg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Session type chip
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
                          session.name,
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
                                  session.startAt.toLocal()),
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

                    // ── Grading section (past sessions only) ─
                    if (canEdit && activeStudents.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.lg),
                      Text('Penilaian Peserta',
                          style: AppTypography.titleMedium),
                      const SizedBox(height: AppDimensions.sm),
                      ...activeStudents.map((student) => _GradingRow(
                            student: student,
                            sessionId: widget.sessionId,
                            sessionTitle: session.name,
                          )),
                    ],

                    // Bottom padding for sticky bar
                    SizedBox(
                        height: (_editMode && canEdit && hasChanges)
                            ? 100
                            : AppDimensions.screenBottom),
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
    // Build the server state map
    final serverMap = <String, String>{};
    for (final a in session.attendances) {
      serverMap[a.studentProfileId] = a.status;
    }
    // Compare
    if (localAttendance.length != serverMap.length) return true;
    for (final entry in localAttendance.entries) {
      if (serverMap[entry.key] != entry.value) return true;
    }
    return false;
  }

  Future<void> _handleSave(CoachSession session) async {
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

      // Refresh detail from server
      ref.invalidate(coachSessionDetailProvider(widget.sessionId));
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
    final name = profile != null
        ? '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim()
        : 'Peserta';
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

/// Per-participant grading entry. Tap navigates to AssessmentFormScreen.
class _GradingRow extends StatelessWidget {
  final CoachSessionStudent student;
  final String sessionId;
  final String sessionTitle;

  const _GradingRow({
    required this.student,
    required this.sessionId,
    required this.sessionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final profile = student.studentProfile;
    final name = profile != null
        ? '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim()
        : 'Peserta';
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
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
            FilledButton.tonal(
              onPressed: () {
                final path = '/coach/assessment/new'
                    '?sessionId=$sessionId'
                    '&sessionTitle=${Uri.encodeComponent(sessionTitle)}'
                    '&studentId=${student.studentProfileId}'
                    '&studentName=${Uri.encodeComponent(name)}';
                context.push(path);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeightSm),
              ),
              child: const Text('Beri Penilaian'),
            ),
          ],
        ),
      ),
    );
  }
}

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
