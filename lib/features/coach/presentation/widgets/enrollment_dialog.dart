import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/features/coach/data/models/enrollment.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';

/// Modal bottom sheet for enrolling a student in (or moving them to) a
/// program. When [existing] is null it acts as a first-time enroll; when
/// non-null it edits the existing enrollment.
///
/// Returns `true` via Navigator.pop when the save succeeds — caller
/// invalidates the dependent enrollment + level-skills providers.
class EnrollmentDialog extends ConsumerStatefulWidget {
  final int studentProfileId;
  final String studentName;
  final Enrollment? existing;

  const EnrollmentDialog({
    super.key,
    required this.studentProfileId,
    required this.studentName,
    this.existing,
  });

  static Future<bool?> show({
    required BuildContext context,
    required int studentProfileId,
    required String studentName,
    Enrollment? existing,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EnrollmentDialog(
          studentProfileId: studentProfileId,
          studentName: studentName,
          existing: existing,
        ),
      ),
    );
  }

  @override
  ConsumerState<EnrollmentDialog> createState() => _EnrollmentDialogState();
}

class _EnrollmentDialogState extends ConsumerState<EnrollmentDialog> {
  int? _programId;
  int? _levelId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _programId = int.tryParse(existing.programId);
      _levelId = existing.currentLevelId == null
          ? null
          : int.tryParse(existing.currentLevelId!);
    }
  }

  bool get _isEdit => widget.existing != null;

  Future<void> _save() async {
    AppHaptics.tap();
    if (_programId == null) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(coachEnrollmentRepoProvider);
      if (_isEdit) {
        await repo.updateEnrollment(
          enrollmentId: int.parse(widget.existing!.id),
          programId: _programId,
          currentLevelId: _levelId,
        );
      } else {
        await repo.enroll(
          studentProfileId: widget.studentProfileId,
          programId: _programId!,
          currentLevelId: _levelId,
        );
      }
      ref.invalidate(coachStudentEnrollmentProvider(widget.studentProfileId));
      // Drop the previous level's skills cache so changing program/level
      // back to a previously-visited level still triggers a fresh fetch.
      final prevLevelId = widget.existing?.currentLevelId;
      if (prevLevelId != null) {
        ref.invalidate(coachStudentLevelSkillsProvider((
          studentProfileId: widget.studentProfileId,
          levelId: int.parse(prevLevelId),
        )));
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final programsAsync = ref.watch(coachProgramsProvider);
    final levelsAsync = _programId == null
        ? null
        : ref.watch(coachProgramLevelsProvider(_programId!));

    return Container(
      decoration: const BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            _isEdit ? 'Ubah Pendaftaran' : 'Daftarkan ke Program',
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: AppDimensions.xxs),
          Text(
            widget.studentName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          Text('Program', style: AppTypography.labelMedium),
          const SizedBox(height: AppDimensions.xs),
          programsAsync.when(
            loading: () => const _LoadingField(),
            error: (e, _) => _ErrorField(
              message: 'Gagal memuat program: $e',
              onRetry: () => ref.invalidate(coachProgramsProvider),
            ),
            data: (programs) => DropdownButtonFormField<int>(
              initialValue: _programId,
              decoration: _fieldDecoration(),
              hint: const Text('Pilih program'),
              items: programs
                  .map((p) => DropdownMenuItem(
                        value: int.tryParse(p.id),
                        child: Text(p.name),
                      ))
                  .toList(),
              onChanged: _saving
                  ? null
                  : (v) => setState(() {
                        _programId = v;
                        _levelId = null;
                      }),
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          Row(
            children: [
              Text('Level', style: AppTypography.labelMedium),
              const SizedBox(width: AppDimensions.xs),
              Text('(Opsional)',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          if (_programId == null)
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Text(
                'Pilih program dulu untuk melihat level.',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textTertiary),
              ),
            )
          else
            levelsAsync!.when(
              loading: () => const _LoadingField(),
              error: (e, _) => _ErrorField(
                message: 'Gagal memuat level: $e',
                onRetry: () => ref
                    .invalidate(coachProgramLevelsProvider(_programId!)),
              ),
              data: (levels) => DropdownButtonFormField<int?>(
                initialValue: _levelId,
                decoration: _fieldDecoration(),
                hint: const Text('Pilih level'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('— Tanpa level —')),
                  ...levels.map((l) => DropdownMenuItem(
                        value: int.tryParse(l.id),
                        child: Text(l.name),
                      )),
                ],
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _levelId = v),
              ),
            ),

          const SizedBox(height: AppDimensions.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: FilledButton(
                  onPressed: (_programId == null || _saving) ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEdit ? 'Simpan' : 'Daftarkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
    );
  }
}

class _LoadingField extends StatelessWidget {
  const _LoadingField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _ErrorField extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorField({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: AppDimensions.xs),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
