# Backend Spec — Organizer Dashboard v2 (UI Redesign)

**Status:** Spec — backend implementation needed
**Owner:** Backend team
**Consumer:** Flutter app, organizer role, dashboard screen
**Linked design:** `docs/PRD-organizer-ui-improvement.md`, design package `r5w1x3RV2QjqJh_jTXimRQ`
**Created:** 2026-05-21

---

## Why

The organizer dashboard is being redesigned to lead with a **monthly-revenue hero** plus a **"today's pulse" snapshot** (sessions/coaches/players). The new layout needs 6 fields the current `/organizer/dashboard` response does not provide. Without them, the UI will hide the corresponding tiles (graceful degradation), but the dashboard's visual completeness depends on these landing.

All 6 fields are **derivable from existing tables** — no schema change. They are aggregations over `sessions`, `coaching_sessions`, `session_students`, `credit_ledger`, and `coaches`.

---

## Field list

Add to the existing `OrganizerDashboardStats` response (presumed endpoint: `GET /api/v1/organizer/dashboard` — verify with backend repo). Field names use the existing camelCase convention already in `OrganizerDashboardStats.fromJson`.

| Field | Type | Definition | SQL hint |
|---|---|---|---|
| `lastMonthEarnings` | int (Rp / sen) | Net earnings for the **previous** calendar month, in tenant currency unit | `SUM(net_revenue) WHERE month = previous_month AND tenant_id = ?` |
| `sessionsThisMonth` | int | Count of sessions held this calendar month, all statuses except `cancelled` | `COUNT(*) FROM coaching_sessions WHERE month = current_month AND status != 'cancelled'` |
| `coachesActiveToday` | int | Count of distinct coaches assigned to sessions starting today | `COUNT(DISTINCT coach_id) FROM coaching_sessions WHERE DATE(start_at) = CURRENT_DATE` |
| `coachesTotal` | int | Total active coaches in the club (not deleted, not suspended) | `COUNT(*) FROM coaches WHERE tenant_id = ? AND status = 'active'` |
| `playersBookedToday` | int | Distinct confirmed participants across today's sessions | `COUNT(DISTINCT user_id) FROM session_students JOIN coaching_sessions … WHERE DATE(start_at) = CURRENT_DATE AND status = 'confirmed'` |
| `hoursOnCourtToday` | int (hours, rounded) | Sum of durations of today's non-cancelled sessions, rounded to nearest hour | `ROUND(SUM(EXTRACT(EPOCH FROM (end_at - start_at)) / 3600)) WHERE DATE(start_at) = CURRENT_DATE AND status != 'cancelled'` |
| `unpaidMemberCount` | int | Distinct members with outstanding (unpaid) balance > 0 right now | `COUNT(DISTINCT user_id) FROM credit_ledger … WHERE balance < 0` (or equivalent unpaid-aggregation) |

> **All 6 fields should default to `0`** if the underlying data is empty (no sessions today, no coaches, etc.). Frontend model already uses `@Default(0)` semantics, so omitting a key is treated as zero.

---

## Updated example response

```json
{
  "stats": {
    // existing fields
    "sessionsToday": 3,
    "sessionsNext7Days": 8,
    "pendingPayments": 4,
    "averageParticipants": 6.2,
    "averageRating": 4.7,
    "monthlyEarnings": 22400000,
    "atRiskSessions": 1,
    "totalUnpaidAmount": 1350000,
    "revenueCollectedToday": 2450000,
    "revenueExpectedToday": 3800000,

    // NEW — add these
    "lastMonthEarnings": 19100000,
    "sessionsThisMonth": 24,
    "coachesActiveToday": 2,
    "coachesTotal": 7,
    "playersBookedToday": 26,
    "hoursOnCourtToday": 7,
    "unpaidMemberCount": 11
  }
}
```

---

## Frontend usage map

Cross-reference for backend reviewer: where each new field renders in the redesigned dashboard.

| Field | Renders as |
|---|---|
| `lastMonthEarnings` | Computed delta chip on hero: `+17.3% vs April`. Formula: `((monthlyEarnings - lastMonthEarnings) / lastMonthEarnings * 100)`. Frontend handles divide-by-zero. |
| `sessionsThisMonth` | Hero subtitle: `"24 sesi terselenggara"` |
| `coachesActiveToday` / `coachesTotal` | "Hari ini" KPI tile: `"Pelatih aktif · 2/7"` |
| `playersBookedToday` | "Hari ini" KPI tile: `"Pemain · 26"` |
| `hoursOnCourtToday` | Jadwal section subtitle: `"7 jam di lapangan"` |
| `unpaidMemberCount` | Glass split tile: `"Belum tertagih · Rp 1.4 jt · 11 anggota"` |

---

## Performance considerations

- All 6 aggregations should be **single-query additions** to the existing dashboard endpoint — do NOT add 6 separate roundtrips.
- Cache the entire dashboard response per `tenant_id` for ~60 seconds. The numbers tolerate slight staleness; what they cannot tolerate is the request-amplification cost of un-cached aggregation per app open.
- `unpaidMemberCount` and `playersBookedToday` involve joins — verify EXPLAIN ANALYZE on production-shaped data. If either pushes p95 > 500ms, add a partial index on `(tenant_id, status, date_trunc('day', start_at))`.

---

## Out of scope (deferred)

These were considered but not in this spec:
- **`attendanceRate` today** (% present out of confirmed) — would require waiting until sessions end before becoming meaningful. Skip.
- **Per-sport breakdown on hero** — explicitly removed by user during design iteration ("revenue per sport is not needed").
- **Settlement bar / payout flow surfacing** — handled by separate `OrganizerEarningsSummary` endpoint, no change.

---

*When this spec is implemented and deployed, the Flutter dashboard will automatically light up the hidden tiles via `if (value != null) show` checks already in place.*

---

# Addendum — Earnings Detail v2 (PR 3)

**Status:** Spec — backend implementation needed
**Consumer:** Flutter `OrganizerEarningsScreen` redesign
**Created:** 2026-05-21

## Why

The Earnings (Pendapatan) screen is being redesigned with three new sections that need data the current `OrganizerEarningsSummary` response does not provide:
1. **P&L summary card** — gross revenue, total expenses, net revenue, margin %
2. **Expense breakdown** — line items grouped by category with stacked bar
3. **Weekly bar chart** — 12 trailing-week net values for the hero card
4. **Delta caption** — `+X.X% vs bulan lalu` on the hero

All 4 are **aggregations over existing data** — no new tables. Add to the existing endpoint (presumed `GET /api/v1/organizer/earnings` — verify with backend repo).

## New fields

Extend the existing `OrganizerEarningsSummary` response.

| Field | Type | Definition | Notes |
|---|---|---|---|
| `grossRevenue` | int (smallest unit) | SUM of all session gross revenue for the active period | Per-period; defaults to current month |
| `totalExpenses` | int | SUM of all expense entries for the active period | Includes coach payouts, court rental, ball boy, equipment, custom |
| `netRevenueThisPeriod` | int | `grossRevenue − totalExpenses` | Computed server-side for consistency |
| `sessionCount` | int | COUNT of completed sessions in the active period | Excludes cancelled |
| `prevPeriodNet` | int | Net revenue for the **previous** equivalent period | Used to compute `+X.X% vs bulan lalu` chip |
| `weeklyChart` | array<float> | Net revenue per week for the last 12 weeks (oldest → newest), in millions of currency unit | E.g. `[3.2, 5.4, 4.1, 6.8, 8.2, 5.5, 7.1, 9.4, 6.7, 8.8, 10.2, 7.6]` — Rp 3.2jt, etc. Float to handle decimals nicely on small bars. |
| `expenseBreakdown` | array<object> | Top expense categories for the period | See sub-spec below |

### `expenseBreakdown[]` shape

```json
{
  "label": "Honor pelatih",
  "subtitle": "7 pelatih · 18 sesi",
  "amount": 5400000,
  "colorHex": "#EF4444",
  "icon": "🎾"
}
```

- `label` (required) — display string
- `subtitle` (optional) — secondary context line
- `amount` (required, int, smallest unit)
- `colorHex` (optional) — 7-char hex; client picks default if null
- `icon` (optional) — emoji or icon name; client picks default if null

The categories used by the design mockup:
| Category | Color hint | Icon hint |
|---|---|---|
| Honor pelatih | `#EF4444` | 🎾 |
| Sewa lapangan | `#F97316` | 🏟️ |
| Ball boy & wasit | `#F59E0B` | ⚖️ |
| Bola & perlengkapan | `#A78BFA` | ⚙️ |
| Lain-lain | `#94A3B8` | 🧾 |

(BE can leave color/icon null and the client will fall back to a fixed rotation.)

## Updated example response

```json
{
  "earnings": {
    "availableBalance": 14280000,
    "pendingBalance": 3650000,
    "paidOutThisMonth": 22400000,
    "settlements": [...],
    "pendingPlayerBalance": 0,
    "pendingVenueBalance": 0,
    "disputeHoldBalance": 0,

    "grossRevenue": 32100000,
    "totalExpenses": 9700000,
    "netRevenueThisPeriod": 22400000,
    "sessionCount": 24,
    "prevPeriodNet": 19100000,
    "weeklyChart": [3.2, 5.4, 4.1, 6.8, 8.2, 5.5, 7.1, 9.4, 6.7, 8.8, 10.2, 7.6],
    "expenseBreakdown": [
      {"label": "Honor pelatih", "subtitle": "7 pelatih · 18 sesi", "amount": 5400000, "colorHex": "#EF4444", "icon": "🎾"},
      {"label": "Sewa lapangan", "subtitle": "12 booking lapangan", "amount": 2800000, "colorHex": "#F97316", "icon": "🏟️"},
      {"label": "Ball boy & wasit", "subtitle": "24 sesi", "amount": 960000, "colorHex": "#F59E0B", "icon": "⚖️"},
      {"label": "Bola & perlengkapan", "subtitle": "Stok bulanan", "amount": 380000, "colorHex": "#A78BFA", "icon": "⚙️"},
      {"label": "Lain-lain", "subtitle": "Konsumsi, transport", "amount": 160000, "colorHex": "#94A3B8", "icon": "🧾"}
    ]
  }
}
```

## Frontend usage map

| Field | Renders as |
|---|---|
| `netRevenueThisPeriod` | Hero big number (replaces hero net which was a client-side fold) |
| `sessionCount` | Hero caption: `"dari N sesi"` |
| `prevPeriodNet` | Hero caption delta: `"+17.3% vs bulan lalu"`. Computed: `((netRevenueThisPeriod - prevPeriodNet) / prevPeriodNet * 100)` |
| `weeklyChart` | Hero card bar chart (12 weekly bars, last bar highlighted) |
| `grossRevenue`, `totalExpenses`, `netRevenueThisPeriod` | "Ringkasan bulan ini" P&L card |
| `expenseBreakdown[]` | "Rincian biaya" stacked bar + line items |

## Period awareness

The frontend has a period selector (Minggu Ini / Bulan Ini / Semua / Custom range). All 7 new fields above should respect a `period` query param the frontend sends with the request:
- `?period=week` — last 7 days
- `?period=month` — current calendar month (default)
- `?period=all` — lifetime
- `?period=custom&from=YYYY-MM-DD&to=YYYY-MM-DD` — explicit range

If the BE cannot do per-period aggregation in PR 1, return only the **month** values and document the limitation; the frontend will show the same numbers across all periods until per-period support lands.

## Performance

- Cache the full response per `(tenant_id, period)` tuple for 60s.
- `expenseBreakdown` is naturally bounded (~5-10 categories); no pagination needed.
- `weeklyChart` is 12 floats — cheap.
- All aggregations should run inside the same request; do not fan out.

---

*Same graceful-degradation contract: until BE deploys these fields, the P&L card, expense breakdown, bar chart, and delta caption will be hidden in the UI. Hero number, period chips, balance split, and settlement history continue to work using the existing fields.*

---

# Addendum — Member Detail v2 (PR 4a)

**Status:** Spec — backend implementation needed
**Consumer:** Flutter `OrganizerMemberDetailScreen` redesign
**Created:** 2026-05-21
**Endpoint:** existing `GET /v1/admin/students/{id}/detail`

## Why

The member detail screen is being redesigned around an outstanding-banner-front-and-center pattern with an aging progress bar. The existing `financial_stats` object provides amount + count, but not the **aging signal** (oldest unpaid days) needed to render the aging ramp, nor the **lifetime spend** for the new lifetime KPI tile.

## New fields

Extend `financial_stats` in the response.

| Field | Type | Definition | Notes |
|---|---|---|---|
| `oldest_unpaid_days` | int? (nullable) | Number of days since the oldest still-unpaid purchase was created | Null when `outstanding_count == 0` |
| `lifetime_spend` | int (smallest unit) | SUM of all paid purchases by this student, all time | Useful for "Lifetime" KPI tile |

## Frontend usage map

| Field | Renders as |
|---|---|
| `oldest_unpaid_days` | Aging progress bar on outstanding banner: `[0d ─ 14d (medium) ─ 30d (escalate)]` with fill ratio. Caption "tertua N hari". |
| `lifetime_spend` | Third KPI tile in the financial strip: "Lifetime" + compact Rp. |

## Updated example response

```json
{
  "student": {...},
  "financial_stats": {
    "paid_this_month": 750000,
    "outstanding_amount": 450000,
    "outstanding_count": 2,
    "total_transactions": 27,
    "oldest_unpaid_days": 14,
    "lifetime_spend": 6400000
  },
  "payment_history": [...],
  "recent_trend": [...],
  "skill_breakdown": [...],
  "session_history": [...]
}
```

## Out of scope (still client-side or design-strict-skip)

- "Sejak {month year}" pill on the hero — design suggests this; can be derived from `enrollment.enrolled_at` client-side if available, else hidden.
- "Level X.X" pill on the hero — derive from `student.enrollment.level_name`, hidden if missing.
- Streak (e.g. "3 days") — not requested; skip.

---

*Same graceful-degradation contract: until BE adds `oldest_unpaid_days` and `lifetime_spend`, the aging progress bar and lifetime KPI tile hide. Outstanding amount + count, paid-this-month, payment history, and all engagement/skill/session sections continue working.*
