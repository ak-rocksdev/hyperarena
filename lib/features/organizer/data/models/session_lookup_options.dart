import 'package:hyperarena/core/theme/app_enums.dart';

/// Lightweight lookup options that feed the create-session pickers. These are
/// deliberately plain (not freezed) — they're read-only view data.

class CoachOption {
  const CoachOption({
    required this.id,
    required this.name,
    this.ratePerSession, // minor units
    this.currency,
    this.avatarUrl,
  });

  final int id;
  final String name;
  final int? ratePerSession;
  final String? currency;
  final String? avatarUrl;
}

class VenueOption {
  const VenueOption({required this.id, required this.name, this.city});

  final String id;
  final String name;
  final String? city;
}

/// A Google Places autocomplete suggestion (from the BE proxy).
class PlacePrediction {
  const PlacePrediction({
    required this.placeId,
    required this.mainText,
    this.secondaryText,
  });

  final String placeId;
  final String mainText;
  final String? secondaryText;
}

/// Resolved place fields for a new venue (from the BE Places details proxy).
class PlaceDetails {
  const PlaceDetails({
    required this.googlePlaceId,
    required this.name,
    this.address,
    this.lat,
    this.lng,
  });

  final String googlePlaceId;
  final String name;
  final String? address;
  final double? lat;
  final double? lng;
}

class RecentSessionOption {
  const RecentSessionOption({
    required this.id,
    required this.startAt,
    required this.type,
    this.coachName,
    this.venueName,
    required this.createdAt,
  });

  final String id;
  final DateTime startAt;
  final SessionType type;
  final String? coachName;
  final String? venueName;
  final DateTime createdAt;
}
