# Phase 2: Coach (Player Views + Coach Role) Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the complete Coach experience — player can view coach details and book coaching sessions; coach can manage dashboard, schedule, students, and assessments — all with mock data.

**Architecture:** Feature-first, extending existing `lib/features/coach/`. New Freezed models (CoachPackage, Assessment, CoachingBooking), new mock data, abstract repos with mock impl, Riverpod providers for state. Coach role shell with 4 tabs. Reuse design tokens (AppColors, AppTypography, AppDimensions, AppShadows, AppSurfaces, ThemeExtensions) consistently. Follow existing patterns from venue/session/booking features.

**Tech Stack:** Flutter 3.38, Riverpod 2.6, go_router 14.8, Freezed 2.5, cached_network_image

---

## What Already Exists (DO NOT recreate)
- `lib/features/coach/data/models/coach.dart` — Freezed model (13 fields)
- `lib/features/coach/data/coach_repository.dart` — abstract: `getCoaches({Sport? sport})`, `getCoach(String id)`
- `lib/features/coach/data/mock_coach_repository.dart` — mock impl
- `lib/features/coach/providers/coach_providers.dart` — repo, filter, list providers
- `lib/features/coach/presentation/widgets/coach_card.dart` — card widget
- `lib/features/coach/presentation/screens/coach_list_screen.dart` — list screen (in Explore tab)
- `lib/core/mocks/mock_coaches.dart` — 5 coaches
- `lib/core/mocks/mock_data.dart` — coaches getter

## Design System Reference
- **Cards:** `AppSurfaces.surface` bg, `AppShadows.sm`, `BorderRadius.circular(AppDimensions.radiusLg)`
- **Chips/Badges:** `AppDimensions.radiusFull`, sport colors via `SportThemeExtension`
- **Level badges:** `GamificationThemeExtension` colors
- **Screen padding:** `AppDimensions.screenHorizontal` (20px)
- **Spacing:** `AppDimensions.sm(8)`, `.md(12)`, `.base(16)`, `.lg(20)`, `.xl(24)`, `.xxl(32)`
- **Typography:** `AppTypography.headingLarge` (titles), `.titleMedium` (section headers), `.bodyMedium` (body), `.caption` (secondary), `.priceLarge` (prices)
- **Buttons:** `AppButton` with `AppShadows.colored` wrapper for primary CTAs
- **Bottom bars:** `AppSurfaces.surface` + `AppShadows.bottomNav`
- **Rating stars:** `RatingThemeExtension.starColor` (#FFC107)

---

## Task 1: Freezed Models — CoachPackage + Assessment + CoachingBooking

**Files:**
- Create: `lib/features/coach/data/models/coach_package.dart`
- Create: `lib/features/coach/data/models/assessment.dart`
- Create: `lib/features/coach/data/models/coaching_booking.dart`

**Step 1: Create CoachPackage model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'coach_package.freezed.dart';
part 'coach_package.g.dart';

@freezed
class CoachPackage with _$CoachPackage {
  const factory CoachPackage({
    required String id,
    required String coachId,
    required String name,
    required String description,
    required Sport sport,
    required int sessions,        // e.g. 4, 8, 12
    required int pricePerSession, // Rupiah
    required int durationMinutes, // e.g. 60, 90
    @Default(true) bool isActive,
  }) = _CoachPackage;

  factory CoachPackage.fromJson(Map<String, dynamic> json) =>
      _$CoachPackageFromJson(json);
}
```

**Step 2: Create Assessment model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'assessment.freezed.dart';
part 'assessment.g.dart';

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
    required int technique,     // 1-10
    required int stamina,       // 1-10
    required int tactics,       // 1-10
    required int mentality,     // 1-10
    required int consistency,   // 1-10
    String? notes,
    @Default(LevelTier.rookie) LevelTier recommendedLevel,
  }) = _Assessment;

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
}
```

**Step 3: Create CoachingBooking model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'coaching_booking.freezed.dart';
part 'coaching_booking.g.dart';

@freezed
class CoachingBooking with _$CoachingBooking {
  const factory CoachingBooking({
    required String id,
    required String coachId,
    required String coachName,
    required String playerId,
    required String playerName,
    required String packageId,
    required String packageName,
    required Sport sport,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String venueName,
    required int amount,
    @Default(BookingStatus.pendingPayment) BookingStatus status,
    required DateTime createdAt,
  }) = _CoachingBooking;

  factory CoachingBooking.fromJson(Map<String, dynamic> json) =>
      _$CoachingBookingFromJson(json);
}
```

**Step 4: Run build_runner + verify**

```bash
cd D:\projects\Flutter\hyperarena
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

**Step 5: Commit**

```bash
git add lib/features/coach/data/models/
git commit -m "feat: add Freezed models for CoachPackage, Assessment, CoachingBooking"
```

---

## Task 2: Mock Data — Packages, Assessments, CoachingBookings

**Files:**
- Create: `lib/core/mocks/mock_coach_packages.dart`
- Create: `lib/core/mocks/mock_assessments.dart`
- Create: `lib/core/mocks/mock_coaching_bookings.dart`
- Modify: `lib/core/mocks/mock_data.dart`

**Step 1: Create mock_coach_packages.dart**

5 coaches × 2 packages each = 10 packages. Examples:
- Andi (Tennis): "Kelas Privat Tennis" (4 sessions, Rp 550k, 60min), "Intensif Tennis" (8 sessions, Rp 500k, 90min)
- Maya (Badminton): "Dasar Badminton" (4 sessions, Rp 420k, 60min), "Kompetisi Badminton" (12 sessions, Rp 380k, 90min)
- Reza (Padel): "Intro Padel" (4 sessions, Rp 350k, 60min), "Padel Advance" (8 sessions, Rp 320k, 60min)
- Dewi (Tennis+Badminton): one per sport
- Fajar (Futsal): "Futsal Fundamental" (4 sessions, Rp 400k, 90min), "Futsal Taktik" (8 sessions, Rp 370k, 120min)

**Step 2: Create mock_assessments.dart**

4 assessments, varied data:
- assess-001: Andi → Budi (Tennis, technique:7, stamina:6, tactics:5, mentality:8, consistency:6, recommended: amateur)
- assess-002: Maya → Budi (Badminton, technique:5, stamina:7, tactics:4, mentality:7, consistency:5, recommended: rookie)
- assess-003: Andi → "Siti Rahayu" (Tennis, technique:8, stamina:7, tactics:7, mentality:8, consistency:8, recommended: intermediate)
- assess-004: Fajar → "Dika Pratama" (Futsal, technique:6, stamina:8, tactics:5, mentality:6, consistency:7, recommended: amateur)

**Step 3: Create mock_coaching_bookings.dart**

5 coaching bookings in varied states:
- cb-001: Budi + Andi Tennis, confirmed, next week
- cb-002: Budi + Maya Badminton, completed, last week
- cb-003: Budi + Reza Padel, pendingPayment, today+3
- cb-004: "Siti" + Andi Tennis, confirmed, today+2
- cb-005: "Dika" + Fajar Futsal, waitingConfirmation, today+4

**Step 4: Update MockData registry**

Add to `lib/core/mocks/mock_data.dart`:
```dart
import 'mock_coach_packages.dart';
import 'mock_assessments.dart';
import 'mock_coaching_bookings.dart';

// Add to class body:
static List<CoachPackage> get coachPackages => MockCoachPackages.packages;
static List<Assessment> get assessments => MockAssessments.assessments;
static List<CoachingBooking> get coachingBookings => MockCoachingBookings.bookings;
```

**Step 5: Verify + commit**

```bash
flutter analyze
git add lib/core/mocks/
git commit -m "feat: add mock data for coach packages, assessments, coaching bookings"
```

---

## Task 3: Extended Coach Repository + Providers

**Files:**
- Modify: `lib/features/coach/data/coach_repository.dart`
- Modify: `lib/features/coach/data/mock_coach_repository.dart`
- Modify: `lib/features/coach/providers/coach_providers.dart`
- Create: `lib/features/coach/providers/coach_detail_provider.dart`
- Create: `lib/features/coach/providers/coach_schedule_provider.dart`
- Create: `lib/features/coach/providers/student_provider.dart`
- Create: `lib/features/coach/providers/assessment_provider.dart`

**Step 1: Extend abstract CoachRepository**

Add methods:
```dart
Future<List<CoachPackage>> getCoachPackages(String coachId);
Future<List<CoachingBooking>> getCoachBookings({String? coachId, String? playerId});
Future<CoachingBooking> createCoachingBooking({
  required String coachId,
  required String packageId,
  required DateTime date,
  required String startTime,
  required String endTime,
  required String venueName,
});
Future<List<Assessment>> getAssessments({String? coachId, String? studentId});
Future<Assessment> createAssessment({
  required String studentId,
  required String studentName,
  required Sport sport,
  required int technique,
  required int stamina,
  required int tactics,
  required int mentality,
  required int consistency,
  String? notes,
  required LevelTier recommendedLevel,
});
Future<List<String>> getStudentNames(String coachId);
```

**Step 2: Implement in MockCoachRepository**

All methods use MockData, 500ms delay, simple filtering.

**Step 3: Create coach_detail_provider.dart**

```dart
// FutureProvider.family for coach detail
final coachDetailProvider = FutureProvider.family<Coach, String>((ref, coachId) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoach(coachId);
});

// FutureProvider.family for coach packages
final coachPackagesProvider = FutureProvider.family<List<CoachPackage>, String>((ref, coachId) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoachPackages(coachId);
});
```

**Step 4: Create coach_schedule_provider.dart**

```dart
// For Coach role: their upcoming bookings
final coachScheduleProvider = FutureProvider<List<CoachingBooking>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoachBookings(coachId: 'coach-001'); // Mock: current coach
});
```

**Step 5: Create student_provider.dart**

```dart
// For Coach role: list of unique student names from assessments
final studentListProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getStudentNames('coach-001');
});

// Assessments for a specific student
final studentAssessmentsProvider = FutureProvider.family<List<Assessment>, String>((ref, studentName) async {
  final repo = ref.read(coachRepositoryProvider);
  final all = await repo.getAssessments(coachId: 'coach-001');
  return all.where((a) => a.studentName == studentName).toList();
});
```

**Step 6: Create assessment_provider.dart**

```dart
// All assessments by current coach
final assessmentListProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getAssessments(coachId: 'coach-001');
});

// Coaching booking flow state for player booking a coach
class CoachBookingState { ... }
class CoachBookingNotifier extends Notifier<CoachBookingState> { ... }
final coachBookingProvider = NotifierProvider<CoachBookingNotifier, CoachBookingState>(...);
```

**Step 7: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/data/ lib/features/coach/providers/
git commit -m "feat: extend coach repository and add detail, schedule, student, assessment providers"
```

---

## Task 4: Coach Detail Screen (Player View)

**Files:**
- Create: `lib/features/coach/presentation/screens/coach_detail_screen.dart`
- Create: `lib/features/coach/presentation/widgets/package_card.dart`
- Create: `lib/features/coach/presentation/widgets/rating_stars.dart`

**Step 1: Create rating_stars.dart**

Reusable star rating widget:
```dart
class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  // Renders filled/half/empty stars using RatingThemeExtension colors
}
```

**Step 2: Create package_card.dart**

Card showing coaching package:
- Container: `AppSurfaces.surface`, `AppShadows.sm`, `radiusLg`
- Sport-colored left accent bar (4px, like session_card pattern)
- Package name (`titleMedium`) + description (`bodySmall`, max 2 lines)
- Row: sessions count pill ("4 sesi") + duration ("60 min")
- Price: `Formatters.formatRupiah(pricePerSession)` + "/sesi" caption
- "Pilih Paket" `FilledButton` (secondary color, white text)
- onTap callback for package selection

**Step 3: Create coach_detail_screen.dart**

Full-screen, pushed on top of shell. Structure:
- `CustomScrollView` with `SliverAppBar` (250h, coach avatar centered on gradient bg)
- Coach name (`headingLarge`) + verified badge
- Level badge (GamificationThemeExtension colors, radiusFull)
- Rating stars + review count + total students
- City row with location icon
- Bio section (`bodyMedium`)
- Sport pills (SportThemeExtension colors)
- Certifications as chips in a Wrap
- "Paket Coaching" section header
- List of `PackageCard` widgets from `coachPackagesProvider(coachId)`
- Bottom bar: hourly rate + "Hubungi Coach" button (placeholder snackbar)

Uses `coachDetailProvider(coachId)` + `coachPackagesProvider(coachId)`.

**Step 4: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/
git commit -m "feat: add coach detail screen with packages, rating stars"
```

---

## Task 5: Coach Booking Flow (Player books coaching)

**Files:**
- Create: `lib/features/coach/presentation/screens/coach_booking_screen.dart`
- Create: `lib/features/coach/presentation/screens/coach_booking_payment_screen.dart`
- Create: `lib/features/coach/presentation/screens/coach_booking_confirmation_screen.dart`

**Step 1: Create coach_booking_screen.dart**

After player selects a package from coach detail:
- AppBar: "Booking Coaching"
- Package summary card (coach name, package name, sport, price, duration)
- Date picker strip (reuse DatePickerStrip pattern — next 14 days)
- Time slot selection (simple list: 07:00, 08:00, ..., 20:00, 60/90min blocks)
- Venue name text field (simple TextField, player enters venue)
- Bottom bar: total amount + "Lanjutkan" button → navigate to payment

Uses `coachBookingProvider` notifier for flow state.

**Step 2: Create coach_booking_payment_screen.dart**

Same pattern as session payment:
- 30-min countdown timer
- Amount + coach name
- QRIS / Bank Transfer tabs
- "Saya Sudah Bayar" button → navigate to confirmation

**Step 3: Create coach_booking_confirmation_screen.dart**

Same pattern as session confirmation:
- Animated success check (ScaleTransition, elastic curve)
- "Booking Coaching Berhasil!" heading
- Summary card (coach, package, date, time, venue)
- "Kembali ke Explore" + "Kembali ke Beranda" buttons
- Resets coachBookingProvider

**Step 4: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/screens/
git commit -m "feat: add coach booking flow — schedule, payment, confirmation"
```

---

## Task 6: Coach Dashboard Screen (Coach Role)

**Files:**
- Create: `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`

**Step 1: Create coach_dashboard_screen.dart**

Coach's home tab. Structure:
- Greeting: "Selamat Pagi, Coach Andi!"
- Quick stats row (3 cards): Total Murid (120), Sesi Minggu Ini (8), Rating (4.8★)
  - Each: `AppSurfaces.surface`, `AppShadows.xs`, `radiusMd`
  - Icon + number (`numberMedium`) + label (`caption`)
- "Jadwal Hari Ini" section header
  - List of today's CoachingBooking entries from `coachScheduleProvider`
  - Each row: time + student name + sport pill + status badge
  - Empty state if no sessions today
- "Penilaian Terbaru" section header
  - Last 3 assessments from `assessmentListProvider`
  - Each: student name + sport + date + radar summary text
  - "Lihat Semua →" link

Uses `coachScheduleProvider`, `assessmentListProvider`.

**Step 2: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/screens/coach_dashboard_screen.dart
git commit -m "feat: add coach dashboard with stats, schedule, recent assessments"
```

---

## Task 7: Coach Schedule Screen (Coach Role)

**Files:**
- Create: `lib/features/coach/presentation/screens/coach_schedule_screen.dart`
- Create: `lib/features/coach/presentation/widgets/coaching_booking_card.dart`

**Step 1: Create coaching_booking_card.dart**

Card for coaching booking entries (reused in dashboard + schedule):
- Container: `surface` bg, `AppShadows.sm`, `radiusLg`
- Sport-colored left accent bar (4px)
- Student name (`titleSmall`) + sport pill
- Date + time row (icons + text)
- Venue row
- Status badge (BookingStatusThemeExtension colors)
- Package name (`caption`)

**Step 2: Create coach_schedule_screen.dart**

Coach's schedule tab. Structure:
- TabBar: "Mendatang" | "Selesai"
- Each tab: `AsyncValueWidget` → list of `CoachingBookingCard`
  - Mendatang: filter confirmed + pendingPayment + waitingConfirmation
  - Selesai: filter completed + cancelled
- Pull-to-refresh
- Empty state per tab
- FAB or header action: "Atur Jadwal" (placeholder snackbar for now)

Uses `coachScheduleProvider`.

**Step 3: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/
git commit -m "feat: add coach schedule screen with booking cards"
```

---

## Task 8: Student List + Student Detail Screens (Coach Role)

**Files:**
- Create: `lib/features/coach/presentation/screens/student_list_screen.dart`
- Create: `lib/features/coach/presentation/screens/student_detail_screen.dart`
- Create: `lib/features/coach/presentation/widgets/radar_chart_widget.dart`

**Step 1: Create radar_chart_widget.dart**

Simple visual for assessment scores (5 axes: Teknik, Stamina, Taktik, Mental, Konsistensi):
- Use `CustomPaint` with pentagon shape
- Background: light neutral grid lines
- Foreground: filled polygon with primary color (alpha 0.3) + border
- Labels at each vertex
- Scale 1–10

**Step 2: Create student_list_screen.dart**

Coach's students tab:
- List of unique student names from `studentListProvider`
- Each row: CircleAvatar with initials + student name + assessment count + last assessed date
- Container: `surface` bg, `AppShadows.xs`, `radiusMd`
- Tap → navigate to student detail
- Empty state: "Belum ada murid"

**Step 3: Create student_detail_screen.dart**

Full-screen pushed. Structure:
- AppBar with student name
- Student avatar (large, centered)
- "Riwayat Penilaian" section header
- List of assessments for this student
- Each assessment card: date + sport pill + RadarChartWidget (compact, 120x120) + recommended level badge + notes
- Bottom: "Buat Penilaian Baru" button → navigate to assessment form

Uses `studentAssessmentsProvider(studentName)`.

**Step 4: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/
git commit -m "feat: add student list, student detail with radar chart"
```

---

## Task 9: Assessment Form Screen (Coach Role)

**Files:**
- Create: `lib/features/coach/presentation/screens/assessment_form_screen.dart`

**Step 1: Create assessment_form_screen.dart**

Form for coach to assess a student:
- AppBar: "Penilaian Baru"
- Student name field (pre-filled if from student detail, or dropdown/text)
- Sport selector (SportChipSelector, single select)
- 5 sliders (1–10) with labels:
  - Teknik (technique)
  - Stamina (stamina)
  - Taktik (tactics)
  - Mental (mentality)
  - Konsistensi (consistency)
  - Each: label + current value + Slider with primary color
- Live RadarChartWidget preview (updates as sliders change)
- Recommended level dropdown (LevelTier values, using GamificationThemeExtension)
- Notes text field (multiline, optional)
- Bottom: "Simpan Penilaian" button with colored shadow
  - On submit: create assessment via provider, show success snackbar, pop back

**Step 2: Verify + commit**

```bash
flutter analyze
git add lib/features/coach/presentation/screens/assessment_form_screen.dart
git commit -m "feat: add assessment form with radar chart preview and sliders"
```

---

## Task 10: Wire Routes — Coach Detail + Booking Flow + Coach Shell

**Files:**
- Modify: `lib/routing/app_router.dart`
- Modify: `lib/features/coach/presentation/widgets/coach_card.dart` (wire "Lihat" button)

**Step 1: Add coach routes to app_router.dart**

Add imports for all new screens. Add routes:

```dart
// Coach detail (player view, full-screen)
GoRoute(
  path: '/coach/:id',
  builder: (_, state) => CoachDetailScreen(coachId: state.pathParameters['id']!),
),

// Coach booking flow
GoRoute(
  path: '/coach/booking',
  builder: (_, _) => const CoachBookingScreen(),
),
GoRoute(
  path: '/coach/booking/payment',
  builder: (_, _) => const CoachBookingPaymentScreen(),
),
GoRoute(
  path: '/coach/booking/confirmation',
  builder: (_, _) => const CoachBookingConfirmationScreen(),
),

// Coach role shell (4 tabs)
StatefulShellRoute.indexedStack(
  builder: (_, _, shell) => RoleShell(
    navigationShell: shell,
    role: UserRole.coach,
  ),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/coach/dashboard', builder: (_, _) => const CoachDashboardScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/coach/schedule', builder: (_, _) => const CoachScheduleScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/coach/students', builder: (_, _) => const StudentListScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/coach/profile', builder: (_, _) => const ProfileScreen()),
    ]),
  ],
),

// Coach full-screen routes
GoRoute(
  path: '/coach/student/:name',
  builder: (_, state) => StudentDetailScreen(studentName: state.pathParameters['name']!),
),
GoRoute(
  path: '/coach/assessment/new',
  builder: (_, _) => const AssessmentFormScreen(),
),
```

**Step 2: Wire CoachCard "Lihat" button**

In `coach_card.dart`, change the "Lihat" button onPressed from snackbar to:
```dart
context.push('/coach/${coach.id}')
```

**Step 3: Update auth redirect for coach role**

In the router's redirect, handle coach role:
```dart
if (isAuthenticated &&
    (state.matchedLocation == '/auth/login' ||
        state.matchedLocation == '/auth/register')) {
  final role = authState!.role;
  return switch (role) {
    UserRole.player => '/player/home',
    UserRole.coach => '/coach/dashboard',
    UserRole.organizer => '/player/home', // placeholder
  };
}
```

**Step 4: Verify + commit**

```bash
flutter analyze
flutter build apk --debug -t lib/main_mock.dart
git add lib/routing/app_router.dart lib/features/coach/presentation/widgets/coach_card.dart
git commit -m "feat: wire coach routes — detail, booking flow, coach shell, student screens"
```

---

## Task 11: Final Verification

**Step 1: Run analysis**

```bash
flutter analyze
```
Expected: 0 issues

**Step 2: Build**

```bash
flutter build apk --debug -t lib/main_mock.dart
```
Expected: success

**Step 3: Run on device**

```bash
flutter run -t lib/main_mock.dart -d emulator-5554
```

Test flows:
- Login → Explore → Coach tab → Tap coach → Coach detail with packages + rating stars
- Coach detail → Select package → Booking screen → Pick date/time → Payment → Confirmation
- (Switch to coach user if mock supports it, or verify coach shell renders)
- Coach Dashboard → Schedule tab → Students tab → Student detail → Assessment form

**Step 4: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix: Phase 2 coach implementation polish"
```

---

## Verification Checklist

- [ ] `flutter analyze` → zero issues
- [ ] `flutter build apk --debug` → success
- [ ] Coach detail screen shows coach info, packages, rating, certifications
- [ ] Coach booking flow: package → date/time → payment → confirmation
- [ ] Coach dashboard: stats, today's schedule, recent assessments
- [ ] Coach schedule: upcoming/completed tabs with booking cards
- [ ] Student list shows unique students with assessment counts
- [ ] Student detail shows assessment history with radar charts
- [ ] Assessment form with 5 sliders, live radar preview, sport selector, save
- [ ] All screens use design system tokens consistently
- [ ] Indonesian text throughout
- [ ] Rupiah formatting correct
