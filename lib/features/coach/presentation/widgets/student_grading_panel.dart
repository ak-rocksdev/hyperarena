import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/features/coach/data/models/enrollment.dart';
import 'package:hyperarena/features/coach/data/models/level_skill.dart';
import 'package:hyperarena/features/coach/data/models/scoring_config.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/features/coach/providers/scoring_config_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/enrollment_dialog.dart';

/// Local mutable draft for one student's grade. Held in the parent screen's
/// state so switching between students doesn't lose work in progress.
class StudentGradingDraft {
  String? overallStatus;
  int? overallScore;
  String notes;
  /// Keyed by `level_skill_id`.
  final Map<int, SkillEntry> skills;

  StudentGradingDraft({
    this.overallStatus,
    this.overallScore,
    this.notes = '',
    Map<int, SkillEntry>? skills,
  }) : skills = skills ?? {};

  bool get isReady => overallStatus != null || overallScore != null;
}

class SkillEntry {
  String? status;
  int? score;

  SkillEntry({this.status, this.score});

  bool get isFilled => status != null || score != null;
}

/// Maps a session/skill status enum value to its themed colour. Shared by the
/// session-level chips, numeric range badge, and per-skill status pills.
Color _statusColor(String key) => switch (key) {
      'needs_work' => AppColors.error,
      'progressing' => AppColors.warning,
      'good' => AppColors.success,
      'excellent' => AppColors.primary,
      'not_started' => AppColors.neutral500,
      'in_progress' => AppColors.warning,
      'achieved' => AppColors.success,
      _ => AppColors.textSecondary,
    };

/// The expanded grading panel for one student. Renders attendance toggles,
/// "Salin dari Sesi Terakhir", overall score (numeric slider OR status chips
/// per tenant config), notes, the optional skill checklist (with personal
/// override labeled), and the Save Progres button.
class StudentGradingPanel extends ConsumerStatefulWidget {
  final String sessionId;
  final int studentProfileId;
  final String studentName;
  final StudentGradingDraft draft;
  final VoidCallback onChanged;
  final VoidCallback onSaved;

  const StudentGradingPanel({
    super.key,
    required this.sessionId,
    required this.studentProfileId,
    required this.studentName,
    required this.draft,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  ConsumerState<StudentGradingPanel> createState() =>
      _StudentGradingPanelState();
}

class _StudentGradingPanelState extends ConsumerState<StudentGradingPanel> {
  late final TextEditingController _notesController;
  bool _saving = false;
  bool _copying = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.draft.notes);
    _notesController.addListener(() {
      widget.draft.notes = _notesController.text;
    });
  }

  @override
  void didUpdateWidget(covariant StudentGradingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentProfileId != widget.studentProfileId) {
      _notesController.text = widget.draft.notes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save(ScoringConfig config) async {
    AppHaptics.tap();
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final draft = widget.draft;
      final skillProgress = <Map<String, dynamic>>[];
      draft.skills.forEach((levelSkillId, entry) {
        if (!entry.isFilled) return;
        skillProgress.add({
          'level_skill_id': levelSkillId,
          if (entry.status != null) 'status': entry.status,
          if (entry.score != null) 'score': entry.score,
        });
      });

      final repo = ref.read(coachSessionRepoProvider);
      await repo.saveSessionProgress(
        sessionId: int.parse(widget.sessionId),
        studentProfileId: widget.studentProfileId,
        score: config.sessionScoringType == 'numeric' ? draft.overallScore : null,
        status: config.sessionScoringType == 'status' ? draft.overallStatus : null,
        notes: draft.notes.trim().isEmpty ? null : draft.notes.trim(),
        skillProgress: skillProgress.isEmpty ? null : skillProgress,
      );
      ref.invalidate(coachSessionProgressProvider(widget.sessionId));
      ref.invalidate(coachSessionRecommendationsProvider(widget.sessionId));
      // Bumping a student's progress can flip the session's
      // completion_state from `needs_grading` → `complete`; invalidate
      // the schedule list so the chip shown there matches.
      ref.invalidate(coachSessionListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penilaian tersimpan'),
          backgroundColor: AppColors.success,
        ),
      );
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _copyFromLast() async {
    if (_copying) return;
    setState(() => _copying = true);
    try {
      final repo = ref.read(coachSessionRepoProvider);
      final detail = await repo.copyFromLast(
        sessionId: int.parse(widget.sessionId),
        studentProfileId: widget.studentProfileId,
      );
      if (!mounted) return;
      if (detail == null || detail.sessionProgress.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Belum ada penilaian sebelumnya untuk disalin.')),
        );
        return;
      }
      final sp = detail.sessionProgress.first;
      setState(() {
        widget.draft.overallStatus = sp.status;
        widget.draft.overallScore = sp.score;
        widget.draft.notes = sp.notes ?? '';
        _notesController.text = widget.draft.notes;
        widget.draft.skills.clear();
        for (final s in detail.skillProgress) {
          widget.draft.skills[int.parse(s.levelSkillId)] = SkillEntry(
            status: s.status,
            score: s.score,
          );
        }
      });
      widget.onChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disalin dari sesi terakhir.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada penilaian sebelumnya untuk disalin.')),
      );
    } finally {
      if (mounted) setState(() => _copying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(scoringConfigProvider);
    final enrollmentAsync = ref.watch(
      coachStudentEnrollmentProvider(widget.studentProfileId),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary50.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusLg),
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.sm,
        AppDimensions.md,
        AppDimensions.md,
      ),
      child: configAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppDimensions.md),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Text(
            'Gagal memuat konfigurasi penilaian: $e',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.error),
          ),
        ),
        data: (config) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCopyFromLastButton(),
            const SizedBox(height: AppDimensions.md),
            _buildSectionHeader(
              'Status Keseluruhan',
              info: 'Diwajibkan',
            ),
            const SizedBox(height: AppDimensions.sm),
            if (config.sessionScoringType == 'numeric')
              _buildNumericScore(config)
            else
              _buildStatusChips(config),
            const SizedBox(height: AppDimensions.lg),
            _buildSectionHeader('Catatan'),
            const SizedBox(height: AppDimensions.xs),
            TextField(
              controller: _notesController,
              maxLines: 3,
              maxLength: 2000,
              enabled: !_saving,
              decoration: InputDecoration(
                hintText: 'Catatan untuk siswa (opsional)',
                hintStyle: AppTypography.bodySmall
                    .copyWith(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppSurfaces.surface,
                contentPadding: const EdgeInsets.all(AppDimensions.sm),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.neutral200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.neutral200),
                ),
                isDense: true,
                counterText: '',
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            _buildSkillsSection(config, enrollmentAsync),
            const SizedBox(height: AppDimensions.lg),
            _buildSaveButton(config),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, {String? info}) {
    return Row(
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        if (info != null) ...[
          const SizedBox(width: AppDimensions.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              info,
              style: AppTypography.caption.copyWith(
                color: AppColors.primary700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCopyFromLastButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: _copying || _saving ? null : _copyFromLast,
        icon: _copying
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.content_copy_outlined,
                size: 14,
                color: AppColors.primary,
              ),
        label: Text(
          'Salin dari Sesi Terakhir',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          minimumSize: const Size(0, 32),
        ),
      ),
    );
  }

  /// Numeric mode: large hero number + slider. Maps the active range to its
  /// label and color from the config.
  Widget _buildNumericScore(ScoringConfig config) {
    final score = widget.draft.overallScore;
    final ranges = config.sessionLabels.numeric;
    final min = ranges.isNotEmpty ? ranges.first.min.toDouble() : 0.0;
    final max = ranges.isNotEmpty ? ranges.last.max.toDouble() : 10.0;
    final activeRange = ranges.firstWhere(
      (r) => score != null && score >= r.min && score <= r.max,
      orElse: () => const NumericRange(
        min: 0,
        max: 10,
        label: '',
        status: '',
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.sm,
        AppDimensions.md,
        AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score?.toString() ?? '—',
                style: AppTypography.headingLarge.copyWith(
                  color: score == null
                      ? AppColors.textTertiary
                      : AppColors.primary,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ ${max.toInt()}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              const Spacer(),
              if (activeRange.label.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(activeRange.status)
                        .withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    activeRange.label,
                    style: AppTypography.labelSmall.copyWith(
                      color: _statusColor(activeRange.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Slider(
            value: (score ?? min).clamp(min, max).toDouble(),
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: score?.toString() ?? '—',
            onChanged: _saving
                ? null
                : (v) {
                    setState(() => widget.draft.overallScore = v.round());
                    widget.onChanged();
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChips(ScoringConfig config) {
    final entries = config.sessionLabels.status.entries.toList();
    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      children: entries.map((e) {
        final selected = widget.draft.overallStatus == e.key;
        final color = _statusColor(e.key);
        return _ChoicePill(
          label: e.value,
          color: color,
          selected: selected,
          onTap: _saving
              ? null
              : () {
                  setState(() => widget.draft.overallStatus = e.key);
                  widget.onChanged();
                },
        );
      }).toList(),
    );
  }

  Widget _buildSkillsSection(
    ScoringConfig config,
    AsyncValue<Enrollment?> enrollmentAsync,
  ) {
    return enrollmentAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (enrollment) {
        if (enrollment == null) return _buildNoEnrollmentBlock();
        if (enrollment.currentLevelId == null) {
          return _buildNoLevelBlock(enrollment);
        }
        final key = (
          studentProfileId: widget.studentProfileId,
          levelId: int.parse(enrollment.currentLevelId!),
        );
        final skillsAsync = ref.watch(coachStudentLevelSkillsProvider(key));
        return skillsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (skills) {
            if (skills.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader(
                  'Daftar Keahlian',
                  info: 'Opsional',
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Isi yang ingin dinilai. Yang dikosongkan tidak akan tersimpan.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                ...skills.map((s) => _SkillRow(
                      key: ValueKey(s.id),
                      skill: s,
                      config: config,
                      entry: widget.draft.skills.putIfAbsent(
                        int.parse(s.id),
                        SkillEntry.new,
                      ),
                      enabled: !_saving,
                      onChanged: () {
                        setState(() {});
                        widget.onChanged();
                      },
                    )),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNoEnrollmentBlock() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 18, color: AppColors.warningDark),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum terdaftar di program',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.warningDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Daftarkan untuk membuka penilaian per-skill berdasarkan kurikulum.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.warningDark,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                FilledButton.tonal(
                  onPressed: () => _openEnrollmentDialog(null),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.warningDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md),
                  ),
                  child: const Text('Daftarkan ke Program'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoLevelBlock(Enrollment enrollment) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              'Program ${enrollment.program?.name ?? ""} belum punya level. Penilaian per-skill tidak tersedia.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEnrollmentDialog(Enrollment? existing) {
    EnrollmentDialog.show(
      context: context,
      studentProfileId: widget.studentProfileId,
      studentName: widget.studentName,
      existing: existing,
    );
  }

  Widget _buildSaveButton(ScoringConfig config) {
    final ready = widget.draft.isReady;
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: FilledButton.icon(
        onPressed: (!ready || _saving) ? null : () => _save(config),
        icon: _saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save_outlined, size: 18),
        label: const Text('Simpan Progres'),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final LevelSkill skill;
  final ScoringConfig config;
  final SkillEntry entry;
  final bool enabled;
  final VoidCallback onChanged;

  const _SkillRow({
    super.key,
    required this.skill,
    required this.config,
    required this.entry,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isNumeric = config.skillScoringType == 'numeric';
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: skill.isOverride
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1.2,
              )
            : Border.all(color: AppColors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.skill?.name ?? 'Skill',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (entry.isFilled)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 14,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                      minWidth: 28, minHeight: 28),
                  onPressed: enabled
                      ? () {
                          entry.status = null;
                          entry.score = null;
                          onChanged();
                        }
                      : null,
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textTertiary,
                  ),
                  tooltip: 'Kosongkan',
                ),
            ],
          ),
          if (skill.isOverride) ...[
            const SizedBox(height: 4),
            _OverrideTag(),
          ],
          const SizedBox(height: AppDimensions.xs),
          if (isNumeric)
            _NumericSkillControl(
              entry: entry,
              config: config,
              enabled: enabled,
              onChanged: onChanged,
            )
          else
            _StatusSkillControl(
              entry: entry,
              config: config,
              enabled: enabled,
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}

/// Visual signal that this skill is configured specifically for one student
/// (`student_profile_id` set on the level_skills row). Web shows just a small
/// person-icon — the FE here uses a labeled chip so the meaning is clear
/// without prior context.
class _OverrideTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline, size: 10, color: AppColors.primary700),
          const SizedBox(width: 3),
          Text(
            'Khusus untuk siswa ini',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumericSkillControl extends StatelessWidget {
  final SkillEntry entry;
  final ScoringConfig config;
  final bool enabled;
  final VoidCallback onChanged;

  const _NumericSkillControl({
    required this.entry,
    required this.config,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ranges = config.skillLabels.numeric;
    final min = ranges.isNotEmpty ? ranges.first.min.toDouble() : 0.0;
    final max = ranges.isNotEmpty ? ranges.last.max.toDouble() : 10.0;
    final score = entry.score;
    final activeLabel = score == null
        ? null
        : ranges
            .where((r) => score >= r.min && score <= r.max)
            .firstOrNull
            ?.label;

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            score?.toString() ?? '—',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: score == null
                  ? AppColors.textTertiary
                  : AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: (score ?? min).clamp(min, max).toDouble(),
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: enabled
                ? (v) {
                    entry.score = v.round();
                    onChanged();
                  }
                : null,
          ),
        ),
        if (activeLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.xs),
            child: Text(
              activeLabel,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }
}

class _StatusSkillControl extends StatelessWidget {
  final SkillEntry entry;
  final ScoringConfig config;
  final bool enabled;
  final VoidCallback onChanged;

  const _StatusSkillControl({
    required this.entry,
    required this.config,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final entries = config.skillLabels.status.entries.toList();
    return Wrap(
      spacing: AppDimensions.xs,
      runSpacing: AppDimensions.xs,
      children: entries.map((e) {
        final selected = entry.status == e.key;
        return _ChoicePill(
          label: e.value,
          color: _statusColor(e.key),
          selected: selected,
          onTap: enabled
              ? () {
                  entry.status = selected ? null : e.key;
                  onChanged();
                }
              : null,
          dense: true,
        );
      }).toList(),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final bool dense;

  const _ChoicePill({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : AppSurfaces.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? AppDimensions.sm : AppDimensions.md,
            vertical: dense ? 4 : 6,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: selected ? color : AppColors.neutral200,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
