// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentDetailImpl _$$StudentDetailImplFromJson(
  Map<String, dynamic> json,
) => _$StudentDetailImpl(
  student: StudentProfileSummary.fromJson(
    json['student'] as Map<String, dynamic>,
  ),
  recentTrend:
      (json['recent_trend'] as List<dynamic>?)
          ?.map((e) => AssessmentTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AssessmentTrendPoint>[],
  skillBreakdown:
      (json['skill_breakdown'] as List<dynamic>?)
          ?.map(
            (e) => SkillCategoryProgress.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <SkillCategoryProgress>[],
  sessionHistory:
      (json['session_history'] as List<dynamic>?)
          ?.map((e) => SessionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SessionHistoryItem>[],
);

Map<String, dynamic> _$$StudentDetailImplToJson(_$StudentDetailImpl instance) =>
    <String, dynamic>{
      'student': instance.student,
      'recent_trend': instance.recentTrend,
      'skill_breakdown': instance.skillBreakdown,
      'session_history': instance.sessionHistory,
    };

_$StudentProfileSummaryImpl _$$StudentProfileSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$StudentProfileSummaryImpl(
  id: idFromJson(json['id']),
  fullName: json['full_name'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  sport: json['sport'] as String?,
  enrollment: json['enrollment'] == null
      ? null
      : StudentDetailEnrollment.fromJson(
          json['enrollment'] as Map<String, dynamic>,
        ),
  stats: json['stats'] == null
      ? const StudentEngagementStats()
      : StudentEngagementStats.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$StudentProfileSummaryImplToJson(
  _$StudentProfileSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'age': instance.age,
  'gender': instance.gender,
  'photo_urls': instance.photoUrls,
  'sport': instance.sport,
  'enrollment': instance.enrollment,
  'stats': instance.stats,
};

_$StudentDetailEnrollmentImpl _$$StudentDetailEnrollmentImplFromJson(
  Map<String, dynamic> json,
) => _$StudentDetailEnrollmentImpl(
  id: idFromJson(json['id']),
  programName: json['program_name'] as String?,
  levelName: json['level_name'] as String?,
  enrolledAt: json['enrolled_at'] == null
      ? null
      : DateTime.parse(json['enrolled_at'] as String),
);

Map<String, dynamic> _$$StudentDetailEnrollmentImplToJson(
  _$StudentDetailEnrollmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'program_name': instance.programName,
  'level_name': instance.levelName,
  'enrolled_at': instance.enrolledAt?.toIso8601String(),
};

_$StudentEngagementStatsImpl _$$StudentEngagementStatsImplFromJson(
  Map<String, dynamic> json,
) => _$StudentEngagementStatsImpl(
  totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
  attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
  skillsMasteredCount: (json['skills_mastered_count'] as num?)?.toInt() ?? 0,
  skillsTotalCount: (json['skills_total_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$StudentEngagementStatsImplToJson(
  _$StudentEngagementStatsImpl instance,
) => <String, dynamic>{
  'total_sessions': instance.totalSessions,
  'attendance_rate': instance.attendanceRate,
  'skills_mastered_count': instance.skillsMasteredCount,
  'skills_total_count': instance.skillsTotalCount,
};

_$AssessmentTrendPointImpl _$$AssessmentTrendPointImplFromJson(
  Map<String, dynamic> json,
) => _$AssessmentTrendPointImpl(
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AssessmentTrendPointImplToJson(
  _$AssessmentTrendPointImpl instance,
) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'status': instance.status,
  'score': instance.score,
};

_$SkillCategoryProgressImpl _$$SkillCategoryProgressImplFromJson(
  Map<String, dynamic> json,
) => _$SkillCategoryProgressImpl(
  category: json['category'] as String,
  achievedCount: (json['achieved_count'] as num?)?.toInt() ?? 0,
  totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SkillCategoryProgressImplToJson(
  _$SkillCategoryProgressImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'achieved_count': instance.achievedCount,
  'total_count': instance.totalCount,
};

_$SessionHistoryItemImpl _$$SessionHistoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$SessionHistoryItemImpl(
  sessionId: idFromJson(json['session_id']),
  startAt: json['start_at'] == null
      ? null
      : DateTime.parse(json['start_at'] as String),
  venueName: json['venue_name'] as String?,
  attendanceStatus: json['attendance_status'] as String?,
  assessment: json['assessment'] == null
      ? null
      : SessionAssessment.fromJson(json['assessment'] as Map<String, dynamic>),
  skillResults:
      (json['skill_results'] as List<dynamic>?)
          ?.map((e) => SessionSkillResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SessionSkillResult>[],
  assignedCoach: json['assigned_coach'] == null
      ? null
      : AssignedCoach.fromJson(json['assigned_coach'] as Map<String, dynamic>),
  payment: json['payment'] == null
      ? null
      : SessionPayment.fromJson(json['payment'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SessionHistoryItemImplToJson(
  _$SessionHistoryItemImpl instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'start_at': instance.startAt?.toIso8601String(),
  'venue_name': instance.venueName,
  'attendance_status': instance.attendanceStatus,
  'assessment': instance.assessment,
  'skill_results': instance.skillResults,
  'assigned_coach': instance.assignedCoach,
  'payment': instance.payment,
};

_$SessionAssessmentImpl _$$SessionAssessmentImplFromJson(
  Map<String, dynamic> json,
) => _$SessionAssessmentImpl(
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$SessionAssessmentImplToJson(
  _$SessionAssessmentImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'score': instance.score,
  'notes': instance.notes,
};

_$SessionSkillResultImpl _$$SessionSkillResultImplFromJson(
  Map<String, dynamic> json,
) => _$SessionSkillResultImpl(
  skillName: json['skill_name'] as String,
  category: json['category'] as String?,
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
);

Map<String, dynamic> _$$SessionSkillResultImplToJson(
  _$SessionSkillResultImpl instance,
) => <String, dynamic>{
  'skill_name': instance.skillName,
  'category': instance.category,
  'status': instance.status,
  'score': instance.score,
};

_$AssignedCoachImpl _$$AssignedCoachImplFromJson(Map<String, dynamic> json) =>
    _$AssignedCoachImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$AssignedCoachImplToJson(_$AssignedCoachImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$SessionPaymentImpl _$$SessionPaymentImplFromJson(Map<String, dynamic> json) =>
    _$SessionPaymentImpl(
      status: json['status'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'IDR',
      purchaseId: nullableIdFromJson(json['purchase_id']),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      paymentProofUrl: json['payment_proof_url'] as String?,
    );

Map<String, dynamic> _$$SessionPaymentImplToJson(
  _$SessionPaymentImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'amount_paid': instance.amountPaid,
  'currency': instance.currency,
  'purchase_id': instance.purchaseId,
  'paid_at': instance.paidAt?.toIso8601String(),
  'payment_proof_url': instance.paymentProofUrl,
};

_$AdminStudentDetailImpl _$$AdminStudentDetailImplFromJson(
  Map<String, dynamic> json,
) => _$AdminStudentDetailImpl(
  student: StudentProfileSummary.fromJson(
    json['student'] as Map<String, dynamic>,
  ),
  recentTrend:
      (json['recent_trend'] as List<dynamic>?)
          ?.map((e) => AssessmentTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AssessmentTrendPoint>[],
  skillBreakdown:
      (json['skill_breakdown'] as List<dynamic>?)
          ?.map(
            (e) => SkillCategoryProgress.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <SkillCategoryProgress>[],
  financialStats: json['financial_stats'] == null
      ? const FinancialStats()
      : FinancialStats.fromJson(
          json['financial_stats'] as Map<String, dynamic>,
        ),
  paymentHistory:
      (json['payment_history'] as List<dynamic>?)
          ?.map((e) => PaymentHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PaymentHistoryItem>[],
  sessionHistory:
      (json['session_history'] as List<dynamic>?)
          ?.map((e) => SessionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SessionHistoryItem>[],
);

Map<String, dynamic> _$$AdminStudentDetailImplToJson(
  _$AdminStudentDetailImpl instance,
) => <String, dynamic>{
  'student': instance.student,
  'recent_trend': instance.recentTrend,
  'skill_breakdown': instance.skillBreakdown,
  'financial_stats': instance.financialStats,
  'payment_history': instance.paymentHistory,
  'session_history': instance.sessionHistory,
};

_$FinancialStatsImpl _$$FinancialStatsImplFromJson(Map<String, dynamic> json) =>
    _$FinancialStatsImpl(
      paidThisMonth: (json['paid_this_month'] as num?)?.toInt() ?? 0,
      outstandingAmount: (json['outstanding_amount'] as num?)?.toInt() ?? 0,
      outstandingCount: (json['outstanding_count'] as num?)?.toInt() ?? 0,
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FinancialStatsImplToJson(
  _$FinancialStatsImpl instance,
) => <String, dynamic>{
  'paid_this_month': instance.paidThisMonth,
  'outstanding_amount': instance.outstandingAmount,
  'outstanding_count': instance.outstandingCount,
  'total_transactions': instance.totalTransactions,
};

_$PaymentHistoryItemImpl _$$PaymentHistoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentHistoryItemImpl(
  purchaseId: idFromJson(json['purchase_id']),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num?)?.toInt() ?? 0,
  currency: json['currency'] as String? ?? 'IDR',
  description: json['description'] as String?,
  status: json['status'] as String?,
  paymentProofUrl: json['payment_proof_url'] as String?,
);

Map<String, dynamic> _$$PaymentHistoryItemImplToJson(
  _$PaymentHistoryItemImpl instance,
) => <String, dynamic>{
  'purchase_id': instance.purchaseId,
  'date': instance.date?.toIso8601String(),
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
  'status': instance.status,
  'payment_proof_url': instance.paymentProofUrl,
};
