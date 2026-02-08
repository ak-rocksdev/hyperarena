// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VenueReview _$VenueReviewFromJson(Map<String, dynamic> json) {
  return _VenueReview.fromJson(json);
}

/// @nodoc
mixin _$VenueReview {
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get reviewerName => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String? get courtName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this VenueReview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueReviewCopyWith<VenueReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueReviewCopyWith<$Res> {
  factory $VenueReviewCopyWith(
    VenueReview value,
    $Res Function(VenueReview) then,
  ) = _$VenueReviewCopyWithImpl<$Res, VenueReview>;
  @useResult
  $Res call({
    String id,
    String reviewerId,
    String reviewerName,
    String venueId,
    String venueName,
    String bookingId,
    String? courtName,
    DateTime date,
    int rating,
    String? comment,
  });
}

/// @nodoc
class _$VenueReviewCopyWithImpl<$Res, $Val extends VenueReview>
    implements $VenueReviewCopyWith<$Res> {
  _$VenueReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? reviewerName = null,
    Object? venueId = null,
    Object? venueName = null,
    Object? bookingId = null,
    Object? courtName = freezed,
    Object? date = null,
    Object? rating = null,
    Object? comment = freezed,
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
            venueId: null == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String,
            courtName: freezed == courtName
                ? _value.courtName
                : courtName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VenueReviewImplCopyWith<$Res>
    implements $VenueReviewCopyWith<$Res> {
  factory _$$VenueReviewImplCopyWith(
    _$VenueReviewImpl value,
    $Res Function(_$VenueReviewImpl) then,
  ) = __$$VenueReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reviewerId,
    String reviewerName,
    String venueId,
    String venueName,
    String bookingId,
    String? courtName,
    DateTime date,
    int rating,
    String? comment,
  });
}

/// @nodoc
class __$$VenueReviewImplCopyWithImpl<$Res>
    extends _$VenueReviewCopyWithImpl<$Res, _$VenueReviewImpl>
    implements _$$VenueReviewImplCopyWith<$Res> {
  __$$VenueReviewImplCopyWithImpl(
    _$VenueReviewImpl _value,
    $Res Function(_$VenueReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VenueReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? reviewerName = null,
    Object? venueId = null,
    Object? venueName = null,
    Object? bookingId = null,
    Object? courtName = freezed,
    Object? date = null,
    Object? rating = null,
    Object? comment = freezed,
  }) {
    return _then(
      _$VenueReviewImpl(
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
        venueId: null == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String,
        courtName: freezed == courtName
            ? _value.courtName
            : courtName // ignore: cast_nullable_to_non_nullable
                  as String?,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueReviewImpl implements _VenueReview {
  const _$VenueReviewImpl({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.venueId,
    required this.venueName,
    required this.bookingId,
    this.courtName,
    required this.date,
    required this.rating,
    this.comment,
  });

  factory _$VenueReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final String reviewerName;
  @override
  final String venueId;
  @override
  final String venueName;
  @override
  final String bookingId;
  @override
  final String? courtName;
  @override
  final DateTime date;
  @override
  final int rating;
  @override
  final String? comment;

  @override
  String toString() {
    return 'VenueReview(id: $id, reviewerId: $reviewerId, reviewerName: $reviewerName, venueId: $venueId, venueName: $venueName, bookingId: $bookingId, courtName: $courtName, date: $date, rating: $rating, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.courtName, courtName) ||
                other.courtName == courtName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reviewerId,
    reviewerName,
    venueId,
    venueName,
    bookingId,
    courtName,
    date,
    rating,
    comment,
  );

  /// Create a copy of VenueReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueReviewImplCopyWith<_$VenueReviewImpl> get copyWith =>
      __$$VenueReviewImplCopyWithImpl<_$VenueReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueReviewImplToJson(this);
  }
}

abstract class _VenueReview implements VenueReview {
  const factory _VenueReview({
    required final String id,
    required final String reviewerId,
    required final String reviewerName,
    required final String venueId,
    required final String venueName,
    required final String bookingId,
    final String? courtName,
    required final DateTime date,
    required final int rating,
    final String? comment,
  }) = _$VenueReviewImpl;

  factory _VenueReview.fromJson(Map<String, dynamic> json) =
      _$VenueReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  String get reviewerName;
  @override
  String get venueId;
  @override
  String get venueName;
  @override
  String get bookingId;
  @override
  String? get courtName;
  @override
  DateTime get date;
  @override
  int get rating;
  @override
  String? get comment;

  /// Create a copy of VenueReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueReviewImplCopyWith<_$VenueReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
