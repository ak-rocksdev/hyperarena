// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_student_roster_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminStudentRosterItem _$AdminStudentRosterItemFromJson(
  Map<String, dynamic> json,
) {
  return _AdminStudentRosterItem.fromJson(json);
}

/// @nodoc
mixin _$AdminStudentRosterItem {
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;
  StudentEnrollmentSummary? get enrollment =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_coach')
  AssignedCoachSummary? get assignedCoach => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sessions')
  int get totalSessions => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_progress')
  LatestProgress? get latestProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_amount')
  int get outstandingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'oldest_outstanding_at')
  DateTime? get oldestOutstandingAt => throw _privateConstructorUsedError;

  /// Serializes this AdminStudentRosterItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminStudentRosterItemCopyWith<AdminStudentRosterItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStudentRosterItemCopyWith<$Res> {
  factory $AdminStudentRosterItemCopyWith(
    AdminStudentRosterItem value,
    $Res Function(AdminStudentRosterItem) then,
  ) = _$AdminStudentRosterItemCopyWithImpl<$Res, AdminStudentRosterItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'full_name') String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'assigned_coach') AssignedCoachSummary? assignedCoach,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions') int totalSessions,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
    @JsonKey(name: 'outstanding_amount') int outstandingAmount,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
    @JsonKey(name: 'oldest_outstanding_at') DateTime? oldestOutstandingAt,
  });

  $StudentEnrollmentSummaryCopyWith<$Res>? get enrollment;
  $AssignedCoachSummaryCopyWith<$Res>? get assignedCoach;
  $LatestProgressCopyWith<$Res>? get latestProgress;
}

/// @nodoc
class _$AdminStudentRosterItemCopyWithImpl<
  $Res,
  $Val extends AdminStudentRosterItem
>
    implements $AdminStudentRosterItemCopyWith<$Res> {
  _$AdminStudentRosterItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = null,
    Object? fullName = null,
    Object? age = freezed,
    Object? photoUrls = freezed,
    Object? enrollment = freezed,
    Object? assignedCoach = freezed,
    Object? lastSessionAt = freezed,
    Object? totalSessions = null,
    Object? attendanceRate = null,
    Object? latestProgress = freezed,
    Object? outstandingAmount = null,
    Object? outstandingCount = null,
    Object? oldestOutstandingAt = freezed,
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
            assignedCoach: freezed == assignedCoach
                ? _value.assignedCoach
                : assignedCoach // ignore: cast_nullable_to_non_nullable
                      as AssignedCoachSummary?,
            lastSessionAt: freezed == lastSessionAt
                ? _value.lastSessionAt
                : lastSessionAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            attendanceRate: null == attendanceRate
                ? _value.attendanceRate
                : attendanceRate // ignore: cast_nullable_to_non_nullable
                      as double,
            latestProgress: freezed == latestProgress
                ? _value.latestProgress
                : latestProgress // ignore: cast_nullable_to_non_nullable
                      as LatestProgress?,
            outstandingAmount: null == outstandingAmount
                ? _value.outstandingAmount
                : outstandingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingCount: null == outstandingCount
                ? _value.outstandingCount
                : outstandingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            oldestOutstandingAt: freezed == oldestOutstandingAt
                ? _value.oldestOutstandingAt
                : oldestOutstandingAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of AdminStudentRosterItem
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

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssignedCoachSummaryCopyWith<$Res>? get assignedCoach {
    if (_value.assignedCoach == null) {
      return null;
    }

    return $AssignedCoachSummaryCopyWith<$Res>(_value.assignedCoach!, (value) {
      return _then(_value.copyWith(assignedCoach: value) as $Val);
    });
  }

  /// Create a copy of AdminStudentRosterItem
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
abstract class _$$AdminStudentRosterItemImplCopyWith<$Res>
    implements $AdminStudentRosterItemCopyWith<$Res> {
  factory _$$AdminStudentRosterItemImplCopyWith(
    _$AdminStudentRosterItemImpl value,
    $Res Function(_$AdminStudentRosterItemImpl) then,
  ) = __$$AdminStudentRosterItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'full_name') String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'assigned_coach') AssignedCoachSummary? assignedCoach,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions') int totalSessions,
    @JsonKey(name: 'attendance_rate') double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
    @JsonKey(name: 'outstanding_amount') int outstandingAmount,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
    @JsonKey(name: 'oldest_outstanding_at') DateTime? oldestOutstandingAt,
  });

  @override
  $StudentEnrollmentSummaryCopyWith<$Res>? get enrollment;
  @override
  $AssignedCoachSummaryCopyWith<$Res>? get assignedCoach;
  @override
  $LatestProgressCopyWith<$Res>? get latestProgress;
}

/// @nodoc
class __$$AdminStudentRosterItemImplCopyWithImpl<$Res>
    extends
        _$AdminStudentRosterItemCopyWithImpl<$Res, _$AdminStudentRosterItemImpl>
    implements _$$AdminStudentRosterItemImplCopyWith<$Res> {
  __$$AdminStudentRosterItemImplCopyWithImpl(
    _$AdminStudentRosterItemImpl _value,
    $Res Function(_$AdminStudentRosterItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = null,
    Object? fullName = null,
    Object? age = freezed,
    Object? photoUrls = freezed,
    Object? enrollment = freezed,
    Object? assignedCoach = freezed,
    Object? lastSessionAt = freezed,
    Object? totalSessions = null,
    Object? attendanceRate = null,
    Object? latestProgress = freezed,
    Object? outstandingAmount = null,
    Object? outstandingCount = null,
    Object? oldestOutstandingAt = freezed,
  }) {
    return _then(
      _$AdminStudentRosterItemImpl(
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
        assignedCoach: freezed == assignedCoach
            ? _value.assignedCoach
            : assignedCoach // ignore: cast_nullable_to_non_nullable
                  as AssignedCoachSummary?,
        lastSessionAt: freezed == lastSessionAt
            ? _value.lastSessionAt
            : lastSessionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        attendanceRate: null == attendanceRate
            ? _value.attendanceRate
            : attendanceRate // ignore: cast_nullable_to_non_nullable
                  as double,
        latestProgress: freezed == latestProgress
            ? _value.latestProgress
            : latestProgress // ignore: cast_nullable_to_non_nullable
                  as LatestProgress?,
        outstandingAmount: null == outstandingAmount
            ? _value.outstandingAmount
            : outstandingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingCount: null == outstandingCount
            ? _value.outstandingCount
            : outstandingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        oldestOutstandingAt: freezed == oldestOutstandingAt
            ? _value.oldestOutstandingAt
            : oldestOutstandingAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminStudentRosterItemImpl implements _AdminStudentRosterItem {
  const _$AdminStudentRosterItemImpl({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'full_name') required this.fullName,
    this.age,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    this.enrollment,
    @JsonKey(name: 'assigned_coach') this.assignedCoach,
    @JsonKey(name: 'last_session_at') this.lastSessionAt,
    @JsonKey(name: 'total_sessions') this.totalSessions = 0,
    @JsonKey(name: 'attendance_rate') this.attendanceRate = 0.0,
    @JsonKey(name: 'latest_progress') this.latestProgress,
    @JsonKey(name: 'outstanding_amount') this.outstandingAmount = 0,
    @JsonKey(name: 'outstanding_count') this.outstandingCount = 0,
    @JsonKey(name: 'oldest_outstanding_at') this.oldestOutstandingAt,
  }) : _photoUrls = photoUrls;

  factory _$AdminStudentRosterItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminStudentRosterItemImplFromJson(json);

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
  @JsonKey(name: 'assigned_coach')
  final AssignedCoachSummary? assignedCoach;
  @override
  @JsonKey(name: 'last_session_at')
  final DateTime? lastSessionAt;
  @override
  @JsonKey(name: 'total_sessions')
  final int totalSessions;
  @override
  @JsonKey(name: 'attendance_rate')
  final double attendanceRate;
  @override
  @JsonKey(name: 'latest_progress')
  final LatestProgress? latestProgress;
  @override
  @JsonKey(name: 'outstanding_amount')
  final int outstandingAmount;
  @override
  @JsonKey(name: 'outstanding_count')
  final int outstandingCount;
  @override
  @JsonKey(name: 'oldest_outstanding_at')
  final DateTime? oldestOutstandingAt;

  @override
  String toString() {
    return 'AdminStudentRosterItem(studentProfileId: $studentProfileId, fullName: $fullName, age: $age, photoUrls: $photoUrls, enrollment: $enrollment, assignedCoach: $assignedCoach, lastSessionAt: $lastSessionAt, totalSessions: $totalSessions, attendanceRate: $attendanceRate, latestProgress: $latestProgress, outstandingAmount: $outstandingAmount, outstandingCount: $outstandingCount, oldestOutstandingAt: $oldestOutstandingAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminStudentRosterItemImpl &&
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
            (identical(other.assignedCoach, assignedCoach) ||
                other.assignedCoach == assignedCoach) &&
            (identical(other.lastSessionAt, lastSessionAt) ||
                other.lastSessionAt == lastSessionAt) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.attendanceRate, attendanceRate) ||
                other.attendanceRate == attendanceRate) &&
            (identical(other.latestProgress, latestProgress) ||
                other.latestProgress == latestProgress) &&
            (identical(other.outstandingAmount, outstandingAmount) ||
                other.outstandingAmount == outstandingAmount) &&
            (identical(other.outstandingCount, outstandingCount) ||
                other.outstandingCount == outstandingCount) &&
            (identical(other.oldestOutstandingAt, oldestOutstandingAt) ||
                other.oldestOutstandingAt == oldestOutstandingAt));
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
    assignedCoach,
    lastSessionAt,
    totalSessions,
    attendanceRate,
    latestProgress,
    outstandingAmount,
    outstandingCount,
    oldestOutstandingAt,
  );

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminStudentRosterItemImplCopyWith<_$AdminStudentRosterItemImpl>
  get copyWith =>
      __$$AdminStudentRosterItemImplCopyWithImpl<_$AdminStudentRosterItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminStudentRosterItemImplToJson(this);
  }
}

abstract class _AdminStudentRosterItem implements AdminStudentRosterItem {
  const factory _AdminStudentRosterItem({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'full_name') required final String fullName,
    final int? age,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    final StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'assigned_coach') final AssignedCoachSummary? assignedCoach,
    @JsonKey(name: 'last_session_at') final DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions') final int totalSessions,
    @JsonKey(name: 'attendance_rate') final double attendanceRate,
    @JsonKey(name: 'latest_progress') final LatestProgress? latestProgress,
    @JsonKey(name: 'outstanding_amount') final int outstandingAmount,
    @JsonKey(name: 'outstanding_count') final int outstandingCount,
    @JsonKey(name: 'oldest_outstanding_at') final DateTime? oldestOutstandingAt,
  }) = _$AdminStudentRosterItemImpl;

  factory _AdminStudentRosterItem.fromJson(Map<String, dynamic> json) =
      _$AdminStudentRosterItemImpl.fromJson;

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
  @JsonKey(name: 'assigned_coach')
  AssignedCoachSummary? get assignedCoach;
  @override
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt;
  @override
  @JsonKey(name: 'total_sessions')
  int get totalSessions;
  @override
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate;
  @override
  @JsonKey(name: 'latest_progress')
  LatestProgress? get latestProgress;
  @override
  @JsonKey(name: 'outstanding_amount')
  int get outstandingAmount;
  @override
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount;
  @override
  @JsonKey(name: 'oldest_outstanding_at')
  DateTime? get oldestOutstandingAt;

  /// Create a copy of AdminStudentRosterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminStudentRosterItemImplCopyWith<_$AdminStudentRosterItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AssignedCoachSummary _$AssignedCoachSummaryFromJson(Map<String, dynamic> json) {
  return _AssignedCoachSummary.fromJson(json);
}

/// @nodoc
mixin _$AssignedCoachSummary {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this AssignedCoachSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignedCoachSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignedCoachSummaryCopyWith<AssignedCoachSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedCoachSummaryCopyWith<$Res> {
  factory $AssignedCoachSummaryCopyWith(
    AssignedCoachSummary value,
    $Res Function(AssignedCoachSummary) then,
  ) = _$AssignedCoachSummaryCopyWithImpl<$Res, AssignedCoachSummary>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String? name});
}

/// @nodoc
class _$AssignedCoachSummaryCopyWithImpl<
  $Res,
  $Val extends AssignedCoachSummary
>
    implements $AssignedCoachSummaryCopyWith<$Res> {
  _$AssignedCoachSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignedCoachSummary
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
abstract class _$$AssignedCoachSummaryImplCopyWith<$Res>
    implements $AssignedCoachSummaryCopyWith<$Res> {
  factory _$$AssignedCoachSummaryImplCopyWith(
    _$AssignedCoachSummaryImpl value,
    $Res Function(_$AssignedCoachSummaryImpl) then,
  ) = __$$AssignedCoachSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String? name});
}

/// @nodoc
class __$$AssignedCoachSummaryImplCopyWithImpl<$Res>
    extends _$AssignedCoachSummaryCopyWithImpl<$Res, _$AssignedCoachSummaryImpl>
    implements _$$AssignedCoachSummaryImplCopyWith<$Res> {
  __$$AssignedCoachSummaryImplCopyWithImpl(
    _$AssignedCoachSummaryImpl _value,
    $Res Function(_$AssignedCoachSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignedCoachSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = freezed}) {
    return _then(
      _$AssignedCoachSummaryImpl(
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
class _$AssignedCoachSummaryImpl implements _AssignedCoachSummary {
  const _$AssignedCoachSummaryImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.name,
  });

  factory _$AssignedCoachSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedCoachSummaryImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String? name;

  @override
  String toString() {
    return 'AssignedCoachSummary(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedCoachSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of AssignedCoachSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedCoachSummaryImplCopyWith<_$AssignedCoachSummaryImpl>
  get copyWith =>
      __$$AssignedCoachSummaryImplCopyWithImpl<_$AssignedCoachSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedCoachSummaryImplToJson(this);
  }
}

abstract class _AssignedCoachSummary implements AssignedCoachSummary {
  const factory _AssignedCoachSummary({
    @JsonKey(fromJson: idFromJson) required final String id,
    final String? name,
  }) = _$AssignedCoachSummaryImpl;

  factory _AssignedCoachSummary.fromJson(Map<String, dynamic> json) =
      _$AssignedCoachSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String? get name;

  /// Create a copy of AssignedCoachSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedCoachSummaryImplCopyWith<_$AssignedCoachSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
