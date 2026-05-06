import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';

/// Numeric session-level grading form. Sends `POST /v1/coach/sessions/{id}/progress`.
///
/// Per-skill grading + categorical mode are deferred until BE Issue 15
/// (`GET /v1/coach/settings/scoring`) ships so the form can adapt to
/// `TenantScoringConfig`. Until then, this form sends both `score` (0-10) and
/// a derived `status`, which passes either tenant config.
class AssessmentFormScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String studentId;
  final String? studentName;
  final String? sessionTitle;

  const AssessmentFormScreen({
    super.key,
    required this.sessionId,
    required this.studentId,
    this.studentName,
    this.sessionTitle,
  });

  @override
  ConsumerState<AssessmentFormScreen> createState() =>
      _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends ConsumerState<AssessmentFormScreen> {
  double _score = 7;
  final _notesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _statusLabel(double score) {
    if (score <= 3) return 'Perlu Pengembangan';
    if (score <= 6) return 'Berkembang';
    if (score <= 8) return 'Baik';
    return 'Sangat Baik';
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(coachSessionRepoProvider);
      await repo.saveSessionProgress(
        sessionId: int.parse(widget.sessionId),
        studentProfileId: int.parse(widget.studentId),
        score: _score.round(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penilaian berhasil disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan penilaian: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Sesi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.studentName != null) ...[
              Text(
                widget.studentName!,
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppDimensions.xs),
            ],
            if (widget.sessionTitle != null)
              Text(
                widget.sessionTitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: AppDimensions.lg),

            Text('Nilai (0-10)', style: AppTypography.titleSmall),
            const SizedBox(height: AppDimensions.sm),
            Row(
              children: [
                Text(
                  _score.round().toString(),
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    _statusLabel(_score),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _score,
              min: 0,
              max: 10,
              divisions: 10,
              label: _score.round().toString(),
              onChanged: _saving
                  ? null
                  : (v) => setState(() => _score = v),
            ),
            const SizedBox(height: AppDimensions.lg),

            Text('Catatan', style: AppTypography.titleSmall),
            const SizedBox(height: AppDimensions.sm),
            TextField(
              controller: _notesController,
              maxLines: 5,
              maxLength: 2000,
              enabled: !_saving,
              decoration: const InputDecoration(
                hintText: 'Catatan pelatih untuk murid (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan Penilaian'),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: AppDimensions.xs),
                  Expanded(
                    child: Text(
                      'Penilaian per-skill akan tersedia setelah backend Issue 15.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
