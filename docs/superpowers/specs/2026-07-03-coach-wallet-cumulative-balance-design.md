# Coach Wallet — Saldo Kumulatif (Cumulative Balance) Design

**Date:** 2026-07-03
**Status:** Approved (approach + withdrawal behavior confirmed by user)
**Repos touched:** `hyperarena` (Flutter FE) + `hypercoach` (Laravel BE, branch `develop`)

## Problem

The Coach Wallet screen scopes *everything* to the selected month, including the
"Belum dicairkan" (undisbursed) figure. A coach who has undisbursed earnings in
April but is viewing May/July sees **Rp 0** and no hint that withdrawable money
exists in another month. Undisbursed earnings are only discoverable by manually
paging month-by-month. This is poor awareness: the coach may never realize they
have money to withdraw.

## Goal

Make undisbursed earnings **always visible as a cumulative (all-months) balance**,
independent of the selected month, and let the coach withdraw that whole balance
in one action.

## Non-Goals

- No change to how a payout is *earned* (session completion → `payouts` row).
- No change to the admin approval flow semantics (per-period requests remain).
- No per-session "cairkan" (still batch, matching current model).

## Decisions (confirmed with user)

1. **Model:** Cumulative balance (Option B), not just an awareness banner.
2. **Withdrawal:** "Cairkan semua sekaligus" — one button creates **one
   payout-request per outstanding period** (FE orchestrates multiple POSTs);
   backend request model stays per-period. Must handle partial failure.

## Current architecture (as-is)

**Backend (`develop`):**
- `GET /v1/coach/payouts/summary?period=YYYY-MM` → per-period buckets
  (`pending`=belum dicairkan/`request_id IS NULL`, `requested`=pending w/
  `request_id`, `approved`, `paid`) + `session_count` + `active_request_id`.
- `POST /v1/coach/payout-requests` `{period}` → `PayoutRequestService::createForCoach($coach, $period)`:
  in a transaction, bundles all `pending`+`request_id IS NULL` payouts of that
  period into one `payout_requests` row, stamps `request_id` on them. Throws
  `ActivePayoutRequestExistsException` if an active request already exists for
  that period; `DomainException` if there are no pending payouts.
- `payout_requests` table has a single `period` (YYYY-MM) column — inherently
  per-period.

**Frontend (`lib/features/wallet/`):**
- `walletPeriodProvider` (StateProvider<String>, default = current period).
- `walletSummaryProvider(period)` / `walletPayoutsProvider(period)` — autoDispose
  families, per-period.
- `CoachWalletScreen` composes: `WalletPeriodSelector` → `WalletHero` (per-month
  "TOTAL PENGHASILAN") → `WalletStatusChips` → `WalletWithdrawCta` → session list.

## Target architecture (to-be)

### Backend — new cumulative endpoint (additive, single responsibility)

`GET /v1/coach/payouts/balance` (coach-guarded, `view-own-payouts` permission).
Aggregates across **all periods** (no `period` filter). Uses the same
status-bucket definitions as `summary` for `requested`/`approved`/`paid`; the
`outstanding` bucket differs deliberately (K1 — excludes periods with an active
request), so it is NOT a plain sum of every month's `summary.pendingCents`.

Response contract:
```json
{
  "outstanding_cents": 300000,          // WITHDRAWABLE NOW — see K1 definition below
  "requested_cents": 0,                 // status=pending AND request_id IS NOT NULL, all periods
  "approved_cents": 0,                  // status=approved, all periods
  "paid_cents": 0,                      // status=paid, all periods
  "outstanding_session_count": 1,       // COUNT(DISTINCT session_id) among withdrawable payouts
  "outstanding_periods": ["2026-04"]    // periods (YYYY-MM) that are withdrawable now, ordered oldest→newest (asc)
}
```
- "Diproses" chip (FE) = `requested_cents + approved_cents`. "Sudah dicairkan"
  chip = `paid_cents`. "Belum dicairkan" chip = `outstanding_cents`.
- **K1 — `outstanding_cents` / `outstanding_periods` = *withdrawable now*:**
  `status='pending' AND request_id IS NULL`, **restricted to periods that do NOT
  already have an active (`pending|approved`) `payout_requests` row.** Rationale:
  `PayoutRequestService::createForCoach` throws `ActivePayoutRequestExistsException`
  for a period that already has an active request, so counting that period's
  pending money into the "Cairkan" total would show money the loop cannot
  actually request. Restricting to no-active-request periods makes the CTA amount
  exactly equal to what "Cairkan semua" will submit.
  - Consequence: a period that has BOTH an active request AND newly-earned pending
    payouts will have that new pending money excluded from `outstanding_cents`
    until the active request resolves. This differs slightly from the per-period
    `summary.pendingCents` (which ignores active requests). Accepted trade-off:
    monthly summary = "earned, not yet in any request"; cumulative balance =
    "withdrawable right now". **(Needs user confirmation.)**
- `total_earned_cents` intentionally OMITTED (K6 — YAGNI; hero shows outstanding,
  not lifetime earned). Add back only if a secondary "total penghasilan" line is
  wanted.
- Implemented as one grouped query (conditional SUMs, with the request-active
  exclusion applied to the pending bucket) + one query for the distinct
  withdrawable periods — no N+1.

Route registered under the `coach` prefix in `routes/api.php`, next to
`/payouts/summary`. New controller method `CoachPayoutController::balance()`.

### Frontend

**Providers (`wallet_providers.dart`):**
- New `walletBalanceProvider` — `FutureProvider.autoDispose<CoachPayoutBalance>`
  (NOT a family; global, month-independent).
- New model `CoachPayoutBalance` (Freezed) matching the contract above, with a
  `diprosesCents` getter (`requestedCents + approvedCents`) and
  `canWithdraw` getter (`outstandingCents > 0`), mirroring
  `CoachPayoutSummary`'s helper-getter style.
- Repository: `ApiWalletRepository.getBalance()` → `GET /v1/coach/payouts/balance`.

**Screen (`coach_wallet_screen.dart`) — recomposition:**
```
Hero            → cumulative "SALDO BELUM DICAIRKAN" (reads walletBalanceProvider)
StatusChips     → cumulative Belum/Diproses/Sudah (reads walletBalanceProvider)
WithdrawCta     → "Cairkan Rp <outstanding_cents>" (reads walletBalanceProvider)
── divider ──
"Riwayat Sesi"  + month selector moves here (reads walletPeriodProvider)
session list    → per-period (walletPayoutsProvider(period)), unchanged
```
- `WalletHero` reworked: label "SALDO BELUM DICAIRKAN", big = `outstanding_cents`,
  subtitle = `outstanding_session_count` sesi + oldest period ("sejak Apr 2026").
  Three states, all derivable from the balance payload (no `total_earned` needed):
  - `outstanding_cents > 0` → the balance.
  - `outstanding_cents == 0` AND `paid + requested + approved > 0` → positive
    state "Semua penghasilan sudah dicairkan 🎉".
  - all buckets 0 → neutral empty "Belum ada penghasilan."
- `WalletStatusChips` reads balance buckets instead of summary buckets.
- `WalletPeriodSelector` relocated under the "Riwayat Sesi" header; label clarifies
  it filters history only.
- Pull-to-refresh invalidates `walletBalanceProvider` + current-period providers.

**Withdrawal — "Cairkan semua sekaligus":**
- CTA amount = `outstanding_cents`; disabled when 0 or while a batch is in flight.
- On tap → confirm sheet → loop over `outstanding_periods`, `POST
  /payout-requests {period}` sequentially.
- **K2 — new batch provider, NOT the existing single-shot one.** The existing
  `payoutRequestActionProvider` submits one period and holds a single-valued
  `error`/`lastSuccess`; it cannot represent per-period outcomes. Add a new
  `payoutBatchRequestProvider` (Notifier) whose state carries a list of
  per-period results `{period, ok, reason?}` plus an `isRunning` flag. It calls
  `repository.requestWithdrawal(period)` (reused as-is) once per period.
- **Partial-failure handling:** collect per-period results. All succeed →
  success snackbar. Some fail → info snackbar "N dari M bulan berhasil diajukan"
  listing skipped periods + reason. A period that races into an
  `ActivePayoutRequestExistsException` (K1 should already exclude these, but a
  concurrent request can still occur) is a benign skip, not a hard error;
  a network/5xx error surfaces as a real failure for that period.
- **K5 — invalidation on completion:** invalidate `walletBalanceProvider` +
  `withdrawalHistoryProvider` + the currently-viewed `walletSummaryProvider(period)`
  and `walletPayoutsProvider(period)` (a just-requested period's session rows flip
  from "Belum dicairkan" → "Diproses").
- **K4 — confirmation sheet copy** changes from per-period ("Periode April 2026")
  to cumulative: "Cairkan seluruh saldo Rp X" + subline listing the N months
  covered (e.g. "Mencakup 2 bulan: April, Mei 2026") and the SLA note.

**K3 — in-flight requests disclosure (replaces single `_ActiveRequestPill`):**
The cumulative model can have multiple active requests (one per period), so there
is no single `active_request_id`. When `requested_cents + approved_cents > 0`,
show a disclosure "N permintaan sedang diproses → Lihat Riwayat" that deep-links
to the withdrawal **history list** screen (not a single request detail). The
per-request detail remains reachable by tapping a row in that list (existing
`withdrawal_request_row`).

### Data flow

```
balance endpoint ──> walletBalanceProvider ──> Hero / Chips / WithdrawCta / K3 disclosure
payouts(period)  ──> session list (Riwayat Sesi), per selected month
summary(period)  ──> no longer drives the hero; kept only if a per-month subtotal
                     is later added to the Riwayat Sesi header (not in v1)
Cairkan tap ──> payoutBatchRequestProvider.run(outstanding_periods)
            ──> per-period POST (sequential)
            ──> invalidate walletBalanceProvider + withdrawalHistoryProvider
                + walletSummaryProvider(period) + walletPayoutsProvider(period)
```

### Error handling

- Balance endpoint failure → hero shows the same error/retry pattern already used
  for summary; history section can load independently.
- Withdrawal error on one period → **do not abort the batch**; record that period
  as failed and continue to the next (other months may still succeed). Report the
  aggregate outcome at the end (K2 partial-failure). No local optimistic mutation
  (server is source of truth) — always re-fetch `walletBalanceProvider` after the
  batch, whatever the mix of outcomes.

### Testing

- **Backend:** feature test for `/payouts/balance` — seeds payouts across ≥2
  periods with mixed statuses; asserts each bucket, `outstanding_session_count`,
  and `outstanding_periods` ordering. **K1 edge:** a period that has an active
  `payout_requests` row AND a newer `request_id IS NULL` pending payout is
  EXCLUDED from `outstanding_cents`/`outstanding_periods` (its requested part
  still counts in `requested_cents`). Auth/permission (403 without
  `view-own-payouts`, 404 no coach profile).
- **Frontend:**
  - `CoachPayoutBalance` JSON round-trip + `diprosesCents`/`canWithdraw` getters.
  - `walletBalanceProvider` maps repo → model.
  - Widget test: Hero/Chips render cumulative values; zero-outstanding positive
    empty state ("Semua penghasilan sudah dicairkan"); CTA disabled at 0;
    K3 disclosure appears when `diprosesCents > 0`.
  - `payoutBatchRequestProvider` unit test: all-success; partial-failure (one
    period races to already-active → benign skip); network error mid-loop →
    structured per-period outcome + correct invalidations.

## Rollout / safety

- Backend change is purely additive (new read endpoint + new controller method +
  one route). No migration, no change to existing endpoints.
- FE reads a new provider; existing per-period providers remain for the history
  section. No breaking change to the withdrawal POST contract.
