// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'open_session.freezed.dart';
part 'open_session.g.dart';

enum OpenSessionStatus { open, full, confirmed, cancelled, completed }

enum SessionPricingModel { margin, transparent }

enum SessionVisibility { free, invitationOnly, membersOnly }

enum SessionSettlementStatus { pending, cleared, paidOut }

Duration? _healthDurationFromJson(int? microseconds) =>
    microseconds == null ? null : Duration(microseconds: microseconds);
int? _healthDurationToJson(Duration? duration) => duration?.inMicroseconds;

@freezed
class SessionHealth with _$SessionHealth {
  const factory SessionHealth({
    @Default(0) int pendingPayments,
    @Default(false) bool isLowSignupRisk,
    @Default(false) bool isJoinDeadlineAtRisk,
    @Default(0) int trendScore,
    @Default(0) int pendingPaymentAmount,
    @Default(0) int slotsRemaining,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    Duration? timeToStart,
  }) = _SessionHealth;

  factory SessionHealth.fromJson(Map<String, dynamic> json) =>
      _$SessionHealthFromJson(json);
}

/// Resolved per-person session pricing — see BE `SessionPriceResolver`
/// for the resolution rules. UI consumers should branch on
/// [paymentMode] via [isCredit] / [isNominal] / [isUnconfigured] rather
/// than comparing the string literally.
@freezed
class SessionPricing with _$SessionPricing {
  const factory SessionPricing({
    @JsonKey(name: 'effective_price') int? effectivePrice,
    @Default('IDR') String currency,
    @JsonKey(name: 'payment_mode') @Default('unconfigured') String paymentMode,
    @JsonKey(name: 'credit_required') int? creditRequired,
    String? source,
    @JsonKey(name: 'product_id') int? productId,
  }) = _SessionPricing;

  factory SessionPricing.fromJson(Map<String, dynamic> json) =>
      _$SessionPricingFromJson(json);
}

extension SessionPricingX on SessionPricing {
  bool get isNominal => paymentMode == 'nominal';
  bool get isCredit => paymentMode == 'credit';
  bool get isUnconfigured =>
      paymentMode == 'unconfigured' || effectivePrice == null;
}

extension OpenSessionTitleX on OpenSession {
  /// User-facing heading. Prefers [displayTitle] (post-feature-deploy BE
  /// always sets this), falls back to legacy [title] (pre-deploy auto-
  /// name), then to a generic placeholder. Always non-null.
  String get safeTitle => (displayTitle != null && displayTitle!.isNotEmpty)
      ? displayTitle!
      : (title != null && title!.isNotEmpty ? title! : 'Sesi Latihan');
}

@freezed
class OpenSession with _$OpenSession {
  const factory OpenSession({
    required String id,

    /// Raw editable title (nullable post-Issue 2026-05-07-session-title).
    /// Pre-feature-deploy BE sent auto-name here; consumers should read
    /// [displayTitle] (or use the `safeTitle` extension) which handles
    /// both windows.
    String? title,
    required Sport sport,
    required String hostId,
    required String hostName,
    required String venueName,
    required String venueId,
    required DateTime date,
    required String startTime,
    required String endTime,
    @Default(0) int currentPlayers,
    @Default(1) int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,

    /// Legacy alias for `pricing.effective_price` — prefer reading
    /// `pricing` (carries payment mode + currency). Defaulted to 0 so a
    /// null-priced legacy row doesn't fail the whole list parse.
    @Default(0) int pricePerPerson,

    /// Resolved pricing block — source of truth for display. Nullable
    /// because mock fixtures may omit it; consumers fall back to
    /// `pricePerPerson` + tenant currency.
    SessionPricing? pricing,

    /// `title ?? auto-name` from BE. Always non-null on a real response;
    /// nullable here so pre-feature-deploy responses (which omit this
    /// field) still parse — use the `safeTitle` extension at call sites.
    @JsonKey(name: 'display_title') String? displayTitle,

    /// 8-char hash, null when no session-specific photo set. Used to
    /// distinguish "real session photo" (rectangular 16:9) from
    /// "fallback to tenant logo" (square) — when [photoUrls] is non-null
    /// but [photoPath] is null, the URLs point at the tenant logo and
    /// caller renders the centered-on-brand-color fallback layout.
    @JsonKey(name: 'photo_path') String? photoPath,

    /// Hero photo URLs in 4 sizes (sm/md/lg/xl). When [photoPath] is set
    /// these are 16:9 session photos; otherwise BE returns the tenant
    /// `logo_urls` map (square) as the fallback. Null when neither
    /// session nor tenant has a photo.
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? description,
    @Default([]) List<String> participantNames,
    @Default(OpenSessionStatus.open) OpenSessionStatus status,
    DateTime? joinDeadline,
    @Default(SessionPricingModel.margin) SessionPricingModel pricingModel,
    @Default(SessionVisibility.free) SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    @Default(SessionSettlementStatus.pending)
    SessionSettlementStatus settlementStatus,
    @Default(SessionHealth()) SessionHealth health,
  }) = _OpenSession;

  factory OpenSession.fromJson(Map<String, dynamic> json) =>
      _$OpenSessionFromJson(json);
}
