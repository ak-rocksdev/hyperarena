// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer_action_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrganizerActionItem _$OrganizerActionItemFromJson(Map<String, dynamic> json) {
  return _OrganizerActionItem.fromJson(json);
}

/// @nodoc
mixin _$OrganizerActionItem {
  String get id => throw _privateConstructorUsedError;
  OrganizerActionType get type => throw _privateConstructorUsedError;
  OrganizerActionSeverity get severity => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  String? get participantId => throw _privateConstructorUsedError;
  DateTime? get dueAt => throw _privateConstructorUsedError;
  String? get actionableRoute => throw _privateConstructorUsedError;
  int? get amountImpact => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration? get timeToStart => throw _privateConstructorUsedError;

  /// Serializes this OrganizerActionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizerActionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizerActionItemCopyWith<OrganizerActionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerActionItemCopyWith<$Res> {
  factory $OrganizerActionItemCopyWith(
    OrganizerActionItem value,
    $Res Function(OrganizerActionItem) then,
  ) = _$OrganizerActionItemCopyWithImpl<$Res, OrganizerActionItem>;
  @useResult
  $Res call({
    String id,
    OrganizerActionType type,
    OrganizerActionSeverity severity,
    String title,
    String subtitle,
    String? sessionId,
    String? participantId,
    DateTime? dueAt,
    String? actionableRoute,
    int? amountImpact,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    Duration? timeToStart,
  });
}

/// @nodoc
class _$OrganizerActionItemCopyWithImpl<$Res, $Val extends OrganizerActionItem>
    implements $OrganizerActionItemCopyWith<$Res> {
  _$OrganizerActionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizerActionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? severity = null,
    Object? title = null,
    Object? subtitle = null,
    Object? sessionId = freezed,
    Object? participantId = freezed,
    Object? dueAt = freezed,
    Object? actionableRoute = freezed,
    Object? amountImpact = freezed,
    Object? timeToStart = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as OrganizerActionType,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as OrganizerActionSeverity,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            participantId: freezed == participantId
                ? _value.participantId
                : participantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            dueAt: freezed == dueAt
                ? _value.dueAt
                : dueAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            actionableRoute: freezed == actionableRoute
                ? _value.actionableRoute
                : actionableRoute // ignore: cast_nullable_to_non_nullable
                      as String?,
            amountImpact: freezed == amountImpact
                ? _value.amountImpact
                : amountImpact // ignore: cast_nullable_to_non_nullable
                      as int?,
            timeToStart: freezed == timeToStart
                ? _value.timeToStart
                : timeToStart // ignore: cast_nullable_to_non_nullable
                      as Duration?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizerActionItemImplCopyWith<$Res>
    implements $OrganizerActionItemCopyWith<$Res> {
  factory _$$OrganizerActionItemImplCopyWith(
    _$OrganizerActionItemImpl value,
    $Res Function(_$OrganizerActionItemImpl) then,
  ) = __$$OrganizerActionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    OrganizerActionType type,
    OrganizerActionSeverity severity,
    String title,
    String subtitle,
    String? sessionId,
    String? participantId,
    DateTime? dueAt,
    String? actionableRoute,
    int? amountImpact,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    Duration? timeToStart,
  });
}

/// @nodoc
class __$$OrganizerActionItemImplCopyWithImpl<$Res>
    extends _$OrganizerActionItemCopyWithImpl<$Res, _$OrganizerActionItemImpl>
    implements _$$OrganizerActionItemImplCopyWith<$Res> {
  __$$OrganizerActionItemImplCopyWithImpl(
    _$OrganizerActionItemImpl _value,
    $Res Function(_$OrganizerActionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizerActionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? severity = null,
    Object? title = null,
    Object? subtitle = null,
    Object? sessionId = freezed,
    Object? participantId = freezed,
    Object? dueAt = freezed,
    Object? actionableRoute = freezed,
    Object? amountImpact = freezed,
    Object? timeToStart = freezed,
  }) {
    return _then(
      _$OrganizerActionItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as OrganizerActionType,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as OrganizerActionSeverity,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantId: freezed == participantId
            ? _value.participantId
            : participantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        dueAt: freezed == dueAt
            ? _value.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        actionableRoute: freezed == actionableRoute
            ? _value.actionableRoute
            : actionableRoute // ignore: cast_nullable_to_non_nullable
                  as String?,
        amountImpact: freezed == amountImpact
            ? _value.amountImpact
            : amountImpact // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeToStart: freezed == timeToStart
            ? _value.timeToStart
            : timeToStart // ignore: cast_nullable_to_non_nullable
                  as Duration?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerActionItemImpl implements _OrganizerActionItem {
  const _$OrganizerActionItemImpl({
    required this.id,
    required this.type,
    this.severity = OrganizerActionSeverity.medium,
    required this.title,
    required this.subtitle,
    this.sessionId,
    this.participantId,
    this.dueAt,
    this.actionableRoute,
    this.amountImpact,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    this.timeToStart,
  });

  factory _$OrganizerActionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerActionItemImplFromJson(json);

  @override
  final String id;
  @override
  final OrganizerActionType type;
  @override
  @JsonKey()
  final OrganizerActionSeverity severity;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String? sessionId;
  @override
  final String? participantId;
  @override
  final DateTime? dueAt;
  @override
  final String? actionableRoute;
  @override
  final int? amountImpact;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration? timeToStart;

  @override
  String toString() {
    return 'OrganizerActionItem(id: $id, type: $type, severity: $severity, title: $title, subtitle: $subtitle, sessionId: $sessionId, participantId: $participantId, dueAt: $dueAt, actionableRoute: $actionableRoute, amountImpact: $amountImpact, timeToStart: $timeToStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerActionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.actionableRoute, actionableRoute) ||
                other.actionableRoute == actionableRoute) &&
            (identical(other.amountImpact, amountImpact) ||
                other.amountImpact == amountImpact) &&
            (identical(other.timeToStart, timeToStart) ||
                other.timeToStart == timeToStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    severity,
    title,
    subtitle,
    sessionId,
    participantId,
    dueAt,
    actionableRoute,
    amountImpact,
    timeToStart,
  );

  /// Create a copy of OrganizerActionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerActionItemImplCopyWith<_$OrganizerActionItemImpl> get copyWith =>
      __$$OrganizerActionItemImplCopyWithImpl<_$OrganizerActionItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerActionItemImplToJson(this);
  }
}

abstract class _OrganizerActionItem implements OrganizerActionItem {
  const factory _OrganizerActionItem({
    required final String id,
    required final OrganizerActionType type,
    final OrganizerActionSeverity severity,
    required final String title,
    required final String subtitle,
    final String? sessionId,
    final String? participantId,
    final DateTime? dueAt,
    final String? actionableRoute,
    final int? amountImpact,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    final Duration? timeToStart,
  }) = _$OrganizerActionItemImpl;

  factory _OrganizerActionItem.fromJson(Map<String, dynamic> json) =
      _$OrganizerActionItemImpl.fromJson;

  @override
  String get id;
  @override
  OrganizerActionType get type;
  @override
  OrganizerActionSeverity get severity;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String? get sessionId;
  @override
  String? get participantId;
  @override
  DateTime? get dueAt;
  @override
  String? get actionableRoute;
  @override
  int? get amountImpact;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration? get timeToStart;

  /// Create a copy of OrganizerActionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizerActionItemImplCopyWith<_$OrganizerActionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
