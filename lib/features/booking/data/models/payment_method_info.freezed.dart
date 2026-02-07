// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethodInfo _$PaymentMethodInfoFromJson(Map<String, dynamic> json) {
  return _PaymentMethodInfo.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodInfo {
  String get id => throw _privateConstructorUsedError;
  PaymentMethodType get type => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get accountNumber => throw _privateConstructorUsedError;
  String? get accountHolderName => throw _privateConstructorUsedError;
  String? get qrisImageUrl => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodInfoCopyWith<PaymentMethodInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodInfoCopyWith<$Res> {
  factory $PaymentMethodInfoCopyWith(
    PaymentMethodInfo value,
    $Res Function(PaymentMethodInfo) then,
  ) = _$PaymentMethodInfoCopyWithImpl<$Res, PaymentMethodInfo>;
  @useResult
  $Res call({
    String id,
    PaymentMethodType type,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? qrisImageUrl,
  });
}

/// @nodoc
class _$PaymentMethodInfoCopyWithImpl<$Res, $Val extends PaymentMethodInfo>
    implements $PaymentMethodInfoCopyWith<$Res> {
  _$PaymentMethodInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolderName = freezed,
    Object? qrisImageUrl = freezed,
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
                      as PaymentMethodType,
            bankName: freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountNumber: freezed == accountNumber
                ? _value.accountNumber
                : accountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountHolderName: freezed == accountHolderName
                ? _value.accountHolderName
                : accountHolderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            qrisImageUrl: freezed == qrisImageUrl
                ? _value.qrisImageUrl
                : qrisImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentMethodInfoImplCopyWith<$Res>
    implements $PaymentMethodInfoCopyWith<$Res> {
  factory _$$PaymentMethodInfoImplCopyWith(
    _$PaymentMethodInfoImpl value,
    $Res Function(_$PaymentMethodInfoImpl) then,
  ) = __$$PaymentMethodInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    PaymentMethodType type,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? qrisImageUrl,
  });
}

/// @nodoc
class __$$PaymentMethodInfoImplCopyWithImpl<$Res>
    extends _$PaymentMethodInfoCopyWithImpl<$Res, _$PaymentMethodInfoImpl>
    implements _$$PaymentMethodInfoImplCopyWith<$Res> {
  __$$PaymentMethodInfoImplCopyWithImpl(
    _$PaymentMethodInfoImpl _value,
    $Res Function(_$PaymentMethodInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolderName = freezed,
    Object? qrisImageUrl = freezed,
  }) {
    return _then(
      _$PaymentMethodInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PaymentMethodType,
        bankName: freezed == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountNumber: freezed == accountNumber
            ? _value.accountNumber
            : accountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountHolderName: freezed == accountHolderName
            ? _value.accountHolderName
            : accountHolderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        qrisImageUrl: freezed == qrisImageUrl
            ? _value.qrisImageUrl
            : qrisImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodInfoImpl implements _PaymentMethodInfo {
  const _$PaymentMethodInfoImpl({
    required this.id,
    required this.type,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
    this.qrisImageUrl,
  });

  factory _$PaymentMethodInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodInfoImplFromJson(json);

  @override
  final String id;
  @override
  final PaymentMethodType type;
  @override
  final String? bankName;
  @override
  final String? accountNumber;
  @override
  final String? accountHolderName;
  @override
  final String? qrisImageUrl;

  @override
  String toString() {
    return 'PaymentMethodInfo(id: $id, type: $type, bankName: $bankName, accountNumber: $accountNumber, accountHolderName: $accountHolderName, qrisImageUrl: $qrisImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.qrisImageUrl, qrisImageUrl) ||
                other.qrisImageUrl == qrisImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    bankName,
    accountNumber,
    accountHolderName,
    qrisImageUrl,
  );

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodInfoImplCopyWith<_$PaymentMethodInfoImpl> get copyWith =>
      __$$PaymentMethodInfoImplCopyWithImpl<_$PaymentMethodInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodInfoImplToJson(this);
  }
}

abstract class _PaymentMethodInfo implements PaymentMethodInfo {
  const factory _PaymentMethodInfo({
    required final String id,
    required final PaymentMethodType type,
    final String? bankName,
    final String? accountNumber,
    final String? accountHolderName,
    final String? qrisImageUrl,
  }) = _$PaymentMethodInfoImpl;

  factory _PaymentMethodInfo.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodInfoImpl.fromJson;

  @override
  String get id;
  @override
  PaymentMethodType get type;
  @override
  String? get bankName;
  @override
  String? get accountNumber;
  @override
  String? get accountHolderName;
  @override
  String? get qrisImageUrl;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodInfoImplCopyWith<_$PaymentMethodInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
