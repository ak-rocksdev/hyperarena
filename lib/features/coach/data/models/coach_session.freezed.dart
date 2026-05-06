// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachSession _$CoachSessionFromJson(Map<String, dynamic> json) {
  return _CoachSession.fromJson(json);
}

/// @nodoc
mixin _$CoachSession {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at')
  DateTime get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Backend-derived quality flag — independent of `status`.
  /// Values: `not_yet | needs_attendance | needs_grading | complete`.
  /// `not_yet` = future session; the other three drive Issue 1 warning chips.
  @JsonKey(name: 'completion_state')
  String get completionState => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_students_count')
  int get bookedStudentsCount => throw _privateConstructorUsedError;
  CoachSessionVenue? get venue => throw _privateConstructorUsedError;
  List<CoachSessionCoach> get coaches =>
      throw _privateConstructorUsedError; // Detail-only fields
  @JsonKey(name: 'session_students')
  List<CoachSessionStudent> get sessionStudents =>
      throw _privateConstructorUsedError;
  List<CoachSessionAttendance> get attendances =>
      throw _privateConstructorUsedError;

  /// Serializes this CoachSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionCopyWith<CoachSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionCopyWith<$Res> {
  factory $CoachSessionCopyWith(
    CoachSession value,
    $Res Function(CoachSession) then,
  ) = _$CoachSessionCopyWithImpl<$Res, CoachSession>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String? type,
    @JsonKey(name: 'start_at') DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    int capacity,
    String? status,
    String? notes,
    String name,
    @JsonKey(name: 'completion_state') String completionState,
    @JsonKey(name: 'booked_students_count') int bookedStudentsCount,
    CoachSessionVenue? venue,
    List<CoachSessionCoach> coaches,
    @JsonKey(name: 'session_students')
    List<CoachSessionStudent> sessionStudents,
    List<CoachSessionAttendance> attendances,
  });

  $CoachSessionVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class _$CoachSessionCopyWithImpl<$Res, $Val extends CoachSession>
    implements $CoachSessionCopyWith<$Res> {
  _$CoachSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? capacity = null,
    Object? status = freezed,
    Object? notes = freezed,
    Object? name = null,
    Object? completionState = null,
    Object? bookedStudentsCount = null,
    Object? venue = freezed,
    Object? coaches = null,
    Object? sessionStudents = null,
    Object? attendances = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            startAt: null == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            completionState: null == completionState
                ? _value.completionState
                : completionState // ignore: cast_nullable_to_non_nullable
                      as String,
            bookedStudentsCount: null == bookedStudentsCount
                ? _value.bookedStudentsCount
                : bookedStudentsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as CoachSessionVenue?,
            coaches: null == coaches
                ? _value.coaches
                : coaches // ignore: cast_nullable_to_non_nullable
                      as List<CoachSessionCoach>,
            sessionStudents: null == sessionStudents
                ? _value.sessionStudents
                : sessionStudents // ignore: cast_nullable_to_non_nullable
                      as List<CoachSessionStudent>,
            attendances: null == attendances
                ? _value.attendances
                : attendances // ignore: cast_nullable_to_non_nullable
                      as List<CoachSessionAttendance>,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachSessionVenueCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $CoachSessionVenueCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachSessionImplCopyWith<$Res>
    implements $CoachSessionCopyWith<$Res> {
  factory _$$CoachSessionImplCopyWith(
    _$CoachSessionImpl value,
    $Res Function(_$CoachSessionImpl) then,
  ) = __$$CoachSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String? type,
    @JsonKey(name: 'start_at') DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    int capacity,
    String? status,
    String? notes,
    String name,
    @JsonKey(name: 'completion_state') String completionState,
    @JsonKey(name: 'booked_students_count') int bookedStudentsCount,
    CoachSessionVenue? venue,
    List<CoachSessionCoach> coaches,
    @JsonKey(name: 'session_students')
    List<CoachSessionStudent> sessionStudents,
    List<CoachSessionAttendance> attendances,
  });

  @override
  $CoachSessionVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$CoachSessionImplCopyWithImpl<$Res>
    extends _$CoachSessionCopyWithImpl<$Res, _$CoachSessionImpl>
    implements _$$CoachSessionImplCopyWith<$Res> {
  __$$CoachSessionImplCopyWithImpl(
    _$CoachSessionImpl _value,
    $Res Function(_$CoachSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? capacity = null,
    Object? status = freezed,
    Object? notes = freezed,
    Object? name = null,
    Object? completionState = null,
    Object? bookedStudentsCount = null,
    Object? venue = freezed,
    Object? coaches = null,
    Object? sessionStudents = null,
    Object? attendances = null,
  }) {
    return _then(
      _$CoachSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        startAt: null == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        completionState: null == completionState
            ? _value.completionState
            : completionState // ignore: cast_nullable_to_non_nullable
                  as String,
        bookedStudentsCount: null == bookedStudentsCount
            ? _value.bookedStudentsCount
            : bookedStudentsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as CoachSessionVenue?,
        coaches: null == coaches
            ? _value._coaches
            : coaches // ignore: cast_nullable_to_non_nullable
                  as List<CoachSessionCoach>,
        sessionStudents: null == sessionStudents
            ? _value._sessionStudents
            : sessionStudents // ignore: cast_nullable_to_non_nullable
                  as List<CoachSessionStudent>,
        attendances: null == attendances
            ? _value._attendances
            : attendances // ignore: cast_nullable_to_non_nullable
                  as List<CoachSessionAttendance>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionImpl implements _CoachSession {
  const _$CoachSessionImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.type,
    @JsonKey(name: 'start_at') required this.startAt,
    @JsonKey(name: 'duration_minutes') this.durationMinutes = 0,
    this.capacity = 0,
    this.status,
    this.notes,
    this.name = 'Sesi Latihan',
    @JsonKey(name: 'completion_state') this.completionState = 'not_yet',
    @JsonKey(name: 'booked_students_count') this.bookedStudentsCount = 0,
    this.venue,
    final List<CoachSessionCoach> coaches = const [],
    @JsonKey(name: 'session_students')
    final List<CoachSessionStudent> sessionStudents = const [],
    final List<CoachSessionAttendance> attendances = const [],
  }) : _coaches = coaches,
       _sessionStudents = sessionStudents,
       _attendances = attendances;

  factory _$CoachSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String? type;
  @override
  @JsonKey(name: 'start_at')
  final DateTime startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  @JsonKey()
  final int capacity;
  @override
  final String? status;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String name;

  /// Backend-derived quality flag — independent of `status`.
  /// Values: `not_yet | needs_attendance | needs_grading | complete`.
  /// `not_yet` = future session; the other three drive Issue 1 warning chips.
  @override
  @JsonKey(name: 'completion_state')
  final String completionState;
  @override
  @JsonKey(name: 'booked_students_count')
  final int bookedStudentsCount;
  @override
  final CoachSessionVenue? venue;
  final List<CoachSessionCoach> _coaches;
  @override
  @JsonKey()
  List<CoachSessionCoach> get coaches {
    if (_coaches is EqualUnmodifiableListView) return _coaches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coaches);
  }

  // Detail-only fields
  final List<CoachSessionStudent> _sessionStudents;
  // Detail-only fields
  @override
  @JsonKey(name: 'session_students')
  List<CoachSessionStudent> get sessionStudents {
    if (_sessionStudents is EqualUnmodifiableListView) return _sessionStudents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionStudents);
  }

  final List<CoachSessionAttendance> _attendances;
  @override
  @JsonKey()
  List<CoachSessionAttendance> get attendances {
    if (_attendances is EqualUnmodifiableListView) return _attendances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attendances);
  }

  @override
  String toString() {
    return 'CoachSession(id: $id, type: $type, startAt: $startAt, durationMinutes: $durationMinutes, capacity: $capacity, status: $status, notes: $notes, name: $name, completionState: $completionState, bookedStudentsCount: $bookedStudentsCount, venue: $venue, coaches: $coaches, sessionStudents: $sessionStudents, attendances: $attendances)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.completionState, completionState) ||
                other.completionState == completionState) &&
            (identical(other.bookedStudentsCount, bookedStudentsCount) ||
                other.bookedStudentsCount == bookedStudentsCount) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            const DeepCollectionEquality().equals(other._coaches, _coaches) &&
            const DeepCollectionEquality().equals(
              other._sessionStudents,
              _sessionStudents,
            ) &&
            const DeepCollectionEquality().equals(
              other._attendances,
              _attendances,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    startAt,
    durationMinutes,
    capacity,
    status,
    notes,
    name,
    completionState,
    bookedStudentsCount,
    venue,
    const DeepCollectionEquality().hash(_coaches),
    const DeepCollectionEquality().hash(_sessionStudents),
    const DeepCollectionEquality().hash(_attendances),
  );

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionImplCopyWith<_$CoachSessionImpl> get copyWith =>
      __$$CoachSessionImplCopyWithImpl<_$CoachSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionImplToJson(this);
  }
}

abstract class _CoachSession implements CoachSession {
  const factory _CoachSession({
    @JsonKey(fromJson: idFromJson) required final String id,
    final String? type,
    @JsonKey(name: 'start_at') required final DateTime startAt,
    @JsonKey(name: 'duration_minutes') final int durationMinutes,
    final int capacity,
    final String? status,
    final String? notes,
    final String name,
    @JsonKey(name: 'completion_state') final String completionState,
    @JsonKey(name: 'booked_students_count') final int bookedStudentsCount,
    final CoachSessionVenue? venue,
    final List<CoachSessionCoach> coaches,
    @JsonKey(name: 'session_students')
    final List<CoachSessionStudent> sessionStudents,
    final List<CoachSessionAttendance> attendances,
  }) = _$CoachSessionImpl;

  factory _CoachSession.fromJson(Map<String, dynamic> json) =
      _$CoachSessionImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String? get type;
  @override
  @JsonKey(name: 'start_at')
  DateTime get startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  int get capacity;
  @override
  String? get status;
  @override
  String? get notes;
  @override
  String get name;

  /// Backend-derived quality flag — independent of `status`.
  /// Values: `not_yet | needs_attendance | needs_grading | complete`.
  /// `not_yet` = future session; the other three drive Issue 1 warning chips.
  @override
  @JsonKey(name: 'completion_state')
  String get completionState;
  @override
  @JsonKey(name: 'booked_students_count')
  int get bookedStudentsCount;
  @override
  CoachSessionVenue? get venue;
  @override
  List<CoachSessionCoach> get coaches; // Detail-only fields
  @override
  @JsonKey(name: 'session_students')
  List<CoachSessionStudent> get sessionStudents;
  @override
  List<CoachSessionAttendance> get attendances;

  /// Create a copy of CoachSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionImplCopyWith<_$CoachSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachSessionVenue _$CoachSessionVenueFromJson(Map<String, dynamic> json) {
  return _CoachSessionVenue.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionVenue {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CoachSessionVenueLocation? get location => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionVenueCopyWith<CoachSessionVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionVenueCopyWith<$Res> {
  factory $CoachSessionVenueCopyWith(
    CoachSessionVenue value,
    $Res Function(CoachSessionVenue) then,
  ) = _$CoachSessionVenueCopyWithImpl<$Res, CoachSessionVenue>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    CoachSessionVenueLocation? location,
  });

  $CoachSessionVenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$CoachSessionVenueCopyWithImpl<$Res, $Val extends CoachSessionVenue>
    implements $CoachSessionVenueCopyWith<$Res> {
  _$CoachSessionVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as CoachSessionVenueLocation?,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachSessionVenueLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $CoachSessionVenueLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachSessionVenueImplCopyWith<$Res>
    implements $CoachSessionVenueCopyWith<$Res> {
  factory _$$CoachSessionVenueImplCopyWith(
    _$CoachSessionVenueImpl value,
    $Res Function(_$CoachSessionVenueImpl) then,
  ) = __$$CoachSessionVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    CoachSessionVenueLocation? location,
  });

  @override
  $CoachSessionVenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$CoachSessionVenueImplCopyWithImpl<$Res>
    extends _$CoachSessionVenueCopyWithImpl<$Res, _$CoachSessionVenueImpl>
    implements _$$CoachSessionVenueImplCopyWith<$Res> {
  __$$CoachSessionVenueImplCopyWithImpl(
    _$CoachSessionVenueImpl _value,
    $Res Function(_$CoachSessionVenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
  }) {
    return _then(
      _$CoachSessionVenueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as CoachSessionVenueLocation?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionVenueImpl implements _CoachSessionVenue {
  const _$CoachSessionVenueImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.location,
  });

  factory _$CoachSessionVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionVenueImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final CoachSessionVenueLocation? location;

  @override
  String toString() {
    return 'CoachSessionVenue(id: $id, name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionVenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, location);

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionVenueImplCopyWith<_$CoachSessionVenueImpl> get copyWith =>
      __$$CoachSessionVenueImplCopyWithImpl<_$CoachSessionVenueImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionVenueImplToJson(this);
  }
}

abstract class _CoachSessionVenue implements CoachSessionVenue {
  const factory _CoachSessionVenue({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final CoachSessionVenueLocation? location,
  }) = _$CoachSessionVenueImpl;

  factory _CoachSessionVenue.fromJson(Map<String, dynamic> json) =
      _$CoachSessionVenueImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  CoachSessionVenueLocation? get location;

  /// Create a copy of CoachSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionVenueImplCopyWith<_$CoachSessionVenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachSessionVenueLocation _$CoachSessionVenueLocationFromJson(
  Map<String, dynamic> json,
) {
  return _CoachSessionVenueLocation.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionVenueLocation {
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lng => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionVenueLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionVenueLocationCopyWith<CoachSessionVenueLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionVenueLocationCopyWith<$Res> {
  factory $CoachSessionVenueLocationCopyWith(
    CoachSessionVenueLocation value,
    $Res Function(CoachSessionVenueLocation) then,
  ) = _$CoachSessionVenueLocationCopyWithImpl<$Res, CoachSessionVenueLocation>;
  @useResult
  $Res call({
    String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class _$CoachSessionVenueLocationCopyWithImpl<
  $Res,
  $Val extends CoachSessionVenueLocation
>
    implements $CoachSessionVenueLocationCopyWith<$Res> {
  _$CoachSessionVenueLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            lat: freezed == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double?,
            lng: freezed == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachSessionVenueLocationImplCopyWith<$Res>
    implements $CoachSessionVenueLocationCopyWith<$Res> {
  factory _$$CoachSessionVenueLocationImplCopyWith(
    _$CoachSessionVenueLocationImpl value,
    $Res Function(_$CoachSessionVenueLocationImpl) then,
  ) = __$$CoachSessionVenueLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class __$$CoachSessionVenueLocationImplCopyWithImpl<$Res>
    extends
        _$CoachSessionVenueLocationCopyWithImpl<
          $Res,
          _$CoachSessionVenueLocationImpl
        >
    implements _$$CoachSessionVenueLocationImplCopyWith<$Res> {
  __$$CoachSessionVenueLocationImplCopyWithImpl(
    _$CoachSessionVenueLocationImpl _value,
    $Res Function(_$CoachSessionVenueLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _$CoachSessionVenueLocationImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double?,
        lng: freezed == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionVenueLocationImpl implements _CoachSessionVenueLocation {
  const _$CoachSessionVenueLocationImpl({
    required this.name,
    this.address,
    @JsonKey(fromJson: latLngFromJson) this.lat,
    @JsonKey(fromJson: latLngFromJson) this.lng,
  });

  factory _$CoachSessionVenueLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionVenueLocationImplFromJson(json);

  @override
  final String name;
  @override
  final String? address;
  @override
  @JsonKey(fromJson: latLngFromJson)
  final double? lat;
  @override
  @JsonKey(fromJson: latLngFromJson)
  final double? lng;

  @override
  String toString() {
    return 'CoachSessionVenueLocation(name: $name, address: $address, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionVenueLocationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, address, lat, lng);

  /// Create a copy of CoachSessionVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionVenueLocationImplCopyWith<_$CoachSessionVenueLocationImpl>
  get copyWith =>
      __$$CoachSessionVenueLocationImplCopyWithImpl<
        _$CoachSessionVenueLocationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionVenueLocationImplToJson(this);
  }
}

abstract class _CoachSessionVenueLocation implements CoachSessionVenueLocation {
  const factory _CoachSessionVenueLocation({
    required final String name,
    final String? address,
    @JsonKey(fromJson: latLngFromJson) final double? lat,
    @JsonKey(fromJson: latLngFromJson) final double? lng,
  }) = _$CoachSessionVenueLocationImpl;

  factory _CoachSessionVenueLocation.fromJson(Map<String, dynamic> json) =
      _$CoachSessionVenueLocationImpl.fromJson;

  @override
  String get name;
  @override
  String? get address;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lat;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lng;

  /// Create a copy of CoachSessionVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionVenueLocationImplCopyWith<_$CoachSessionVenueLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CoachSessionCoach _$CoachSessionCoachFromJson(Map<String, dynamic> json) {
  return _CoachSessionCoach.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionCoach {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  CoachSessionUser? get user => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionCoach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionCoachCopyWith<CoachSessionCoach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionCoachCopyWith<$Res> {
  factory $CoachSessionCoachCopyWith(
    CoachSessionCoach value,
    $Res Function(CoachSessionCoach) then,
  ) = _$CoachSessionCoachCopyWithImpl<$Res, CoachSessionCoach>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, CoachSessionUser? user});

  $CoachSessionUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$CoachSessionCoachCopyWithImpl<$Res, $Val extends CoachSessionCoach>
    implements $CoachSessionCoachCopyWith<$Res> {
  _$CoachSessionCoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? user = freezed}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as CoachSessionUser?,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachSessionUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $CoachSessionUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachSessionCoachImplCopyWith<$Res>
    implements $CoachSessionCoachCopyWith<$Res> {
  factory _$$CoachSessionCoachImplCopyWith(
    _$CoachSessionCoachImpl value,
    $Res Function(_$CoachSessionCoachImpl) then,
  ) = __$$CoachSessionCoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, CoachSessionUser? user});

  @override
  $CoachSessionUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$CoachSessionCoachImplCopyWithImpl<$Res>
    extends _$CoachSessionCoachCopyWithImpl<$Res, _$CoachSessionCoachImpl>
    implements _$$CoachSessionCoachImplCopyWith<$Res> {
  __$$CoachSessionCoachImplCopyWithImpl(
    _$CoachSessionCoachImpl _value,
    $Res Function(_$CoachSessionCoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? user = freezed}) {
    return _then(
      _$CoachSessionCoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as CoachSessionUser?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionCoachImpl implements _CoachSessionCoach {
  const _$CoachSessionCoachImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.user,
  });

  factory _$CoachSessionCoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionCoachImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final CoachSessionUser? user;

  @override
  String toString() {
    return 'CoachSessionCoach(id: $id, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionCoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user);

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionCoachImplCopyWith<_$CoachSessionCoachImpl> get copyWith =>
      __$$CoachSessionCoachImplCopyWithImpl<_$CoachSessionCoachImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionCoachImplToJson(this);
  }
}

abstract class _CoachSessionCoach implements CoachSessionCoach {
  const factory _CoachSessionCoach({
    @JsonKey(fromJson: idFromJson) required final String id,
    final CoachSessionUser? user,
  }) = _$CoachSessionCoachImpl;

  factory _CoachSessionCoach.fromJson(Map<String, dynamic> json) =
      _$CoachSessionCoachImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  CoachSessionUser? get user;

  /// Create a copy of CoachSessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionCoachImplCopyWith<_$CoachSessionCoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachSessionUser _$CoachSessionUserFromJson(Map<String, dynamic> json) {
  return _CoachSessionUser.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionUser {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionUserCopyWith<CoachSessionUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionUserCopyWith<$Res> {
  factory $CoachSessionUserCopyWith(
    CoachSessionUser value,
    $Res Function(CoachSessionUser) then,
  ) = _$CoachSessionUserCopyWithImpl<$Res, CoachSessionUser>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? email,
  });
}

/// @nodoc
class _$CoachSessionUserCopyWithImpl<$Res, $Val extends CoachSessionUser>
    implements $CoachSessionUserCopyWith<$Res> {
  _$CoachSessionUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? email = freezed}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachSessionUserImplCopyWith<$Res>
    implements $CoachSessionUserCopyWith<$Res> {
  factory _$$CoachSessionUserImplCopyWith(
    _$CoachSessionUserImpl value,
    $Res Function(_$CoachSessionUserImpl) then,
  ) = __$$CoachSessionUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? email,
  });
}

/// @nodoc
class __$$CoachSessionUserImplCopyWithImpl<$Res>
    extends _$CoachSessionUserCopyWithImpl<$Res, _$CoachSessionUserImpl>
    implements _$$CoachSessionUserImplCopyWith<$Res> {
  __$$CoachSessionUserImplCopyWithImpl(
    _$CoachSessionUserImpl _value,
    $Res Function(_$CoachSessionUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? email = freezed}) {
    return _then(
      _$CoachSessionUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionUserImpl implements _CoachSessionUser {
  const _$CoachSessionUserImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.email,
  });

  factory _$CoachSessionUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionUserImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? email;

  @override
  String toString() {
    return 'CoachSessionUser(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email);

  /// Create a copy of CoachSessionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionUserImplCopyWith<_$CoachSessionUserImpl> get copyWith =>
      __$$CoachSessionUserImplCopyWithImpl<_$CoachSessionUserImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionUserImplToJson(this);
  }
}

abstract class _CoachSessionUser implements CoachSessionUser {
  const factory _CoachSessionUser({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? email,
  }) = _$CoachSessionUserImpl;

  factory _CoachSessionUser.fromJson(Map<String, dynamic> json) =
      _$CoachSessionUserImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get email;

  /// Create a copy of CoachSessionUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionUserImplCopyWith<_$CoachSessionUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachSessionStudent _$CoachSessionStudentFromJson(Map<String, dynamic> json) {
  return _CoachSessionStudent.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionStudent {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile')
  StudentProfile? get studentProfile => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionStudent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionStudentCopyWith<CoachSessionStudent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionStudentCopyWith<$Res> {
  factory $CoachSessionStudentCopyWith(
    CoachSessionStudent value,
    $Res Function(CoachSessionStudent) then,
  ) = _$CoachSessionStudentCopyWithImpl<$Res, CoachSessionStudent>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'student_profile') StudentProfile? studentProfile,
  });

  $StudentProfileCopyWith<$Res>? get studentProfile;
}

/// @nodoc
class _$CoachSessionStudentCopyWithImpl<$Res, $Val extends CoachSessionStudent>
    implements $CoachSessionStudentCopyWith<$Res> {
  _$CoachSessionStudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? cancelledAt = freezed,
    Object? studentProfile = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentProfileId: null == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            studentProfile: freezed == studentProfile
                ? _value.studentProfile
                : studentProfile // ignore: cast_nullable_to_non_nullable
                      as StudentProfile?,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentProfileCopyWith<$Res>? get studentProfile {
    if (_value.studentProfile == null) {
      return null;
    }

    return $StudentProfileCopyWith<$Res>(_value.studentProfile!, (value) {
      return _then(_value.copyWith(studentProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachSessionStudentImplCopyWith<$Res>
    implements $CoachSessionStudentCopyWith<$Res> {
  factory _$$CoachSessionStudentImplCopyWith(
    _$CoachSessionStudentImpl value,
    $Res Function(_$CoachSessionStudentImpl) then,
  ) = __$$CoachSessionStudentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'student_profile') StudentProfile? studentProfile,
  });

  @override
  $StudentProfileCopyWith<$Res>? get studentProfile;
}

/// @nodoc
class __$$CoachSessionStudentImplCopyWithImpl<$Res>
    extends _$CoachSessionStudentCopyWithImpl<$Res, _$CoachSessionStudentImpl>
    implements _$$CoachSessionStudentImplCopyWith<$Res> {
  __$$CoachSessionStudentImplCopyWithImpl(
    _$CoachSessionStudentImpl _value,
    $Res Function(_$CoachSessionStudentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? cancelledAt = freezed,
    Object? studentProfile = freezed,
  }) {
    return _then(
      _$CoachSessionStudentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        studentProfile: freezed == studentProfile
            ? _value.studentProfile
            : studentProfile // ignore: cast_nullable_to_non_nullable
                  as StudentProfile?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionStudentImpl implements _CoachSessionStudent {
  const _$CoachSessionStudentImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'cancelled_at') this.cancelledAt,
    @JsonKey(name: 'student_profile') this.studentProfile,
  });

  factory _$CoachSessionStudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionStudentImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'student_profile')
  final StudentProfile? studentProfile;

  @override
  String toString() {
    return 'CoachSessionStudent(id: $id, studentProfileId: $studentProfileId, cancelledAt: $cancelledAt, studentProfile: $studentProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionStudentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.studentProfile, studentProfile) ||
                other.studentProfile == studentProfile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentProfileId,
    cancelledAt,
    studentProfile,
  );

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionStudentImplCopyWith<_$CoachSessionStudentImpl> get copyWith =>
      __$$CoachSessionStudentImplCopyWithImpl<_$CoachSessionStudentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionStudentImplToJson(this);
  }
}

abstract class _CoachSessionStudent implements CoachSessionStudent {
  const factory _CoachSessionStudent({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
    @JsonKey(name: 'student_profile') final StudentProfile? studentProfile,
  }) = _$CoachSessionStudentImpl;

  factory _CoachSessionStudent.fromJson(Map<String, dynamic> json) =
      _$CoachSessionStudentImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'student_profile')
  StudentProfile? get studentProfile;

  /// Create a copy of CoachSessionStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionStudentImplCopyWith<_$CoachSessionStudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) {
  return _StudentProfile.fromJson(json);
}

/// @nodoc
mixin _$StudentProfile {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_path')
  String? get photoPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileCopyWith<StudentProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileCopyWith<$Res> {
  factory $StudentProfileCopyWith(
    StudentProfile value,
    $Res Function(StudentProfile) then,
  ) = _$StudentProfileCopyWithImpl<$Res, StudentProfile>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });
}

/// @nodoc
class _$StudentProfileCopyWithImpl<$Res, $Val extends StudentProfile>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentProfileImplCopyWith<$Res>
    implements $StudentProfileCopyWith<$Res> {
  factory _$$StudentProfileImplCopyWith(
    _$StudentProfileImpl value,
    $Res Function(_$StudentProfileImpl) then,
  ) = __$$StudentProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });
}

/// @nodoc
class __$$StudentProfileImplCopyWithImpl<$Res>
    extends _$StudentProfileCopyWithImpl<$Res, _$StudentProfileImpl>
    implements _$$StudentProfileImplCopyWith<$Res> {
  __$$StudentProfileImplCopyWithImpl(
    _$StudentProfileImpl _value,
    $Res Function(_$StudentProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(
      _$StudentProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileImpl implements _StudentProfile {
  const _$StudentProfileImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    @JsonKey(name: 'photo_path') this.photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) : _photoUrls = photoUrls;

  factory _$StudentProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'photo_path')
  final String? photoPath;
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
  String toString() {
    return 'StudentProfile(id: $id, firstName: $firstName, lastName: $lastName, photoPath: $photoPath, photoUrls: $photoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    photoPath,
    const DeepCollectionEquality().hash(_photoUrls),
  );

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      __$$StudentProfileImplCopyWithImpl<_$StudentProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileImplToJson(this);
  }
}

abstract class _StudentProfile implements StudentProfile {
  const factory _StudentProfile({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    @JsonKey(name: 'photo_path') final String? photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) = _$StudentProfileImpl;

  factory _StudentProfile.fromJson(Map<String, dynamic> json) =
      _$StudentProfileImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'photo_path')
  String? get photoPath;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachSessionAttendance _$CoachSessionAttendanceFromJson(
  Map<String, dynamic> json,
) {
  return _CoachSessionAttendance.fromJson(json);
}

/// @nodoc
mixin _$CoachSessionAttendance {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'marked_by_user')
  CoachSessionUser? get markedByUser => throw _privateConstructorUsedError;

  /// Serializes this CoachSessionAttendance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachSessionAttendanceCopyWith<CoachSessionAttendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachSessionAttendanceCopyWith<$Res> {
  factory $CoachSessionAttendanceCopyWith(
    CoachSessionAttendance value,
    $Res Function(CoachSessionAttendance) then,
  ) = _$CoachSessionAttendanceCopyWithImpl<$Res, CoachSessionAttendance>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    String status,
    @JsonKey(name: 'marked_by_user') CoachSessionUser? markedByUser,
  });

  $CoachSessionUserCopyWith<$Res>? get markedByUser;
}

/// @nodoc
class _$CoachSessionAttendanceCopyWithImpl<
  $Res,
  $Val extends CoachSessionAttendance
>
    implements $CoachSessionAttendanceCopyWith<$Res> {
  _$CoachSessionAttendanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? status = null,
    Object? markedByUser = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentProfileId: null == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            markedByUser: freezed == markedByUser
                ? _value.markedByUser
                : markedByUser // ignore: cast_nullable_to_non_nullable
                      as CoachSessionUser?,
          )
          as $Val,
    );
  }

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachSessionUserCopyWith<$Res>? get markedByUser {
    if (_value.markedByUser == null) {
      return null;
    }

    return $CoachSessionUserCopyWith<$Res>(_value.markedByUser!, (value) {
      return _then(_value.copyWith(markedByUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoachSessionAttendanceImplCopyWith<$Res>
    implements $CoachSessionAttendanceCopyWith<$Res> {
  factory _$$CoachSessionAttendanceImplCopyWith(
    _$CoachSessionAttendanceImpl value,
    $Res Function(_$CoachSessionAttendanceImpl) then,
  ) = __$$CoachSessionAttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    String status,
    @JsonKey(name: 'marked_by_user') CoachSessionUser? markedByUser,
  });

  @override
  $CoachSessionUserCopyWith<$Res>? get markedByUser;
}

/// @nodoc
class __$$CoachSessionAttendanceImplCopyWithImpl<$Res>
    extends
        _$CoachSessionAttendanceCopyWithImpl<$Res, _$CoachSessionAttendanceImpl>
    implements _$$CoachSessionAttendanceImplCopyWith<$Res> {
  __$$CoachSessionAttendanceImplCopyWithImpl(
    _$CoachSessionAttendanceImpl _value,
    $Res Function(_$CoachSessionAttendanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? status = null,
    Object? markedByUser = freezed,
  }) {
    return _then(
      _$CoachSessionAttendanceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        markedByUser: freezed == markedByUser
            ? _value.markedByUser
            : markedByUser // ignore: cast_nullable_to_non_nullable
                  as CoachSessionUser?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachSessionAttendanceImpl implements _CoachSessionAttendance {
  const _$CoachSessionAttendanceImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    required this.status,
    @JsonKey(name: 'marked_by_user') this.markedByUser,
  });

  factory _$CoachSessionAttendanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachSessionAttendanceImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  final String status;
  @override
  @JsonKey(name: 'marked_by_user')
  final CoachSessionUser? markedByUser;

  @override
  String toString() {
    return 'CoachSessionAttendance(id: $id, studentProfileId: $studentProfileId, status: $status, markedByUser: $markedByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachSessionAttendanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.markedByUser, markedByUser) ||
                other.markedByUser == markedByUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, studentProfileId, status, markedByUser);

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachSessionAttendanceImplCopyWith<_$CoachSessionAttendanceImpl>
  get copyWith =>
      __$$CoachSessionAttendanceImplCopyWithImpl<_$CoachSessionAttendanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachSessionAttendanceImplToJson(this);
  }
}

abstract class _CoachSessionAttendance implements CoachSessionAttendance {
  const factory _CoachSessionAttendance({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    required final String status,
    @JsonKey(name: 'marked_by_user') final CoachSessionUser? markedByUser,
  }) = _$CoachSessionAttendanceImpl;

  factory _CoachSessionAttendance.fromJson(Map<String, dynamic> json) =
      _$CoachSessionAttendanceImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  String get status;
  @override
  @JsonKey(name: 'marked_by_user')
  CoachSessionUser? get markedByUser;

  /// Create a copy of CoachSessionAttendance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachSessionAttendanceImplCopyWith<_$CoachSessionAttendanceImpl>
  get copyWith => throw _privateConstructorUsedError;
}
