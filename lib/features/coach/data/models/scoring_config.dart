// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scoring_config.freezed.dart';
part 'scoring_config.g.dart';

/// Tenant scoring configuration — drives both session-level and per-skill
/// grading UI. Fetched from `GET /v1/coach/settings/scoring` (Issue 15).
///
/// Each `*_scoring_type` is `'numeric'` or `'status'`:
/// - `numeric` → render slider; map score to status via `numeric` ranges.
/// - `status`  → render chip-picker from `status` enum keys.
@freezed
class ScoringConfig with _$ScoringConfig {
  const factory ScoringConfig({
    @JsonKey(name: 'session_scoring_type')
    @Default('status')
    String sessionScoringType,
    @JsonKey(name: 'skill_scoring_type')
    @Default('status')
    String skillScoringType,
    @JsonKey(name: 'show_numeric_to_members')
    @Default(true)
    bool showNumericToMembers,
    @JsonKey(name: 'session_labels')
    @Default(ScoringLabels())
    ScoringLabels sessionLabels,
    @JsonKey(name: 'skill_labels')
    @Default(ScoringLabels())
    ScoringLabels skillLabels,
  }) = _ScoringConfig;

  factory ScoringConfig.fromJson(Map<String, dynamic> json) =>
      _$ScoringConfigFromJson(json);
}

/// `status` is a `{ key: humanLabel }` map; `numeric` is a list of ranges.
@freezed
class ScoringLabels with _$ScoringLabels {
  const factory ScoringLabels({
    @Default(<String, String>{}) Map<String, String> status,
    @Default(<NumericRange>[]) List<NumericRange> numeric,
  }) = _ScoringLabels;

  factory ScoringLabels.fromJson(Map<String, dynamic> json) =>
      _$ScoringLabelsFromJson(json);
}

@freezed
class NumericRange with _$NumericRange {
  const factory NumericRange({
    required int min,
    required int max,
    required String label,
    String? color,
    required String status,
  }) = _NumericRange;

  factory NumericRange.fromJson(Map<String, dynamic> json) =>
      _$NumericRangeFromJson(json);
}
