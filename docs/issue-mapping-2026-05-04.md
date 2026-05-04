# Issue Mapping — 2026-05-04 (Flutter side)

Investigation of 12 reported issues across the Flutter app (this repo) and the Laravel backend (`C:\laragon\www\hypercoach`). For backend-only action plans see `docs/superpowers/issue-mapping-2026-05-04.md` in the Laravel repo.

**Categories:**
- **A. Frontend** — Flutter only
- **B. Backend** — Laravel only
- **C. Both** — coordinated change required

**Principle:** the app must consistently distinguish (a) real data, (b) empty data, (c) mock/dummy data, and (d) feature-in-progress. Mock data must be explicitly labeled. Never show a fake success toast.

---

## Issue 1 — Schedule / Jadwal: status logic & follow-up actions

**Kategori:** C. Both

**Temuan:**
- Filter at `lib/features/coach/presentation/screens/coach_schedule_screen.dart:117-124` is purely string-based — `_upcoming` returns anything that isn't `completed`/`cancelled`. Past sessions stay in "Mendatang" indefinitely because the backend never auto-transitions sessions to `completed`.
- `_CoachSessionCard` (`coach_schedule_screen.dart:175-277`) renders only meta info; no awareness of past-vs-future, no warning chip, no inline CTAs.
- Attendance UI exists end-to-end at `lib/features/coach/presentation/screens/coach_session_detail_screen.dart` — wired to `ApiCoachSessionRepository.bulkSaveAttendance`. Edit mode is gated by a 24-hour grace window (`_isWithinGraceWindow`, lines 76-82), which silently blocks any past session that the coach forgot to fill within a day.
- Grading UI: `lib/features/coach/presentation/widgets/session_player_assessment_list.dart` is **orphaned** — the only file that imports it is itself unused. The detail screen has no grading section mounted.

**Status API/Data:**
- `GET /v1/coach/sessions` and `GET /v1/coach/sessions/{id}` — exist (routes/api.php:379-380)
- `POST /v1/coach/sessions/{sessionId}/attendance/bulk` — exists, fully wired in Flutter (line 385)
- `POST /v1/coach/sessions/{sessionId}/progress` — exists (line 390), **never called from Flutter**
- No auto-complete cron / no `PATCH /coach/sessions/{id}/complete` route

**Action Plan FE:**
- Add `_isPast(CoachSession s)` helper using `s.startAt.add(Duration(minutes: s.durationMinutes))`.
- Either move past-but-not-completed sessions into a "Perlu Tindak Lanjut" section, or render them in "Mendatang" with a warning chip.
- Add inline CTAs on `_CoachSessionCard`: "Lengkapi Absensi" (when attendances empty), "Isi Penilaian" (when no progress recorded).
- Remove or extend the 24-hour grace window — sessions stuck in `scheduled` should still be editable.
- Mount `SessionPlayerAssessmentList` inside `CoachSessionDetailScreen` for past/completed sessions.

**Action Plan BE:** see backend doc — auto-complete scheduler + optional manual `PATCH /v1/coach/sessions/{id}/complete`.

**Catatan:** Two parallel blockers — (1) sessions never auto-transition to `completed`; (2) grading entry point is built but unmounted. Both must be addressed together.

---

## Issue 2 — Coach Dashboard: real vs dummy fields

**Kategori:** C. Both

**Temuan:** All dashboard data is mock or hardcoded.

| Field | Source | Status |
|---|---|---|
| Greeting "Coach Andi!" | `coach_dashboard_screen.dart:59` literal | **Hardcoded** |
| Jadwal Hari Ini | `coachScheduleProvider` → `MockCoachRepository` | Mock + hardcoded `coach-001` |
| Penilaian Terbaru | `assessmentListProvider` → `MockCoachRepository` | Mock + hardcoded `coach-001` |
| Ulasan Terbaru | `coachReviewsProvider('coach-001')` | Mock + hardcoded |
| Total Murid | `_QuickStatsRow` line 262 | Literal `'120'` |
| Sesi Minggu Ini | `_QuickStatsRow` line 268 | Literal `'8'` |
| Rating | `_QuickStatsRow` line 274 | Literal `'4.8'` |

`coach_providers.dart:8-9` returns `MockCoachRepository()` with no flag.

**Status API/Data:**
- No `GET /v1/coach/dashboard` endpoint exists — confirmed via grep on `routes/api.php`.
- Sessions count *could* be derived from `GET /v1/coach/sessions?from=&to=`.
- No coach-facing aggregate endpoint for total students / rating / recent reviews.

**Action Plan FE:**
- Replace `MockCoachRepository` reference in `coach_providers.dart` with a real `ApiCoachRepository` once endpoints exist.
- Replace hardcoded `'coach-001'` with the authenticated user's coach ID from `authNotifierProvider`.
- Replace hardcoded `'Coach Andi!'` greeting with `user?.name`.
- Until backend endpoints exist: render `0` or "Belum ada data" / "Feature in Progress" labels on each card. **Do not display stale mock numbers.**

**Action Plan BE:** see backend doc — propose `GET /v1/coach/dashboard` aggregate endpoint.

**Catatan:** The greeting hardcode is high-visibility — every coach sees "Coach Andi!" regardless of identity. Top of fix list.

---

## Issue 3 — Atur Ketersediaan Jam: false success toast

**Kategori:** C. Both

**Temuan:**
- `lib/features/coach/presentation/screens/coach_availability_screen.dart:46` reads initial state from `MockData.coaches.firstWhere((c) => c.id == 'coach-001')`.
- Save button at lines 209-215 calls `ScaffoldMessenger.showSnackBar('Ketersediaan berhasil disimpan')` then `context.pop()`. **No HTTP call. No persistence.**
- The screen imports `mock_data.dart` directly (line 4), confirming this was never wired.

**Status API/Data:** No availability/schedule routes exist in `routes/api.php` (grep on "availability", "schedule", "ketersediaan" → zero matches). No `CoachAvailabilityController` in `app/Http/Controllers/Coach/`.

**Action Plan FE (until backend ready):**
- Remove the misleading success snackbar. Replace with one of:
  - Disable the save button + show "Feature in Progress: Pengaturan ketersediaan belum aktif" badge above the form.
  - Or hide the entry point from the coach menu entirely.

**Action Plan BE:** see backend doc — design availability schema + `GET/PUT /v1/coach/availability`.

**Catatan:** Highest UX trust priority. The misleading toast actively lies to coaches.

---

## Issue 4a — Coach own profile: hide "Perkembangan" section

**Kategori:** A. Frontend

**Temuan:** The `_MenuItem('Perkembangan', ...)` at `lib/features/profile/presentation/screens/profile_screen.dart:449` renders unconditionally. The same `ProfileScreen` widget is reused for all four roles via `app_router.dart:453-455`. `CareerScreen` (`career_screen.dart`) shows player assessments and reviews — irrelevant for a coach.

**Status API/Data:** n/a (frontend guard only)

**Action Plan FE:**
- Wrap the "Perkembangan" `_MenuItem` in `if (user?.currentRole != UserRole.coach)`.
- Also audit the XP/level progress section (lines 208-277) and streak banner (lines 281-316) — same player-only concepts. Decide: hide for coach or replace with coach-specific stats.

**Action Plan BE:** n/a

**Catatan:** Long-term: split the profile header into role-specific variants instead of a single shared screen with conditional sections.

---

## Issue 4b — Edit Profile (mobile, all roles)

**Kategori:** C. Both

**Temuan:**
- `PUT /v1/auth/profile` — wired correctly in `lib/features/profile/presentation/screens/edit_profile_screen.dart:85`.
- `POST /v1/auth/photo` (multipart upload) — wired in `_pickAndUploadPhoto()` line 179.
- `DELETE /v1/auth/photo` — wired in `_deletePhoto()` line 204.
- **Mismatch:** UI form has `bio` and `city` fields (`_bioController`, `_cityController`) but they are (a) never pre-filled from the user model (lines 41-44 init empty), and (b) never sent to the backend (only `name` + `phone` are sent at line 85). Backend `UpdateProfileRequest` only validates `name` + `phone` — those UI fields would be silently dropped anyway.
- Profile photo on `ProfileScreen` `CircleAvatar` (lines 128-145) is not wrapped in a `GestureDetector` — no zoom/preview on tap. The `InteractiveViewer` pattern is used elsewhere (`participant_management_screen.dart:495`, `venue_detail_screen.dart:528`).

**Status API/Data:**
- `PUT /auth/profile` — exists, accepts `name` + `phone` only
- `POST /auth/photo` / `DELETE /auth/photo` — exist, fully functional

**Action Plan FE:**
- Either remove `bio`/`city` (and sports/levels) from the edit form until backend supports them, or extend the PUT payload after backend adds the fields.
- In `initState()`, pre-fill controllers from the live user model.
- Wrap `CircleAvatar` in `ProfileScreen` with a `GestureDetector` opening a full-screen `InteractiveViewer` preview.

**Action Plan BE:** see backend doc — extend `UpdateProfileRequest` rules + `users` schema for `bio`, `city`.

**Catatan:** Photo upload/delete is the most complete part — production-ready. The misalignment is the bio/city fields-without-backing.

---

## Issue 4c — Admin → Detail Coach

**Kategori:** C. Both

**Temuan:**
- `GET /admin/coaches`, `GET /admin/coaches/{id}`, `GET /admin/coaches/{coachId}/rates` — all exist (routes/api.php ~180-187).
- **No** `GET /admin/coaches/{id}/schedule` — admin sessions endpoint exists but lacks a `coach_id` filter.
- **No** `GET /admin/coaches/{id}/reviews` — only `venue-deletion-requests` reviews exist.
- Flutter has **no** admin-specific coach list screen — the existing `CoachListScreen` reads from `marketplaceCoachListProvider`, not admin endpoints. Organizer shell (`app_router.dart:509-571`) has Dashboard / Sessions / Club / Profile — no Coaches tab.
- `coach_detail_screen.dart` exists but is for the player/coach feature flow (`/coach/:id`), reads mock data.

**Status API/Data:**
- `GET /admin/coaches` ✅
- `GET /admin/coaches/{id}` ✅ (name, bio, rates, photo)
- `GET /admin/coaches/{id}/sessions` ❌ missing
- `GET /admin/coaches/{id}/reviews` ❌ missing

**Action Plan FE:**
- Add a "Coaches" tab/entry to the organizer shell.
- New screens: `lib/features/organizer/presentation/screens/admin_coach_list_screen.dart` + `admin_coach_detail_screen.dart`.
- New providers calling `/admin/coaches/*` (NOT marketplace).

**Action Plan BE:** see backend doc — add the two missing routes.

**Catatan:** Both new endpoints needed before FE detail screen is shippable.

---

## Issue 5 — Coach List tenant filtering

**Kategori:** B. Backend (with optional FE param)

**Temuan:** `GET /marketplace/coaches` is **intentionally cross-tenant by design** — `routes/api.php:569` comment says so. `MarketplaceService::getCoaches()` calls `Coach::withoutGlobalScopes()` at line 114, bypassing the `BelongsToTenant` global scope. The route group lacks `resolve.tenant` middleware, so `app('current_tenant')` is never bound. Flutter sends no `tenant_id` param.

**Status API/Data:** Endpoint exists. The cross-tenant return is the documented design, not a runtime bug. Filtering would require either a query parameter or a deliberate middleware change.

**Action Plan FE:** if single-tenant filtering is the desired behaviour, pass `tenant_slug` or `tenant_id` as a query param in `ApiMarketplaceCoachRepository.getCoaches()`.

**Action Plan BE:** see backend doc — product decision needed first (cross-tenant discovery vs single-club scoping); then add optional tenant filter.

**Catatan:** **Product decision required** before implementing. The current behaviour matches the stated design; if the design is wrong, it's a deliberate change not a bug fix.

---

## Issue 6 — Menu Arena: thumbnails & cover images

**Kategori:** C. Both (BE infra check + FE polish)

**Temuan:**
- Backend `VenuePhoto` model appends `url` via `Storage::disk('public')->url($file_path)`. URL prefix depends on `APP_URL` in Laravel `.env`. If `APP_URL` is misconfigured, all photo URLs become localhost-relative and unreachable from mobile.
- `MarketplaceService::getVenues` correctly eager-loads `photos` relationship.
- Flutter `MarketplaceVenue` model has `List<VenuePhoto> photos` correctly mapped (`marketplace_venue.dart`).
- `VenueListScreen` (lines 138-158): correctly checks `photos.isNotEmpty` and renders `Image.network(photos.first.url)`.
- `MarketplaceVenueDetailScreen`: hero uses `photos.first` only (no swipeable carousel on the hero); a separate horizontal thumbnail strip below already supports tap-to-open `_PhotoViewerDialog` with pinch-to-zoom.

**Status API/Data:** Endpoint payload contains photos. Most likely cause of blank thumbnails: backend `APP_URL` env misconfiguration on production.

**Action Plan FE:**
- Add a swipeable `PageView` to the `SliverAppBar` `FlexibleSpaceBar` when `venue.photos.length > 1` — the hero currently only shows the first photo.
- Verify on a real device whether `Image.network` loads the URLs successfully.

**Action Plan BE:** see backend doc — verify `APP_URL` (and `FILESYSTEM_URL`) on production, ensure photos are seeded.

**Catatan:** Two failure modes possible: (a) URLs are wrong (BE config), (b) photos array is empty (no DB rows). Test both before assuming either.

---

## Issue 7 — Menu Klub: hide from UI until ready

**Kategori:** A. Frontend

**Temuan:**
- Bottom nav: `app_router.dart:148-153` — `_destinations(UserRole.organizer)` includes a `'Klub'` `NavigationDestination` as index 2.
- Router branch: `app_router.dart:527-533` — branch index 2 routes `AppRoutes.organizerClub` → `OrganizerCommunityScreen`.
- Route constant: `app_routes.dart:77` — `static const organizerClub = '/organizer/club'`.
- `OrganizerCommunityScreen` calls `clubProfileProvider`/`clubMembersProvider`, both of which throw `UnimplementedError` (Task 7A).

**Status API/Data:** No backend endpoints for club profile or members.

**Action Plan FE:**
- Remove the Klub `NavigationDestination` from `_destinations(UserRole.organizer)`.
- Remove the Klub `StatefulShellBranch` from the organizer `StatefulShellRoute` (the indexed branches).
- Adjust remaining branch indices (Profile shifts from 3 to 2).
- Leave `AppRoutes.organizerClub` and `OrganizerCommunityScreen` files in place — just disconnected from navigation. Easier to re-enable when backend lands.
- Verify `clubProfileProvider`/`clubMembersProvider` are not watched anywhere else after the nav removal.

**Action Plan BE:** n/a (no backend work needed to hide the feature)

**Catatan:** `_invalidateAllFeatureProviders()` in `auth_provider.dart:185-186` still references `clubProfileProvider`/`clubMembersProvider`. After hiding nav, confirm no consumers remain so the invalidate calls become harmless no-ops.

---

## Issue 8 — Dashboard Organizer: data parity & display

**Kategori:** C. Both (FE bugs + BE gaps)

**Temuan:**
- `OrganizerSessionParticipantController::dashboard` (lines 508-520) returns: `sessions_today`, `sessions_next7_days`, `at_risk_sessions`, `pending_payments`, `monthly_earnings`, `total_unpaid_amount`, `revenue_collected_today`, `revenue_expected_today`, `average_participants`, `average_rating: 0.0` (hardcoded TODO), and `action_items` array.
- Flutter `OrganizerDashboardStats` model maps all fields correctly.
- `OrganizerDashboardScreen` should render fine — KPI strip + action queue work against live data.
- **Hardcoded greeting:** `'${_greeting()}, Sari!'` (line 72) — same hardcode pattern as the coach dashboard.
- `mySessions` returns ALL tenant sessions (no status filter); Flutter splits upcoming/past client-side.
- Per-participant `payment_status` is in `/participants` (per-session), not embedded in dashboard or session list — by design.
- `getSessionDetail` (`api_organizer_repository.dart:84`) does a linear scan — TODO comment notes the missing `GET /organizer/sessions/{id}` endpoint.

**Status API/Data:**
- `GET /marketplace/organizer/dashboard` ✅
- `GET /marketplace/organizer/sessions` ✅ (returns all statuses)
- `GET /marketplace/organizer/sessions/{id}/participants` ✅ (with `payment_status`)
- `GET /marketplace/organizer/sessions/{id}` ❌ missing — Flutter does linear scan as workaround
- `average_rating` always 0 — backend stub

**Action Plan FE:**
- Replace hardcoded `'Sari!'` with `ref.watch(authNotifierProvider)?.name ?? 'Organizer'`.
- Verify dashboard renders correctly against live API on a real device — most likely already works once greeting is fixed.
- Decide: is a dedicated "completed sessions" mobile screen needed beyond the existing list-with-filter? Or is the agenda + sessions tab enough?
- Don't yet implement payment-status-summary-on-session-card — confirm with product whether tap-through to participants is acceptable.

**Action Plan BE:** see backend doc — add `GET /organizer/sessions/{id}` for deep-link efficiency; wire `average_rating` when reviews land.

**Catatan:** **Brainstorm needed (per request):** what does "dashboard not displaying correctly" mean concretely? Most likely the hardcoded "Sari!" greeting is the visible regression. After fixing that, run a real device test before assuming the rest is broken. Logging the dashboard JSON response on a test device would confirm what data is actually missing vs misrendered.

---

## Issue 9 — Multi-Role Switching

**Kategori:** A. Frontend (already built — testing only)

**Temuan:** End-to-end implementation already exists.
- Backend: `PUT /auth/switch-role` validated at `routes/api.php:125` → `SwitchRoleController`. Validates role ∈ `{super-admin, admin, coach, member}`. Returns updated user with `can_switch_to`.
- Flutter data layer: `ApiAuthRepository.switchRole` correctly calls `PUT /v1/auth/switch-role`. `AuthNotifier.switchRole` uses `resolveBackendRole()` to disambiguate `organizer` → `admin` vs `super-admin`. Calls `_invalidateAllFeatureProviders()` after success.
- UI: `lib/shared/widgets/role_switch_section.dart` is already mounted in `ProfileScreen:433`. Renders all available roles, highlights "Aktif", shows loading state via `isSwitchingRoleProvider`, error SnackBar.

**Status API/Data:** Endpoint exists. UI exists. Wiring complete.

**Action Plan FE:**
- Test with `haris@peteniskelana.id` (admin + coach) — `RoleSwitchSection` should show both Organizer and Coach tiles.
- Verify the `super-admin` ↔ `admin` ambiguity branch in `role_mapper.dart` works for users with both Spatie roles.

**Action Plan BE:** n/a

**Catatan:** No new code needed — only verification testing. If `haris@peteniskelana.id` doesn't see the switch tile, the bug is in `availableRoles` parsing, not in this stack.

---

## Issue 10 — Coach Grading Mechanism

**Kategori:** C. Both

**Temuan:** Backend is **fully built**. Flutter is **completely disconnected**.

**Backend (production-ready):**
- `app/Http/Controllers/Coach/ProgressController.php` stores both session-level (`SessionProgress`) and per-skill (`SkillProgress`) progress.
- Tenant-configurable scoring via `TenantScoringConfig` — supports two modes:
  - **Numeric**: `score` 0-10 required; `status` derived
  - **Text**: `status` enum required (`needs_work | progressing | good | excellent`); `score` optional
- Routes: `GET/POST /v1/coach/sessions/{sessionId}/progress`, `POST .../progress/copy-from-last`.
- Side effect: notifies guardians via `ProgressUpdated`.

**Flutter (UI exists, save() is fake):**
- `lib/features/coach/presentation/screens/assessment_form_screen.dart`: collects 5 sliders (Teknik, Stamina, Taktik, Mental, Konsistensi), `recommendedLevel`, `notes`, plus `strength`/`improve`/`style`.
- `_submit()` (lines 94-103) calls `ScaffoldMessenger.showSnackBar('Penilaian berhasil disimpan')` then `Navigator.pop()`. **No HTTP call.**
- `SessionPlayerAssessmentList` (the entry point widget for "Beri Penilaian") is orphaned — never mounted.

**Schema mismatch:**

| Flutter | Backend | Gap |
|---|---|---|
| 5 slider scores (1-10) | one session `score` + per-skill `score` (0-10) | FE has 5 generic; BE has 1 generic + N curriculum-linked |
| `recommendedLevel` | not in `RecordProgressRequest` | FE-only concept |
| `strength`, `improve`, `style` | single `notes` field | 3 → 1 field collapse |
| Mock `studentId` string | `student_profile_id` integer FK | Incompatible IDs |

**Status API/Data:**
- `GET/POST /v1/coach/sessions/{sessionId}/progress` ✅
- `POST .../progress/copy-from-last` ✅
- `GET /v1/coach/levels/{levelId}/skills` ✅ (needed if doing per-skill grading)

**Action Plan FE:**
- Wire `_submit()` to `POST /v1/coach/sessions/{sessionId}/progress`.
- **Phase 1 (simpler):** average the 5 sliders → numeric `score`, send as session-level only. Defer per-skill.
- **Phase 2 (richer):** fetch `level_skills` for the session's level, render real skill names, save per-skill scores.
- Replace mock `studentId` with real `student_profile_id` from the session participant payload.
- Mount `SessionPlayerAssessmentList` inside `CoachSessionDetailScreen`.
- Either drop `recommendedLevel` from save payload, or store locally until BE adds the field.

**Action Plan BE:** see backend doc — optional schema extensions for `strength_notes`/`improvement_notes`/`style_notes`/`recommended_level`.

**Catatan:** Largest single integration gap in the coach feature. **Product decision needed:** simplify FE form to match backend's session-level/per-skill model, or invest in fetching the curriculum first.

---

## Issue 11 — Recent activity (real vs mock)

**Kategori:** C. Both

**Temuan:**
- `lib/features/profile/presentation/screens/profile_screen.dart:400-430` renders "Aktivitas Terbaru" purely from `MockData.bookings` and `MockData.currentProfile`. No provider, no API call, no async.
- `_RecentActivityCard` (line 682) computes XP locally via `booking.totalAmount ~/ 15000`.
- Backend has no activity feed endpoint — grep on `routes/api.php` for "activity"/"feed"/"recent" returns nothing usable. The word `activity` only appears in `tag.platform.activity` middleware and `sessions/recent` (admin-only).

**Status API/Data:** Activity feed endpoint — **completely missing** on backend.

**Action Plan FE:**
- Until BE endpoint exists: add a visible "[Contoh Data]" / "Feature in Progress" label on the section header so users know it's not real.
- Once endpoint exists: replace `MockData.bookings` source with a real `FutureProvider` calling the API.

**Action Plan BE:** see backend doc — propose `GET /v1/me/activity` reading from existing Spatie `activity_log`.

**Catatan:** Spatie `LogsActivity` is already wired on `Coach` and likely other models in the backend — extending it to record player events (booking confirmed, session attended, etc.) is the right path rather than building a custom events table.

---

## Issue 12 — Additional findings (caught during investigation)

| # | Finding | File | Severity |
|---|---|---|---|
| 12.1 | Hardcoded greeting "Sari!" in organizer dashboard | `lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart:72` | Medium (visible) |
| 12.2 | Hardcoded greeting "Coach Andi!" in coach dashboard | `lib/features/coach/presentation/screens/coach_dashboard_screen.dart:59` | Medium (visible) |
| 12.3 | `getSessionDetail` does linear scan over full session list (no `/organizer/sessions/{id}` route) | `lib/features/organizer/data/api_organizer_repository.dart:84` | Low (perf) |
| 12.4 | `Venue` (old, mock-backed) and `MarketplaceVenue` (new, API-backed) coexist; old `VenueDetailScreen` at `/venue/:id` reads mock data and is still router-registered | `lib/features/venue/data/models/venue.dart` vs `marketplace_venue.dart` | Medium (architectural debt) |
| 12.5 | `MockAuthRepository` lives next to `ApiAuthRepository` with no `kDebugMode` guard — dev-only swap risk if a future refactor inverts the provider | `lib/features/auth/data/mock_auth_repository.dart` | Low (dev hygiene) |
| 12.6 | Backend `average_rating: 0.0` hardcoded TODO in dashboard payload — Flutter renders 0 stars | (Laravel) `OrganizerSessionParticipantController.php:513` | Low (silent zero) |
| 12.7 | Confirm/reject participant guard method named `userIsCoachForPurchase()` even though the caller is an organizer/admin | (Laravel) `OrganizerSessionParticipantController.php:639-647` | Low (clarity) |
| 12.8 | `_invalidateAllFeatureProviders()` references club providers that throw `UnimplementedError` — invalidating these is a no-op now but creates noise | `lib/features/auth/providers/auth_provider.dart:185-186` | Low |

---

## Cross-cutting recommendations

1. **Dummy-data audit pass.** Several screens still depend on `MockData.*` directly: coach dashboard, coach availability, coach assessment, profile recent activity. Inventory + label all mock sources visibly until each is wired.
2. **No-fake-success rule.** Any save action that doesn't actually persist must either (a) be disabled with a "Feature in Progress" badge, or (b) honestly report failure. Issue 3 and Issue 10 both violate this today.
3. **Hardcoded user names.** Two greetings ("Sari!", "Coach Andi!") are baked in — quick wins to fix as part of any dashboard touch.
4. **Role-aware profile.** `ProfileScreen` is shared across all 4 roles with no role-aware sections (Issue 4a, plus XP/streak banners). A small role-conditional pass is worthwhile.
5. **Activity log integration.** Spatie activity log on the backend is the natural source for Issue 11; coordinate with backend to expose a `me/activity` endpoint reading from it.

---

## Priority suggestion (for sequencing)

1. **Stop lying to users** — Issue 3 (false "berhasil disimpan"), Issue 10 (false grading save). Disable or fix.
2. **Quick visibility wins** — Issues 12.1/12.2 (hardcoded greetings), Issue 7 (hide Klub), Issue 4a (hide Perkembangan for coach).
3. **Real data plumbing** — Issue 2 (coach dashboard), Issue 11 (activity), Issue 1 (schedule status), Issue 4b (edit profile fields).
4. **New backend work + FE wire-up** — Issue 4c (admin coach detail), Issue 6 (verify `APP_URL`), Issue 10 (grading wire-up after product decision), Issue 8 (after greeting fix and live test).
5. **Product decision required first** — Issue 5 (cross-tenant marketplace?).
6. **Already done, test only** — Issue 9 (multi-role switch).
