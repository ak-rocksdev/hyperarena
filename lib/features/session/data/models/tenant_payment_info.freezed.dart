// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_payment_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantPaymentInfo _$TenantPaymentInfoFromJson(Map<String, dynamic> json) {
  return _TenantPaymentInfo.fromJson(json);
}

/// @nodoc
mixin _$TenantPaymentInfo {
  @JsonKey(name: 'bank_name')
  String get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_holder')
  String get accountHolder => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_instructions')
  String? get paymentInstructions => throw _privateConstructorUsedError;

  /// Serializes this TenantPaymentInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantPaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantPaymentInfoCopyWith<TenantPaymentInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantPaymentInfoCopyWith<$Res> {
  factory $TenantPaymentInfoCopyWith(
    TenantPaymentInfo value,
    $Res Function(TenantPaymentInfo) then,
  ) = _$TenantPaymentInfoCopyWithImpl<$Res, TenantPaymentInfo>;
  @useResult
  $Res call({
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
  });
}

/// @nodoc
class _$TenantPaymentInfoCopyWithImpl<$Res, $Val extends TenantPaymentInfo>
    implements $TenantPaymentInfoCopyWith<$Res> {
  _$TenantPaymentInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantPaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? paymentInstructions = freezed,
  }) {
    return _then(
      _value.copyWith(
            bankName: null == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String,
            accountNumber: null == accountNumber
                ? _value.accountNumber
                : accountNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            accountHolder: null == accountHolder
                ? _value.accountHolder
                : accountHolder // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentInstructions: freezed == paymentInstructions
                ? _value.paymentInstructions
                : paymentInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantPaymentInfoImplCopyWith<$Res>
    implements $TenantPaymentInfoCopyWith<$Res> {
  factory _$$TenantPaymentInfoImplCopyWith(
    _$TenantPaymentInfoImpl value,
    $Res Function(_$TenantPaymentInfoImpl) then,
  ) = __$$TenantPaymentInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
  });
}

/// @nodoc
class __$$TenantPaymentInfoImplCopyWithImpl<$Res>
    extends _$TenantPaymentInfoCopyWithImpl<$Res, _$TenantPaymentInfoImpl>
    implements _$$TenantPaymentInfoImplCopyWith<$Res> {
  __$$TenantPaymentInfoImplCopyWithImpl(
    _$TenantPaymentInfoImpl _value,
    $Res Function(_$TenantPaymentInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantPaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? paymentInstructions = freezed,
  }) {
    return _then(
      _$TenantPaymentInfoImpl(
        bankName: null == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String,
        accountNumber: null == accountNumber
            ? _value.accountNumber
            : accountNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        accountHolder: null == accountHolder
            ? _value.accountHolder
            : accountHolder // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentInstructions: freezed == paymentInstructions
            ? _value.paymentInstructions
            : paymentInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantPaymentInfoImpl implements _TenantPaymentInfo {
  const _$TenantPaymentInfoImpl({
    @JsonKey(name: 'bank_name') required this.bankName,
    @JsonKey(name: 'account_number') required this.accountNumber,
    @JsonKey(name: 'account_holder') required this.accountHolder,
    @JsonKey(name: 'payment_instructions') this.paymentInstructions,
  });

  factory _$TenantPaymentInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantPaymentInfoImplFromJson(json);

  @override
  @JsonKey(name: 'bank_name')
  final String bankName;
  @override
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  final String accountHolder;
  @override
  @JsonKey(name: 'payment_instructions')
  final String? paymentInstructions;

  @override
  String toString() {
    return 'TenantPaymentInfo(bankName: $bankName, accountNumber: $accountNumber, accountHolder: $accountHolder, paymentInstructions: $paymentInstructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantPaymentInfoImpl &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.paymentInstructions, paymentInstructions) ||
                other.paymentInstructions == paymentInstructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bankName,
    accountNumber,
    accountHolder,
    paymentInstructions,
  );

  /// Create a copy of TenantPaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantPaymentInfoImplCopyWith<_$TenantPaymentInfoImpl> get copyWith =>
      __$$TenantPaymentInfoImplCopyWithImpl<_$TenantPaymentInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantPaymentInfoImplToJson(this);
  }
}

abstract class _TenantPaymentInfo implements TenantPaymentInfo {
  const factory _TenantPaymentInfo({
    @JsonKey(name: 'bank_name') required final String bankName,
    @JsonKey(name: 'account_number') required final String accountNumber,
    @JsonKey(name: 'account_holder') required final String accountHolder,
    @JsonKey(name: 'payment_instructions') final String? paymentInstructions,
  }) = _$TenantPaymentInfoImpl;

  factory _TenantPaymentInfo.fromJson(Map<String, dynamic> json) =
      _$TenantPaymentInfoImpl.fromJson;

  @override
  @JsonKey(name: 'bank_name')
  String get bankName;
  @override
  @JsonKey(name: 'account_number')
  String get accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  String get accountHolder;
  @override
  @JsonKey(name: 'payment_instructions')
  String? get paymentInstructions;

  /// Create a copy of TenantPaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantPaymentInfoImplCopyWith<_$TenantPaymentInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
