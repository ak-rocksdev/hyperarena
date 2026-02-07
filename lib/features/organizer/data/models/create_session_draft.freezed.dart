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
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Sport? get sport => throw _privateConstructorUsedError;
  LevelTier? get minLevel => throw _privateConstructorUsedError;
  LevelTier? get maxLevel => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  int? get pricePerPerson => throw _privateConstructorUsedError;
  int get minParticipants => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  DateTime? get joinDeadline => throw _privateConstructorUsedError;
  SessionPricingModel get pricingModel => throw _privateConstructorUsedError;
  SessionVisibility get visibility => throw _privateConstructorUsedError;
  int? get courtCost => throw _privateConstructorUsedError;
  int? get coachCost => throw _privateConstructorUsedError;
  int? get organizerFeePerPerson => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;

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
    String? title,
    String? description,
    Sport? sport,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    String? venueId,
    String? venueName,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? pricePerPerson,
    int minParticipants,
    int maxParticipants,
    DateTime? joinDeadline,
    SessionPricingModel pricingModel,
    SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    String? templateId,
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
    Object? title = freezed,
    Object? description = freezed,
    Object? sport = freezed,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? date = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? pricePerPerson = freezed,
    Object? minParticipants = null,
    Object? maxParticipants = null,
    Object? joinDeadline = freezed,
    Object? pricingModel = null,
    Object? visibility = null,
    Object? courtCost = freezed,
    Object? coachCost = freezed,
    Object? organizerFeePerPerson = freezed,
    Object? templateId = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sport: freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport?,
            minLevel: freezed == minLevel
                ? _value.minLevel
                : minLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            maxLevel: freezed == maxLevel
                ? _value.maxLevel
                : maxLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            venueId: freezed == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String?,
            venueName: freezed == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            pricePerPerson: freezed == pricePerPerson
                ? _value.pricePerPerson
                : pricePerPerson // ignore: cast_nullable_to_non_nullable
                      as int?,
            minParticipants: null == minParticipants
                ? _value.minParticipants
                : minParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            maxParticipants: null == maxParticipants
                ? _value.maxParticipants
                : maxParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            joinDeadline: freezed == joinDeadline
                ? _value.joinDeadline
                : joinDeadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pricingModel: null == pricingModel
                ? _value.pricingModel
                : pricingModel // ignore: cast_nullable_to_non_nullable
                      as SessionPricingModel,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as SessionVisibility,
            courtCost: freezed == courtCost
                ? _value.courtCost
                : courtCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            coachCost: freezed == coachCost
                ? _value.coachCost
                : coachCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            organizerFeePerPerson: freezed == organizerFeePerPerson
                ? _value.organizerFeePerPerson
                : organizerFeePerPerson // ignore: cast_nullable_to_non_nullable
                      as int?,
            templateId: freezed == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
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
    String? title,
    String? description,
    Sport? sport,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    String? venueId,
    String? venueName,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? pricePerPerson,
    int minParticipants,
    int maxParticipants,
    DateTime? joinDeadline,
    SessionPricingModel pricingModel,
    SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    String? templateId,
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
    Object? title = freezed,
    Object? description = freezed,
    Object? sport = freezed,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? date = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? pricePerPerson = freezed,
    Object? minParticipants = null,
    Object? maxParticipants = null,
    Object? joinDeadline = freezed,
    Object? pricingModel = null,
    Object? visibility = null,
    Object? courtCost = freezed,
    Object? coachCost = freezed,
    Object? organizerFeePerPerson = freezed,
    Object? templateId = freezed,
  }) {
    return _then(
      _$CreateSessionDraftImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sport: freezed == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport?,
        minLevel: freezed == minLevel
            ? _value.minLevel
            : minLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        maxLevel: freezed == maxLevel
            ? _value.maxLevel
            : maxLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        venueId: freezed == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String?,
        venueName: freezed == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        pricePerPerson: freezed == pricePerPerson
            ? _value.pricePerPerson
            : pricePerPerson // ignore: cast_nullable_to_non_nullable
                  as int?,
        minParticipants: null == minParticipants
            ? _value.minParticipants
            : minParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        maxParticipants: null == maxParticipants
            ? _value.maxParticipants
            : maxParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        joinDeadline: freezed == joinDeadline
            ? _value.joinDeadline
            : joinDeadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pricingModel: null == pricingModel
            ? _value.pricingModel
            : pricingModel // ignore: cast_nullable_to_non_nullable
                  as SessionPricingModel,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as SessionVisibility,
        courtCost: freezed == courtCost
            ? _value.courtCost
            : courtCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        coachCost: freezed == coachCost
            ? _value.coachCost
            : coachCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        organizerFeePerPerson: freezed == organizerFeePerPerson
            ? _value.organizerFeePerPerson
            : organizerFeePerPerson // ignore: cast_nullable_to_non_nullable
                  as int?,
        templateId: freezed == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSessionDraftImpl implements _CreateSessionDraft {
  const _$CreateSessionDraftImpl({
    this.title,
    this.description,
    this.sport,
    this.minLevel,
    this.maxLevel,
    this.venueId,
    this.venueName,
    this.date,
    this.startTime,
    this.endTime,
    this.pricePerPerson,
    this.minParticipants = 2,
    this.maxParticipants = 8,
    this.joinDeadline,
    this.pricingModel = SessionPricingModel.margin,
    this.visibility = SessionVisibility.free,
    this.courtCost,
    this.coachCost,
    this.organizerFeePerPerson,
    this.templateId,
  });

  factory _$CreateSessionDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSessionDraftImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final Sport? sport;
  @override
  final LevelTier? minLevel;
  @override
  final LevelTier? maxLevel;
  @override
  final String? venueId;
  @override
  final String? venueName;
  @override
  final DateTime? date;
  @override
  final String? startTime;
  @override
  final String? endTime;
  @override
  final int? pricePerPerson;
  @override
  @JsonKey()
  final int minParticipants;
  @override
  @JsonKey()
  final int maxParticipants;
  @override
  final DateTime? joinDeadline;
  @override
  @JsonKey()
  final SessionPricingModel pricingModel;
  @override
  @JsonKey()
  final SessionVisibility visibility;
  @override
  final int? courtCost;
  @override
  final int? coachCost;
  @override
  final int? organizerFeePerPerson;
  @override
  final String? templateId;

  @override
  String toString() {
    return 'CreateSessionDraft(title: $title, description: $description, sport: $sport, minLevel: $minLevel, maxLevel: $maxLevel, venueId: $venueId, venueName: $venueName, date: $date, startTime: $startTime, endTime: $endTime, pricePerPerson: $pricePerPerson, minParticipants: $minParticipants, maxParticipants: $maxParticipants, joinDeadline: $joinDeadline, pricingModel: $pricingModel, visibility: $visibility, courtCost: $courtCost, coachCost: $coachCost, organizerFeePerPerson: $organizerFeePerPerson, templateId: $templateId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSessionDraftImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.minLevel, minLevel) ||
                other.minLevel == minLevel) &&
            (identical(other.maxLevel, maxLevel) ||
                other.maxLevel == maxLevel) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.pricePerPerson, pricePerPerson) ||
                other.pricePerPerson == pricePerPerson) &&
            (identical(other.minParticipants, minParticipants) ||
                other.minParticipants == minParticipants) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.joinDeadline, joinDeadline) ||
                other.joinDeadline == joinDeadline) &&
            (identical(other.pricingModel, pricingModel) ||
                other.pricingModel == pricingModel) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.courtCost, courtCost) ||
                other.courtCost == courtCost) &&
            (identical(other.coachCost, coachCost) ||
                other.coachCost == coachCost) &&
            (identical(other.organizerFeePerPerson, organizerFeePerPerson) ||
                other.organizerFeePerPerson == organizerFeePerPerson) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    title,
    description,
    sport,
    minLevel,
    maxLevel,
    venueId,
    venueName,
    date,
    startTime,
    endTime,
    pricePerPerson,
    minParticipants,
    maxParticipants,
    joinDeadline,
    pricingModel,
    visibility,
    courtCost,
    coachCost,
    organizerFeePerPerson,
    templateId,
  ]);

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

abstract class _CreateSessionDraft implements CreateSessionDraft {
  const factory _CreateSessionDraft({
    final String? title,
    final String? description,
    final Sport? sport,
    final LevelTier? minLevel,
    final LevelTier? maxLevel,
    final String? venueId,
    final String? venueName,
    final DateTime? date,
    final String? startTime,
    final String? endTime,
    final int? pricePerPerson,
    final int minParticipants,
    final int maxParticipants,
    final DateTime? joinDeadline,
    final SessionPricingModel pricingModel,
    final SessionVisibility visibility,
    final int? courtCost,
    final int? coachCost,
    final int? organizerFeePerPerson,
    final String? templateId,
  }) = _$CreateSessionDraftImpl;

  factory _CreateSessionDraft.fromJson(Map<String, dynamic> json) =
      _$CreateSessionDraftImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  Sport? get sport;
  @override
  LevelTier? get minLevel;
  @override
  LevelTier? get maxLevel;
  @override
  String? get venueId;
  @override
  String? get venueName;
  @override
  DateTime? get date;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override
  int? get pricePerPerson;
  @override
  int get minParticipants;
  @override
  int get maxParticipants;
  @override
  DateTime? get joinDeadline;
  @override
  SessionPricingModel get pricingModel;
  @override
  SessionVisibility get visibility;
  @override
  int? get courtCost;
  @override
  int? get coachCost;
  @override
  int? get organizerFeePerPerson;
  @override
  String? get templateId;

  /// Create a copy of CreateSessionDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSessionDraftImplCopyWith<_$CreateSessionDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
