// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachStudentRosterItem _$CoachStudentRosterItemFromJson(
  Map<String, dynamic> json,
) {
  return _CoachStudentRosterItem.fromJson(json);
}

/// @nodoc
mixin _$CoachStudentRosterItem {
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;
  StudentEnrollmentSummary? get enrollment =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sessions_with_coach')
  int get totalSessionsWithCoach => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_progress')
  LatestProgress? get latestProgress => throw _privateConstructorUsedError;

  /// Serializes this CoachStudentRosterItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachStudentRosterItemCopyWith<CoachStudentRosterItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachStudentRosterItemCopyWith<$Res> {
  factory $CoachStudentRosterItemCopyWith(
    CoachStudentRosterItem value,
    $Res Function(CoachStudentRosterItem) then,
  ) = _$CoachStudentRosterItemCopyWithImpl<$Res, CoachStudentRosterItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'full_name') String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions_with_coach') int totalSessionsWithCoach,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
  });

  $StudentEnrollmentSummaryCopyWith<$Res>? get enrollment;
  $LatestProgressCopyWith<$Res>? get latestProgress;
}

/// @nodoc
class _$CoachStudentRosterItemCopyWithImpl<
  $Res,
  $Val extends CoachStudentRosterItem
>
    implements $CoachStudentRosterItemCopyWith<$Res> {
  _$CoachStudentRosterItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = null,
    Object? fullName = null,
    Object? age = freezed,
    Object? photoUrls = freezed,
    Object? enrollment = freezed,
    Object? lastSessionAt = freezed,
    Object? totalSessionsWithCoach = null,
    Object? attendanceRate = null,
    Object? latestProgress = freezed,
  }) {
    return _then(
      _value.copyWith(
            studentProfileId: null == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            enrollment: freezed == enrollment
                ? _value.enrollment
                : enrollment // ignore: cast_nullable_to_non_nullable
                      as StudentEnrollmentSummary?,
            lastSessionAt: freezed == lastSessionAt
                ? _value.lastSessionAt
                : lastSessionAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalSessionsWithCoach: null == totalSessionsWithCoach
                ? _value.totalSessionsWithCoach
                : totalSessionsWithCoach // ignore: cast_nullable_to_non_nullable
                      as int,
            attendanceRate: null == attendanceRate
                ? _value.attendanceRate
                : attendanceRate // ignore: cast_nullable_to_non_nullable
                      as double,
            latestProgress: freezed == latestProgress
                ? _value.latestProgress
                : latestProgress // ignore: cast_nullable_to_non_nullable
                      as LatestProgress?,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentEnrollmentSummaryCopyWith<$Res>? get enrollment {
    if (_value.enrollment == null) {
      return null;
    }

    return $StudentEnrollmentSummaryCopyWith<$Res>(_value.enrollment!, (value) {
      return _then(_value.copyWith(enrollment: value) as $Val);
    });
  }

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LatestProgressCopyWith<$Res>? get latestProgress {
    if (_value.latestProgress == null) {
      return null;
    }

    return $LatestProgressCopyWith<$Res>(_value.latestProgress!, (value) {
      return _then(_value.copyWith(latestProgress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachStudentRosterItemImplCopyWith<$Res>
    implements $CoachStudentRosterItemCopyWith<$Res> {
  factory _$$CoachStudentRosterItemImplCopyWith(
    _$CoachStudentRosterItemImpl value,
    $Res Function(_$CoachStudentRosterItemImpl) then,
  ) = __$$CoachStudentRosterItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'full_name') String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions_with_coach') int totalSessionsWithCoach,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
  });

  @override
  $StudentEnrollmentSummaryCopyWith<$Res>? get enrollment;
  @override
  $LatestProgressCopyWith<$Res>? get latestProgress;
}

/// @nodoc
class __$$CoachStudentRosterItemImplCopyWithImpl<$Res>
    extends
        _$CoachStudentRosterItemCopyWithImpl<$Res, _$CoachStudentRosterItemImpl>
    implements _$$CoachStudentRosterItemImplCopyWith<$Res> {
  __$$CoachStudentRosterItemImplCopyWithImpl(
    _$CoachStudentRosterItemImpl _value,
    $Res Function(_$CoachStudentRosterItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = null,
    Object? fullName = null,
    Object? age = freezed,
    Object? photoUrls = freezed,
    Object? enrollment = freezed,
    Object? lastSessionAt = freezed,
    Object? totalSessionsWithCoach = null,
    Object? attendanceRate = null,
    Object? latestProgress = freezed,
  }) {
    return _then(
      _$CoachStudentRosterItemImpl(
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        enrollment: freezed == enrollment
            ? _value.enrollment
            : enrollment // ignore: cast_nullable_to_non_nullable
                  as StudentEnrollmentSummary?,
        lastSessionAt: freezed == lastSessionAt
            ? _value.lastSessionAt
            : lastSessionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalSessionsWithCoach: null == totalSessionsWithCoach
            ? _value.totalSessionsWithCoach
            : totalSessionsWithCoach // ignore: cast_nullable_to_non_nullable
                  as int,
        attendanceRate: null == attendanceRate
            ? _value.attendanceRate
            : attendanceRate // ignore: cast_nullable_to_non_nullable
                  as double,
        latestProgress: freezed == latestProgress
            ? _value.latestProgress
            : latestProgress // ignore: cast_nullable_to_non_nullable
                  as LatestProgress?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachStudentRosterItemImpl implements _CoachStudentRosterItem {
  const _$CoachStudentRosterItemImpl({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'full_name') required this.fullName,
    this.age,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    this.enrollment,
    @JsonKey(name: 'last_session_at') this.lastSessionAt,
    @JsonKey(name: 'total_sessions_with_coach') this.totalSessionsWithCoach = 0,
    @JsonKey(name: 'attendance_rate') this.attendanceRate = 0.0,
    @JsonKey(name: 'latest_progress') this.latestProgress,
  }) : _photoUrls = photoUrls;

  factory _$CoachStudentRosterItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachStudentRosterItemImplFromJson(json);

  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final int? age;
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
  final StudentEnrollmentSummary? enrollment;
  @override
  @JsonKey(name: 'last_session_at')
  final DateTime? lastSessionAt;
  @override
  @JsonKey(name: 'total_sessions_with_coach')
  final int totalSessionsWithCoach;
  @override
  @JsonKey(name: 'attendance_rate')
  final double attendanceRate;
  @override
  @JsonKey(name: 'latest_progress')
  final LatestProgress? latestProgress;

  @override
  String toString() {
    return 'CoachStudentRosterItem(studentProfileId: $studentProfileId, fullName: $fullName, age: $age, photoUrls: $photoUrls, enrollment: $enrollment, lastSessionAt: $lastSessionAt, totalSessionsWithCoach: $totalSessionsWithCoach, attendanceRate: $attendanceRate, latestProgress: $latestProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachStudentRosterItemImpl &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.age, age) || other.age == age) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            (identical(other.enrollment, enrollment) ||
                other.enrollment == enrollment) &&
            (identical(other.lastSessionAt, lastSessionAt) ||
                other.lastSessionAt == lastSessionAt) &&
            (identical(other.totalSessionsWithCoach, totalSessionsWithCoach) ||
                other.totalSessionsWithCoach == totalSessionsWithCoach) &&
            (identical(other.attendanceRate, attendanceRate) ||
                other.attendanceRate == attendanceRate) &&
            (identical(other.latestProgress, latestProgress) ||
                other.latestProgress == latestProgress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentProfileId,
    fullName,
    age,
    const DeepCollectionEquality().hash(_photoUrls),
    enrollment,
    lastSessionAt,
    totalSessionsWithCoach,
    attendanceRate,
    latestProgress,
  );

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachStudentRosterItemImplCopyWith<_$CoachStudentRosterItemImpl>
  get copyWith =>
      __$$CoachStudentRosterItemImplCopyWithImpl<_$CoachStudentRosterItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachStudentRosterItemImplToJson(this);
  }
}

abstract class _CoachStudentRosterItem implements CoachStudentRosterItem {
  const factory _CoachStudentRosterItem({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'full_name') required final String fullName,
    final int? age,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    final StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'last_session_at') final DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions_with_coach')
    final int totalSessionsWithCoach,
    @JsonKey(name: 'attendance_rate') final double attendanceRate,
    @JsonKey(name: 'latest_progress') final LatestProgress? latestProgress,
  }) = _$CoachStudentRosterItemImpl;

  factory _CoachStudentRosterItem.fromJson(Map<String, dynamic> json) =
      _$CoachStudentRosterItemImpl.fromJson;

  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  int? get age;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;
  @override
  StudentEnrollmentSummary? get enrollment;
  @override
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt;
  @override
  @JsonKey(name: 'total_sessions_with_coach')
  int get totalSessionsWithCoach;
  @override
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate;
  @override
  @JsonKey(name: 'latest_progress')
  LatestProgress? get latestProgress;

  /// Create a copy of CoachStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachStudentRosterItemImplCopyWith<_$CoachStudentRosterItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StudentEnrollmentSummary _$StudentEnrollmentSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _StudentEnrollmentSummary.fromJson(json);
}

/// @nodoc
mixin _$StudentEnrollmentSummary {
  @JsonKey(name: 'program_name')
  String? get programName => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_name')
  String? get levelName => throw _privateConstructorUsedError;

  /// Serializes this StudentEnrollmentSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentEnrollmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentEnrollmentSummaryCopyWith<StudentEnrollmentSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentEnrollmentSummaryCopyWith<$Res> {
  factory $StudentEnrollmentSummaryCopyWith(
    StudentEnrollmentSummary value,
    $Res Function(StudentEnrollmentSummary) then,
  ) = _$StudentEnrollmentSummaryCopyWithImpl<$Res, StudentEnrollmentSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
  });
}

/// @nodoc
class _$StudentEnrollmentSummaryCopyWithImpl<
  $Res,
  $Val extends StudentEnrollmentSummary
>
    implements $StudentEnrollmentSummaryCopyWith<$Res> {
  _$StudentEnrollmentSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentEnrollmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? programName = freezed, Object? levelName = freezed}) {
    return _then(
      _value.copyWith(
            programName: freezed == programName
                ? _value.programName
                : programName // ignore: cast_nullable_to_non_nullable
                      as String?,
            levelName: freezed == levelName
                ? _value.levelName
                : levelName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentEnrollmentSummaryImplCopyWith<$Res>
    implements $StudentEnrollmentSummaryCopyWith<$Res> {
  factory _$$StudentEnrollmentSummaryImplCopyWith(
    _$StudentEnrollmentSummaryImpl value,
    $Res Function(_$StudentEnrollmentSummaryImpl) then,
  ) = __$$StudentEnrollmentSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
  });
}

/// @nodoc
class __$$StudentEnrollmentSummaryImplCopyWithImpl<$Res>
    extends
        _$StudentEnrollmentSummaryCopyWithImpl<
          $Res,
          _$StudentEnrollmentSummaryImpl
        >
    implements _$$StudentEnrollmentSummaryImplCopyWith<$Res> {
  __$$StudentEnrollmentSummaryImplCopyWithImpl(
    _$StudentEnrollmentSummaryImpl _value,
    $Res Function(_$StudentEnrollmentSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentEnrollmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? programName = freezed, Object? levelName = freezed}) {
    return _then(
      _$StudentEnrollmentSummaryImpl(
        programName: freezed == programName
            ? _value.programName
            : programName // ignore: cast_nullable_to_non_nullable
                  as String?,
        levelName: freezed == levelName
            ? _value.levelName
            : levelName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentEnrollmentSummaryImpl implements _StudentEnrollmentSummary {
  const _$StudentEnrollmentSummaryImpl({
    @JsonKey(name: 'program_name') this.programName,
    @JsonKey(name: 'level_name') this.levelName,
  });

  factory _$StudentEnrollmentSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentEnrollmentSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'program_name')
  final String? programName;
  @override
  @JsonKey(name: 'level_name')
  final String? levelName;

  @override
  String toString() {
    return 'StudentEnrollmentSummary(programName: $programName, levelName: $levelName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentEnrollmentSummaryImpl &&
            (identical(other.programName, programName) ||
                other.programName == programName) &&
            (identical(other.levelName, levelName) ||
                other.levelName == levelName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, programName, levelName);

  /// Create a copy of StudentEnrollmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentEnrollmentSummaryImplCopyWith<_$StudentEnrollmentSummaryImpl>
  get copyWith =>
      __$$StudentEnrollmentSummaryImplCopyWithImpl<
        _$StudentEnrollmentSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentEnrollmentSummaryImplToJson(this);
  }
}

abstract class _StudentEnrollmentSummary implements StudentEnrollmentSummary {
  const factory _StudentEnrollmentSummary({
    @JsonKey(name: 'program_name') final String? programName,
    @JsonKey(name: 'level_name') final String? levelName,
  }) = _$StudentEnrollmentSummaryImpl;

  factory _StudentEnrollmentSummary.fromJson(Map<String, dynamic> json) =
      _$StudentEnrollmentSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'program_name')
  String? get programName;
  @override
  @JsonKey(name: 'level_name')
  String? get levelName;

  /// Create a copy of StudentEnrollmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentEnrollmentSummaryImplCopyWith<_$StudentEnrollmentSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LatestProgress _$LatestProgressFromJson(Map<String, dynamic> json) {
  return _LatestProgress.fromJson(json);
}

/// @nodoc
mixin _$LatestProgress {
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  /// Serializes this LatestProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LatestProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LatestProgressCopyWith<LatestProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LatestProgressCopyWith<$Res> {
  factory $LatestProgressCopyWith(
    LatestProgress value,
    $Res Function(LatestProgress) then,
  ) = _$LatestProgressCopyWithImpl<$Res, LatestProgress>;
  @useResult
  $Res call({String? status, int? score});
}

/// @nodoc
class _$LatestProgressCopyWithImpl<$Res, $Val extends LatestProgress>
    implements $LatestProgressCopyWith<$Res> {
  _$LatestProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LatestProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = freezed, Object? score = freezed}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LatestProgressImplCopyWith<$Res>
    implements $LatestProgressCopyWith<$Res> {
  factory _$$LatestProgressImplCopyWith(
    _$LatestProgressImpl value,
    $Res Function(_$LatestProgressImpl) then,
  ) = __$$LatestProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? status, int? score});
}

/// @nodoc
class __$$LatestProgressImplCopyWithImpl<$Res>
    extends _$LatestProgressCopyWithImpl<$Res, _$LatestProgressImpl>
    implements _$$LatestProgressImplCopyWith<$Res> {
  __$$LatestProgressImplCopyWithImpl(
    _$LatestProgressImpl _value,
    $Res Function(_$LatestProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LatestProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = freezed, Object? score = freezed}) {
    return _then(
      _$LatestProgressImpl(
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
class _$LatestProgressImpl implements _LatestProgress {
  const _$LatestProgressImpl({this.status, this.score});

  factory _$LatestProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$LatestProgressImplFromJson(json);

  @override
  final String? status;
  @override
  final int? score;

  @override
  String toString() {
    return 'LatestProgress(status: $status, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LatestProgressImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, score);

  /// Create a copy of LatestProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LatestProgressImplCopyWith<_$LatestProgressImpl> get copyWith =>
      __$$LatestProgressImplCopyWithImpl<_$LatestProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LatestProgressImplToJson(this);
  }
}

abstract class _LatestProgress implements LatestProgress {
  const factory _LatestProgress({final String? status, final int? score}) =
      _$LatestProgressImpl;

  factory _LatestProgress.fromJson(Map<String, dynamic> json) =
      _$LatestProgressImpl.fromJson;

  @override
  String? get status;
  @override
  int? get score;

  /// Create a copy of LatestProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LatestProgressImplCopyWith<_$LatestProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
