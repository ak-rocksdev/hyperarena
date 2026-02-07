import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';

abstract final class MockOwnerData {
  static List<CourtAvailabilityIssue> get issues {
    final now = DateTime.now();
    return [
      CourtAvailabilityIssue(
        id: 'issue-001',
        courtId: 'court-001',
        courtName: 'Lapangan Tenis 1',
        venueId: 'venue-001',
        venueName: 'GOR Senayan Sports Center',
        from: now.add(const Duration(days: 1, hours: 1)),
        to: now.add(const Duration(days: 1, hours: 4)),
        reason: 'Maintenance lampu lapangan',
        requiresOrganizerNotice: true,
      ),
    ];
  }
}
