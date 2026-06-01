// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return _PaymentMethod.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethod {
  String get key => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_amount')
  int get feeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodCopyWith<PaymentMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodCopyWith<$Res> {
  factory $PaymentMethodCopyWith(
    PaymentMethod value,
    $Res Function(PaymentMethod) then,
  ) = _$PaymentMethodCopyWithImpl<$Res, PaymentMethod>;
  @useResult
  $Res call({
    String key,
    String provider,
    String label,
    String description,
    String icon,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
  });

  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class _$PaymentMethodCopyWithImpl<$Res, $Val extends PaymentMethod>
    implements $PaymentMethodCopyWith<$Res> {
  _$PaymentMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? provider = null,
    Object? label = null,
    Object? description = null,
    Object? icon = null,
    Object? feeAmount = null,
    Object? bankDetails = freezed,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            feeAmount: null == feeAmount
                ? _value.feeAmount
                : feeAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            bankDetails: freezed == bankDetails
                ? _value.bankDetails
                : bankDetails // ignore: cast_nullable_to_non_nullable
                      as ManualBankDetails?,
          )
          as $Val,
    );
  }

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ManualBankDetailsCopyWith<$Res>? get bankDetails {
    if (_value.bankDetails == null) {
      return null;
    }

    return $ManualBankDetailsCopyWith<$Res>(_value.bankDetails!, (value) {
      return _then(_value.copyWith(bankDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentMethodImplCopyWith<$Res>
    implements $PaymentMethodCopyWith<$Res> {
  factory _$$PaymentMethodImplCopyWith(
    _$PaymentMethodImpl value,
    $Res Function(_$PaymentMethodImpl) then,
  ) = __$$PaymentMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String key,
    String provider,
    String label,
    String description,
    String icon,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
  });

  @override
  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class __$$PaymentMethodImplCopyWithImpl<$Res>
    extends _$PaymentMethodCopyWithImpl<$Res, _$PaymentMethodImpl>
    implements _$$PaymentMethodImplCopyWith<$Res> {
  __$$PaymentMethodImplCopyWithImpl(
    _$PaymentMethodImpl _value,
    $Res Function(_$PaymentMethodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? provider = null,
    Object? label = null,
    Object? description = null,
    Object? icon = null,
    Object? feeAmount = null,
    Object? bankDetails = freezed,
  }) {
    return _then(
      _$PaymentMethodImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        feeAmount: null == feeAmount
            ? _value.feeAmount
            : feeAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        bankDetails: freezed == bankDetails
            ? _value.bankDetails
            : bankDetails // ignore: cast_nullable_to_non_nullable
                  as ManualBankDetails?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodImpl implements _PaymentMethod {
  const _$PaymentMethodImpl({
    required this.key,
    required this.provider,
    required this.label,
    required this.description,
    required this.icon,
    @JsonKey(name: 'fee_amount') required this.feeAmount,
    @JsonKey(name: 'bank_details') this.bankDetails,
  });

  factory _$PaymentMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodImplFromJson(json);

  @override
  final String key;
  @override
  final String provider;
  @override
  final String label;
  @override
  final String description;
  @override
  final String icon;
  @override
  @JsonKey(name: 'fee_amount')
  final int feeAmount;
  @override
  @JsonKey(name: 'bank_details')
  final ManualBankDetails? bankDetails;

  @override
  String toString() {
    return 'PaymentMethod(key: $key, provider: $provider, label: $label, description: $description, icon: $icon, feeAmount: $feeAmount, bankDetails: $bankDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.bankDetails, bankDetails) ||
                other.bankDetails == bankDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    key,
    provider,
    label,
    description,
    icon,
    feeAmount,
    bankDetails,
  );

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      __$$PaymentMethodImplCopyWithImpl<_$PaymentMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodImplToJson(this);
  }
}

abstract class _PaymentMethod implements PaymentMethod {
  const factory _PaymentMethod({
    required final String key,
    required final String provider,
    required final String label,
    required final String description,
    required final String icon,
    @JsonKey(name: 'fee_amount') required final int feeAmount,
    @JsonKey(name: 'bank_details') final ManualBankDetails? bankDetails,
  }) = _$PaymentMethodImpl;

  factory _PaymentMethod.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodImpl.fromJson;

  @override
  String get key;
  @override
  String get provider;
  @override
  String get label;
  @override
  String get description;
  @override
  String get icon;
  @override
  @JsonKey(name: 'fee_amount')
  int get feeAmount;
  @override
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManualBankDetails _$ManualBankDetailsFromJson(Map<String, dynamic> json) {
  return _ManualBankDetails.fromJson(json);
}

/// @nodoc
mixin _$ManualBankDetails {
  @JsonKey(name: 'bank_name')
  String get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_holder')
  String get accountHolder => throw _privateConstructorUsedError;

  /// Serializes this ManualBankDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManualBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManualBankDetailsCopyWith<ManualBankDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManualBankDetailsCopyWith<$Res> {
  factory $ManualBankDetailsCopyWith(
    ManualBankDetails value,
    $Res Function(ManualBankDetails) then,
  ) = _$ManualBankDetailsCopyWithImpl<$Res, ManualBankDetails>;
  @useResult
  $Res call({
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
  });
}

/// @nodoc
class _$ManualBankDetailsCopyWithImpl<$Res, $Val extends ManualBankDetails>
    implements $ManualBankDetailsCopyWith<$Res> {
  _$ManualBankDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManualBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManualBankDetailsImplCopyWith<$Res>
    implements $ManualBankDetailsCopyWith<$Res> {
  factory _$$ManualBankDetailsImplCopyWith(
    _$ManualBankDetailsImpl value,
    $Res Function(_$ManualBankDetailsImpl) then,
  ) = __$$ManualBankDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
  });
}

/// @nodoc
class __$$ManualBankDetailsImplCopyWithImpl<$Res>
    extends _$ManualBankDetailsCopyWithImpl<$Res, _$ManualBankDetailsImpl>
    implements _$$ManualBankDetailsImplCopyWith<$Res> {
  __$$ManualBankDetailsImplCopyWithImpl(
    _$ManualBankDetailsImpl _value,
    $Res Function(_$ManualBankDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManualBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
  }) {
    return _then(
      _$ManualBankDetailsImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManualBankDetailsImpl implements _ManualBankDetails {
  const _$ManualBankDetailsImpl({
    @JsonKey(name: 'bank_name') required this.bankName,
    @JsonKey(name: 'account_number') required this.accountNumber,
    @JsonKey(name: 'account_holder') required this.accountHolder,
  });

  factory _$ManualBankDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManualBankDetailsImplFromJson(json);

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
  String toString() {
    return 'ManualBankDetails(bankName: $bankName, accountNumber: $accountNumber, accountHolder: $accountHolder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManualBankDetailsImpl &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, bankName, accountNumber, accountHolder);

  /// Create a copy of ManualBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManualBankDetailsImplCopyWith<_$ManualBankDetailsImpl> get copyWith =>
      __$$ManualBankDetailsImplCopyWithImpl<_$ManualBankDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManualBankDetailsImplToJson(this);
  }
}

abstract class _ManualBankDetails implements ManualBankDetails {
  const factory _ManualBankDetails({
    @JsonKey(name: 'bank_name') required final String bankName,
    @JsonKey(name: 'account_number') required final String accountNumber,
    @JsonKey(name: 'account_holder') required final String accountHolder,
  }) = _$ManualBankDetailsImpl;

  factory _ManualBankDetails.fromJson(Map<String, dynamic> json) =
      _$ManualBankDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'bank_name')
  String get bankName;
  @override
  @JsonKey(name: 'account_number')
  String get accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  String get accountHolder;

  /// Create a copy of ManualBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManualBankDetailsImplCopyWith<_$ManualBankDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
