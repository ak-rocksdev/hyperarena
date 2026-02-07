// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OpenSession _$OpenSessionFromJson(Map<String, dynamic> json) {
  return _OpenSession.fromJson(json);
}

/// @nodoc
mixin _$OpenSession {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Sport get sport => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get hostName => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get currentPlayers => throw _privateConstructorUsedError;
  int get maxPlayers => throw _privateConstructorUsedError;
  LevelTier? get minLevel => throw _privateConstructorUsedError;
  LevelTier? get maxLevel => throw _privateConstructorUsedError;
  int get pricePerPerson => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get participantNames => throw _privateConstructorUsedError;

  /// Serializes this OpenSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenSessionCopyWith<OpenSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenSessionCopyWith<$Res> {
  factory $OpenSessionCopyWith(
    OpenSession value,
    $Res Function(OpenSession) then,
  ) = _$OpenSessionCopyWithImpl<$Res, OpenSession>;
  @useResult
  $Res call({
    String id,
    String title,
    Sport sport,
    String hostId,
    String hostName,
    String venueName,
    String venueId,
    DateTime date,
    String startTime,
    String endTime,
    int currentPlayers,
    int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    int pricePerPerson,
    String? description,
    List<String> participantNames,
  });
}

/// @nodoc
class _$OpenSessionCopyWithImpl<$Res, $Val extends OpenSession>
    implements $OpenSessionCopyWith<$Res> {
  _$OpenSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sport = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? venueName = null,
    Object? venueId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? currentPlayers = null,
    Object? maxPlayers = null,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? pricePerPerson = null,
    Object? description = freezed,
    Object? participantNames = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            sport: null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as String,
            hostName: null == hostName
                ? _value.hostName
                : hostName // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            venueId: null == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPlayers: null == currentPlayers
                ? _value.currentPlayers
                : currentPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            maxPlayers: null == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            minLevel: freezed == minLevel
                ? _value.minLevel
                : minLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            maxLevel: freezed == maxLevel
                ? _value.maxLevel
                : maxLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            pricePerPerson: null == pricePerPerson
                ? _value.pricePerPerson
                : pricePerPerson // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            participantNames: null == participantNames
                ? _value.participantNames
                : participantNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpenSessionImplCopyWith<$Res>
    implements $OpenSessionCopyWith<$Res> {
  factory _$$OpenSessionImplCopyWith(
    _$OpenSessionImpl value,
    $Res Function(_$OpenSessionImpl) then,
  ) = __$$OpenSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    Sport sport,
    String hostId,
    String hostName,
    String venueName,
    String venueId,
    DateTime date,
    String startTime,
    String endTime,
    int currentPlayers,
    int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    int pricePerPerson,
    String? description,
    List<String> participantNames,
  });
}

/// @nodoc
class __$$OpenSessionImplCopyWithImpl<$Res>
    extends _$OpenSessionCopyWithImpl<$Res, _$OpenSessionImpl>
    implements _$$OpenSessionImplCopyWith<$Res> {
  __$$OpenSessionImplCopyWithImpl(
    _$OpenSessionImpl _value,
    $Res Function(_$OpenSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sport = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? venueName = null,
    Object? venueId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? currentPlayers = null,
    Object? maxPlayers = null,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? pricePerPerson = null,
    Object? description = freezed,
    Object? participantNames = null,
  }) {
    return _then(
      _$OpenSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        sport: null == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostName: null == hostName
            ? _value.hostName
            : hostName // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        venueId: null == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPlayers: null == currentPlayers
            ? _value.currentPlayers
            : currentPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        maxPlayers: null == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        minLevel: freezed == minLevel
            ? _value.minLevel
            : minLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        maxLevel: freezed == maxLevel
            ? _value.maxLevel
            : maxLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        pricePerPerson: null == pricePerPerson
            ? _value.pricePerPerson
            : pricePerPerson // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantNames: null == participantNames
            ? _value._participantNames
            : participantNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenSessionImpl implements _OpenSession {
  const _$OpenSessionImpl({
    required this.id,
    required this.title,
    required this.sport,
    required this.hostId,
    required this.hostName,
    required this.venueName,
    required this.venueId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.currentPlayers = 0,
    required this.maxPlayers,
    this.minLevel,
    this.maxLevel,
    required this.pricePerPerson,
    this.description,
    final List<String> participantNames = const [],
  }) : _participantNames = participantNames;

  factory _$OpenSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final Sport sport;
  @override
  final String hostId;
  @override
  final String hostName;
  @override
  final String venueName;
  @override
  final String venueId;
  @override
  final DateTime date;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  @JsonKey()
  final int currentPlayers;
  @override
  final int maxPlayers;
  @override
  final LevelTier? minLevel;
  @override
  final LevelTier? maxLevel;
  @override
  final int pricePerPerson;
  @override
  final String? description;
  final List<String> _participantNames;
  @override
  @JsonKey()
  List<String> get participantNames {
    if (_participantNames is EqualUnmodifiableListView)
      return _participantNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantNames);
  }

  @override
  String toString() {
    return 'OpenSession(id: $id, title: $title, sport: $sport, hostId: $hostId, hostName: $hostName, venueName: $venueName, venueId: $venueId, date: $date, startTime: $startTime, endTime: $endTime, currentPlayers: $currentPlayers, maxPlayers: $maxPlayers, minLevel: $minLevel, maxLevel: $maxLevel, pricePerPerson: $pricePerPerson, description: $description, participantNames: $participantNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.currentPlayers, currentPlayers) ||
                other.currentPlayers == currentPlayers) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.minLevel, minLevel) ||
                other.minLevel == minLevel) &&
            (identical(other.maxLevel, maxLevel) ||
                other.maxLevel == maxLevel) &&
            (identical(other.pricePerPerson, pricePerPerson) ||
                other.pricePerPerson == pricePerPerson) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._participantNames,
              _participantNames,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    sport,
    hostId,
    hostName,
    venueName,
    venueId,
    date,
    startTime,
    endTime,
    currentPlayers,
    maxPlayers,
    minLevel,
    maxLevel,
    pricePerPerson,
    description,
    const DeepCollectionEquality().hash(_participantNames),
  );

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenSessionImplCopyWith<_$OpenSessionImpl> get copyWith =>
      __$$OpenSessionImplCopyWithImpl<_$OpenSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenSessionImplToJson(this);
  }
}

abstract class _OpenSession implements OpenSession {
  const factory _OpenSession({
    required final String id,
    required final String title,
    required final Sport sport,
    required final String hostId,
    required final String hostName,
    required final String venueName,
    required final String venueId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    final int currentPlayers,
    required final int maxPlayers,
    final LevelTier? minLevel,
    final LevelTier? maxLevel,
    required final int pricePerPerson,
    final String? description,
    final List<String> participantNames,
  }) = _$OpenSessionImpl;

  factory _OpenSession.fromJson(Map<String, dynamic> json) =
      _$OpenSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  Sport get sport;
  @override
  String get hostId;
  @override
  String get hostName;
  @override
  String get venueName;
  @override
  String get venueId;
  @override
  DateTime get date;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int get currentPlayers;
  @override
  int get maxPlayers;
  @override
  LevelTier? get minLevel;
  @override
  LevelTier? get maxLevel;
  @override
  int get pricePerPerson;
  @override
  String? get description;
  @override
  List<String> get participantNames;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenSessionImplCopyWith<_$OpenSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
