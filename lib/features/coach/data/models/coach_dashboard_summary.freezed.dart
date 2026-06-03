// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoachDashboardSummary {
  SectionResult<CoachPerformance> get performance =>
      throw _privateConstructorUsedError;
  SectionResult<CoachActionCounts> get actions =>
      throw _privateConstructorUsedError;
  SectionResult<List<CoachStudentRosterItem>> get attentionList =>
      throw _privateConstructorUsedError;
  SectionResult<Map<Sport, int>> get sportBreakdown =>
      throw _privateConstructorUsedError;
  int get sessionsTomorrow => throw _privateConstructorUsedError;

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachDashboardSummaryCopyWith<CoachDashboardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachDashboardSummaryCopyWith<$Res> {
  factory $CoachDashboardSummaryCopyWith(
    CoachDashboardSummary value,
    $Res Function(CoachDashboardSummary) then,
  ) = _$CoachDashboardSummaryCopyWithImpl<$Res, CoachDashboardSummary>;
  @useResult
  $Res call({
    SectionResult<CoachPerformance> performance,
    SectionResult<CoachActionCounts> actions,
    SectionResult<List<CoachStudentRosterItem>> attentionList,
    SectionResult<Map<Sport, int>> sportBreakdown,
    int sessionsTomorrow,
  });

  $SectionResultCopyWith<CoachPerformance, $Res> get performance;
  $SectionResultCopyWith<CoachActionCounts, $Res> get actions;
  $SectionResultCopyWith<List<CoachStudentRosterItem>, $Res> get attentionList;
  $SectionResultCopyWith<Map<Sport, int>, $Res> get sportBreakdown;
}

/// @nodoc
class _$CoachDashboardSummaryCopyWithImpl<
  $Res,
  $Val extends CoachDashboardSummary
>
    implements $CoachDashboardSummaryCopyWith<$Res> {
  _$CoachDashboardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? performance = null,
    Object? actions = null,
    Object? attentionList = null,
    Object? sportBreakdown = null,
    Object? sessionsTomorrow = null,
  }) {
    return _then(
      _value.copyWith(
            performance: null == performance
                ? _value.performance
                : performance // ignore: cast_nullable_to_non_nullable
                      as SectionResult<CoachPerformance>,
            actions: null == actions
                ? _value.actions
                : actions // ignore: cast_nullable_to_non_nullable
                      as SectionResult<CoachActionCounts>,
            attentionList: null == attentionList
                ? _value.attentionList
                : attentionList // ignore: cast_nullable_to_non_nullable
                      as SectionResult<List<CoachStudentRosterItem>>,
            sportBreakdown: null == sportBreakdown
                ? _value.sportBreakdown
                : sportBreakdown // ignore: cast_nullable_to_non_nullable
                      as SectionResult<Map<Sport, int>>,
            sessionsTomorrow: null == sessionsTomorrow
                ? _value.sessionsTomorrow
                : sessionsTomorrow // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SectionResultCopyWith<CoachPerformance, $Res> get performance {
    return $SectionResultCopyWith<CoachPerformance, $Res>(_value.performance, (
      value,
    ) {
      return _then(_value.copyWith(performance: value) as $Val);
    });
  }

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SectionResultCopyWith<CoachActionCounts, $Res> get actions {
    return $SectionResultCopyWith<CoachActionCounts, $Res>(_value.actions, (
      value,
    ) {
      return _then(_value.copyWith(actions: value) as $Val);
    });
  }

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SectionResultCopyWith<List<CoachStudentRosterItem>, $Res> get attentionList {
    return $SectionResultCopyWith<List<CoachStudentRosterItem>, $Res>(
      _value.attentionList,
      (value) {
        return _then(_value.copyWith(attentionList: value) as $Val);
      },
    );
  }

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SectionResultCopyWith<Map<Sport, int>, $Res> get sportBreakdown {
    return $SectionResultCopyWith<Map<Sport, int>, $Res>(
      _value.sportBreakdown,
      (value) {
        return _then(_value.copyWith(sportBreakdown: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$CoachDashboardSummaryImplCopyWith<$Res>
    implements $CoachDashboardSummaryCopyWith<$Res> {
  factory _$$CoachDashboardSummaryImplCopyWith(
    _$CoachDashboardSummaryImpl value,
    $Res Function(_$CoachDashboardSummaryImpl) then,
  ) = __$$CoachDashboardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SectionResult<CoachPerformance> performance,
    SectionResult<CoachActionCounts> actions,
    SectionResult<List<CoachStudentRosterItem>> attentionList,
    SectionResult<Map<Sport, int>> sportBreakdown,
    int sessionsTomorrow,
  });

  @override
  $SectionResultCopyWith<CoachPerformance, $Res> get performance;
  @override
  $SectionResultCopyWith<CoachActionCounts, $Res> get actions;
  @override
  $SectionResultCopyWith<List<CoachStudentRosterItem>, $Res> get attentionList;
  @override
  $SectionResultCopyWith<Map<Sport, int>, $Res> get sportBreakdown;
}

/// @nodoc
class __$$CoachDashboardSummaryImplCopyWithImpl<$Res>
    extends
        _$CoachDashboardSummaryCopyWithImpl<$Res, _$CoachDashboardSummaryImpl>
    implements _$$CoachDashboardSummaryImplCopyWith<$Res> {
  __$$CoachDashboardSummaryImplCopyWithImpl(
    _$CoachDashboardSummaryImpl _value,
    $Res Function(_$CoachDashboardSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? performance = null,
    Object? actions = null,
    Object? attentionList = null,
    Object? sportBreakdown = null,
    Object? sessionsTomorrow = null,
  }) {
    return _then(
      _$CoachDashboardSummaryImpl(
        performance: null == performance
            ? _value.performance
            : performance // ignore: cast_nullable_to_non_nullable
                  as SectionResult<CoachPerformance>,
        actions: null == actions
            ? _value.actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as SectionResult<CoachActionCounts>,
        attentionList: null == attentionList
            ? _value.attentionList
            : attentionList // ignore: cast_nullable_to_non_nullable
                  as SectionResult<List<CoachStudentRosterItem>>,
        sportBreakdown: null == sportBreakdown
            ? _value.sportBreakdown
            : sportBreakdown // ignore: cast_nullable_to_non_nullable
                  as SectionResult<Map<Sport, int>>,
        sessionsTomorrow: null == sessionsTomorrow
            ? _value.sessionsTomorrow
            : sessionsTomorrow // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CoachDashboardSummaryImpl implements _CoachDashboardSummary {
  const _$CoachDashboardSummaryImpl({
    required this.performance,
    required this.actions,
    required this.attentionList,
    required this.sportBreakdown,
    required this.sessionsTomorrow,
  });

  @override
  final SectionResult<CoachPerformance> performance;
  @override
  final SectionResult<CoachActionCounts> actions;
  @override
  final SectionResult<List<CoachStudentRosterItem>> attentionList;
  @override
  final SectionResult<Map<Sport, int>> sportBreakdown;
  @override
  final int sessionsTomorrow;

  @override
  String toString() {
    return 'CoachDashboardSummary(performance: $performance, actions: $actions, attentionList: $attentionList, sportBreakdown: $sportBreakdown, sessionsTomorrow: $sessionsTomorrow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachDashboardSummaryImpl &&
            (identical(other.performance, performance) ||
                other.performance == performance) &&
            (identical(other.actions, actions) || other.actions == actions) &&
            (identical(other.attentionList, attentionList) ||
                other.attentionList == attentionList) &&
            (identical(other.sportBreakdown, sportBreakdown) ||
                other.sportBreakdown == sportBreakdown) &&
            (identical(other.sessionsTomorrow, sessionsTomorrow) ||
                other.sessionsTomorrow == sessionsTomorrow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    performance,
    actions,
    attentionList,
    sportBreakdown,
    sessionsTomorrow,
  );

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachDashboardSummaryImplCopyWith<_$CoachDashboardSummaryImpl>
  get copyWith =>
      __$$CoachDashboardSummaryImplCopyWithImpl<_$CoachDashboardSummaryImpl>(
        this,
        _$identity,
      );
}

abstract class _CoachDashboardSummary implements CoachDashboardSummary {
  const factory _CoachDashboardSummary({
    required final SectionResult<CoachPerformance> performance,
    required final SectionResult<CoachActionCounts> actions,
    required final SectionResult<List<CoachStudentRosterItem>> attentionList,
    required final SectionResult<Map<Sport, int>> sportBreakdown,
    required final int sessionsTomorrow,
  }) = _$CoachDashboardSummaryImpl;

  @override
  SectionResult<CoachPerformance> get performance;
  @override
  SectionResult<CoachActionCounts> get actions;
  @override
  SectionResult<List<CoachStudentRosterItem>> get attentionList;
  @override
  SectionResult<Map<Sport, int>> get sportBreakdown;
  @override
  int get sessionsTomorrow;

  /// Create a copy of CoachDashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachDashboardSummaryImplCopyWith<_$CoachDashboardSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
