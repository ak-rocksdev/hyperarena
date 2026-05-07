// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketplaceSession _$MarketplaceSessionFromJson(Map<String, dynamic> json) {
  return _MarketplaceSession.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceSession {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
  DateTime get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError; // Default 0 so a legacy row with null capacity (one historical row
  // surfaced after dropping the end-time filter) doesn't crash the
  // whole list. Card renders "0/N peserta" — visually wrong but
  // recoverable; whole-screen failure is not.
  int get capacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_count')
  int get bookedCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  SessionTenant? get tenant => throw _privateConstructorUsedError;
  MarketplaceSessionVenue? get venue => throw _privateConstructorUsedError;
  List<SessionCoach> get coaches => throw _privateConstructorUsedError;
  List<SessionParticipant> get participants =>
      throw _privateConstructorUsedError;
  bool get isEnrolled => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_title')
  String? get displayTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_path')
  String? get photoPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceSessionCopyWith<MarketplaceSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceSessionCopyWith<$Res> {
  factory $MarketplaceSessionCopyWith(
    MarketplaceSession value,
    $Res Function(MarketplaceSession) then,
  ) = _$MarketplaceSessionCopyWithImpl<$Res, MarketplaceSession>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    int capacity,
    @JsonKey(name: 'booked_count') int bookedCount,
    String? notes,
    SessionTenant? tenant,
    MarketplaceSessionVenue? venue,
    List<SessionCoach> coaches,
    List<SessionParticipant> participants,
    bool isEnrolled,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });

  $SessionTenantCopyWith<$Res>? get tenant;
  $MarketplaceSessionVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class _$MarketplaceSessionCopyWithImpl<$Res, $Val extends MarketplaceSession>
    implements $MarketplaceSessionCopyWith<$Res> {
  _$MarketplaceSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? capacity = null,
    Object? bookedCount = null,
    Object? notes = freezed,
    Object? tenant = freezed,
    Object? venue = freezed,
    Object? coaches = null,
    Object? participants = null,
    Object? isEnrolled = null,
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
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            bookedCount: null == bookedCount
                ? _value.bookedCount
                : bookedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as SessionTenant?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as MarketplaceSessionVenue?,
            coaches: null == coaches
                ? _value.coaches
                : coaches // ignore: cast_nullable_to_non_nullable
                      as List<SessionCoach>,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<SessionParticipant>,
            isEnrolled: null == isEnrolled
                ? _value.isEnrolled
                : isEnrolled // ignore: cast_nullable_to_non_nullable
                      as bool,
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

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionTenantCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $SessionTenantCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarketplaceSessionVenueCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $MarketplaceSessionVenueCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceSessionImplCopyWith<$Res>
    implements $MarketplaceSessionCopyWith<$Res> {
  factory _$$MarketplaceSessionImplCopyWith(
    _$MarketplaceSessionImpl value,
    $Res Function(_$MarketplaceSessionImpl) then,
  ) = __$$MarketplaceSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    DateTime startAt,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    int capacity,
    @JsonKey(name: 'booked_count') int bookedCount,
    String? notes,
    SessionTenant? tenant,
    MarketplaceSessionVenue? venue,
    List<SessionCoach> coaches,
    List<SessionParticipant> participants,
    bool isEnrolled,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });

  @override
  $SessionTenantCopyWith<$Res>? get tenant;
  @override
  $MarketplaceSessionVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$MarketplaceSessionImplCopyWithImpl<$Res>
    extends _$MarketplaceSessionCopyWithImpl<$Res, _$MarketplaceSessionImpl>
    implements _$$MarketplaceSessionImplCopyWith<$Res> {
  __$$MarketplaceSessionImplCopyWithImpl(
    _$MarketplaceSessionImpl _value,
    $Res Function(_$MarketplaceSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? startAt = null,
    Object? durationMinutes = null,
    Object? capacity = null,
    Object? bookedCount = null,
    Object? notes = freezed,
    Object? tenant = freezed,
    Object? venue = freezed,
    Object? coaches = null,
    Object? participants = null,
    Object? isEnrolled = null,
    Object? title = freezed,
    Object? displayTitle = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(
      _$MarketplaceSessionImpl(
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
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        bookedCount: null == bookedCount
            ? _value.bookedCount
            : bookedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as SessionTenant?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as MarketplaceSessionVenue?,
        coaches: null == coaches
            ? _value._coaches
            : coaches // ignore: cast_nullable_to_non_nullable
                  as List<SessionCoach>,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<SessionParticipant>,
        isEnrolled: null == isEnrolled
            ? _value.isEnrolled
            : isEnrolled // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$MarketplaceSessionImpl implements _MarketplaceSession {
  const _$MarketplaceSessionImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.name = 'Sesi Latihan',
    this.type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required this.startAt,
    @JsonKey(name: 'duration_minutes') required this.durationMinutes,
    this.capacity = 0,
    @JsonKey(name: 'booked_count') this.bookedCount = 0,
    this.notes,
    this.tenant,
    this.venue,
    final List<SessionCoach> coaches = const [],
    final List<SessionParticipant> participants = const [],
    this.isEnrolled = false,
    this.title,
    @JsonKey(name: 'display_title') this.displayTitle,
    @JsonKey(name: 'photo_path') this.photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) : _coaches = coaches,
       _participants = participants,
       _photoUrls = photoUrls;

  factory _$MarketplaceSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceSessionImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  final String? type;
  @override
  @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
  final DateTime startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  // Default 0 so a legacy row with null capacity (one historical row
  // surfaced after dropping the end-time filter) doesn't crash the
  // whole list. Card renders "0/N peserta" — visually wrong but
  // recoverable; whole-screen failure is not.
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey(name: 'booked_count')
  final int bookedCount;
  @override
  final String? notes;
  @override
  final SessionTenant? tenant;
  @override
  final MarketplaceSessionVenue? venue;
  final List<SessionCoach> _coaches;
  @override
  @JsonKey()
  List<SessionCoach> get coaches {
    if (_coaches is EqualUnmodifiableListView) return _coaches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coaches);
  }

  final List<SessionParticipant> _participants;
  @override
  @JsonKey()
  List<SessionParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final bool isEnrolled;
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
    return 'MarketplaceSession(id: $id, name: $name, type: $type, startAt: $startAt, durationMinutes: $durationMinutes, capacity: $capacity, bookedCount: $bookedCount, notes: $notes, tenant: $tenant, venue: $venue, coaches: $coaches, participants: $participants, isEnrolled: $isEnrolled, title: $title, displayTitle: $displayTitle, photoPath: $photoPath, photoUrls: $photoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.bookedCount, bookedCount) ||
                other.bookedCount == bookedCount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            const DeepCollectionEquality().equals(other._coaches, _coaches) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.isEnrolled, isEnrolled) ||
                other.isEnrolled == isEnrolled) &&
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
    capacity,
    bookedCount,
    notes,
    tenant,
    venue,
    const DeepCollectionEquality().hash(_coaches),
    const DeepCollectionEquality().hash(_participants),
    isEnrolled,
    title,
    displayTitle,
    photoPath,
    const DeepCollectionEquality().hash(_photoUrls),
  );

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceSessionImplCopyWith<_$MarketplaceSessionImpl> get copyWith =>
      __$$MarketplaceSessionImplCopyWithImpl<_$MarketplaceSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceSessionImplToJson(this);
  }
}

abstract class _MarketplaceSession implements MarketplaceSession {
  const factory _MarketplaceSession({
    @JsonKey(fromJson: idFromJson) required final String id,
    final String name,
    final String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required final DateTime startAt,
    @JsonKey(name: 'duration_minutes') required final int durationMinutes,
    final int capacity,
    @JsonKey(name: 'booked_count') final int bookedCount,
    final String? notes,
    final SessionTenant? tenant,
    final MarketplaceSessionVenue? venue,
    final List<SessionCoach> coaches,
    final List<SessionParticipant> participants,
    final bool isEnrolled,
    final String? title,
    @JsonKey(name: 'display_title') final String? displayTitle,
    @JsonKey(name: 'photo_path') final String? photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) = _$MarketplaceSessionImpl;

  factory _MarketplaceSession.fromJson(Map<String, dynamic> json) =
      _$MarketplaceSessionImpl.fromJson;

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
  int get durationMinutes; // Default 0 so a legacy row with null capacity (one historical row
  // surfaced after dropping the end-time filter) doesn't crash the
  // whole list. Card renders "0/N peserta" — visually wrong but
  // recoverable; whole-screen failure is not.
  @override
  int get capacity;
  @override
  @JsonKey(name: 'booked_count')
  int get bookedCount;
  @override
  String? get notes;
  @override
  SessionTenant? get tenant;
  @override
  MarketplaceSessionVenue? get venue;
  @override
  List<SessionCoach> get coaches;
  @override
  List<SessionParticipant> get participants;
  @override
  bool get isEnrolled;
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

  /// Create a copy of MarketplaceSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceSessionImplCopyWith<_$MarketplaceSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionTenant _$SessionTenantFromJson(Map<String, dynamic> json) {
  return _SessionTenant.fromJson(json);
}

/// @nodoc
mixin _$SessionTenant {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;

  /// Hex color (`#RRGGBB`) for fallback hero rendering when the session
  /// has no photo and falls back to the tenant logo (logo is square,
  /// rendered centered on this color to fill the 16:9 box).
  @JsonKey(name: 'brand_color')
  String? get brandColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls => throw _privateConstructorUsedError;

  /// Serializes this SessionTenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionTenantCopyWith<SessionTenant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionTenantCopyWith<$Res> {
  factory $SessionTenantCopyWith(
    SessionTenant value,
    $Res Function(SessionTenant) then,
  ) = _$SessionTenantCopyWithImpl<$Res, SessionTenant>;
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
class _$SessionTenantCopyWithImpl<$Res, $Val extends SessionTenant>
    implements $SessionTenantCopyWith<$Res> {
  _$SessionTenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionTenant
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
abstract class _$$SessionTenantImplCopyWith<$Res>
    implements $SessionTenantCopyWith<$Res> {
  factory _$$SessionTenantImplCopyWith(
    _$SessionTenantImpl value,
    $Res Function(_$SessionTenantImpl) then,
  ) = __$$SessionTenantImplCopyWithImpl<$Res>;
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
class __$$SessionTenantImplCopyWithImpl<$Res>
    extends _$SessionTenantCopyWithImpl<$Res, _$SessionTenantImpl>
    implements _$$SessionTenantImplCopyWith<$Res> {
  __$$SessionTenantImplCopyWithImpl(
    _$SessionTenantImpl _value,
    $Res Function(_$SessionTenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionTenant
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
      _$SessionTenantImpl(
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
class _$SessionTenantImpl implements _SessionTenant {
  const _$SessionTenantImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.slug,
    @JsonKey(name: 'brand_color') this.brandColor,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
  }) : _logoUrls = logoUrls;

  factory _$SessionTenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionTenantImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? slug;

  /// Hex color (`#RRGGBB`) for fallback hero rendering when the session
  /// has no photo and falls back to the tenant logo (logo is square,
  /// rendered centered on this color to fill the 16:9 box).
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
    return 'SessionTenant(id: $id, name: $name, slug: $slug, brandColor: $brandColor, logoUrls: $logoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionTenantImpl &&
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

  /// Create a copy of SessionTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionTenantImplCopyWith<_$SessionTenantImpl> get copyWith =>
      __$$SessionTenantImplCopyWithImpl<_$SessionTenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionTenantImplToJson(this);
  }
}

abstract class _SessionTenant implements SessionTenant {
  const factory _SessionTenant({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? slug,
    @JsonKey(name: 'brand_color') final String? brandColor,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
  }) = _$SessionTenantImpl;

  factory _SessionTenant.fromJson(Map<String, dynamic> json) =
      _$SessionTenantImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get slug;

  /// Hex color (`#RRGGBB`) for fallback hero rendering when the session
  /// has no photo and falls back to the tenant logo (logo is square,
  /// rendered centered on this color to fill the 16:9 box).
  @override
  @JsonKey(name: 'brand_color')
  String? get brandColor;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls;

  /// Create a copy of SessionTenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionTenantImplCopyWith<_$SessionTenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceSessionVenue _$MarketplaceSessionVenueFromJson(
  Map<String, dynamic> json,
) {
  return _MarketplaceSessionVenue.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceSessionVenue {
  String get name => throw _privateConstructorUsedError;
  VenueLocation? get location => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceSessionVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceSessionVenueCopyWith<MarketplaceSessionVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceSessionVenueCopyWith<$Res> {
  factory $MarketplaceSessionVenueCopyWith(
    MarketplaceSessionVenue value,
    $Res Function(MarketplaceSessionVenue) then,
  ) = _$MarketplaceSessionVenueCopyWithImpl<$Res, MarketplaceSessionVenue>;
  @useResult
  $Res call({String name, VenueLocation? location});

  $VenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$MarketplaceSessionVenueCopyWithImpl<
  $Res,
  $Val extends MarketplaceSessionVenue
>
    implements $MarketplaceSessionVenueCopyWith<$Res> {
  _$MarketplaceSessionVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? location = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as VenueLocation?,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $VenueLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceSessionVenueImplCopyWith<$Res>
    implements $MarketplaceSessionVenueCopyWith<$Res> {
  factory _$$MarketplaceSessionVenueImplCopyWith(
    _$MarketplaceSessionVenueImpl value,
    $Res Function(_$MarketplaceSessionVenueImpl) then,
  ) = __$$MarketplaceSessionVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, VenueLocation? location});

  @override
  $VenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$MarketplaceSessionVenueImplCopyWithImpl<$Res>
    extends
        _$MarketplaceSessionVenueCopyWithImpl<
          $Res,
          _$MarketplaceSessionVenueImpl
        >
    implements _$$MarketplaceSessionVenueImplCopyWith<$Res> {
  __$$MarketplaceSessionVenueImplCopyWithImpl(
    _$MarketplaceSessionVenueImpl _value,
    $Res Function(_$MarketplaceSessionVenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? location = freezed}) {
    return _then(
      _$MarketplaceSessionVenueImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as VenueLocation?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceSessionVenueImpl implements _MarketplaceSessionVenue {
  const _$MarketplaceSessionVenueImpl({required this.name, this.location});

  factory _$MarketplaceSessionVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceSessionVenueImplFromJson(json);

  @override
  final String name;
  @override
  final VenueLocation? location;

  @override
  String toString() {
    return 'MarketplaceSessionVenue(name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceSessionVenueImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, location);

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceSessionVenueImplCopyWith<_$MarketplaceSessionVenueImpl>
  get copyWith =>
      __$$MarketplaceSessionVenueImplCopyWithImpl<
        _$MarketplaceSessionVenueImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceSessionVenueImplToJson(this);
  }
}

abstract class _MarketplaceSessionVenue implements MarketplaceSessionVenue {
  const factory _MarketplaceSessionVenue({
    required final String name,
    final VenueLocation? location,
  }) = _$MarketplaceSessionVenueImpl;

  factory _MarketplaceSessionVenue.fromJson(Map<String, dynamic> json) =
      _$MarketplaceSessionVenueImpl.fromJson;

  @override
  String get name;
  @override
  VenueLocation? get location;

  /// Create a copy of MarketplaceSessionVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceSessionVenueImplCopyWith<_$MarketplaceSessionVenueImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SessionParticipant _$SessionParticipantFromJson(Map<String, dynamic> json) {
  return _SessionParticipant.fromJson(json);
}

/// @nodoc
mixin _$SessionParticipant {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_at')
  DateTime? get bookedAt => throw _privateConstructorUsedError;

  /// Serializes this SessionParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionParticipantCopyWith<SessionParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionParticipantCopyWith<$Res> {
  factory $SessionParticipantCopyWith(
    SessionParticipant value,
    $Res Function(SessionParticipant) then,
  ) = _$SessionParticipantCopyWithImpl<$Res, SessionParticipant>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? photoUrl,
    @JsonKey(name: 'booked_at') DateTime? bookedAt,
  });
}

/// @nodoc
class _$SessionParticipantCopyWithImpl<$Res, $Val extends SessionParticipant>
    implements $SessionParticipantCopyWith<$Res> {
  _$SessionParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? bookedAt = freezed,
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
            bookedAt: freezed == bookedAt
                ? _value.bookedAt
                : bookedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionParticipantImplCopyWith<$Res>
    implements $SessionParticipantCopyWith<$Res> {
  factory _$$SessionParticipantImplCopyWith(
    _$SessionParticipantImpl value,
    $Res Function(_$SessionParticipantImpl) then,
  ) = __$$SessionParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? photoUrl,
    @JsonKey(name: 'booked_at') DateTime? bookedAt,
  });
}

/// @nodoc
class __$$SessionParticipantImplCopyWithImpl<$Res>
    extends _$SessionParticipantCopyWithImpl<$Res, _$SessionParticipantImpl>
    implements _$$SessionParticipantImplCopyWith<$Res> {
  __$$SessionParticipantImplCopyWithImpl(
    _$SessionParticipantImpl _value,
    $Res Function(_$SessionParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? bookedAt = freezed,
  }) {
    return _then(
      _$SessionParticipantImpl(
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
        bookedAt: freezed == bookedAt
            ? _value.bookedAt
            : bookedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionParticipantImpl implements _SessionParticipant {
  const _$SessionParticipantImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.photoUrl,
    @JsonKey(name: 'booked_at') this.bookedAt,
  });

  factory _$SessionParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionParticipantImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? photoUrl;
  @override
  @JsonKey(name: 'booked_at')
  final DateTime? bookedAt;

  @override
  String toString() {
    return 'SessionParticipant(id: $id, name: $name, photoUrl: $photoUrl, bookedAt: $bookedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, photoUrl, bookedAt);

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      __$$SessionParticipantImplCopyWithImpl<_$SessionParticipantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionParticipantImplToJson(this);
  }
}

abstract class _SessionParticipant implements SessionParticipant {
  const factory _SessionParticipant({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? photoUrl,
    @JsonKey(name: 'booked_at') final DateTime? bookedAt,
  }) = _$SessionParticipantImpl;

  factory _SessionParticipant.fromJson(Map<String, dynamic> json) =
      _$SessionParticipantImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get photoUrl;
  @override
  @JsonKey(name: 'booked_at')
  DateTime? get bookedAt;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionCoach _$SessionCoachFromJson(Map<String, dynamic> json) {
  return _SessionCoach.fromJson(json);
}

/// @nodoc
mixin _$SessionCoach {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  CoachUser? get user => throw _privateConstructorUsedError;

  /// Serializes this SessionCoach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCoachCopyWith<SessionCoach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCoachCopyWith<$Res> {
  factory $SessionCoachCopyWith(
    SessionCoach value,
    $Res Function(SessionCoach) then,
  ) = _$SessionCoachCopyWithImpl<$Res, SessionCoach>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, CoachUser? user});

  $CoachUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$SessionCoachCopyWithImpl<$Res, $Val extends SessionCoach>
    implements $SessionCoachCopyWith<$Res> {
  _$SessionCoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionCoach
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
                      as CoachUser?,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $CoachUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionCoachImplCopyWith<$Res>
    implements $SessionCoachCopyWith<$Res> {
  factory _$$SessionCoachImplCopyWith(
    _$SessionCoachImpl value,
    $Res Function(_$SessionCoachImpl) then,
  ) = __$$SessionCoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, CoachUser? user});

  @override
  $CoachUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$SessionCoachImplCopyWithImpl<$Res>
    extends _$SessionCoachCopyWithImpl<$Res, _$SessionCoachImpl>
    implements _$$SessionCoachImplCopyWith<$Res> {
  __$$SessionCoachImplCopyWithImpl(
    _$SessionCoachImpl _value,
    $Res Function(_$SessionCoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? user = freezed}) {
    return _then(
      _$SessionCoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as CoachUser?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionCoachImpl implements _SessionCoach {
  const _$SessionCoachImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.user,
  });

  factory _$SessionCoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionCoachImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final CoachUser? user;

  @override
  String toString() {
    return 'SessionCoach(id: $id, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionCoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user);

  /// Create a copy of SessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionCoachImplCopyWith<_$SessionCoachImpl> get copyWith =>
      __$$SessionCoachImplCopyWithImpl<_$SessionCoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionCoachImplToJson(this);
  }
}

abstract class _SessionCoach implements SessionCoach {
  const factory _SessionCoach({
    @JsonKey(fromJson: idFromJson) required final String id,
    final CoachUser? user,
  }) = _$SessionCoachImpl;

  factory _SessionCoach.fromJson(Map<String, dynamic> json) =
      _$SessionCoachImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  CoachUser? get user;

  /// Create a copy of SessionCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionCoachImplCopyWith<_$SessionCoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
