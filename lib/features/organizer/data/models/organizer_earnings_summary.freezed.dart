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
  int get disputeHoldBalance =>
      throw _privateConstructorUsedError; // ── Earnings v2 fields (spec: docs/PRD-organizer-dashboard-be-fields.md) ──
  // All nullable — UI hides corresponding sections when BE has not yet
  // populated them. Once BE deploys, the P&L card + expense breakdown +
  // bar chart + delta caption light up automatically.
  int? get grossRevenue => throw _privateConstructorUsedError;
  int? get totalExpenses => throw _privateConstructorUsedError;
  int? get netRevenueThisPeriod => throw _privateConstructorUsedError;
  int? get sessionCount => throw _privateConstructorUsedError;
  int? get prevPeriodNet => throw _privateConstructorUsedError;
  List<double> get weeklyChart => throw _privateConstructorUsedError;
  List<ExpenseCategory> get expenseBreakdown =>
      throw _privateConstructorUsedError;

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
    int? grossRevenue,
    int? totalExpenses,
    int? netRevenueThisPeriod,
    int? sessionCount,
    int? prevPeriodNet,
    List<double> weeklyChart,
    List<ExpenseCategory> expenseBreakdown,
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
    Object? grossRevenue = freezed,
    Object? totalExpenses = freezed,
    Object? netRevenueThisPeriod = freezed,
    Object? sessionCount = freezed,
    Object? prevPeriodNet = freezed,
    Object? weeklyChart = null,
    Object? expenseBreakdown = null,
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
            grossRevenue: freezed == grossRevenue
                ? _value.grossRevenue
                : grossRevenue // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalExpenses: freezed == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as int?,
            netRevenueThisPeriod: freezed == netRevenueThisPeriod
                ? _value.netRevenueThisPeriod
                : netRevenueThisPeriod // ignore: cast_nullable_to_non_nullable
                      as int?,
            sessionCount: freezed == sessionCount
                ? _value.sessionCount
                : sessionCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            prevPeriodNet: freezed == prevPeriodNet
                ? _value.prevPeriodNet
                : prevPeriodNet // ignore: cast_nullable_to_non_nullable
                      as int?,
            weeklyChart: null == weeklyChart
                ? _value.weeklyChart
                : weeklyChart // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            expenseBreakdown: null == expenseBreakdown
                ? _value.expenseBreakdown
                : expenseBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseCategory>,
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
    int? grossRevenue,
    int? totalExpenses,
    int? netRevenueThisPeriod,
    int? sessionCount,
    int? prevPeriodNet,
    List<double> weeklyChart,
    List<ExpenseCategory> expenseBreakdown,
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
    Object? grossRevenue = freezed,
    Object? totalExpenses = freezed,
    Object? netRevenueThisPeriod = freezed,
    Object? sessionCount = freezed,
    Object? prevPeriodNet = freezed,
    Object? weeklyChart = null,
    Object? expenseBreakdown = null,
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
        grossRevenue: freezed == grossRevenue
            ? _value.grossRevenue
            : grossRevenue // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalExpenses: freezed == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as int?,
        netRevenueThisPeriod: freezed == netRevenueThisPeriod
            ? _value.netRevenueThisPeriod
            : netRevenueThisPeriod // ignore: cast_nullable_to_non_nullable
                  as int?,
        sessionCount: freezed == sessionCount
            ? _value.sessionCount
            : sessionCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        prevPeriodNet: freezed == prevPeriodNet
            ? _value.prevPeriodNet
            : prevPeriodNet // ignore: cast_nullable_to_non_nullable
                  as int?,
        weeklyChart: null == weeklyChart
            ? _value._weeklyChart
            : weeklyChart // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        expenseBreakdown: null == expenseBreakdown
            ? _value._expenseBreakdown
            : expenseBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseCategory>,
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
    this.grossRevenue,
    this.totalExpenses,
    this.netRevenueThisPeriod,
    this.sessionCount,
    this.prevPeriodNet,
    final List<double> weeklyChart = const [],
    final List<ExpenseCategory> expenseBreakdown = const [],
  }) : _settlements = settlements,
       _weeklyChart = weeklyChart,
       _expenseBreakdown = expenseBreakdown;

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
  // ── Earnings v2 fields (spec: docs/PRD-organizer-dashboard-be-fields.md) ──
  // All nullable — UI hides corresponding sections when BE has not yet
  // populated them. Once BE deploys, the P&L card + expense breakdown +
  // bar chart + delta caption light up automatically.
  @override
  final int? grossRevenue;
  @override
  final int? totalExpenses;
  @override
  final int? netRevenueThisPeriod;
  @override
  final int? sessionCount;
  @override
  final int? prevPeriodNet;
  final List<double> _weeklyChart;
  @override
  @JsonKey()
  List<double> get weeklyChart {
    if (_weeklyChart is EqualUnmodifiableListView) return _weeklyChart;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyChart);
  }

  final List<ExpenseCategory> _expenseBreakdown;
  @override
  @JsonKey()
  List<ExpenseCategory> get expenseBreakdown {
    if (_expenseBreakdown is EqualUnmodifiableListView)
      return _expenseBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseBreakdown);
  }

  @override
  String toString() {
    return 'OrganizerEarningsSummary(availableBalance: $availableBalance, pendingBalance: $pendingBalance, paidOutThisMonth: $paidOutThisMonth, settlements: $settlements, pendingPlayerBalance: $pendingPlayerBalance, pendingVenueBalance: $pendingVenueBalance, disputeHoldBalance: $disputeHoldBalance, grossRevenue: $grossRevenue, totalExpenses: $totalExpenses, netRevenueThisPeriod: $netRevenueThisPeriod, sessionCount: $sessionCount, prevPeriodNet: $prevPeriodNet, weeklyChart: $weeklyChart, expenseBreakdown: $expenseBreakdown)';
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
                other.disputeHoldBalance == disputeHoldBalance) &&
            (identical(other.grossRevenue, grossRevenue) ||
                other.grossRevenue == grossRevenue) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netRevenueThisPeriod, netRevenueThisPeriod) ||
                other.netRevenueThisPeriod == netRevenueThisPeriod) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount) &&
            (identical(other.prevPeriodNet, prevPeriodNet) ||
                other.prevPeriodNet == prevPeriodNet) &&
            const DeepCollectionEquality().equals(
              other._weeklyChart,
              _weeklyChart,
            ) &&
            const DeepCollectionEquality().equals(
              other._expenseBreakdown,
              _expenseBreakdown,
            ));
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
    grossRevenue,
    totalExpenses,
    netRevenueThisPeriod,
    sessionCount,
    prevPeriodNet,
    const DeepCollectionEquality().hash(_weeklyChart),
    const DeepCollectionEquality().hash(_expenseBreakdown),
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
    final int? grossRevenue,
    final int? totalExpenses,
    final int? netRevenueThisPeriod,
    final int? sessionCount,
    final int? prevPeriodNet,
    final List<double> weeklyChart,
    final List<ExpenseCategory> expenseBreakdown,
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
  int get disputeHoldBalance; // ── Earnings v2 fields (spec: docs/PRD-organizer-dashboard-be-fields.md) ──
  // All nullable — UI hides corresponding sections when BE has not yet
  // populated them. Once BE deploys, the P&L card + expense breakdown +
  // bar chart + delta caption light up automatically.
  @override
  int? get grossRevenue;
  @override
  int? get totalExpenses;
  @override
  int? get netRevenueThisPeriod;
  @override
  int? get sessionCount;
  @override
  int? get prevPeriodNet;
  @override
  List<double> get weeklyChart;
  @override
  List<ExpenseCategory> get expenseBreakdown;

  /// Create a copy of OrganizerEarningsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizerEarningsSummaryImplCopyWith<_$OrganizerEarningsSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  return _ExpenseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategory {
  String get label => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;

  /// 7-char hex like `#EF4444` — optional override. When null, the client
  /// picks a color from a fixed rotation based on row index.
  String? get colorHex => throw _privateConstructorUsedError;

  /// Emoji or icon-name override. When null, the client falls back to a
  /// generic receipt glyph.
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this ExpenseCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCategoryCopyWith<ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryCopyWith<$Res> {
  factory $ExpenseCategoryCopyWith(
    ExpenseCategory value,
    $Res Function(ExpenseCategory) then,
  ) = _$ExpenseCategoryCopyWithImpl<$Res, ExpenseCategory>;
  @useResult
  $Res call({
    String label,
    String? subtitle,
    int amount,
    String? colorHex,
    String? icon,
  });
}

/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res, $Val extends ExpenseCategory>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? subtitle = freezed,
    Object? amount = null,
    Object? colorHex = freezed,
    Object? icon = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            colorHex: freezed == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryImplCopyWith<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  factory _$$ExpenseCategoryImplCopyWith(
    _$ExpenseCategoryImpl value,
    $Res Function(_$ExpenseCategoryImpl) then,
  ) = __$$ExpenseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    String? subtitle,
    int amount,
    String? colorHex,
    String? icon,
  });
}

/// @nodoc
class __$$ExpenseCategoryImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryCopyWithImpl<$Res, _$ExpenseCategoryImpl>
    implements _$$ExpenseCategoryImplCopyWith<$Res> {
  __$$ExpenseCategoryImplCopyWithImpl(
    _$ExpenseCategoryImpl _value,
    $Res Function(_$ExpenseCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? subtitle = freezed,
    Object? amount = null,
    Object? colorHex = freezed,
    Object? icon = freezed,
  }) {
    return _then(
      _$ExpenseCategoryImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        colorHex: freezed == colorHex
            ? _value.colorHex
            : colorHex // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryImpl implements _ExpenseCategory {
  const _$ExpenseCategoryImpl({
    required this.label,
    this.subtitle,
    required this.amount,
    this.colorHex,
    this.icon,
  });

  factory _$ExpenseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryImplFromJson(json);

  @override
  final String label;
  @override
  final String? subtitle;
  @override
  final int amount;

  /// 7-char hex like `#EF4444` — optional override. When null, the client
  /// picks a color from a fixed rotation based on row index.
  @override
  final String? colorHex;

  /// Emoji or icon-name override. When null, the client falls back to a
  /// generic receipt glyph.
  @override
  final String? icon;

  @override
  String toString() {
    return 'ExpenseCategory(label: $label, subtitle: $subtitle, amount: $amount, colorHex: $colorHex, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, subtitle, amount, colorHex, icon);

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      __$$ExpenseCategoryImplCopyWithImpl<_$ExpenseCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryImplToJson(this);
  }
}

abstract class _ExpenseCategory implements ExpenseCategory {
  const factory _ExpenseCategory({
    required final String label,
    final String? subtitle,
    required final int amount,
    final String? colorHex,
    final String? icon,
  }) = _$ExpenseCategoryImpl;

  factory _ExpenseCategory.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryImpl.fromJson;

  @override
  String get label;
  @override
  String? get subtitle;
  @override
  int get amount;

  /// 7-char hex like `#EF4444` — optional override. When null, the client
  /// picks a color from a fixed rotation based on row index.
  @override
  String? get colorHex;

  /// Emoji or icon-name override. When null, the client falls back to a
  /// generic receipt glyph.
  @override
  String? get icon;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
