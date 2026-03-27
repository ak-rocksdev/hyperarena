/// Converts any dynamic value to String ID.
/// Used by all marketplace Freezed models where the backend sends int IDs.
String idFromJson(dynamic v) => v.toString();

/// Converts a nullable dynamic value to nullable String ID.
String? nullableIdFromJson(dynamic v) => v?.toString();

/// Converts dynamic lat/lng values (may be string or num from API).
double? latLngFromJson(dynamic v) =>
    v == null ? null : (v is num ? v.toDouble() : double.tryParse(v.toString()));
