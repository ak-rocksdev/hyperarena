// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer_earnings_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrganizerSessionSettlement _$OrganizerSessionSettlementFromJson(
  Map<String, dynamic> json,
) {
  return _OrganizerSessionSettlement.fromJson(json);
}

/// @nodoc
mixin _$OrganizerSessionSettlement {
  String get sessionId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get grossRevenue => throw _privateConstructorUsedError;
  int get organizerFee => throw _privateConstructorUsedError;
  int get estimatedCost => throw _privateConstructorUsedError;
  int get netRevenue => throw _privateConstructorUsedError;
  SessionSettlementStatus get settlementStatus =>
      throw _privateConstructorUsedError;

  /// Serializes this OrganizerSessionSettlement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizerSessionSettlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizerSessionSettlementCopyWith<OrganizerSessionSettlement>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerSessionSettlementCopyWith<$Res> {
  factory $OrganizerSessionSettlementCopyWith(
    OrganizerSessionSettlement value,
    $Res Function(OrganizerSessionSettlement) then,
  ) =
      _$OrganizerSessionSettlementCopyWithImpl<
        $Res,
        OrganizerSessionSettlement
      >;
  @useResult
  $Res call({
    String sessionId,
    String title,
    DateTime date,
    int grossRevenue,
    int organizerFee,
    int estimatedCost,
    int netRevenue,
    SessionSettlementStatus settlementStatus,
  });
}

/// @nodoc
class _$OrganizerSessionSettlementCopyWithImpl<
  $Res,
  $Val extends OrganizerSessionSettlement
>
    implements $OrganizerSessionSettlementCopyWith<$Res> {
  _$OrganizerSessionSettlementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizerSessionSettlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? title = null,
    Object? date = null,
    Object? grossRevenue = null,
    Object? organizerFee = null,
    Object? estimatedCost = null,
    Object? netRevenue = null,
    Object? settlementStatus = null,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            grossRevenue: null == grossRevenue
                ? _value.grossRevenue
                : grossRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            organizerFee: null == organizerFee
                ? _value.organizerFee
                : organizerFee // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedCost: null == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as int,
            netRevenue: null == netRevenue
                ? _value.netRevenue
                : netRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            settlementStatus: null == settlementStatus
                ? _value.settlementStatus
                : settlementStatus // ignore: cast_nullable_to_non_nullable
                      as SessionSettlementStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizerSessionSettlementImplCopyWith<$Res>
    implements $OrganizerSessionSettlementCopyWith<$Res> {
  factory _$$OrganizerSessionSettlementImplCopyWith(
    _$OrganizerSessionSettlementImpl value,
    $Res Function(_$OrganizerSessionSettlementImpl) then,
  ) = __$$OrganizerSessionSettlementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    String title,
    DateTime date,
    int grossRevenue,
    int organizerFee,
    int estimatedCost,
    int netRevenue,
    SessionSettlementStatus settlementStatus,
  });
}

/// @nodoc
class __$$OrganizerSessionSettlementImplCopyWithImpl<$Res>
    extends
        _$OrganizerSessionSettlementCopyWithImpl<
          $Res,
          _$OrganizerSessionSettlementImpl
        >
    implements _$$OrganizerSessionSettlementImplCopyWith<$Res> {
  __$$OrganizerSessionSettlementImplCopyWithImpl(
    _$OrganizerSessionSettlementImpl _value,
    $Res Function(_$OrganizerSessionSettlementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizerSessionSettlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? title = null,
    Object? date = null,
    Object? grossRevenue = null,
    Object? organizerFee = null,
    Object? estimatedCost = null,
    Object? netRevenue = null,
    Object? settlementStatus = null,
  }) {
    return _then(
      _$OrganizerSessionSettlementImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        grossRevenue: null == grossRevenue
            ? _value.grossRevenue
            : grossRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        organizerFee: null == organizerFee
            ? _value.organizerFee
            : organizerFee // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedCost: null == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as int,
        netRevenue: null == netRevenue
            ? _value.netRevenue
            : netRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        settlementStatus: null == settlementStatus
            ? _value.settlementStatus
            : settlementStatus // ignore: cast_nullable_to_non_nullable
                  as SessionSettlementStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerSessionSettlementImpl implements _OrganizerSessionSettlement {
  const _$OrganizerSessionSettlementImpl({
    required this.sessionId,
    required this.title,
    required this.date,
    required this.grossRevenue,
    this.organizerFee = 0,
    this.estimatedCost = 0,
    required this.netRevenue,
    this.settlementStatus = SessionSettlementStatus.pending,
  });

  factory _$OrganizerSessionSettlementImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$OrganizerSessionSettlementImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String title;
  @override
  final DateTime date;
  @override
  final int grossRevenue;
  @override
  @JsonKey()
  final int organizerFee;
  @override
  @JsonKey()
  final int estimatedCost;
  @override
  final int netRevenue;
  @override
  @JsonKey()
  final SessionSettlementStatus settlementStatus;

  @override
  String toString() {
    return 'OrganizerSessionSettlement(sessionId: $sessionId, title: $title, date: $date, grossRevenue: $grossRevenue, organizerFee: $organizerFee, estimatedCost: $estimatedCost, netRevenue: $netRevenue, settlementStatus: $settlementStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerSessionSettlementImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.grossRevenue, grossRevenue) ||
                other.grossRevenue == grossRevenue) &&
            (identical(other.organizerFee, organizerFee) ||
                other.organizerFee == organizerFee) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.netRevenue, netRevenue) ||
                other.netRevenue == netRevenue) &&
            (identical(other.settlementStatus, settlementStatus) ||
                other.settlementStatus == settlementStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    title,
    date,
    grossRevenue,
    organizerFee,
    estimatedCost,
    netRevenue,
    settlementStatus,
  );

  /// Create a copy of OrganizerSessionSettlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerSessionSettlementImplCopyWith<_$OrganizerSessionSettlementImpl>
  get copyWith =>
      __$$OrganizerSessionSettlementImplCopyWithImpl<
        _$OrganizerSessionSettlementImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerSessionSettlementImplToJson(this);
  }
}

abstract class _OrganizerSessionSettlement
    implements OrganizerSessionSettlement {
  const factory _OrganizerSessionSettlement({
    required final String sessionId,
    required final String title,
    required final DateTime date,
    required final int grossRevenue,
    final int organizerFee,
    final int estimatedCost,
    required final int netRevenue,
    final SessionSettlementStatus settlementStatus,
  }) = _$OrganizerSessionSettlementImpl;

  factory _OrganizerSessionSettlement.fromJson(Map<String, dynamic> json) =
      _$OrganizerSessionSettlementImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get title;
  @override
  DateTime get date;
  @override
  int get grossRevenue;
  @override
  int get organizerFee;
  @override
  int get estimatedCost;
  @override
  int get netRevenue;
  @override
  SessionSettlementStatus get settlementStatus;

  /// Create a copy of OrganizerSessionSettlement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizerSessionSettlementImplCopyWith<_$OrganizerSessionSettlementImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrganizerEarningsSummary _$OrganizerEarningsSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _OrganizerEarningsSummary.fromJson(json);
}

/// @nodoc
mixin _$OrganizerEarningsSummary {
  int get availableBalance => throw _privateConstructorUsedError;
  int get pendingBalance => throw _privateConstructorUsedError;
  int get paidOutThisMonth => throw _privateConstructorUsedError;
  List<OrganizerSessionSettlement> get settlements =>
      throw _privateConstructorUsedError;
  int get pendingPlayerBalance => throw _privateConstructorUsedError;
  int get pendingVenueBalance => throw _privateConstructorUsedError;
  int get disputeHoldBalance => throw _privateConstructorUsedError;

  /// Serializes this OrganizerEarningsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizerEarningsSummaryCopyWith<OrganizerEarningsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerEarningsSummaryCopyWith<$Res> {
  factory $OrganizerEarningsSummaryCopyWith(
    OrganizerEarningsSummary value,
    $Res Function(OrganizerEarningsSummary) then,
  ) = _$OrganizerEarningsSummaryCopyWithImpl<$Res, OrganizerEarningsSummary>;
  @useResult
  $Res call({
    int availableBalance,
    int pendingBalance,
    int paidOutThisMonth,
    List<OrganizerSessionSettlement> settlements,
    int pendingPlayerBalance,
    int pendingVenueBalance,
    int disputeHoldBalance,
  });
}

/// @nodoc
class _$OrganizerEarningsSummaryCopyWithImpl<
  $Res,
  $Val extends OrganizerEarningsSummary
>
    implements $OrganizerEarningsSummaryCopyWith<$Res> {
  _$OrganizerEarningsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? paidOutThisMonth = null,
    Object? settlements = null,
    Object? pendingPlayerBalance = null,
    Object? pendingVenueBalance = null,
    Object? disputeHoldBalance = null,
  }) {
    return _then(
      _value.copyWith(
            availableBalance: null == availableBalance
                ? _value.availableBalance
                : availableBalance // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingBalance: null == pendingBalance
                ? _value.pendingBalance
                : pendingBalance // ignore: cast_nullable_to_non_nullable
                      as int,
            paidOutThisMonth: null == paidOutThisMonth
                ? _value.paidOutThisMonth
                : paidOutThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            settlements: null == settlements
                ? _value.settlements
                : settlements // ignore: cast_nullable_to_non_nullable
                      as List<OrganizerSessionSettlement>,
            pendingPlayerBalance: null == pendingPlayerBalance
                ? _value.pendingPlayerBalance
                : pendingPlayerBalance // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingVenueBalance: null == pendingVenueBalance
                ? _value.pendingVenueBalance
                : pendingVenueBalance // ignore: cast_nullable_to_non_nullable
                      as int,
            disputeHoldBalance: null == disputeHoldBalance
                ? _value.disputeHoldBalance
                : disputeHoldBalance // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizerEarningsSummaryImplCopyWith<$Res>
    implements $OrganizerEarningsSummaryCopyWith<$Res> {
  factory _$$OrganizerEarningsSummaryImplCopyWith(
    _$OrganizerEarningsSummaryImpl value,
    $Res Function(_$OrganizerEarningsSummaryImpl) then,
  ) = __$$OrganizerEarningsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int availableBalance,
    int pendingBalance,
    int paidOutThisMonth,
    List<OrganizerSessionSettlement> settlements,
    int pendingPlayerBalance,
    int pendingVenueBalance,
    int disputeHoldBalance,
  });
}

/// @nodoc
class __$$OrganizerEarningsSummaryImplCopyWithImpl<$Res>
    extends
        _$OrganizerEarningsSummaryCopyWithImpl<
          $Res,
          _$OrganizerEarningsSummaryImpl
        >
    implements _$$OrganizerEarningsSummaryImplCopyWith<$Res> {
  __$$OrganizerEarningsSummaryImplCopyWithImpl(
    _$OrganizerEarningsSummaryImpl _value,
    $Res Function(_$OrganizerEarningsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? paidOutThisMonth = null,
    Object? settlements = null,
    Object? pendingPlayerBalance = null,
    Object? pendingVenueBalance = null,
    Object? disputeHoldBalance = null,
  }) {
    return _then(
      _$OrganizerEarningsSummaryImpl(
        availableBalance: null == availableBalance
            ? _value.availableBalance
            : availableBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingBalance: null == pendingBalance
            ? _value.pendingBalance
            : pendingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        paidOutThisMonth: null == paidOutThisMonth
            ? _value.paidOutThisMonth
            : paidOutThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        settlements: null == settlements
            ? _value._settlements
            : settlements // ignore: cast_nullable_to_non_nullable
                  as List<OrganizerSessionSettlement>,
        pendingPlayerBalance: null == pendingPlayerBalance
            ? _value.pendingPlayerBalance
            : pendingPlayerBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingVenueBalance: null == pendingVenueBalance
            ? _value.pendingVenueBalance
            : pendingVenueBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        disputeHoldBalance: null == disputeHoldBalance
            ? _value.disputeHoldBalance
            : disputeHoldBalance // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerEarningsSummaryImpl implements _OrganizerEarningsSummary {
  const _$OrganizerEarningsSummaryImpl({
    this.availableBalance = 0,
    this.pendingBalance = 0,
    this.paidOutThisMonth = 0,
    final List<OrganizerSessionSettlement> settlements = const [],
    this.pendingPlayerBalance = 0,
    this.pendingVenueBalance = 0,
    this.disputeHoldBalance = 0,
  }) : _settlements = settlements;

  factory _$OrganizerEarningsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerEarningsSummaryImplFromJson(json);

  @override
  @JsonKey()
  final int availableBalance;
  @override
  @JsonKey()
  final int pendingBalance;
  @override
  @JsonKey()
  final int paidOutThisMonth;
  final List<OrganizerSessionSettlement> _settlements;
  @override
  @JsonKey()
  List<OrganizerSessionSettlement> get settlements {
    if (_settlements is EqualUnmodifiableListView) return _settlements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_settlements);
  }

  @override
  @JsonKey()
  final int pendingPlayerBalance;
  @override
  @JsonKey()
  final int pendingVenueBalance;
  @override
  @JsonKey()
  final int disputeHoldBalance;

  @override
  String toString() {
    return 'OrganizerEarningsSummary(availableBalance: $availableBalance, pendingBalance: $pendingBalance, paidOutThisMonth: $paidOutThisMonth, settlements: $settlements, pendingPlayerBalance: $pendingPlayerBalance, pendingVenueBalance: $pendingVenueBalance, disputeHoldBalance: $disputeHoldBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerEarningsSummaryImpl &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.pendingBalance, pendingBalance) ||
                other.pendingBalance == pendingBalance) &&
            (identical(other.paidOutThisMonth, paidOutThisMonth) ||
                other.paidOutThisMonth == paidOutThisMonth) &&
            const DeepCollectionEquality().equals(
              other._settlements,
              _settlements,
            ) &&
            (identical(other.pendingPlayerBalance, pendingPlayerBalance) ||
                other.pendingPlayerBalance == pendingPlayerBalance) &&
            (identical(other.pendingVenueBalance, pendingVenueBalance) ||
                other.pendingVenueBalance == pendingVenueBalance) &&
            (identical(other.disputeHoldBalance, disputeHoldBalance) ||
                other.disputeHoldBalance == disputeHoldBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    availableBalance,
    pendingBalance,
    paidOutThisMonth,
    const DeepCollectionEquality().hash(_settlements),
    pendingPlayerBalance,
    pendingVenueBalance,
    disputeHoldBalance,
  );

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerEarningsSummaryImplCopyWith<_$OrganizerEarningsSummaryImpl>
  get copyWith =>
      __$$OrganizerEarningsSummaryImplCopyWithImpl<
        _$OrganizerEarningsSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerEarningsSummaryImplToJson(this);
  }
}

abstract class _OrganizerEarningsSummary implements OrganizerEarningsSummary {
  const factory _OrganizerEarningsSummary({
    final int availableBalance,
    final int pendingBalance,
    final int paidOutThisMonth,
    final List<OrganizerSessionSettlement> settlements,
    final int pendingPlayerBalance,
    final int pendingVenueBalance,
    final int disputeHoldBalance,
  }) = _$OrganizerEarningsSummaryImpl;

  factory _OrganizerEarningsSummary.fromJson(Map<String, dynamic> json) =
      _$OrganizerEarningsSummaryImpl.fromJson;

  @override
  int get availableBalance;
  @override
  int get pendingBalance;
  @override
  int get paidOutThisMonth;
  @override
  List<OrganizerSessionSettlement> get settlements;
  @override
  int get pendingPlayerBalance;
  @override
  int get pendingVenueBalance;
  @override
  int get disputeHoldBalance;

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizerEarningsSummaryImplCopyWith<_$OrganizerEarningsSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
