// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_payout_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachPayoutSummary _$CoachPayoutSummaryFromJson(Map<String, dynamic> json) {
  return _CoachPayoutSummary.fromJson(json);
}

/// @nodoc
mixin _$CoachPayoutSummary {
  String get period => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_earned_cents')
  int get totalEarnedCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_count')
  int get sessionCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_count')
  int get studentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_cents')
  int get pendingCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_cents')
  int get requestedCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_cents')
  int get approvedCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_cents')
  int get paidCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_request_id')
  int? get activeRequestId => throw _privateConstructorUsedError;

  /// Serializes this CoachPayoutSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachPayoutSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachPayoutSummaryCopyWith<CoachPayoutSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachPayoutSummaryCopyWith<$Res> {
  factory $CoachPayoutSummaryCopyWith(
    CoachPayoutSummary value,
    $Res Function(CoachPayoutSummary) then,
  ) = _$CoachPayoutSummaryCopyWithImpl<$Res, CoachPayoutSummary>;
  @useResult
  $Res call({
    String period,
    @JsonKey(name: 'total_earned_cents') int totalEarnedCents,
    @JsonKey(name: 'session_count') int sessionCount,
    @JsonKey(name: 'student_count') int studentCount,
    @JsonKey(name: 'pending_cents') int pendingCents,
    @JsonKey(name: 'requested_cents') int requestedCents,
    @JsonKey(name: 'approved_cents') int approvedCents,
    @JsonKey(name: 'paid_cents') int paidCents,
    @JsonKey(name: 'active_request_id') int? activeRequestId,
  });
}

/// @nodoc
class _$CoachPayoutSummaryCopyWithImpl<$Res, $Val extends CoachPayoutSummary>
    implements $CoachPayoutSummaryCopyWith<$Res> {
  _$CoachPayoutSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachPayoutSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? totalEarnedCents = null,
    Object? sessionCount = null,
    Object? studentCount = null,
    Object? pendingCents = null,
    Object? requestedCents = null,
    Object? approvedCents = null,
    Object? paidCents = null,
    Object? activeRequestId = freezed,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            totalEarnedCents: null == totalEarnedCents
                ? _value.totalEarnedCents
                : totalEarnedCents // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionCount: null == sessionCount
                ? _value.sessionCount
                : sessionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            studentCount: null == studentCount
                ? _value.studentCount
                : studentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingCents: null == pendingCents
                ? _value.pendingCents
                : pendingCents // ignore: cast_nullable_to_non_nullable
                      as int,
            requestedCents: null == requestedCents
                ? _value.requestedCents
                : requestedCents // ignore: cast_nullable_to_non_nullable
                      as int,
            approvedCents: null == approvedCents
                ? _value.approvedCents
                : approvedCents // ignore: cast_nullable_to_non_nullable
                      as int,
            paidCents: null == paidCents
                ? _value.paidCents
                : paidCents // ignore: cast_nullable_to_non_nullable
                      as int,
            activeRequestId: freezed == activeRequestId
                ? _value.activeRequestId
                : activeRequestId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachPayoutSummaryImplCopyWith<$Res>
    implements $CoachPayoutSummaryCopyWith<$Res> {
  factory _$$CoachPayoutSummaryImplCopyWith(
    _$CoachPayoutSummaryImpl value,
    $Res Function(_$CoachPayoutSummaryImpl) then,
  ) = __$$CoachPayoutSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String period,
    @JsonKey(name: 'total_earned_cents') int totalEarnedCents,
    @JsonKey(name: 'session_count') int sessionCount,
    @JsonKey(name: 'student_count') int studentCount,
    @JsonKey(name: 'pending_cents') int pendingCents,
    @JsonKey(name: 'requested_cents') int requestedCents,
    @JsonKey(name: 'approved_cents') int approvedCents,
    @JsonKey(name: 'paid_cents') int paidCents,
    @JsonKey(name: 'active_request_id') int? activeRequestId,
  });
}

/// @nodoc
class __$$CoachPayoutSummaryImplCopyWithImpl<$Res>
    extends _$CoachPayoutSummaryCopyWithImpl<$Res, _$CoachPayoutSummaryImpl>
    implements _$$CoachPayoutSummaryImplCopyWith<$Res> {
  __$$CoachPayoutSummaryImplCopyWithImpl(
    _$CoachPayoutSummaryImpl _value,
    $Res Function(_$CoachPayoutSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachPayoutSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? totalEarnedCents = null,
    Object? sessionCount = null,
    Object? studentCount = null,
    Object? pendingCents = null,
    Object? requestedCents = null,
    Object? approvedCents = null,
    Object? paidCents = null,
    Object? activeRequestId = freezed,
  }) {
    return _then(
      _$CoachPayoutSummaryImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        totalEarnedCents: null == totalEarnedCents
            ? _value.totalEarnedCents
            : totalEarnedCents // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionCount: null == sessionCount
            ? _value.sessionCount
            : sessionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        studentCount: null == studentCount
            ? _value.studentCount
            : studentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingCents: null == pendingCents
            ? _value.pendingCents
            : pendingCents // ignore: cast_nullable_to_non_nullable
                  as int,
        requestedCents: null == requestedCents
            ? _value.requestedCents
            : requestedCents // ignore: cast_nullable_to_non_nullable
                  as int,
        approvedCents: null == approvedCents
            ? _value.approvedCents
            : approvedCents // ignore: cast_nullable_to_non_nullable
                  as int,
        paidCents: null == paidCents
            ? _value.paidCents
            : paidCents // ignore: cast_nullable_to_non_nullable
                  as int,
        activeRequestId: freezed == activeRequestId
            ? _value.activeRequestId
            : activeRequestId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachPayoutSummaryImpl extends _CoachPayoutSummary {
  const _$CoachPayoutSummaryImpl({
    required this.period,
    @JsonKey(name: 'total_earned_cents') this.totalEarnedCents = 0,
    @JsonKey(name: 'session_count') this.sessionCount = 0,
    @JsonKey(name: 'student_count') this.studentCount = 0,
    @JsonKey(name: 'pending_cents') this.pendingCents = 0,
    @JsonKey(name: 'requested_cents') this.requestedCents = 0,
    @JsonKey(name: 'approved_cents') this.approvedCents = 0,
    @JsonKey(name: 'paid_cents') this.paidCents = 0,
    @JsonKey(name: 'active_request_id') this.activeRequestId,
  }) : super._();

  factory _$CoachPayoutSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachPayoutSummaryImplFromJson(json);

  @override
  final String period;
  @override
  @JsonKey(name: 'total_earned_cents')
  final int totalEarnedCents;
  @override
  @JsonKey(name: 'session_count')
  final int sessionCount;
  @override
  @JsonKey(name: 'student_count')
  final int studentCount;
  @override
  @JsonKey(name: 'pending_cents')
  final int pendingCents;
  @override
  @JsonKey(name: 'requested_cents')
  final int requestedCents;
  @override
  @JsonKey(name: 'approved_cents')
  final int approvedCents;
  @override
  @JsonKey(name: 'paid_cents')
  final int paidCents;
  @override
  @JsonKey(name: 'active_request_id')
  final int? activeRequestId;

  @override
  String toString() {
    return 'CoachPayoutSummary(period: $period, totalEarnedCents: $totalEarnedCents, sessionCount: $sessionCount, studentCount: $studentCount, pendingCents: $pendingCents, requestedCents: $requestedCents, approvedCents: $approvedCents, paidCents: $paidCents, activeRequestId: $activeRequestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachPayoutSummaryImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.totalEarnedCents, totalEarnedCents) ||
                other.totalEarnedCents == totalEarnedCents) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            (identical(other.pendingCents, pendingCents) ||
                other.pendingCents == pendingCents) &&
            (identical(other.requestedCents, requestedCents) ||
                other.requestedCents == requestedCents) &&
            (identical(other.approvedCents, approvedCents) ||
                other.approvedCents == approvedCents) &&
            (identical(other.paidCents, paidCents) ||
                other.paidCents == paidCents) &&
            (identical(other.activeRequestId, activeRequestId) ||
                other.activeRequestId == activeRequestId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    totalEarnedCents,
    sessionCount,
    studentCount,
    pendingCents,
    requestedCents,
    approvedCents,
    paidCents,
    activeRequestId,
  );

  /// Create a copy of CoachPayoutSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachPayoutSummaryImplCopyWith<_$CoachPayoutSummaryImpl> get copyWith =>
      __$$CoachPayoutSummaryImplCopyWithImpl<_$CoachPayoutSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachPayoutSummaryImplToJson(this);
  }
}

abstract class _CoachPayoutSummary extends CoachPayoutSummary {
  const factory _CoachPayoutSummary({
    required final String period,
    @JsonKey(name: 'total_earned_cents') final int totalEarnedCents,
    @JsonKey(name: 'session_count') final int sessionCount,
    @JsonKey(name: 'student_count') final int studentCount,
    @JsonKey(name: 'pending_cents') final int pendingCents,
    @JsonKey(name: 'requested_cents') final int requestedCents,
    @JsonKey(name: 'approved_cents') final int approvedCents,
    @JsonKey(name: 'paid_cents') final int paidCents,
    @JsonKey(name: 'active_request_id') final int? activeRequestId,
  }) = _$CoachPayoutSummaryImpl;
  const _CoachPayoutSummary._() : super._();

  factory _CoachPayoutSummary.fromJson(Map<String, dynamic> json) =
      _$CoachPayoutSummaryImpl.fromJson;

  @override
  String get period;
  @override
  @JsonKey(name: 'total_earned_cents')
  int get totalEarnedCents;
  @override
  @JsonKey(name: 'session_count')
  int get sessionCount;
  @override
  @JsonKey(name: 'student_count')
  int get studentCount;
  @override
  @JsonKey(name: 'pending_cents')
  int get pendingCents;
  @override
  @JsonKey(name: 'requested_cents')
  int get requestedCents;
  @override
  @JsonKey(name: 'approved_cents')
  int get approvedCents;
  @override
  @JsonKey(name: 'paid_cents')
  int get paidCents;
  @override
  @JsonKey(name: 'active_request_id')
  int? get activeRequestId;

  /// Create a copy of CoachPayoutSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachPayoutSummaryImplCopyWith<_$CoachPayoutSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
