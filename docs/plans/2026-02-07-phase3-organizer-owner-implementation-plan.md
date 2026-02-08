# Phase 3: Organizer + Court Owner — Visual & Operational Upgrade

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace all basic/placeholder organizer and owner screens with polished, action-led operational dashboards following the brainstormed design specifications. Extend models where needed for new visibility options and payment flexibility.

**Context:** Phase 3 data layer (models, repositories, mock implementations, providers) was already built in a prior execution pass. All Freezed models, mock repos, and Riverpod providers are functional. This plan focuses on the **UI layer redesign** and small model extensions.

**Architecture:** Feature-First + Riverpod + go_router. Mock-first repository pattern. All design tokens from `DESIGN_SYSTEM.md`.

**Tech Stack:** Flutter 3.38, Riverpod, go_router, Freezed/json_serializable, cached_network_image.

---

## What Already Exists (DO NOT recreate)

These files are complete and working — only modify if a task explicitly says to:

**Models (Freezed, with generated .freezed.dart + .g.dart):**
- `lib/features/session/data/models/open_session.dart` — OpenSession + SessionHealth + enums
- `lib/features/session/data/models/session_participant.dart` — 7 participant states
- `lib/features/organizer/data/models/organizer_dashboard_stats.dart`
- `lib/features/organizer/data/models/organizer_action_item.dart` — types + severity
- `lib/features/organizer/data/models/organizer_earnings_summary.dart` — settlements
- `lib/features/organizer/data/models/create_session_draft.dart`
- `lib/features/owner/data/models/owner_dashboard_stats.dart`
- `lib/features/owner/data/models/court_availability_issue.dart`

**Repositories + Mocks:**
- `lib/features/organizer/data/organizer_repository.dart` (abstract, 18 methods)
- `lib/features/organizer/data/mock_organizer_repository.dart` (full implementation)
- `lib/features/owner/data/owner_repository.dart` (abstract, 8 methods)
- `lib/features/owner/data/mock_owner_repository.dart`

**Providers:**
- `lib/features/organizer/providers/organizer_providers.dart` — 12 providers
- `lib/features/organizer/providers/create_session_provider.dart`
- `lib/features/organizer/providers/participant_management_provider.dart`
- `lib/features/owner/providers/owner_providers.dart`

**Routing (complete):**
- `lib/routing/app_routes.dart` — all organizer/owner route constants
- `lib/routing/app_router.dart` — all shells + full-screen routes registered

---

## Design Principles (from brainstorming session)

### Organizer Dashboard — Action-Led, Not Stat-Led
- **Flow:** Fill slots -> collect money -> confirm players -> avoid problems -> get paid
- **Default timeframe:** Today + Next 7 days
- **Section order:** Greeting -> Attention items -> Next sessions timeline -> Create Session CTA -> Earnings snapshot
- **Visual tone:** Calm base + targeted alerts (severity dots: red/orange/yellow)
- **Attention items:** Compact list rows, grouped by type when multiple. No "inbox" label.
- **Session cards:** Sport accent bar, fill-rate progress bar, health chips only for problems

### Court Owner Dashboard — Lean Reconciliation
- Primary action: Confirm payment received (whether via app or external)
- **Payment is optional through app** — owner marks "received/settled" regardless of channel
- Organizer-managed bookings tagged "Dikelola Organizer"
- Direct bookings tagged "Konfirmasi Owner Diperlukan"

### Session Visibility Options
- `free` — open to everyone, no restrictions
- `invitationOnly` — publicly visible but requires invite to join
- `membersOnly` — restricted to organizer's followers/members

---

## Task 1: Extend SessionVisibility Enum + Owner Payment Flexibility

**Files:**
- Modify: `lib/features/session/data/models/open_session.dart`
- Modify: `lib/features/organizer/data/models/create_session_draft.dart`
- Modify: `lib/features/owner/data/owner_repository.dart`
- Modify: `lib/features/owner/data/mock_owner_repository.dart`

**Changes:**

1. Update `SessionVisibility` enum:
```dart
enum SessionVisibility { free, invitationOnly, membersOnly }
```
Replace all references to `SessionVisibility.public` with `SessionVisibility.free` and `SessionVisibility.followersOnly` with `SessionVisibility.membersOnly` across all files that reference these values.

2. Add `markBookingSettled` to `OwnerRepository`:
```dart
Future<Booking> markBookingSettled(String bookingId, {String? note});
```
This covers the case where payment happened outside the app — owner just marks it as settled.

3. Implement in `MockOwnerRepository` — update booking status to confirmed + add note.

4. Add a visibility label helper method (can go in a small utility or inline):
```dart
String visibilityLabel(SessionVisibility v) => switch (v) {
  SessionVisibility.free => 'Gratis / Terbuka',
  SessionVisibility.invitationOnly => 'Undangan Publik',
  SessionVisibility.membersOnly => 'Khusus Member',
};
```

**Verify:**
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

---

## Task 2: Organizer Dashboard Screen — Full Redesign

**File:** Overwrite `lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart`

**Design spec (top to bottom):**

1. **No AppBar** — use SafeArea + custom greeting header:
   - Greeting: "Selamat [Pagi/Siang/Sore/Malam], [Name]!" using `AppTypography.headingLarge`
   - Subtitle: "X sesi minggu ini" in `AppTypography.bodyMedium` + `AppColors.textSecondary`

2. **Attention items section** (only shown when items exist):
   - Section header: "Perlu Perhatian" in `AppTypography.titleMedium`
   - Compact list rows in a single `surface` container with `AppShadows.sm` + `radiusLg`
   - Each row: severity dot (10px circle) + title + subtitle + chevron icon
   - Severity dot colors: `high` = `AppColors.error`, `medium` = `AppColors.warning`, `low` = `AppColors.info`
   - Rows separated by thin `Divider(color: AppColors.neutral100)`
   - Group by type when >3 items of same type, show count header: "3 Pembayaran Tertunda"
   - Tappable → `context.push(AppRoutes.organizerSessionDetail(item.sessionId!))`
   - When empty: skip section entirely (no empty state)

3. **Next sessions timeline** (Today + Next 7 days):
   - Section header: "Sesi Mendatang" + "Lihat Semua" text button → `context.go(AppRoutes.organizerSessions)`
   - Session cards (see Task 3 for `_OrganizerSessionCard` widget)
   - Max 5 shown on dashboard
   - When empty: `EmptyState(message: 'Belum ada sesi minggu ini', icon: Icons.event_available_outlined)`

4. **Create Session CTA**:
   - Full-width container with `accent` gradient background (`AppColors.accent` to `AppColors.accent700` or similar warm gradient)
   - White text: "Buat Sesi Baru" + "Atur jadwal dan undang pemain" subtitle
   - Rounded `radiusLg`, `AppShadows.md`
   - Tap → `context.push(AppRoutes.organizerCreateSession)`

5. **Earnings snapshot**:
   - `surface` container, `radiusLg`, `AppShadows.sm`
   - Row: "Tersedia" (green `AppColors.success` value) | "Tertunda" (orange `AppColors.warning` value) | "Detail" text button
   - Values from `organizerEarningsProvider`
   - Tap "Detail" → `context.push(AppRoutes.organizerEarnings)`

**Pull-to-refresh:** `RefreshIndicator` that invalidates all dashboard providers.

**Use existing providers:** `organizerDashboardProvider`, `organizerActionInboxProvider`, `organizerAgendaProvider`, `organizerEarningsProvider`.

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart
```

---

## Task 3: Organizer Session Card Widget

**File:** Create `lib/features/organizer/presentation/widgets/organizer_session_card.dart`

**Widget:** `OrganizerSessionCard` — ConsumerWidget taking `OpenSession session` + optional `VoidCallback? onTap`.

**Card anatomy:**
- `surface` bg, `radiusLg`, `AppShadows.sm`, padding `AppDimensions.base`
- **Sport accent bar:** 4px wide Container on the left side using `IntrinsicHeight` + sport color from `SportThemeExtension`
- **Top row:** Session title (`titleSmall`, bold) + status pill right-aligned
  - Status pill colors: `open` = `AppColors.primary` bg, `full` = `AppColors.warning`, `confirmed` = `AppColors.success`, `cancelled` = `AppColors.error`, `completed` = `AppColors.neutral400`
  - Status labels: `Terjadwal`, `Penuh`, `Terkonfirmasi`, `Dibatalkan`, `Selesai`
- **Meta row:** Icon + text pairs: venue icon + name, calendar icon + `Formatters.formatDateShort(date)`, clock icon + time range
  - Use `AppTypography.caption` + `AppColors.textSecondary`
  - Icons size 14, `AppColors.neutral400`
- **Fill rate bar:** Full-width, 6px height, `radiusFull`
  - Track: `AppColors.neutral100`
  - Fill: sport color from `SportThemeExtension`, width = `currentPlayers / maxPlayers`
  - Label right-aligned: "${currentPlayers}/${maxPlayers} pemain" in `AppTypography.caption`
- **Health chips row** (only show if problems exist):
  - `health.pendingPayments > 0` → orange chip: "${n} belum bayar"
  - `health.isJoinDeadlineAtRisk` → yellow chip: "Deadline segera"
  - `health.isLowSignupRisk` → yellow chip: "Kuota rendah"
  - Any participant with `disputed` status → red chip: "Sengketa"
  - Chip style: colored bg with 0.1 alpha, colored text, `radiusFull`, small padding
  - **No chips = healthy session** (clean card, no extra row)
- **Bottom row:** Price left (`Formatters.formatRupiah(pricePerPerson)` + "/orang") + "Kelola" tonal button right
  - If `session.status == cancelled` → no button, just grey "Dibatalkan" text

**Critical state:** If any red chips present, replace sport accent bar color with `AppColors.error`.

**Default onTap:** `context.push(AppRoutes.organizerSessionDetail(session.id))`

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/widgets
```

---

## Task 4: Organizer Session List Screen — Redesign

**File:** Overwrite `lib/features/organizer/presentation/screens/organizer_session_list_screen.dart`

**Design:**
- AppBar: "Sesi Saya" title
- **Toggle row** below AppBar: `SegmentedButton` with 2 options: "Mendatang" | "Selesai"
  - Default: Mendatang
  - Mendatang uses `organizerUpcomingSessionsProvider`
  - Selesai uses `organizerPastSessionsProvider`
- **Session list:** `ListView.builder` using `OrganizerSessionCard` from Task 3
  - Padding: `AppDimensions.screenHorizontal`
  - Item spacing: `AppDimensions.sm`
- **Empty state:** `EmptyState` with context-appropriate message
- **FAB:** `FloatingActionButton.extended` with `+` icon + "Buat Sesi" → `context.push(AppRoutes.organizerCreateSession)`
- **Pull-to-refresh:** Invalidates session providers

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens/organizer_session_list_screen.dart
```

---

## Task 5: Organizer Session Detail Screen — Full Redesign

**File:** Overwrite `lib/features/organizer/presentation/screens/organizer_session_detail_screen.dart`

**Remove:** The manual `bottomNavigationBar` — this screen is full-screen (pushed route), not a tab. Use standard AppBar with back button.

**Design spec (top to bottom, scrollable):**

1. **Session header card** — `surface` bg, `radiusLg`, `AppShadows.sm`:
   - Sport badge pill (sport-colored bg + sport label) + edit icon button top-right (snackbar "Edit coming soon" for MVP)
   - Title: `AppTypography.headingSmall`
   - Status pill right of title (same style as session card)
   - Info rows: venue + date + time + price (same `_InfoRow` pattern as player session detail)

2. **Health summary strip** — Row of 3 mini-metric containers:
   - Fill rate: circular percentage indicator (small, 32px) + "8/10" text
   - Pending: count text, orange if > 0
   - Settlement: status text, green if "Dibayarkan"
   - Use `surface` bg, `radiusMd`, `AppShadows.xs`

3. **Action buttons row** — Horizontal scroll of `FilledButton.tonal`:
   - "Kirim Pengingat" (icon: `Icons.notifications_active_outlined`) → show template picker bottom sheet
   - "Bagikan Sesi" (icon: `Icons.share_outlined`) → snackbar "Share coming soon"
   - "Duplikat Sesi" (icon: `Icons.copy_outlined`) → snackbar "Duplicate coming soon" (or trigger duplicate action)
   - "Batalkan Sesi" (icon: `Icons.cancel_outlined`, `foregroundColor: AppColors.error`) → show reason dialog → `participantManagement.cancelSession()`

4. **Participant roster**:
   - Section header: "Peserta" + count badge
   - Each participant in a `surface` container row:
     - Left: `CircleAvatar` with initials (24px radius, `AppColors.primary50` bg)
     - Center: player name (`titleSmall`) + joined date (`caption`)
     - Right: status chip with color:
       - `pendingPayment` → orange bg: "Menunggu Bayar"
       - `confirmed` → green bg: "Terkonfirmasi"
       - `rejected` → red bg: "Ditolak"
       - `cancelledByPlayer` → grey bg: "Dibatalkan"
       - `refunded` → red outline: "Refund"
       - `noShow` → dark grey bg: "No Show"
       - `disputed` → red filled: "Sengketa"
     - Tap row → show bottom sheet with contextual actions:
       - If `pendingPayment`: "Konfirmasi Pembayaran" + "Tolak" (with reason input)
       - If `confirmed`: "Tandai No Show" + "Ajukan Refund" (with reason)
       - If `disputed`: "Selesaikan Sengketa" (with resolution input)
       - All states: "Kirim Pesan" (snackbar for MVP)
   - Show all participants (no `.take(5)` limit)

5. **Settlement section**:
   - Section header: "Settlement"
   - `surface` container with breakdown rows:
     - "Gross Revenue" → `Formatters.formatRupiah(gross)`
     - "Estimasi Biaya" → `Formatters.formatRupiah(cost)` (negative/deduction style)
     - Divider
     - "Pendapatan Bersih" → `Formatters.formatRupiah(net)` (bold, `titleMedium`)
     - Settlement status chip at bottom

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens/organizer_session_detail_screen.dart
```

---

## Task 6: Create Session Screen — Wizard Redesign

**File:** Overwrite `lib/features/organizer/presentation/screens/create_session_screen.dart`

**Design:** 4-step wizard using `Stepper` (keep existing Stepper approach but polish each step).

**Step 1 — Info Dasar:**
- `AppTextField` for session title (with label "Judul Sesi")
- Sport selector: horizontal scroll of `SportChipSelector` pills (single select)
- `AppTextField` for description (optional, multiline, 3 lines)
- Visibility selector: 3-option `SegmentedButton`:
  - "Terbuka" (free) | "Undangan" (invitationOnly) | "Member" (membersOnly)
  - Use the new `SessionVisibility` enum values from Task 1

**Step 2 — Jadwal & Lokasi:**
- Venue dropdown (from `MockData.venues`) with venue name display
- Date picker using `showDatePicker` — show selected date in a styled container
- Start/End time: Use `TimeOfDay` pickers or styled text fields (e.g. "19:00" / "21:00")
- Join deadline: auto-calculated "2 jam sebelum mulai" with option to edit

**Step 3 — Peserta & Harga:**
- Max players: number stepper (+ / - buttons around a number display)
- Level range: two `DropdownButton<LevelTier?>` (min/max, both optional)
- Price per person: `AppTextField` with "Rp" prefix, number keyboard
- Pricing note toggle: `SegmentedButton` "Termasuk Lapangan" / "Belum Termasuk"

**Step 4 — Review & Terbitkan:**
- Summary card showing all entered data in read-only format (title, sport, venue, date, time, players, price, visibility)
- Mini preview: render an `OrganizerSessionCard` with the draft data
- "Terbitkan" primary button with accent gradient (full width)
- "Simpan Draft" secondary text button below
- Template/Duplicate section: show existing sessions as action chips for quick duplication

**Controls:** "Lanjut" filled button + "Kembali" text button. Step 4 shows "Terbitkan" instead of "Lanjut".

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens/create_session_screen.dart
```

---

## Task 7: Participant Management Screen — Redesign

**File:** Overwrite `lib/features/organizer/presentation/screens/participant_management_screen.dart`

**Design:**
- AppBar: "Kelola Peserta" + session title as subtitle
- **Filter chips:** Horizontal row — "Semua" | "Menunggu" | "Terkonfirmasi" | "Bermasalah"
  - "Bermasalah" filters: `rejected`, `refunded`, `noShow`, `disputed`
- **Participant list:** Same card style as session detail roster but with more space and direct action buttons visible (not just in bottom sheet):
  - For `pendingPayment`: show "Konfirmasi" filled button + "Tolak" outlined button inline
  - For `confirmed`: show "No Show" + "Refund" as outlined buttons
  - For `disputed`: show "Selesaikan" filled button
- **Batch actions section** at top (when pending > 0):
  - "Konfirmasi Semua Pembayaran (X)" filled accent button
  - "Kirim Pengingat Pembayaran" outlined button
- **Stats bar** at bottom: confirmed count / total + pending count + refund count

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens/participant_management_screen.dart
```

---

## Task 8: Organizer Earnings + Community Screens

**Files:**
- Overwrite: `lib/features/organizer/presentation/screens/organizer_earnings_screen.dart`
- Overwrite: `lib/features/organizer/presentation/screens/organizer_community_screen.dart`

### Earnings Screen Design:
- AppBar: "Pendapatan"
- **3 summary cards** in a row (using `Expanded`):
  - "Tersedia" — green `AppColors.success` text, large Rupiah value
  - "Tertunda" — orange `AppColors.warning` text
  - "Dibayarkan" — neutral grey text
  - Each card: `surface` bg, `radiusMd`, `AppShadows.xs`
- **Period filter chips:** "Minggu Ini" | "Bulan Ini" | "Semua" (default: Bulan Ini)
  - Filter is visual only for MVP — show all settlements regardless
- **Per-session settlement list:** Each row in `surface` container:
  - Session title + date (left)
  - Amount: `Formatters.formatRupiah(netRevenue)` (right)
  - Settlement status chip: `pending` = orange, `cleared` = blue (`AppColors.info`), `paidOut` = green
  - Tap → `context.push(AppRoutes.organizerSessionDetail(sessionId))`
- **Empty state:** "Belum ada sesi yang selesai" + "Buat Sesi" CTA

### Community Screen Design:
- AppBar: "Komunitas"
- **Follower count** header: "X Pengikut" in `headingSmall`
- **Follower list:** Simple `ListView` of name rows
  - Each row: `CircleAvatar` with initials + name + "Pengikut" label
- **Invite CTA** at bottom: "Undang Pemain" filled button (snackbar for MVP)
- **Empty state:** "Belum ada pengikut" + invite CTA

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation/screens
```

---

## Task 9: Owner Dashboard Screen — Full Redesign

**File:** Overwrite `lib/features/owner/presentation/screens/owner_dashboard_screen.dart`

**Design spec (top to bottom):**

1. **No AppBar** — SafeArea + custom greeting:
   - "Halo, Hendra" in `headingLarge`
   - "3 venue aktif" subtitle in `bodyMedium` + `textSecondary`

2. **Pending confirmations banner** (only when `pendingConfirmations > 0`):
   - Orange-tinted container (`AppColors.warning` with 0.08 alpha bg)
   - `radiusLg`, padding `base`
   - Text: "X pembayaran menunggu konfirmasi"
   - "Lihat" text button right → `context.push(AppRoutes.ownerBookingQueue)`

3. **Today's overview row** — 3 `Expanded` stat cards:
   - "Booking Hari Ini" (count) + calendar icon
   - "Okupansi" (percentage) + pie chart icon + mini circular progress (just percentage text for MVP)
   - "Pendapatan Hari Ini" (Rupiah) + wallet icon
   - Each card: `surface` bg, `radiusMd`, `AppShadows.xs`, padding `base`

4. **Venue quick cards** — vertical list:
   - Each card: `surface` bg, `radiusLg`, `AppShadows.sm`
   - Venue name (`titleSmall`) + city (`caption`)
   - Court count: "X lapangan" pill
   - Status dot: green (normal) / orange (has issues)
   - Tap → `context.push(AppRoutes.ownerVenueDetail(venue.id))`

5. **Court issues section** (only when issues exist):
   - Red-tinted container (`AppColors.error` with 0.05 alpha)
   - Each row: court name + issue reason + "Atur" text button
   - Use `ownerAvailabilityIssuesProvider`

**Remove:** The manual "Boundary Signals" section (was for debugging, not user-facing). Boundary signals should be embedded contextually in booking queue items instead.

**Verify:**
```bash
flutter analyze lib/features/owner/presentation/screens/owner_dashboard_screen.dart
```

---

## Task 10: Owner Venue Screens — Redesign

**Files:**
- Overwrite: `lib/features/owner/presentation/screens/owner_venue_list_screen.dart`
- Overwrite: `lib/features/owner/presentation/screens/owner_venue_detail_screen.dart`

### Venue List Screen:
- AppBar: "Venue Saya"
- Venue cards: `surface` bg, `radiusLg`, `AppShadows.sm`
  - Venue name + city + court count
  - Occupancy mini bar (simple linear progress)
  - Status indicator dot
  - Tap → `context.push(AppRoutes.ownerVenueDetail(venue.id))`

### Venue Detail Screen:
- AppBar: venue name
- **Info section:** Name + city + address in `surface` card
- **Court list:** Cards per court:
  - Court name + sport type pill
  - Status: "Aktif" (green) / "Tidak Tersedia" (red) with date range if unavailable
  - Today's booking count badge
- **Edit button:** "Edit Info Venue" outlined button → snackbar "Edit coming soon" for MVP
- **Court availability toggle:** Per court, "Tandai Tidak Tersedia" button → show date range picker + reason input → call `setCourtUnavailable()`

**Verify:**
```bash
flutter analyze lib/features/owner/presentation/screens
```

---

## Task 11: Owner Booking Queue Screen — Redesign

**File:** Overwrite `lib/features/owner/presentation/screens/owner_booking_queue_screen.dart`

**Design:**
- AppBar: "Antrian Booking"
- **Filter tabs:** `SegmentedButton` — "Semua" | "Menunggu" | "Dikonfirmasi"
  - Default: Menunggu (show pending first — this is the primary action screen)
- **Booking rows** — each in `surface` container, `radiusMd`, `AppShadows.xs`:
  - **Left column:**
    - Booker name (`titleSmall`)
    - Court + venue name (`caption`)
    - Date + time range (`caption`)
  - **Right column:**
    - Amount: `Formatters.formatRupiah(booking.totalAmount)` in `titleSmall`
    - Source tag below amount:
      - Direct booking: "Langsung" chip in `AppColors.primary` tint
      - Organizer-managed: "Via [OrganizerName]" chip in `AppColors.secondary` tint
      - Below organizer tag: "Dikelola oleh [Name]" in `caption` + `textTertiary`
  - **Actions (for pending bookings):**
    - "Konfirmasi Diterima" filled button → confirm bottom sheet with Rupiah amount
    - "Tandai Lunas" outlined button (for external payments) → show note input
    - "Tolak" text button with `AppColors.error` → show reason input
  - **For confirmed bookings:** Show green check icon + "Terkonfirmasi" + confirmed date

**Confirm bottom sheet:**
- Title: "Konfirmasi Pembayaran"
- Show: booker name, court, amount
- "Konfirmasi pembayaran diterima?" text
- "Konfirmasi" filled button + "Batal" text button

**Mark settled bottom sheet (for external payments):**
- Title: "Tandai Pembayaran Lunas"
- Note text field (optional): "Catatan (transfer bank, tunai, dll)"
- "Tandai Lunas" filled button

**Verify:**
```bash
flutter analyze lib/features/owner/presentation/screens/owner_booking_queue_screen.dart
```

---

## Task 12: QA + Regression Pass

**Required checks:**
```bash
flutter analyze
flutter build apk --debug -t lib/main_mock.dart
```

**Manual flow matrix:**
1. Quick login Host → organizer dashboard shows greeting + attention items + session timeline + CTA + earnings.
2. Organizer sessions tab → session list with toggle (upcoming/past) + session cards with health chips.
3. Organizer session detail → participant roster with status chips + action bottom sheets work (confirm/reject/no-show/refund).
4. Create session wizard → 4 steps + visibility selector has 3 options + publish creates session.
5. Organizer earnings → 3 summary cards + settlement list.
6. Quick login Owner → dashboard shows greeting + pending banner + stats + venue cards.
7. Owner venue list → cards with court count + occupancy.
8. Owner booking queue → filter tabs + confirm/mark-settled/reject actions work.
9. Player login → all existing flows unaffected (home, explore, booking, session join).
10. Coach login → dashboard, schedule, students, assessment all still work.

---

## Deliverables Checklist

- [x] `SessionVisibility` enum updated to `free/invitationOnly/membersOnly`.
- [x] Owner repo has `markBookingSettled` method.
- [x] Organizer dashboard is action-led with greeting, attention items, sessions, CTA, earnings.
- [x] `OrganizerSessionCard` widget reusable across dashboard + session list.
- [x] Session list has upcoming/past toggle with proper filtering.
- [x] Session detail shows full participant roster with inline status chips + action bottom sheets.
- [x] Create session wizard has 4 polished steps with visibility selector.
- [x] Participant management screen has filter chips + batch actions.
- [x] Earnings screen shows 3 summary cards + per-session settlements.
- [x] Community screen redesigned as Klub with club identity card, stats strip, enriched member list + invite CTA.
- [x] Owner dashboard has greeting, pending banner, stats, venue cards, court issues.
- [x] Owner venue screens show court list with availability toggles.
- [x] Owner booking queue has filter + confirm/settle/reject actions with bottom sheets.
- [x] All labels in Indonesian (consistent with rest of app).
- [x] Full app analyze/build passes in mock mode.
- [x] Manual role-switch test passes for all 4 roles.

---

## Suggested Sequencing

1. **Task 1** — Enum/model extensions (small, unblocks Task 6 visibility selector)
2. **Task 3** — Session card widget (reusable, unblocks Tasks 2 + 4)
3. **Tasks 2, 4, 5** — Organizer dashboard + session list + session detail (core screens)
4. **Tasks 6, 7** — Create session wizard + participant management
5. **Task 8** — Earnings + Community (lighter screens)
6. **Tasks 9, 10, 11** — Owner screens (independent from organizer)
7. **Task 12** — QA pass

---

*Plan Version: 2.0 — Visual & Operational Upgrade*
*Phase: 3 — Organizer + Court Owner Operations*
*Date: 2026-02-07*
