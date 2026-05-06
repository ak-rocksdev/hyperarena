// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'coach_id', fromJson: idFromJson)
  String get coachId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError; // Populated only by [Review.fromListJson]; null on submit/my-review.
  String? get coachName => throw _privateConstructorUsedError;
  String? get sessionTitle => throw _privateConstructorUsedError;
  DateTime? get sessionDate => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'coach_id', fromJson: idFromJson) String coachId,
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    int rating,
    String? comment,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? coachName,
    String? sessionTitle,
    DateTime? sessionDate,
  });
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? sessionId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? coachName = freezed,
    Object? sessionTitle = freezed,
    Object? sessionDate = freezed,
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
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            coachName: freezed == coachName
                ? _value.coachName
                : coachName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sessionTitle: freezed == sessionTitle
                ? _value.sessionTitle
                : sessionTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            sessionDate: freezed == sessionDate
                ? _value.sessionDate
                : sessionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'coach_id', fromJson: idFromJson) String coachId,
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    int rating,
    String? comment,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? coachName,
    String? sessionTitle,
    DateTime? sessionDate,
  });
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? sessionId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? coachName = freezed,
    Object? sessionTitle = freezed,
    Object? sessionDate = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        coachId: null == coachId
            ? _value.coachId
            : coachId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        coachName: freezed == coachName
            ? _value.coachName
            : coachName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sessionTitle: freezed == sessionTitle
            ? _value.sessionTitle
            : sessionTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        sessionDate: freezed == sessionDate
            ? _value.sessionDate
            : sessionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'coach_id', fromJson: idFromJson) required this.coachId,
    @JsonKey(name: 'session_id', fromJson: idFromJson) required this.sessionId,
    required this.rating,
    this.comment,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.coachName,
    this.sessionTitle,
    this.sessionDate,
  });

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'coach_id', fromJson: idFromJson)
  final String coachId;
  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  final String sessionId;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  // Populated only by [Review.fromListJson]; null on submit/my-review.
  @override
  final String? coachName;
  @override
  final String? sessionTitle;
  @override
  final DateTime? sessionDate;

  @override
  String toString() {
    return 'Review(id: $id, coachId: $coachId, sessionId: $sessionId, rating: $rating, comment: $comment, createdAt: $createdAt, coachName: $coachName, sessionTitle: $sessionTitle, sessionDate: $sessionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.coachName, coachName) ||
                other.coachName == coachName) &&
            (identical(other.sessionTitle, sessionTitle) ||
                other.sessionTitle == sessionTitle) &&
            (identical(other.sessionDate, sessionDate) ||
                other.sessionDate == sessionDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    coachId,
    sessionId,
    rating,
    comment,
    createdAt,
    coachName,
    sessionTitle,
    sessionDate,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review implements Review {
  const factory _Review({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'coach_id', fromJson: idFromJson)
    required final String coachId,
    @JsonKey(name: 'session_id', fromJson: idFromJson)
    required final String sessionId,
    required final int rating,
    final String? comment,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final String? coachName,
    final String? sessionTitle,
    final DateTime? sessionDate,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'coach_id', fromJson: idFromJson)
  String get coachId;
  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // Populated only by [Review.fromListJson]; null on submit/my-review.
  @override
  String? get coachName;
  @override
  String? get sessionTitle;
  @override
  DateTime? get sessionDate;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
