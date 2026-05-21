# PRD — Organizer UI Improvement

**Status:** UI/UX redesign exploration
**Type:** Improvement of existing implementation (not greenfield)
**Target tool:** Claude Design (Anthropic Labs)
**Platform:** Flutter mobile (Android-first, iOS later)
**Language:** Indonesian-only UI
**Date:** 2026-05-10

---

## 1. Project Statement

> **This is a UI improvement project for an existing, shipped feature.**
>
> The Organizer role in HyperArena has been built and is in active use. The goal here is **not** to design new features, change data models, or expand scope. The goal is to **rethink the visual design, hierarchy, and ergonomics** of the existing Organizer screens so they are easier, faster, and more pleasant to use on a phone.
>
> Engineering, data flow, and feature scope are **fixed**. What changes is the visual layout, information density, typography, color usage, motion, and interaction polish — within the existing Flutter design system (or with intentional, well-justified exceptions).

**In scope for this redesign exploration:**
- Organizer **Dashboard** and the screens that flow from it (members, sessions, earnings, community, participant management, create-session).

**Out of scope:**
- Athlete (player), Coach, and Venue Owner roles — these will be tackled in separate iterations.
- Backend changes, API redesign, schema changes.
- New Organizer features (e.g., new analytics, new flows).

---

## 2. Product Overview — HyperArena

**HyperArena** is an all-in-one sports booking and community platform for Indonesia's recreational sports community. It connects four kinds of users in one app: players, coaches, organizers, and venue owners.

The problem space: in Indonesia, court bookings, coaching, and group sessions today live in WhatsApp groups and Instagram DMs — fragmented, with no shared source of truth for payments, attendance, or skill progress. HyperArena consolidates that into a single mobile app.

**Supported sports:** Tennis, Padel, Badminton, Futsal, Basketball, Volleyball, Table Tennis.

**Stack:** Flutter 3.38, Dart 3.8, Riverpod, go_router, Freezed. Multi-tenant Laravel backend (each "club" is a tenant). Always-online (talks to production VPS by default).

**Design language baseline:** an internal "Athletic Field Notebook" aesthetic — 4px left accent bars on cards, small-caps section headers, tabular figures for numbers, deliberate use of white space. See [`docs/DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md) for current tokens.

The redesign may **respect** or **deliberately break** that aesthetic — but if it breaks it, the new direction needs to be cohesive across all Organizer screens, not piecemeal.

---

## 3. Roles in HyperArena

HyperArena has four user roles. **This PRD covers only one — Organizer.** The others are listed for context.

| Role | What they do | In scope here? |
|---|---|---|
| **Athlete / Anggota Klub** (Player) | Books courts, joins sessions, finds coaches, tracks skill progression, earns gamification rewards. | No |
| **Coach** | Manages students, runs sessions, writes skill assessments, accepts coaching bookings. | No |
| **Organizer / Admin Klub** | Runs a sports **club** (a tenant). Manages members, hosts sessions, collects payments, tracks earnings, sends reminders, resolves disputes. | **YES** |
| **Venue Owner** | Operates physical venues and courts; confirms/rejects bookings from venue inbox. | No (and explicitly deferred to future) |

> **Important context:** A *club* in this Flutter app maps to a *school* in the Laravel backend. Each Organizer is the admin of one club/tenant. The Organizer's lens is **financial-first** — they are running a business. Members owe money, sessions need to break even, and revenue needs to be settled. Engagement metrics matter, but money matters first.

---

## 4. The Organizer — Deep Dive

### 4.1 Who they are

A typical HyperArena Organizer is:
- A **part-time or amateur sports community leader** (not a full-time business operator).
- Running a recreational sports club of **20–200 members**.
- Frequently away from a desktop — they manage the club **from their phone** between work, commute, and the actual sport sessions they organize.
- Comfortable with WhatsApp and Instagram, but not necessarily a power user of business software.

### 4.2 What they care about (in priority order)

1. **Money in, money out.** Who paid? Who didn't? How much did this session net? What's my cash position?
2. **Session ops.** Is today's session full enough to run? Did the venue confirm? Did anyone drop out?
3. **Member engagement.** Who's been inactive? Who's been on a streak? Who's a repeat customer?
4. **Disputes and edge cases.** Refunds, no-shows, payment proof verification.

The dashboard exists to surface (1) and (2) immediately. (3) and (4) are deeper-dive flows.

### 4.3 The Organizer's daily lens

Think of two modes the Organizer flips between:

**"Collection mode"** — sitting down at the start of the day, asking: *who owes me money, and what's coming in today?*
> Triggered by: opening the app in the morning, or after a session ends.
> Lives in: Dashboard hero, Members "Menunggak" filter, Earnings.

**"Session ops mode"** — actively running or preparing a session.
> Triggered by: a session starts in <2 hours, or a participant just paid.
> Lives in: Session Detail, Participant Management, action queue items.

A great redesign should make it **obvious which mode the dashboard is helping with at any moment**, and let the Organizer slip between them in one or two taps.

---

## 5. Screen Inventory (in scope)

| # | Screen | Route | Purpose |
|---|---|---|---|
| 1 | **Dashboard** | `/organizer/dashboard` | Daily command center. Today's revenue, agenda, action queue, KPI strip, earnings snapshot. |
| 2 | **Sessions list** | `/organizer/sessions` | All sessions (upcoming + past) with toggle. |
| 3 | **Session detail** | `/organizer/session/{id}` | One session: header, health, participants, settlement breakdown. |
| 4 | **Create session** (4-step stepper) | `/organizer/session/create` | New session form: info → schedule → participants/pricing → review/publish. |
| 5 | **Participant management** | `/organizer/session/{id}/participants` | Per-session bulk + per-participant management (alternative to bottom sheet in #3). |
| 6 | **Members** ("Anggota Klub") | `/organizer/club/members` | Tenant-wide roster with **financial collection lens** (outstanding banner, debt sort). |
| 7 | **Member detail** | `/organizer/club/members/{id}` | One member's full profile: financial KPIs, payment history, enrollment, engagement, skill breakdown, session history. |
| 8 | **Community** | `/organizer/club` | Club identity (cover, logo, tagline) + member directory with role badges, tier chips, gamification signals. |
| 9 | **Earnings** ("Pendapatan") | `/organizer/earnings` | Settlement history with period filter (week / month / all / custom range). |

> Screens #6 (Members) and #8 (Community) currently exist as **two distinct lenses on the same member roster**: Members is the *financial* lens (outstanding, sort by debt), Community is the *engagement* lens (tiers, streaks, role badges). Whether to keep them as two screens, merge them, or split differently is an open design question — see §8.

---

## 6. User Journeys

The redesign should make these journeys feel fast, obvious, and respectful of the user's attention.

### J1 — "How much did I make today?" (Collection mode, ~5 seconds)
1. Opens app → lands on **Dashboard**.
2. **Today's Collections hero** at the top shows:
   - Net revenue collected today
   - Expected revenue today (gap = outstanding)
3. Done. Doesn't scroll.

> Edge case: on idle days (no sessions), the hero **auto-hides** to keep the dashboard compact.

### J2 — "Who hasn't paid me?" (Collection mode, ~15 seconds)
1. Dashboard → tap **Members** in nav (or scroll dashboard if action queue surfaces it).
2. Tap filter chip **"Menunggak"** → list auto-sorts by debt size descending.
3. Each row's red **outstanding banner** at the bottom shows: amount, count, oldest unpaid date (with aging color: muted red < 7d, medium 7–30d, bold 30d+).
4. Tap a member → **Member Detail** → payment history shows each transaction with status pill and optional payment proof image (zoomable).

### J3 — "Mark this player's payment as confirmed" (Session ops mode)
1. Dashboard → action queue item **"Konfirmasi pembayaran"** (or filter session list by "Pending Payment").
2. Tap session card → **Session Detail**.
3. Participant roster → tap the player with status `Menunggu Bayar` → bottom sheet appears.
4. Sheet shows payment proof image (if uploaded, zoomable) + actions: **"Tandai Lunas"** (primary) or **"Tolak"** (with reason).
5. Tap "Tandai Lunas" → status flips to "Terkonfirmasi", roster updates.

> Bulk variant: from Session Detail, the Organizer can also open **Participant Management** which has a `"Konfirmasi Semua Pembayaran (N)"` batch button.

### J4 — "Create a new session" (~60 seconds, 4 steps)
1. Dashboard FAB **"Buat Sesi"** → **Create Session** stepper.
2. **Step 1 — Info Dasar:** Title, sport (chip selector across all sports), description, visibility (Terbuka / Undangan / Member).
3. **Step 2 — Jadwal & Lokasi:** Venue dropdown, date picker, start/end time. Info box reminds: *"Batas gabung: 6 jam sebelum sesi."*
4. **Step 3 — Peserta & Harga:** Max/min players (counter widgets), level range, price, pricing model (Margin / Transparan).
5. **Step 4 — Review & Terbitkan:** Summary card, optional **template** chip or **duplicate from past session** chip, then **"Terbitkan Sesi"**.
6. Lands on the new Session Detail.

### J5 — "Settle this session — what's the net?" (Financial reconciliation)
1. Session Detail → scroll to **Settlement** section (collapsed card).
2. **Net top line:** *"Pendapatan Bersih"* + amount (green if positive) + margin % badge.
3. Tap **"Lihat rincian"** → expands to show:
   - **Pendapatan:** student_payments, refunds (negative), coach_payouts, custom revenue entries.
   - **Biaya:** all cost streams + custom cost entries.
4. Status pill shows `Tertunda → Selesai → Dibayarkan`.

### J6 — "Send a reminder to everyone who hasn't paid"
1. Session Detail → **"Kirim Pengingat"** button → template picker:
   - "Mulai dalam 2 jam"
   - "Lapangan berubah"
   - "Pengingat pembayaran"
2. Pick → API sends to all relevant participants (e.g., payment reminder goes to pending-only).

### J7 — "Check earnings trend"
1. Tap **Earnings** in nav.
2. Hero shows net for current period with session count caption.
3. Tap period chip: **Minggu Ini / Bulan Ini / Semua / Pilih Tanggal** (custom range picker).
4. Hero updates; settlement list below shows individual sessions with status pills.

### J8 — "Who in the club has been quiet lately?"
1. **Community** screen → member directory.
2. Activity dot on each avatar: 🟢 active today / 🟡 active within 7 days / ⚪ longer.
3. Auto-tags surface signals: **"Anggota Baru"** (joined < 30 days), **"Si Paling Aktif"** (top 2 by sessions played).
4. Tier chips (Rookie → Pro) show progression.

---

## 7. Current Layout — What Each Screen Shows Today

> **Read this section as "ground truth of what exists."** The redesign decides which parts to keep, reorder, merge, or rethink.

### 7.1 Dashboard — current section order

1. **Greeting row:** `"Selamat [Pagi/Siang/Sore/Malam], [FirstName]!"` + Money Visibility Toggle (eye icon) at the right.
2. **Today's Collections hero** (auto-hides on 0-revenue days):
   - Big tabular number: net revenue collected today.
   - Secondary: expected revenue today (the gap).
3. **KPI Strip — 4 metrics** in equal-width cells:
   - Active members
   - Active coaches
   - Sessions/month
   - Outstanding bills (amount + count)
4. **Action Queue:** items grouped/sorted by severity.
   - Item types: confirmPayment, waitlistDecision, sessionRisk, refundRequest, dispute, ownerIssue.
   - Severity: low / medium / high.
5. **Session filter bar:**
   - Date range chips: Today / Tomorrow / This Week.
   - Status filter chips: Pending Payment / Low Quota / Dispute / Confirmed.
6. **"Sesi Mendatang"** header + **"Lihat Semua"** link → goes to Sessions list.
7. **Session list** (filtered, client-side): vertical list of `OrganizerSessionCard`.
8. **Earnings snapshot card:** mini version of Earnings hero (net earnings, available balance, pending balance).
9. **FAB:** `"Buat Sesi"` (extended FAB, accent color, bottom-right).

### 7.2 Members ("Anggota Klub")

- **Hero:** club cover image, logo, sport, city.
- **Stats ticker (4 KPIs):** active members (30d), active coaches, sessions/month, outstanding bills.
- **Pinned header (184px tall, fixed):** search field + filter row (Semua / Menunggak / Tanpa coach / Belum dinilai) + sort row (URUTKAN: Aktivitas · Tagihan · Nama).
- **Member roster (paginated, infinite scroll):** each row has:
  - 4px left accent bar (color = progression status).
  - Avatar + name + age + status chip.
  - Enrollment line (program · level) or `"TANPA PROGRAM"` badge.
  - Coach chip (if assigned) + last session date + total session count.
  - **Outstanding banner footer (red, only if amount > 0):** amount, count, oldest date with **aging color ramp** (muted → bold red as it gets older).
- Selecting "Menunggak" auto-flips the sort to "Tagihan" (debt-first).

### 7.3 Member Detail

- **Hero (280px):** primary-color gradient bg, member photo, name, age/gender/sport chips.
- **Financial KPI strip (3):** paid this month / outstanding / total transactions.
- **Payment history list:** icon + description + date + amount + status pill (Menunggu Bayar / Cek Bukti / Lunas / Lunas Kredit / Ditolak) + optional zoomable payment proof image.
- **Enrollment card:** program, level, joined date — or unenrolled warning.
- **Engagement KPI strip (3):** total sessions / attendance rate % / skills mastered ratio.
- **Recent trend:** horizontal cards of last 4 assessments with score, status, delta arrow.
- **Skill breakdown:** category rows with progress bars (achieved/total).
- **Session history list:** each row has date, venue, attendance pill (Hadir/Telat/Absen), payment status pill. Tap → bottom sheet (`SessionResultSheet`).

### 7.4 Sessions list

- AppBar title `"Sesi Saya"`.
- **SegmentedButton:** `Mendatang` / `Selesai`.
- Vertical list of `OrganizerSessionCard` (photo, sport badge, title, status pill, venue, date, time, price, health summary).
- FAB `"Buat Sesi"`.

### 7.5 Session Detail

- **Header card:** photo (zoomable) + sport badge + edit icon (currently a stub) + title + status pill + info rows (location, date, time, price/payment mode).
- **Health Summary Strip (3 cards):** Peserta `X/Y` / Tertunda `N` / Settlement (Tertunda/Tersedia/Dibayarkan).
- **Action buttons row** (horizontal scroll): `Kirim Pengingat` / `Bagikan` (stub) / `Duplikat` (stub) / `Batalkan` (red).
- **Participant roster:**
  - Header `"Peserta"` + count badge.
  - Each row: avatar + name + joined date + status chip.
  - Tap → bottom sheet with payment proof preview + contextual actions (varies by status):
    - `pendingPayment`: **Tandai Lunas** / **Tolak**.
    - `confirmed`: **Tandai No Show** / **Ajukan Refund**.
    - `disputed`: **Selesaikan Komplain**.
  - Attendance buttons (Hadir / Telat / Absen) for confirmed-with-bookingId only.
- **Settlement section (collapsible):**
  - Net top line + margin % badge.
  - Summary rows (Pendapatan / Biaya).
  - Expand → full breakdown (system-tracked streams + custom entries).

### 7.6 Create Session (4-step stepper)

Material Stepper widget with `"Lanjut"` / `"Kembali"` controls. Final step has summary + template/duplicate ActionChips + `"Terbitkan Sesi"`.

### 7.7 Earnings

- **Hero card** (4px green left accent):
  - Small-caps `"PENDAPATAN BERSIH · [PERIOD LABEL]"`.
  - Big tabular net amount.
  - Caption: `"[N] sesi [period]"`.
  - Hairline divider + pending meta row (icon + label + optional pending amount).
- **Period chips:** `Minggu Ini` / `Bulan Ini` / `Semua` / `Pilih Tanggal` (calendar icon, shows range when custom).
- **`RIWAYAT · N sesi`** header + hairline.
- **Settlement rows:** 4px status-colored bar + title + date + net amount + status pill. Tap → Session Detail.

### 7.8 Community

- **Hero (200px):** cover photo + dark gradient overlay + edit button (top-right, stub).
- **Glass identity card (overlapping hero):** avatar + club name + tagline + city chip + "Sejak [Month Year]" chip.
- **Stats strip (3):** members / sessions per month / active sports.
- **Invite button** (gradient fill): `"Undang Anggota"` (currently stub).
- **Member directory (sorted by role priority → sessions desc):**
  - Avatar + activity dot.
  - Name + optional role badge (Admin/Kapten).
  - Tier chip (Rookie → Pro, color-coded).
  - Auto-tags (`Anggota Baru` / `Si Paling Aktif`).
  - Mini stat row (sessions + optional fire 🔥 + streak).
  - Sport preference chips.

### 7.9 Participant Management

- Filter chips (Semua / Menunggu / Terkonfirmasi / Bermasalah) with counts.
- **Batch actions section** (only if pending > 0):
  - `Konfirmasi Semua Pembayaran (N)` (filled, primary).
  - `Kirim Pengingat Pembayaran` (outlined).
- Per-participant cards (same content as Session Detail's bottom sheet, but inline as full cards).
- **Sticky bottom stats bar:** Terkonfirmasi `X/Y` / Tertunda `N` / Refund `N`.

---

## 8. Current Pain Points & Improvement Opportunities

These are observations from auditing the existing code — concrete starting points for the redesign. Not every one needs solving; treat as an inspiration list.

### 8.1 Dashboard

- **Information density.** The dashboard stacks 7+ sections vertically: greeting, hero, KPI strip, action queue, filter bar, session list, earnings snapshot, FAB clearance. On a typical Android phone this is **3+ scroll-screens**. The eye doesn't know where to land first.
- **Two competing "today" focal points.** The Today's Collections hero AND the session filter (defaulting to "Today") both fight for the user's attention as the "today widget." They duplicate intent.
- **KPI strip is generic.** Active members / active coaches / sessions per month / outstanding — these are slow-moving numbers. Showing them with the same visual weight as the action queue (which is *actionable*) flattens the hierarchy.
- **Money visibility toggle is small and far from the money.** It lives next to the greeting, but the money it hides lives further down the screen. Discoverability is OK; relationship is not.
- **Session filter has 4 status filters with equal weight.** "Dispute" filter is currently a no-op (the code returns false because the field doesn't exist on session yet) — it's a chip that does nothing.
- **No clear mode signaling.** The dashboard tries to serve both "collection mode" and "session ops mode" simultaneously without telling the user which one it's optimized for right now.

### 8.2 Members vs. Community — two screens, same roster

- The same underlying member list is rendered **twice** under different lenses: Members (financial) and Community (engagement/identity). Users may not understand why both exist or which to use.
- Possible directions:
  - **Merge** into one screen with a lens toggle (Money | Engagement).
  - **Keep separate** but make their distinct purposes obvious in the nav and screen header.
  - **Subsume** Community into the club profile/identity card and let Members carry the roster.

### 8.3 Session Detail

- **Stub buttons cohabit with real ones.** The Edit / Bagikan / Duplikat buttons are visible in the action row but currently snackbar stubs. They erode trust in the UI ("does anything here actually work?"). Either commit to the feature or hide them.
- **Settlement section is buried.** A session's net revenue is a key piece of info, but it sits below the participant roster. For "session ops mode" that's right — but for "wrap-up after session" mode the user would prefer money first.
- **Bottom sheet vs. dedicated screen.** Per-participant actions are in a bottom sheet on Session Detail, but Participant Management offers the same actions inline on its own screen. Two interaction patterns for the same task = slower to learn.

### 8.4 Outstanding banner & aging signal

- The aging color ramp (muted red → medium → bold) is a clever idea, but the steps are subtle. A 60-day-old debt and a 35-day-old debt look almost identical. The signal's resolution doesn't match its importance.
- The banner sits at the *bottom* of the member card, past the rest of the row. For a financial-lens screen, the most important number on the card is in the least-scannable position.

### 8.5 Create Session stepper

- 4 steps × ~5 fields each = a lot of taps. Many fields have sensible defaults (min players = 2, pricing model, visibility). Could probably be condensed to 2 steps for the common case, with an "advanced" reveal.
- Step 4's "Template" and "Duplicate from past session" feature is great but is offered *last*, after the user has already filled everything in. It belongs at the *top* — "Start from a template?" before "Tell me everything."

### 8.6 Earnings

- The hero is well-designed (single number, clear period label) but the period chip "Pilih Tanggal" produces a custom range that then breaks the rhythm of the chips (active state shows the range as text, varies in width, looks unbalanced).
- Period filtering is **client-side only** today. If the redesign assumes server-side accuracy, the visual shouldn't promise more precision than the data has.

### 8.7 Visual style — "Athletic Field Notebook"

- The current design language (4px left accent bars, small-caps headers, tabular figures, hairline dividers) reads as *deliberately analog / paper-ledger*. It has personality, but it can also feel **dated** or **dense** compared to modern fintech/sports apps.
- Open question for the redesign: lean further into the notebook aesthetic (make it *more* distinctive), or move toward a cleaner contemporary look (Stripe/Notion-flavored)? Pick one and commit.

### 8.8 Indonesian-only UI considerations

- Indonesian text tends to be **15–25% longer** than English (e.g., "Konfirmasi Semua Pembayaran" vs. "Confirm All Payments"). Many existing buttons fit only because the design uses small-caps or shrinks font; a cleaner type choice may need to plan for line-wrapping or icon-only states for narrow buttons.
- Numbers use `Rp` prefix and dot thousands separator (`Rp 1.250.000`). Tabular figures are essential for column alignment.

---

## 9. Design Constraints

### 9.1 Hard constraints

- **Mobile-first, vertical scroll.** Designed for a phone held in one hand. Critical actions reachable with the thumb.
- **Flutter material widgets.** Output that maps to Material 3 components ideally — Card, Chip, FilledButton, OutlinedButton, FAB, BottomSheet, Stepper, SegmentedButton, RefreshIndicator.
- **Dark mode support required.** The app already has a full dark theme. Any new design must work in both.
- **All text in Indonesian.** Don't use English placeholder text in the redesign; use realistic Indonesian copy.
- **Multi-currency aware.** Money formatting is tenant-aware (Rp / RM / $). Show `Rp` examples; design must accommodate longer labels.
- **Always-online runtime.** Loading states (shimmer/skeleton) and error states need design love — they're reached frequently.

### 9.2 Soft constraints (preferred but breakable with reason)

- **Existing design tokens.** Colors, dimensions, typography are defined in `lib/core/theme/`. Prefer to extend rather than replace.
- **Field Notebook aesthetic** — see §8.7. Keep, evolve, or replace, but be intentional and consistent.
- **Money visibility toggle** is a real feature (sensitive-by-default for organizers in public). Wherever money appears, design needs a "masked" state (`••••••`).
- **Indonesian-only** today, but the codebase is preparing for i18n (BE+web have EN/ID/MS). The design shouldn't bake in Indonesian-specific layout assumptions that would break with longer English labels.

### 9.3 What not to design

- New features. If a screen currently has 4 sections, the redesign has 4 (possibly merged or reordered) — not 6.
- Data model changes. Don't introduce fields the BE doesn't return.
- Cross-role flows. Athlete and Coach screens are separate redesign efforts.
- Settings, profile, notifications, auth — outside Organizer scope.

---

## 10. What "Better" Looks Like (success criteria)

A successful redesign should:

1. **Lead with the right thing.** When the Organizer opens the dashboard at 7am with coffee in hand, the *most valuable single piece of information* is on screen without scrolling. (Probably: net revenue today + today's first session status.)
2. **Resolve the two-mode tension.** Either the dashboard switches modes deliberately, or it shows both modes' info in a way that doesn't feel like two dashboards stacked.
3. **Make money flows feel like a fintech app, not a CRM.** Numbers should feel weighty and trustworthy: tabular figures, clear hierarchy, generous spacing around the hero number.
4. **Reduce stub debt.** Visible buttons should do things. Hide or grey-out work-in-progress.
5. **Be visually distinctive** but never at the cost of legibility. Mobile-first ergonomics > clever layouts.
6. **Cohere across all 9 screens.** A redesigned dashboard that doesn't share a visual language with the redesigned earnings screen is worse than no redesign.

---

## 11. Design System Snapshot

> **Self-contained token reference for Claude Design.** Extracted from `docs/DESIGN_SYSTEM.md`. Use these exact values — don't invent new colors or font sizes.

### 11.1 Design Direction for this Redesign

The existing implementation uses an "Athletic Field Notebook" aesthetic (dense, small-caps, hairline dividers). **This redesign should move toward:**

- **Modern & clean** — closer to fintech/productivity apps (Stripe, Linear, Notion) than a sports ledger.
- **Spacious layout** — generous vertical padding between sections, breathing room around numbers, don't cram.
- **Readable type** — body text at 16px (bodyLarge) as default, not 14px. Hero numbers large and bold. Captions small but not tiny.
- **Financial weight** — money amounts should feel authoritative: tabular figures, high-contrast, given the most visual real estate on the screen.
- The 4px left accent bar pattern can be kept or retired — but if retired, replace with a different spatial rhythm that distinguishes card types.

### 11.2 Color Palette

#### Brand Colors

| Role | Token | Hex | Usage |
|---|---|---|---|
| Primary | `primary` | `#2563EB` | Buttons, links, active states, icons |
| Primary light | `primary50` | `#EFF6FF` | Tinted backgrounds, selected chips |
| Primary dark | `primary700` | `#1D4ED8` | Pressed/hover on primary |
| Primary darkest | `primary900` | `#1E3A8A` | Text on light primary bg |
| Secondary | `secondary` | `#0D9488` | Health/activity indicators, tags |
| Secondary light | `secondary50` | `#F0FDFA` | Secondary-tinted surface |
| Accent | `accent` | `#F97316` | FAB, special CTAs, highlights, XP bars |
| Accent light | `accent50` | `#FFF7ED` | Accent-tinted surface |

#### Neutral (Slate)

| Token | Hex | Usage |
|---|---|---|
| `neutral50` | `#F8FAFC` | Page background |
| `neutral100` | `#F1F5F9` | Card variant bg, surface alternate |
| `neutral200` | `#E2E8F0` | Borders, dividers |
| `neutral400` | `#94A3B8` | Tertiary text, icons, hints |
| `neutral500` | `#64748B` | Secondary text |
| `neutral600` | `#475569` | Body text secondary |
| `neutral800` | `#1E293B` | Headings, high-emphasis text |
| `neutral900` | `#0F172A` | Primary text, max contrast |

#### Semantic

| Role | Main | Light bg | Dark/text |
|---|---|---|---|
| Success (confirmed, paid) | `#22C55E` | `#DCFCE7` | `#16A34A` |
| Warning (pending) | `#F59E0B` | `#FEF3C7` | `#D97706` |
| Error (rejected, overdue) | `#EF4444` | `#FEE2E2` | `#DC2626` |
| Info | `#6366F1` | `#E0E7FF` | `#4F46E5` |

#### Surface & Background

| Token | Light | Dark |
|---|---|---|
| `background` | `#F8FAFC` | `#0F172A` |
| `surface` | `#FFFFFF` | `#1E293B` |
| `surfaceVariant` | `#F1F5F9` | `#334155` |

#### Text

| Token | Light | Dark |
|---|---|---|
| `textPrimary` | `#0F172A` | `#F1F5F9` |
| `textSecondary` | `#475569` | `#94A3B8` |
| `textTertiary` | `#94A3B8` | `#64748B` |
| `textOnPrimary` | `#FFFFFF` | `#FFFFFF` |
| `textLink` | `#2563EB` | `#60A5FA` |

#### Sport Colors (for chips and badges)

| Sport | Foreground | Background | Text on bg |
|---|---|---|---|
| Tennis | `#65A30D` | `#F5FAD1` | `#3F6212` |
| Padel | `#7C3AED` | `#EDE9FE` | `#5B21B6` |
| Badminton | `#0EA5E9` | `#E0F2FE` | `#0369A1` |
| Futsal | `#EF4444` | `#FEE2E2` | `#B91C1C` |
| Basketball | `#F97316` | `#FFF7ED` | `#C2410C` |
| Volleyball | `#EC4899` | `#FCE7F3` | `#BE185D` |
| Table Tennis | `#14B8A6` | `#F0FDFA` | `#0F766E` |

#### Session/Participant Status Colors

| Status | Badge | Background | Text |
|---|---|---|---|
| Pending Payment | `#F59E0B` | `#FEF3C7` | `#D97706` |
| Confirmed | `#22C55E` | `#DCFCE7` | `#16A34A` |
| Rejected / Refunded | `#EF4444` | `#FEE2E2` | `#DC2626` |
| Cancelled | `#94A3B8` | `#F1F5F9` | `#475569` |
| Completed | `#3B82F6` | `#DBEAFE` | `#2563EB` |

#### Level Tier Colors (gamification chips)

| Tier | Badge | Background | Text |
|---|---|---|---|
| Rookie | `#CD7F32` | `#FDF2E3` | `#8B5E20` |
| Amateur | `#94A3B8` | `#F1F5F9` | `#64748B` |
| Intermediate | `#F59E0B` | `#FEF3C7` | `#B45309` |
| Advanced | `#38BDF8` | `#E0F2FE` | `#0369A1` |
| Pro | `#A78BFA` | `#EDE9FE` | `#6D28D9` |

#### Gradients

| Name | Colors | Direction | Usage |
|---|---|---|---|
| primaryGradient | `#1D4ED8` → `#60A5FA` | top-left → bottom-right | Hero sections, primary CTAs |
| energyGradient | `#F97316` → `#FBBF24` | left → right | XP bars, streak indicators |
| darkOverlay | `transparent` → `#000000` 80% | top → bottom | Text-on-image overlays |

### 11.3 Typography

**Font family:** `Plus Jakarta Sans` (geometric, modern, excellent readability)
**Monospace (prices/codes, optional):** `JetBrains Mono`

#### Type Scale

| Style | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| `displayLarge` | 40px | 800 ExtraBold | 1.2 | Splash, hero XP totals |
| `headingLarge` | 24px | 700 Bold | 1.3 | Screen titles |
| `headingMedium` | 20px | 600 SemiBold | 1.35 | Section headers |
| `headingSmall` | 18px | 700 Bold | 1.4 | Card titles |
| `titleMedium` | 16px | 600 SemiBold | 1.45 | List item titles, bold labels |
| `titleSmall` | 14px | 600 SemiBold | 1.45 | Small titles, bold metadata |
| `bodyLarge` | 16px | 400 Regular | 1.5 | **Default body text** ← use this, not 14px |
| `bodyMedium` | 14px | 400 Regular | 1.5 | Secondary body text |
| `bodySmall` | 12px | 400 Regular | 1.5 | Descriptions, metadata |
| `labelLarge` | 14px | 600 SemiBold | 1.4 | Button text, tabs |
| `labelMedium` | 12px | 500 Medium | 1.4 | Chip labels, small buttons |
| `caption` | 12px | 400 Regular | 1.4 | Timestamps, captions |
| `overline` | 10px | 600 SemiBold | 1.4 | ALL-CAPS category labels |

#### Special (numbers & prices)

| Style | Size | Weight | Usage |
|---|---|---|---|
| `numberLarge` | 36px | 800 ExtraBold | Dashboard hero numbers, net revenue |
| `numberMedium` | 24px | 700 Bold | Card statistics, KPI values |
| `numberSmall` | 16px | 700 Bold | Inline numbers, counts |
| `priceLarge` | 24px | 700 Bold | Primary price display |
| `price` | 18px | 700 Bold | Standard price |

> **Design direction note:** For this redesign, prefer `numberLarge` (36px) for the single most important number on screen (e.g., today's net revenue). Use `numberMedium` (24px) for KPI values. Body text defaults to `bodyLarge` (16px). This produces a spacious, readable hierarchy — don't compress to smaller sizes unless absolutely necessary.

### 11.4 Spacing & Dimensions

**Base unit: 4px.** All spacing is a multiple of 4.

| Token | Value | Usage |
|---|---|---|
| `xs` | 4px | Micro spacing, icon-to-text gaps |
| `sm` | 8px | Chip padding, tight gaps |
| `md` | 12px | Inner padding, list gaps |
| `base` | 16px | Default card padding |
| `lg` | 20px | Section gaps, comfortable padding |
| `xl` | 24px | Screen horizontal padding, section spacing |
| `xxl` | 32px | Large section separators |
| `xxxl` | 40px | Major section breaks |
| `huge` | 48px | Top-level separators |
| `massive` | 64px | Hero section padding |

**Screen margins:** 20px horizontal, 16px below AppBar, 24px above bottom nav.

> **Design direction note:** For this redesign, use `xl` (24px) or `xxl` (32px) between major dashboard sections. Card internal padding should be `base`–`lg` (16–20px), not `md` (12px). This creates the spacious feel requested.

#### Border Radius

| Token | Value | Usage |
|---|---|---|
| `xs` | 4px | Small badges, tags |
| `sm` | 8px | Buttons, inputs, small cards |
| `md` | 12px | Standard cards |
| `lg` | 16px | Large cards, bottom sheets |
| `xl` | 20px | Feature cards, hero elements |
| `full` | 999px | Pills, chips, avatars |

#### Component Sizes

| Component | Value |
|---|---|
| Button (primary CTA) | 56px height |
| Button (standard) | 48px height |
| Input field | 52px height |
| Chip | 32px height |
| AppBar | 56px height |
| Bottom nav | 72px height |
| Avatar (list) | 32px |
| Avatar (card) | 48px |
| Avatar (profile hero) | 64–96px |
| Min touch target | 48×48px |

### 11.5 Shadows / Elevation

| Token | Offset | Blur | Color | Usage |
|---|---|---|---|---|
| `xs` | (0, 1) | 2px | `#0F172A` 5% | Subtle card lift |
| `sm` | (0, 1) | 3px | `#0F172A` 10% | Default cards |
| `md` | (0, 4) | 6px | `#0F172A` 10% | Elevated cards |
| `lg` | (0, 10) | 15px | `#0F172A` 10% | Modals, FAB |
| `colored` | (0, 4) | 12px | `#2563EB` 20% | Active FAB glow |

### 11.6 Key Component Specs

**Cards**
- Background: `surface` (`#FFFFFF`)
- Border: 1px `#E2E8F0`
- Radius: `md` (12px)
- Shadow: `sm`
- Padding: 16px

**Buttons**
- Primary (filled): bg `#2563EB`, text white, height 56px (CTA) / 48px (standard), radius 8px
- Secondary (outlined): border 1.5px `#2563EB`, text `#2563EB`, height 48px, radius 8px
- Tertiary (text): text `#2563EB`, no bg
- Destructive: bg `#EF4444`, text white

**Chips (filter/selection)**
- Height: 32px, radius full (pill)
- Default: bg `#F1F5F9`, border `#E2E8F0`, text `#475569`
- Selected: bg `#EFF6FF`, border `#2563EB`, text `#1D4ED8`
- Font: 12px / 500 Medium

**Status pills** — pill shape (radius full), 8px horizontal padding, 4px vertical:
- Background from semantic light color, text from semantic dark color (see §11.2 table)

**Bottom sheet**
- Bg: `surface`, top radius 20px, handle: 36×4px `#CBD5E1`

**FAB (extended)**
- Bg: `#F97316` (accent), text+icon white, radius 16px, shadow `colored`

### 11.7 Dark Mode Note

All surfaces, text, and borders flip in dark mode (see §11.2 surface/text tables). Brand colors (primary `#2563EB`, secondary `#0D9488`, accent `#F97316`) and semantic colors (success/warning/error) **stay the same** in dark mode.

### 11.8 Accessibility Minimums

- Touch targets: **48×48px minimum**
- Text contrast: 4.5:1 for body, 3:1 for large text
- Indonesian strings are 20–35% longer than English — use flexible-width buttons, allow text wrapping

---

## 12. Reference Material (in this repo)

For the human or tool consuming this PRD, useful files to inspect:

- **Existing design tokens:** [`lib/core/theme/app_colors.dart`](../lib/core/theme/app_colors.dart), [`app_typography.dart`](../lib/core/theme/app_typography.dart), [`app_dimensions.dart`](../lib/core/theme/app_dimensions.dart).
- **Design system doc (full):** [`docs/DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md).
- **Dashboard screen source:** [`lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart`](../lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart).
- **All Organizer screens:** `lib/features/organizer/presentation/screens/`.
- **Models that shape the UI:** `lib/features/organizer/data/models/`.

---

*End of PRD.*
