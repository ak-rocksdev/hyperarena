// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_financial.freezed.dart';
part 'session_financial.g.dart';

/// Per-session financial snapshot — mirrors `SessionFinancialService::forSession()`.
///
/// Endpoint: `GET /v1/marketplace/organizer/sessions/{id}/financial`
/// Permission: `view-finances` (organizer / admin / super-admin).
///
/// Amounts are in the smallest currency unit (rupiah for IDR, sen for MYR
/// — same convention as `Formatters.formatCurrency`).
@freezed
class SessionFinancial with _$SessionFinancial {
  const factory SessionFinancial({
    required FinancialSide revenue,
    required FinancialSide cost,
    required FinancialNet net,
    @Default('IDR') String currency,
  }) = _SessionFinancial;

  factory SessionFinancial.fromJson(Map<String, dynamic> json) =>
      _$SessionFinancialFromJson(json);
}

@freezed
class FinancialSide with _$FinancialSide {
  const factory FinancialSide({
    @Default(0) int total,
    @JsonKey(name: 'system_tracked')
    @Default(SystemTrackedBlock())
    SystemTrackedBlock systemTracked,
    @Default(CustomBlock()) CustomBlock custom,
  }) = _FinancialSide;

  factory FinancialSide.fromJson(Map<String, dynamic> json) =>
      _$FinancialSideFromJson(json);
}

@freezed
class SystemTrackedBlock with _$SystemTrackedBlock {
  const factory SystemTrackedBlock({
    @Default(0) int total,
    @Default(<FinancialStream>[]) List<FinancialStream> streams,
  }) = _SystemTrackedBlock;

  factory SystemTrackedBlock.fromJson(Map<String, dynamic> json) =>
      _$SystemTrackedBlockFromJson(json);
}

/// One named stream inside the system-tracked block — e.g.
/// `key='student_payments'` or `key='coach_payouts'`. The `key` is stable
/// machine-readable so a BE-leads-FE deploy still renders (the key falls
/// through as the label) instead of crashing on an unknown enum value.
@freezed
class FinancialStream with _$FinancialStream {
  const factory FinancialStream({
    required String key,
    @Default(0) int amount,
  }) = _FinancialStream;

  factory FinancialStream.fromJson(Map<String, dynamic> json) =>
      _$FinancialStreamFromJson(json);
}

extension FinancialStreamX on FinancialStream {
  /// Indonesian label for the BE stream key. Add new keys here when BE
  /// adds them; fall-through preserves the raw key so a stale FE during
  /// deploy still surfaces the line item.
  String get displayLabel => switch (key) {
        'student_payments' => 'Pembayaran peserta',
        'refunds' => 'Refund',
        'coach_payouts' => 'Komisi pelatih',
        _ => key,
      };
}

@freezed
class CustomBlock with _$CustomBlock {
  const factory CustomBlock({
    @Default(0) int total,
    @Default(<FinancialEntry>[]) List<FinancialEntry> entries,
  }) = _CustomBlock;

  factory CustomBlock.fromJson(Map<String, dynamic> json) =>
      _$CustomBlockFromJson(json);
}

@freezed
class FinancialEntry with _$FinancialEntry {
  const factory FinancialEntry({
    required int id,
    @Default(0) int amount,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'recorded_by_name') String? recordedByName,
    FinancialEntryCategory? category,
    FinancialEntryStudent? student,
  }) = _FinancialEntry;

  factory FinancialEntry.fromJson(Map<String, dynamic> json) =>
      _$FinancialEntryFromJson(json);
}

@freezed
class FinancialEntryCategory with _$FinancialEntryCategory {
  const factory FinancialEntryCategory({
    required int id,
    required String name,
    String? icon,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
  }) = _FinancialEntryCategory;

  factory FinancialEntryCategory.fromJson(Map<String, dynamic> json) =>
      _$FinancialEntryCategoryFromJson(json);
}

@freezed
class FinancialEntryStudent with _$FinancialEntryStudent {
  const factory FinancialEntryStudent({
    required int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  }) = _FinancialEntryStudent;

  factory FinancialEntryStudent.fromJson(Map<String, dynamic> json) =>
      _$FinancialEntryStudentFromJson(json);
}

@freezed
class FinancialNet with _$FinancialNet {
  const factory FinancialNet({
    @Default(0) int amount,
    @JsonKey(name: 'margin_percent') int? marginPercent,
  }) = _FinancialNet;

  factory FinancialNet.fromJson(Map<String, dynamic> json) =>
      _$FinancialNetFromJson(json);
}
