// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseStatus _$PurchaseStatusFromJson(Map<String, dynamic> json) {
  return _PurchaseStatus.fromJson(json);
}

/// @nodoc
mixin _$PurchaseStatus {
  @JsonKey(name: 'purchase_id')
  int get purchaseId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this PurchaseStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseStatusCopyWith<PurchaseStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseStatusCopyWith<$Res> {
  factory $PurchaseStatusCopyWith(
    PurchaseStatus value,
    $Res Function(PurchaseStatus) then,
  ) = _$PurchaseStatusCopyWithImpl<$Res, PurchaseStatus>;
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
  });
}

/// @nodoc
class _$PurchaseStatusCopyWithImpl<$Res, $Val extends PurchaseStatus>
    implements $PurchaseStatusCopyWith<$Res> {
  _$PurchaseStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            purchaseId: null == purchaseId
                ? _value.purchaseId
                : purchaseId // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseStatusImplCopyWith<$Res>
    implements $PurchaseStatusCopyWith<$Res> {
  factory _$$PurchaseStatusImplCopyWith(
    _$PurchaseStatusImpl value,
    $Res Function(_$PurchaseStatusImpl) then,
  ) = __$$PurchaseStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
  });
}

/// @nodoc
class __$$PurchaseStatusImplCopyWithImpl<$Res>
    extends _$PurchaseStatusCopyWithImpl<$Res, _$PurchaseStatusImpl>
    implements _$$PurchaseStatusImplCopyWith<$Res> {
  __$$PurchaseStatusImplCopyWithImpl(
    _$PurchaseStatusImpl _value,
    $Res Function(_$PurchaseStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _$PurchaseStatusImpl(
        purchaseId: null == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseStatusImpl implements _PurchaseStatus {
  const _$PurchaseStatusImpl({
    @JsonKey(name: 'purchase_id') required this.purchaseId,
    required this.status,
    @JsonKey(name: 'paid_at') this.paidAt,
  });

  factory _$PurchaseStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseStatusImplFromJson(json);

  @override
  @JsonKey(name: 'purchase_id')
  final int purchaseId;
  @override
  final String status;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;

  @override
  String toString() {
    return 'PurchaseStatus(purchaseId: $purchaseId, status: $status, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStatusImpl &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, purchaseId, status, paidAt);

  /// Create a copy of PurchaseStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStatusImplCopyWith<_$PurchaseStatusImpl> get copyWith =>
      __$$PurchaseStatusImplCopyWithImpl<_$PurchaseStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseStatusImplToJson(this);
  }
}

abstract class _PurchaseStatus implements PurchaseStatus {
  const factory _PurchaseStatus({
    @JsonKey(name: 'purchase_id') required final int purchaseId,
    required final String status,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
  }) = _$PurchaseStatusImpl;

  factory _PurchaseStatus.fromJson(Map<String, dynamic> json) =
      _$PurchaseStatusImpl.fromJson;

  @override
  @JsonKey(name: 'purchase_id')
  int get purchaseId;
  @override
  String get status;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;

  /// Create a copy of PurchaseStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStatusImplCopyWith<_$PurchaseStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
