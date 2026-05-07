// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketplaceBooking _$MarketplaceBookingFromJson(Map<String, dynamic> json) {
  return _MarketplaceBooking.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceBooking {
  @JsonKey(name: 'booking_id', fromJson: idFromJson)
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
  DateTime get bookedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  BookingSession get session => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_review')
  bool get canReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_blocked_reason')
  String? get reviewBlockedReason => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceBookingCopyWith<MarketplaceBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceBookingCopyWith<$Res> {
  factory $MarketplaceBookingCopyWith(
    MarketplaceBooking value,
    $Res Function(MarketplaceBooking) then,
  ) = _$MarketplaceBookingCopyWithImpl<$Res, MarketplaceBooking>;
  @useResult
  $Res call({
    @JsonKey(name: 'booking_id', fromJson: idFromJson) String bookingId,
    @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
    DateTime bookedAt,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    BookingSession session,
    @JsonKey(name: 'can_review') bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
  });

  $BookingSessionCopyWith<$Res> get session;
}

/// @nodoc
class _$MarketplaceBookingCopyWithImpl<$Res, $Val extends MarketplaceBooking>
    implements $MarketplaceBookingCopyWith<$Res> {
  _$MarketplaceBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookedAt = null,
    Object? paymentStatus = freezed,
    Object? session = null,
    Object? canReview = null,
    Object? reviewBlockedReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String,
            bookedAt: null == bookedAt
                ? _value.bookedAt
                : bookedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            session: null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as BookingSession,
            canReview: null == canReview
                ? _value.canReview
                : canReview // ignore: cast_nullable_to_non_nullable
                      as bool,
            reviewBlockedReason: freezed == reviewBlockedReason
                ? _value.reviewBlockedReason
                : reviewBlockedReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingSessionCopyWith<$Res> get session {
    return $BookingSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceBookingImplCopyWith<$Res>
    implements $MarketplaceBookingCopyWith<$Res> {
  factory _$$MarketplaceBookingImplCopyWith(
    _$MarketplaceBookingImpl value,
    $Res Function(_$MarketplaceBookingImpl) then,
  ) = __$$MarketplaceBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'booking_id', fromJson: idFromJson) String bookingId,
    @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
    DateTime bookedAt,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    BookingSession session,
    @JsonKey(name: 'can_review') bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
  });

  @override
  $BookingSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$MarketplaceBookingImplCopyWithImpl<$Res>
    extends _$MarketplaceBookingCopyWithImpl<$Res, _$MarketplaceBookingImpl>
    implements _$$MarketplaceBookingImplCopyWith<$Res> {
  __$$MarketplaceBookingImplCopyWithImpl(
    _$MarketplaceBookingImpl _value,
    $Res Function(_$MarketplaceBookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? bookedAt = null,
    Object? paymentStatus = freezed,
    Object? session = null,
    Object? canReview = null,
    Object? reviewBlockedReason = freezed,
  }) {
    return _then(
      _$MarketplaceBookingImpl(
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookedAt: null == bookedAt
            ? _value.bookedAt
            : bookedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as BookingSession,
        canReview: null == canReview
            ? _value.canReview
            : canReview // ignore: cast_nullable_to_non_nullable
                  as bool,
        reviewBlockedReason: freezed == reviewBlockedReason
            ? _value.reviewBlockedReason
            : reviewBlockedReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceBookingImpl implements _MarketplaceBooking {
  const _$MarketplaceBookingImpl({
    @JsonKey(name: 'booking_id', fromJson: idFromJson) required this.bookingId,
    @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
    required this.bookedAt,
    @JsonKey(name: 'payment_status') this.paymentStatus,
    required this.session,
    @JsonKey(name: 'can_review') this.canReview = false,
    @JsonKey(name: 'review_blocked_reason') this.reviewBlockedReason,
  });

  factory _$MarketplaceBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceBookingImplFromJson(json);

  @override
  @JsonKey(name: 'booking_id', fromJson: idFromJson)
  final String bookingId;
  @override
  @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
  final DateTime bookedAt;
  @override
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @override
  final BookingSession session;
  @override
  @JsonKey(name: 'can_review')
  final bool canReview;
  @override
  @JsonKey(name: 'review_blocked_reason')
  final String? reviewBlockedReason;

  @override
  String toString() {
    return 'MarketplaceBooking(bookingId: $bookingId, bookedAt: $bookedAt, paymentStatus: $paymentStatus, session: $session, canReview: $canReview, reviewBlockedReason: $reviewBlockedReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceBookingImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.canReview, canReview) ||
                other.canReview == canReview) &&
            (identical(other.reviewBlockedReason, reviewBlockedReason) ||
                other.reviewBlockedReason == reviewBlockedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bookingId,
    bookedAt,
    paymentStatus,
    session,
    canReview,
    reviewBlockedReason,
  );

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceBookingImplCopyWith<_$MarketplaceBookingImpl> get copyWith =>
      __$$MarketplaceBookingImplCopyWithImpl<_$MarketplaceBookingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceBookingImplToJson(this);
  }
}

abstract class _MarketplaceBooking implements MarketplaceBooking {
  const factory _MarketplaceBooking({
    @JsonKey(name: 'booking_id', fromJson: idFromJson)
    required final String bookingId,
    @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
    required final DateTime bookedAt,
    @JsonKey(name: 'payment_status') final String? paymentStatus,
    required final BookingSession session,
    @JsonKey(name: 'can_review') final bool canReview,
    @JsonKey(name: 'review_blocked_reason') final String? reviewBlockedReason,
  }) = _$MarketplaceBookingImpl;

  factory _MarketplaceBooking.fromJson(Map<String, dynamic> json) =
      _$MarketplaceBookingImpl.fromJson;

  @override
  @JsonKey(name: 'booking_id', fromJson: idFromJson)
  String get bookingId;
  @override
  @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
  DateTime get bookedAt;
  @override
  @JsonKey(name: 'payment_status')
  String? get paymentStatus;
  @override
  BookingSession get session;
  @override
  @JsonKey(name: 'can_review')
  bool get canReview;
  @override
  @JsonKey(name: 'review_blocked_reason')
  String? get reviewBlockedReason;

  /// Create a copy of MarketplaceBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceBookingImplCopyWith<_$MarketplaceBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingSession _$BookingSessionFromJson(Map<String, dynamic> json) {
  return _BookingSession.fromJson(json);
}

/// @nodoc
mixin _$BookingSession {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
  DateTime get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  BookingTenant? get tenant => throw _privateConstructorUsedError;
  BookingVenue? get venue => throw _privateConstructorUsedError;
  List<BookingCoach> get coaches => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_title')
  String? get displayTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_path')
  String? get photoPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;

  /// Serializes this BookingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingSessionCopyWith<BookingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingSessionCopyWith<$Res> {
  factory $BookingSessionCopyWith(
    BookingSession value,
    $Res Function(BookingSession) then,
  ) = _$BookingSessionCopyWithImpl<$Res, BookingSession>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    BookingTenant? tenant,
    BookingVenue? venue,
    List<BookingCoach> coaches,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });

  $BookingTenantCopyWith<$Res>? get tenant;
  $BookingVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class _$BookingSessionCopyWithImpl<$Res, $Val extends BookingSession>
    implements $BookingSessionCopyWith<$Res> {
  _$BookingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? tenant = freezed,
    Object? venue = freezed,
    Object? coaches = null,
    Object? title = freezed,
    Object? displayTitle = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
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
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as BookingTenant?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as BookingVenue?,
            coaches: null == coaches
                ? _value.coaches
                : coaches // ignore: cast_nullable_to_non_nullable
                      as List<BookingCoach>,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayTitle: freezed == displayTitle
                ? _value.displayTitle
                : displayTitle // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingTenantCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $BookingTenantCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingVenueCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $BookingVenueCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingSessionImplCopyWith<$Res>
    implements $BookingSessionCopyWith<$Res> {
  factory _$$BookingSessionImplCopyWith(
    _$BookingSessionImpl value,
    $Res Function(_$BookingSessionImpl) then,
  ) = __$$BookingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    BookingTenant? tenant,
    BookingVenue? venue,
    List<BookingCoach> coaches,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });

  @override
  $BookingTenantCopyWith<$Res>? get tenant;
  @override
  $BookingVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$BookingSessionImplCopyWithImpl<$Res>
    extends _$BookingSessionCopyWithImpl<$Res, _$BookingSessionImpl>
    implements _$$BookingSessionImplCopyWith<$Res> {
  __$$BookingSessionImplCopyWithImpl(
    _$BookingSessionImpl _value,
    $Res Function(_$BookingSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? tenant = freezed,
    Object? venue = freezed,
    Object? coaches = null,
    Object? title = freezed,
    Object? displayTitle = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(
      _$BookingSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
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
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as BookingTenant?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as BookingVenue?,
        coaches: null == coaches
            ? _value._coaches
            : coaches // ignore: cast_nullable_to_non_nullable
                  as List<BookingCoach>,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayTitle: freezed == displayTitle
            ? _value.displayTitle
            : displayTitle // ignore: cast_nullable_to_non_nullable
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
class _$BookingSessionImpl implements _BookingSession {
  const _$BookingSessionImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required this.startAt,
    @JsonKey(name: 'duration_minutes') required this.durationMinutes,
    this.tenant,
    this.venue,
    final List<BookingCoach> coaches = const <BookingCoach>[],
    this.title,
    @JsonKey(name: 'display_title') this.displayTitle,
    @JsonKey(name: 'photo_path') this.photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) : _coaches = coaches,
       _photoUrls = photoUrls;

  factory _$BookingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingSessionImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? type;
  @override
  @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
  final DateTime startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  final BookingTenant? tenant;
  @override
  final BookingVenue? venue;
  final List<BookingCoach> _coaches;
  @override
  @JsonKey()
  List<BookingCoach> get coaches {
    if (_coaches is EqualUnmodifiableListView) return _coaches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coaches);
  }

  @override
  final String? title;
  @override
  @JsonKey(name: 'display_title')
  final String? displayTitle;
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
    return 'BookingSession(id: $id, name: $name, type: $type, startAt: $startAt, durationMinutes: $durationMinutes, tenant: $tenant, venue: $venue, coaches: $coaches, title: $title, displayTitle: $displayTitle, photoPath: $photoPath, photoUrls: $photoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            const DeepCollectionEquality().equals(other._coaches, _coaches) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
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
    name,
    type,
    startAt,
    durationMinutes,
    tenant,
    venue,
    const DeepCollectionEquality().hash(_coaches),
    title,
    displayTitle,
    photoPath,
    const DeepCollectionEquality().hash(_photoUrls),
  );

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingSessionImplCopyWith<_$BookingSessionImpl> get copyWith =>
      __$$BookingSessionImplCopyWithImpl<_$BookingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingSessionImplToJson(this);
  }
}

abstract class _BookingSession implements BookingSession {
  const factory _BookingSession({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required final DateTime startAt,
    @JsonKey(name: 'duration_minutes') required final int durationMinutes,
    final BookingTenant? tenant,
    final BookingVenue? venue,
    final List<BookingCoach> coaches,
    final String? title,
    @JsonKey(name: 'display_title') final String? displayTitle,
    @JsonKey(name: 'photo_path') final String? photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) = _$BookingSessionImpl;

  factory _BookingSession.fromJson(Map<String, dynamic> json) =
      _$BookingSessionImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get type;
  @override
  @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
  DateTime get startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  BookingTenant? get tenant;
  @override
  BookingVenue? get venue;
  @override
  List<BookingCoach> get coaches;
  @override
  String? get title;
  @override
  @JsonKey(name: 'display_title')
  String? get displayTitle;
  @override
  @JsonKey(name: 'photo_path')
  String? get photoPath;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;

  /// Create a copy of BookingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingSessionImplCopyWith<_$BookingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingTenant _$BookingTenantFromJson(Map<String, dynamic> json) {
  return _BookingTenant.fromJson(json);
}

/// @nodoc
mixin _$BookingTenant {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_color')
  String? get brandColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls => throw _privateConstructorUsedError;

  /// Serializes this BookingTenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingTenantCopyWith<BookingTenant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingTenantCopyWith<$Res> {
  factory $BookingTenantCopyWith(
    BookingTenant value,
    $Res Function(BookingTenant) then,
  ) = _$BookingTenantCopyWithImpl<$Res, BookingTenant>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? slug,
    @JsonKey(name: 'brand_color') String? brandColor,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
  });
}

/// @nodoc
class _$BookingTenantCopyWithImpl<$Res, $Val extends BookingTenant>
    implements $BookingTenantCopyWith<$Res> {
  _$BookingTenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? brandColor = freezed,
    Object? logoUrls = freezed,
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
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandColor: freezed == brandColor
                ? _value.brandColor
                : brandColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrls: freezed == logoUrls
                ? _value.logoUrls
                : logoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingTenantImplCopyWith<$Res>
    implements $BookingTenantCopyWith<$Res> {
  factory _$$BookingTenantImplCopyWith(
    _$BookingTenantImpl value,
    $Res Function(_$BookingTenantImpl) then,
  ) = __$$BookingTenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? slug,
    @JsonKey(name: 'brand_color') String? brandColor,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
  });
}

/// @nodoc
class __$$BookingTenantImplCopyWithImpl<$Res>
    extends _$BookingTenantCopyWithImpl<$Res, _$BookingTenantImpl>
    implements _$$BookingTenantImplCopyWith<$Res> {
  __$$BookingTenantImplCopyWithImpl(
    _$BookingTenantImpl _value,
    $Res Function(_$BookingTenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? brandColor = freezed,
    Object? logoUrls = freezed,
  }) {
    return _then(
      _$BookingTenantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandColor: freezed == brandColor
            ? _value.brandColor
            : brandColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrls: freezed == logoUrls
            ? _value._logoUrls
            : logoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingTenantImpl implements _BookingTenant {
  const _$BookingTenantImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.slug,
    @JsonKey(name: 'brand_color') this.brandColor,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
  }) : _logoUrls = logoUrls;

  factory _$BookingTenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingTenantImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? slug;
  @override
  @JsonKey(name: 'brand_color')
  final String? brandColor;
  final Map<String, String>? _logoUrls;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls {
    final value = _logoUrls;
    if (value == null) return null;
    if (_logoUrls is EqualUnmodifiableMapView) return _logoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BookingTenant(id: $id, name: $name, slug: $slug, brandColor: $brandColor, logoUrls: $logoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingTenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.brandColor, brandColor) ||
                other.brandColor == brandColor) &&
            const DeepCollectionEquality().equals(other._logoUrls, _logoUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    brandColor,
    const DeepCollectionEquality().hash(_logoUrls),
  );

  /// Create a copy of BookingTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingTenantImplCopyWith<_$BookingTenantImpl> get copyWith =>
      __$$BookingTenantImplCopyWithImpl<_$BookingTenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingTenantImplToJson(this);
  }
}

abstract class _BookingTenant implements BookingTenant {
  const factory _BookingTenant({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? slug,
    @JsonKey(name: 'brand_color') final String? brandColor,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
  }) = _$BookingTenantImpl;

  factory _BookingTenant.fromJson(Map<String, dynamic> json) =
      _$BookingTenantImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get slug;
  @override
  @JsonKey(name: 'brand_color')
  String? get brandColor;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls;

  /// Create a copy of BookingTenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingTenantImplCopyWith<_$BookingTenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingVenue _$BookingVenueFromJson(Map<String, dynamic> json) {
  return _BookingVenue.fromJson(json);
}

/// @nodoc
mixin _$BookingVenue {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  BookingVenueLocation? get location => throw _privateConstructorUsedError;

  /// Serializes this BookingVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingVenueCopyWith<BookingVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingVenueCopyWith<$Res> {
  factory $BookingVenueCopyWith(
    BookingVenue value,
    $Res Function(BookingVenue) then,
  ) = _$BookingVenueCopyWithImpl<$Res, BookingVenue>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    BookingVenueLocation? location,
  });

  $BookingVenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$BookingVenueCopyWithImpl<$Res, $Val extends BookingVenue>
    implements $BookingVenueCopyWith<$Res> {
  _$BookingVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingVenue
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
                      as BookingVenueLocation?,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingVenueLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $BookingVenueLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingVenueImplCopyWith<$Res>
    implements $BookingVenueCopyWith<$Res> {
  factory _$$BookingVenueImplCopyWith(
    _$BookingVenueImpl value,
    $Res Function(_$BookingVenueImpl) then,
  ) = __$$BookingVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    BookingVenueLocation? location,
  });

  @override
  $BookingVenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$BookingVenueImplCopyWithImpl<$Res>
    extends _$BookingVenueCopyWithImpl<$Res, _$BookingVenueImpl>
    implements _$$BookingVenueImplCopyWith<$Res> {
  __$$BookingVenueImplCopyWithImpl(
    _$BookingVenueImpl _value,
    $Res Function(_$BookingVenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
  }) {
    return _then(
      _$BookingVenueImpl(
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
                  as BookingVenueLocation?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingVenueImpl implements _BookingVenue {
  const _$BookingVenueImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.location,
  });

  factory _$BookingVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingVenueImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final BookingVenueLocation? location;

  @override
  String toString() {
    return 'BookingVenue(id: $id, name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingVenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, location);

  /// Create a copy of BookingVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingVenueImplCopyWith<_$BookingVenueImpl> get copyWith =>
      __$$BookingVenueImplCopyWithImpl<_$BookingVenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingVenueImplToJson(this);
  }
}

abstract class _BookingVenue implements BookingVenue {
  const factory _BookingVenue({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final BookingVenueLocation? location,
  }) = _$BookingVenueImpl;

  factory _BookingVenue.fromJson(Map<String, dynamic> json) =
      _$BookingVenueImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  BookingVenueLocation? get location;

  /// Create a copy of BookingVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingVenueImplCopyWith<_$BookingVenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingVenueLocation _$BookingVenueLocationFromJson(Map<String, dynamic> json) {
  return _BookingVenueLocation.fromJson(json);
}

/// @nodoc
mixin _$BookingVenueLocation {
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lng => throw _privateConstructorUsedError;

  /// Serializes this BookingVenueLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingVenueLocationCopyWith<BookingVenueLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingVenueLocationCopyWith<$Res> {
  factory $BookingVenueLocationCopyWith(
    BookingVenueLocation value,
    $Res Function(BookingVenueLocation) then,
  ) = _$BookingVenueLocationCopyWithImpl<$Res, BookingVenueLocation>;
  @useResult
  $Res call({
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class _$BookingVenueLocationCopyWithImpl<
  $Res,
  $Val extends BookingVenueLocation
>
    implements $BookingVenueLocationCopyWith<$Res> {
  _$BookingVenueLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _value.copyWith(
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
abstract class _$$BookingVenueLocationImplCopyWith<$Res>
    implements $BookingVenueLocationCopyWith<$Res> {
  factory _$$BookingVenueLocationImplCopyWith(
    _$BookingVenueLocationImpl value,
    $Res Function(_$BookingVenueLocationImpl) then,
  ) = __$$BookingVenueLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class __$$BookingVenueLocationImplCopyWithImpl<$Res>
    extends _$BookingVenueLocationCopyWithImpl<$Res, _$BookingVenueLocationImpl>
    implements _$$BookingVenueLocationImplCopyWith<$Res> {
  __$$BookingVenueLocationImplCopyWithImpl(
    _$BookingVenueLocationImpl _value,
    $Res Function(_$BookingVenueLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _$BookingVenueLocationImpl(
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
class _$BookingVenueLocationImpl implements _BookingVenueLocation {
  const _$BookingVenueLocationImpl({
    this.address,
    @JsonKey(fromJson: latLngFromJson) this.lat,
    @JsonKey(fromJson: latLngFromJson) this.lng,
  });

  factory _$BookingVenueLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingVenueLocationImplFromJson(json);

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
    return 'BookingVenueLocation(address: $address, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingVenueLocationImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, lat, lng);

  /// Create a copy of BookingVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingVenueLocationImplCopyWith<_$BookingVenueLocationImpl>
  get copyWith =>
      __$$BookingVenueLocationImplCopyWithImpl<_$BookingVenueLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingVenueLocationImplToJson(this);
  }
}

abstract class _BookingVenueLocation implements BookingVenueLocation {
  const factory _BookingVenueLocation({
    final String? address,
    @JsonKey(fromJson: latLngFromJson) final double? lat,
    @JsonKey(fromJson: latLngFromJson) final double? lng,
  }) = _$BookingVenueLocationImpl;

  factory _BookingVenueLocation.fromJson(Map<String, dynamic> json) =
      _$BookingVenueLocationImpl.fromJson;

  @override
  String? get address;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lat;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lng;

  /// Create a copy of BookingVenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingVenueLocationImplCopyWith<_$BookingVenueLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BookingCoach _$BookingCoachFromJson(Map<String, dynamic> json) {
  return _BookingCoach.fromJson(json);
}

/// @nodoc
mixin _$BookingCoach {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;

  /// Serializes this BookingCoach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCoachCopyWith<BookingCoach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCoachCopyWith<$Res> {
  factory $BookingCoachCopyWith(
    BookingCoach value,
    $Res Function(BookingCoach) then,
  ) = _$BookingCoachCopyWithImpl<$Res, BookingCoach>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    @JsonKey(name: 'photo_url') String? photoUrl,
  });
}

/// @nodoc
class _$BookingCoachCopyWithImpl<$Res, $Val extends BookingCoach>
    implements $BookingCoachCopyWith<$Res> {
  _$BookingCoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
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
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingCoachImplCopyWith<$Res>
    implements $BookingCoachCopyWith<$Res> {
  factory _$$BookingCoachImplCopyWith(
    _$BookingCoachImpl value,
    $Res Function(_$BookingCoachImpl) then,
  ) = __$$BookingCoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    @JsonKey(name: 'photo_url') String? photoUrl,
  });
}

/// @nodoc
class __$$BookingCoachImplCopyWithImpl<$Res>
    extends _$BookingCoachCopyWithImpl<$Res, _$BookingCoachImpl>
    implements _$$BookingCoachImplCopyWith<$Res> {
  __$$BookingCoachImplCopyWithImpl(
    _$BookingCoachImpl _value,
    $Res Function(_$BookingCoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
  }) {
    return _then(
      _$BookingCoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingCoachImpl implements _BookingCoach {
  const _$BookingCoachImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    @JsonKey(name: 'photo_url') this.photoUrl,
  });

  factory _$BookingCoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingCoachImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  @override
  String toString() {
    return 'BookingCoach(id: $id, name: $name, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingCoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, photoUrl);

  /// Create a copy of BookingCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingCoachImplCopyWith<_$BookingCoachImpl> get copyWith =>
      __$$BookingCoachImplCopyWithImpl<_$BookingCoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingCoachImplToJson(this);
  }
}

abstract class _BookingCoach implements BookingCoach {
  const factory _BookingCoach({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    @JsonKey(name: 'photo_url') final String? photoUrl,
  }) = _$BookingCoachImpl;

  factory _BookingCoach.fromJson(Map<String, dynamic> json) =
      _$BookingCoachImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;

  /// Create a copy of BookingCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingCoachImplCopyWith<_$BookingCoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
