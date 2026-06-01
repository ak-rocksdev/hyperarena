// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentIntent _$PaymentIntentFromJson(Map<String, dynamic> json) {
  return _PaymentIntent.fromJson(json);
}

/// @nodoc
mixin _$PaymentIntent {
  @JsonKey(name: 'purchase_id')
  int get purchaseId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_base')
  int get amountBase => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_amount')
  int get feeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_total')
  int get amountTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'va_number')
  String? get vaNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'va_bank')
  String? get vaBank => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'proof_upload_url')
  String? get proofUploadUrl => throw _privateConstructorUsedError;

  /// Serializes this PaymentIntent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentIntentCopyWith<PaymentIntent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentIntentCopyWith<$Res> {
  factory $PaymentIntentCopyWith(
    PaymentIntent value,
    $Res Function(PaymentIntent) then,
  ) = _$PaymentIntentCopyWithImpl<$Res, PaymentIntent>;
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    String provider,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'amount_base') int amountBase,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') String? proofUploadUrl,
  });

  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class _$PaymentIntentCopyWithImpl<$Res, $Val extends PaymentIntent>
    implements $PaymentIntentCopyWith<$Res> {
  _$PaymentIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? provider = null,
    Object? paymentMethod = null,
    Object? amountBase = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? expiresAt = freezed,
    Object? bankDetails = freezed,
    Object? proofUploadUrl = freezed,
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
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            amountBase: null == amountBase
                ? _value.amountBase
                : amountBase // ignore: cast_nullable_to_non_nullable
                      as int,
            feeAmount: null == feeAmount
                ? _value.feeAmount
                : feeAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            amountTotal: null == amountTotal
                ? _value.amountTotal
                : amountTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            vaNumber: freezed == vaNumber
                ? _value.vaNumber
                : vaNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            vaBank: freezed == vaBank
                ? _value.vaBank
                : vaBank // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bankDetails: freezed == bankDetails
                ? _value.bankDetails
                : bankDetails // ignore: cast_nullable_to_non_nullable
                      as ManualBankDetails?,
            proofUploadUrl: freezed == proofUploadUrl
                ? _value.proofUploadUrl
                : proofUploadUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PaymentIntent
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
abstract class _$$PaymentIntentImplCopyWith<$Res>
    implements $PaymentIntentCopyWith<$Res> {
  factory _$$PaymentIntentImplCopyWith(
    _$PaymentIntentImpl value,
    $Res Function(_$PaymentIntentImpl) then,
  ) = __$$PaymentIntentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    String provider,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'amount_base') int amountBase,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') String? proofUploadUrl,
  });

  @override
  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class __$$PaymentIntentImplCopyWithImpl<$Res>
    extends _$PaymentIntentCopyWithImpl<$Res, _$PaymentIntentImpl>
    implements _$$PaymentIntentImplCopyWith<$Res> {
  __$$PaymentIntentImplCopyWithImpl(
    _$PaymentIntentImpl _value,
    $Res Function(_$PaymentIntentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? provider = null,
    Object? paymentMethod = null,
    Object? amountBase = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? expiresAt = freezed,
    Object? bankDetails = freezed,
    Object? proofUploadUrl = freezed,
  }) {
    return _then(
      _$PaymentIntentImpl(
        purchaseId: null == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amountBase: null == amountBase
            ? _value.amountBase
            : amountBase // ignore: cast_nullable_to_non_nullable
                  as int,
        feeAmount: null == feeAmount
            ? _value.feeAmount
            : feeAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        amountTotal: null == amountTotal
            ? _value.amountTotal
            : amountTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        vaNumber: freezed == vaNumber
            ? _value.vaNumber
            : vaNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        vaBank: freezed == vaBank
            ? _value.vaBank
            : vaBank // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bankDetails: freezed == bankDetails
            ? _value.bankDetails
            : bankDetails // ignore: cast_nullable_to_non_nullable
                  as ManualBankDetails?,
        proofUploadUrl: freezed == proofUploadUrl
            ? _value.proofUploadUrl
            : proofUploadUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentIntentImpl implements _PaymentIntent {
  const _$PaymentIntentImpl({
    @JsonKey(name: 'purchase_id') required this.purchaseId,
    required this.status,
    required this.provider,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    @JsonKey(name: 'amount_base') required this.amountBase,
    @JsonKey(name: 'fee_amount') required this.feeAmount,
    @JsonKey(name: 'amount_total') required this.amountTotal,
    @JsonKey(name: 'va_number') this.vaNumber,
    @JsonKey(name: 'va_bank') this.vaBank,
    @JsonKey(name: 'expires_at') this.expiresAt,
    @JsonKey(name: 'bank_details') this.bankDetails,
    @JsonKey(name: 'proof_upload_url') this.proofUploadUrl,
  });

  factory _$PaymentIntentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentIntentImplFromJson(json);

  @override
  @JsonKey(name: 'purchase_id')
  final int purchaseId;
  @override
  final String status;
  @override
  final String provider;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey(name: 'amount_base')
  final int amountBase;
  @override
  @JsonKey(name: 'fee_amount')
  final int feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  final int amountTotal;
  @override
  @JsonKey(name: 'va_number')
  final String? vaNumber;
  @override
  @JsonKey(name: 'va_bank')
  final String? vaBank;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'bank_details')
  final ManualBankDetails? bankDetails;
  @override
  @JsonKey(name: 'proof_upload_url')
  final String? proofUploadUrl;

  @override
  String toString() {
    return 'PaymentIntent(purchaseId: $purchaseId, status: $status, provider: $provider, paymentMethod: $paymentMethod, amountBase: $amountBase, feeAmount: $feeAmount, amountTotal: $amountTotal, vaNumber: $vaNumber, vaBank: $vaBank, expiresAt: $expiresAt, bankDetails: $bankDetails, proofUploadUrl: $proofUploadUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentIntentImpl &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amountBase, amountBase) ||
                other.amountBase == amountBase) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.amountTotal, amountTotal) ||
                other.amountTotal == amountTotal) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.vaBank, vaBank) || other.vaBank == vaBank) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.bankDetails, bankDetails) ||
                other.bankDetails == bankDetails) &&
            (identical(other.proofUploadUrl, proofUploadUrl) ||
                other.proofUploadUrl == proofUploadUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    purchaseId,
    status,
    provider,
    paymentMethod,
    amountBase,
    feeAmount,
    amountTotal,
    vaNumber,
    vaBank,
    expiresAt,
    bankDetails,
    proofUploadUrl,
  );

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      __$$PaymentIntentImplCopyWithImpl<_$PaymentIntentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentIntentImplToJson(this);
  }
}

abstract class _PaymentIntent implements PaymentIntent {
  const factory _PaymentIntent({
    @JsonKey(name: 'purchase_id') required final int purchaseId,
    required final String status,
    required final String provider,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    @JsonKey(name: 'amount_base') required final int amountBase,
    @JsonKey(name: 'fee_amount') required final int feeAmount,
    @JsonKey(name: 'amount_total') required final int amountTotal,
    @JsonKey(name: 'va_number') final String? vaNumber,
    @JsonKey(name: 'va_bank') final String? vaBank,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    @JsonKey(name: 'bank_details') final ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') final String? proofUploadUrl,
  }) = _$PaymentIntentImpl;

  factory _PaymentIntent.fromJson(Map<String, dynamic> json) =
      _$PaymentIntentImpl.fromJson;

  @override
  @JsonKey(name: 'purchase_id')
  int get purchaseId;
  @override
  String get status;
  @override
  String get provider;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  @JsonKey(name: 'amount_base')
  int get amountBase;
  @override
  @JsonKey(name: 'fee_amount')
  int get feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  int get amountTotal;
  @override
  @JsonKey(name: 'va_number')
  String? get vaNumber;
  @override
  @JsonKey(name: 'va_bank')
  String? get vaBank;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails;
  @override
  @JsonKey(name: 'proof_upload_url')
  String? get proofUploadUrl;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
