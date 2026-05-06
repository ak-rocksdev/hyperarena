// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_progress_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionProgressDetail _$SessionProgressDetailFromJson(
  Map<String, dynamic> json,
) {
  return _SessionProgressDetail.fromJson(json);
}

/// @nodoc
mixin _$SessionProgressDetail {
  @JsonKey(name: 'session_progress')
  List<SessionProgressEntry> get sessionProgress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_progress')
  List<SkillProgressEntry> get skillProgress =>
      throw _privateConstructorUsedError;

  /// Serializes this SessionProgressDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionProgressDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionProgressDetailCopyWith<SessionProgressDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionProgressDetailCopyWith<$Res> {
  factory $SessionProgressDetailCopyWith(
    SessionProgressDetail value,
    $Res Function(SessionProgressDetail) then,
  ) = _$SessionProgressDetailCopyWithImpl<$Res, SessionProgressDetail>;
  @useResult
  $Res call({
    @JsonKey(name: 'session_progress')
    List<SessionProgressEntry> sessionProgress,
    @JsonKey(name: 'skill_progress') List<SkillProgressEntry> skillProgress,
  });
}

/// @nodoc
class _$SessionProgressDetailCopyWithImpl<
  $Res,
  $Val extends SessionProgressDetail
>
    implements $SessionProgressDetailCopyWith<$Res> {
  _$SessionProgressDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionProgressDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionProgress = null, Object? skillProgress = null}) {
    return _then(
      _value.copyWith(
            sessionProgress: null == sessionProgress
                ? _value.sessionProgress
                : sessionProgress // ignore: cast_nullable_to_non_nullable
                      as List<SessionProgressEntry>,
            skillProgress: null == skillProgress
                ? _value.skillProgress
                : skillProgress // ignore: cast_nullable_to_non_nullable
                      as List<SkillProgressEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionProgressDetailImplCopyWith<$Res>
    implements $SessionProgressDetailCopyWith<$Res> {
  factory _$$SessionProgressDetailImplCopyWith(
    _$SessionProgressDetailImpl value,
    $Res Function(_$SessionProgressDetailImpl) then,
  ) = __$$SessionProgressDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'session_progress')
    List<SessionProgressEntry> sessionProgress,
    @JsonKey(name: 'skill_progress') List<SkillProgressEntry> skillProgress,
  });
}

/// @nodoc
class __$$SessionProgressDetailImplCopyWithImpl<$Res>
    extends
        _$SessionProgressDetailCopyWithImpl<$Res, _$SessionProgressDetailImpl>
    implements _$$SessionProgressDetailImplCopyWith<$Res> {
  __$$SessionProgressDetailImplCopyWithImpl(
    _$SessionProgressDetailImpl _value,
    $Res Function(_$SessionProgressDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionProgressDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionProgress = null, Object? skillProgress = null}) {
    return _then(
      _$SessionProgressDetailImpl(
        sessionProgress: null == sessionProgress
            ? _value._sessionProgress
            : sessionProgress // ignore: cast_nullable_to_non_nullable
                  as List<SessionProgressEntry>,
        skillProgress: null == skillProgress
            ? _value._skillProgress
            : skillProgress // ignore: cast_nullable_to_non_nullable
                  as List<SkillProgressEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionProgressDetailImpl implements _SessionProgressDetail {
  const _$SessionProgressDetailImpl({
    @JsonKey(name: 'session_progress')
    final List<SessionProgressEntry> sessionProgress =
        const <SessionProgressEntry>[],
    @JsonKey(name: 'skill_progress')
    final List<SkillProgressEntry> skillProgress = const <SkillProgressEntry>[],
  }) : _sessionProgress = sessionProgress,
       _skillProgress = skillProgress;

  factory _$SessionProgressDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionProgressDetailImplFromJson(json);

  final List<SessionProgressEntry> _sessionProgress;
  @override
  @JsonKey(name: 'session_progress')
  List<SessionProgressEntry> get sessionProgress {
    if (_sessionProgress is EqualUnmodifiableListView) return _sessionProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionProgress);
  }

  final List<SkillProgressEntry> _skillProgress;
  @override
  @JsonKey(name: 'skill_progress')
  List<SkillProgressEntry> get skillProgress {
    if (_skillProgress is EqualUnmodifiableListView) return _skillProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillProgress);
  }

  @override
  String toString() {
    return 'SessionProgressDetail(sessionProgress: $sessionProgress, skillProgress: $skillProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionProgressDetailImpl &&
            const DeepCollectionEquality().equals(
              other._sessionProgress,
              _sessionProgress,
            ) &&
            const DeepCollectionEquality().equals(
              other._skillProgress,
              _skillProgress,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_sessionProgress),
    const DeepCollectionEquality().hash(_skillProgress),
  );

  /// Create a copy of SessionProgressDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionProgressDetailImplCopyWith<_$SessionProgressDetailImpl>
  get copyWith =>
      __$$SessionProgressDetailImplCopyWithImpl<_$SessionProgressDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionProgressDetailImplToJson(this);
  }
}

abstract class _SessionProgressDetail implements SessionProgressDetail {
  const factory _SessionProgressDetail({
    @JsonKey(name: 'session_progress')
    final List<SessionProgressEntry> sessionProgress,
    @JsonKey(name: 'skill_progress')
    final List<SkillProgressEntry> skillProgress,
  }) = _$SessionProgressDetailImpl;

  factory _SessionProgressDetail.fromJson(Map<String, dynamic> json) =
      _$SessionProgressDetailImpl.fromJson;

  @override
  @JsonKey(name: 'session_progress')
  List<SessionProgressEntry> get sessionProgress;
  @override
  @JsonKey(name: 'skill_progress')
  List<SkillProgressEntry> get skillProgress;

  /// Create a copy of SessionProgressDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionProgressDetailImplCopyWith<_$SessionProgressDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SessionProgressEntry _$SessionProgressEntryFromJson(Map<String, dynamic> json) {
  return _SessionProgressEntry.fromJson(json);
}

/// @nodoc
mixin _$SessionProgressEntry {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SessionProgressEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionProgressEntryCopyWith<SessionProgressEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionProgressEntryCopyWith<$Res> {
  factory $SessionProgressEntryCopyWith(
    SessionProgressEntry value,
    $Res Function(SessionProgressEntry) then,
  ) = _$SessionProgressEntryCopyWithImpl<$Res, SessionProgressEntry>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    String? status,
    int? score,
    String? notes,
  });
}

/// @nodoc
class _$SessionProgressEntryCopyWithImpl<
  $Res,
  $Val extends SessionProgressEntry
>
    implements $SessionProgressEntryCopyWith<$Res> {
  _$SessionProgressEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
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
abstract class _$$SessionProgressEntryImplCopyWith<$Res>
    implements $SessionProgressEntryCopyWith<$Res> {
  factory _$$SessionProgressEntryImplCopyWith(
    _$SessionProgressEntryImpl value,
    $Res Function(_$SessionProgressEntryImpl) then,
  ) = __$$SessionProgressEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    String? status,
    int? score,
    String? notes,
  });
}

/// @nodoc
class __$$SessionProgressEntryImplCopyWithImpl<$Res>
    extends _$SessionProgressEntryCopyWithImpl<$Res, _$SessionProgressEntryImpl>
    implements _$$SessionProgressEntryImplCopyWith<$Res> {
  __$$SessionProgressEntryImplCopyWithImpl(
    _$SessionProgressEntryImpl _value,
    $Res Function(_$SessionProgressEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$SessionProgressEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$SessionProgressEntryImpl implements _SessionProgressEntry {
  const _$SessionProgressEntryImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    this.status,
    this.score,
    this.notes,
  });

  factory _$SessionProgressEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionProgressEntryImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  final String? status;
  @override
  final int? score;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SessionProgressEntry(id: $id, studentProfileId: $studentProfileId, status: $status, score: $score, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionProgressEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, studentProfileId, status, score, notes);

  /// Create a copy of SessionProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionProgressEntryImplCopyWith<_$SessionProgressEntryImpl>
  get copyWith =>
      __$$SessionProgressEntryImplCopyWithImpl<_$SessionProgressEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionProgressEntryImplToJson(this);
  }
}

abstract class _SessionProgressEntry implements SessionProgressEntry {
  const factory _SessionProgressEntry({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    final String? status,
    final int? score,
    final String? notes,
  }) = _$SessionProgressEntryImpl;

  factory _SessionProgressEntry.fromJson(Map<String, dynamic> json) =
      _$SessionProgressEntryImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  String? get status;
  @override
  int? get score;
  @override
  String? get notes;

  /// Create a copy of SessionProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionProgressEntryImplCopyWith<_$SessionProgressEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SkillProgressEntry _$SkillProgressEntryFromJson(Map<String, dynamic> json) {
  return _SkillProgressEntry.fromJson(json);
}

/// @nodoc
mixin _$SkillProgressEntry {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  String get levelSkillId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SkillProgressEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillProgressEntryCopyWith<SkillProgressEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillProgressEntryCopyWith<$Res> {
  factory $SkillProgressEntryCopyWith(
    SkillProgressEntry value,
    $Res Function(SkillProgressEntry) then,
  ) = _$SkillProgressEntryCopyWithImpl<$Res, SkillProgressEntry>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson) String levelSkillId,
    String? status,
    int? score,
    String? notes,
  });
}

/// @nodoc
class _$SkillProgressEntryCopyWithImpl<$Res, $Val extends SkillProgressEntry>
    implements $SkillProgressEntryCopyWith<$Res> {
  _$SkillProgressEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? levelSkillId = null,
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
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
            levelSkillId: null == levelSkillId
                ? _value.levelSkillId
                : levelSkillId // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$SkillProgressEntryImplCopyWith<$Res>
    implements $SkillProgressEntryCopyWith<$Res> {
  factory _$$SkillProgressEntryImplCopyWith(
    _$SkillProgressEntryImpl value,
    $Res Function(_$SkillProgressEntryImpl) then,
  ) = __$$SkillProgressEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson) String levelSkillId,
    String? status,
    int? score,
    String? notes,
  });
}

/// @nodoc
class __$$SkillProgressEntryImplCopyWithImpl<$Res>
    extends _$SkillProgressEntryCopyWithImpl<$Res, _$SkillProgressEntryImpl>
    implements _$$SkillProgressEntryImplCopyWith<$Res> {
  __$$SkillProgressEntryImplCopyWithImpl(
    _$SkillProgressEntryImpl _value,
    $Res Function(_$SkillProgressEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? levelSkillId = null,
    Object? status = freezed,
    Object? score = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$SkillProgressEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        levelSkillId: null == levelSkillId
            ? _value.levelSkillId
            : levelSkillId // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$SkillProgressEntryImpl implements _SkillProgressEntry {
  const _$SkillProgressEntryImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required this.levelSkillId,
    this.status,
    this.score,
    this.notes,
  });

  factory _$SkillProgressEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillProgressEntryImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  final String levelSkillId;
  @override
  final String? status;
  @override
  final int? score;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SkillProgressEntry(id: $id, studentProfileId: $studentProfileId, levelSkillId: $levelSkillId, status: $status, score: $score, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillProgressEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.levelSkillId, levelSkillId) ||
                other.levelSkillId == levelSkillId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentProfileId,
    levelSkillId,
    status,
    score,
    notes,
  );

  /// Create a copy of SkillProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillProgressEntryImplCopyWith<_$SkillProgressEntryImpl> get copyWith =>
      __$$SkillProgressEntryImplCopyWithImpl<_$SkillProgressEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillProgressEntryImplToJson(this);
  }
}

abstract class _SkillProgressEntry implements SkillProgressEntry {
  const factory _SkillProgressEntry({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required final String levelSkillId,
    final String? status,
    final int? score,
    final String? notes,
  }) = _$SkillProgressEntryImpl;

  factory _SkillProgressEntry.fromJson(Map<String, dynamic> json) =
      _$SkillProgressEntryImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  String get levelSkillId;
  @override
  String? get status;
  @override
  int? get score;
  @override
  String? get notes;

  /// Create a copy of SkillProgressEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillProgressEntryImplCopyWith<_$SkillProgressEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
