// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Assessment _$AssessmentFromJson(Map<String, dynamic> json) {
  return _Assessment.fromJson(json);
}

/// @nodoc
mixin _$Assessment {
  String get id => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String get coachName => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get studentName => throw _privateConstructorUsedError;
  Sport get sport => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get technique => throw _privateConstructorUsedError;
  int get stamina => throw _privateConstructorUsedError;
  int get tactics => throw _privateConstructorUsedError;
  int get mentality => throw _privateConstructorUsedError;
  int get consistency => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  LevelTier get recommendedLevel => throw _privateConstructorUsedError;

  /// Serializes this Assessment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssessmentCopyWith<Assessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentCopyWith<$Res> {
  factory $AssessmentCopyWith(
    Assessment value,
    $Res Function(Assessment) then,
  ) = _$AssessmentCopyWithImpl<$Res, Assessment>;
  @useResult
  $Res call({
    String id,
    String coachId,
    String coachName,
    String studentId,
    String studentName,
    Sport sport,
    DateTime date,
    int technique,
    int stamina,
    int tactics,
    int mentality,
    int consistency,
    String? notes,
    LevelTier recommendedLevel,
  });
}

/// @nodoc
class _$AssessmentCopyWithImpl<$Res, $Val extends Assessment>
    implements $AssessmentCopyWith<$Res> {
  _$AssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? sport = null,
    Object? date = null,
    Object? technique = null,
    Object? stamina = null,
    Object? tactics = null,
    Object? mentality = null,
    Object? consistency = null,
    Object? notes = freezed,
    Object? recommendedLevel = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            coachId: null == coachId
                ? _value.coachId
                : coachId // ignore: cast_nullable_to_non_nullable
                      as String,
            coachName: null == coachName
                ? _value.coachName
                : coachName // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentName: null == studentName
                ? _value.studentName
                : studentName // ignore: cast_nullable_to_non_nullable
                      as String,
            sport: null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            technique: null == technique
                ? _value.technique
                : technique // ignore: cast_nullable_to_non_nullable
                      as int,
            stamina: null == stamina
                ? _value.stamina
                : stamina // ignore: cast_nullable_to_non_nullable
                      as int,
            tactics: null == tactics
                ? _value.tactics
                : tactics // ignore: cast_nullable_to_non_nullable
                      as int,
            mentality: null == mentality
                ? _value.mentality
                : mentality // ignore: cast_nullable_to_non_nullable
                      as int,
            consistency: null == consistency
                ? _value.consistency
                : consistency // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendedLevel: null == recommendedLevel
                ? _value.recommendedLevel
                : recommendedLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssessmentImplCopyWith<$Res>
    implements $AssessmentCopyWith<$Res> {
  factory _$$AssessmentImplCopyWith(
    _$AssessmentImpl value,
    $Res Function(_$AssessmentImpl) then,
  ) = __$$AssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String coachId,
    String coachName,
    String studentId,
    String studentName,
    Sport sport,
    DateTime date,
    int technique,
    int stamina,
    int tactics,
    int mentality,
    int consistency,
    String? notes,
    LevelTier recommendedLevel,
  });
}

/// @nodoc
class __$$AssessmentImplCopyWithImpl<$Res>
    extends _$AssessmentCopyWithImpl<$Res, _$AssessmentImpl>
    implements _$$AssessmentImplCopyWith<$Res> {
  __$$AssessmentImplCopyWithImpl(
    _$AssessmentImpl _value,
    $Res Function(_$AssessmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? sport = null,
    Object? date = null,
    Object? technique = null,
    Object? stamina = null,
    Object? tactics = null,
    Object? mentality = null,
    Object? consistency = null,
    Object? notes = freezed,
    Object? recommendedLevel = null,
  }) {
    return _then(
      _$AssessmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        coachId: null == coachId
            ? _value.coachId
            : coachId // ignore: cast_nullable_to_non_nullable
                  as String,
        coachName: null == coachName
            ? _value.coachName
            : coachName // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentName: null == studentName
            ? _value.studentName
            : studentName // ignore: cast_nullable_to_non_nullable
                  as String,
        sport: null == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        technique: null == technique
            ? _value.technique
            : technique // ignore: cast_nullable_to_non_nullable
                  as int,
        stamina: null == stamina
            ? _value.stamina
            : stamina // ignore: cast_nullable_to_non_nullable
                  as int,
        tactics: null == tactics
            ? _value.tactics
            : tactics // ignore: cast_nullable_to_non_nullable
                  as int,
        mentality: null == mentality
            ? _value.mentality
            : mentality // ignore: cast_nullable_to_non_nullable
                  as int,
        consistency: null == consistency
            ? _value.consistency
            : consistency // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendedLevel: null == recommendedLevel
            ? _value.recommendedLevel
            : recommendedLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssessmentImpl implements _Assessment {
  const _$AssessmentImpl({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.studentId,
    required this.studentName,
    required this.sport,
    required this.date,
    required this.technique,
    required this.stamina,
    required this.tactics,
    required this.mentality,
    required this.consistency,
    this.notes,
    this.recommendedLevel = LevelTier.rookie,
  });

  factory _$AssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssessmentImplFromJson(json);

  @override
  final String id;
  @override
  final String coachId;
  @override
  final String coachName;
  @override
  final String studentId;
  @override
  final String studentName;
  @override
  final Sport sport;
  @override
  final DateTime date;
  @override
  final int technique;
  @override
  final int stamina;
  @override
  final int tactics;
  @override
  final int mentality;
  @override
  final int consistency;
  @override
  final String? notes;
  @override
  @JsonKey()
  final LevelTier recommendedLevel;

  @override
  String toString() {
    return 'Assessment(id: $id, coachId: $coachId, coachName: $coachName, studentId: $studentId, studentName: $studentName, sport: $sport, date: $date, technique: $technique, stamina: $stamina, tactics: $tactics, mentality: $mentality, consistency: $consistency, notes: $notes, recommendedLevel: $recommendedLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.coachName, coachName) ||
                other.coachName == coachName) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.technique, technique) ||
                other.technique == technique) &&
            (identical(other.stamina, stamina) || other.stamina == stamina) &&
            (identical(other.tactics, tactics) || other.tactics == tactics) &&
            (identical(other.mentality, mentality) ||
                other.mentality == mentality) &&
            (identical(other.consistency, consistency) ||
                other.consistency == consistency) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recommendedLevel, recommendedLevel) ||
                other.recommendedLevel == recommendedLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    coachId,
    coachName,
    studentId,
    studentName,
    sport,
    date,
    technique,
    stamina,
    tactics,
    mentality,
    consistency,
    notes,
    recommendedLevel,
  );

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentImplCopyWith<_$AssessmentImpl> get copyWith =>
      __$$AssessmentImplCopyWithImpl<_$AssessmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssessmentImplToJson(this);
  }
}

abstract class _Assessment implements Assessment {
  const factory _Assessment({
    required final String id,
    required final String coachId,
    required final String coachName,
    required final String studentId,
    required final String studentName,
    required final Sport sport,
    required final DateTime date,
    required final int technique,
    required final int stamina,
    required final int tactics,
    required final int mentality,
    required final int consistency,
    final String? notes,
    final LevelTier recommendedLevel,
  }) = _$AssessmentImpl;

  factory _Assessment.fromJson(Map<String, dynamic> json) =
      _$AssessmentImpl.fromJson;

  @override
  String get id;
  @override
  String get coachId;
  @override
  String get coachName;
  @override
  String get studentId;
  @override
  String get studentName;
  @override
  Sport get sport;
  @override
  DateTime get date;
  @override
  int get technique;
  @override
  int get stamina;
  @override
  int get tactics;
  @override
  int get mentality;
  @override
  int get consistency;
  @override
  String? get notes;
  @override
  LevelTier get recommendedLevel;

  /// Create a copy of Assessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentImplCopyWith<_$AssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
