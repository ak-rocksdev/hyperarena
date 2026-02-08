class ClubProfile {
  const ClubProfile({
    required this.name,
    this.tagline,
    this.city,
    this.coverPhotoUrl,
    required this.createdAt,
  });

  final String name;
  final String? tagline;
  final String? city;
  final String? coverPhotoUrl;
  final DateTime createdAt;
}
