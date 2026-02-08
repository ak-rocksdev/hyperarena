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
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get reviewerName => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String get coachName => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionTitle => throw _privateConstructorUsedError;
  Sport get sport => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;

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
    String id,
    String reviewerId,
    String reviewerName,
    String coachId,
    String coachName,
    String sessionId,
    String sessionTitle,
    Sport sport,
    DateTime date,
    int rating,
    String? comment,
    bool isAnonymous,
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
    Object? reviewerId = null,
    Object? reviewerName = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? sessionId = null,
    Object? sessionTitle = null,
    Object? sport = null,
    Object? date = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewerId: null == reviewerId
                ? _value.reviewerId
                : reviewerId // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewerName: null == reviewerName
                ? _value.reviewerName
                : reviewerName // ignore: cast_nullable_to_non_nullable
                      as String,
            coachId: null == coachId
                ? _value.coachId
                : coachId // ignore: cast_nullable_to_non_nullable
                      as String,
            coachName: null == coachName
                ? _value.coachName
                : coachName // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionTitle: null == sessionTitle
                ? _value.sessionTitle
                : sessionTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            sport: null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAnonymous: null == isAnonymous
                ? _value.isAnonymous
                : isAnonymous // ignore: cast_nullable_to_non_nullable
                      as bool,
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
    String id,
    String reviewerId,
    String reviewerName,
    String coachId,
    String coachName,
    String sessionId,
    String sessionTitle,
    Sport sport,
    DateTime date,
    int rating,
    String? comment,
    bool isAnonymous,
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
    Object? reviewerId = null,
    Object? reviewerName = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? sessionId = null,
    Object? sessionTitle = null,
    Object? sport = null,
    Object? date = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerName: null == reviewerName
            ? _value.reviewerName
            : reviewerName // ignore: cast_nullable_to_non_nullable
                  as String,
        coachId: null == coachId
            ? _value.coachId
            : coachId // ignore: cast_nullable_to_non_nullable
                  as String,
        coachName: null == coachName
            ? _value.coachName
            : coachName // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionTitle: null == sessionTitle
            ? _value.sessionTitle
            : sessionTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        sport: null == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAnonymous: null == isAnonymous
            ? _value.isAnonymous
            : isAnonymous // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.coachId,
    required this.coachName,
    required this.sessionId,
    required this.sessionTitle,
    required this.sport,
    required this.date,
    required this.rating,
    this.comment,
    this.isAnonymous = false,
  });

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final String reviewerName;
  @override
  final String coachId;
  @override
  final String coachName;
  @override
  final String sessionId;
  @override
  final String sessionTitle;
  @override
  final Sport sport;
  @override
  final DateTime date;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  @JsonKey()
  final bool isAnonymous;

  @override
  String toString() {
    return 'Review(id: $id, reviewerId: $reviewerId, reviewerName: $reviewerName, coachId: $coachId, coachName: $coachName, sessionId: $sessionId, sessionTitle: $sessionTitle, sport: $sport, date: $date, rating: $rating, comment: $comment, isAnonymous: $isAnonymous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.coachName, coachName) ||
                other.coachName == coachName) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionTitle, sessionTitle) ||
                other.sessionTitle == sessionTitle) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reviewerId,
    reviewerName,
    coachId,
    coachName,
    sessionId,
    sessionTitle,
    sport,
    date,
    rating,
    comment,
    isAnonymous,
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
    required final String id,
    required final String reviewerId,
    required final String reviewerName,
    required final String coachId,
    required final String coachName,
    required final String sessionId,
    required final String sessionTitle,
    required final Sport sport,
    required final DateTime date,
    required final int rating,
    final String? comment,
    final bool isAnonymous,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  String get reviewerName;
  @override
  String get coachId;
  @override
  String get coachName;
  @override
  String get sessionId;
  @override
  String get sessionTitle;
  @override
  Sport get sport;
  @override
  DateTime get date;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  bool get isAnonymous;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
