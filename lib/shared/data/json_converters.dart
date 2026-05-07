/// Converts any dynamic value to String ID.
/// Used by all marketplace Freezed models where the backend sends int IDs.
String idFromJson(dynamic v) => v.toString();

/// Converts a nullable dynamic value to nullable String ID.
String? nullableIdFromJson(dynamic v) => v?.toString();

/// Converts dynamic lat/lng values (may be string or num from API).
double? latLngFromJson(dynamic v) =>
    v == null ? null : (v is num ? v.toDouble() : double.tryParse(v.toString()));

/// Parses an ISO-8601 datetime as a naive wall-clock DateTime, ignoring the
/// offset.
///
/// Backend serializes session/booking datetimes with the tenant's local
/// offset (e.g. `2026-05-07T15:00:00+07:00`). Dart's `DateTime.parse`
/// consumes that offset and returns the absolute instant in the device's
/// local representation — so a Malaysia-set device viewing a Jakarta
/// session sees `16:00` instead of `15:00`. We preserve the wall-clock by
/// constructing the DateTime from the string components directly. The
/// resulting DateTime's hour/minute match what the tenant set, regardless
/// of device timezone — exactly what `Formatters.formatTimeHm` etc. render.
///
/// Only apply to event-time fields the BE has already converted to tenant
/// tz (start_at, booked_at, paid_at, etc., post Issue 19.6 sweep). Audit
/// columns like `created_at`/`updated_at` still arrive in UTC `Z` and
/// should keep the default parsing.
DateTime tenantWallClockFromJson(String iso) {
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2}))?')
      .firstMatch(iso);
  if (m == null) return DateTime.parse(iso);
  return DateTime(
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
    int.parse(m.group(4)!),
    int.parse(m.group(5)!),
    int.parse(m.group(6) ?? '0'),
  );
}

/// Nullable variant of [tenantWallClockFromJson].
DateTime? tenantWallClockFromJsonNullable(String? iso) =>
    iso == null ? null : tenantWallClockFromJson(iso);
