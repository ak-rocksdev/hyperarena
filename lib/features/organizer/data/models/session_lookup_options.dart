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
