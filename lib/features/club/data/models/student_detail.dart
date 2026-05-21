// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'student_detail.freezed.dart';
part 'student_detail.g.dart';

/// `GET /v1/coach/students/{id}` (Issue 19.2). Coach-scope view —
/// `session_history[]` is filtered to sessions where the auth coach was
/// assigned. No financial fields exposed (admin-only via 19.3).
@freezed
class StudentDetail with _$StudentDetail {
  const factory StudentDetail({
    required StudentProfileSummary student,
    @JsonKey(name: 'recent_trend')
    @Default(<AssessmentTrendPoint>[])
    List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    @Default(<SkillCategoryProgress>[])
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'session_history')
    @Default(<SessionHistoryItem>[])
    List<SessionHistoryItem> sessionHistory,
  }) = _StudentDetail;

  factory StudentDetail.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailFromJson(json);
}

@freezed
class StudentProfileSummary with _$StudentProfileSummary {
  const factory StudentProfileSummary({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    int? age,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? sport,
    StudentDetailEnrollment? enrollment,
    @Default(StudentEngagementStats()) StudentEngagementStats stats,
  }) = _StudentProfileSummary;

  factory StudentProfileSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileSummaryFromJson(json);
}

@freezed
class StudentDetailEnrollment with _$StudentDetailEnrollment {
  const factory StudentDetailEnrollment({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    @JsonKey(name: 'enrolled_at') DateTime? enrolledAt,
  }) = _StudentDetailEnrollment;

  factory StudentDetailEnrollment.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailEnrollmentFromJson(json);
}

@freezed
class StudentEngagementStats with _$StudentEngagementStats {
  const factory StudentEngagementStats({
    @JsonKey(name: 'total_sessions') @Default(0) int totalSessions,
    @JsonKey(name: 'attendance_rate') @Default(0.0) double attendanceRate,
    @JsonKey(name: 'skills_mastered_count')
    @Default(0)
    int skillsMasteredCount,
    @JsonKey(name: 'skills_total_count') @Default(0) int skillsTotalCount,
  }) = _StudentEngagementStats;

  factory StudentEngagementStats.fromJson(Map<String, dynamic> json) =>
      _$StudentEngagementStatsFromJson(json);
}

@freezed
class AssessmentTrendPoint with _$AssessmentTrendPoint {
  const factory AssessmentTrendPoint({
    DateTime? date,
    String? status,
    int? score,
  }) = _AssessmentTrendPoint;

  factory AssessmentTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$AssessmentTrendPointFromJson(json);
}

@freezed
class SkillCategoryProgress with _$SkillCategoryProgress {
  const factory SkillCategoryProgress({
    required String category,
    @JsonKey(name: 'achieved_count') @Default(0) int achievedCount,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
  }) = _SkillCategoryProgress;

  factory SkillCategoryProgress.fromJson(Map<String, dynamic> json) =>
      _$SkillCategoryProgressFromJson(json);
}

@freezed
class SessionHistoryItem with _$SessionHistoryItem {
  const factory SessionHistoryItem({
    @JsonKey(name: 'session_id', fromJson: idFromJson)
    required String sessionId,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'venue_name') String? venueName,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    SessionAssessment? assessment,
    @JsonKey(name: 'skill_results')
    @Default(<SessionSkillResult>[])
    List<SessionSkillResult> skillResults,
    // Admin-scope (19.3) only — null on the coach view.
    @JsonKey(name: 'assigned_coach') AssignedCoach? assignedCoach,
    SessionPayment? payment,
  }) = _SessionHistoryItem;

  factory SessionHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$SessionHistoryItemFromJson(json);
}

@freezed
class SessionAssessment with _$SessionAssessment {
  const factory SessionAssessment({
    String? status,
    int? score,
    String? notes,
  }) = _SessionAssessment;

  factory SessionAssessment.fromJson(Map<String, dynamic> json) =>
      _$SessionAssessmentFromJson(json);
}

@freezed
class SessionSkillResult with _$SessionSkillResult {
  const factory SessionSkillResult({
    @JsonKey(name: 'skill_name') required String skillName,
    String? category,
    String? status,
    int? score,
  }) = _SessionSkillResult;

  factory SessionSkillResult.fromJson(Map<String, dynamic> json) =>
      _$SessionSkillResultFromJson(json);
}

@freezed
class AssignedCoach with _$AssignedCoach {
  const factory AssignedCoach({
    @JsonKey(fromJson: idFromJson) required String id,
    String? name,
  }) = _AssignedCoach;

  factory AssignedCoach.fromJson(Map<String, dynamic> json) =>
      _$AssignedCoachFromJson(json);
}

/// Per-session payment object (admin scope only). `paymentProofUrl` is
/// nullable — BE adds it via `Purchase::getPaymentProofUrlAttribute()`
/// once the smoke-test follow-up lands; FE renders the zoom thumbnail
/// only when non-null.
@freezed
class SessionPayment with _$SessionPayment {
  const factory SessionPayment({
    String? status,
    @JsonKey(name: 'amount_paid') @Default(0) int amountPaid,
    @Default('IDR') String currency,
    @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
    String? purchaseId,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  }) = _SessionPayment;

  factory SessionPayment.fromJson(Map<String, dynamic> json) =>
      _$SessionPaymentFromJson(json);
}

/// `GET /v1/admin/students/{id}/detail` (Issue 19.3). Extends 19.2 with
/// `financial_stats` + `payment_history[]`. The base `student` /
/// `recent_trend` / `skill_breakdown` / `session_history` shapes are
/// identical — `session_history[]` items add `assigned_coach` + nested
/// `payment` objects when admin-scoped.
@freezed
class AdminStudentDetail with _$AdminStudentDetail {
  const factory AdminStudentDetail({
    required StudentProfileSummary student,
    @JsonKey(name: 'recent_trend')
    @Default(<AssessmentTrendPoint>[])
    List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    @Default(<SkillCategoryProgress>[])
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'financial_stats')
    @Default(FinancialStats())
    FinancialStats financialStats,
    @JsonKey(name: 'payment_history')
    @Default(<PaymentHistoryItem>[])
    List<PaymentHistoryItem> paymentHistory,
    @JsonKey(name: 'session_history')
    @Default(<SessionHistoryItem>[])
    List<SessionHistoryItem> sessionHistory,
  }) = _AdminStudentDetail;

  factory AdminStudentDetail.fromJson(Map<String, dynamic> json) =>
      _$AdminStudentDetailFromJson(json);
}

@freezed
class FinancialStats with _$FinancialStats {
  const factory FinancialStats({
    @JsonKey(name: 'paid_this_month') @Default(0) int paidThisMonth,
    @JsonKey(name: 'outstanding_amount') @Default(0) int outstandingAmount,
    @JsonKey(name: 'outstanding_count') @Default(0) int outstandingCount,
    @JsonKey(name: 'total_transactions') @Default(0) int totalTransactions,

    // ── Member Detail v2 fields (spec: PRD-organizer-dashboard-be-fields.md) ──
    // Nullable on purpose: BE may not return them yet. UI hides the aging
    // progress bar + lifetime tile gracefully when null.
    @JsonKey(name: 'oldest_unpaid_days') int? oldestUnpaidDays,
    @JsonKey(name: 'lifetime_spend') int? lifetimeSpend,
  }) = _FinancialStats;

  factory FinancialStats.fromJson(Map<String, dynamic> json) =>
      _$FinancialStatsFromJson(json);
}

@freezed
class PaymentHistoryItem with _$PaymentHistoryItem {
  const factory PaymentHistoryItem({
    @JsonKey(name: 'purchase_id', fromJson: idFromJson)
    required String purchaseId,
    DateTime? date,
    @Default(0) int amount,
    @Default('IDR') String currency,
    String? description,
    String? status,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  }) = _PaymentHistoryItem;

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryItemFromJson(json);
}
