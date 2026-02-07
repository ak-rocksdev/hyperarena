class ClubProfile {
  const ClubProfile({
    required this.name,
    this.tagline,
    this.city,
    required this.createdAt,
  });

  final String name;
  final String? tagline;
  final String? city;
  final DateTime createdAt;
}
