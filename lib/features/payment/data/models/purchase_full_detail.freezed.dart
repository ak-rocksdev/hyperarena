// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_full_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseResume _$PurchaseResumeFromJson(Map<String, dynamic> json) {
  return _PurchaseResume.fromJson(json);
}

/// @nodoc
mixin _$PurchaseResume {
  String get method => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'qr_string')
  String? get qrString => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'proof_upload_url')
  String? get proofUploadUrl => throw _privateConstructorUsedError;

  /// Serializes this PurchaseResume to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseResume
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseResumeCopyWith<PurchaseResume> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseResumeCopyWith<$Res> {
  factory $PurchaseResumeCopyWith(
    PurchaseResume value,
    $Res Function(PurchaseResume) then,
  ) = _$PurchaseResumeCopyWithImpl<$Res, PurchaseResume>;
  @useResult
  $Res call({
    String method,
    String provider,
    @JsonKey(name: 'amount_base') int amountBase,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'qr_string') String? qrString,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') String? proofUploadUrl,
  });

  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class _$PurchaseResumeCopyWithImpl<$Res, $Val extends PurchaseResume>
    implements $PurchaseResumeCopyWith<$Res> {
  _$PurchaseResumeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseResume
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? provider = null,
    Object? amountBase = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? qrString = freezed,
    Object? expiresAt = freezed,
    Object? bankDetails = freezed,
    Object? proofUploadUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
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
            qrString: freezed == qrString
                ? _value.qrString
                : qrString // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of PurchaseResume
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
abstract class _$$PurchaseResumeImplCopyWith<$Res>
    implements $PurchaseResumeCopyWith<$Res> {
  factory _$$PurchaseResumeImplCopyWith(
    _$PurchaseResumeImpl value,
    $Res Function(_$PurchaseResumeImpl) then,
  ) = __$$PurchaseResumeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String method,
    String provider,
    @JsonKey(name: 'amount_base') int amountBase,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'qr_string') String? qrString,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') String? proofUploadUrl,
  });

  @override
  $ManualBankDetailsCopyWith<$Res>? get bankDetails;
}

/// @nodoc
class __$$PurchaseResumeImplCopyWithImpl<$Res>
    extends _$PurchaseResumeCopyWithImpl<$Res, _$PurchaseResumeImpl>
    implements _$$PurchaseResumeImplCopyWith<$Res> {
  __$$PurchaseResumeImplCopyWithImpl(
    _$PurchaseResumeImpl _value,
    $Res Function(_$PurchaseResumeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseResume
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? provider = null,
    Object? amountBase = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? qrString = freezed,
    Object? expiresAt = freezed,
    Object? bankDetails = freezed,
    Object? proofUploadUrl = freezed,
  }) {
    return _then(
      _$PurchaseResumeImpl(
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
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
        qrString: freezed == qrString
            ? _value.qrString
            : qrString // ignore: cast_nullable_to_non_nullable
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
class _$PurchaseResumeImpl implements _PurchaseResume {
  const _$PurchaseResumeImpl({
    required this.method,
    required this.provider,
    @JsonKey(name: 'amount_base') required this.amountBase,
    @JsonKey(name: 'fee_amount') required this.feeAmount,
    @JsonKey(name: 'amount_total') required this.amountTotal,
    @JsonKey(name: 'va_number') this.vaNumber,
    @JsonKey(name: 'va_bank') this.vaBank,
    @JsonKey(name: 'qr_string') this.qrString,
    @JsonKey(name: 'expires_at') this.expiresAt,
    @JsonKey(name: 'bank_details') this.bankDetails,
    @JsonKey(name: 'proof_upload_url') this.proofUploadUrl,
  });

  factory _$PurchaseResumeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseResumeImplFromJson(json);

  @override
  final String method;
  @override
  final String provider;
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
  @JsonKey(name: 'qr_string')
  final String? qrString;
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
    return 'PurchaseResume(method: $method, provider: $provider, amountBase: $amountBase, feeAmount: $feeAmount, amountTotal: $amountTotal, vaNumber: $vaNumber, vaBank: $vaBank, qrString: $qrString, expiresAt: $expiresAt, bankDetails: $bankDetails, proofUploadUrl: $proofUploadUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseResumeImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.amountBase, amountBase) ||
                other.amountBase == amountBase) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.amountTotal, amountTotal) ||
                other.amountTotal == amountTotal) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.vaBank, vaBank) || other.vaBank == vaBank) &&
            (identical(other.qrString, qrString) ||
                other.qrString == qrString) &&
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
    method,
    provider,
    amountBase,
    feeAmount,
    amountTotal,
    vaNumber,
    vaBank,
    qrString,
    expiresAt,
    bankDetails,
    proofUploadUrl,
  );

  /// Create a copy of PurchaseResume
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseResumeImplCopyWith<_$PurchaseResumeImpl> get copyWith =>
      __$$PurchaseResumeImplCopyWithImpl<_$PurchaseResumeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseResumeImplToJson(this);
  }
}

abstract class _PurchaseResume implements PurchaseResume {
  const factory _PurchaseResume({
    required final String method,
    required final String provider,
    @JsonKey(name: 'amount_base') required final int amountBase,
    @JsonKey(name: 'fee_amount') required final int feeAmount,
    @JsonKey(name: 'amount_total') required final int amountTotal,
    @JsonKey(name: 'va_number') final String? vaNumber,
    @JsonKey(name: 'va_bank') final String? vaBank,
    @JsonKey(name: 'qr_string') final String? qrString,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    @JsonKey(name: 'bank_details') final ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') final String? proofUploadUrl,
  }) = _$PurchaseResumeImpl;

  factory _PurchaseResume.fromJson(Map<String, dynamic> json) =
      _$PurchaseResumeImpl.fromJson;

  @override
  String get method;
  @override
  String get provider;
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
  @JsonKey(name: 'qr_string')
  String? get qrString;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'bank_details')
  ManualBankDetails? get bankDetails;
  @override
  @JsonKey(name: 'proof_upload_url')
  String? get proofUploadUrl;

  /// Create a copy of PurchaseResume
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseResumeImplCopyWith<_$PurchaseResumeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseFullDetail _$PurchaseFullDetailFromJson(Map<String, dynamic> json) {
  return _PurchaseFullDetail.fromJson(json);
}

/// @nodoc
mixin _$PurchaseFullDetail {
  int get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid')
  int get amountPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_amount')
  int get feeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_total')
  int get amountTotal => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_provider')
  String get paymentProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_label')
  String? get productLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'va_number')
  String? get vaNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'va_bank')
  String? get vaBank => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_proof_path')
  String? get paymentProofPath => throw _privateConstructorUsedError;
  DetailTenant? get tenant => throw _privateConstructorUsedError;
  DetailSession? get session => throw _privateConstructorUsedError;
  PurchaseResume? get resume => throw _privateConstructorUsedError;

  /// Serializes this PurchaseFullDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseFullDetailCopyWith<PurchaseFullDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseFullDetailCopyWith<$Res> {
  factory $PurchaseFullDetailCopyWith(
    PurchaseFullDetail value,
    $Res Function(PurchaseFullDetail) then,
  ) = _$PurchaseFullDetailCopyWithImpl<$Res, PurchaseFullDetail>;
  @useResult
  $Res call({
    int id,
    String reference,
    String status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    String currency,
    @JsonKey(name: 'payment_provider') String paymentProvider,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'product_label') String? productLabel,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'payment_proof_path') String? paymentProofPath,
    DetailTenant? tenant,
    DetailSession? session,
    PurchaseResume? resume,
  });

  $DetailTenantCopyWith<$Res>? get tenant;
  $DetailSessionCopyWith<$Res>? get session;
  $PurchaseResumeCopyWith<$Res>? get resume;
}

/// @nodoc
class _$PurchaseFullDetailCopyWithImpl<$Res, $Val extends PurchaseFullDetail>
    implements $PurchaseFullDetailCopyWith<$Res> {
  _$PurchaseFullDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? amountPaid = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? currency = null,
    Object? paymentProvider = null,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? productLabel = freezed,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? expiresAt = freezed,
    Object? paymentProofPath = freezed,
    Object? tenant = freezed,
    Object? session = freezed,
    Object? resume = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as int,
            feeAmount: null == feeAmount
                ? _value.feeAmount
                : feeAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            amountTotal: null == amountTotal
                ? _value.amountTotal
                : amountTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentProvider: null == paymentProvider
                ? _value.paymentProvider
                : paymentProvider // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            productLabel: freezed == productLabel
                ? _value.productLabel
                : productLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            paymentProofPath: freezed == paymentProofPath
                ? _value.paymentProofPath
                : paymentProofPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as DetailTenant?,
            session: freezed == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as DetailSession?,
            resume: freezed == resume
                ? _value.resume
                : resume // ignore: cast_nullable_to_non_nullable
                      as PurchaseResume?,
          )
          as $Val,
    );
  }

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailTenantCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $DetailTenantCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailSessionCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $DetailSessionCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseResumeCopyWith<$Res>? get resume {
    if (_value.resume == null) {
      return null;
    }

    return $PurchaseResumeCopyWith<$Res>(_value.resume!, (value) {
      return _then(_value.copyWith(resume: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseFullDetailImplCopyWith<$Res>
    implements $PurchaseFullDetailCopyWith<$Res> {
  factory _$$PurchaseFullDetailImplCopyWith(
    _$PurchaseFullDetailImpl value,
    $Res Function(_$PurchaseFullDetailImpl) then,
  ) = __$$PurchaseFullDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String reference,
    String status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    String currency,
    @JsonKey(name: 'payment_provider') String paymentProvider,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'product_label') String? productLabel,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'payment_proof_path') String? paymentProofPath,
    DetailTenant? tenant,
    DetailSession? session,
    PurchaseResume? resume,
  });

  @override
  $DetailTenantCopyWith<$Res>? get tenant;
  @override
  $DetailSessionCopyWith<$Res>? get session;
  @override
  $PurchaseResumeCopyWith<$Res>? get resume;
}

/// @nodoc
class __$$PurchaseFullDetailImplCopyWithImpl<$Res>
    extends _$PurchaseFullDetailCopyWithImpl<$Res, _$PurchaseFullDetailImpl>
    implements _$$PurchaseFullDetailImplCopyWith<$Res> {
  __$$PurchaseFullDetailImplCopyWithImpl(
    _$PurchaseFullDetailImpl _value,
    $Res Function(_$PurchaseFullDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? amountPaid = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? currency = null,
    Object? paymentProvider = null,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? productLabel = freezed,
    Object? vaNumber = freezed,
    Object? vaBank = freezed,
    Object? expiresAt = freezed,
    Object? paymentProofPath = freezed,
    Object? tenant = freezed,
    Object? session = freezed,
    Object? resume = freezed,
  }) {
    return _then(
      _$PurchaseFullDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as int,
        feeAmount: null == feeAmount
            ? _value.feeAmount
            : feeAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        amountTotal: null == amountTotal
            ? _value.amountTotal
            : amountTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentProvider: null == paymentProvider
            ? _value.paymentProvider
            : paymentProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        productLabel: freezed == productLabel
            ? _value.productLabel
            : productLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        paymentProofPath: freezed == paymentProofPath
            ? _value.paymentProofPath
            : paymentProofPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as DetailTenant?,
        session: freezed == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as DetailSession?,
        resume: freezed == resume
            ? _value.resume
            : resume // ignore: cast_nullable_to_non_nullable
                  as PurchaseResume?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseFullDetailImpl implements _PurchaseFullDetail {
  const _$PurchaseFullDetailImpl({
    required this.id,
    required this.reference,
    required this.status,
    @JsonKey(name: 'amount_paid') required this.amountPaid,
    @JsonKey(name: 'fee_amount') required this.feeAmount,
    @JsonKey(name: 'amount_total') required this.amountTotal,
    required this.currency,
    @JsonKey(name: 'payment_provider') required this.paymentProvider,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'confirmed_at') this.confirmedAt,
    @JsonKey(name: 'product_label') this.productLabel,
    @JsonKey(name: 'va_number') this.vaNumber,
    @JsonKey(name: 'va_bank') this.vaBank,
    @JsonKey(name: 'expires_at') this.expiresAt,
    @JsonKey(name: 'payment_proof_path') this.paymentProofPath,
    this.tenant,
    this.session,
    this.resume,
  });

  factory _$PurchaseFullDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseFullDetailImplFromJson(json);

  @override
  final int id;
  @override
  final String reference;
  @override
  final String status;
  @override
  @JsonKey(name: 'amount_paid')
  final int amountPaid;
  @override
  @JsonKey(name: 'fee_amount')
  final int feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  final int amountTotal;
  @override
  final String currency;
  @override
  @JsonKey(name: 'payment_provider')
  final String paymentProvider;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'product_label')
  final String? productLabel;
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
  @JsonKey(name: 'payment_proof_path')
  final String? paymentProofPath;
  @override
  final DetailTenant? tenant;
  @override
  final DetailSession? session;
  @override
  final PurchaseResume? resume;

  @override
  String toString() {
    return 'PurchaseFullDetail(id: $id, reference: $reference, status: $status, amountPaid: $amountPaid, feeAmount: $feeAmount, amountTotal: $amountTotal, currency: $currency, paymentProvider: $paymentProvider, paymentMethod: $paymentMethod, createdAt: $createdAt, confirmedAt: $confirmedAt, productLabel: $productLabel, vaNumber: $vaNumber, vaBank: $vaBank, expiresAt: $expiresAt, paymentProofPath: $paymentProofPath, tenant: $tenant, session: $session, resume: $resume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseFullDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.amountTotal, amountTotal) ||
                other.amountTotal == amountTotal) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentProvider, paymentProvider) ||
                other.paymentProvider == paymentProvider) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.productLabel, productLabel) ||
                other.productLabel == productLabel) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.vaBank, vaBank) || other.vaBank == vaBank) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.paymentProofPath, paymentProofPath) ||
                other.paymentProofPath == paymentProofPath) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.resume, resume) || other.resume == resume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    reference,
    status,
    amountPaid,
    feeAmount,
    amountTotal,
    currency,
    paymentProvider,
    paymentMethod,
    createdAt,
    confirmedAt,
    productLabel,
    vaNumber,
    vaBank,
    expiresAt,
    paymentProofPath,
    tenant,
    session,
    resume,
  ]);

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseFullDetailImplCopyWith<_$PurchaseFullDetailImpl> get copyWith =>
      __$$PurchaseFullDetailImplCopyWithImpl<_$PurchaseFullDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseFullDetailImplToJson(this);
  }
}

abstract class _PurchaseFullDetail implements PurchaseFullDetail {
  const factory _PurchaseFullDetail({
    required final int id,
    required final String reference,
    required final String status,
    @JsonKey(name: 'amount_paid') required final int amountPaid,
    @JsonKey(name: 'fee_amount') required final int feeAmount,
    @JsonKey(name: 'amount_total') required final int amountTotal,
    required final String currency,
    @JsonKey(name: 'payment_provider') required final String paymentProvider,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
    @JsonKey(name: 'product_label') final String? productLabel,
    @JsonKey(name: 'va_number') final String? vaNumber,
    @JsonKey(name: 'va_bank') final String? vaBank,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    @JsonKey(name: 'payment_proof_path') final String? paymentProofPath,
    final DetailTenant? tenant,
    final DetailSession? session,
    final PurchaseResume? resume,
  }) = _$PurchaseFullDetailImpl;

  factory _PurchaseFullDetail.fromJson(Map<String, dynamic> json) =
      _$PurchaseFullDetailImpl.fromJson;

  @override
  int get id;
  @override
  String get reference;
  @override
  String get status;
  @override
  @JsonKey(name: 'amount_paid')
  int get amountPaid;
  @override
  @JsonKey(name: 'fee_amount')
  int get feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  int get amountTotal;
  @override
  String get currency;
  @override
  @JsonKey(name: 'payment_provider')
  String get paymentProvider;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'product_label')
  String? get productLabel;
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
  @JsonKey(name: 'payment_proof_path')
  String? get paymentProofPath;
  @override
  DetailTenant? get tenant;
  @override
  DetailSession? get session;
  @override
  PurchaseResume? get resume;

  /// Create a copy of PurchaseFullDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseFullDetailImplCopyWith<_$PurchaseFullDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DetailTenant _$DetailTenantFromJson(Map<String, dynamic> json) {
  return _DetailTenant.fromJson(json);
}

/// @nodoc
mixin _$DetailTenant {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  /// Serializes this DetailTenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailTenantCopyWith<DetailTenant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailTenantCopyWith<$Res> {
  factory $DetailTenantCopyWith(
    DetailTenant value,
    $Res Function(DetailTenant) then,
  ) = _$DetailTenantCopyWithImpl<$Res, DetailTenant>;
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class _$DetailTenantCopyWithImpl<$Res, $Val extends DetailTenant>
    implements $DetailTenantCopyWith<$Res> {
  _$DetailTenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? slug = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailTenantImplCopyWith<$Res>
    implements $DetailTenantCopyWith<$Res> {
  factory _$$DetailTenantImplCopyWith(
    _$DetailTenantImpl value,
    $Res Function(_$DetailTenantImpl) then,
  ) = __$$DetailTenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class __$$DetailTenantImplCopyWithImpl<$Res>
    extends _$DetailTenantCopyWithImpl<$Res, _$DetailTenantImpl>
    implements _$$DetailTenantImplCopyWith<$Res> {
  __$$DetailTenantImplCopyWithImpl(
    _$DetailTenantImpl _value,
    $Res Function(_$DetailTenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? slug = null}) {
    return _then(
      _$DetailTenantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailTenantImpl implements _DetailTenant {
  const _$DetailTenantImpl({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory _$DetailTenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailTenantImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;

  @override
  String toString() {
    return 'DetailTenant(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailTenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  /// Create a copy of DetailTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailTenantImplCopyWith<_$DetailTenantImpl> get copyWith =>
      __$$DetailTenantImplCopyWithImpl<_$DetailTenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailTenantImplToJson(this);
  }
}

abstract class _DetailTenant implements DetailTenant {
  const factory _DetailTenant({
    required final int id,
    required final String name,
    required final String slug,
  }) = _$DetailTenantImpl;

  factory _DetailTenant.fromJson(Map<String, dynamic> json) =
      _$DetailTenantImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;

  /// Create a copy of DetailTenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailTenantImplCopyWith<_$DetailTenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DetailSession _$DetailSessionFromJson(Map<String, dynamic> json) {
  return _DetailSession.fromJson(json);
}

/// @nodoc
mixin _$DetailSession {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_title')
  String? get displayTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at')
  DateTime? get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  DetailVenue? get venue => throw _privateConstructorUsedError;

  /// Serializes this DetailSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailSessionCopyWith<DetailSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailSessionCopyWith<$Res> {
  factory $DetailSessionCopyWith(
    DetailSession value,
    $Res Function(DetailSession) then,
  ) = _$DetailSessionCopyWithImpl<$Res, DetailSession>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    DetailVenue? venue,
  });

  $DetailVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class _$DetailSessionCopyWithImpl<$Res, $Val extends DetailSession>
    implements $DetailSessionCopyWith<$Res> {
  _$DetailSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayTitle = freezed,
    Object? startAt = freezed,
    Object? durationMinutes = freezed,
    Object? venue = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            displayTitle: freezed == displayTitle
                ? _value.displayTitle
                : displayTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as DetailVenue?,
          )
          as $Val,
    );
  }

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailVenueCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $DetailVenueCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailSessionImplCopyWith<$Res>
    implements $DetailSessionCopyWith<$Res> {
  factory _$$DetailSessionImplCopyWith(
    _$DetailSessionImpl value,
    $Res Function(_$DetailSessionImpl) then,
  ) = __$$DetailSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    DetailVenue? venue,
  });

  @override
  $DetailVenueCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$DetailSessionImplCopyWithImpl<$Res>
    extends _$DetailSessionCopyWithImpl<$Res, _$DetailSessionImpl>
    implements _$$DetailSessionImplCopyWith<$Res> {
  __$$DetailSessionImplCopyWithImpl(
    _$DetailSessionImpl _value,
    $Res Function(_$DetailSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayTitle = freezed,
    Object? startAt = freezed,
    Object? durationMinutes = freezed,
    Object? venue = freezed,
  }) {
    return _then(
      _$DetailSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        displayTitle: freezed == displayTitle
            ? _value.displayTitle
            : displayTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as DetailVenue?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailSessionImpl implements _DetailSession {
  const _$DetailSessionImpl({
    required this.id,
    @JsonKey(name: 'display_title') this.displayTitle,
    @JsonKey(name: 'start_at') this.startAt,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    this.venue,
  });

  factory _$DetailSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailSessionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'display_title')
  final String? displayTitle;
  @override
  @JsonKey(name: 'start_at')
  final DateTime? startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  final DetailVenue? venue;

  @override
  String toString() {
    return 'DetailSession(id: $id, displayTitle: $displayTitle, startAt: $startAt, durationMinutes: $durationMinutes, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    displayTitle,
    startAt,
    durationMinutes,
    venue,
  );

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailSessionImplCopyWith<_$DetailSessionImpl> get copyWith =>
      __$$DetailSessionImplCopyWithImpl<_$DetailSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailSessionImplToJson(this);
  }
}

abstract class _DetailSession implements DetailSession {
  const factory _DetailSession({
    required final int id,
    @JsonKey(name: 'display_title') final String? displayTitle,
    @JsonKey(name: 'start_at') final DateTime? startAt,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    final DetailVenue? venue,
  }) = _$DetailSessionImpl;

  factory _DetailSession.fromJson(Map<String, dynamic> json) =
      _$DetailSessionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'display_title')
  String? get displayTitle;
  @override
  @JsonKey(name: 'start_at')
  DateTime? get startAt;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  DetailVenue? get venue;

  /// Create a copy of DetailSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailSessionImplCopyWith<_$DetailSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DetailVenue _$DetailVenueFromJson(Map<String, dynamic> json) {
  return _DetailVenue.fromJson(json);
}

/// @nodoc
mixin _$DetailVenue {
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this DetailVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailVenueCopyWith<DetailVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailVenueCopyWith<$Res> {
  factory $DetailVenueCopyWith(
    DetailVenue value,
    $Res Function(DetailVenue) then,
  ) = _$DetailVenueCopyWithImpl<$Res, DetailVenue>;
  @useResult
  $Res call({String name, String? address});
}

/// @nodoc
class _$DetailVenueCopyWithImpl<$Res, $Val extends DetailVenue>
    implements $DetailVenueCopyWith<$Res> {
  _$DetailVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? address = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailVenueImplCopyWith<$Res>
    implements $DetailVenueCopyWith<$Res> {
  factory _$$DetailVenueImplCopyWith(
    _$DetailVenueImpl value,
    $Res Function(_$DetailVenueImpl) then,
  ) = __$$DetailVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? address});
}

/// @nodoc
class __$$DetailVenueImplCopyWithImpl<$Res>
    extends _$DetailVenueCopyWithImpl<$Res, _$DetailVenueImpl>
    implements _$$DetailVenueImplCopyWith<$Res> {
  __$$DetailVenueImplCopyWithImpl(
    _$DetailVenueImpl _value,
    $Res Function(_$DetailVenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? address = freezed}) {
    return _then(
      _$DetailVenueImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailVenueImpl implements _DetailVenue {
  const _$DetailVenueImpl({required this.name, this.address});

  factory _$DetailVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailVenueImplFromJson(json);

  @override
  final String name;
  @override
  final String? address;

  @override
  String toString() {
    return 'DetailVenue(name: $name, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailVenueImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, address);

  /// Create a copy of DetailVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailVenueImplCopyWith<_$DetailVenueImpl> get copyWith =>
      __$$DetailVenueImplCopyWithImpl<_$DetailVenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailVenueImplToJson(this);
  }
}

abstract class _DetailVenue implements DetailVenue {
  const factory _DetailVenue({
    required final String name,
    final String? address,
  }) = _$DetailVenueImpl;

  factory _DetailVenue.fromJson(Map<String, dynamic> json) =
      _$DetailVenueImpl.fromJson;

  @override
  String get name;
  @override
  String? get address;

  /// Create a copy of DetailVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailVenueImplCopyWith<_$DetailVenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RebookEligibility _$RebookEligibilityFromJson(Map<String, dynamic> json) {
  return _RebookEligibility.fromJson(json);
}

/// @nodoc
mixin _$RebookEligibility {
  bool get eligible => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  int? get sessionId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this RebookEligibility to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RebookEligibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RebookEligibilityCopyWith<RebookEligibility> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RebookEligibilityCopyWith<$Res> {
  factory $RebookEligibilityCopyWith(
    RebookEligibility value,
    $Res Function(RebookEligibility) then,
  ) = _$RebookEligibilityCopyWithImpl<$Res, RebookEligibility>;
  @useResult
  $Res call({
    bool eligible,
    @JsonKey(name: 'session_id') int? sessionId,
    String? reason,
  });
}

/// @nodoc
class _$RebookEligibilityCopyWithImpl<$Res, $Val extends RebookEligibility>
    implements $RebookEligibilityCopyWith<$Res> {
  _$RebookEligibilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RebookEligibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eligible = null,
    Object? sessionId = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      _value.copyWith(
            eligible: null == eligible
                ? _value.eligible
                : eligible // ignore: cast_nullable_to_non_nullable
                      as bool,
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RebookEligibilityImplCopyWith<$Res>
    implements $RebookEligibilityCopyWith<$Res> {
  factory _$$RebookEligibilityImplCopyWith(
    _$RebookEligibilityImpl value,
    $Res Function(_$RebookEligibilityImpl) then,
  ) = __$$RebookEligibilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool eligible,
    @JsonKey(name: 'session_id') int? sessionId,
    String? reason,
  });
}

/// @nodoc
class __$$RebookEligibilityImplCopyWithImpl<$Res>
    extends _$RebookEligibilityCopyWithImpl<$Res, _$RebookEligibilityImpl>
    implements _$$RebookEligibilityImplCopyWith<$Res> {
  __$$RebookEligibilityImplCopyWithImpl(
    _$RebookEligibilityImpl _value,
    $Res Function(_$RebookEligibilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RebookEligibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eligible = null,
    Object? sessionId = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      _$RebookEligibilityImpl(
        eligible: null == eligible
            ? _value.eligible
            : eligible // ignore: cast_nullable_to_non_nullable
                  as bool,
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RebookEligibilityImpl implements _RebookEligibility {
  const _$RebookEligibilityImpl({
    required this.eligible,
    @JsonKey(name: 'session_id') this.sessionId,
    this.reason,
  });

  factory _$RebookEligibilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RebookEligibilityImplFromJson(json);

  @override
  final bool eligible;
  @override
  @JsonKey(name: 'session_id')
  final int? sessionId;
  @override
  final String? reason;

  @override
  String toString() {
    return 'RebookEligibility(eligible: $eligible, sessionId: $sessionId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RebookEligibilityImpl &&
            (identical(other.eligible, eligible) ||
                other.eligible == eligible) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eligible, sessionId, reason);

  /// Create a copy of RebookEligibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RebookEligibilityImplCopyWith<_$RebookEligibilityImpl> get copyWith =>
      __$$RebookEligibilityImplCopyWithImpl<_$RebookEligibilityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RebookEligibilityImplToJson(this);
  }
}

abstract class _RebookEligibility implements RebookEligibility {
  const factory _RebookEligibility({
    required final bool eligible,
    @JsonKey(name: 'session_id') final int? sessionId,
    final String? reason,
  }) = _$RebookEligibilityImpl;

  factory _RebookEligibility.fromJson(Map<String, dynamic> json) =
      _$RebookEligibilityImpl.fromJson;

  @override
  bool get eligible;
  @override
  @JsonKey(name: 'session_id')
  int? get sessionId;
  @override
  String? get reason;

  /// Create a copy of RebookEligibility
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RebookEligibilityImplCopyWith<_$RebookEligibilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseDetailResponse _$PurchaseDetailResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PurchaseDetailResponse.fromJson(json);
}

/// @nodoc
mixin _$PurchaseDetailResponse {
  PurchaseFullDetail get purchase => throw _privateConstructorUsedError;
  @JsonKey(name: 'rebook_eligibility')
  RebookEligibility get rebookEligibility => throw _privateConstructorUsedError;

  /// Serializes this PurchaseDetailResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseDetailResponseCopyWith<PurchaseDetailResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseDetailResponseCopyWith<$Res> {
  factory $PurchaseDetailResponseCopyWith(
    PurchaseDetailResponse value,
    $Res Function(PurchaseDetailResponse) then,
  ) = _$PurchaseDetailResponseCopyWithImpl<$Res, PurchaseDetailResponse>;
  @useResult
  $Res call({
    PurchaseFullDetail purchase,
    @JsonKey(name: 'rebook_eligibility') RebookEligibility rebookEligibility,
  });

  $PurchaseFullDetailCopyWith<$Res> get purchase;
  $RebookEligibilityCopyWith<$Res> get rebookEligibility;
}

/// @nodoc
class _$PurchaseDetailResponseCopyWithImpl<
  $Res,
  $Val extends PurchaseDetailResponse
>
    implements $PurchaseDetailResponseCopyWith<$Res> {
  _$PurchaseDetailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? purchase = null, Object? rebookEligibility = null}) {
    return _then(
      _value.copyWith(
            purchase: null == purchase
                ? _value.purchase
                : purchase // ignore: cast_nullable_to_non_nullable
                      as PurchaseFullDetail,
            rebookEligibility: null == rebookEligibility
                ? _value.rebookEligibility
                : rebookEligibility // ignore: cast_nullable_to_non_nullable
                      as RebookEligibility,
          )
          as $Val,
    );
  }

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseFullDetailCopyWith<$Res> get purchase {
    return $PurchaseFullDetailCopyWith<$Res>(_value.purchase, (value) {
      return _then(_value.copyWith(purchase: value) as $Val);
    });
  }

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RebookEligibilityCopyWith<$Res> get rebookEligibility {
    return $RebookEligibilityCopyWith<$Res>(_value.rebookEligibility, (value) {
      return _then(_value.copyWith(rebookEligibility: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseDetailResponseImplCopyWith<$Res>
    implements $PurchaseDetailResponseCopyWith<$Res> {
  factory _$$PurchaseDetailResponseImplCopyWith(
    _$PurchaseDetailResponseImpl value,
    $Res Function(_$PurchaseDetailResponseImpl) then,
  ) = __$$PurchaseDetailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PurchaseFullDetail purchase,
    @JsonKey(name: 'rebook_eligibility') RebookEligibility rebookEligibility,
  });

  @override
  $PurchaseFullDetailCopyWith<$Res> get purchase;
  @override
  $RebookEligibilityCopyWith<$Res> get rebookEligibility;
}

/// @nodoc
class __$$PurchaseDetailResponseImplCopyWithImpl<$Res>
    extends
        _$PurchaseDetailResponseCopyWithImpl<$Res, _$PurchaseDetailResponseImpl>
    implements _$$PurchaseDetailResponseImplCopyWith<$Res> {
  __$$PurchaseDetailResponseImplCopyWithImpl(
    _$PurchaseDetailResponseImpl _value,
    $Res Function(_$PurchaseDetailResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? purchase = null, Object? rebookEligibility = null}) {
    return _then(
      _$PurchaseDetailResponseImpl(
        purchase: null == purchase
            ? _value.purchase
            : purchase // ignore: cast_nullable_to_non_nullable
                  as PurchaseFullDetail,
        rebookEligibility: null == rebookEligibility
            ? _value.rebookEligibility
            : rebookEligibility // ignore: cast_nullable_to_non_nullable
                  as RebookEligibility,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseDetailResponseImpl implements _PurchaseDetailResponse {
  const _$PurchaseDetailResponseImpl({
    required this.purchase,
    @JsonKey(name: 'rebook_eligibility') required this.rebookEligibility,
  });

  factory _$PurchaseDetailResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseDetailResponseImplFromJson(json);

  @override
  final PurchaseFullDetail purchase;
  @override
  @JsonKey(name: 'rebook_eligibility')
  final RebookEligibility rebookEligibility;

  @override
  String toString() {
    return 'PurchaseDetailResponse(purchase: $purchase, rebookEligibility: $rebookEligibility)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseDetailResponseImpl &&
            (identical(other.purchase, purchase) ||
                other.purchase == purchase) &&
            (identical(other.rebookEligibility, rebookEligibility) ||
                other.rebookEligibility == rebookEligibility));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, purchase, rebookEligibility);

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseDetailResponseImplCopyWith<_$PurchaseDetailResponseImpl>
  get copyWith =>
      __$$PurchaseDetailResponseImplCopyWithImpl<_$PurchaseDetailResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseDetailResponseImplToJson(this);
  }
}

abstract class _PurchaseDetailResponse implements PurchaseDetailResponse {
  const factory _PurchaseDetailResponse({
    required final PurchaseFullDetail purchase,
    @JsonKey(name: 'rebook_eligibility')
    required final RebookEligibility rebookEligibility,
  }) = _$PurchaseDetailResponseImpl;

  factory _PurchaseDetailResponse.fromJson(Map<String, dynamic> json) =
      _$PurchaseDetailResponseImpl.fromJson;

  @override
  PurchaseFullDetail get purchase;
  @override
  @JsonKey(name: 'rebook_eligibility')
  RebookEligibility get rebookEligibility;

  /// Create a copy of PurchaseDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseDetailResponseImplCopyWith<_$PurchaseDetailResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
