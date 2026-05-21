# Deferred Work — Organizer Redesign + Brand Refresh

**Purpose.** Things that **cannot or should not be done now** but **must be addressed later**. Each item has a trigger (when it becomes actionable), a clear scope, and a pointer to where it shows up.

Created in conjunction with PR 1 (Brand Foundation) of the Organizer redesign — keep updating as new "later" items surface.

**Last updated:** 2026-05-21

---

## A. Backend dependencies

### A1. New dashboard fields (BLOCKING for dashboard v2 visual completeness)
- **Spec:** `docs/PRD-organizer-dashboard-be-fields.md`
- **Fields:** `lastMonthEarnings`, `sessionsThisMonth`, `coachesActiveToday`, `coachesTotal`, `playersBookedToday`, `hoursOnCourtToday`, `unpaidMemberCount`
- **Frontend behavior until shipped:** corresponding UI sections render hidden (graceful degradation, no error). When the BE deploys, tiles light up automatically.
- **Trigger:** BE team commits to a delivery date — frontend can stop graceful-hiding and treat as required.
- **Effort estimate:** ~1 PR on Laravel side, no schema change. Mostly aggregation SQL in the dashboard service.

### A2. Earnings breakdown endpoint (for PR 3 — Earnings detail screen)
- **Need:** Expense categories with subtitle, amount, and color/icon. Five reference categories in the design: Honor pelatih, Sewa lapangan, Ball boy & wasit, Bola & perlengkapan, Lain-lain.
- **Proposed shape:** extend `OrganizerEarningsSummary` with `expenseBreakdown: [{ category, subtitle, amount, percentOfTotal }]` for the current period.
- **Trigger:** start of PR 3 (Earnings detail). Spec doc to be appended to `PRD-organizer-dashboard-be-fields.md` at that time.

---

## B. Frontend follow-ups (after PR 1)

### B1. Visual regression scan on non-organizer screens
- **Why:** PR 1 globally swapped `AppColors.primary` from blue (`#2563EB`) → brand teal (`#1F7A74`). All screens that use primary buttons/links/active states now render teal.
- **Verify manually:** auth (login/register), athlete home, athlete booking detail, coach dashboard, venue inbox, profile, payment proof flow.
- **Look for:** unexpected hue clashes (e.g., teal text on light teal background), broken contrast (WCAG AA), residual hardcoded blue overlooked in audit.
- **Action if regression:** file a small per-screen patch, or apply targeted `AppColors.primary800/900` overrides where contrast breaks.

### B2. `index.html` design-system showcase still shows blue
- **File:** `index.html` (74 KB) — static HTML design-system reference, not the Flutter web entry.
- **Decision:** **leave for now** — it's not user-facing runtime; it's a frozen reference of the old palette. Rebuilding it is out of scope.
- **If rebuilt later:** regenerate via the design-system source-of-truth doc (DESIGN_SYSTEM.md), not by find-replace.

### B3. `docs/DESIGN_SYSTEM.md` still describes blue primary
- The canonical design-system doc still calls primary "Electric Blue `#2563EB`". After PR 1 it's stale.
- **Action:** rewrite §1.1 Primary table to describe the teal ramp + brand anchor `#1F7A74`. Add a "Brand Refresh — 2026-05" note at the top.
- **Trigger:** before PR 2 ships (so designers reading the doc see the right palette).

### B4. `secondary` token now visually overlaps `primary`
- Current `AppColors.secondary = #0D9488` (Tailwind teal-600). New `AppColors.primary = #1F7A74` (brand teal). Both are teals — distinct shades but the visual contrast is small.
- **Risk:** any screen that uses primary + secondary side-by-side may look muddled.
- **Options for later:** either retire `secondary` (rare usage today — audit first), or repurpose it to a contrasting accent (orange / blue).
- **Trigger:** if a designer or user reports the dashboard or any screen looking "all-teal / monotonous."

### B5. iOS adaptive icon foreground has teal bg baked in
- The new logo PNG has the teal gradient background fused with the white "H" mark.
- For an ideal **adaptive icon** (Android 8+), foreground should be the white "H" on transparent and the teal background should come from `adaptive_icon_background: "#1F7A74"`. Currently the teal is in *both* layers, producing a slightly thicker visible teal.
- **Fix later:** request a transparent-bg version of the logo from design; re-run `flutter_launcher_icons`.
- **Cosmetic only**, not blocking.

### B6. `AppDomainColors.statusCompleted*` still uses blue (`#3B82F6` / `#2563EB`)
- The "Completed" booking status is intentionally a different hue from primary. Originally the doc said "maps to primary" — but now that primary is teal, the historical mapping note is outdated.
- **Decision:** keep `statusCompleted` blue — it's a semantic status color, and distinct from primary is now actually a feature (no confusion between "primary action" and "completed state").
- **Action:** just update the doc comment / `DESIGN_SYSTEM.md` to drop the "maps to primary" note. No code change.

---

## C. Open scope questions (need user decision before PR 2)

### C1. Bottom navigation
- The design shows a 5-tab bottom nav: Beranda · Sesi · Anggota · Pendapatan · Klub.
- I have not yet audited whether organizer mode has a shell route with `BottomNavigationBar`. Need to check `lib/routing/` and `lib/app.dart` before PR 2.
- **Decision needed if missing:** build new organizer shell? Or rely on existing nav structure? Will surface as a question at the start of PR 2.

### C2. Action queue redesign
- Current `ActionQueueWidget` exists and works. The design just restyles it (different icon set, 4px left bar in semantic color, count badge). Worth keeping the data layer, only restyling the presentation.
- Confirm during PR 2 implementation that no inbox-filtering logic changes.

### C3. KpiStripWidget + SessionFilterBar in current dashboard
- The design replaces these with: "Hari ini" mini-KPIs (different metrics) + "Jadwal" day timeline.
- Plan: delete `kpi_strip_widget.dart` and `session_filter_bar.dart` after PR 2 wires up replacements. Should be safe — no other screen imports them (verify with grep before delete).

### C4. Earnings snapshot card on dashboard
- Current dashboard has `EarningsSnapshotCard` at the bottom. The new design replaces this with the hero (monthly revenue at top) + dedicated Earnings detail screen. The snapshot card becomes redundant.
- Plan: remove from dashboard in PR 2.

### C5. Orphaned dashboard widgets after PR 2 — cleanup
After the PR 2 rewrite, the following files are no longer imported anywhere. Verified via `grep ActionQueueWidget|TodaysCollectionsHero|KpiStripWidget|SessionFilterBar|EarningsSnapshotCard lib/` after PR 2 — only references are in their own definition files.

Files orphaned by PR 2:
- `lib/features/organizer/presentation/widgets/todays_collections_hero.dart`
- `lib/features/organizer/presentation/widgets/kpi_strip_widget.dart`
- `lib/features/organizer/presentation/widgets/session_filter_bar.dart`
- `lib/features/organizer/presentation/widgets/earnings_snapshot_card.dart`
- `lib/features/organizer/presentation/widgets/action_queue_widget.dart` (the GROUPED version — replaced by flat `DashboardActionList` on the dashboard; the grouped version may still be useful for a future `/organizer/inbox` screen, so don't delete yet — see [C2])

**Action:** delete in a follow-up cleanup PR, OR re-purpose `action_queue_widget.dart` for the inbox screen. Removing now would be safe but separate-PR keeps PR 2 focused.

Also deferred from PR 2:
- `dashboardDateRangeProvider` and `dashboardFilterProvider` in `organizer_providers.dart` (used only by `SessionFilterBar`) are now unused. Can delete after the widgets are removed.
- `_applyFilters` method previously in `organizer_dashboard_screen.dart` was removed during the rewrite.

---

## D. Tooling / build

### D1. `flutter_launcher_icons` warning about iOS alpha — RESOLVED
- Added `remove_alpha_ios: true` to pubspec during PR 1. Next icon regen will produce a clean iOS icon.

### D2. Dependency staleness
- `flutter pub get` reports 85 packages have newer versions but constraint-incompatible. Not blocking, not part of this PR. Worth a dedicated upgrade pass later (probably tied to a Flutter SDK bump).

---

*Add new entries above this line as they surface. When an item is resolved, move to "Resolved" section at bottom (or just delete with a commit message linking the resolution).*

## D5. Profile avatar not rendering (reported 2026-05-21, investigated 2026-05-21)

**Status: NOT caused by PR 1-3** — confirmed via thorough investigation (background agent, full trace).

**Trace findings (no smoking gun in our changes):**
- `profile_screen.dart` lines 126-142 — avatar uses `CircleAvatar(backgroundImage: NetworkImage(user!.avatarUrl!))` — code path unchanged.
- No runtime references to `assets/icon/` in `lib/`. Overwritten `app_icon.png` has no runtime impact.
- `AppColors.primary50` (now `#E6F2F0` teal-tint) used only as `backgroundColor` decorative, never as a condition.
- `cached_network_image` not used for avatars (only venue/session photos).
- `app_bootstrap.dart`, `ApiInterceptor`, auth headers — all unchanged.

**Likely root cause (external — needs user verification):**
1. **`/v1/auth/me` response shape change on production BE.** The mapper at `lib/features/auth/data/mappers/auth_response_mapper.dart:62-71` (`_extractAvatarUrl`) reads `photo_urls.md` (with fallbacks `sm`/`lg`/`photo_path`). If BE stopped returning `photo_urls`, the mapper returns `null` and the avatar can't render. Since the user's preview runs against **production VPS** (per user note), a backend contract change would surface as "avatar disappeared" without any FE change.
2. **Stale `SharedPreferences` blob.** `AuthNotifier.build()` restores `User.fromJson(prefs)` — which reads flat `avatar_url` key (set when user last logged in). If the saved blob has `avatar_url: null` (e.g. from a session created before `_extractAvatarUrl` was added), the avatar never reads from `photo_urls` again. **Fresh logout/login would fix this.**
3. **NetworkImage silent failure.** `CircleAvatar.backgroundImage` doesn't expose `onBackgroundImageError` (well, it does — but it's not wired). If the URL is relative-without-base, blocked by Android cleartext policy, or returns 404, the user sees an empty teal circle and no log.

**Diagnostic steps for user (in order of effort):**
1. **Force fresh logout + login** as Haris → if avatar reappears, root cause = stale prefs blob (resolved per-session).
2. **Open Flutter DevTools network tab** while loading profile → inspect the `/v1/auth/me` response for the `photo_urls` and `photo_path` keys. If both absent → BE regression. If present → next step.
3. **Add `onBackgroundImageError` on `CircleAvatar`** at `profile_screen.dart:126` to log the network error. (Defensive improvement, not done yet — see below.)

**Defensive improvement (deferred until reproducibility confirmed):**
Rewrite the avatar widget using `ClipOval` + `Image.network(errorBuilder: ...)` to surface load failures as initials fallback (instead of empty circle). Apply to:
- `profile_screen.dart:126`
- `zoomable_avatar.dart:64`
- `edit_profile_screen.dart` (audit needed)

**Side-discoveries (pre-existing, unrelated to avatar issue):**
- `auth_response_mapper.dart` line 40-58 — `isVerified` field never set from BE response; always defaults to `false`.
- Asymmetric key mapping: live API returns `photo_urls` (nested), persisted blob uses `avatar_url` (flat). These two paths diverge if either side changes shape.

**Symptom.** User logged in as a profile that has `avatarUrl` set (e.g. "Haris Mustamsikin") — opens profile screen — photo does not render. Previously the photo was visible.

**Analysis.** None of PR 1–3 touched:
- `User.avatarUrl` field or its serialization
- `profile_screen.dart` avatar rendering (line 117-143 unchanged)
- `ZoomableAvatar` widget
- ApiClient, auth headers, or any network layer

PR 1 changed `AppColors.primary50` from `#EFF6FF` (light blue) → `#E6F2F0` (light teal). The CircleAvatar `backgroundColor` is `primary50`, so when the NetworkImage fails to render the fallback color now reads as teal instead of light blue — making the "no photo" state more visually noticeable, but **not the cause** of failure.

**Likely root cause (cannot verify without device).**
1. Image cache stale from hot-reload between sessions — **try hot-restart (R, not r)** first
2. NetworkImage silently failing (auth header missing on the avatar request, TLS issue, etc.)
3. Avatar URL became invalid (BE returning relative path, expired signed URL, etc.)

**Defensive improvement (not done — needs confirmation that the issue is reproducible).**
- `CircleAvatar.backgroundImage` does not expose `errorBuilder`. To make failures visible/recoverable, rewrite using `ClipOval` + `Image.network` with `errorBuilder` falling back to initials. Apply to:
  - `profile_screen.dart` (~L126)
  - `zoomable_avatar.dart` `CircleAvatar` (~L64)
  - `edit_profile_screen.dart` (audit needed)
- This is a pre-existing gap, not caused by PR 1-3.

**Recommended next step.** User does hot-restart and reports whether photo now appears. If still broken, capture the failing URL and inspect network response. If reproducible across fresh installs, file as bug with PR 1 as the suspect commit.

---

## E. Earnings Detail (PR 3) follow-ups

### E1. BE fields for P&L card + expense breakdown + bar chart + delta
- **Spec:** `docs/PRD-organizer-dashboard-be-fields.md` — Addendum "Earnings Detail v2"
- **Fields:** `grossRevenue`, `totalExpenses`, `netRevenueThisPeriod`, `sessionCount`, `prevPeriodNet`, `weeklyChart`, `expenseBreakdown[]`
- **Frontend behavior until shipped:** PnlCard, ExpenseBreakdownCard, bar chart, and `+X% vs bulan lalu` chip all hide. Hero number falls back to `availableBalance` (or per-period fold of `settlements`). Settlement history works fully.
- **When BE deploys:** the four sections light up automatically.

### E2. Period filter is client-side only
- The current period selector (Minggu/Bulan/Semua/Custom) filters the already-loaded `settlements` list client-side.
- For sensible numbers per period BE should accept `?period=` query param (see spec §"Period awareness") and return per-period aggregates.
- Until BE supports per-period queries, **all periods show the same `grossRevenue`/`totalExpenses` etc.** — only the settlements list and (client-side) sessionCount/periodNet differ. Document this on screen if it becomes confusing.

### E3. Bar chart highlight position
- The current `_MiniBarChart` highlights the **second-to-last** bar (matching the design mockup, which had the most recent complete week prominent). When BE delivers real `weeklyChart` arrays, verify the highlight aligns with what's semantically "current" (current week vs last full week) and adjust the index if needed.

### E4. Share button is a stub
- The "Bagikan" action in the earnings AppBar shows a snackbar "Fitur bagikan akan datang". Real implementation deferred — should generate a shareable image or text summary of the active period.

## Visibility strategy update (PR 5 — 2026-05-21)

User initially chose "Hide section sampai BE siap" then reversed to "show placeholder for visual completeness" after seeing the app feel empty. Current behavior across all redesigned widgets:

| Widget | Pre-BE behavior |
|---|---|
| Dashboard hero delta chip | Hidden when null (no false data) |
| Dashboard hero caption | Shows `"— sesi bulan ini · vs bulan lalu"` (placeholder) |
| Dashboard glass tiles `sub` | Shows `"— anggota"` / `"tidak ada tertunda"` |
| `TodayActivityStrip` | All 3 tiles render; missing values → `"—"` |
| Earnings hero caption | Shows `"dari — sesi · vs bulan lalu"` |
| Earnings bar chart | Empty muted bars + caption `"Tren mingguan akan tampil setelah backend update"` |
| `PnlCard` | Always renders; rows show `"—"`; caption `"Tersedia setelah pembaruan backend"` |
| `ExpenseBreakdownCard` | Always renders; empty state shows generic receipt icon + explanatory caption |
| Member aging progress bar | Empty gray track + caption `"Aging belum tersedia"` |
| Member Lifetime tile | `"—"` until `lifetime_spend` arrives |

When BE deploys the spec fields, all placeholders auto-replace with real values — no FE change needed.

## Resolved

- **§C1 Bottom navigation (5-tab)** — implemented in PR 4d. Organizer shell now: Beranda / Sesi / Anggota / Pendapatan / Klub. Profile moved out of nav to dashboard header icon (next to bell). Member detail nested under `/organizer/members/:id`. Earnings is now a tab branch; Community (`OrganizerCommunityScreen`) is wired in as the "Klub" tab (was previously unused).
- **§C2 ActionInbox route** — partially: `/organizer/inbox` route still missing; "Semua" link in dashboard action list still visual-only. Defer to a real inbox screen later.
- **§B5 iOS adaptive icon foreground** — still pending. Logo PNG carries baked-in teal background. Cosmetic.
