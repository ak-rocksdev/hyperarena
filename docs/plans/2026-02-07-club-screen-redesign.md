# Club Screen Redesign — Organizer "Komunitas" → "Klub"

**Goal:** Replace the flat follower list with a club membership screen featuring identity card, stats strip, and enriched member list.

**Context:** The current `OrganizerCommunityScreen` is a basic list of follower names with an invite button. We're rebranding it as a "Klub" (club) — a sport-agnostic organizer community where the club name is the organizer's brand. No payment/subscription required to join.

**Architecture:** Feature-First + Riverpod + go_router. Mock-first. Design tokens from `docs/DESIGN_SYSTEM.md`.

---

## Screen Layout (top to bottom)

### 1. Club Identity Card

No AppBar — `SafeArea` + custom header (consistent with organizer dashboard).

- `surface` container, `radiusLg`, `AppShadows.sm`, padding `AppDimensions.base`
- **Row layout:**
  - Left: `CircleAvatar` (48px radius, organizer initials, `AppColors.primary50` bg, `AppColors.primary` text)
  - Right (expanded, column):
    - Club name: `AppTypography.headingSmall` (e.g. "Petenis Kelana")
    - Tagline: `AppTypography.bodySmall` + `AppColors.textSecondary` (optional — hidden when null/empty)
    - City pill: small `Container` with `Icons.location_on_outlined` (14px) + city text in `AppTypography.caption`, `AppColors.neutral400` icon
- **Edit icon button** positioned top-right (absolute via `Stack` or `Align`):
  - `IconButton(icon: Icons.edit_outlined)` → snackbar "Edit profil klub segera hadir"

### 2. Stats Strip

Below identity card, spacing `AppDimensions.base`.

- Horizontal `Row` of 3 `Expanded` containers
- Gap between cards: `AppDimensions.sm` (use `MainAxisAlignment.spaceBetween` or explicit `SizedBox`)
- Each card: `surface` bg, `radiusMd`, `AppShadows.xs`, padding `AppDimensions.sm`, centered content

**Card anatomy (top to bottom, centered):**
- Icon: 16px, `AppColors.neutral400`, centered above value
- Value: `AppTypography.headingSmall` + `AppColors.primary`
- Label: `AppTypography.caption` + `AppColors.textSecondary`

**Cards:**
1. Icon `Icons.group_outlined` / value: member count / label: "Anggota"
2. Icon `Icons.event_outlined` / value: sessions this month / label: "Sesi Bulan Ini"
3. Icon `Icons.sports_tennis_outlined` / value: distinct sport count / label: "Sport Aktif"

### 3. Member List

Below stats strip, spacing `AppDimensions.lg`.

**Section header row:**
- Left: "Anggota" in `AppTypography.titleMedium`
- Right: count badge — `Container` with `AppColors.primary50` bg, `radiusFull`, padding horizontal `AppDimensions.sm`, showing count in `AppTypography.caption` + `AppColors.primary`

**Member rows** — `ListView` inside `Expanded`, padding `AppDimensions.screenHorizontal`:
- Each row: `surface` container, `radiusMd`, `AppShadows.xs`, margin-bottom `AppDimensions.sm`
- **Row layout:**
  - Left: `CircleAvatar` (20px radius, initials, `AppColors.primary50` bg, `AppColors.primary` text)
  - Center (expanded, column):
    - Name: `AppTypography.titleSmall`
    - Join date: `AppTypography.caption` + `AppColors.textSecondary` (e.g. "Bergabung 3 Jan 2026")
    - Sport tags: `Wrap` of small pills, spacing 4px
      - Each pill: sport color bg at 0.1 alpha, sport color text, `radiusFull`, padding horizontal 8 / vertical 2
      - e.g. "Tennis" pill in blue tint, "Padel" pill in teal tint
  - Right: `IconButton(Icons.message_outlined)` → snackbar "Fitur pesan akan segera hadir"

### 4. Bottom Section (pinned, outside scroll)

- Full-width `FilledButton.icon`:
  - Icon: `Icons.person_add_outlined`
  - Label: "Undang Anggota"
  - → snackbar "Fitur undangan akan segera hadir"
- Bottom padding: `AppDimensions.screenBottom`

### 5. Empty State

When no members:
- `EmptyState(icon: Icons.group_off_outlined, message: 'Belum ada anggota')`
- Invite CTA button below (same as bottom section)

---

## Data Layer Changes

### New: `ClubProfile` class

Location: `lib/features/organizer/data/models/club_profile.dart`

Plain Dart class (no Freezed — too simple to warrant it):

```dart
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
```

### New: `ClubMember` class

Location: `lib/features/organizer/data/models/club_member.dart`

Plain Dart class:

```dart
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
```

### Mock Data Update

`lib/core/mocks/mock_organizer_data.dart` — replace `List<String> followers` with:

- `ClubProfile clubProfile` — name: "Andi Sport Club", tagline: "Komunitas olahraga raket & bola Jakarta Selatan", city: "Jakarta Selatan"
- `List<ClubMember> clubMembers` — 7 members with names (reuse existing), varied join dates, and 1-3 sport preferences each

### Repository Changes

`OrganizerRepository`:
- Replace `Future<List<String>> getFollowers()` with:
  - `Future<ClubProfile> getClubProfile()`
  - `Future<List<ClubMember>> getClubMembers()`

`MockOrganizerRepository`:
- Implement both methods returning from `MockOrganizerData`

### Provider Changes

`organizer_providers.dart`:
- Replace `organizerFollowersProvider` with:
  - `clubProfileProvider` — `FutureProvider<ClubProfile>`
  - `clubMembersProvider` — `FutureProvider<List<ClubMember>>`

### Routing Changes

- `app_routes.dart`: rename `organizerCommunity` → `organizerClub` (update path to `/organizer/club`)
- `app_router.dart`:
  - Update route path reference
  - Bottom nav label: "Community" → "Klub"
  - Icon stays `Icons.group_outlined` / `Icons.group`
- Update any references to the old route in other screens

---

## Stats Computation

The 3 stats are derived, not stored:

- **Anggota:** `clubMembers.length`
- **Sesi Bulan Ini:** count from `organizerSessionsProvider` where `session.date` is in current month
- **Sport Aktif:** distinct `session.sport` values from organizer's sessions (or from member preferences — sessions is more accurate)

---

## Files Modified

| File | Change |
|------|--------|
| `lib/features/organizer/presentation/screens/organizer_community_screen.dart` | Full rewrite → club screen |
| `lib/features/organizer/data/organizer_repository.dart` | Replace `getFollowers` with `getClubProfile` + `getClubMembers` |
| `lib/features/organizer/data/mock_organizer_repository.dart` | Implement new methods |
| `lib/features/organizer/providers/organizer_providers.dart` | Replace `organizerFollowersProvider` with 2 new providers |
| `lib/core/mocks/mock_organizer_data.dart` | Add `ClubProfile` + `List<ClubMember>` mock data |
| `lib/routing/app_routes.dart` | Rename route constant |
| `lib/routing/app_router.dart` | Update route path + bottom nav label |

## New Files

| File | Content |
|------|---------|
| `lib/features/organizer/data/models/club_profile.dart` | `ClubProfile` class |
| `lib/features/organizer/data/models/club_member.dart` | `ClubMember` class |

---

*Design Version: 1.0*
*Date: 2026-02-07*
