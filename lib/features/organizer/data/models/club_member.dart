import 'package:hyperarena/core/theme/app_enums.dart';

class ClubMember {
  const ClubMember({
    required this.id,
    required this.name,
    required this.joinedAt,
    this.sportPreferences = const [],
  });

  final String id;
  final String name;
  final DateTime joinedAt;
  final List<Sport> sportPreferences;
}
