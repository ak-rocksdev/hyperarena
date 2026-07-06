// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_session_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateSessionDraft _$CreateSessionDraftFromJson(Map<String, dynamic> json) {
  return _CreateSessionDraft.fromJson(json);
}

/// @nodoc
mixin _$CreateSessionDraft {
  int? get sessionId =>
      throw _privateConstructorUsedError; // null = create, non-null = editing an existing session
  List<int> get coachIds => throw _privateConstructorUsedError;
  SessionType get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError; // "HH:mm"
  int get durationMinutes => throw _privateConstructorUsedError;
  int? get capacity =>
      throw _privateConstructorUsedError; // null = unlimited (also null for private)
  String? get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  int? get price =>
      throw _privateConstructorUsedError; // minor units; null = free
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateSessionDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSessionDraftCopyWith<CreateSessionDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSessionDraftCopyWith<$Res> {
  factory $CreateSessionDraftCopyWith(
    CreateSessionDraft value,
    $Res Function(CreateSessionDraft) then,
  ) = _$CreateSessionDraftCopyWithImpl<$Res, CreateSessionDraft>;
  @useResult
  $Res call({
    int? sessionId,
    List<int> coachIds,
    SessionType type,
    String? title,
    DateTime? date,
    String? startTime,
    int durationMinutes,
    int? capacity,
    String? venueId,
    String? venueName,
    int? price,
    String? notes,
  });
}

/// @nodoc
class _$CreateSessionDraftCopyWithImpl<$Res, $Val extends CreateSessionDraft>
    implements $CreateSessionDraftCopyWith<$Res> {
  _$CreateSessionDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = freezed,
    Object? coachIds = null,
    Object? type = null,
    Object? title = freezed,
    Object? date = freezed,
    Object? startTime = freezed,
    Object? durationMinutes = null,
    Object? capacity = freezed,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? price = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            coachIds: null == coachIds
                ? _value.coachIds
                : coachIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SessionType,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            capacity: freezed == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int?,
            venueId: freezed == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String?,
            venueName: freezed == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CreateSessionDraftImplCopyWith<$Res>
    implements $CreateSessionDraftCopyWith<$Res> {
  factory _$$CreateSessionDraftImplCopyWith(
    _$CreateSessionDraftImpl value,
    $Res Function(_$CreateSessionDraftImpl) then,
  ) = __$$CreateSessionDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? sessionId,
    List<int> coachIds,
    SessionType type,
    String? title,
    DateTime? date,
    String? startTime,
    int durationMinutes,
    int? capacity,
    String? venueId,
    String? venueName,
    int? price,
    String? notes,
  });
}

/// @nodoc
class __$$CreateSessionDraftImplCopyWithImpl<$Res>
    extends _$CreateSessionDraftCopyWithImpl<$Res, _$CreateSessionDraftImpl>
    implements _$$CreateSessionDraftImplCopyWith<$Res> {
  __$$CreateSessionDraftImplCopyWithImpl(
    _$CreateSessionDraftImpl _value,
    $Res Function(_$CreateSessionDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = freezed,
    Object? coachIds = null,
    Object? type = null,
    Object? title = freezed,
    Object? date = freezed,
    Object? startTime = freezed,
    Object? durationMinutes = null,
    Object? capacity = freezed,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? price = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CreateSessionDraftImpl(
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        coachIds: null == coachIds
            ? _value._coachIds
            : coachIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SessionType,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        capacity: freezed == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int?,
        venueId: freezed == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String?,
        venueName: freezed == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
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
class _$CreateSessionDraftImpl extends _CreateSessionDraft {
  const _$CreateSessionDraftImpl({
    this.sessionId,
    final List<int> coachIds = const <int>[],
    this.type = SessionType.group,
    this.title,
    this.date,
    this.startTime,
    this.durationMinutes = 60,
    this.capacity,
    this.venueId,
    this.venueName,
    this.price,
    this.notes,
  }) : _coachIds = coachIds,
       super._();

  factory _$CreateSessionDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSessionDraftImplFromJson(json);

  @override
  final int? sessionId;
  // null = create, non-null = editing an existing session
  final List<int> _coachIds;
  // null = create, non-null = editing an existing session
  @override
  @JsonKey()
  List<int> get coachIds {
    if (_coachIds is EqualUnmodifiableListView) return _coachIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coachIds);
  }

  @override
  @JsonKey()
  final SessionType type;
  @override
  final String? title;
  @override
  final DateTime? date;
  @override
  final String? startTime;
  // "HH:mm"
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  final int? capacity;
  // null = unlimited (also null for private)
  @override
  final String? venueId;
  @override
  final String? venueName;
  @override
  final int? price;
  // minor units; null = free
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateSessionDraft(sessionId: $sessionId, coachIds: $coachIds, type: $type, title: $title, date: $date, startTime: $startTime, durationMinutes: $durationMinutes, capacity: $capacity, venueId: $venueId, venueName: $venueName, price: $price, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSessionDraftImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._coachIds, _coachIds) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    const DeepCollectionEquality().hash(_coachIds),
    type,
    title,
    date,
    startTime,
    durationMinutes,
    capacity,
    venueId,
    venueName,
    price,
    notes,
  );

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSessionDraftImplCopyWith<_$CreateSessionDraftImpl> get copyWith =>
      __$$CreateSessionDraftImplCopyWithImpl<_$CreateSessionDraftImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSessionDraftImplToJson(this);
  }
}

abstract class _CreateSessionDraft extends CreateSessionDraft {
  const factory _CreateSessionDraft({
    final int? sessionId,
    final List<int> coachIds,
    final SessionType type,
    final String? title,
    final DateTime? date,
    final String? startTime,
    final int durationMinutes,
    final int? capacity,
    final String? venueId,
    final String? venueName,
    final int? price,
    final String? notes,
  }) = _$CreateSessionDraftImpl;
  const _CreateSessionDraft._() : super._();

  factory _CreateSessionDraft.fromJson(Map<String, dynamic> json) =
      _$CreateSessionDraftImpl.fromJson;

  @override
  int? get sessionId; // null = create, non-null = editing an existing session
  @override
  List<int> get coachIds;
  @override
  SessionType get type;
  @override
  String? get title;
  @override
  DateTime? get date;
  @override
  String? get startTime; // "HH:mm"
  @override
  int get durationMinutes;
  @override
  int? get capacity; // null = unlimited (also null for private)
  @override
  String? get venueId;
  @override
  String? get venueName;
  @override
  int? get price; // minor units; null = free
  @override
  String? get notes;

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSessionDraftImplCopyWith<_$CreateSessionDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
