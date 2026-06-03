# Coach Dashboard Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** `docs/superpowers/specs/2026-06-03-coach-dashboard-redesign.md`

**Goal:** Restructure the coach dashboard into a layered command center (operational → performance → student) backed by a per-section result type, with a visible role pill, four new sections (action items, attention list, sport breakdown, performance metrics), and consistent empty/error states.

**Architecture:** Single-screen vertical scroll, each section is its own widget reading either an existing provider or a new aggregate `coachDashboardSummaryProvider` that wraps each sub-fetch in `SectionResult<T>` so a single failure does not blank the dashboard. Existing `_ScheduleCard` and `_AssessmentCard` widgets are reused as-is.

**Tech Stack:** Flutter 3.x, Riverpod (`flutter_riverpod` 2.6), Freezed 2.5, `fl_chart` 0.70 (already in `pubspec.yaml`), `shimmer` 3.0, `go_router` 14.8.

---

## Scope Clarifications

These come from the spec self-review plus discovery during plan-writing:

1. **Mock → API switch for existing providers (spec §5 mandatory fix #2) is OUT of this plan.**
   `coachRepositoryProvider` returns the abstract `CoachRepository`. No `ApiCoachRepository` implementation exists today — the existing API repos (`ApiCoachSessionRepository`, `ApiCoachEnrollmentRepository`, `ApiMarketplaceCoachRepository`) return different model types (`CoachSession`, `Enrollment`) that do not match the abstract's signature (`CoachingBooking`, `Assessment`). Bridging requires BE/FE model alignment which is a separate effort. The dashboard's Today Schedule and Recent Assessments therefore continue to read mock data via `MockCoachRepository` after this plan ships. Everything else in the spec is in scope.

2. **`coachIdProvider` migration is partial.**
   The new provider replaces the hardcoded `'coach-001'` literal in `coach_schedule_provider.dart` and `assessment_provider.dart`. But because the data source is still mock, the mock's coach ID `'coach-001'` is what the mock filters on. To keep the dashboard rendering during the transition, `coachIdProvider` returns `'coach-001'` until real auth-derived ID is plumbed alongside the mock→API switch.

3. **Today Schedule shows marketplace bookings only.**
   The spec assumes Today Schedule's data shape stays `List<CoachingBooking>` (marketplace bookings). Unifying with club `CoachSession` data is out of scope — that's a follow-up once model alignment lands.

4. **Performance widget reads from a new dashboard repository.**
   The aggregate `coachDashboardSummaryProvider` introduces an `ApiCoachDashboardRepository` that owns the new endpoints (performance, action counts, attention list, sport breakdown). When BE has not shipped the dedicated endpoint, the repo computes client-side from `ApiCoachSessionRepository`/`ApiCoachEnrollmentRepository` (per spec §5).

---

## File Structure

| Path | Responsibility | Created/Modified |
|---|---|---|
| `lib/core/utils/section_result.dart` | Sealed `SectionResult<T>` with `.success` and `.failure` variants | Created |
| `lib/core/utils/section_result.freezed.dart` | Freezed generated | Created (codegen) |
| `lib/features/coach/data/models/coach_performance.dart` | Freezed model | Created |
| `lib/features/coach/data/models/coach_action_counts.dart` | Freezed model | Created |
| `lib/features/coach/data/models/coach_dashboard_summary.dart` | Freezed model holding `SectionResult` per section | Created |
| `lib/features/coach/data/api_coach_dashboard_repository.dart` | New API repo: performance, action counts, attention list, sport breakdown | Created |
| `lib/features/coach/providers/coach_id_provider.dart` | Derives coach ID from `authNotifierProvider` | Created |
| `lib/features/coach/providers/coach_dashboard_summary_provider.dart` | Parallel-fetch + Result-wrapping orchestrator | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_role_pill.dart` | Pill showing active role + optional tap-to-profile | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart` | Greeting row + tagline + pill + bell | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart` | Pending items banner | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart` | Today schedule list | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart` | 3-card metric strip | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart` | Top-3 assessments | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart` | Ungraded students preview | Created |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart` | Per-sport chart | Created |
| `lib/features/coach/presentation/screens/coach_dashboard_screen.dart` | Reduced to shell composing the section widgets + `RefreshIndicator` | Modified |
| `lib/features/coach/providers/coach_schedule_provider.dart` | `coachId` now from `coachIdProvider` | Modified |
| `lib/features/coach/providers/assessment_provider.dart` | `coachId` now from `coachIdProvider` | Modified |
| `lib/features/auth/providers/auth_provider.dart` | `_invalidateAllFeatureProviders` adds new providers | Modified |
| `lib/core/theme/app_colors.dart` | Add `coachAccent` token if no existing color fits | Modified |
| `test/core/utils/section_result_test.dart` | Pure unit | Created |
| `test/features/coach/providers/coach_id_provider_test.dart` | Riverpod ProviderContainer test | Created |
| `test/features/coach/providers/coach_dashboard_summary_provider_test.dart` | Parallel-fetch + partial-failure semantics | Created |
| `test/features/coach/presentation/widgets/dashboard/*_test.dart` | One widget test per dashboard widget | Created (8 files) |

---

## Phase 1 — Foundation: `SectionResult`, Freezed models

### Task 1.1: `SectionResult` sealed class

**Files:**
- Create: `lib/core/utils/section_result.dart`
- Test: `test/core/utils/section_result_test.dart`

- [ ] **Step 1: Write the failing test**

Write `test/core/utils/section_result_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';

void main() {
  group('SectionResult', () {
    test('success holds the value', () {
      const r = SectionResult.success(42);
      expect(r.valueOrNull, 42);
      expect(r.errorOrNull, null);
      expect(r.isSuccess, true);
      expect(r.isFailure, false);
    });

    test('failure holds the error', () {
      final err = Exception('boom');
      final r = SectionResult<int>.failure(err, StackTrace.current);
      expect(r.valueOrNull, null);
      expect(r.errorOrNull, err);
      expect(r.isSuccess, false);
      expect(r.isFailure, true);
    });

    test('mapSuccess transforms only success', () {
      const a = SectionResult<int>.success(10);
      final b = a.mapSuccess((v) => v * 2);
      expect(b.valueOrNull, 20);

      final c = SectionResult<int>.failure(Exception('x'), null);
      final d = c.mapSuccess((v) => v * 2);
      expect(d.isFailure, true);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/utils/section_result_test.dart`
Expected: FAIL — `section_result.dart` does not exist.

- [ ] **Step 3: Write the implementation**

Write `lib/core/utils/section_result.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_result.freezed.dart';

/// A per-section result used by the coach dashboard summary so a single
/// fetch failure does not invalidate the whole dashboard. Widgets read their
/// section's `SectionResult` and render either data or an inline retry.
@freezed
sealed class SectionResult<T> with _$SectionResult<T> {
  const SectionResult._();

  const factory SectionResult.success(T value) = SectionSuccess<T>;
  const factory SectionResult.failure(Object error, StackTrace? stackTrace) =
      SectionFailure<T>;

  bool get isSuccess => this is SectionSuccess<T>;
  bool get isFailure => this is SectionFailure<T>;

  T? get valueOrNull => switch (this) {
        SectionSuccess<T>(:final value) => value,
        SectionFailure<T>() => null,
      };

  Object? get errorOrNull => switch (this) {
        SectionSuccess<T>() => null,
        SectionFailure<T>(:final error) => error,
      };

  SectionResult<R> mapSuccess<R>(R Function(T) f) => switch (this) {
        SectionSuccess<T>(:final value) => SectionResult.success(f(value)),
        SectionFailure<T>(:final error, :final stackTrace) =>
          SectionResult.failure(error, stackTrace),
      };
}
```

- [ ] **Step 4: Generate Freezed code and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `lib/core/utils/section_result.freezed.dart`.

Run: `flutter test test/core/utils/section_result_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/core/utils/section_result.dart lib/core/utils/section_result.freezed.dart test/core/utils/section_result_test.dart
git commit -m "Coach dashboard: add SectionResult<T> for per-section partial failures"
```

---

### Task 1.2: `CoachPerformance` model

**Files:**
- Create: `lib/features/coach/data/models/coach_performance.dart`

- [ ] **Step 1: Write the model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_performance.freezed.dart';
part 'coach_performance.g.dart';

/// Performance metrics for a coach. Currency fields are in the smallest
/// unit (IDR uses whole rupiah, MYR uses cents — multiply by tenant
/// currency multiplier when formatting). Earnings are club-side only;
/// marketplace earnings are not part of this iteration.
@freezed
class CoachPerformance with _$CoachPerformance {
  const factory CoachPerformance({
    required int earningsThisWeekCents,
    required int earningsThisMonthCents,
    required int sessionsThisWeek,
    required int sessionsThisMonth,
    required int activeStudentCount,
  }) = _CoachPerformance;

  factory CoachPerformance.fromJson(Map<String, dynamic> json) =>
      _$CoachPerformanceFromJson(json);
}
```

- [ ] **Step 2: Generate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `coach_performance.freezed.dart` and `coach_performance.g.dart`.

Run: `flutter analyze lib/features/coach/data/models/coach_performance.dart`
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/data/models/coach_performance.dart lib/features/coach/data/models/coach_performance.freezed.dart lib/features/coach/data/models/coach_performance.g.dart
git commit -m "Coach dashboard: add CoachPerformance model"
```

---

### Task 1.3: `CoachActionCounts` model

**Files:**
- Create: `lib/features/coach/data/models/coach_action_counts.dart`

- [ ] **Step 1: Write the model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_action_counts.freezed.dart';
part 'coach_action_counts.g.dart';

/// Counts the dashboard surfaces as "action items" — unmarked attendance,
/// ungraded assessments for completed sessions, and students who have
/// never received an assessment.
@freezed
class CoachActionCounts with _$CoachActionCounts {
  const factory CoachActionCounts({
    required int absencesUnmarked,
    required int assessmentsUngraded,
    required int studentsUngraded,
  }) = _CoachActionCounts;

  factory CoachActionCounts.fromJson(Map<String, dynamic> json) =>
      _$CoachActionCountsFromJson(json);
}
```

- [ ] **Step 2: Generate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter analyze lib/features/coach/data/models/coach_action_counts.dart`
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/data/models/coach_action_counts.dart lib/features/coach/data/models/coach_action_counts.freezed.dart lib/features/coach/data/models/coach_action_counts.g.dart
git commit -m "Coach dashboard: add CoachActionCounts model"
```

---

### Task 1.4: `CoachDashboardSummary` model

**Files:**
- Create: `lib/features/coach/data/models/coach_dashboard_summary.dart`

`Student` and `Sport` types already exist (`lib/features/coach/data/models/`, `lib/core/theme/app_enums.dart`). Verify before continuing:

```bash
grep -rn "class Student " lib/features/coach/data/models/
grep -n "enum Sport" lib/core/theme/app_enums.dart
```

- [ ] **Step 1: Write the model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';

part 'coach_dashboard_summary.freezed.dart';

/// All data the dashboard summary provider produces. Each section is a
/// `SectionResult<T>` so one failing fetch does not invalidate the rest.
/// `sessionsTomorrow` is derived from `coachScheduleProvider` (no separate
/// fetch) and therefore stays a plain int.
@freezed
class CoachDashboardSummary with _$CoachDashboardSummary {
  const factory CoachDashboardSummary({
    required SectionResult<CoachPerformance> performance,
    required SectionResult<CoachActionCounts> actions,
    required SectionResult<List<CoachStudentRosterItem>> attentionList,
    required SectionResult<Map<Sport, int>> sportBreakdown,
    required int sessionsTomorrow,
  }) = _CoachDashboardSummary;
}
```

If `CoachStudentRosterItem` is not the right type, use the project's existing student model from the grep result above. Document the choice in the commit message.

- [ ] **Step 2: Generate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter analyze lib/features/coach/data/models/coach_dashboard_summary.dart`
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/data/models/coach_dashboard_summary.dart lib/features/coach/data/models/coach_dashboard_summary.freezed.dart
git commit -m "Coach dashboard: add CoachDashboardSummary holding SectionResult per section"
```

---

## Phase 2 — Auth wiring: `coachIdProvider`

### Task 2.1: Add `coachIdProvider`

**Files:**
- Create: `lib/features/coach/providers/coach_id_provider.dart`
- Test: `test/features/coach/providers/coach_id_provider_test.dart`

Per Scope Clarification #2, this provider returns `'coach-001'` for now so the mock keeps working. The signature is correct so that swapping to `user.id` later is a one-line change.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';

void main() {
  test('coachIdProvider returns the mock coach id during transition', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final id = container.read(coachIdProvider);
    expect(id, 'coach-001');
  });
}
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/providers/coach_id_provider_test.dart`
Expected: FAIL — provider does not exist.

- [ ] **Step 3: Write the provider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The active coach's ID for dashboard queries.
///
/// Transitional: returns the mock literal `'coach-001'` so the existing
/// mock repository keeps filtering correctly. When `coachRepositoryProvider`
/// switches from mock to API (see plan Scope Clarification #1), update this
/// provider to read `authNotifierProvider`'s `user.id`.
final coachIdProvider = Provider<String>((ref) {
  return 'coach-001';
});
```

- [ ] **Step 4: Verify test passes**

Run: `flutter test test/features/coach/providers/coach_id_provider_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/coach/providers/coach_id_provider.dart test/features/coach/providers/coach_id_provider_test.dart
git commit -m "Coach dashboard: add coachIdProvider (transitional mock value)"
```

---

### Task 2.2: Refactor `coachScheduleProvider` to use `coachIdProvider`

**Files:**
- Modify: `lib/features/coach/providers/coach_schedule_provider.dart`

- [ ] **Step 1: Edit the file**

Replace the contents of `lib/features/coach/providers/coach_schedule_provider.dart` with:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final coachScheduleProvider =
    FutureProvider<List<CoachingBooking>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);
  return repo.getCoachBookings(coachId: coachId);
});
```

- [ ] **Step 2: Run full test suite**

Run: `flutter test`
Expected: existing tests pass. No new test required — behavior is unchanged because `coachIdProvider` returns the same literal that was hardcoded.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/providers/coach_schedule_provider.dart
git commit -m "Coach dashboard: route coachScheduleProvider through coachIdProvider"
```

---

### Task 2.3: Refactor `assessmentListProvider` to use `coachIdProvider`

**Files:**
- Modify: `lib/features/coach/providers/assessment_provider.dart`

- [ ] **Step 1: Edit the file**

Replace the contents of `lib/features/coach/providers/assessment_provider.dart` with:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final assessmentListProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);
  return repo.getAssessments(coachId: coachId);
});
```

- [ ] **Step 2: Run full test suite**

Run: `flutter test`
Expected: pass.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/providers/assessment_provider.dart
git commit -m "Coach dashboard: route assessmentListProvider through coachIdProvider"
```

---

## Phase 3 — Widget extraction (no behavior change)

Each extracted widget renders identically to the current inline code; tests focus on a single golden behavior to catch regression during the move.

### Task 3.1: Create `CoachDashboardGreeting`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';

void main() {
  testWidgets('greeting shows first name from user', (tester) async {
    const user = User(
      id: 'u1',
      name: 'Budi Santoso',
      email: 'b@x.com',
      role: UserRole.coach,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _StubAuth(user)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardGreeting()),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Budi'), findsOneWidget);
    expect(find.text('Kelola jadwal dan murid Anda'), findsOneWidget);
  });

  testWidgets('greeting falls back to "Coach" when name is null', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _StubAuth(null)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardGreeting()),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Coach'), findsOneWidget);
  });
}

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);
  final User? _user;
  @override
  User? build() => _user;
}
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Write the widget**

Extract lines 33-73 + the `_greeting()` helper from `lib/features/coach/presentation/screens/coach_dashboard_screen.dart` into:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/notification/presentation/widgets/notification_bell.dart';

class CoachDashboardGreeting extends ConsumerWidget {
  const CoachDashboardGreeting({super.key});

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, ${Formatters.firstName(user?.name, fallback: 'Coach')}!',
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Kelola jadwal dan murid Anda',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const NotificationBell(),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Use the new widget in the screen**

Edit `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`:

1. Add import: `import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';`
2. Replace the inline greeting block (the `Row` at lines 49-73) with `const CoachDashboardGreeting()`.
3. Remove the now-unused `_greeting()` method (lines 25-31).

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart
git commit -m "Coach dashboard: extract greeting into its own widget"
```

---

### Task 3.2: Create `CoachDashboardTodaySchedule`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule_test.dart`

The internal `_ScheduleCard` widget (lines 266-344 of the screen) is also moved into this file so it stays private to the section that uses it. The empty-state text is upgraded to use the shared `EmptyState` widget (spec §6).

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/booking_status.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

CoachingBooking _booking(DateTime date) => CoachingBooking(
      id: 'b1',
      coachId: 'coach-001',
      coachName: 'Coach',
      playerId: 'p1',
      playerName: 'Player A',
      packageId: 'pkg-1',
      packageName: 'Standard',
      sport: Sport.tennis,
      venueName: 'Court 1',
      date: date,
      startTime: '08:00',
      endTime: '09:00',
      status: BookingStatus.confirmed,
      pricePerHour: 100000,
      totalAmount: 100000,
      duration: 1,
    );

void main() {
  testWidgets('renders today bookings only', (tester) async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith(
            (ref) => Future.value([_booking(now), _booking(tomorrow)]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardTodaySchedule()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('Player A'), findsOneWidget);
  });

  testWidgets('shows EmptyState when no bookings today', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith((ref) => Future.value(<CoachingBooking>[])),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardTodaySchedule()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Tidak ada jadwal hari ini'), findsOneWidget);
  });
}
```

If the `CoachingBooking` constructor differs from above, copy the actual signature from `lib/features/coach/data/models/coaching_booking.dart`. The plan does not own the canonical model shape.

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

class CoachDashboardTodaySchedule extends ConsumerWidget {
  const CoachDashboardTodaySchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(coachScheduleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jadwal Hari Ini', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.md),
        AsyncValueWidget<List<CoachingBooking>>(
          value: scheduleAsync,
          data: (bookings) {
            final now = DateTime.now();
            final todayBookings = bookings.where((b) =>
                b.date.year == now.year &&
                b.date.month == now.month &&
                b.date.day == now.day).toList();

            if (todayBookings.isEmpty) {
              return const EmptyState(
                icon: Icons.event_available,
                message: 'Tidak ada jadwal hari ini',
              );
            }
            return Column(
              children: todayBookings
                  .map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: _ScheduleCard(booking: b),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final CoachingBooking booking;
  const _ScheduleCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Formatters.formatTimeRange(booking.startTime, booking.endTime),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(booking.playerName, style: AppTypography.titleSmall),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
                decoration: BoxDecoration(
                  color: sportTheme.backgroundColor(booking.sport),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  SportChipSelector.sportLabel(booking.sport),
                  style: AppTypography.badge
                      .copyWith(color: sportTheme.textColor(booking.sport)),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
                decoration: BoxDecoration(
                  color: statusTheme.backgroundColor(booking.status),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  StatusBadge.statusLabel(booking.status),
                  style: AppTypography.badge
                      .copyWith(color: statusTheme.textColor(booking.status)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule_test.dart`
Expected: PASS.

- [ ] **Step 5: Use in screen + delete old block**

Edit `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`:
1. Add import: `import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';`
2. Replace the "Jadwal Hari Ini" block (the `Text` heading + `AsyncValueWidget` at the old lines 80-121) with `const CoachDashboardTodaySchedule()`.
3. Delete the in-file `_ScheduleCard` class.

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule_test.dart
git commit -m "Coach dashboard: extract today schedule section into its own widget"
```

---

### Task 3.3: Create `CoachDashboardRecentAssessments`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';

void main() {
  testWidgets('shows EmptyState with CTA when no assessments', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentListProvider.overrideWith(
            (ref) => Future.value(<Assessment>[]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardRecentAssessments()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Belum ada penilaian'), findsOneWidget);
    expect(find.text('Buat Penilaian'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Write the widget**

Move the inline assessment section (current lines 124-181, plus the `_AssessmentCard` class at lines 346-447) into the new file. Replace the centered-text empty state with the shared `EmptyState` + a CTA that navigates to `/coach/students`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';

class CoachDashboardRecentAssessments extends ConsumerWidget {
  const CoachDashboardRecentAssessments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentsAsync = ref.watch(assessmentListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Penilaian Terbaru', style: AppTypography.titleMedium),
            TextButton(
              onPressed: () => context.go('/coach/students'),
              child: Text(
                'Lihat Semua',
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        AsyncValueWidget<List<Assessment>>(
          value: assessmentsAsync,
          data: (assessments) {
            final sorted = [...assessments]..sort((a, b) => b.date.compareTo(a.date));
            final recent = sorted.take(3).toList();
            if (recent.isEmpty) {
              return EmptyState(
                icon: Icons.assignment_outlined,
                message: 'Belum ada penilaian',
                actionLabel: 'Buat Penilaian',
                onAction: () => context.go('/coach/students'),
              );
            }
            return Column(
              children: recent
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: _AssessmentCard(assessment: a),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  const _AssessmentCard({required this.assessment});

  double get _averageScore =>
      (assessment.technique +
              assessment.stamina +
              assessment.tactics +
              assessment.mentality +
              assessment.consistency) /
          5;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assessment.studentName, style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: AppDimensions.xxs),
                      decoration: BoxDecoration(
                        color: sportTheme.backgroundColor(assessment.sport),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        SportChipSelector.sportLabel(assessment.sport),
                        style: AppTypography.badge.copyWith(
                            color: sportTheme.textColor(assessment.sport)),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      Formatters.formatDate(assessment.date),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _averageScore.toStringAsFixed(1),
                style: AppTypography.numberMedium
                    .copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.xxs),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xxs),
                decoration: BoxDecoration(
                  color: gamification
                      .levelBackgroundColor(assessment.recommendedLevel),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  GamificationHelpers.tierLabel(assessment.recommendedLevel),
                  style: AppTypography.badge.copyWith(
                      color: gamification
                          .levelTextColor(assessment.recommendedLevel)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments_test.dart`
Expected: PASS.

- [ ] **Step 5: Use in screen + clean up**

Edit `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`:
1. Add import for the new widget.
2. Replace the "Penilaian Terbaru" block (lines 124-181 in current source) with `const CoachDashboardRecentAssessments()`.
3. Delete the in-file `_AssessmentCard` class.

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments_test.dart
git commit -m "Coach dashboard: extract recent assessments section + adopt EmptyState"
```

---

### Task 3.4: Shrink screen to shell with RefreshIndicator

**Files:**
- Modify: `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`

At this point the screen still contains the hardcoded `_QuickStatsRow` and `_StatCard` private classes. They're replaced later in Phase 8. For now, just wrap the body in `RefreshIndicator` and clean up the layout.

- [ ] **Step 1: Replace the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(coachScheduleProvider);
    ref.invalidate(assessmentListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: AppDimensions.base),
                CoachDashboardGreeting(),
                SizedBox(height: AppDimensions.xl),
                _QuickStatsRow(), // TEMPORARY — replaced in Phase 8
                SizedBox(height: AppDimensions.xl),
                CoachDashboardTodaySchedule(),
                SizedBox(height: AppDimensions.xl),
                CoachDashboardRecentAssessments(),
                SizedBox(height: AppDimensions.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats Row — TEMPORARY, replaced by CoachDashboardPerformance in Phase 8
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(icon: Icons.people_outline, value: '120', label: 'Total Murid')),
        SizedBox(width: AppDimensions.sm),
        Expanded(child: _StatCard(icon: Icons.calendar_today, value: '8', label: 'Sesi Minggu Ini')),
        SizedBox(width: AppDimensions.sm),
        Expanded(child: _StatCard(icon: Icons.star_rounded, value: '4.8', label: 'Rating')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: AppDimensions.iconMd),
          const SizedBox(height: AppDimensions.sm),
          Text(value, style: AppTypography.numberMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyzer + full test**

Run: `flutter analyze`
Expected: no errors (or unrelated pre-existing warnings only).

Run: `flutter test`
Expected: pass.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/presentation/screens/coach_dashboard_screen.dart
git commit -m "Coach dashboard: shrink screen to shell + RefreshIndicator"
```

---

## Phase 4 — `CoachRolePill`

### Task 4.1: Add `coachAccent` color token (if missing)

**Files:**
- Modify: `lib/core/theme/app_colors.dart`

- [ ] **Step 1: Check for existing fit**

```bash
grep -n "coach\|accent\|secondary" lib/core/theme/app_colors.dart
```

If a token like `secondary`, `tealAccent`, or anything role-flavored fits well visually, skip the next step and reuse it in Task 4.2.

- [ ] **Step 2: Add token if needed**

Add inside the existing `AppColors` class:

```dart
/// Background tint for the coach role pill. Distinct enough from the
/// `primary` brand accent to read as "role indicator" rather than CTA.
static const Color coachAccent = Color(0xFF14B8A6); // teal-500
```

Pair with text color (use existing white or `neutral0` if defined).

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_colors.dart
git commit -m "Theme: add coachAccent color token for role pill"
```

(Skip the commit if Step 2 was skipped.)

---

### Task 4.2: Build `CoachRolePill`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_role_pill.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_role_pill_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_role_pill.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);
  final User? _user;
  @override
  User? build() => _user;
}

GoRouter _routerCapturing(List<String> pushed) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: CoachRolePill()),
        ),
        GoRoute(path: '/profile', builder: (_, __) {
          pushed.add('/profile');
          return const Scaffold(body: SizedBox());
        }),
      ],
    );

void main() {
  testWidgets('renders MODE COACH label', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing([])),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('MODE COACH'), findsOneWidget);
  });

  testWidgets('multi-role: tap navigates to /profile', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach', 'organizer'],
    );
    final pushed = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing(pushed)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('MODE COACH'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/profile'));
  });

  testWidgets('single-role: chevron not present', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing([])),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });
}
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_role_pill_test.dart`
Expected: FAIL — file missing.

- [ ] **Step 3: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';

class CoachRolePill extends ConsumerWidget {
  const CoachRolePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final hasMultipleRoles = (user?.availableRoles.length ?? 0) > 1;

    final pill = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.coachAccent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          const Icon(Icons.sports, color: Colors.white, size: 14),
          const SizedBox(width: AppDimensions.xxs),
          Text(
            'MODE COACH',
            style: AppTypography.badge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasMultipleRoles) ...[
            const SizedBox(width: AppDimensions.xxs),
            const Icon(Icons.chevron_right, color: Colors.white, size: 14),
          ],
        ],
      ),
    );

    if (!hasMultipleRoles) return pill;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go('/profile'),
      child: pill,
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_role_pill_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_role_pill.dart test/features/coach/presentation/widgets/dashboard/coach_role_pill_test.dart
git commit -m "Coach dashboard: add CoachRolePill widget"
```

---

### Task 4.3: Integrate `CoachRolePill` into `CoachDashboardGreeting`

**Files:**
- Modify: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart`
- Modify: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart`

- [ ] **Step 1: Update the greeting widget**

Replace its `build` method so the layout becomes:
1. Top row: `CoachRolePill` (left) + `NotificationBell` (right).
2. Greeting text line + tagline below.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(authNotifierProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          CoachRolePill(),
          NotificationBell(),
        ],
      ),
      const SizedBox(height: AppDimensions.md),
      Text(
        '${_greeting()}, ${Formatters.firstName(user?.name, fallback: 'Coach')}!',
        style: AppTypography.headingLarge,
      ),
      const SizedBox(height: AppDimensions.xs),
      Text(
        'Kelola jadwal dan murid Anda',
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );
}
```

Add the import for `coach_role_pill.dart`.

- [ ] **Step 2: Extend the greeting test**

Add to `coach_dashboard_greeting_test.dart`:

```dart
testWidgets('greeting renders role pill', (tester) async {
  const user = User(
    id: 'u1',
    name: 'Budi Santoso',
    email: 'b@x.com',
    role: UserRole.coach,
    availableRoles: ['coach'],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
      child: const MaterialApp(home: Scaffold(body: CoachDashboardGreeting())),
    ),
  );
  await tester.pump();
  expect(find.text('MODE COACH'), findsOneWidget);
});
```

- [ ] **Step 3: Run tests**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart`
Expected: PASS (3 tests including the new one).

- [ ] **Step 4: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting_test.dart
git commit -m "Coach dashboard: greeting renders CoachRolePill above name"
```

---

## Phase 5 — Dashboard repository + summary provider + Action Items

### Task 5.1: `ApiCoachDashboardRepository` skeleton

**Files:**
- Create: `lib/features/coach/data/api_coach_dashboard_repository.dart`

The repo gets stub methods for all four summary calls. Each method throws `UnimplementedError` to start; per-section tasks (5.x, 6.x, 7.x, 8.x) replace the body with the real call.

- [ ] **Step 1: Create the file**

```dart
import 'package:dio/dio.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

/// Backs the dashboard's aggregate summary. Each method maps to one
/// SectionResult slot in CoachDashboardSummary. When a BE summary endpoint
/// does not yet exist, the implementation derives the value from existing
/// list endpoints.
class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._dio);
  final Dio _dio;

  Future<CoachPerformance> getPerformance({required String coachId}) async {
    throw UnimplementedError('Phase 8: getPerformance');
  }

  Future<CoachActionCounts> getActionCounts({required String coachId}) async {
    throw UnimplementedError('Phase 5: getActionCounts');
  }

  Future<List<CoachStudentRosterItem>> getAttentionList({required String coachId}) async {
    throw UnimplementedError('Phase 6: getAttentionList');
  }

  Future<Map<Sport, int>> getSportBreakdown({required String coachId}) async {
    throw UnimplementedError('Phase 7: getSportBreakdown');
  }
}
```

If `CoachStudentRosterItem` isn't the right type (Task 1.4 grep), substitute the correct model.

- [ ] **Step 2: Verify it analyzes**

Run: `flutter analyze lib/features/coach/data/api_coach_dashboard_repository.dart`
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/data/api_coach_dashboard_repository.dart
git commit -m "Coach dashboard: scaffold ApiCoachDashboardRepository"
```

---

### Task 5.2: `coachDashboardSummaryProvider` orchestrator

**Files:**
- Create: `lib/features/coach/providers/coach_dashboard_summary_provider.dart`
- Test: `test/features/coach/providers/coach_dashboard_summary_provider_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/api_coach_dashboard_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/providers/coach_dashboard_summary_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ApiCoachDashboardRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('aggregates all four sections on happy path', () async {
    when(() => repo.getPerformance(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachPerformance(
              earningsThisWeekCents: 0,
              earningsThisMonthCents: 100,
              sessionsThisWeek: 1,
              sessionsThisMonth: 4,
              activeStudentCount: 5,
            ));
    when(() => repo.getActionCounts(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachActionCounts(
              absencesUnmarked: 0,
              assessmentsUngraded: 0,
              studentsUngraded: 0,
            ));
    when(() => repo.getAttentionList(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <CoachStudentRosterItem>[]);
    when(() => repo.getSportBreakdown(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <Sport, int>{});

    final container = ProviderContainer(overrides: [
      apiCoachDashboardRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final summary = await container.read(coachDashboardSummaryProvider.future);
    expect(summary.performance.isSuccess, true);
    expect(summary.actions.isSuccess, true);
    expect(summary.attentionList.isSuccess, true);
    expect(summary.sportBreakdown.isSuccess, true);
  });

  test('one failing fetch does not poison the others', () async {
    when(() => repo.getPerformance(coachId: any(named: 'coachId')))
        .thenThrow(Exception('boom'));
    when(() => repo.getActionCounts(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachActionCounts(
              absencesUnmarked: 1,
              assessmentsUngraded: 2,
              studentsUngraded: 3,
            ));
    when(() => repo.getAttentionList(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <CoachStudentRosterItem>[]);
    when(() => repo.getSportBreakdown(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <Sport, int>{});

    final container = ProviderContainer(overrides: [
      apiCoachDashboardRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final summary = await container.read(coachDashboardSummaryProvider.future);
    expect(summary.performance.isFailure, true);
    expect(summary.actions.valueOrNull?.absencesUnmarked, 1);
  });
}
```

Note: this test uses `mocktail`. Add it to `dev_dependencies` in `pubspec.yaml` if not present, then `flutter pub get`.

```yaml
dev_dependencies:
  mocktail: ^1.0.4
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/providers/coach_dashboard_summary_provider_test.dart`
Expected: FAIL — file missing.

- [ ] **Step 3: Write the provider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_dashboard_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_dashboard_summary.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final apiCoachDashboardRepositoryProvider =
    Provider<ApiCoachDashboardRepository>(
        (ref) => ApiCoachDashboardRepository(ref.watch(apiClientProvider)));

Future<SectionResult<T>> _safe<T>(Future<T> Function() f) async {
  try {
    return SectionResult.success(await f());
  } catch (e, st) {
    return SectionResult.failure(e, st);
  }
}

final coachDashboardSummaryProvider =
    FutureProvider.autoDispose<CoachDashboardSummary>((ref) async {
  ref.keepAlive();
  final repo = ref.watch(apiCoachDashboardRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);

  final results = await Future.wait([
    _safe<CoachPerformance>(() => repo.getPerformance(coachId: coachId)),
    _safe<CoachActionCounts>(() => repo.getActionCounts(coachId: coachId)),
    _safe<List<CoachStudentRosterItem>>(() => repo.getAttentionList(coachId: coachId)),
    _safe<Map<Sport, int>>(() => repo.getSportBreakdown(coachId: coachId)),
  ]);

  final schedule = await ref.watch(coachScheduleProvider.future);
  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));
  final sessionsTomorrow = schedule
      .where((b) =>
          b.date.year == tomorrow.year &&
          b.date.month == tomorrow.month &&
          b.date.day == tomorrow.day)
      .length;

  return CoachDashboardSummary(
    performance: results[0] as SectionResult<CoachPerformance>,
    actions: results[1] as SectionResult<CoachActionCounts>,
    attentionList: results[2] as SectionResult<List<CoachStudentRosterItem>>,
    sportBreakdown: results[3] as SectionResult<Map<Sport, int>>,
    sessionsTomorrow: sessionsTomorrow,
  );
});
```

The `_safe` wrapper above is the partial-failure mechanism — each fetch resolves to a `SectionResult` so `Future.wait` never short-circuits.

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/providers/coach_dashboard_summary_provider_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Register provider in `_invalidateAllFeatureProviders`**

Edit `lib/features/auth/providers/auth_provider.dart`: in the `// ── Coach (role) ──` block of `_invalidateAllFeatureProviders`, add:

```dart
ref.invalidate(coachDashboardSummaryProvider);
```

Add the matching import at the top.

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/providers/coach_dashboard_summary_provider.dart test/features/coach/providers/coach_dashboard_summary_provider_test.dart lib/features/auth/providers/auth_provider.dart pubspec.yaml pubspec.lock
git commit -m "Coach dashboard: add summary provider with SectionResult partial-failure"
```

---

### Task 5.3: Implement `getActionCounts`

**Files:**
- Modify: `lib/features/coach/data/api_coach_dashboard_repository.dart`
- Test: extend `test/features/coach/providers/coach_dashboard_summary_provider_test.dart` (already covers via mock)

Per Scope Clarification #1, no BE endpoint exists yet. This task derives counts client-side using the existing API repos.

- [ ] **Step 1: Check the BE endpoint first**

```bash
grep -rn "coach.*summary\|coach.*stats" lib/features/coach/data/ lib/core/config/api_endpoints.dart
```

If a real summary endpoint shows up, prefer it. Otherwise continue.

- [ ] **Step 2: Replace `getActionCounts` body**

```dart
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
// ... existing imports

class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._dio, this._sessions);
  final Dio _dio;
  final ApiCoachSessionRepository _sessions;

  Future<CoachActionCounts> getActionCounts({required String coachId}) async {
    // Pull a wide enough recent window. The list endpoint paginates; for
    // counts we only need the first page that covers "needs action" cases —
    // attendance not yet marked or assessment not yet recorded for a
    // completed session. If the endpoint returns more than one page in the
    // typical action backlog, raise `page` or call `getSessions` until
    // `currentPage >= lastPage` (capped at, say, 5 pages defensively).
    final page = await _sessions.getSessions();
    final absences = page.items
        .where((s) => s.attendanceCount == 0 && s.status == 'ongoing')
        .length;
    final ungraded = page.items
        .where((s) => s.status == 'completed' && s.hasAssessment == false)
        .length;
    // studentsUngraded comes from the attention list endpoint in Task 6.x.
    // Until then, derive from the same page heuristic: students appearing
    // in completed sessions without any recorded assessment.
    final studentsUngraded = page.items
        .where((s) => s.hasAssessment == false)
        .map((s) => s.studentProfileIds)
        .expand((ids) => ids)
        .toSet()
        .length;
    return CoachActionCounts(
      absencesUnmarked: absences,
      assessmentsUngraded: ungraded,
      studentsUngraded: studentsUngraded,
    );
  }
  // ... other methods unchanged
}
```

If `CoachSession` does not expose `attendanceCount`, `hasAssessment`, or `studentProfileIds`, inspect `lib/features/coach/data/models/coach_session.dart` and adapt to whichever fields it does have. The semantic intent is: count "needs action" cases.

- [ ] **Step 3: Update the provider constructor**

In `coach_dashboard_summary_provider.dart`, change `apiCoachDashboardRepositoryProvider`:

```dart
final apiCoachDashboardRepositoryProvider =
    Provider<ApiCoachDashboardRepository>((ref) {
  return ApiCoachDashboardRepository(
    ref.watch(apiClientProvider),
    ref.watch(coachSessionRepoProvider),
  );
});
```

Add: `import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';`

- [ ] **Step 4: Run summary provider test**

Run: `flutter test test/features/coach/providers/coach_dashboard_summary_provider_test.dart`
Expected: PASS — the existing tests mock the repo and so do not regress on the implementation swap.

- [ ] **Step 5: Commit**

```bash
git add lib/features/coach/data/api_coach_dashboard_repository.dart lib/features/coach/providers/coach_dashboard_summary_provider.dart
git commit -m "Coach dashboard: derive action counts from existing session list"
```

---

### Task 5.4: Build `CoachDashboardActionItems`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart';

void main() {
  testWidgets('renders SizedBox.shrink when all counts are zero', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult.success(CoachActionCounts(
              absencesUnmarked: 0,
              assessmentsUngraded: 0,
              studentsUngraded: 0,
            )),
          ),
        ),
      ),
    );
    expect(find.byType(SizedBox), findsAtLeast(1));
    expect(find.textContaining('absensi'), findsNothing);
  });

  testWidgets('renders rows for nonzero counts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult.success(CoachActionCounts(
              absencesUnmarked: 3,
              assessmentsUngraded: 2,
              studentsUngraded: 4,
            )),
          ),
        ),
      ),
    );
    expect(find.textContaining('3'), findsOneWidget);
    expect(find.textContaining('2'), findsOneWidget);
    expect(find.textContaining('4'), findsOneWidget);
  });

  testWidgets('renders inline retry on SectionResult.failure', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult<CoachActionCounts>.failure(
              Exception('x'),
              null,
            ),
            onRetry: () {},
          ),
        ),
      ),
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items_test.dart`
Expected: FAIL — file missing.

- [ ] **Step 3: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';

class CoachDashboardActionItems extends StatelessWidget {
  const CoachDashboardActionItems({
    super.key,
    required this.result,
    this.onRetry,
  });

  final SectionResult<CoachActionCounts> result;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SectionFailure() => _RetryBanner(onRetry: onRetry),
      SectionSuccess(:final value) when _allZero(value) => const SizedBox.shrink(),
      SectionSuccess(:final value) => _Card(counts: value),
    };
  }

  static bool _allZero(CoachActionCounts c) =>
      c.absencesUnmarked == 0 &&
      c.assessmentsUngraded == 0 &&
      c.studentsUngraded == 0;
}

class _Card extends StatelessWidget {
  const _Card({required this.counts});
  final CoachActionCounts counts;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (counts.absencesUnmarked > 0) {
      rows.add(_Row(
        icon: Icons.warning_amber_rounded,
        count: counts.absencesUnmarked,
        label: 'absensi belum di-mark',
        onTap: () => context.go('/coach/schedule?filter=unmarked'),
      ));
    }
    if (counts.assessmentsUngraded > 0) {
      rows.add(_Row(
        icon: Icons.assignment_late_outlined,
        count: counts.assessmentsUngraded,
        label: 'penilaian sesi belum diisi',
        onTap: () => context.go('/coach/schedule?filter=ungraded'),
      ));
    }
    if (counts.studentsUngraded > 0) {
      rows.add(_Row(
        icon: Icons.person_search,
        count: counts.studentsUngraded,
        label: 'murid belum dinilai',
        onTap: () => context.go('/coach/students?filter=ungraded'),
      ));
    }
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
        border: const Border(
          left: BorderSide(color: AppColors.warning, width: 4),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.count,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final int count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Row(
          children: [
            Icon(icon, color: AppColors.warning),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '$count ',
                  style: AppTypography.titleSmall,
                  children: [
                    TextSpan(text: label, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _RetryBanner extends StatelessWidget {
  const _RetryBanner({this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger),
          const SizedBox(width: AppDimensions.sm),
          const Expanded(child: Text('Gagal memuat item perhatian')),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
```

If `AppColors.warning` / `AppColors.danger` are named differently, use whatever your theme defines. The names are illustrative.

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Wire into screen**

Edit `lib/features/coach/presentation/screens/coach_dashboard_screen.dart`:

1. Add import for `coach_dashboard_action_items.dart` and for `coach_dashboard_summary_provider.dart`.
2. Convert the screen so it watches `coachDashboardSummaryProvider`.
3. Insert `CoachDashboardActionItems` immediately after the greeting block.

The relevant change:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final summaryAsync = ref.watch(coachDashboardSummaryProvider);
  return Scaffold(
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),
              const CoachDashboardGreeting(),
              const SizedBox(height: AppDimensions.xl),
              summaryAsync.when(
                data: (s) => CoachDashboardActionItems(
                  result: s.actions,
                  onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
                ),
                loading: () => const SizedBox(height: 60),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppDimensions.xl),
              const _QuickStatsRow(),
              // ... rest unchanged
            ],
          ),
        ),
      ),
    ),
  );
}
```

Update `_refresh` to also invalidate the new provider:

```dart
Future<void> _refresh(WidgetRef ref) async {
  ref.invalidate(coachDashboardSummaryProvider);
  ref.invalidate(coachScheduleProvider);
  ref.invalidate(assessmentListProvider);
}
```

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items_test.dart
git commit -m "Coach dashboard: add ActionItems banner driven by summary provider"
```

---

## Phase 6 — Attention List

### Task 6.1: Implement `getAttentionList`

**Files:**
- Modify: `lib/features/coach/data/api_coach_dashboard_repository.dart`

Approach: load the coach's students from `ApiCoachEnrollmentRepository` (or whichever existing endpoint returns the student list), filter to those with zero assessments, take 5.

- [ ] **Step 1: Inspect available student endpoints**

```bash
grep -rn "getStudents\|students/list\|getAttention" lib/features/coach/data/
```

Pick the one that yields a list with assessment counts (or that needs a follow-up call per student to check `assessments.isEmpty`). Document the choice in the repo method's doc comment.

- [ ] **Step 2: Add the enrollment repo to the constructor and implement the method**

The `CoachStudentRosterItem` model exposes `latestProgress` (the most recent recorded session progress). `latestProgress == null` is the canonical "never been assessed" signal — that is the "perlu perhatian" criterion from spec §4.7.

Update the class header in `lib/features/coach/data/api_coach_dashboard_repository.dart`:

```dart
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_enrollment_repository.dart';
// ... existing imports

class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._dio, this._sessions, this._students);
  final Dio _dio;
  final ApiCoachSessionRepository _sessions;
  final ApiCoachEnrollmentRepository _students;
  // ...
}
```

Replace the `getAttentionList` body:

```dart
Future<List<CoachStudentRosterItem>> getAttentionList({required String coachId}) async {
  final roster = await _students.getCoachStudents();
  return roster.where((s) => s.latestProgress == null).take(5).toList();
}
```

If `ApiCoachEnrollmentRepository` does not yet expose `getCoachStudents()`, locate the existing roster fetch path (`grep -rn "v1/coach/students" lib/features/coach/`) and either reuse that method or add a thin wrapper around the same endpoint. The repo's role here is purely "fetch the roster"; the filter happens client-side.

- [ ] **Step 3: Update repository constructor + provider**

In `coach_dashboard_summary_provider.dart`:

```dart
final apiCoachDashboardRepositoryProvider =
    Provider<ApiCoachDashboardRepository>((ref) {
  return ApiCoachDashboardRepository(
    ref.watch(apiClientProvider),
    ref.watch(coachSessionRepoProvider),
    ref.watch(coachEnrollmentRepoProvider),
  );
});
```

- [ ] **Step 4: Run existing summary tests**

Run: `flutter test test/features/coach/providers/coach_dashboard_summary_provider_test.dart`
Expected: PASS (existing mocks unchanged).

- [ ] **Step 5: Commit**

```bash
git add lib/features/coach/data/api_coach_dashboard_repository.dart lib/features/coach/providers/coach_dashboard_summary_provider.dart
git commit -m "Coach dashboard: derive attention list from existing student endpoint"
```

---

### Task 6.2: Build `CoachDashboardAttentionList`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart';

void main() {
  testWidgets('positive empty when zero ungraded', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success(<CoachStudentRosterItem>[]),
          ),
        ),
      ),
    );
    expect(find.text('Semua murid sudah dinilai'), findsOneWidget);
  });

  testWidgets('renders up to 5 items', (tester) async {
    final students = List.generate(
      7,
      (i) => CoachStudentRosterItem(
        studentProfileId: 'id-$i',
        fullName: 'Student $i',
        totalSessionsWithCoach: 0,
        attendanceRate: 0.0,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success(students),
          ),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      expect(find.text('Student $i'), findsOneWidget);
    }
    expect(find.text('Student 5'), findsNothing);
  });
}
```

`CoachStudentRosterItem` lives in `lib/features/club/data/models/coach_student.dart` and is the type returned by `GET /v1/coach/students` (Issue 19.1). Required fields: `studentProfileId`, `fullName`, `totalSessionsWithCoach`, `attendanceRate`. Optional: `age`, `photoUrls`, `enrollment`, `lastSessionAt`, `latestProgress`.

- [ ] **Step 2: Confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list_test.dart`
Expected: FAIL.

- [ ] **Step 3: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';

class CoachDashboardAttentionList extends StatelessWidget {
  const CoachDashboardAttentionList({
    super.key,
    required this.result,
    this.onRetry,
  });

  final SectionResult<List<CoachStudentRosterItem>> result;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perlu Perhatian', style: AppTypography.titleMedium),
        Text('Murid belum dinilai',
            style: AppTypography.bodySmall),
        const SizedBox(height: AppDimensions.md),
        switch (result) {
          SectionFailure() => _retry(),
          SectionSuccess(:final value) when value.isEmpty => const EmptyState(
              icon: Icons.check_circle_outline,
              message: 'Semua murid sudah dinilai',
            ),
          SectionSuccess(:final value) => Column(
              children: value
                  .take(5)
                  .map((s) => _StudentRow(student: s))
                  .toList(),
            ),
        },
      ],
    );
  }

  Widget _retry() => Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Row(
          children: [
            const Expanded(child: Text('Gagal memuat')),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student});
  final CoachStudentRosterItem student;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/coach/students/${student.studentProfileId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Row(
          children: [
            CircleAvatar(child: Text(student.fullName.characters.first)),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(student.fullName, style: AppTypography.bodyMedium),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list_test.dart`
Expected: PASS.

- [ ] **Step 5: Wire into screen**

In `coach_dashboard_screen.dart`, after `CoachDashboardRecentAssessments`:

```dart
summaryAsync.when(
  data: (s) => CoachDashboardAttentionList(
    result: s.attentionList,
    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
  ),
  loading: () => const SizedBox(height: 60),
  error: (_, __) => const SizedBox.shrink(),
),
const SizedBox(height: AppDimensions.xl),
```

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list_test.dart
git commit -m "Coach dashboard: add AttentionList section"
```

---

## Phase 7 — Sport Breakdown

### Task 7.1: Implement `getSportBreakdown`

**Files:**
- Modify: `lib/features/coach/data/api_coach_dashboard_repository.dart`

`CoachStudentRosterItem` does not carry a `sport` field, so the breakdown derives from `CoachSession` (which does identify the sport per session) by deduping unique students per sport seen in the last 90 days.

- [ ] **Step 1: Replace the method**

```dart
Future<Map<Sport, int>> getSportBreakdown({required String coachId}) async {
  final page = await _sessions.getSessions();
  final cutoff = DateTime.now().subtract(const Duration(days: 90));
  final studentsBySport = <Sport, Set<String>>{};
  for (final s in page.items) {
    if (s.startsAt.isBefore(cutoff)) continue;
    final bucket = studentsBySport.putIfAbsent(s.sport, () => <String>{});
    bucket.addAll(s.studentProfileIds.map((id) => id.toString()));
  }
  return {
    for (final entry in studentsBySport.entries) entry.key: entry.value.length,
  };
}
```

If `CoachSession` does not expose `sport` or `studentProfileIds` under these exact names, inspect `lib/features/coach/data/models/coach_session.dart` and adapt. The semantic intent is: count unique students seen per sport in the last 90 days.

- [ ] **Step 2: Commit**

```bash
git add lib/features/coach/data/api_coach_dashboard_repository.dart
git commit -m "Coach dashboard: derive sport breakdown from session participation"
```

---

### Task 7.2: Build `CoachDashboardSportBreakdown`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart';

void main() {
  testWidgets('section hidden when empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardSportBreakdown(
            result: SectionResult.success(<Sport, int>{}),
          ),
        ),
      ),
    );
    expect(find.text('Distribusi Murid'), findsNothing);
  });

  testWidgets('renders distribution when populated', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardSportBreakdown(
            result: SectionResult.success(<Sport, int>{
              Sport.tennis: 4,
              Sport.padel: 2,
            }),
          ),
        ),
      ),
    );
    expect(find.text('Distribusi Murid'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown_test.dart`
Expected: FAIL.

- [ ] **Step 3: Write the widget**

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';

class CoachDashboardSportBreakdown extends StatelessWidget {
  const CoachDashboardSportBreakdown({super.key, required this.result});
  final SectionResult<Map<Sport, int>> result;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SectionFailure() => const SizedBox.shrink(),
      SectionSuccess(:final value) when value.isEmpty => const SizedBox.shrink(),
      SectionSuccess(:final value) => _Chart(data: value),
    };
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.data});
  final Map<Sport, int> data;

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();
    final sections = data.entries
        .map((e) => PieChartSectionData(
              value: e.value.toDouble(),
              title: '${e.value}',
              radius: 50,
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distribusi Murid', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.md),
        SizedBox(
          height: 180,
          child: PieChart(PieChartData(sections: sections, sectionsSpace: 2)),
        ),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.xs,
          children: data.entries
              .map((e) => Chip(
                    label: Text(
                        '${SportChipSelector.sportLabel(e.key)}: ${e.value}'),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown_test.dart`
Expected: PASS.

- [ ] **Step 5: Wire into screen**

In `coach_dashboard_screen.dart`, after `CoachDashboardAttentionList`:

```dart
summaryAsync.when(
  data: (s) => CoachDashboardSportBreakdown(result: s.sportBreakdown),
  loading: () => const SizedBox.shrink(),
  error: (_, __) => const SizedBox.shrink(),
),
const SizedBox(height: AppDimensions.xxl),
```

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown_test.dart
git commit -m "Coach dashboard: add SportBreakdown pie chart section"
```

---

## Phase 8 — Performance widget (replaces `_QuickStatsRow`)

### Task 8.1: Implement `getPerformance`

**Files:**
- Modify: `lib/features/coach/data/api_coach_dashboard_repository.dart`

- [ ] **Step 1: Replace the method**

```dart
Future<CoachPerformance> getPerformance({required String coachId}) async {
  final page = await _sessions.getSessions();
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final monthStart = DateTime(now.year, now.month, 1);
  final last30 = now.subtract(const Duration(days: 30));

  int sessionsWeek = 0;
  int sessionsMonth = 0;
  int earningsWeekCents = 0;
  int earningsMonthCents = 0;
  final activeStudents = <String>{};

  for (final s in page.items) {
    if (s.status != 'completed') continue;
    if (s.startsAt.isAfter(weekStart)) {
      sessionsWeek += 1;
      earningsWeekCents += s.coachPayoutCents ?? 0;
    }
    if (s.startsAt.isAfter(monthStart)) {
      sessionsMonth += 1;
      earningsMonthCents += s.coachPayoutCents ?? 0;
    }
    if (s.startsAt.isAfter(last30)) {
      activeStudents.addAll(s.studentProfileIds.map((id) => id.toString()));
    }
  }

  return CoachPerformance(
    earningsThisWeekCents: earningsWeekCents,
    earningsThisMonthCents: earningsMonthCents,
    sessionsThisWeek: sessionsWeek,
    sessionsThisMonth: sessionsMonth,
    activeStudentCount: activeStudents.length,
  );
}
```

Substitute the correct `CoachSession` field names. If `coachPayoutCents` is not exposed, earnings stay 0 — the widget will show `Rp 0` until BE adds the payout breakdown.

- [ ] **Step 2: Commit**

```bash
git add lib/features/coach/data/api_coach_dashboard_repository.dart
git commit -m "Coach dashboard: derive performance metrics from session list"
```

---

### Task 8.2: Build `CoachDashboardPerformance`

**Files:**
- Create: `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart`
- Test: `test/features/coach/presentation/widgets/dashboard/coach_dashboard_performance_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart';

void main() {
  testWidgets('renders three metric cards', (tester) async {
    const perf = CoachPerformance(
      earningsThisWeekCents: 0,
      earningsThisMonthCents: 500000,
      sessionsThisWeek: 3,
      sessionsThisMonth: 12,
      activeStudentCount: 8,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tenantCurrencyProvider.overrideWithValue('IDR')],
        child: const MaterialApp(
          home: Scaffold(
            body: CoachDashboardPerformance(
              result: SectionResult.success(perf),
              sportCount: 2,
            ),
          ),
        ),
      ),
    );
    expect(find.textContaining('3'), findsWidgets);
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Sesi'), findsOneWidget);
    expect(find.text('Murid Aktif'), findsOneWidget);
  });

  testWidgets('inline retry on failure', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardPerformance(
            result: SectionResult<CoachPerformance>.failure(Exception('x'), null),
            sportCount: 0,
            onRetry: () {},
          ),
        ),
      ),
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Confirm failure**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_performance_test.dart`
Expected: FAIL.

- [ ] **Step 3: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

class CoachDashboardPerformance extends ConsumerWidget {
  const CoachDashboardPerformance({
    super.key,
    required this.result,
    required this.sportCount,
    this.onRetry,
  });
  final SectionResult<CoachPerformance> result;
  final int sportCount;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    return switch (result) {
      SectionFailure() => _retry(),
      SectionSuccess(:final value) => Row(
          children: [
            Expanded(child: _Card(
              label: 'Earnings',
              value: Formatters.formatCurrency(value.earningsThisMonthCents, currency),
              sub: '${value.sessionsThisMonth} sesi bulan ini',
            )),
            const SizedBox(width: AppDimensions.sm),
            Expanded(child: _Card(
              label: 'Sesi',
              value: '${value.sessionsThisWeek}',
              sub: '${value.sessionsThisMonth} bulan ini',
            )),
            const SizedBox(width: AppDimensions.sm),
            Expanded(child: _Card(
              label: 'Murid Aktif',
              value: '${value.activeStudentCount}',
              sub: '$sportCount sport',
            )),
          ],
        ),
    };
  }

  Widget _retry() => Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Row(
          children: [
            const Expanded(child: Text('Gagal memuat performa')),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.label, required this.value, required this.sub});
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: AppDimensions.xs),
          Text(value, style: AppTypography.numberMedium),
          const SizedBox(height: AppDimensions.xxs),
          Text(sub, style: AppTypography.caption
              .copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
```

`Formatters.formatCurrency(int amount, String currency)` is verified to exist in `lib/core/utils/formatters.dart`. IDR uses whole rupiah, MYR uses cents — the formatter handles the multiplier internally.

- [ ] **Step 4: Run test**

Run: `flutter test test/features/coach/presentation/widgets/dashboard/coach_dashboard_performance_test.dart`
Expected: PASS.

- [ ] **Step 5: Replace `_QuickStatsRow` in screen**

In `coach_dashboard_screen.dart`:
1. Delete the `_QuickStatsRow` and `_StatCard` classes.
2. Remove the now-unused theme imports.
3. Replace `const _QuickStatsRow()` with:

```dart
summaryAsync.when(
  data: (s) => CoachDashboardPerformance(
    result: s.performance,
    sportCount: s.sportBreakdown.valueOrNull?.length ?? 0,
    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
  ),
  loading: () => const SizedBox(height: 100),
  error: (_, __) => const SizedBox.shrink(),
),
```

- [ ] **Step 6: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart lib/features/coach/presentation/screens/coach_dashboard_screen.dart test/features/coach/presentation/widgets/dashboard/coach_dashboard_performance_test.dart
git commit -m "Coach dashboard: replace hardcoded stats with CoachDashboardPerformance"
```

---

## Phase 9 — Smoke integration test

### Task 9.1: Happy-path integration test

**Files:**
- Create: `integration_test/coach_dashboard_happy_path_test.dart`

- [ ] **Step 1: Check existing integration test infra**

```bash
ls integration_test/ 2>&1 || echo 'no integration_test dir'
grep -n "integration_test" pubspec.yaml
```

If `integration_test` is not configured as a dev-dep, add:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

Then `flutter pub get`.

- [ ] **Step 2: Write the test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_dashboard_summary.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_dashboard_screen.dart';
import 'package:hyperarena/features/coach/providers/coach_dashboard_summary_provider.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._u);
  final User? _u;
  @override
  User? build() => _u;
}

void main() {
  testWidgets('coach dashboard renders all sections and refreshes', (tester) async {
    const user = User(
      id: 'u1',
      name: 'Coach Andi',
      email: 'a@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );

    final summary = CoachDashboardSummary(
      performance: const SectionResult.success(CoachPerformance(
        earningsThisWeekCents: 0,
        earningsThisMonthCents: 1000000,
        sessionsThisWeek: 3,
        sessionsThisMonth: 12,
        activeStudentCount: 8,
      )),
      actions: const SectionResult.success(CoachActionCounts(
        absencesUnmarked: 1, assessmentsUngraded: 2, studentsUngraded: 4,
      )),
      attentionList: const SectionResult.success([
        CoachStudentRosterItem(
          studentProfileId: 's1',
          fullName: 'Anna',
          totalSessionsWithCoach: 0,
          attendanceRate: 0.0,
        ),
        CoachStudentRosterItem(
          studentProfileId: 's2',
          fullName: 'Bobi',
          totalSessionsWithCoach: 0,
          attendanceRate: 0.0,
        ),
      ]),
      sportBreakdown: const SectionResult.success({Sport.tennis: 5, Sport.padel: 3}),
      sessionsTomorrow: 2,
    );

    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const CoachDashboardScreen()),
      GoRoute(path: '/coach/students/:id', builder: (_, __) => const Scaffold()),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith(() => _StubAuth(user)),
        coachDashboardSummaryProvider.overrideWith((ref) async => summary),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();

    expect(find.text('MODE COACH'), findsOneWidget);
    expect(find.textContaining('Coach Andi'), findsOneWidget);
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Perlu Perhatian'), findsOneWidget);
    expect(find.text('Distribusi Murid'), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run**

Run: `flutter test integration_test/coach_dashboard_happy_path_test.dart`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add integration_test/coach_dashboard_happy_path_test.dart pubspec.yaml pubspec.lock
git commit -m "Coach dashboard: happy-path integration test"
```

---

## Final Verification

- [ ] Run full suite: `flutter test`
- [ ] Run analyzer: `flutter analyze`
- [ ] Manually launch the app on emulator, log in as coach, verify each section renders + pull-to-refresh works.
- [ ] If anything fails, fix in a follow-up commit; do not bypass.
