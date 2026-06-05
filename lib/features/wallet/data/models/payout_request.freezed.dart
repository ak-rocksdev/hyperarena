// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PayoutRequest _$PayoutRequestFromJson(Map<String, dynamic> json) {
  return _PayoutRequest.fromJson(json);
}

/// @nodoc
mixin _$PayoutRequest {
  int get id => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount_cents')
  int get totalAmountCents => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending'|'approved'|'rejected'|'cancelled'
  @JsonKey(name: 'requested_at')
  DateTime get requestedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_note')
  String? get rejectionNote => throw _privateConstructorUsedError;

  /// Linked Payout list (eager-loaded by show endpoint, summary fields only
  /// on list). Counted in MVP for "X sesi" display in the History row.
  List<CoachPayout> get payouts => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_by')
  Map<String, dynamic>? get processedBy => throw _privateConstructorUsedError;

  /// Serializes this PayoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayoutRequestCopyWith<PayoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutRequestCopyWith<$Res> {
  factory $PayoutRequestCopyWith(
    PayoutRequest value,
    $Res Function(PayoutRequest) then,
  ) = _$PayoutRequestCopyWithImpl<$Res, PayoutRequest>;
  @useResult
  $Res call({
    int id,
    String period,
    @JsonKey(name: 'total_amount_cents') int totalAmountCents,
    String status,
    @JsonKey(name: 'requested_at') DateTime requestedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'rejection_note') String? rejectionNote,
    List<CoachPayout> payouts,
    @JsonKey(name: 'processed_by') Map<String, dynamic>? processedBy,
  });
}

/// @nodoc
class _$PayoutRequestCopyWithImpl<$Res, $Val extends PayoutRequest>
    implements $PayoutRequestCopyWith<$Res> {
  _$PayoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? period = null,
    Object? totalAmountCents = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? rejectionNote = freezed,
    Object? payouts = null,
    Object? processedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmountCents: null == totalAmountCents
                ? _value.totalAmountCents
                : totalAmountCents // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestedAt: null == requestedAt
                ? _value.requestedAt
                : requestedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            processedAt: freezed == processedAt
                ? _value.processedAt
                : processedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rejectionNote: freezed == rejectionNote
                ? _value.rejectionNote
                : rejectionNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            payouts: null == payouts
                ? _value.payouts
                : payouts // ignore: cast_nullable_to_non_nullable
                      as List<CoachPayout>,
            processedBy: freezed == processedBy
                ? _value.processedBy
                : processedBy // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PayoutRequestImplCopyWith<$Res>
    implements $PayoutRequestCopyWith<$Res> {
  factory _$$PayoutRequestImplCopyWith(
    _$PayoutRequestImpl value,
    $Res Function(_$PayoutRequestImpl) then,
  ) = __$$PayoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String period,
    @JsonKey(name: 'total_amount_cents') int totalAmountCents,
    String status,
    @JsonKey(name: 'requested_at') DateTime requestedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'rejection_note') String? rejectionNote,
    List<CoachPayout> payouts,
    @JsonKey(name: 'processed_by') Map<String, dynamic>? processedBy,
  });
}

/// @nodoc
class __$$PayoutRequestImplCopyWithImpl<$Res>
    extends _$PayoutRequestCopyWithImpl<$Res, _$PayoutRequestImpl>
    implements _$$PayoutRequestImplCopyWith<$Res> {
  __$$PayoutRequestImplCopyWithImpl(
    _$PayoutRequestImpl _value,
    $Res Function(_$PayoutRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? period = null,
    Object? totalAmountCents = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? rejectionNote = freezed,
    Object? payouts = null,
    Object? processedBy = freezed,
  }) {
    return _then(
      _$PayoutRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmountCents: null == totalAmountCents
            ? _value.totalAmountCents
            : totalAmountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestedAt: null == requestedAt
            ? _value.requestedAt
            : requestedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        processedAt: freezed == processedAt
            ? _value.processedAt
            : processedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rejectionNote: freezed == rejectionNote
            ? _value.rejectionNote
            : rejectionNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        payouts: null == payouts
            ? _value._payouts
            : payouts // ignore: cast_nullable_to_non_nullable
                  as List<CoachPayout>,
        processedBy: freezed == processedBy
            ? _value._processedBy
            : processedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PayoutRequestImpl extends _PayoutRequest {
  const _$PayoutRequestImpl({
    required this.id,
    required this.period,
    @JsonKey(name: 'total_amount_cents') required this.totalAmountCents,
    required this.status,
    @JsonKey(name: 'requested_at') required this.requestedAt,
    @JsonKey(name: 'processed_at') this.processedAt,
    @JsonKey(name: 'rejection_note') this.rejectionNote,
    final List<CoachPayout> payouts = const [],
    @JsonKey(name: 'processed_by') final Map<String, dynamic>? processedBy,
  }) : _payouts = payouts,
       _processedBy = processedBy,
       super._();

  factory _$PayoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutRequestImplFromJson(json);

  @override
  final int id;
  @override
  final String period;
  @override
  @JsonKey(name: 'total_amount_cents')
  final int totalAmountCents;
  @override
  final String status;
  // 'pending'|'approved'|'rejected'|'cancelled'
  @override
  @JsonKey(name: 'requested_at')
  final DateTime requestedAt;
  @override
  @JsonKey(name: 'processed_at')
  final DateTime? processedAt;
  @override
  @JsonKey(name: 'rejection_note')
  final String? rejectionNote;

  /// Linked Payout list (eager-loaded by show endpoint, summary fields only
  /// on list). Counted in MVP for "X sesi" display in the History row.
  final List<CoachPayout> _payouts;

  /// Linked Payout list (eager-loaded by show endpoint, summary fields only
  /// on list). Counted in MVP for "X sesi" display in the History row.
  @override
  @JsonKey()
  List<CoachPayout> get payouts {
    if (_payouts is EqualUnmodifiableListView) return _payouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payouts);
  }

  final Map<String, dynamic>? _processedBy;
  @override
  @JsonKey(name: 'processed_by')
  Map<String, dynamic>? get processedBy {
    final value = _processedBy;
    if (value == null) return null;
    if (_processedBy is EqualUnmodifiableMapView) return _processedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PayoutRequest(id: $id, period: $period, totalAmountCents: $totalAmountCents, status: $status, requestedAt: $requestedAt, processedAt: $processedAt, rejectionNote: $rejectionNote, payouts: $payouts, processedBy: $processedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.totalAmountCents, totalAmountCents) ||
                other.totalAmountCents == totalAmountCents) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.rejectionNote, rejectionNote) ||
                other.rejectionNote == rejectionNote) &&
            const DeepCollectionEquality().equals(other._payouts, _payouts) &&
            const DeepCollectionEquality().equals(
              other._processedBy,
              _processedBy,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    period,
    totalAmountCents,
    status,
    requestedAt,
    processedAt,
    rejectionNote,
    const DeepCollectionEquality().hash(_payouts),
    const DeepCollectionEquality().hash(_processedBy),
  );

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutRequestImplCopyWith<_$PayoutRequestImpl> get copyWith =>
      __$$PayoutRequestImplCopyWithImpl<_$PayoutRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayoutRequestImplToJson(this);
  }
}

abstract class _PayoutRequest extends PayoutRequest {
  const factory _PayoutRequest({
    required final int id,
    required final String period,
    @JsonKey(name: 'total_amount_cents') required final int totalAmountCents,
    required final String status,
    @JsonKey(name: 'requested_at') required final DateTime requestedAt,
    @JsonKey(name: 'processed_at') final DateTime? processedAt,
    @JsonKey(name: 'rejection_note') final String? rejectionNote,
    final List<CoachPayout> payouts,
    @JsonKey(name: 'processed_by') final Map<String, dynamic>? processedBy,
  }) = _$PayoutRequestImpl;
  const _PayoutRequest._() : super._();

  factory _PayoutRequest.fromJson(Map<String, dynamic> json) =
      _$PayoutRequestImpl.fromJson;

  @override
  int get id;
  @override
  String get period;
  @override
  @JsonKey(name: 'total_amount_cents')
  int get totalAmountCents;
  @override
  String get status; // 'pending'|'approved'|'rejected'|'cancelled'
  @override
  @JsonKey(name: 'requested_at')
  DateTime get requestedAt;
  @override
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt;
  @override
  @JsonKey(name: 'rejection_note')
  String? get rejectionNote;

  /// Linked Payout list (eager-loaded by show endpoint, summary fields only
  /// on list). Counted in MVP for "X sesi" display in the History row.
  @override
  List<CoachPayout> get payouts;
  @override
  @JsonKey(name: 'processed_by')
  Map<String, dynamic>? get processedBy;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayoutRequestImplCopyWith<_$PayoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
