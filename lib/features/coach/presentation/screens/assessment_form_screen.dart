import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/coach/data/models/scoring_config.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/features/coach/providers/scoring_config_provider.dart';

/// Session-level grading form. Sends `POST /v1/coach/sessions/{id}/progress`.
///
/// Form mode is driven by tenant `ScoringConfig.sessionScoringType` from
/// `GET /v1/coach/settings/scoring` (Issue 15):
/// - `'numeric'` → slider over the configured numeric ranges; status derived
///   from the matching range.
/// - `'status'`  → chip picker from `sessionLabels.status` keys.
///
/// Per-skill grading is deferred until the FE wires `GET /v1/coach/levels/{id}/skills`.
class AssessmentFormScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(scoringConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Sesi')),
      body: configAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    size: 40, color: AppColors.error),
                const SizedBox(height: AppDimensions.md),
                Text('Gagal memuat konfigurasi penilaian',
                    style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  e.toString(),
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.md),
                FilledButton(
                  onPressed: () => ref.invalidate(scoringConfigProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (config) => _Form(
          sessionId: sessionId,
          studentId: studentId,
          studentName: studentName,
          sessionTitle: sessionTitle,
          config: config,
        ),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  final String sessionId;
  final String studentId;
  final String? studentName;
  final String? sessionTitle;
  final ScoringConfig config;

  const _Form({
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.sessionTitle,
    required this.config,
  });

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late double _score;
  String? _status;
  final _notesController = TextEditingController();
  bool _saving = false;

  bool get _isNumeric => widget.config.sessionScoringType == 'numeric';
  List<NumericRange> get _ranges => widget.config.sessionLabels.numeric;
  Map<String, String> get _statusLabels =>
      widget.config.sessionLabels.status;

  @override
  void initState() {
    super.initState();
    if (_isNumeric && _ranges.isNotEmpty) {
      // Default to the midpoint of the range list.
      final last = _ranges.last;
      _score = ((last.max + _ranges.first.min) / 2).floorToDouble();
    } else {
      _score = 5;
      // Default to first status key, if any.
      if (_statusLabels.isNotEmpty) {
        _status = _statusLabels.keys.first;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Numeric → label from configured ranges.
  String _labelForScore(double score) {
    final s = score.round();
    for (final r in _ranges) {
      if (s >= r.min && s <= r.max) return r.label;
    }
    return '';
  }

  Future<void> _submit() async {
    if (_saving) return;
    if (!_isNumeric && _status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih status penilaian')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(coachSessionRepoProvider);
      await repo.saveSessionProgress(
        sessionId: int.parse(widget.sessionId),
        studentProfileId: int.parse(widget.studentId),
        score: _isNumeric ? _score.round() : null,
        status: _isNumeric ? null : _status,
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
    final double minScore =
        _ranges.isNotEmpty ? _ranges.first.min.toDouble() : 0;
    final double maxScore =
        _ranges.isNotEmpty ? _ranges.last.max.toDouble() : 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.studentName != null) ...[
            Text(widget.studentName!, style: AppTypography.titleMedium),
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

          if (_isNumeric) ...[
            Text(
              'Nilai (${minScore.toInt()}-${maxScore.toInt()})',
              style: AppTypography.titleSmall,
            ),
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
                    _labelForScore(_score),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _score,
              min: minScore,
              max: maxScore,
              divisions: (maxScore - minScore).toInt(),
              label: _score.round().toString(),
              onChanged: _saving
                  ? null
                  : (v) => setState(() => _score = v),
            ),
          ] else ...[
            Text('Status Penilaian', style: AppTypography.titleSmall),
            const SizedBox(height: AppDimensions.sm),
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: _statusLabels.entries
                  .map(
                    (e) => ChoiceChip(
                      label: Text(e.value),
                      selected: _status == e.key,
                      onSelected: _saving
                          ? null
                          : (sel) {
                              if (sel) setState(() => _status = e.key);
                            },
                    ),
                  )
                  .toList(),
            ),
          ],
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
        ],
      ),
    );
  }
}
