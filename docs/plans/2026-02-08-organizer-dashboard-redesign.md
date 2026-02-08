# Organizer Dashboard Redesign

## What the operator needs

The organizer opens the app and wants five answers fast:

1. What happens today?
2. What demands action right now?
3. Where is money stuck?
4. What should I do next?
5. Which sessions underperform?

The current dashboard stacks a greeting, a flat alert list, session cards, a CTA banner, and an earnings row — all in one scroll. It reads like a feed, not a control panel. Each section occupies full width and full attention; nothing groups, nothing summarizes, nothing filters.

This redesign turns the dashboard into a command center.

---

## What changes

### 1. KPI strip replaces the greeting subtitle

The current subtitle ("5 sesi minggu ini") wastes prime screen space on a single number. Replace it with a compact row of tappable tiles:

| Tile | Source field | Example |
|------|-------------|---------|
| Sesi Hari Ini | `sessionsToday` | **3** |
| Belum Bayar | `pendingPayments` | **5 (Rp 750rb)** |
| Sesi Berisiko | `atRiskSessions` | **2** |
| Pendapatan Bulan Ini | `monthlyEarnings` | **Rp 4,2jt** |

Each tile taps to filter the session list below. When tapped, it highlights as an active filter chip so the operator sees which filter is on.

Keep the greeting line ("Selamat Pagi, Sari!") but move the subtitle text into this strip.

**Layout:** A single horizontal row of 4 compact cards, each ~25% width. On narrow screens, 2x2 grid. Background matches surface color; the number is large, the label is small caption text below it.

**New model fields needed on `OrganizerDashboardStats`:**
- `totalUnpaidAmount` (int) — sum of Rupiah owed across all pending payments
- `revenueCollectedToday` (int) — already paid for today's sessions
- `revenueExpectedToday` (int) — total expected if all pay

---

### 2. Action Queue replaces flat "Perlu Perhatian"

The current `_ActionItemRow` shows a colored dot, title, subtitle, and a chevron. Every item looks identical. The operator cannot scan by category, cannot see money impact, and cannot act without navigating away.

Replace with grouped task cards:

**Pembayaran Tertunda** — 5 pemain · Rp 750.000 · [Ingatkan Semua]
**Kuota Rendah** — 2 sesi · Terdekat mulai 3 jam lagi · [Undang Pemain]
**Sengketa** — 1 kasus · [Selesaikan]

Each group shows:
- Category icon + label
- Count
- Money or time impact (whichever applies)
- One primary action button

Tapping the group expands to show individual items (current `_ActionItemRow` style). The primary button triggers the action without expanding.

**New model fields needed on `OrganizerActionItem`:**
- `amountImpact` (int?) — Rupiah value at stake
- `timeToStart` (Duration?) — how soon the related session starts

**Copy changes:**
- "Risiko kuota pada Badminton Sore" becomes "Kuota rendah: 1 slot lagi. Mulai 3 jam lagi. Kirim undangan?"
- "Pertimbangkan reminder atau reschedule" becomes the action button itself — no need to suggest what the user already knows.

---

### 3. Session list gets filters and a date toggle

The current list shows the next 5 sessions, no filtering, no date scope. At scale (20+ sessions/week across venues), this forces scrolling.

Add above the session list:

**Date toggle:** Hari Ini | Besok | Minggu Ini (default: Hari Ini)
**Filter chips:** Belum Bayar · Kuota Rendah · Sengketa · Terkonfirmasi
**Venue selector:** dropdown, only visible when the organizer manages 2+ venues.

The KPI strip taps also activate these filters. One unified filter state — never two separate systems.

Default view: today's sessions only. This alone cuts scroll length by 70-80% for active organizers.

---

### 4. Session cards show impact, not just labels

Current health chips say "2 belum bayar" — the operator does not know if that means Rp 200.000 or Rp 2.000.000.

Changes to `OrganizerSessionCard`:

**Add to health chips:**
- "2 belum bayar **(Rp 300rb)**" — show the money
- "Mulai 3 jam lagi" — show countdown, not just "Deadline segera"
- "1 slot lagi" — show remaining slots, not just "Kuota rendah"

**Add quick actions:**
Two visible buttons at card bottom (replacing single "Kelola" button):
- **Undang** (share icon) — copies/shares invite link
- **Ingatkan** (bell icon) — sends payment reminder to unpaid participants

Overflow menu (three-dot) for: Reschedule, Duplikat, Batalkan, Kelola (full detail).

**New fields needed on `SessionHealth`:**
- `pendingPaymentAmount` (int) — total Rupiah unpaid
- `slotsRemaining` (int) — `maxPlayers - currentPlayers` (computed, but useful for display text)
- `timeToStart` (Duration?) — time until session starts

---

### 5. Earnings snapshot becomes a tappable summary card

The current earnings row shows "Tersedia" and "Tertunda" side by side with a "Detail" text button. It works but looks like an afterthought at the bottom of the scroll.

Move it into a card with clearer breakdown:

| Label | Value | Color |
|-------|-------|-------|
| Tersedia | Rp 1.200.000 | success/green |
| Tertunda (pemain) | Rp 750.000 | warning/orange |
| Tertunda (venue) | Rp 300.000 | warning/orange |
| Dalam sengketa | Rp 150.000 | error/red |

Tapping the card opens the full earnings screen.

**New fields needed on `OrganizerEarningsSummary`:**
- `pendingPlayerBalance` (int) — pending because players have not paid
- `pendingVenueBalance` (int) — pending because venue has not confirmed
- `disputeHoldBalance` (int) — held due to active disputes

---

### 6. CTA stays, but becomes a floating action button

The current CTA banner ("Buat Sesi Baru") takes 100px+ of scroll height. At the bottom of the page, it is easy to miss. At the top, it pushes content down.

Replace with a standard Material FAB:
- Primary icon: `+` with label "Buat Sesi"
- Position: bottom-right, floating
- The gradient banner space is freed for content

---

## Section order (top to bottom)

1. **Greeting** — one line, "Selamat Pagi, Sari!"
2. **KPI strip** — 4 tiles, compact, tappable
3. **Action Queue** — grouped tasks, collapsed by default, 1-tap actions
4. **Date toggle + filter chips** — inline controls
5. **Session list** — filtered by date/status, cards with quick actions
6. **Earnings card** — tappable summary with 4-line breakdown
7. **FAB** — floating "Buat Sesi" button (always visible)

This order matches the operator's mental sequence: status first, urgent tasks second, sessions third, money fourth. The FAB floats above everything.

---

## What to skip (for now)

These items from the original feedback require backend decisions or scope beyond this pass:

- Weekly fill-rate and performance metrics (Section 10)
- Funnel tracking (views, joined, paid)
- Smart suggestions and auto-reschedule prompts
- Weather/closure alerts
- SLA timers for disputes
- "Revenue Today: Collected + Expected" as a KPI tile (business model unclear — commission vs flat fee)
- "Expected revenue next 7 days" and "Next payout date" in earnings (needs settlement schedule from backend)
- Server-side filtering (mock-first phase uses client-side)

---

## Model changes summary

```dart
// OrganizerDashboardStats — add:
int totalUnpaidAmount;        // sum of all pending payment Rupiah
int revenueCollectedToday;    // paid for today's sessions
int revenueExpectedToday;     // total expected for today

// OrganizerActionItem — add:
int? amountImpact;            // Rupiah at stake for this action
Duration? timeToStart;        // countdown to session start

// SessionHealth — add:
int pendingPaymentAmount;     // total Rupiah unpaid for this session
int slotsRemaining;           // maxPlayers - currentPlayers
Duration? timeToStart;        // time until session begins

// OrganizerEarningsSummary — add:
int pendingPlayerBalance;     // unpaid by players
int pendingVenueBalance;      // unconfirmed by venue
int disputeHoldBalance;       // held in dispute
```

---

## Acceptance criteria

1. The operator understands today's status in 10 seconds — KPI strip answers it without scrolling.
2. "Ingatkan belum bayar" takes 2 taps: one on the Action Queue button, one to confirm.
3. "Undang pemain" takes 2 taps: one on the session card's Undang button, one to share.
4. Action Queue groups tasks by category and shows count + money/time impact for each group.
5. Session cards show unpaid amount in Rupiah and countdown to start time.
6. Dashboard defaults to today's sessions. Date toggle and filter chips reduce scroll.
7. Earnings card shows 4 categories (available, pending-player, pending-venue, dispute).

---

## Implementation approach

Build these as separate widgets, each with its own provider:

| Widget | Provider | Data |
|--------|----------|------|
| `KpiStripWidget` | `organizerDashboardProvider` | Stats with new fields |
| `ActionQueueWidget` | `organizerActionInboxProvider` | Grouped action items |
| `SessionFilterBar` | local state (StateProvider) | Date toggle + chips |
| `OrganizerSessionCard` | (existing, modified) | Enhanced health display |
| `EarningsSnapshotCard` | `organizerEarningsProvider` | Expanded breakdown |

The dashboard screen assembles these widgets. Each can load, error, and refresh independently.
