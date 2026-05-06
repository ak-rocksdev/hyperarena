// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scoring_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoringConfig _$ScoringConfigFromJson(Map<String, dynamic> json) {
  return _ScoringConfig.fromJson(json);
}

/// @nodoc
mixin _$ScoringConfig {
  @JsonKey(name: 'session_scoring_type')
  String get sessionScoringType => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_scoring_type')
  String get skillScoringType => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_numeric_to_members')
  bool get showNumericToMembers => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_labels')
  ScoringLabels get sessionLabels => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_labels')
  ScoringLabels get skillLabels => throw _privateConstructorUsedError;

  /// Serializes this ScoringConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoringConfigCopyWith<ScoringConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoringConfigCopyWith<$Res> {
  factory $ScoringConfigCopyWith(
    ScoringConfig value,
    $Res Function(ScoringConfig) then,
  ) = _$ScoringConfigCopyWithImpl<$Res, ScoringConfig>;
  @useResult
  $Res call({
    @JsonKey(name: 'session_scoring_type') String sessionScoringType,
    @JsonKey(name: 'skill_scoring_type') String skillScoringType,
    @JsonKey(name: 'show_numeric_to_members') bool showNumericToMembers,
    @JsonKey(name: 'session_labels') ScoringLabels sessionLabels,
    @JsonKey(name: 'skill_labels') ScoringLabels skillLabels,
  });

  $ScoringLabelsCopyWith<$Res> get sessionLabels;
  $ScoringLabelsCopyWith<$Res> get skillLabels;
}

/// @nodoc
class _$ScoringConfigCopyWithImpl<$Res, $Val extends ScoringConfig>
    implements $ScoringConfigCopyWith<$Res> {
  _$ScoringConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionScoringType = null,
    Object? skillScoringType = null,
    Object? showNumericToMembers = null,
    Object? sessionLabels = null,
    Object? skillLabels = null,
  }) {
    return _then(
      _value.copyWith(
            sessionScoringType: null == sessionScoringType
                ? _value.sessionScoringType
                : sessionScoringType // ignore: cast_nullable_to_non_nullable
                      as String,
            skillScoringType: null == skillScoringType
                ? _value.skillScoringType
                : skillScoringType // ignore: cast_nullable_to_non_nullable
                      as String,
            showNumericToMembers: null == showNumericToMembers
                ? _value.showNumericToMembers
                : showNumericToMembers // ignore: cast_nullable_to_non_nullable
                      as bool,
            sessionLabels: null == sessionLabels
                ? _value.sessionLabels
                : sessionLabels // ignore: cast_nullable_to_non_nullable
                      as ScoringLabels,
            skillLabels: null == skillLabels
                ? _value.skillLabels
                : skillLabels // ignore: cast_nullable_to_non_nullable
                      as ScoringLabels,
          )
          as $Val,
    );
  }

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoringLabelsCopyWith<$Res> get sessionLabels {
    return $ScoringLabelsCopyWith<$Res>(_value.sessionLabels, (value) {
      return _then(_value.copyWith(sessionLabels: value) as $Val);
    });
  }

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoringLabelsCopyWith<$Res> get skillLabels {
    return $ScoringLabelsCopyWith<$Res>(_value.skillLabels, (value) {
      return _then(_value.copyWith(skillLabels: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScoringConfigImplCopyWith<$Res>
    implements $ScoringConfigCopyWith<$Res> {
  factory _$$ScoringConfigImplCopyWith(
    _$ScoringConfigImpl value,
    $Res Function(_$ScoringConfigImpl) then,
  ) = __$$ScoringConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'session_scoring_type') String sessionScoringType,
    @JsonKey(name: 'skill_scoring_type') String skillScoringType,
    @JsonKey(name: 'show_numeric_to_members') bool showNumericToMembers,
    @JsonKey(name: 'session_labels') ScoringLabels sessionLabels,
    @JsonKey(name: 'skill_labels') ScoringLabels skillLabels,
  });

  @override
  $ScoringLabelsCopyWith<$Res> get sessionLabels;
  @override
  $ScoringLabelsCopyWith<$Res> get skillLabels;
}

/// @nodoc
class __$$ScoringConfigImplCopyWithImpl<$Res>
    extends _$ScoringConfigCopyWithImpl<$Res, _$ScoringConfigImpl>
    implements _$$ScoringConfigImplCopyWith<$Res> {
  __$$ScoringConfigImplCopyWithImpl(
    _$ScoringConfigImpl _value,
    $Res Function(_$ScoringConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionScoringType = null,
    Object? skillScoringType = null,
    Object? showNumericToMembers = null,
    Object? sessionLabels = null,
    Object? skillLabels = null,
  }) {
    return _then(
      _$ScoringConfigImpl(
        sessionScoringType: null == sessionScoringType
            ? _value.sessionScoringType
            : sessionScoringType // ignore: cast_nullable_to_non_nullable
                  as String,
        skillScoringType: null == skillScoringType
            ? _value.skillScoringType
            : skillScoringType // ignore: cast_nullable_to_non_nullable
                  as String,
        showNumericToMembers: null == showNumericToMembers
            ? _value.showNumericToMembers
            : showNumericToMembers // ignore: cast_nullable_to_non_nullable
                  as bool,
        sessionLabels: null == sessionLabels
            ? _value.sessionLabels
            : sessionLabels // ignore: cast_nullable_to_non_nullable
                  as ScoringLabels,
        skillLabels: null == skillLabels
            ? _value.skillLabels
            : skillLabels // ignore: cast_nullable_to_non_nullable
                  as ScoringLabels,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoringConfigImpl implements _ScoringConfig {
  const _$ScoringConfigImpl({
    @JsonKey(name: 'session_scoring_type') this.sessionScoringType = 'status',
    @JsonKey(name: 'skill_scoring_type') this.skillScoringType = 'status',
    @JsonKey(name: 'show_numeric_to_members') this.showNumericToMembers = true,
    @JsonKey(name: 'session_labels') this.sessionLabels = const ScoringLabels(),
    @JsonKey(name: 'skill_labels') this.skillLabels = const ScoringLabels(),
  });

  factory _$ScoringConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoringConfigImplFromJson(json);

  @override
  @JsonKey(name: 'session_scoring_type')
  final String sessionScoringType;
  @override
  @JsonKey(name: 'skill_scoring_type')
  final String skillScoringType;
  @override
  @JsonKey(name: 'show_numeric_to_members')
  final bool showNumericToMembers;
  @override
  @JsonKey(name: 'session_labels')
  final ScoringLabels sessionLabels;
  @override
  @JsonKey(name: 'skill_labels')
  final ScoringLabels skillLabels;

  @override
  String toString() {
    return 'ScoringConfig(sessionScoringType: $sessionScoringType, skillScoringType: $skillScoringType, showNumericToMembers: $showNumericToMembers, sessionLabels: $sessionLabels, skillLabels: $skillLabels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoringConfigImpl &&
            (identical(other.sessionScoringType, sessionScoringType) ||
                other.sessionScoringType == sessionScoringType) &&
            (identical(other.skillScoringType, skillScoringType) ||
                other.skillScoringType == skillScoringType) &&
            (identical(other.showNumericToMembers, showNumericToMembers) ||
                other.showNumericToMembers == showNumericToMembers) &&
            (identical(other.sessionLabels, sessionLabels) ||
                other.sessionLabels == sessionLabels) &&
            (identical(other.skillLabels, skillLabels) ||
                other.skillLabels == skillLabels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionScoringType,
    skillScoringType,
    showNumericToMembers,
    sessionLabels,
    skillLabels,
  );

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoringConfigImplCopyWith<_$ScoringConfigImpl> get copyWith =>
      __$$ScoringConfigImplCopyWithImpl<_$ScoringConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoringConfigImplToJson(this);
  }
}

abstract class _ScoringConfig implements ScoringConfig {
  const factory _ScoringConfig({
    @JsonKey(name: 'session_scoring_type') final String sessionScoringType,
    @JsonKey(name: 'skill_scoring_type') final String skillScoringType,
    @JsonKey(name: 'show_numeric_to_members') final bool showNumericToMembers,
    @JsonKey(name: 'session_labels') final ScoringLabels sessionLabels,
    @JsonKey(name: 'skill_labels') final ScoringLabels skillLabels,
  }) = _$ScoringConfigImpl;

  factory _ScoringConfig.fromJson(Map<String, dynamic> json) =
      _$ScoringConfigImpl.fromJson;

  @override
  @JsonKey(name: 'session_scoring_type')
  String get sessionScoringType;
  @override
  @JsonKey(name: 'skill_scoring_type')
  String get skillScoringType;
  @override
  @JsonKey(name: 'show_numeric_to_members')
  bool get showNumericToMembers;
  @override
  @JsonKey(name: 'session_labels')
  ScoringLabels get sessionLabels;
  @override
  @JsonKey(name: 'skill_labels')
  ScoringLabels get skillLabels;

  /// Create a copy of ScoringConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoringConfigImplCopyWith<_$ScoringConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScoringLabels _$ScoringLabelsFromJson(Map<String, dynamic> json) {
  return _ScoringLabels.fromJson(json);
}

/// @nodoc
mixin _$ScoringLabels {
  Map<String, String> get status => throw _privateConstructorUsedError;
  List<NumericRange> get numeric => throw _privateConstructorUsedError;

  /// Serializes this ScoringLabels to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoringLabels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoringLabelsCopyWith<ScoringLabels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoringLabelsCopyWith<$Res> {
  factory $ScoringLabelsCopyWith(
    ScoringLabels value,
    $Res Function(ScoringLabels) then,
  ) = _$ScoringLabelsCopyWithImpl<$Res, ScoringLabels>;
  @useResult
  $Res call({Map<String, String> status, List<NumericRange> numeric});
}

/// @nodoc
class _$ScoringLabelsCopyWithImpl<$Res, $Val extends ScoringLabels>
    implements $ScoringLabelsCopyWith<$Res> {
  _$ScoringLabelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoringLabels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? numeric = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            numeric: null == numeric
                ? _value.numeric
                : numeric // ignore: cast_nullable_to_non_nullable
                      as List<NumericRange>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoringLabelsImplCopyWith<$Res>
    implements $ScoringLabelsCopyWith<$Res> {
  factory _$$ScoringLabelsImplCopyWith(
    _$ScoringLabelsImpl value,
    $Res Function(_$ScoringLabelsImpl) then,
  ) = __$$ScoringLabelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> status, List<NumericRange> numeric});
}

/// @nodoc
class __$$ScoringLabelsImplCopyWithImpl<$Res>
    extends _$ScoringLabelsCopyWithImpl<$Res, _$ScoringLabelsImpl>
    implements _$$ScoringLabelsImplCopyWith<$Res> {
  __$$ScoringLabelsImplCopyWithImpl(
    _$ScoringLabelsImpl _value,
    $Res Function(_$ScoringLabelsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoringLabels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? numeric = null}) {
    return _then(
      _$ScoringLabelsImpl(
        status: null == status
            ? _value._status
            : status // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        numeric: null == numeric
            ? _value._numeric
            : numeric // ignore: cast_nullable_to_non_nullable
                  as List<NumericRange>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoringLabelsImpl implements _ScoringLabels {
  const _$ScoringLabelsImpl({
    final Map<String, String> status = const <String, String>{},
    final List<NumericRange> numeric = const <NumericRange>[],
  }) : _status = status,
       _numeric = numeric;

  factory _$ScoringLabelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoringLabelsImplFromJson(json);

  final Map<String, String> _status;
  @override
  @JsonKey()
  Map<String, String> get status {
    if (_status is EqualUnmodifiableMapView) return _status;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_status);
  }

  final List<NumericRange> _numeric;
  @override
  @JsonKey()
  List<NumericRange> get numeric {
    if (_numeric is EqualUnmodifiableListView) return _numeric;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_numeric);
  }

  @override
  String toString() {
    return 'ScoringLabels(status: $status, numeric: $numeric)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoringLabelsImpl &&
            const DeepCollectionEquality().equals(other._status, _status) &&
            const DeepCollectionEquality().equals(other._numeric, _numeric));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_status),
    const DeepCollectionEquality().hash(_numeric),
  );

  /// Create a copy of ScoringLabels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoringLabelsImplCopyWith<_$ScoringLabelsImpl> get copyWith =>
      __$$ScoringLabelsImplCopyWithImpl<_$ScoringLabelsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoringLabelsImplToJson(this);
  }
}

abstract class _ScoringLabels implements ScoringLabels {
  const factory _ScoringLabels({
    final Map<String, String> status,
    final List<NumericRange> numeric,
  }) = _$ScoringLabelsImpl;

  factory _ScoringLabels.fromJson(Map<String, dynamic> json) =
      _$ScoringLabelsImpl.fromJson;

  @override
  Map<String, String> get status;
  @override
  List<NumericRange> get numeric;

  /// Create a copy of ScoringLabels
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoringLabelsImplCopyWith<_$ScoringLabelsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NumericRange _$NumericRangeFromJson(Map<String, dynamic> json) {
  return _NumericRange.fromJson(json);
}

/// @nodoc
mixin _$NumericRange {
  int get min => throw _privateConstructorUsedError;
  int get max => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this NumericRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NumericRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NumericRangeCopyWith<NumericRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumericRangeCopyWith<$Res> {
  factory $NumericRangeCopyWith(
    NumericRange value,
    $Res Function(NumericRange) then,
  ) = _$NumericRangeCopyWithImpl<$Res, NumericRange>;
  @useResult
  $Res call({int min, int max, String label, String? color, String status});
}

/// @nodoc
class _$NumericRangeCopyWithImpl<$Res, $Val extends NumericRange>
    implements $NumericRangeCopyWith<$Res> {
  _$NumericRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NumericRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
    Object? label = null,
    Object? color = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            min: null == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as int,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NumericRangeImplCopyWith<$Res>
    implements $NumericRangeCopyWith<$Res> {
  factory _$$NumericRangeImplCopyWith(
    _$NumericRangeImpl value,
    $Res Function(_$NumericRangeImpl) then,
  ) = __$$NumericRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int min, int max, String label, String? color, String status});
}

/// @nodoc
class __$$NumericRangeImplCopyWithImpl<$Res>
    extends _$NumericRangeCopyWithImpl<$Res, _$NumericRangeImpl>
    implements _$$NumericRangeImplCopyWith<$Res> {
  __$$NumericRangeImplCopyWithImpl(
    _$NumericRangeImpl _value,
    $Res Function(_$NumericRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NumericRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
    Object? label = null,
    Object? color = freezed,
    Object? status = null,
  }) {
    return _then(
      _$NumericRangeImpl(
        min: null == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as int,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NumericRangeImpl implements _NumericRange {
  const _$NumericRangeImpl({
    required this.min,
    required this.max,
    required this.label,
    this.color,
    required this.status,
  });

  factory _$NumericRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NumericRangeImplFromJson(json);

  @override
  final int min;
  @override
  final int max;
  @override
  final String label;
  @override
  final String? color;
  @override
  final String status;

  @override
  String toString() {
    return 'NumericRange(min: $min, max: $max, label: $label, color: $color, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NumericRangeImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max, label, color, status);

  /// Create a copy of NumericRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NumericRangeImplCopyWith<_$NumericRangeImpl> get copyWith =>
      __$$NumericRangeImplCopyWithImpl<_$NumericRangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NumericRangeImplToJson(this);
  }
}

abstract class _NumericRange implements NumericRange {
  const factory _NumericRange({
    required final int min,
    required final int max,
    required final String label,
    final String? color,
    required final String status,
  }) = _$NumericRangeImpl;

  factory _NumericRange.fromJson(Map<String, dynamic> json) =
      _$NumericRangeImpl.fromJson;

  @override
  int get min;
  @override
  int get max;
  @override
  String get label;
  @override
  String? get color;
  @override
  String get status;

  /// Create a copy of NumericRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NumericRangeImplCopyWith<_$NumericRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
