// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentDetail _$StudentDetailFromJson(Map<String, dynamic> json) {
  return _StudentDetail.fromJson(json);
}

/// @nodoc
mixin _$StudentDetail {
  StudentProfileSummary get student => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this StudentDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentDetailCopyWith<StudentDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentDetailCopyWith<$Res> {
  factory $StudentDetailCopyWith(
    StudentDetail value,
    $Res Function(StudentDetail) then,
  ) = _$StudentDetailCopyWithImpl<$Res, StudentDetail>;
  @useResult
  $Res call({
    StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'session_history') List<SessionHistoryItem> sessionHistory,
  });

  $StudentProfileSummaryCopyWith<$Res> get student;
}

/// @nodoc
class _$StudentDetailCopyWithImpl<$Res, $Val extends StudentDetail>
    implements $StudentDetailCopyWith<$Res> {
  _$StudentDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? student = null,
    Object? recentTrend = null,
    Object? skillBreakdown = null,
    Object? sessionHistory = null,
  }) {
    return _then(
      _value.copyWith(
            student: null == student
                ? _value.student
                : student // ignore: cast_nullable_to_non_nullable
                      as StudentProfileSummary,
            recentTrend: null == recentTrend
                ? _value.recentTrend
                : recentTrend // ignore: cast_nullable_to_non_nullable
                      as List<AssessmentTrendPoint>,
            skillBreakdown: null == skillBreakdown
                ? _value.skillBreakdown
                : skillBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<SkillCategoryProgress>,
            sessionHistory: null == sessionHistory
                ? _value.sessionHistory
                : sessionHistory // ignore: cast_nullable_to_non_nullable
                      as List<SessionHistoryItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentProfileSummaryCopyWith<$Res> get student {
    return $StudentProfileSummaryCopyWith<$Res>(_value.student, (value) {
      return _then(_value.copyWith(student: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentDetailImplCopyWith<$Res>
    implements $StudentDetailCopyWith<$Res> {
  factory _$$StudentDetailImplCopyWith(
    _$StudentDetailImpl value,
    $Res Function(_$StudentDetailImpl) then,
  ) = __$$StudentDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'session_history') List<SessionHistoryItem> sessionHistory,
  });

  @override
  $StudentProfileSummaryCopyWith<$Res> get student;
}

/// @nodoc
class __$$StudentDetailImplCopyWithImpl<$Res>
    extends _$StudentDetailCopyWithImpl<$Res, _$StudentDetailImpl>
    implements _$$StudentDetailImplCopyWith<$Res> {
  __$$StudentDetailImplCopyWithImpl(
    _$StudentDetailImpl _value,
    $Res Function(_$StudentDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? student = null,
    Object? recentTrend = null,
    Object? skillBreakdown = null,
    Object? sessionHistory = null,
  }) {
    return _then(
      _$StudentDetailImpl(
        student: null == student
            ? _value.student
            : student // ignore: cast_nullable_to_non_nullable
                  as StudentProfileSummary,
        recentTrend: null == recentTrend
            ? _value._recentTrend
            : recentTrend // ignore: cast_nullable_to_non_nullable
                  as List<AssessmentTrendPoint>,
        skillBreakdown: null == skillBreakdown
            ? _value._skillBreakdown
            : skillBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<SkillCategoryProgress>,
        sessionHistory: null == sessionHistory
            ? _value._sessionHistory
            : sessionHistory // ignore: cast_nullable_to_non_nullable
                  as List<SessionHistoryItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentDetailImpl implements _StudentDetail {
  const _$StudentDetailImpl({
    required this.student,
    @JsonKey(name: 'recent_trend')
    final List<AssessmentTrendPoint> recentTrend =
        const <AssessmentTrendPoint>[],
    @JsonKey(name: 'skill_breakdown')
    final List<SkillCategoryProgress> skillBreakdown =
        const <SkillCategoryProgress>[],
    @JsonKey(name: 'session_history')
    final List<SessionHistoryItem> sessionHistory =
        const <SessionHistoryItem>[],
  }) : _recentTrend = recentTrend,
       _skillBreakdown = skillBreakdown,
       _sessionHistory = sessionHistory;

  factory _$StudentDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentDetailImplFromJson(json);

  @override
  final StudentProfileSummary student;
  final List<AssessmentTrendPoint> _recentTrend;
  @override
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend {
    if (_recentTrend is EqualUnmodifiableListView) return _recentTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTrend);
  }

  final List<SkillCategoryProgress> _skillBreakdown;
  @override
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown {
    if (_skillBreakdown is EqualUnmodifiableListView) return _skillBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillBreakdown);
  }

  final List<SessionHistoryItem> _sessionHistory;
  @override
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory {
    if (_sessionHistory is EqualUnmodifiableListView) return _sessionHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionHistory);
  }

  @override
  String toString() {
    return 'StudentDetail(student: $student, recentTrend: $recentTrend, skillBreakdown: $skillBreakdown, sessionHistory: $sessionHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentDetailImpl &&
            (identical(other.student, student) || other.student == student) &&
            const DeepCollectionEquality().equals(
              other._recentTrend,
              _recentTrend,
            ) &&
            const DeepCollectionEquality().equals(
              other._skillBreakdown,
              _skillBreakdown,
            ) &&
            const DeepCollectionEquality().equals(
              other._sessionHistory,
              _sessionHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    student,
    const DeepCollectionEquality().hash(_recentTrend),
    const DeepCollectionEquality().hash(_skillBreakdown),
    const DeepCollectionEquality().hash(_sessionHistory),
  );

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentDetailImplCopyWith<_$StudentDetailImpl> get copyWith =>
      __$$StudentDetailImplCopyWithImpl<_$StudentDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentDetailImplToJson(this);
  }
}

abstract class _StudentDetail implements StudentDetail {
  const factory _StudentDetail({
    required final StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') final List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    final List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'session_history')
    final List<SessionHistoryItem> sessionHistory,
  }) = _$StudentDetailImpl;

  factory _StudentDetail.fromJson(Map<String, dynamic> json) =
      _$StudentDetailImpl.fromJson;

  @override
  StudentProfileSummary get student;
  @override
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend;
  @override
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown;
  @override
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory;

  /// Create a copy of StudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentDetailImplCopyWith<_$StudentDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentProfileSummary _$StudentProfileSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _StudentProfileSummary.fromJson(json);
}

/// @nodoc
mixin _$StudentProfileSummary {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;
  String? get sport => throw _privateConstructorUsedError;
  StudentDetailEnrollment? get enrollment => throw _privateConstructorUsedError;
  StudentEngagementStats get stats => throw _privateConstructorUsedError;

  /// Serializes this StudentProfileSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileSummaryCopyWith<StudentProfileSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileSummaryCopyWith<$Res> {
  factory $StudentProfileSummaryCopyWith(
    StudentProfileSummary value,
    $Res Function(StudentProfileSummary) then,
  ) = _$StudentProfileSummaryCopyWithImpl<$Res, StudentProfileSummary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    int? age,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? sport,
    StudentDetailEnrollment? enrollment,
    StudentEngagementStats stats,
  });

  $StudentDetailEnrollmentCopyWith<$Res>? get enrollment;
  $StudentEngagementStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$StudentProfileSummaryCopyWithImpl<
  $Res,
  $Val extends StudentProfileSummary
>
    implements $StudentProfileSummaryCopyWith<$Res> {
  _$StudentProfileSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? photoUrls = freezed,
    Object? sport = freezed,
    Object? enrollment = freezed,
    Object? stats = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            sport: freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as String?,
            enrollment: freezed == enrollment
                ? _value.enrollment
                : enrollment // ignore: cast_nullable_to_non_nullable
                      as StudentDetailEnrollment?,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as StudentEngagementStats,
          )
          as $Val,
    );
  }

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentDetailEnrollmentCopyWith<$Res>? get enrollment {
    if (_value.enrollment == null) {
      return null;
    }

    return $StudentDetailEnrollmentCopyWith<$Res>(_value.enrollment!, (value) {
      return _then(_value.copyWith(enrollment: value) as $Val);
    });
  }

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentEngagementStatsCopyWith<$Res> get stats {
    return $StudentEngagementStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentProfileSummaryImplCopyWith<$Res>
    implements $StudentProfileSummaryCopyWith<$Res> {
  factory _$$StudentProfileSummaryImplCopyWith(
    _$StudentProfileSummaryImpl value,
    $Res Function(_$StudentProfileSummaryImpl) then,
  ) = __$$StudentProfileSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    int? age,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? sport,
    StudentDetailEnrollment? enrollment,
    StudentEngagementStats stats,
  });

  @override
  $StudentDetailEnrollmentCopyWith<$Res>? get enrollment;
  @override
  $StudentEngagementStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$StudentProfileSummaryImplCopyWithImpl<$Res>
    extends
        _$StudentProfileSummaryCopyWithImpl<$Res, _$StudentProfileSummaryImpl>
    implements _$$StudentProfileSummaryImplCopyWith<$Res> {
  __$$StudentProfileSummaryImplCopyWithImpl(
    _$StudentProfileSummaryImpl _value,
    $Res Function(_$StudentProfileSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? photoUrls = freezed,
    Object? sport = freezed,
    Object? enrollment = freezed,
    Object? stats = null,
  }) {
    return _then(
      _$StudentProfileSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        sport: freezed == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as String?,
        enrollment: freezed == enrollment
            ? _value.enrollment
            : enrollment // ignore: cast_nullable_to_non_nullable
                  as StudentDetailEnrollment?,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as StudentEngagementStats,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileSummaryImpl implements _StudentProfileSummary {
  const _$StudentProfileSummaryImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    this.age,
    this.gender,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    this.sport,
    this.enrollment,
    this.stats = const StudentEngagementStats(),
  }) : _photoUrls = photoUrls;

  factory _$StudentProfileSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileSummaryImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final int? age;
  @override
  final String? gender;
  final Map<String, String>? _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableMapView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? sport;
  @override
  final StudentDetailEnrollment? enrollment;
  @override
  @JsonKey()
  final StudentEngagementStats stats;

  @override
  String toString() {
    return 'StudentProfileSummary(id: $id, fullName: $fullName, firstName: $firstName, lastName: $lastName, age: $age, gender: $gender, photoUrls: $photoUrls, sport: $sport, enrollment: $enrollment, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.enrollment, enrollment) ||
                other.enrollment == enrollment) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    firstName,
    lastName,
    age,
    gender,
    const DeepCollectionEquality().hash(_photoUrls),
    sport,
    enrollment,
    stats,
  );

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileSummaryImplCopyWith<_$StudentProfileSummaryImpl>
  get copyWith =>
      __$$StudentProfileSummaryImplCopyWithImpl<_$StudentProfileSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileSummaryImplToJson(this);
  }
}

abstract class _StudentProfileSummary implements StudentProfileSummary {
  const factory _StudentProfileSummary({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'full_name') required final String fullName,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    final int? age,
    final String? gender,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    final String? sport,
    final StudentDetailEnrollment? enrollment,
    final StudentEngagementStats stats,
  }) = _$StudentProfileSummaryImpl;

  factory _StudentProfileSummary.fromJson(Map<String, dynamic> json) =
      _$StudentProfileSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  int? get age;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;
  @override
  String? get sport;
  @override
  StudentDetailEnrollment? get enrollment;
  @override
  StudentEngagementStats get stats;

  /// Create a copy of StudentProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileSummaryImplCopyWith<_$StudentProfileSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StudentDetailEnrollment _$StudentDetailEnrollmentFromJson(
  Map<String, dynamic> json,
) {
  return _StudentDetailEnrollment.fromJson(json);
}

/// @nodoc
mixin _$StudentDetailEnrollment {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'program_name')
  String? get programName => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_name')
  String? get levelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrolled_at')
  DateTime? get enrolledAt => throw _privateConstructorUsedError;

  /// Serializes this StudentDetailEnrollment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentDetailEnrollment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentDetailEnrollmentCopyWith<StudentDetailEnrollment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentDetailEnrollmentCopyWith<$Res> {
  factory $StudentDetailEnrollmentCopyWith(
    StudentDetailEnrollment value,
    $Res Function(StudentDetailEnrollment) then,
  ) = _$StudentDetailEnrollmentCopyWithImpl<$Res, StudentDetailEnrollment>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    @JsonKey(name: 'enrolled_at') DateTime? enrolledAt,
  });
}

/// @nodoc
class _$StudentDetailEnrollmentCopyWithImpl<
  $Res,
  $Val extends StudentDetailEnrollment
>
    implements $StudentDetailEnrollmentCopyWith<$Res> {
  _$StudentDetailEnrollmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentDetailEnrollment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? programName = freezed,
    Object? levelName = freezed,
    Object? enrolledAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            programName: freezed == programName
                ? _value.programName
                : programName // ignore: cast_nullable_to_non_nullable
                      as String?,
            levelName: freezed == levelName
                ? _value.levelName
                : levelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            enrolledAt: freezed == enrolledAt
                ? _value.enrolledAt
                : enrolledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentDetailEnrollmentImplCopyWith<$Res>
    implements $StudentDetailEnrollmentCopyWith<$Res> {
  factory _$$StudentDetailEnrollmentImplCopyWith(
    _$StudentDetailEnrollmentImpl value,
    $Res Function(_$StudentDetailEnrollmentImpl) then,
  ) = __$$StudentDetailEnrollmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    @JsonKey(name: 'enrolled_at') DateTime? enrolledAt,
  });
}

/// @nodoc
class __$$StudentDetailEnrollmentImplCopyWithImpl<$Res>
    extends
        _$StudentDetailEnrollmentCopyWithImpl<
          $Res,
          _$StudentDetailEnrollmentImpl
        >
    implements _$$StudentDetailEnrollmentImplCopyWith<$Res> {
  __$$StudentDetailEnrollmentImplCopyWithImpl(
    _$StudentDetailEnrollmentImpl _value,
    $Res Function(_$StudentDetailEnrollmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentDetailEnrollment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? programName = freezed,
    Object? levelName = freezed,
    Object? enrolledAt = freezed,
  }) {
    return _then(
      _$StudentDetailEnrollmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        programName: freezed == programName
            ? _value.programName
            : programName // ignore: cast_nullable_to_non_nullable
                  as String?,
        levelName: freezed == levelName
            ? _value.levelName
            : levelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        enrolledAt: freezed == enrolledAt
            ? _value.enrolledAt
            : enrolledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentDetailEnrollmentImpl implements _StudentDetailEnrollment {
  const _$StudentDetailEnrollmentImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'program_name') this.programName,
    @JsonKey(name: 'level_name') this.levelName,
    @JsonKey(name: 'enrolled_at') this.enrolledAt,
  });

  factory _$StudentDetailEnrollmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentDetailEnrollmentImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'program_name')
  final String? programName;
  @override
  @JsonKey(name: 'level_name')
  final String? levelName;
  @override
  @JsonKey(name: 'enrolled_at')
  final DateTime? enrolledAt;

  @override
  String toString() {
    return 'StudentDetailEnrollment(id: $id, programName: $programName, levelName: $levelName, enrolledAt: $enrolledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentDetailEnrollmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.programName, programName) ||
                other.programName == programName) &&
            (identical(other.levelName, levelName) ||
                other.levelName == levelName) &&
            (identical(other.enrolledAt, enrolledAt) ||
                other.enrolledAt == enrolledAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, programName, levelName, enrolledAt);

  /// Create a copy of StudentDetailEnrollment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentDetailEnrollmentImplCopyWith<_$StudentDetailEnrollmentImpl>
  get copyWith =>
      __$$StudentDetailEnrollmentImplCopyWithImpl<
        _$StudentDetailEnrollmentImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentDetailEnrollmentImplToJson(this);
  }
}

abstract class _StudentDetailEnrollment implements StudentDetailEnrollment {
  const factory _StudentDetailEnrollment({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'program_name') final String? programName,
    @JsonKey(name: 'level_name') final String? levelName,
    @JsonKey(name: 'enrolled_at') final DateTime? enrolledAt,
  }) = _$StudentDetailEnrollmentImpl;

  factory _StudentDetailEnrollment.fromJson(Map<String, dynamic> json) =
      _$StudentDetailEnrollmentImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'program_name')
  String? get programName;
  @override
  @JsonKey(name: 'level_name')
  String? get levelName;
  @override
  @JsonKey(name: 'enrolled_at')
  DateTime? get enrolledAt;

  /// Create a copy of StudentDetailEnrollment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentDetailEnrollmentImplCopyWith<_$StudentDetailEnrollmentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StudentEngagementStats _$StudentEngagementStatsFromJson(
  Map<String, dynamic> json,
) {
  return _StudentEngagementStats.fromJson(json);
}

/// @nodoc
mixin _$StudentEngagementStats {
  @JsonKey(name: 'total_sessions')
  int get totalSessions => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'skills_mastered_count')
  int get skillsMasteredCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'skills_total_count')
  int get skillsTotalCount => throw _privateConstructorUsedError;

  /// Serializes this StudentEngagementStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentEngagementStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentEngagementStatsCopyWith<StudentEngagementStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentEngagementStatsCopyWith<$Res> {
  factory $StudentEngagementStatsCopyWith(
    StudentEngagementStats value,
    $Res Function(StudentEngagementStats) then,
  ) = _$StudentEngagementStatsCopyWithImpl<$Res, StudentEngagementStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_sessions') int totalSessions,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'skills_mastered_count') int skillsMasteredCount,
    @JsonKey(name: 'skills_total_count') int skillsTotalCount,
  });
}

/// @nodoc
class _$StudentEngagementStatsCopyWithImpl<
  $Res,
  $Val extends StudentEngagementStats
>
    implements $StudentEngagementStatsCopyWith<$Res> {
  _$StudentEngagementStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentEngagementStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? attendanceRate = null,
    Object? skillsMasteredCount = null,
    Object? skillsTotalCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            attendanceRate: null == attendanceRate
                ? _value.attendanceRate
                : attendanceRate // ignore: cast_nullable_to_non_nullable
                      as double,
            skillsMasteredCount: null == skillsMasteredCount
                ? _value.skillsMasteredCount
                : skillsMasteredCount // ignore: cast_nullable_to_non_nullable
                      as int,
            skillsTotalCount: null == skillsTotalCount
                ? _value.skillsTotalCount
                : skillsTotalCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentEngagementStatsImplCopyWith<$Res>
    implements $StudentEngagementStatsCopyWith<$Res> {
  factory _$$StudentEngagementStatsImplCopyWith(
    _$StudentEngagementStatsImpl value,
    $Res Function(_$StudentEngagementStatsImpl) then,
  ) = __$$StudentEngagementStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_sessions') int totalSessions,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'skills_mastered_count') int skillsMasteredCount,
    @JsonKey(name: 'skills_total_count') int skillsTotalCount,
  });
}

/// @nodoc
class __$$StudentEngagementStatsImplCopyWithImpl<$Res>
    extends
        _$StudentEngagementStatsCopyWithImpl<$Res, _$StudentEngagementStatsImpl>
    implements _$$StudentEngagementStatsImplCopyWith<$Res> {
  __$$StudentEngagementStatsImplCopyWithImpl(
    _$StudentEngagementStatsImpl _value,
    $Res Function(_$StudentEngagementStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentEngagementStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? attendanceRate = null,
    Object? skillsMasteredCount = null,
    Object? skillsTotalCount = null,
  }) {
    return _then(
      _$StudentEngagementStatsImpl(
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        attendanceRate: null == attendanceRate
            ? _value.attendanceRate
            : attendanceRate // ignore: cast_nullable_to_non_nullable
                  as double,
        skillsMasteredCount: null == skillsMasteredCount
            ? _value.skillsMasteredCount
            : skillsMasteredCount // ignore: cast_nullable_to_non_nullable
                  as int,
        skillsTotalCount: null == skillsTotalCount
            ? _value.skillsTotalCount
            : skillsTotalCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentEngagementStatsImpl implements _StudentEngagementStats {
  const _$StudentEngagementStatsImpl({
    @JsonKey(name: 'total_sessions') this.totalSessions = 0,
    @JsonKey(name: 'attendance_rate') this.attendanceRate = 0.0,
    @JsonKey(name: 'skills_mastered_count') this.skillsMasteredCount = 0,
    @JsonKey(name: 'skills_total_count') this.skillsTotalCount = 0,
  });

  factory _$StudentEngagementStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentEngagementStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_sessions')
  final int totalSessions;
  @override
  @JsonKey(name: 'attendance_rate')
  final double attendanceRate;
  @override
  @JsonKey(name: 'skills_mastered_count')
  final int skillsMasteredCount;
  @override
  @JsonKey(name: 'skills_total_count')
  final int skillsTotalCount;

  @override
  String toString() {
    return 'StudentEngagementStats(totalSessions: $totalSessions, attendanceRate: $attendanceRate, skillsMasteredCount: $skillsMasteredCount, skillsTotalCount: $skillsTotalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentEngagementStatsImpl &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.attendanceRate, attendanceRate) ||
                other.attendanceRate == attendanceRate) &&
            (identical(other.skillsMasteredCount, skillsMasteredCount) ||
                other.skillsMasteredCount == skillsMasteredCount) &&
            (identical(other.skillsTotalCount, skillsTotalCount) ||
                other.skillsTotalCount == skillsTotalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalSessions,
    attendanceRate,
    skillsMasteredCount,
    skillsTotalCount,
  );

  /// Create a copy of StudentEngagementStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentEngagementStatsImplCopyWith<_$StudentEngagementStatsImpl>
  get copyWith =>
      __$$StudentEngagementStatsImplCopyWithImpl<_$StudentEngagementStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentEngagementStatsImplToJson(this);
  }
}

abstract class _StudentEngagementStats implements StudentEngagementStats {
  const factory _StudentEngagementStats({
    @JsonKey(name: 'total_sessions') final int totalSessions,
    @JsonKey(name: 'attendance_rate') final double attendanceRate,
    @JsonKey(name: 'skills_mastered_count') final int skillsMasteredCount,
    @JsonKey(name: 'skills_total_count') final int skillsTotalCount,
  }) = _$StudentEngagementStatsImpl;

  factory _StudentEngagementStats.fromJson(Map<String, dynamic> json) =
      _$StudentEngagementStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_sessions')
  int get totalSessions;
  @override
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate;
  @override
  @JsonKey(name: 'skills_mastered_count')
  int get skillsMasteredCount;
  @override
  @JsonKey(name: 'skills_total_count')
  int get skillsTotalCount;

  /// Create a copy of StudentEngagementStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentEngagementStatsImplCopyWith<_$StudentEngagementStatsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AssessmentTrendPoint _$AssessmentTrendPointFromJson(Map<String, dynamic> json) {
  return _AssessmentTrendPoint.fromJson(json);
}

/// @nodoc
mixin _$AssessmentTrendPoint {
  DateTime? get date => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  /// Serializes this AssessmentTrendPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssessmentTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssessmentTrendPointCopyWith<AssessmentTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentTrendPointCopyWith<$Res> {
  factory $AssessmentTrendPointCopyWith(
    AssessmentTrendPoint value,
    $Res Function(AssessmentTrendPoint) then,
  ) = _$AssessmentTrendPointCopyWithImpl<$Res, AssessmentTrendPoint>;
  @useResult
  $Res call({DateTime? date, String? status, int? score});
}

/// @nodoc
class _$AssessmentTrendPointCopyWithImpl<
  $Res,
  $Val extends AssessmentTrendPoint
>
    implements $AssessmentTrendPointCopyWith<$Res> {
  _$AssessmentTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssessmentTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? status = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssessmentTrendPointImplCopyWith<$Res>
    implements $AssessmentTrendPointCopyWith<$Res> {
  factory _$$AssessmentTrendPointImplCopyWith(
    _$AssessmentTrendPointImpl value,
    $Res Function(_$AssessmentTrendPointImpl) then,
  ) = __$$AssessmentTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? date, String? status, int? score});
}

/// @nodoc
class __$$AssessmentTrendPointImplCopyWithImpl<$Res>
    extends _$AssessmentTrendPointCopyWithImpl<$Res, _$AssessmentTrendPointImpl>
    implements _$$AssessmentTrendPointImplCopyWith<$Res> {
  __$$AssessmentTrendPointImplCopyWithImpl(
    _$AssessmentTrendPointImpl _value,
    $Res Function(_$AssessmentTrendPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? status = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _$AssessmentTrendPointImpl(
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssessmentTrendPointImpl implements _AssessmentTrendPoint {
  const _$AssessmentTrendPointImpl({this.date, this.status, this.score});

  factory _$AssessmentTrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssessmentTrendPointImplFromJson(json);

  @override
  final DateTime? date;
  @override
  final String? status;
  @override
  final int? score;

  @override
  String toString() {
    return 'AssessmentTrendPoint(date: $date, status: $status, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentTrendPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, status, score);

  /// Create a copy of AssessmentTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentTrendPointImplCopyWith<_$AssessmentTrendPointImpl>
  get copyWith =>
      __$$AssessmentTrendPointImplCopyWithImpl<_$AssessmentTrendPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssessmentTrendPointImplToJson(this);
  }
}

abstract class _AssessmentTrendPoint implements AssessmentTrendPoint {
  const factory _AssessmentTrendPoint({
    final DateTime? date,
    final String? status,
    final int? score,
  }) = _$AssessmentTrendPointImpl;

  factory _AssessmentTrendPoint.fromJson(Map<String, dynamic> json) =
      _$AssessmentTrendPointImpl.fromJson;

  @override
  DateTime? get date;
  @override
  String? get status;
  @override
  int? get score;

  /// Create a copy of AssessmentTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentTrendPointImplCopyWith<_$AssessmentTrendPointImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SkillCategoryProgress _$SkillCategoryProgressFromJson(
  Map<String, dynamic> json,
) {
  return _SkillCategoryProgress.fromJson(json);
}

/// @nodoc
mixin _$SkillCategoryProgress {
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'achieved_count')
  int get achievedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;

  /// Serializes this SkillCategoryProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillCategoryProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillCategoryProgressCopyWith<SkillCategoryProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillCategoryProgressCopyWith<$Res> {
  factory $SkillCategoryProgressCopyWith(
    SkillCategoryProgress value,
    $Res Function(SkillCategoryProgress) then,
  ) = _$SkillCategoryProgressCopyWithImpl<$Res, SkillCategoryProgress>;
  @useResult
  $Res call({
    String category,
    @JsonKey(name: 'achieved_count') int achievedCount,
    @JsonKey(name: 'total_count') int totalCount,
  });
}

/// @nodoc
class _$SkillCategoryProgressCopyWithImpl<
  $Res,
  $Val extends SkillCategoryProgress
>
    implements $SkillCategoryProgressCopyWith<$Res> {
  _$SkillCategoryProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillCategoryProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? achievedCount = null,
    Object? totalCount = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            achievedCount: null == achievedCount
                ? _value.achievedCount
                : achievedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkillCategoryProgressImplCopyWith<$Res>
    implements $SkillCategoryProgressCopyWith<$Res> {
  factory _$$SkillCategoryProgressImplCopyWith(
    _$SkillCategoryProgressImpl value,
    $Res Function(_$SkillCategoryProgressImpl) then,
  ) = __$$SkillCategoryProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String category,
    @JsonKey(name: 'achieved_count') int achievedCount,
    @JsonKey(name: 'total_count') int totalCount,
  });
}

/// @nodoc
class __$$SkillCategoryProgressImplCopyWithImpl<$Res>
    extends
        _$SkillCategoryProgressCopyWithImpl<$Res, _$SkillCategoryProgressImpl>
    implements _$$SkillCategoryProgressImplCopyWith<$Res> {
  __$$SkillCategoryProgressImplCopyWithImpl(
    _$SkillCategoryProgressImpl _value,
    $Res Function(_$SkillCategoryProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillCategoryProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? achievedCount = null,
    Object? totalCount = null,
  }) {
    return _then(
      _$SkillCategoryProgressImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        achievedCount: null == achievedCount
            ? _value.achievedCount
            : achievedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillCategoryProgressImpl implements _SkillCategoryProgress {
  const _$SkillCategoryProgressImpl({
    required this.category,
    @JsonKey(name: 'achieved_count') this.achievedCount = 0,
    @JsonKey(name: 'total_count') this.totalCount = 0,
  });

  factory _$SkillCategoryProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillCategoryProgressImplFromJson(json);

  @override
  final String category;
  @override
  @JsonKey(name: 'achieved_count')
  final int achievedCount;
  @override
  @JsonKey(name: 'total_count')
  final int totalCount;

  @override
  String toString() {
    return 'SkillCategoryProgress(category: $category, achievedCount: $achievedCount, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillCategoryProgressImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.achievedCount, achievedCount) ||
                other.achievedCount == achievedCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, achievedCount, totalCount);

  /// Create a copy of SkillCategoryProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillCategoryProgressImplCopyWith<_$SkillCategoryProgressImpl>
  get copyWith =>
      __$$SkillCategoryProgressImplCopyWithImpl<_$SkillCategoryProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillCategoryProgressImplToJson(this);
  }
}

abstract class _SkillCategoryProgress implements SkillCategoryProgress {
  const factory _SkillCategoryProgress({
    required final String category,
    @JsonKey(name: 'achieved_count') final int achievedCount,
    @JsonKey(name: 'total_count') final int totalCount,
  }) = _$SkillCategoryProgressImpl;

  factory _SkillCategoryProgress.fromJson(Map<String, dynamic> json) =
      _$SkillCategoryProgressImpl.fromJson;

  @override
  String get category;
  @override
  @JsonKey(name: 'achieved_count')
  int get achievedCount;
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;

  /// Create a copy of SkillCategoryProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillCategoryProgressImplCopyWith<_$SkillCategoryProgressImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SessionHistoryItem _$SessionHistoryItemFromJson(Map<String, dynamic> json) {
  return _SessionHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$SessionHistoryItem {
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at')
  DateTime? get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_name')
  String? get venueName => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_status')
  String? get attendanceStatus => throw _privateConstructorUsedError;
  SessionAssessment? get assessment => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_results')
  List<SessionSkillResult> get skillResults =>
      throw _privateConstructorUsedError; // Admin-scope (19.3) only — null on the coach view.
  @JsonKey(name: 'assigned_coach')
  AssignedCoach? get assignedCoach => throw _privateConstructorUsedError;
  SessionPayment? get payment => throw _privateConstructorUsedError;

  /// Serializes this SessionHistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryItemCopyWith<SessionHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryItemCopyWith<$Res> {
  factory $SessionHistoryItemCopyWith(
    SessionHistoryItem value,
    $Res Function(SessionHistoryItem) then,
  ) = _$SessionHistoryItemCopyWithImpl<$Res, SessionHistoryItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'venue_name') String? venueName,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    SessionAssessment? assessment,
    @JsonKey(name: 'skill_results') List<SessionSkillResult> skillResults,
    @JsonKey(name: 'assigned_coach') AssignedCoach? assignedCoach,
    SessionPayment? payment,
  });

  $SessionAssessmentCopyWith<$Res>? get assessment;
  $AssignedCoachCopyWith<$Res>? get assignedCoach;
  $SessionPaymentCopyWith<$Res>? get payment;
}

/// @nodoc
class _$SessionHistoryItemCopyWithImpl<$Res, $Val extends SessionHistoryItem>
    implements $SessionHistoryItemCopyWith<$Res> {
  _$SessionHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startAt = freezed,
    Object? venueName = freezed,
    Object? attendanceStatus = freezed,
    Object? assessment = freezed,
    Object? skillResults = null,
    Object? assignedCoach = freezed,
    Object? payment = freezed,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            venueName: freezed == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String?,
            attendanceStatus: freezed == attendanceStatus
                ? _value.attendanceStatus
                : attendanceStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            assessment: freezed == assessment
                ? _value.assessment
                : assessment // ignore: cast_nullable_to_non_nullable
                      as SessionAssessment?,
            skillResults: null == skillResults
                ? _value.skillResults
                : skillResults // ignore: cast_nullable_to_non_nullable
                      as List<SessionSkillResult>,
            assignedCoach: freezed == assignedCoach
                ? _value.assignedCoach
                : assignedCoach // ignore: cast_nullable_to_non_nullable
                      as AssignedCoach?,
            payment: freezed == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as SessionPayment?,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionAssessmentCopyWith<$Res>? get assessment {
    if (_value.assessment == null) {
      return null;
    }

    return $SessionAssessmentCopyWith<$Res>(_value.assessment!, (value) {
      return _then(_value.copyWith(assessment: value) as $Val);
    });
  }

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssignedCoachCopyWith<$Res>? get assignedCoach {
    if (_value.assignedCoach == null) {
      return null;
    }

    return $AssignedCoachCopyWith<$Res>(_value.assignedCoach!, (value) {
      return _then(_value.copyWith(assignedCoach: value) as $Val);
    });
  }

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionPaymentCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $SessionPaymentCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionHistoryItemImplCopyWith<$Res>
    implements $SessionHistoryItemCopyWith<$Res> {
  factory _$$SessionHistoryItemImplCopyWith(
    _$SessionHistoryItemImpl value,
    $Res Function(_$SessionHistoryItemImpl) then,
  ) = __$$SessionHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'venue_name') String? venueName,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    SessionAssessment? assessment,
    @JsonKey(name: 'skill_results') List<SessionSkillResult> skillResults,
    @JsonKey(name: 'assigned_coach') AssignedCoach? assignedCoach,
    SessionPayment? payment,
  });

  @override
  $SessionAssessmentCopyWith<$Res>? get assessment;
  @override
  $AssignedCoachCopyWith<$Res>? get assignedCoach;
  @override
  $SessionPaymentCopyWith<$Res>? get payment;
}

/// @nodoc
class __$$SessionHistoryItemImplCopyWithImpl<$Res>
    extends _$SessionHistoryItemCopyWithImpl<$Res, _$SessionHistoryItemImpl>
    implements _$$SessionHistoryItemImplCopyWith<$Res> {
  __$$SessionHistoryItemImplCopyWithImpl(
    _$SessionHistoryItemImpl _value,
    $Res Function(_$SessionHistoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startAt = freezed,
    Object? venueName = freezed,
    Object? attendanceStatus = freezed,
    Object? assessment = freezed,
    Object? skillResults = null,
    Object? assignedCoach = freezed,
    Object? payment = freezed,
  }) {
    return _then(
      _$SessionHistoryItemImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        venueName: freezed == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String?,
        attendanceStatus: freezed == attendanceStatus
            ? _value.attendanceStatus
            : attendanceStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        assessment: freezed == assessment
            ? _value.assessment
            : assessment // ignore: cast_nullable_to_non_nullable
                  as SessionAssessment?,
        skillResults: null == skillResults
            ? _value._skillResults
            : skillResults // ignore: cast_nullable_to_non_nullable
                  as List<SessionSkillResult>,
        assignedCoach: freezed == assignedCoach
            ? _value.assignedCoach
            : assignedCoach // ignore: cast_nullable_to_non_nullable
                  as AssignedCoach?,
        payment: freezed == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as SessionPayment?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionHistoryItemImpl implements _SessionHistoryItem {
  const _$SessionHistoryItemImpl({
    @JsonKey(name: 'session_id', fromJson: idFromJson) required this.sessionId,
    @JsonKey(name: 'start_at') this.startAt,
    @JsonKey(name: 'venue_name') this.venueName,
    @JsonKey(name: 'attendance_status') this.attendanceStatus,
    this.assessment,
    @JsonKey(name: 'skill_results')
    final List<SessionSkillResult> skillResults = const <SessionSkillResult>[],
    @JsonKey(name: 'assigned_coach') this.assignedCoach,
    this.payment,
  }) : _skillResults = skillResults;

  factory _$SessionHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionHistoryItemImplFromJson(json);

  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  final String sessionId;
  @override
  @JsonKey(name: 'start_at')
  final DateTime? startAt;
  @override
  @JsonKey(name: 'venue_name')
  final String? venueName;
  @override
  @JsonKey(name: 'attendance_status')
  final String? attendanceStatus;
  @override
  final SessionAssessment? assessment;
  final List<SessionSkillResult> _skillResults;
  @override
  @JsonKey(name: 'skill_results')
  List<SessionSkillResult> get skillResults {
    if (_skillResults is EqualUnmodifiableListView) return _skillResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillResults);
  }

  // Admin-scope (19.3) only — null on the coach view.
  @override
  @JsonKey(name: 'assigned_coach')
  final AssignedCoach? assignedCoach;
  @override
  final SessionPayment? payment;

  @override
  String toString() {
    return 'SessionHistoryItem(sessionId: $sessionId, startAt: $startAt, venueName: $venueName, attendanceStatus: $attendanceStatus, assessment: $assessment, skillResults: $skillResults, assignedCoach: $assignedCoach, payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryItemImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.assessment, assessment) ||
                other.assessment == assessment) &&
            const DeepCollectionEquality().equals(
              other._skillResults,
              _skillResults,
            ) &&
            (identical(other.assignedCoach, assignedCoach) ||
                other.assignedCoach == assignedCoach) &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    startAt,
    venueName,
    attendanceStatus,
    assessment,
    const DeepCollectionEquality().hash(_skillResults),
    assignedCoach,
    payment,
  );

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      __$$SessionHistoryItemImplCopyWithImpl<_$SessionHistoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionHistoryItemImplToJson(this);
  }
}

abstract class _SessionHistoryItem implements SessionHistoryItem {
  const factory _SessionHistoryItem({
    @JsonKey(name: 'session_id', fromJson: idFromJson)
    required final String sessionId,
    @JsonKey(name: 'start_at') final DateTime? startAt,
    @JsonKey(name: 'venue_name') final String? venueName,
    @JsonKey(name: 'attendance_status') final String? attendanceStatus,
    final SessionAssessment? assessment,
    @JsonKey(name: 'skill_results') final List<SessionSkillResult> skillResults,
    @JsonKey(name: 'assigned_coach') final AssignedCoach? assignedCoach,
    final SessionPayment? payment,
  }) = _$SessionHistoryItemImpl;

  factory _SessionHistoryItem.fromJson(Map<String, dynamic> json) =
      _$SessionHistoryItemImpl.fromJson;

  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId;
  @override
  @JsonKey(name: 'start_at')
  DateTime? get startAt;
  @override
  @JsonKey(name: 'venue_name')
  String? get venueName;
  @override
  @JsonKey(name: 'attendance_status')
  String? get attendanceStatus;
  @override
  SessionAssessment? get assessment;
  @override
  @JsonKey(name: 'skill_results')
  List<SessionSkillResult> get skillResults; // Admin-scope (19.3) only — null on the coach view.
  @override
  @JsonKey(name: 'assigned_coach')
  AssignedCoach? get assignedCoach;
  @override
  SessionPayment? get payment;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionAssessment _$SessionAssessmentFromJson(Map<String, dynamic> json) {
  return _SessionAssessment.fromJson(json);
}

/// @nodoc
mixin _$SessionAssessment {
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SessionAssessment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionAssessmentCopyWith<SessionAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionAssessmentCopyWith<$Res> {
  factory $SessionAssessmentCopyWith(
    SessionAssessment value,
    $Res Function(SessionAssessment) then,
  ) = _$SessionAssessmentCopyWithImpl<$Res, SessionAssessment>;
  @useResult
  $Res call({String? status, int? score, String? notes});
}

/// @nodoc
class _$SessionAssessmentCopyWithImpl<$Res, $Val extends SessionAssessment>
    implements $SessionAssessmentCopyWith<$Res> {
  _$SessionAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionAssessmentImplCopyWith<$Res>
    implements $SessionAssessmentCopyWith<$Res> {
  factory _$$SessionAssessmentImplCopyWith(
    _$SessionAssessmentImpl value,
    $Res Function(_$SessionAssessmentImpl) then,
  ) = __$$SessionAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? status, int? score, String? notes});
}

/// @nodoc
class __$$SessionAssessmentImplCopyWithImpl<$Res>
    extends _$SessionAssessmentCopyWithImpl<$Res, _$SessionAssessmentImpl>
    implements _$$SessionAssessmentImplCopyWith<$Res> {
  __$$SessionAssessmentImplCopyWithImpl(
    _$SessionAssessmentImpl _value,
    $Res Function(_$SessionAssessmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$SessionAssessmentImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionAssessmentImpl implements _SessionAssessment {
  const _$SessionAssessmentImpl({this.status, this.score, this.notes});

  factory _$SessionAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionAssessmentImplFromJson(json);

  @override
  final String? status;
  @override
  final int? score;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SessionAssessment(status: $status, score: $score, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionAssessmentImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, score, notes);

  /// Create a copy of SessionAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionAssessmentImplCopyWith<_$SessionAssessmentImpl> get copyWith =>
      __$$SessionAssessmentImplCopyWithImpl<_$SessionAssessmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionAssessmentImplToJson(this);
  }
}

abstract class _SessionAssessment implements SessionAssessment {
  const factory _SessionAssessment({
    final String? status,
    final int? score,
    final String? notes,
  }) = _$SessionAssessmentImpl;

  factory _SessionAssessment.fromJson(Map<String, dynamic> json) =
      _$SessionAssessmentImpl.fromJson;

  @override
  String? get status;
  @override
  int? get score;
  @override
  String? get notes;

  /// Create a copy of SessionAssessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionAssessmentImplCopyWith<_$SessionAssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionSkillResult _$SessionSkillResultFromJson(Map<String, dynamic> json) {
  return _SessionSkillResult.fromJson(json);
}

/// @nodoc
mixin _$SessionSkillResult {
  @JsonKey(name: 'skill_name')
  String get skillName => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  /// Serializes this SessionSkillResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionSkillResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSkillResultCopyWith<SessionSkillResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSkillResultCopyWith<$Res> {
  factory $SessionSkillResultCopyWith(
    SessionSkillResult value,
    $Res Function(SessionSkillResult) then,
  ) = _$SessionSkillResultCopyWithImpl<$Res, SessionSkillResult>;
  @useResult
  $Res call({
    @JsonKey(name: 'skill_name') String skillName,
    String? category,
    String? status,
    int? score,
  });
}

/// @nodoc
class _$SessionSkillResultCopyWithImpl<$Res, $Val extends SessionSkillResult>
    implements $SessionSkillResultCopyWith<$Res> {
  _$SessionSkillResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSkillResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillName = null,
    Object? category = freezed,
    Object? status = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _value.copyWith(
            skillName: null == skillName
                ? _value.skillName
                : skillName // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionSkillResultImplCopyWith<$Res>
    implements $SessionSkillResultCopyWith<$Res> {
  factory _$$SessionSkillResultImplCopyWith(
    _$SessionSkillResultImpl value,
    $Res Function(_$SessionSkillResultImpl) then,
  ) = __$$SessionSkillResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'skill_name') String skillName,
    String? category,
    String? status,
    int? score,
  });
}

/// @nodoc
class __$$SessionSkillResultImplCopyWithImpl<$Res>
    extends _$SessionSkillResultCopyWithImpl<$Res, _$SessionSkillResultImpl>
    implements _$$SessionSkillResultImplCopyWith<$Res> {
  __$$SessionSkillResultImplCopyWithImpl(
    _$SessionSkillResultImpl _value,
    $Res Function(_$SessionSkillResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionSkillResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillName = null,
    Object? category = freezed,
    Object? status = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _$SessionSkillResultImpl(
        skillName: null == skillName
            ? _value.skillName
            : skillName // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionSkillResultImpl implements _SessionSkillResult {
  const _$SessionSkillResultImpl({
    @JsonKey(name: 'skill_name') required this.skillName,
    this.category,
    this.status,
    this.score,
  });

  factory _$SessionSkillResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionSkillResultImplFromJson(json);

  @override
  @JsonKey(name: 'skill_name')
  final String skillName;
  @override
  final String? category;
  @override
  final String? status;
  @override
  final int? score;

  @override
  String toString() {
    return 'SessionSkillResult(skillName: $skillName, category: $category, status: $status, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSkillResultImpl &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, skillName, category, status, score);

  /// Create a copy of SessionSkillResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSkillResultImplCopyWith<_$SessionSkillResultImpl> get copyWith =>
      __$$SessionSkillResultImplCopyWithImpl<_$SessionSkillResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionSkillResultImplToJson(this);
  }
}

abstract class _SessionSkillResult implements SessionSkillResult {
  const factory _SessionSkillResult({
    @JsonKey(name: 'skill_name') required final String skillName,
    final String? category,
    final String? status,
    final int? score,
  }) = _$SessionSkillResultImpl;

  factory _SessionSkillResult.fromJson(Map<String, dynamic> json) =
      _$SessionSkillResultImpl.fromJson;

  @override
  @JsonKey(name: 'skill_name')
  String get skillName;
  @override
  String? get category;
  @override
  String? get status;
  @override
  int? get score;

  /// Create a copy of SessionSkillResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSkillResultImplCopyWith<_$SessionSkillResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssignedCoach _$AssignedCoachFromJson(Map<String, dynamic> json) {
  return _AssignedCoach.fromJson(json);
}

/// @nodoc
mixin _$AssignedCoach {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this AssignedCoach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignedCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignedCoachCopyWith<AssignedCoach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedCoachCopyWith<$Res> {
  factory $AssignedCoachCopyWith(
    AssignedCoach value,
    $Res Function(AssignedCoach) then,
  ) = _$AssignedCoachCopyWithImpl<$Res, AssignedCoach>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String? name});
}

/// @nodoc
class _$AssignedCoachCopyWithImpl<$Res, $Val extends AssignedCoach>
    implements $AssignedCoachCopyWith<$Res> {
  _$AssignedCoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignedCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssignedCoachImplCopyWith<$Res>
    implements $AssignedCoachCopyWith<$Res> {
  factory _$$AssignedCoachImplCopyWith(
    _$AssignedCoachImpl value,
    $Res Function(_$AssignedCoachImpl) then,
  ) = __$$AssignedCoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String? name});
}

/// @nodoc
class __$$AssignedCoachImplCopyWithImpl<$Res>
    extends _$AssignedCoachCopyWithImpl<$Res, _$AssignedCoachImpl>
    implements _$$AssignedCoachImplCopyWith<$Res> {
  __$$AssignedCoachImplCopyWithImpl(
    _$AssignedCoachImpl _value,
    $Res Function(_$AssignedCoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignedCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = freezed}) {
    return _then(
      _$AssignedCoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignedCoachImpl implements _AssignedCoach {
  const _$AssignedCoachImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.name,
  });

  factory _$AssignedCoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedCoachImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String? name;

  @override
  String toString() {
    return 'AssignedCoach(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedCoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of AssignedCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedCoachImplCopyWith<_$AssignedCoachImpl> get copyWith =>
      __$$AssignedCoachImplCopyWithImpl<_$AssignedCoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedCoachImplToJson(this);
  }
}

abstract class _AssignedCoach implements AssignedCoach {
  const factory _AssignedCoach({
    @JsonKey(fromJson: idFromJson) required final String id,
    final String? name,
  }) = _$AssignedCoachImpl;

  factory _AssignedCoach.fromJson(Map<String, dynamic> json) =
      _$AssignedCoachImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String? get name;

  /// Create a copy of AssignedCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedCoachImplCopyWith<_$AssignedCoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionPayment _$SessionPaymentFromJson(Map<String, dynamic> json) {
  return _SessionPayment.fromJson(json);
}

/// @nodoc
mixin _$SessionPayment {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid')
  int get amountPaid => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
  String? get purchaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_proof_url')
  String? get paymentProofUrl => throw _privateConstructorUsedError;

  /// Serializes this SessionPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionPaymentCopyWith<SessionPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionPaymentCopyWith<$Res> {
  factory $SessionPaymentCopyWith(
    SessionPayment value,
    $Res Function(SessionPayment) then,
  ) = _$SessionPaymentCopyWithImpl<$Res, SessionPayment>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    String currency,
    @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
    String? purchaseId,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  });
}

/// @nodoc
class _$SessionPaymentCopyWithImpl<$Res, $Val extends SessionPayment>
    implements $SessionPaymentCopyWith<$Res> {
  _$SessionPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? amountPaid = null,
    Object? currency = null,
    Object? purchaseId = freezed,
    Object? paidAt = freezed,
    Object? paymentProofUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            purchaseId: freezed == purchaseId
                ? _value.purchaseId
                : purchaseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paymentProofUrl: freezed == paymentProofUrl
                ? _value.paymentProofUrl
                : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionPaymentImplCopyWith<$Res>
    implements $SessionPaymentCopyWith<$Res> {
  factory _$$SessionPaymentImplCopyWith(
    _$SessionPaymentImpl value,
    $Res Function(_$SessionPaymentImpl) then,
  ) = __$$SessionPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    String currency,
    @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
    String? purchaseId,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  });
}

/// @nodoc
class __$$SessionPaymentImplCopyWithImpl<$Res>
    extends _$SessionPaymentCopyWithImpl<$Res, _$SessionPaymentImpl>
    implements _$$SessionPaymentImplCopyWith<$Res> {
  __$$SessionPaymentImplCopyWithImpl(
    _$SessionPaymentImpl _value,
    $Res Function(_$SessionPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? amountPaid = null,
    Object? currency = null,
    Object? purchaseId = freezed,
    Object? paidAt = freezed,
    Object? paymentProofUrl = freezed,
  }) {
    return _then(
      _$SessionPaymentImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        purchaseId: freezed == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paymentProofUrl: freezed == paymentProofUrl
            ? _value.paymentProofUrl
            : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionPaymentImpl implements _SessionPayment {
  const _$SessionPaymentImpl({
    this.status,
    @JsonKey(name: 'amount_paid') this.amountPaid = 0,
    this.currency = 'IDR',
    @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson) this.purchaseId,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'payment_proof_url') this.paymentProofUrl,
  });

  factory _$SessionPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionPaymentImplFromJson(json);

  @override
  final String? status;
  @override
  @JsonKey(name: 'amount_paid')
  final int amountPaid;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
  final String? purchaseId;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'payment_proof_url')
  final String? paymentProofUrl;

  @override
  String toString() {
    return 'SessionPayment(status: $status, amountPaid: $amountPaid, currency: $currency, purchaseId: $purchaseId, paidAt: $paidAt, paymentProofUrl: $paymentProofUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionPaymentImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.paymentProofUrl, paymentProofUrl) ||
                other.paymentProofUrl == paymentProofUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    amountPaid,
    currency,
    purchaseId,
    paidAt,
    paymentProofUrl,
  );

  /// Create a copy of SessionPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionPaymentImplCopyWith<_$SessionPaymentImpl> get copyWith =>
      __$$SessionPaymentImplCopyWithImpl<_$SessionPaymentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionPaymentImplToJson(this);
  }
}

abstract class _SessionPayment implements SessionPayment {
  const factory _SessionPayment({
    final String? status,
    @JsonKey(name: 'amount_paid') final int amountPaid,
    final String currency,
    @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
    final String? purchaseId,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
    @JsonKey(name: 'payment_proof_url') final String? paymentProofUrl,
  }) = _$SessionPaymentImpl;

  factory _SessionPayment.fromJson(Map<String, dynamic> json) =
      _$SessionPaymentImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'amount_paid')
  int get amountPaid;
  @override
  String get currency;
  @override
  @JsonKey(name: 'purchase_id', fromJson: nullableIdFromJson)
  String? get purchaseId;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'payment_proof_url')
  String? get paymentProofUrl;

  /// Create a copy of SessionPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionPaymentImplCopyWith<_$SessionPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminStudentDetail _$AdminStudentDetailFromJson(Map<String, dynamic> json) {
  return _AdminStudentDetail.fromJson(json);
}

/// @nodoc
mixin _$AdminStudentDetail {
  StudentProfileSummary get student => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'financial_stats')
  FinancialStats get financialStats => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_history')
  List<PaymentHistoryItem> get paymentHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this AdminStudentDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminStudentDetailCopyWith<AdminStudentDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStudentDetailCopyWith<$Res> {
  factory $AdminStudentDetailCopyWith(
    AdminStudentDetail value,
    $Res Function(AdminStudentDetail) then,
  ) = _$AdminStudentDetailCopyWithImpl<$Res, AdminStudentDetail>;
  @useResult
  $Res call({
    StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'financial_stats') FinancialStats financialStats,
    @JsonKey(name: 'payment_history') List<PaymentHistoryItem> paymentHistory,
    @JsonKey(name: 'session_history') List<SessionHistoryItem> sessionHistory,
  });

  $StudentProfileSummaryCopyWith<$Res> get student;
  $FinancialStatsCopyWith<$Res> get financialStats;
}

/// @nodoc
class _$AdminStudentDetailCopyWithImpl<$Res, $Val extends AdminStudentDetail>
    implements $AdminStudentDetailCopyWith<$Res> {
  _$AdminStudentDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? student = null,
    Object? recentTrend = null,
    Object? skillBreakdown = null,
    Object? financialStats = null,
    Object? paymentHistory = null,
    Object? sessionHistory = null,
  }) {
    return _then(
      _value.copyWith(
            student: null == student
                ? _value.student
                : student // ignore: cast_nullable_to_non_nullable
                      as StudentProfileSummary,
            recentTrend: null == recentTrend
                ? _value.recentTrend
                : recentTrend // ignore: cast_nullable_to_non_nullable
                      as List<AssessmentTrendPoint>,
            skillBreakdown: null == skillBreakdown
                ? _value.skillBreakdown
                : skillBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<SkillCategoryProgress>,
            financialStats: null == financialStats
                ? _value.financialStats
                : financialStats // ignore: cast_nullable_to_non_nullable
                      as FinancialStats,
            paymentHistory: null == paymentHistory
                ? _value.paymentHistory
                : paymentHistory // ignore: cast_nullable_to_non_nullable
                      as List<PaymentHistoryItem>,
            sessionHistory: null == sessionHistory
                ? _value.sessionHistory
                : sessionHistory // ignore: cast_nullable_to_non_nullable
                      as List<SessionHistoryItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentProfileSummaryCopyWith<$Res> get student {
    return $StudentProfileSummaryCopyWith<$Res>(_value.student, (value) {
      return _then(_value.copyWith(student: value) as $Val);
    });
  }

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialStatsCopyWith<$Res> get financialStats {
    return $FinancialStatsCopyWith<$Res>(_value.financialStats, (value) {
      return _then(_value.copyWith(financialStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdminStudentDetailImplCopyWith<$Res>
    implements $AdminStudentDetailCopyWith<$Res> {
  factory _$$AdminStudentDetailImplCopyWith(
    _$AdminStudentDetailImpl value,
    $Res Function(_$AdminStudentDetailImpl) then,
  ) = __$$AdminStudentDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'financial_stats') FinancialStats financialStats,
    @JsonKey(name: 'payment_history') List<PaymentHistoryItem> paymentHistory,
    @JsonKey(name: 'session_history') List<SessionHistoryItem> sessionHistory,
  });

  @override
  $StudentProfileSummaryCopyWith<$Res> get student;
  @override
  $FinancialStatsCopyWith<$Res> get financialStats;
}

/// @nodoc
class __$$AdminStudentDetailImplCopyWithImpl<$Res>
    extends _$AdminStudentDetailCopyWithImpl<$Res, _$AdminStudentDetailImpl>
    implements _$$AdminStudentDetailImplCopyWith<$Res> {
  __$$AdminStudentDetailImplCopyWithImpl(
    _$AdminStudentDetailImpl _value,
    $Res Function(_$AdminStudentDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? student = null,
    Object? recentTrend = null,
    Object? skillBreakdown = null,
    Object? financialStats = null,
    Object? paymentHistory = null,
    Object? sessionHistory = null,
  }) {
    return _then(
      _$AdminStudentDetailImpl(
        student: null == student
            ? _value.student
            : student // ignore: cast_nullable_to_non_nullable
                  as StudentProfileSummary,
        recentTrend: null == recentTrend
            ? _value._recentTrend
            : recentTrend // ignore: cast_nullable_to_non_nullable
                  as List<AssessmentTrendPoint>,
        skillBreakdown: null == skillBreakdown
            ? _value._skillBreakdown
            : skillBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<SkillCategoryProgress>,
        financialStats: null == financialStats
            ? _value.financialStats
            : financialStats // ignore: cast_nullable_to_non_nullable
                  as FinancialStats,
        paymentHistory: null == paymentHistory
            ? _value._paymentHistory
            : paymentHistory // ignore: cast_nullable_to_non_nullable
                  as List<PaymentHistoryItem>,
        sessionHistory: null == sessionHistory
            ? _value._sessionHistory
            : sessionHistory // ignore: cast_nullable_to_non_nullable
                  as List<SessionHistoryItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminStudentDetailImpl implements _AdminStudentDetail {
  const _$AdminStudentDetailImpl({
    required this.student,
    @JsonKey(name: 'recent_trend')
    final List<AssessmentTrendPoint> recentTrend =
        const <AssessmentTrendPoint>[],
    @JsonKey(name: 'skill_breakdown')
    final List<SkillCategoryProgress> skillBreakdown =
        const <SkillCategoryProgress>[],
    @JsonKey(name: 'financial_stats')
    this.financialStats = const FinancialStats(),
    @JsonKey(name: 'payment_history')
    final List<PaymentHistoryItem> paymentHistory =
        const <PaymentHistoryItem>[],
    @JsonKey(name: 'session_history')
    final List<SessionHistoryItem> sessionHistory =
        const <SessionHistoryItem>[],
  }) : _recentTrend = recentTrend,
       _skillBreakdown = skillBreakdown,
       _paymentHistory = paymentHistory,
       _sessionHistory = sessionHistory;

  factory _$AdminStudentDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminStudentDetailImplFromJson(json);

  @override
  final StudentProfileSummary student;
  final List<AssessmentTrendPoint> _recentTrend;
  @override
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend {
    if (_recentTrend is EqualUnmodifiableListView) return _recentTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTrend);
  }

  final List<SkillCategoryProgress> _skillBreakdown;
  @override
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown {
    if (_skillBreakdown is EqualUnmodifiableListView) return _skillBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillBreakdown);
  }

  @override
  @JsonKey(name: 'financial_stats')
  final FinancialStats financialStats;
  final List<PaymentHistoryItem> _paymentHistory;
  @override
  @JsonKey(name: 'payment_history')
  List<PaymentHistoryItem> get paymentHistory {
    if (_paymentHistory is EqualUnmodifiableListView) return _paymentHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentHistory);
  }

  final List<SessionHistoryItem> _sessionHistory;
  @override
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory {
    if (_sessionHistory is EqualUnmodifiableListView) return _sessionHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionHistory);
  }

  @override
  String toString() {
    return 'AdminStudentDetail(student: $student, recentTrend: $recentTrend, skillBreakdown: $skillBreakdown, financialStats: $financialStats, paymentHistory: $paymentHistory, sessionHistory: $sessionHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminStudentDetailImpl &&
            (identical(other.student, student) || other.student == student) &&
            const DeepCollectionEquality().equals(
              other._recentTrend,
              _recentTrend,
            ) &&
            const DeepCollectionEquality().equals(
              other._skillBreakdown,
              _skillBreakdown,
            ) &&
            (identical(other.financialStats, financialStats) ||
                other.financialStats == financialStats) &&
            const DeepCollectionEquality().equals(
              other._paymentHistory,
              _paymentHistory,
            ) &&
            const DeepCollectionEquality().equals(
              other._sessionHistory,
              _sessionHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    student,
    const DeepCollectionEquality().hash(_recentTrend),
    const DeepCollectionEquality().hash(_skillBreakdown),
    financialStats,
    const DeepCollectionEquality().hash(_paymentHistory),
    const DeepCollectionEquality().hash(_sessionHistory),
  );

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminStudentDetailImplCopyWith<_$AdminStudentDetailImpl> get copyWith =>
      __$$AdminStudentDetailImplCopyWithImpl<_$AdminStudentDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminStudentDetailImplToJson(this);
  }
}

abstract class _AdminStudentDetail implements AdminStudentDetail {
  const factory _AdminStudentDetail({
    required final StudentProfileSummary student,
    @JsonKey(name: 'recent_trend') final List<AssessmentTrendPoint> recentTrend,
    @JsonKey(name: 'skill_breakdown')
    final List<SkillCategoryProgress> skillBreakdown,
    @JsonKey(name: 'financial_stats') final FinancialStats financialStats,
    @JsonKey(name: 'payment_history')
    final List<PaymentHistoryItem> paymentHistory,
    @JsonKey(name: 'session_history')
    final List<SessionHistoryItem> sessionHistory,
  }) = _$AdminStudentDetailImpl;

  factory _AdminStudentDetail.fromJson(Map<String, dynamic> json) =
      _$AdminStudentDetailImpl.fromJson;

  @override
  StudentProfileSummary get student;
  @override
  @JsonKey(name: 'recent_trend')
  List<AssessmentTrendPoint> get recentTrend;
  @override
  @JsonKey(name: 'skill_breakdown')
  List<SkillCategoryProgress> get skillBreakdown;
  @override
  @JsonKey(name: 'financial_stats')
  FinancialStats get financialStats;
  @override
  @JsonKey(name: 'payment_history')
  List<PaymentHistoryItem> get paymentHistory;
  @override
  @JsonKey(name: 'session_history')
  List<SessionHistoryItem> get sessionHistory;

  /// Create a copy of AdminStudentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminStudentDetailImplCopyWith<_$AdminStudentDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialStats _$FinancialStatsFromJson(Map<String, dynamic> json) {
  return _FinancialStats.fromJson(json);
}

/// @nodoc
mixin _$FinancialStats {
  @JsonKey(name: 'paid_this_month')
  int get paidThisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_amount')
  int get outstandingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_transactions')
  int get totalTransactions => throw _privateConstructorUsedError;

  /// Serializes this FinancialStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialStatsCopyWith<FinancialStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialStatsCopyWith<$Res> {
  factory $FinancialStatsCopyWith(
    FinancialStats value,
    $Res Function(FinancialStats) then,
  ) = _$FinancialStatsCopyWithImpl<$Res, FinancialStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'paid_this_month') int paidThisMonth,
    @JsonKey(name: 'outstanding_amount') int outstandingAmount,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
    @JsonKey(name: 'total_transactions') int totalTransactions,
  });
}

/// @nodoc
class _$FinancialStatsCopyWithImpl<$Res, $Val extends FinancialStats>
    implements $FinancialStatsCopyWith<$Res> {
  _$FinancialStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidThisMonth = null,
    Object? outstandingAmount = null,
    Object? outstandingCount = null,
    Object? totalTransactions = null,
  }) {
    return _then(
      _value.copyWith(
            paidThisMonth: null == paidThisMonth
                ? _value.paidThisMonth
                : paidThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingAmount: null == outstandingAmount
                ? _value.outstandingAmount
                : outstandingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingCount: null == outstandingCount
                ? _value.outstandingCount
                : outstandingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTransactions: null == totalTransactions
                ? _value.totalTransactions
                : totalTransactions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialStatsImplCopyWith<$Res>
    implements $FinancialStatsCopyWith<$Res> {
  factory _$$FinancialStatsImplCopyWith(
    _$FinancialStatsImpl value,
    $Res Function(_$FinancialStatsImpl) then,
  ) = __$$FinancialStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'paid_this_month') int paidThisMonth,
    @JsonKey(name: 'outstanding_amount') int outstandingAmount,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
    @JsonKey(name: 'total_transactions') int totalTransactions,
  });
}

/// @nodoc
class __$$FinancialStatsImplCopyWithImpl<$Res>
    extends _$FinancialStatsCopyWithImpl<$Res, _$FinancialStatsImpl>
    implements _$$FinancialStatsImplCopyWith<$Res> {
  __$$FinancialStatsImplCopyWithImpl(
    _$FinancialStatsImpl _value,
    $Res Function(_$FinancialStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidThisMonth = null,
    Object? outstandingAmount = null,
    Object? outstandingCount = null,
    Object? totalTransactions = null,
  }) {
    return _then(
      _$FinancialStatsImpl(
        paidThisMonth: null == paidThisMonth
            ? _value.paidThisMonth
            : paidThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingAmount: null == outstandingAmount
            ? _value.outstandingAmount
            : outstandingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingCount: null == outstandingCount
            ? _value.outstandingCount
            : outstandingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTransactions: null == totalTransactions
            ? _value.totalTransactions
            : totalTransactions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialStatsImpl implements _FinancialStats {
  const _$FinancialStatsImpl({
    @JsonKey(name: 'paid_this_month') this.paidThisMonth = 0,
    @JsonKey(name: 'outstanding_amount') this.outstandingAmount = 0,
    @JsonKey(name: 'outstanding_count') this.outstandingCount = 0,
    @JsonKey(name: 'total_transactions') this.totalTransactions = 0,
  });

  factory _$FinancialStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialStatsImplFromJson(json);

  @override
  @JsonKey(name: 'paid_this_month')
  final int paidThisMonth;
  @override
  @JsonKey(name: 'outstanding_amount')
  final int outstandingAmount;
  @override
  @JsonKey(name: 'outstanding_count')
  final int outstandingCount;
  @override
  @JsonKey(name: 'total_transactions')
  final int totalTransactions;

  @override
  String toString() {
    return 'FinancialStats(paidThisMonth: $paidThisMonth, outstandingAmount: $outstandingAmount, outstandingCount: $outstandingCount, totalTransactions: $totalTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialStatsImpl &&
            (identical(other.paidThisMonth, paidThisMonth) ||
                other.paidThisMonth == paidThisMonth) &&
            (identical(other.outstandingAmount, outstandingAmount) ||
                other.outstandingAmount == outstandingAmount) &&
            (identical(other.outstandingCount, outstandingCount) ||
                other.outstandingCount == outstandingCount) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paidThisMonth,
    outstandingAmount,
    outstandingCount,
    totalTransactions,
  );

  /// Create a copy of FinancialStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialStatsImplCopyWith<_$FinancialStatsImpl> get copyWith =>
      __$$FinancialStatsImplCopyWithImpl<_$FinancialStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialStatsImplToJson(this);
  }
}

abstract class _FinancialStats implements FinancialStats {
  const factory _FinancialStats({
    @JsonKey(name: 'paid_this_month') final int paidThisMonth,
    @JsonKey(name: 'outstanding_amount') final int outstandingAmount,
    @JsonKey(name: 'outstanding_count') final int outstandingCount,
    @JsonKey(name: 'total_transactions') final int totalTransactions,
  }) = _$FinancialStatsImpl;

  factory _FinancialStats.fromJson(Map<String, dynamic> json) =
      _$FinancialStatsImpl.fromJson;

  @override
  @JsonKey(name: 'paid_this_month')
  int get paidThisMonth;
  @override
  @JsonKey(name: 'outstanding_amount')
  int get outstandingAmount;
  @override
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount;
  @override
  @JsonKey(name: 'total_transactions')
  int get totalTransactions;

  /// Create a copy of FinancialStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialStatsImplCopyWith<_$FinancialStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentHistoryItem _$PaymentHistoryItemFromJson(Map<String, dynamic> json) {
  return _PaymentHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$PaymentHistoryItem {
  @JsonKey(name: 'purchase_id', fromJson: idFromJson)
  String get purchaseId => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_proof_url')
  String? get paymentProofUrl => throw _privateConstructorUsedError;

  /// Serializes this PaymentHistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentHistoryItemCopyWith<PaymentHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentHistoryItemCopyWith<$Res> {
  factory $PaymentHistoryItemCopyWith(
    PaymentHistoryItem value,
    $Res Function(PaymentHistoryItem) then,
  ) = _$PaymentHistoryItemCopyWithImpl<$Res, PaymentHistoryItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id', fromJson: idFromJson) String purchaseId,
    DateTime? date,
    int amount,
    String currency,
    String? description,
    String? status,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  });
}

/// @nodoc
class _$PaymentHistoryItemCopyWithImpl<$Res, $Val extends PaymentHistoryItem>
    implements $PaymentHistoryItemCopyWith<$Res> {
  _$PaymentHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? date = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? status = freezed,
    Object? paymentProofUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            purchaseId: null == purchaseId
                ? _value.purchaseId
                : purchaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentProofUrl: freezed == paymentProofUrl
                ? _value.paymentProofUrl
                : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentHistoryItemImplCopyWith<$Res>
    implements $PaymentHistoryItemCopyWith<$Res> {
  factory _$$PaymentHistoryItemImplCopyWith(
    _$PaymentHistoryItemImpl value,
    $Res Function(_$PaymentHistoryItemImpl) then,
  ) = __$$PaymentHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id', fromJson: idFromJson) String purchaseId,
    DateTime? date,
    int amount,
    String currency,
    String? description,
    String? status,
    @JsonKey(name: 'payment_proof_url') String? paymentProofUrl,
  });
}

/// @nodoc
class __$$PaymentHistoryItemImplCopyWithImpl<$Res>
    extends _$PaymentHistoryItemCopyWithImpl<$Res, _$PaymentHistoryItemImpl>
    implements _$$PaymentHistoryItemImplCopyWith<$Res> {
  __$$PaymentHistoryItemImplCopyWithImpl(
    _$PaymentHistoryItemImpl _value,
    $Res Function(_$PaymentHistoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? date = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? status = freezed,
    Object? paymentProofUrl = freezed,
  }) {
    return _then(
      _$PaymentHistoryItemImpl(
        purchaseId: null == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentProofUrl: freezed == paymentProofUrl
            ? _value.paymentProofUrl
            : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentHistoryItemImpl implements _PaymentHistoryItem {
  const _$PaymentHistoryItemImpl({
    @JsonKey(name: 'purchase_id', fromJson: idFromJson)
    required this.purchaseId,
    this.date,
    this.amount = 0,
    this.currency = 'IDR',
    this.description,
    this.status,
    @JsonKey(name: 'payment_proof_url') this.paymentProofUrl,
  });

  factory _$PaymentHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentHistoryItemImplFromJson(json);

  @override
  @JsonKey(name: 'purchase_id', fromJson: idFromJson)
  final String purchaseId;
  @override
  final DateTime? date;
  @override
  @JsonKey()
  final int amount;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? description;
  @override
  final String? status;
  @override
  @JsonKey(name: 'payment_proof_url')
  final String? paymentProofUrl;

  @override
  String toString() {
    return 'PaymentHistoryItem(purchaseId: $purchaseId, date: $date, amount: $amount, currency: $currency, description: $description, status: $status, paymentProofUrl: $paymentProofUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentHistoryItemImpl &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentProofUrl, paymentProofUrl) ||
                other.paymentProofUrl == paymentProofUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    purchaseId,
    date,
    amount,
    currency,
    description,
    status,
    paymentProofUrl,
  );

  /// Create a copy of PaymentHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentHistoryItemImplCopyWith<_$PaymentHistoryItemImpl> get copyWith =>
      __$$PaymentHistoryItemImplCopyWithImpl<_$PaymentHistoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentHistoryItemImplToJson(this);
  }
}

abstract class _PaymentHistoryItem implements PaymentHistoryItem {
  const factory _PaymentHistoryItem({
    @JsonKey(name: 'purchase_id', fromJson: idFromJson)
    required final String purchaseId,
    final DateTime? date,
    final int amount,
    final String currency,
    final String? description,
    final String? status,
    @JsonKey(name: 'payment_proof_url') final String? paymentProofUrl,
  }) = _$PaymentHistoryItemImpl;

  factory _PaymentHistoryItem.fromJson(Map<String, dynamic> json) =
      _$PaymentHistoryItemImpl.fromJson;

  @override
  @JsonKey(name: 'purchase_id', fromJson: idFromJson)
  String get purchaseId;
  @override
  DateTime? get date;
  @override
  int get amount;
  @override
  String get currency;
  @override
  String? get description;
  @override
  String? get status;
  @override
  @JsonKey(name: 'payment_proof_url')
  String? get paymentProofUrl;

  /// Create a copy of PaymentHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentHistoryItemImplCopyWith<_$PaymentHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
