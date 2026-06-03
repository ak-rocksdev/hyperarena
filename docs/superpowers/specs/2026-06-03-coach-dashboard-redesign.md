# Coach Dashboard Redesign — Design Spec

**Date:** 2026-06-03
**Status:** Draft (awaiting user approval)
**Scope:** Flutter app (`lib/features/coach/presentation/screens/coach_dashboard_screen.dart`)

---

## 1. Problem & Goal

### Current state

The coach dashboard at `coach_dashboard_screen.dart` is a 450-line single file with four sections: greeting, hardcoded quick stats (`120 / 8 / 4.8`), today's schedule, and recent assessments. It uses `MockCoachRepository` even though the sibling Schedule tab uses a real API (`ApiCoachSessionRepository`). The provider passes a hardcoded `coachId = 'coach-001'` rather than reading from `authNotifierProvider`. Empty states are plain centered text — inconsistent with the app-wide `EmptyState` widget used in 18 other screens. There is no visual indicator of the active role, even though the auth model supports multi-role (`user.availableRoles`).

### Goal

Turn the dashboard into a **command center** that, in a single scroll, lets a coach quickly understand:
1. **What they need to do today** (operational layer)
2. **How they are performing** (performance layer)
3. **Which students need follow-up** (student layer)

And makes it instantly obvious that the current role context is **Coach**.

---

## 2. Persona & Frame

| Decision | Value |
|---|---|
| **Coach persona** | Hybrid — one coach can run both club sessions and marketplace bookings. Dashboard surfaces both sources. |
| **Primary frame** | Mixed: operational first, then performance, then student. |
| **Earnings scope** | **Club only.** Marketplace coach monetization is not live yet; marketplace bookings are read-only in the schedule. |
| **Rating / reviews** | Not surfaced. Consistent with the existing design rule that coaches do not see student reviews (current file, lines 179-181). |
| **i18n** | Indonesian-only (matches Flutter app convention). No translation layer added. |

---

## 3. Layout

Single-column vertical scroll. Section order is fixed and matches user priority.

```
┌─────────────────────────────────────┐
│ [● MODE COACH]              🔔     │  ← Role pill + notification bell
│ Selamat Pagi, Budi!                │
│ Kelola jadwal dan murid Anda       │
├─────────────────────────────────────┤
│ Action Items (banner)               │  ← Hidden when all counts = 0
│  ⚠ 3 absensi belum di-mark         │
│  📝 2 penilaian sesi belum diisi   │
│  👥 4 murid belum dinilai          │
├─────────────────────────────────────┤
│ Jadwal Hari Ini                    │
│   [_ScheduleCard × N]              │
│   Besok: 3 sesi                    │
├─────────────────────────────────────┤
│ Performance                         │
│ ┌────────┬────────┬────────────┐   │
│ │Earnings│ Sesi   │Murid Aktif │   │
│ │ Bulan  │ Minggu │            │   │
│ └────────┴────────┴────────────┘   │
├─────────────────────────────────────┤
│ Penilaian Terbaru     Lihat Semua →│
│   [_AssessmentCard × 3]            │
├─────────────────────────────────────┤
│ Perlu Perhatian                     │
│   [student row × ≤5]               │
├─────────────────────────────────────┤
│ Distribusi Murid per Sport          │  ← Hidden when 0 students
│   [chart]                          │
└─────────────────────────────────────┘
```

Wrapped in `RefreshIndicator` for pull-to-refresh.

---

## 4. Component Specifications

All section widgets live in `lib/features/coach/presentation/widgets/dashboard/`. Each file owns one section. Cards within sections (`_ScheduleCard`, `_AssessmentCard`) are reused from the current file as-is.

### 4.1 `CoachDashboardGreeting`

- **Input**: `User?` via `authNotifierProvider`.
- **Render**: a row containing the role pill (left) and `NotificationBell` (right), then the greeting line, then the tagline.
- **Greeting line**: existing dynamic logic — "Selamat Pagi/Siang/Sore/Malam, {firstName}!", fallback "Coach" when name is null.

### 4.2 `CoachRolePill`

- **Visual**: rounded pill (~28px height), tight padding, role-specific accent color, leading dot indicator + sport/whistle icon, label `MODE COACH` in `AppTypography.badge` uppercase.
- **Behavior**:
  - If `user.availableRoles.length > 1`: trailing chevron, tap navigates to `/profile` where the existing `RoleSwitchSection` is rendered.
  - Else: no chevron, non-interactive.
- **Color**: prefer an existing token in `app_colors.dart`; if none fits, add one `coachAccent` token (single addition, no theme refactor).
- **Reusable**: the widget accepts a `role` parameter and a label/icon mapping so the same pattern can later be applied to other role dashboards. That extension is out of scope for this task — only the coach instance ships now.

### 4.3 `CoachDashboardActionItems` *(new)*

- **Input**: `SectionResult<CoachActionCounts>` (selected from `coachDashboardSummaryProvider.actions`).
- **Render rules**:
  - `SectionResult.failure` → inline retry chip (does not blank the section).
  - `SectionResult.success` with all three counts = 0 → `SizedBox.shrink()` (section hidden, no empty state).
  - `SectionResult.success` with any nonzero count → card surface with warning-accent left border, one row per nonzero count: `icon + count + label + chevron`. Rows separated by hairline divider.
- **Tap targets** (routes committed by this spec; if the target screen does not yet support the query param, implementation adds it):
  - Absensi pending → `/coach/schedule?filter=unmarked` (filter expression: `status=ongoing AND attendance=null`).
  - Penilaian sesi pending → `/coach/schedule?filter=ungraded` (filter expression: `status=completed AND assessment=null`).
  - Murid belum dinilai → `/coach/students?filter=ungraded`.

### 4.4 `CoachDashboardTodaySchedule`

- **Input**: `AsyncValue<List<CoachingBooking>>` from `coachScheduleProvider` (existing, with `coachId` fix — see §5).
- **Render**: title "Jadwal Hari Ini" → list of `_ScheduleCard` (existing widget, reused) for bookings whose date matches today → footer hint "Besok: X sesi" when `sessionsTomorrow > 0`.
- **Empty state**: `EmptyState(icon: Icons.event_available, message: 'Tidak ada jadwal hari ini')`.
- **Loading**: `AsyncValueWidget` default shimmer (3 cards).
- **Error**: `AsyncValueWidget` default error block.

### 4.5 `CoachDashboardPerformance`

- **Input**: `SectionResult<CoachPerformance>` (selected from `coachDashboardSummaryProvider.performance`).
- **Render**: three equal-width cards in a row. Headline number + sub-text per card. On `SectionResult.failure`, render inline retry banner inside the section (dashboard not blocked).
  - **Earnings (bulan ini)**: headline = `earningsThisMonthCents` via `Formatters.currency` (tenant currency); sub-text = `"{sessionsThisMonth} sesi bulan ini"`. Both month-scoped — no week/month mix.
  - **Sesi (minggu ini)**: headline = `sessionsThisWeek`; sub-text = `"{sessionsThisMonth} bulan ini"`. Week is the primary glance, month is the secondary context.
  - **Murid Aktif**: headline = `activeStudentCount`; sub-text = `"{sportCount} sport"` where `sportCount = sportBreakdown.keys.length`.
- **Definition of "active student"**: a unique student who appears in this coach's sessions or bookings within the last 30 days (any status). Computed by the BE summary endpoint or, if absent, by client-side dedup on the session/booking lists.
- **Loading**: custom 3-card shimmer (do not reuse `AsyncValueWidget` shimmer here — that one is single-card vertical).
- **Error**: inline retry banner inside the section. Does not blank the dashboard.
- **Empty**: `EmptyState(icon: Icons.bar_chart, message: 'Belum ada data minggu ini')` if all counts are zero.

### 4.6 `CoachDashboardRecentAssessments`

- **Input**: `AsyncValue<List<Assessment>>` from `assessmentListProvider` (existing, with `coachId` fix).
- **Render**: header row with title + "Lihat Semua" → top-3 assessments sorted by date desc → `_AssessmentCard` (existing widget, reused).
- **Empty**: `EmptyState(icon: Icons.assignment, message: 'Belum ada penilaian', actionLabel: 'Buat Penilaian', onAction: → /coach/students)`.
- **"Lihat Semua"** still navigates to `/coach/students` (unchanged).

### 4.7 `CoachDashboardAttentionList` *(new)*

- **Input**: `SectionResult<List<Student>>` (selected from `coachDashboardSummaryProvider.attentionList`). The provider caps the list at 5 — the widget does not need to slice further.
- **Definition of "perlu perhatian"**: a student who has **zero assessments** to date. (No date/threshold criteria. Single rule.)
- **Render**: header "Perlu Perhatian" with subtitle "Murid belum dinilai" → up to 5 compact rows: avatar + name + sport pill + chevron.
- **Tap row** → `/coach/students/{id}` (existing route; the student detail screen is where the coach can start the assessment flow).
- **Empty (positive)**: `EmptyState(icon: Icons.check_circle, message: 'Semua murid sudah dinilai')`.

### 4.8 `CoachDashboardSportBreakdown` *(new)*

- **Input**: `SectionResult<Map<Sport, int>>` (selected from `coachDashboardSummaryProvider.sportBreakdown`).
- **Render**: a simple horizontal stacked bar or donut showing student count per sport. Built with a `CustomPainter` or a chart library already in `pubspec.yaml` — **do not add a new dependency** for this section.
- **Hidden when** the map is empty or sums to 0 (coach has no students at all).
- **No empty state UI** — the section disappears.

---

## 5. Data Flow

### Provider tree

```
authNotifierProvider                    →  User
   ↓
coachIdProvider (new)                   →  String   (throws if user/role missing)
   ↓
coachRepositoryProvider                 →  ApiCoachRepository  (was MockCoachRepository)
   ↓
coachDashboardSummaryProvider (new)     →  FutureProvider<CoachDashboardSummary>
   parallel fetch — each sub-call wrapped in Result<T>, then combined
   (see "Partial failure" below — no Future.wait strict-fail):
     • performance
     • action counts
     • attention list
     • sport breakdown
     • sessions tomorrow

coachScheduleProvider     (existing — coachId fix)
assessmentListProvider    (existing — coachId fix)
```

### Data shapes (Freezed)

The summary holds a `SectionResult<T>` per section so a single fetch failure does not invalidate the whole dashboard. The provider itself always succeeds with the summary; widgets read the section's `SectionResult` and render data, loading, or section-error inline.

```dart
// Lightweight per-section result. Implementation can use sealed class or
// dartz Either — choose whichever matches existing conventions.
@freezed
sealed class SectionResult<T> with _$SectionResult<T> {
  const factory SectionResult.success(T value) = _Success<T>;
  const factory SectionResult.failure(Object error, StackTrace? stackTrace) = _Failure<T>;
}

@freezed
class CoachDashboardSummary with _$CoachDashboardSummary {
  const factory CoachDashboardSummary({
    required SectionResult<CoachPerformance> performance,
    required SectionResult<CoachActionCounts> actions,
    required SectionResult<List<Student>> attentionList,     // ≤ 5
    required SectionResult<Map<Sport, int>> sportBreakdown,
    required int sessionsTomorrow,   // derived from coachScheduleProvider, no separate fetch
  }) = _CoachDashboardSummary;
}

@freezed
class CoachPerformance with _$CoachPerformance {
  const factory CoachPerformance({
    required int earningsThisWeekCents,   // club only
    required int earningsThisMonthCents,  // club only
    required int sessionsThisWeek,
    required int sessionsThisMonth,
    required int activeStudentCount,
  }) = _CoachPerformance;
}

@freezed
class CoachActionCounts with _$CoachActionCounts {
  const factory CoachActionCounts({
    required int absencesUnmarked,
    required int assessmentsUngraded,
    required int studentsUngraded,
  }) = _CoachActionCounts;
}
```

### Backend endpoints

The dashboard ships using **only existing list endpoints**. Any aggregation/derivation happens client-side. Adding dedicated summary endpoints is an out-of-scope BE follow-up (§9) — purely a performance optimization, not a blocker.

| Section | Source | How |
|---|---|---|
| Today schedule | `GET /v1/coach/sessions?date=today` (exists, `ApiCoachSessionRepository`) | direct list |
| Sessions tomorrow (count) | reuses `coachScheduleProvider` data | client-side filter on date |
| Performance | existing coach session + enrollment endpoints | client-side aggregate: sum completed sessions in week/month, sum payouts from `coach_rates × completed_sessions`, dedup students in last 30 days |
| Action counts | derived | client-side: count sessions with `attendance=null` (absences), count completed sessions with no assessment (ungraded), count students with zero assessments (studentsUngraded) |
| Attention list | existing students endpoint | client-side filter `assessments.isEmpty`, take 5 |
| Sport breakdown | existing students endpoint | client-side `groupBy(sport).count()` |
| Recent assessments | existing assessments endpoint | already wired |

If the BE team later ships `GET /v1/coach/me/summary` and `GET /v1/coach/students/sport-breakdown`, the repository methods swap to use them — the widget contracts do not change.

### Mandatory fixes

1. Replace hardcoded `'coach-001'` in `coach_schedule_provider.dart` and `assessment_provider.dart` with `ref.watch(coachIdProvider)`.
2. Switch `coachRepositoryProvider` from `MockCoachRepository()` to `ApiCoachRepository(...)`. Mock remains available for tests via `ProviderScope.overrides`.
3. Remove the hardcoded quick stats (`120 / 8 / 4.8`) from `_QuickStatsRow`. The widget is deleted; `CoachDashboardPerformance` replaces it.

### Caching & refresh

- `coachDashboardSummaryProvider` uses `autoDispose` with `keepAlive` while the screen is mounted.
- `RefreshIndicator` wraps the scroll view. On pull, it invalidates `coachDashboardSummaryProvider`, `coachScheduleProvider`, and `assessmentListProvider` in parallel.
- Background refresh on app-resume is out of scope for this task (see §8).

### Partial failure

A naive `Future.wait` is strict (one failure rejects the whole). Instead, each sub-fetch inside `coachDashboardSummaryProvider` is wrapped to resolve to `SectionResult.success(T)` or `SectionResult.failure(err, stack)` — the provider itself always returns a `CoachDashboardSummary`. Widgets read their own `SectionResult` field and render inline retry on failure. The dashboard never blanks because one query failed.

---

## 6. Loading / Empty / Error States

| Section | Loading | Empty | Error |
|---|---|---|---|
| Greeting | instant (sync from auth) | n/a | fallback "Coach" |
| Action Items | shimmer × 3 rows | **section hidden** | inline retry chip |
| Today Schedule | shimmer × 3 cards | `EmptyState` event_available | `AsyncValueWidget` default error |
| Performance | custom 3-card shimmer | `EmptyState` bar_chart | inline retry, dashboard not blocked |
| Recent Assessments | shimmer × 3 cards | `EmptyState` assignment + CTA | default error |
| Attention List | shimmer × 3 rows | **positive** `EmptyState` check_circle | default error |
| Sport Breakdown | shimmer chart placeholder | **section hidden** | inline retry chip |

Rule: a section is **hidden** when the empty state would be noise (Action Items when nothing pending, Sport Breakdown when zero students). All other sections keep their slot and render a meaningful empty state, because the slot itself signals "this kind of content normally lives here".

---

## 7. File Plan

**Created — app code:**
```
lib/core/utils/
└── section_result.dart                  (+ .freezed)   — shared, reusable beyond dashboard

lib/features/coach/presentation/widgets/dashboard/
├── coach_dashboard_greeting.dart
├── coach_role_pill.dart
├── coach_dashboard_action_items.dart
├── coach_dashboard_today_schedule.dart
├── coach_dashboard_performance.dart
├── coach_dashboard_recent_assessments.dart
├── coach_dashboard_attention_list.dart
└── coach_dashboard_sport_breakdown.dart

lib/features/coach/providers/
├── coach_id_provider.dart
└── coach_dashboard_summary_provider.dart

lib/features/coach/data/models/
├── coach_dashboard_summary.dart         (+ .freezed + .g)
├── coach_performance.dart               (+ .freezed + .g)
└── coach_action_counts.dart             (+ .freezed + .g)
```

**Created — tests** (mirror app structure):
```
test/features/coach/presentation/widgets/dashboard/
├── coach_dashboard_greeting_test.dart
├── coach_role_pill_test.dart
├── coach_dashboard_action_items_test.dart
├── coach_dashboard_today_schedule_test.dart
├── coach_dashboard_performance_test.dart
├── coach_dashboard_recent_assessments_test.dart
├── coach_dashboard_attention_list_test.dart
└── coach_dashboard_sport_breakdown_test.dart

test/features/coach/providers/
└── coach_dashboard_summary_provider_test.dart

integration_test/
└── coach_dashboard_happy_path_test.dart
```

**Modified:**
```
lib/features/coach/presentation/screens/coach_dashboard_screen.dart   (shrink to shell)
lib/features/coach/providers/coach_schedule_provider.dart             (fix coachId)
lib/features/coach/providers/assessment_provider.dart                 (fix coachId)
lib/features/coach/providers/coach_providers.dart                     (switch to API repo)
lib/core/theme/app_colors.dart                                        (add coachAccent if no fit)
```

---

## 8. Non-Goals

- No review/rating section. The existing rule that coaches do not see student reviews stays.
- No marketplace earnings calculation. Marketplace bookings still appear in the schedule, read-only.
- No milestone/achievement section.
- No quick-action FAB or chip bar.
- No in-place role switcher on the dashboard. The pill navigates to `/profile` where the existing `RoleSwitchSection` handles the switch.
- No i18n migration. All strings remain hardcoded Indonesian.
- No app-wide theme/role-color refactor. At most one color token is added.

---

## 9. Out of Scope (potential follow-ups)

- Charting library evaluation if the sport-breakdown design demands more than a `CustomPainter`.
- Background refresh on app-resume via a lifecycle observer in `RoleShell`.
- New BE endpoints (`/v1/coach/me/summary`, `/v1/coach/students/sport-breakdown`) — owned by the Laravel team. The dashboard ships with client-side aggregation as fallback.
- UI for accept/reject marketplace bookings — will be needed when marketplace coach monetization launches.
- Applying the role pill pattern to Member/Organizer/Owner dashboards.

---

## 10. Testing Strategy

### Widget tests (per section, via `ProviderScope.overrides`)

| Widget | Coverage |
|---|---|
| `CoachDashboardGreeting` | renders name; fallback "Coach" when null; pill tap navigates to profile when multi-role; pill non-interactive when single-role |
| `CoachDashboardActionItems` | hidden when all counts = 0; renders rows for nonzero counts; tap navigates to filtered route |
| `CoachDashboardTodaySchedule` | today filter correctness; "Besok: N sesi" hint shows when N > 0; empty state; loading shimmer; error |
| `CoachDashboardPerformance` | IDR vs MYR currency formatting; loading shimmer; inline retry on error; survives single-fetch failure |
| `CoachDashboardRecentAssessments` | top-3 sort desc by date; empty state CTA navigates to students; loading; error |
| `CoachDashboardAttentionList` | positive empty when zero ungraded; caps at 5 items; tap navigates to student detail |
| `CoachDashboardSportBreakdown` | hidden when map empty/sum 0; renders distribution |

### Provider tests

- `coachDashboardSummaryProvider`: parallel-fetch happy path; one-section failure does not poison the others; `coachIdProvider` throws when user null; `ref.invalidate` triggers reload.

### Integration test (one happy path)

Login as coach → land on dashboard → all sections render with seeded mock data → pull-to-refresh works → tap an Attention-List row → navigates to student detail.

---

## 11. Migration Plan (incremental, each step shippable)

1. **Split file with no behavior change.** Extract current widgets into `widgets/dashboard/`. Tests stay green.
2. **Fix data wiring.** Swap `MockCoachRepository` → `ApiCoachRepository`. Replace hardcoded `coachId` with `coachIdProvider`. Tests use overrides.
3. **Add new sections one PR at a time**, in this order: role pill → action items → attention list → sport breakdown.
4. **Polish empty/error states** to match the consistent table in §6.

No big-bang rewrite. Each PR independently testable and rollback-safe.
