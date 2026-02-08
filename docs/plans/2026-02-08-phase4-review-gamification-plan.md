# Phase 4: Review + Assessment + Gamification + Profile + Notification

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the per-session mutual review system (player reviews coach, coach assesses player per session), complete the gamification layer, add a career dashboard with radar charts, and wire up a notification center. This is the final phase before API integration.

**Context:** Phases 0–3 are complete. The Coach Assessment model exists but is NOT session-linked. The Review feature has zero code — only the folder structure was planned in the architecture doc. Gamification has a Badge model + providers but no screens. Profile screen exists but is missing edit, career, and settings screens. Notification has nothing built.

**Architecture:** Feature-First + Riverpod + go_router. Mock-first repository pattern. All design tokens from `DESIGN_SYSTEM.md`.

**Tech Stack:** Flutter 3.38, Riverpod, go_router, Freezed/json_serializable, fl_chart (radar charts).

---

## Privacy Rules (CRITICAL)

These rules govern all review and assessment visibility throughout the system:

### Player → Coach Review
- **Coach** can see ALL reviews written about them (from any player, any session).
- **The player who wrote the review** can see their own review.
- **Other players** CANNOT see reviews written by other players about a coach.
- **Public profile** does NOT show individual reviews — only aggregate rating (average stars + total count).

### Coach → Player Assessment (per session)
- **Coach** can see all assessments they wrote.
- **The player who received the assessment** can see their own assessment.
- **Other players** CANNOT see assessments given to other players.
- **Improvement comments** (whatToImprove, playingStyleNotes) are PRIVATE — visible only to the coach who wrote it and the player who received it.

### Aggregate Data (public-safe)
- Coach profile can show: average rating (1–5 stars), total review count, rating distribution (5★: 12, 4★: 8, etc.).
- Player profile can show: their own radar chart from assessments, their level tier. NOT individual assessment details to others.

---

## What Already Exists (DO NOT recreate)

These files are complete and working — only modify if a task explicitly says to:

**Models (Freezed, with generated .freezed.dart + .g.dart):**
- `lib/features/coach/data/models/assessment.dart` — 5 skill axes, notes, recommendedLevel (NO sessionId yet)
- `lib/features/coach/data/models/coaching_booking.dart` — CoachingBooking with coachId, playerId, date, status
- `lib/features/session/data/models/open_session.dart` — OpenSession with hostId, sport, date, participants
- `lib/features/session/data/models/session_participant.dart` — SessionParticipant with playerId, sessionId, status
- `lib/features/gamification/data/models/badge.dart` — Badge with id, name, description, iconName, xpReward
- `lib/features/profile/data/models/player_profile.dart` — PlayerProfile with XP, levelTier, sports, selfAssessedLevels

**Repositories + Mocks:**
- `lib/features/coach/data/coach_repository.dart` — abstract, includes getAssessments() + createAssessment()
- `lib/features/coach/data/mock_coach_repository.dart` — full implementation

**Providers:**
- `lib/features/coach/providers/assessment_provider.dart` — assessmentListProvider
- `lib/features/gamification/providers/gamification_providers.dart` — badgeListProvider, playerStatsProvider

**Mock Data:**
- `lib/core/mocks/mock_assessments.dart` — 4 sample assessments
- `lib/core/mocks/mock_badges.dart` — 8 badges
- `lib/core/mocks/mock_data.dart` — central registry

**Screens:**
- `lib/features/profile/presentation/screens/profile_screen.dart` — fully built with XP bar, badges, sport stats, recent activity, menu items
- `lib/features/coach/presentation/screens/assessment_form_screen.dart` — 5 sliders + radar preview

**Routing:**
- `lib/routing/app_routes.dart` — all existing routes
- `lib/routing/app_router.dart` — all shells registered

---

## Task 1: Extend Assessment Model with Session Link + Improvement Fields

**Files:**
- Modify: `lib/features/coach/data/models/assessment.dart`
- Modify: `lib/features/coach/data/coach_repository.dart`
- Modify: `lib/features/coach/data/mock_coach_repository.dart`
- Modify: `lib/core/mocks/mock_assessments.dart`

**Changes:**

1. Add fields to `Assessment` model:
```dart
@freezed
class Assessment with _$Assessment {
  const factory Assessment({
    required String id,
    required String coachId,
    required String coachName,
    required String studentId,
    required String studentName,
    required Sport sport,
    required DateTime date,
    required int technique,
    required int stamina,
    required int tactics,
    required int mentality,
    required int consistency,
    String? notes,
    @Default(LevelTier.rookie) LevelTier recommendedLevel,
    // ── NEW: session link ──
    String? sessionId,                // links to OpenSession.id or CoachingBooking.id
    String? sessionTitle,             // denormalized for display
    // ── NEW: structured improvement feedback ──
    String? whatToImprove,            // "Apa yang perlu diperbaiki?"
    String? playingStyleNotes,        // "Catatan gaya bermain"
    String? strengthHighlight,        // "Kelebihan utama"
  }) = _Assessment;

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
}
```

2. Update `CoachRepository.createAssessment()` to accept optional `sessionId`, `sessionTitle`, `whatToImprove`, `playingStyleNotes`, `strengthHighlight`.

3. Update `MockCoachRepository.createAssessment()` implementation.

4. Update `mock_assessments.dart` — add `sessionId` and improvement fields to 2 of the 4 existing mocks. Add 2 new session-linked assessments:
```dart
Assessment(
  id: 'assess-005',
  coachId: 'coach-001',
  coachName: 'Andi Prasetyo',
  studentId: 'user-001',
  studentName: 'Budi Santoso',
  sport: Sport.tennis,
  date: now.subtract(const Duration(days: 1)),
  technique: 8,
  stamina: 7,
  tactics: 6,
  mentality: 8,
  consistency: 7,
  notes: 'Peningkatan signifikan dari sesi sebelumnya.',
  recommendedLevel: LevelTier.amateur,
  sessionId: 'session-today-1',
  sessionTitle: 'Latihan Tennis Pagi',
  whatToImprove: 'Backhand slice masih sering ke net. Coba lebih rileks di pergelangan tangan saat slice.',
  playingStyleNotes: 'Pemain baseline yang agresif. Forehand dominan, perlu variasi di net approach.',
  strengthHighlight: 'Forehand cross-court sangat konsisten dan dalam.',
),
```

5. Run `dart run build_runner build --delete-conflicting-outputs`.

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 2: Create Review Model + Repository

**Files:**
- Create: `lib/features/review/data/models/review.dart`
- Create: `lib/features/review/data/review_repository.dart`
- Create: `lib/features/review/data/mock_review_repository.dart`
- Create: `lib/core/mocks/mock_reviews.dart`
- Modify: `lib/core/mocks/mock_data.dart` — register reviews

**Changes:**

1. Create `Review` Freezed model:
```dart
@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String reviewerId,        // player who writes the review
    required String reviewerName,
    required String coachId,           // coach being reviewed
    required String coachName,
    required String sessionId,         // the session this review is about
    required String sessionTitle,      // denormalized
    required Sport sport,
    required DateTime date,
    required int rating,               // 1–5 stars
    String? comment,                   // free-text feedback (private: only reviewer + coach can see)
    @Default(false) bool isAnonymous,  // future: allow anonymous reviews
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
```

2. Create `ReviewRepository` abstract class:
```dart
abstract class ReviewRepository {
  /// Get reviews written about a coach (coach sees all their reviews).
  Future<List<Review>> getCoachReviews(String coachId);

  /// Get reviews written BY a player (player sees their own reviews).
  Future<List<Review>> getPlayerReviews(String reviewerId);

  /// Get reviews for a specific session.
  Future<List<Review>> getSessionReviews(String sessionId);

  /// Check if a player has already reviewed a coach for a given session.
  Future<bool> hasReviewed({required String reviewerId, required String sessionId});

  /// Submit a new review.
  Future<Review> submitReview({
    required String coachId,
    required String sessionId,
    required int rating,
    String? comment,
  });

  /// Get aggregate rating for a coach (public-safe).
  Future<CoachRatingAggregate> getCoachRating(String coachId);
}

@freezed
class CoachRatingAggregate with _$CoachRatingAggregate {
  const factory CoachRatingAggregate({
    required String coachId,
    required double averageRating,
    required int totalReviews,
    @Default({}) Map<int, int> distribution,  // {5: 12, 4: 8, 3: 2, 2: 1, 1: 0}
  }) = _CoachRatingAggregate;

  factory CoachRatingAggregate.fromJson(Map<String, dynamic> json) =>
      _$CoachRatingAggregateFromJson(json);
}
```

Put `CoachRatingAggregate` in a separate file `lib/features/review/data/models/coach_rating_aggregate.dart`.

3. Create `MockReviewRepository` — return from mock data, compute aggregate from list.

4. Create `mock_reviews.dart` — 6 reviews across 3 sessions from different players reviewing coaches:
   - 2 reviews for coach-001 (Andi Prasetyo) on session-today-1
   - 2 reviews for coach-001 on a different session
   - 2 reviews for coach-002 (Maya Sari) on session-today-2
   - Varied ratings (3–5 stars), realistic Indonesian comments about coaching quality

5. Register in `MockData`:
```dart
static List<Review> get reviews => MockReviews.reviews;
```

6. Run `build_runner`.

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 3: Create Review Providers

**Files:**
- Create: `lib/features/review/providers/review_providers.dart`
- Modify: `lib/routing/app_routes.dart` — add review routes

**Changes:**

1. Create providers:
```dart
/// Reviews for a specific coach (coach views their own reviews)
final coachReviewsProvider = FutureProvider.family<List<Review>, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachReviews(coachId);
});

/// Reviews written by the current player (player views reviews they wrote)
final myReviewsProvider = FutureProvider.family<List<Review>, String>((ref, playerId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getPlayerReviews(playerId);
});

/// Reviews for a specific session
final sessionReviewsProvider = FutureProvider.family<List<Review>, String>((ref, sessionId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getSessionReviews(sessionId);
});

/// Check if current player already reviewed a session
final hasReviewedProvider = FutureProvider.family<bool, ({String reviewerId, String sessionId})>((ref, params) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.hasReviewed(reviewerId: params.reviewerId, sessionId: params.sessionId);
});

/// Aggregate rating for coach profile (public-safe)
final coachRatingProvider = FutureProvider.family<CoachRatingAggregate, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachRating(coachId);
});

/// Repository provider
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return MockReviewRepository();
});
```

2. Add routes to `AppRoutes`:
```dart
// ── Review routes ────────────────────────────────────────────
static String submitReview(String sessionId) => '/review/create/$sessionId';
static const myReviews = '/player/reviews';
static String coachReviews(String coachId) => '/coach/$coachId/reviews';
```

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 4: Build Submit Review Screen (Player → Coach)

**Files:**
- Create: `lib/features/review/presentation/screens/submit_review_screen.dart`
- Create: `lib/features/review/presentation/widgets/rating_stars.dart`
- Modify: `lib/routing/app_router.dart` — register route

**Changes:**

1. `RatingStars` widget — interactive star rating (1–5):
   - Row of 5 star icons, tappable
   - Selected stars: filled with accent color
   - Unselected: outlined, neutral
   - Optional: half-star display for averages (read-only mode)

2. `SubmitReviewScreen` — full-page form:
   - **AppBar:** "Beri Ulasan"
   - **Coach info header:** Avatar + name + session title + date
   - **Star rating:** RatingStars widget (required, must select at least 1)
   - **Comment field:** Multi-line text field, placeholder "Bagaimana pengalaman latihan dengan coach ini?" (optional but encouraged)
   - **Privacy notice:** Small caption text: "Ulasan ini hanya dapat dilihat oleh Anda dan coach."
   - **Submit button:** Full-width, disabled until rating is selected
   - On submit: call `reviewRepository.submitReview()`, show success snackbar, pop back

   Screen receives `sessionId` as path parameter. Loads session data to show coach name and session title.

3. Register route in `app_router.dart`:
```dart
GoRoute(
  path: '/review/create/:sessionId',
  builder: (context, state) => SubmitReviewScreen(
    sessionId: state.pathParameters['sessionId']!,
  ),
),
```

**Verify:** `flutter analyze` shows 0 issues. Navigate to screen from a test tap.

---

## Task 5: Build Coach Review List Screen (Coach sees their reviews)

**Files:**
- Create: `lib/features/review/presentation/screens/coach_review_list_screen.dart`
- Create: `lib/features/review/presentation/widgets/review_card.dart`

**Changes:**

1. `ReviewCard` widget — displays a single review:
   - **Header row:** Reviewer name (or "Anonim" if anonymous) + date
   - **Star rating:** RatingStars in read-only mode
   - **Session context:** Small chip showing session title + sport icon
   - **Comment:** Full text, up to 3 lines with "Selengkapnya" expand
   - Design: Surface card with sm shadow, radius medium

2. `CoachReviewListScreen`:
   - **AppBar:** "Ulasan Saya" (from coach perspective)
   - **Summary header card:** Average rating (large number) + star display + total count + distribution bars (5★–1★)
   - **Filter chips:** Semua | 5★ | 4★ | 3★ | 2★ | 1★
   - **Review list:** ListView of ReviewCard widgets, sorted newest first
   - **Empty state:** "Belum ada ulasan" with illustration
   - Uses `coachReviewsProvider` and `coachRatingProvider`

This screen is accessible from:
- Coach dashboard (menu item or summary card)
- Coach profile screen

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 6: Build Session Assessment Form (Coach → Player, per session)

**Files:**
- Modify: `lib/features/coach/presentation/screens/assessment_form_screen.dart`

**Changes:**

The existing `AssessmentFormScreen` has 5 sliders + notes + sport selector + recommended level. Extend it to support a **session-linked mode**:

1. Add optional constructor parameters: `sessionId`, `sessionTitle`, `studentId`, `studentName`, `sport` (pre-filled when coming from a session context).

2. When `sessionId` is provided:
   - Hide the student selector (already known)
   - Hide the sport selector (already known from session)
   - Show a session context banner at top: "[Session Title] · [Date]"
   - Show 3 additional text fields below the sliders:
     - **"Kelebihan Utama"** — single-line, placeholder "Apa kelebihan utama pemain ini di sesi ini?"
     - **"Yang Perlu Diperbaiki"** — multi-line, placeholder "Apa yang perlu diperbaiki? Berikan saran spesifik."
     - **"Catatan Gaya Bermain"** — multi-line, placeholder "Catatan tentang gaya bermain, pola permainan, atau kebiasaan."
   - Privacy notice below fields: "Catatan ini hanya dapat dilihat oleh Anda dan pemain."

3. When `sessionId` is NOT provided, behavior is unchanged (standalone assessment).

4. On submit: pass new fields to `coachRepository.createAssessment()`.

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 7: Build Post-Session Review Trigger

**Files:**
- Create: `lib/features/review/presentation/widgets/post_session_review_banner.dart`
- Modify: `lib/features/session/presentation/screens/session_detail_screen.dart` (or equivalent player-facing session detail)

**Changes:**

After a session is completed, players need a clear entry point to review the coach. This task adds a banner that appears on the session detail screen when:
- Session status is `completed`
- The session had a coach (either coaching booking or organizer-led session with coach)
- The current player has NOT yet reviewed this session

1. `PostSessionReviewBanner` widget:
   - Gradient accent background (soft)
   - Coach avatar + "Bagaimana latihan dengan [Coach Name]?"
   - Star rating preview (tappable, navigates to full review form)
   - "Beri Ulasan" button → navigates to `SubmitReviewScreen`

2. Add the banner to the session detail screen, positioned after the session info section, before participants list. Only shows when conditions above are met.

3. For coaching bookings: add similar banner to `BookingDetailScreen` when booking status is `completed`.

**Verify:** `flutter analyze` shows 0 issues. Banner visible on completed session detail.

---

## Task 8: Build Coach Assessment Entry Points (per session)

**Files:**
- Modify: Coach-facing session detail or coaching booking detail screen
- Create: `lib/features/coach/presentation/widgets/session_player_assessment_list.dart`

**Changes:**

A coach needs to assess individual players after a session. This task adds the entry point:

1. `SessionPlayerAssessmentList` widget — shows on coach's view of a completed session:
   - Lists all participants in that session
   - Each row: Player name + avatar + status indicator (assessed / not yet)
   - "Beri Penilaian" button on each unassessed player → navigates to `AssessmentFormScreen` with session context pre-filled
   - "Lihat Penilaian" on already-assessed players → shows read-only assessment

2. Add this widget to:
   - Coach's view of completed sessions
   - Coach's view of completed coaching bookings

3. For the mock layer: add a helper to check if an assessment already exists for a given (coachId, studentId, sessionId) triple.

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 9: Build Player Assessment History Screen (Career Dashboard)

**Files:**
- Create: `lib/features/profile/presentation/screens/career_screen.dart`
- Create: `lib/features/profile/providers/career_provider.dart`
- Modify: `lib/features/profile/presentation/screens/profile_screen.dart` — wire "Statistik" or career menu item
- Modify: `lib/routing/app_routes.dart` — add career route
- Modify: `lib/routing/app_router.dart` — register route

**Changes:**

1. `CareerProvider` — aggregates the current player's assessments:
   - Latest assessment per sport (for current radar chart)
   - Assessment history timeline (all assessments, newest first)
   - Average skill scores over time (for trend display)
   - Links to sessions where applicable

2. `CareerScreen`:
   - **AppBar:** "Perkembangan Saya"
   - **Radar chart section:** fl_chart RadarChart showing latest 5-axis assessment for selected sport
     - Sport tabs if player has assessments in multiple sports
     - If no assessments: empty state "Belum ada penilaian dari coach"
   - **Skill breakdown:** Below radar chart, 5 horizontal bars showing each skill score (1–10) with labels
   - **Recommended level:** Badge showing the most recent coach's recommended level
   - **Improvement notes section:** Latest coach's whatToImprove + playingStyleNotes + strengthHighlight
     - Privacy: this is the player viewing their own data, so it's allowed
     - Collapsed by default, expandable
   - **Assessment timeline:** Chronological list of all assessments
     - Each item: Date + Coach name + Session title (if linked) + mini radar thumbnail
     - Tappable → detail view showing full assessment + improvement notes
   - **Review history tab:** "Ulasan Saya" — list of reviews this player has written about coaches
     - Each item: Coach name + session + rating + date
     - Shows the player's own comments

3. Add route: `static const career = '/player/career';`

4. Wire from `ProfileScreen` — add "Perkembangan" menu item or make the sport stats section tappable.

**Verify:** `flutter analyze` shows 0 issues. Career screen shows radar chart with mock data.

---

## Task 10: Build Notification Model + Repository + Screen

**Files:**
- Create: `lib/features/notification/data/models/notification_item.dart`
- Create: `lib/features/notification/data/notification_repository.dart`
- Create: `lib/features/notification/data/mock_notification_repository.dart`
- Create: `lib/features/notification/providers/notification_providers.dart`
- Create: `lib/features/notification/presentation/screens/notifications_screen.dart`
- Create: `lib/features/notification/presentation/widgets/notification_tile.dart`
- Create: `lib/core/mocks/mock_notifications.dart`
- Modify: `lib/core/mocks/mock_data.dart` — register notifications
- Modify: `lib/routing/app_routes.dart` — add notification route
- Modify: `lib/routing/app_router.dart` — register route

**Changes:**

1. `NotificationItem` Freezed model:
```dart
enum NotificationType {
  paymentReminder,     // "Bayar sebelum jam 15:00"
  sessionReminder,     // "Sesi dimulai 1 jam lagi"
  reviewRequest,       // "Beri ulasan untuk Coach Andi"
  assessmentReceived,  // "Coach Andi menilai performa Anda"
  bookingConfirmed,    // "Booking dikonfirmasi"
  sessionFull,         // "Sesi sudah penuh"
  badge,               // "Badge baru: First Timer!"
  general,
}

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? actionRoute,       // deep link route when tapped
    String? relatedId,         // session/booking/review ID
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
```

2. `NotificationRepository`:
```dart
abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications({int limit = 50});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}
```

3. `MockNotificationRepository` + `mock_notifications.dart` — 10 sample notifications spanning all types, mix of read/unread, with actionRoutes pointing to relevant screens.

4. Providers: `notificationListProvider`, `unreadCountProvider`.

5. `NotificationTile` widget:
   - Type-specific icon + color
   - Title + body text
   - Time ago label ("2 jam lalu", "Kemarin")
   - Unread dot indicator
   - Tappable → navigates to actionRoute

6. `NotificationsScreen`:
   - **AppBar:** "Notifikasi" with "Tandai Semua Dibaca" action
   - **List:** Grouped by date (Hari Ini, Kemarin, Sebelumnya)
   - **Empty state:** "Tidak ada notifikasi"
   - Pull-to-refresh

7. Routes: `static const notifications = '/notifications';`

8. Include review-related notification types:
   - `reviewRequest`: "Beri ulasan untuk Coach [name] — sesi [title] sudah selesai"
   - `assessmentReceived`: "Coach [name] memberikan penilaian untuk sesi [title]. Lihat perkembangan Anda."

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 11: Wire Notification Badge to App Shell

**Files:**
- Modify: `lib/routing/app_router.dart` — add notification icon to app bars
- Modify: Player shell / Coach shell app bars as appropriate

**Changes:**

1. Add a notification bell icon to the app bar of the Player and Coach shells.
2. Show unread count badge (red dot or number) using `unreadCountProvider`.
3. Tapping navigates to `NotificationsScreen`.

**Verify:** `flutter analyze` shows 0 issues. Bell icon visible with badge count.

---

## Task 12: Build Achievements Screen (Gamification)

**Files:**
- Create: `lib/features/gamification/presentation/screens/achievements_screen.dart`
- Create: `lib/features/gamification/presentation/widgets/badge_grid.dart`
- Modify: `lib/features/profile/presentation/screens/profile_screen.dart` — wire "Pencapaian" → "Lihat Semua"
- Modify: `lib/routing/app_routes.dart` — add achievements route
- Modify: `lib/routing/app_router.dart` — register route

**Changes:**

1. `BadgeGrid` widget — grid of badge cards:
   - 2 columns
   - Unlocked badges: full color, icon, name, description, XP reward, unlock date
   - Locked badges: grayscale/opacity, lock icon overlay, description of how to unlock
   - Tappable → same badge detail bottom sheet from ProfileScreen

2. `AchievementsScreen`:
   - **AppBar:** "Pencapaian"
   - **Header:** XP progress bar + level badge (reuse from profile)
   - **Stats row:** Total badges earned / total available
   - **Tab bar:** Terbuka | Terkunci | Semua
   - **Badge grid:** Filtered by tab

3. Route: `static const achievements = '/player/achievements';`

4. Wire from ProfileScreen:
   - "Lihat Semua →" in Pencapaian section → navigates to AchievementsScreen
   - "Pencapaian" menu item → navigates to AchievementsScreen

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 13: Build Edit Profile + Settings Screens

**Files:**
- Create: `lib/features/profile/presentation/screens/edit_profile_screen.dart`
- Create: `lib/features/profile/presentation/screens/settings_screen.dart`
- Create: `lib/features/profile/data/profile_repository.dart`
- Create: `lib/features/profile/data/mock_profile_repository.dart`
- Create: `lib/features/profile/providers/profile_provider.dart`
- Modify: `lib/features/profile/presentation/screens/profile_screen.dart` — wire menu items
- Modify: `lib/routing/app_routes.dart` — add routes
- Modify: `lib/routing/app_router.dart` — register routes

**Changes:**

1. `ProfileRepository`:
```dart
abstract class ProfileRepository {
  Future<PlayerProfile> getProfile(String userId);
  Future<PlayerProfile> updateProfile({
    String? bio,
    String? city,
    List<Sport>? sports,
    Map<String, String>? selfAssessedLevels,
  });
}
```

2. `MockProfileRepository` — reads/writes to MockData.

3. `ProfileProvider` — uses repository, exposes current profile with update method.

4. `EditProfileScreen`:
   - **AppBar:** "Edit Profil" with Save button
   - **Avatar:** Circular with camera icon overlay (tap → placeholder, no actual picker needed for mock)
   - **Fields:** Nama (read-only, from auth), Bio (multi-line), Kota (text field)
   - **Sport selector:** Reuse SportChipSelector from auth flow
   - **Self-assessed levels:** For each selected sport, dropdown with LevelTier values
   - On save: update via repository, pop back

5. `SettingsScreen`:
   - **AppBar:** "Pengaturan"
   - **Sections:**
     - Notifikasi: toggle switches for different notification types (mock only, state stored locally)
     - Privasi: placeholder section
     - Akun: Ganti Password (placeholder), Hapus Akun (placeholder with warning)
     - Tentang: App version, privacy policy link (placeholder)

6. Routes: `static const editProfile = '/player/profile/edit';`, `static const settings = '/player/settings';`

7. Wire from ProfileScreen menu items.

**Verify:** `flutter analyze` shows 0 issues.

---

## Task 14: Integrate Reviews into Coach Profile/Detail Screens

**Files:**
- Modify: `lib/features/coach/presentation/screens/coach_detail_screen.dart` (player-facing)
- Modify: `lib/features/coach/presentation/screens/coach_dashboard_screen.dart` (coach-facing)

**Changes:**

1. **Coach detail screen (player view):**
   - Add aggregate rating section: average stars + total count
   - Show rating distribution bars (5★–1★)
   - Do NOT show individual review text or reviewer names (privacy rule)
   - "Ulasan" label with count, e.g. "Ulasan (23)"

2. **Coach dashboard (coach's own view):**
   - Add "Ulasan Terbaru" section showing latest 3 reviews (ReviewCard widget)
   - "Lihat Semua" → navigates to `CoachReviewListScreen`
   - Show aggregate rating summary card

**Verify:** `flutter analyze` shows 0 issues.

---

## Section Order Summary

After all tasks, the app has:

**Player flow:**
1. Complete session → PostSessionReviewBanner appears → SubmitReviewScreen
2. Profile → Career dashboard with radar charts + assessment history + own reviews
3. Profile → Achievements screen with all badges
4. Profile → Edit Profile + Settings
5. Notification bell → Notification center with review/assessment alerts

**Coach flow:**
1. View completed session → SessionPlayerAssessmentList → AssessmentFormScreen (with improvement fields)
2. Dashboard → Recent reviews summary → CoachReviewListScreen (all reviews)
3. Notification center with new review alerts

---

## Model Changes Summary

```dart
// Assessment — extend:
String? sessionId;           // links to session/coaching booking
String? sessionTitle;        // denormalized
String? whatToImprove;       // private improvement feedback
String? playingStyleNotes;   // private playing style notes
String? strengthHighlight;   // private strength callout

// NEW: Review
String id, reviewerId, reviewerName, coachId, coachName;
String sessionId, sessionTitle;
Sport sport;
DateTime date;
int rating;                  // 1–5
String? comment;             // private: reviewer + coach only
bool isAnonymous;

// NEW: CoachRatingAggregate
String coachId;
double averageRating;
int totalReviews;
Map<int, int> distribution;

// NEW: NotificationItem
String id, title, body;
NotificationType type;
DateTime createdAt;
bool isRead;
String? actionRoute, relatedId;
```

---

## Acceptance Criteria

1. **Player can review coach after a completed session** — banner appears, 2 taps to submit (star + confirm).
2. **Multiple players can each review the same coach for the same session** — each gets their own review entry.
3. **Coach can assess each player per session** — assessment form pre-fills session + player, includes improvement fields.
4. **Reviews are private** — only the reviewer and the coach can see the review text. Other players see only aggregate stars.
5. **Coach improvement comments are private** — whatToImprove, playingStyleNotes, strengthHighlight visible only to the coach and the assessed player.
6. **Coach sees all their reviews** — CoachReviewListScreen with filters and aggregate summary.
7. **Player sees their own assessment history** — Career screen with radar chart, improvement notes, timeline.
8. **Notification center works** — bell icon with badge count, grouped notifications, tappable deep links.
9. **Achievements screen shows all badges** — unlocked/locked states, XP rewards, grid layout.
10. **Edit profile and settings screens functional** — bio, city, sports, levels editable.

---

## Implementation Checklist

- [x] **Task 1:** Extend Assessment model with session link + improvement fields
- [x] **Task 2:** Create Review model + repository + mock data
- [x] **Task 3:** Create Review providers + routes
- [x] **Task 4:** Build Submit Review screen (player → coach)
- [x] **Task 5:** Build Coach Review List screen (coach views reviews)
- [x] **Task 6:** Build Session Assessment form (coach → player, per session)
- [x] **Task 7:** Build Post-Session Review trigger (banner on completed sessions)
- [x] **Task 8:** Build Coach Assessment entry points (per session player list)
- [x] **Task 9:** Build Career Dashboard (player assessment history + radar chart)
- [x] **Task 10:** Build Notification model + repository + screen
- [x] **Task 11:** Wire Notification badge to app shell
- [x] **Task 12:** Build Achievements screen
- [x] **Task 13:** Build Edit Profile + Settings screens
- [x] **Task 14:** Integrate reviews into Coach profile/detail screens

### Post-Implementation Fixes (from user testing)

- [x] Fix notification "Bayar sebelum jam 15:00" crash — coaching booking route mismatch
- [x] Remove inconsistent hourly rate from coach detail bottom bar
- [x] Make completed coaching sessions clickable → detail screen + assessment entry
- [x] Add venue association to coach packages → auto-populate in booking flow
