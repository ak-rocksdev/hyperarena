# Coach Wallet — Cumulative Balance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make coach undisbursed earnings always visible as an all-months cumulative balance, and let the coach withdraw the whole balance in one action.

**Architecture:** New additive backend read endpoint `GET /v1/coach/payouts/balance` aggregates buckets across all periods (withdrawable-now definition per design K1). A new Flutter `walletBalanceProvider` (global, non-family) drives the hero, status chips, and withdraw CTA; the month selector demotes to a "Riwayat Sesi" filter. "Cairkan" orchestrates one POST per outstanding period via a new batch provider with per-period outcome tracking.

**Tech Stack:** Laravel 12 / PHPUnit 11 (backend, `hypercoach` repo, branch `develop`); Flutter 3.44 / Dart 3.12, Riverpod, Freezed + json_serializable, Dio (frontend, `hyperarena` repo).

## Global Constraints

- **Two repos.** Backend = `/Users/abdulkadir/Projects/Dev/Web/hypercoach` (already on branch `develop`; commit there). Frontend = `/Users/abdulkadir/Projects/Dev/Mobile/hyperarena` (create branch `feature/wallet-cumulative-balance` off `main` before Task 2).
- **Money is integer cents/sen** everywhere. Never floats.
- **Copy is Indonesian**, sentence case, matching existing wallet strings.
- **`outstanding` = withdrawable now** (design K1): `status='pending' AND request_id IS NULL AND period NOT IN (periods having an active pending|approved payout_request)`.
- **Balance payload keys (snake_case):** `outstanding_cents`, `requested_cents`, `approved_cents`, `paid_cents`, `outstanding_session_count`, `outstanding_periods` (array of `YYYY-MM`, ascending). No `total_earned_cents` (design K6).
- **"Diproses" (FE) = `requestedCents + approvedCents`.** "Belum dicairkan" = `outstandingCents`. "Sudah dicairkan" = `paidCents`.
- **Batch withdrawal never aborts on one failure** — record per-period outcome, continue, report aggregate.
- Backend agg queries must be N+1-free (grouped conditional SUMs / single pluck).
- After editing any Freezed model, run `dart run build_runner build --delete-conflicting-outputs`.
- FE run/verify uses the Herd backend on `develop`; Android emulator `emulator-5554`, iOS sim per memory.

---

### Task 1: Backend — `GET /v1/coach/payouts/balance` endpoint

**Files:**
- Modify: `app/Http/Controllers/Coach/PayoutController.php` (add `balance()`; add `use App\Models\PayoutRequest;`)
- Modify: `routes/api.php:487` (register route next to `/payouts/summary`)
- Test: `tests/Feature/Wallet/CoachPayoutBalanceEndpointTest.php` (create)

**Interfaces:**
- Produces HTTP: `GET /v1/coach/payouts/balance` → JSON `{outstanding_cents, requested_cents, approved_cents, paid_cents, outstanding_session_count, outstanding_periods[]}`. Guarded by `permission:view-own-payouts`.

- [ ] **Step 1: Write the failing test**

Create `tests/Feature/Wallet/CoachPayoutBalanceEndpointTest.php` (mirrors `CoachPayoutRequestEndpointTest` setUp/helpers):

```php
<?php

namespace Tests\Feature\Wallet;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Session;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CoachPayoutBalanceEndpointTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private Coach $coach;
    private User $coachUser;
    private string $baseUrl;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleAndPermissionSeeder::class);

        $this->tenant = Tenant::create([
            'name' => 'Test', 'slug' => 'test',
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $this->tenant->id, 'plan_id' => $plan->id,
            'status' => 'active', 'started_at' => now(),
        ]);
        $this->coachUser = User::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'Coach', 'email' => 'c@x.com', 'password' => bcrypt('p'),
        ]);
        $this->coachUser->assignRole('coach');
        $this->coach = Coach::create([
            'tenant_id' => $this->tenant->id, 'user_id' => $this->coachUser->id, 'status' => 'active',
        ]);
        $this->baseUrl = 'http://test.hypercoach.local/api/v1';
    }

    private function pendingPayout(string $period, int $amount): Payout
    {
        $session = Session::create([
            'tenant_id' => $this->tenant->id, 'type' => 'group',
            'start_at' => now()->subDays(1), 'duration_minutes' => 60, 'capacity' => 10, 'status' => 'completed',
        ]);
        return Payout::create([
            'tenant_id' => $this->tenant->id, 'coach_id' => $this->coach->id, 'session_id' => $session->id,
            'rate_applied' => $amount, 'amount' => $amount, 'currency' => 'IDR',
            'period' => $period, 'status' => 'pending',
        ]);
    }

    public function test_balance_sums_outstanding_across_periods(): void
    {
        $this->pendingPayout('2026-04', 300000);
        $this->pendingPayout('2026-05', 150000);
        Sanctum::actingAs($this->coachUser);

        $res = $this->getJson("{$this->baseUrl}/coach/payouts/balance");

        $res->assertOk()
            ->assertJsonPath('outstanding_cents', 450000)
            ->assertJsonPath('outstanding_session_count', 2)
            ->assertJsonPath('requested_cents', 0)
            ->assertJsonPath('paid_cents', 0);
        $this->assertSame(['2026-04', '2026-05'], $res->json('outstanding_periods'));
    }

    public function test_period_with_active_request_excluded_from_outstanding(): void
    {
        // April gets a request (active), then earns a NEW pending payout.
        $this->pendingPayout('2026-04', 300000);
        Sanctum::actingAs($this->coachUser);
        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-04'])->assertCreated();
        $this->pendingPayout('2026-04', 50000);   // new, unrequested, but April is now active
        $this->pendingPayout('2026-05', 150000);

        $res = $this->getJson("{$this->baseUrl}/coach/payouts/balance");

        $res->assertOk()
            ->assertJsonPath('outstanding_cents', 150000)  // only May is withdrawable
            ->assertJsonPath('requested_cents', 300000);   // April's requested part
        $this->assertSame(['2026-05'], $res->json('outstanding_periods'));
    }

    public function test_requires_view_own_payouts_permission(): void
    {
        $this->coachUser->syncRoles(['member']);
        app()['cache']->forget('spatie.permission.cache');
        Sanctum::actingAs($this->coachUser);

        $this->getJson("{$this->baseUrl}/coach/payouts/balance")->assertForbidden();
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /Users/abdulkadir/Projects/Dev/Web/hypercoach && php artisan test --filter=CoachPayoutBalanceEndpointTest`
Expected: FAIL (route not defined → 404, assertions fail).

- [ ] **Step 3: Add the route**

In `routes/api.php`, immediately after the existing `/payouts/summary` route (line ~488), add:

```php
        Route::get('/payouts/balance', [CoachPayoutController::class, 'balance'])
            ->middleware('permission:view-own-payouts');
```

- [ ] **Step 4: Implement `balance()`**

In `app/Http/Controllers/Coach/PayoutController.php`, add `use App\Models\PayoutRequest;` to the imports, then add this method after `summary()`:

```php
    public function balance(Request $request): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('view-own-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $coach = Coach::where('user_id', $request->user()->id)->first();
        if (! $coach) {
            return response()->json(['message' => 'Coach profile not found.'], 404);
        }

        // Periods that already have an active (pending|approved) request — their
        // pending payouts cannot be re-requested, so they are excluded from the
        // withdrawable "outstanding" bucket (design K1).
        $activePeriods = PayoutRequest::where('coach_id', $coach->id)
            ->whereIn('status', ['pending', 'approved'])
            ->pluck('period')
            ->all();

        // requested / approved / paid — across ALL periods, one grouped query.
        $row = Payout::where('coach_id', $coach->id)
            ->selectRaw(
                "COALESCE(SUM(CASE WHEN status = 'pending' AND request_id IS NOT NULL THEN amount ELSE 0 END), 0) as requested_cents, "
                ."COALESCE(SUM(CASE WHEN status = 'approved' THEN amount ELSE 0 END), 0) as approved_cents, "
                ."COALESCE(SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END), 0) as paid_cents"
            )
            ->first();

        // Withdrawable now: pending, unrequested, not in an active-request period.
        $outstanding = Payout::where('coach_id', $coach->id)
            ->where('status', 'pending')
            ->whereNull('request_id')
            ->when(! empty($activePeriods), fn ($q) => $q->whereNotIn('period', $activePeriods));

        $outstandingPeriods = (clone $outstanding)
            ->distinct()->orderBy('period')->pluck('period')->all();

        return response()->json([
            'outstanding_cents' => (int) (clone $outstanding)->sum('amount'),
            'requested_cents' => (int) ($row->requested_cents ?? 0),
            'approved_cents' => (int) ($row->approved_cents ?? 0),
            'paid_cents' => (int) ($row->paid_cents ?? 0),
            'outstanding_session_count' => (int) (clone $outstanding)->distinct()->count('session_id'),
            'outstanding_periods' => $outstandingPeriods,
        ]);
    }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `php artisan test --filter=CoachPayoutBalanceEndpointTest`
Expected: PASS (3 tests).

- [ ] **Step 6: Clear route cache + smoke-test via curl**

```bash
php artisan optimize:clear
TOKEN="96|AZnbv9Up90Poh5x5txUi2kqfuXb9qDIhPAa67bE755b639c1"
curl -s "http://hypercoach.test/api/v1/coach/payouts/balance" \
  -H "Accept: application/json" -H "X-Tenant: petenis-kelana" -H "Authorization: Bearer $TOKEN"
```
Expected: JSON with `outstanding_cents: 300000`, `outstanding_periods: ["2026-04"]` (matches April seed).

- [ ] **Step 7: Commit**

```bash
cd /Users/abdulkadir/Projects/Dev/Web/hypercoach
git add app/Http/Controllers/Coach/PayoutController.php routes/api.php tests/Feature/Wallet/CoachPayoutBalanceEndpointTest.php
git commit -m "feat(coach-wallet): add cumulative /payouts/balance endpoint"
```

---

### Task 2: FE — `CoachPayoutBalance` model

**Files:**
- Create: `lib/features/wallet/data/models/coach_payout_balance.dart` (+ generated `.freezed.dart`/`.g.dart`)
- Test: `test/features/wallet/models/coach_payout_balance_test.dart` (create)

**Interfaces:**
- Produces: `CoachPayoutBalance` with fields `outstandingCents, requestedCents, approvedCents, paidCents, outstandingSessionCount, outstandingPeriods (List<String>)` and getters `diprosesCents`, `canWithdraw`, `hasAnyActivity`. `CoachPayoutBalance.fromJson`.

- [ ] **Step 1: Create the branch**

```bash
cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena
git checkout -b feature/wallet-cumulative-balance
```

- [ ] **Step 2: Write the failing test**

Create `test/features/wallet/models/coach_payout_balance_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';

void main() {
  test('fromJson maps all buckets + derived getters', () {
    final b = CoachPayoutBalance.fromJson({
      'outstanding_cents': 450000,
      'requested_cents': 100000,
      'approved_cents': 50000,
      'paid_cents': 200000,
      'outstanding_session_count': 2,
      'outstanding_periods': ['2026-04', '2026-05'],
    });

    expect(b.outstandingCents, 450000);
    expect(b.diprosesCents, 150000); // requested + approved
    expect(b.paidCents, 200000);
    expect(b.outstandingPeriods, ['2026-04', '2026-05']);
    expect(b.canWithdraw, isTrue);
    expect(b.hasAnyActivity, isTrue);
  });

  test('defaults tolerate a sparse payload', () {
    final b = CoachPayoutBalance.fromJson({'outstanding_cents': 0});
    expect(b.outstandingCents, 0);
    expect(b.outstandingPeriods, isEmpty);
    expect(b.canWithdraw, isFalse);
    expect(b.hasAnyActivity, isFalse);
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/wallet/models/coach_payout_balance_test.dart`
Expected: FAIL (target of URI doesn't exist — model not created).

- [ ] **Step 4: Create the model**

Create `lib/features/wallet/data/models/coach_payout_balance.dart`:

```dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout_balance.freezed.dart';
part 'coach_payout_balance.g.dart';

/// Cumulative (all-months) wallet balance. Unlike [CoachPayoutSummary] which is
/// per-period, this drives the always-visible hero / chips / withdraw CTA.
///
/// `outstandingCents` is "withdrawable now" — pending, unrequested, and NOT in a
/// period that already has an active request (design K1). So it is not a plain
/// sum of each month's `summary.pendingCents`.
@freezed
class CoachPayoutBalance with _$CoachPayoutBalance {
  const factory CoachPayoutBalance({
    @JsonKey(name: 'outstanding_cents') @Default(0) int outstandingCents,
    @JsonKey(name: 'requested_cents') @Default(0) int requestedCents,
    @JsonKey(name: 'approved_cents') @Default(0) int approvedCents,
    @JsonKey(name: 'paid_cents') @Default(0) int paidCents,
    @JsonKey(name: 'outstanding_session_count')
    @Default(0)
    int outstandingSessionCount,
    @JsonKey(name: 'outstanding_periods')
    @Default(<String>[])
    List<String> outstandingPeriods,
  }) = _CoachPayoutBalance;

  const CoachPayoutBalance._();

  /// "Diproses" chip — money out of the coach's hands (requested or approved).
  int get diprosesCents => requestedCents + approvedCents;

  bool get canWithdraw => outstandingCents > 0;

  /// True if the coach has ANY lifetime payout activity — distinguishes the
  /// "all withdrawn 🎉" hero state from the "never earned" state.
  bool get hasAnyActivity =>
      outstandingCents + requestedCents + approvedCents + paidCents > 0;

  factory CoachPayoutBalance.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutBalanceFromJson(json);
}
```

- [ ] **Step 5: Generate Freezed code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: creates `coach_payout_balance.freezed.dart` + `coach_payout_balance.g.dart`, no errors.

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/features/wallet/models/coach_payout_balance_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 7: Commit**

```bash
git add lib/features/wallet/data/models/coach_payout_balance.dart lib/features/wallet/data/models/coach_payout_balance.freezed.dart lib/features/wallet/data/models/coach_payout_balance.g.dart test/features/wallet/models/coach_payout_balance_test.dart
git commit -m "feat(wallet): add CoachPayoutBalance model"
```

---

### Task 3: FE — repository `getBalance()` + `walletBalanceProvider`

**Files:**
- Modify: `lib/features/wallet/data/api_wallet_repository.dart` (add `getBalance()`; add import)
- Modify: `lib/features/wallet/providers/wallet_providers.dart` (add `walletBalanceProvider`; add import)
- Test: `test/features/wallet/providers/wallet_balance_provider_test.dart` (create)

**Interfaces:**
- Consumes: `CoachPayoutBalance` (Task 2), `walletRepositoryProvider` (existing).
- Produces: `ApiWalletRepository.getBalance() → Future<CoachPayoutBalance>`; `walletBalanceProvider` (`FutureProvider.autoDispose<CoachPayoutBalance>`).

- [ ] **Step 1: Write the failing test**

Create `test/features/wallet/providers/wallet_balance_provider_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class _FakeRepo implements ApiWalletRepository {
  @override
  Future<CoachPayoutBalance> getBalance() async =>
      const CoachPayoutBalance(outstandingCents: 300000, outstandingPeriods: ['2026-04']);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('walletBalanceProvider returns repo balance', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(_FakeRepo()),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(walletBalanceProvider.future);
    expect(result.outstandingCents, 300000);
    expect(result.outstandingPeriods, ['2026-04']);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/wallet/providers/wallet_balance_provider_test.dart`
Expected: FAIL (`getBalance` / `walletBalanceProvider` undefined).

- [ ] **Step 3: Add `getBalance()` to the repository**

In `lib/features/wallet/data/api_wallet_repository.dart`, add the import at the top:

```dart
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
```

Then add this method after `getSummary()`:

```dart
  /// `GET /v1/coach/payouts/balance` — cumulative all-months buckets +
  /// withdrawable periods. Drives the always-visible hero / chips / CTA.
  Future<CoachPayoutBalance> getBalance() async {
    try {
      final res = await _apiClient.get('/v1/coach/payouts/balance');
      return CoachPayoutBalance.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
```

- [ ] **Step 4: Add `walletBalanceProvider`**

In `lib/features/wallet/providers/wallet_providers.dart`, add the import:

```dart
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
```

Then add after `walletPayoutsProvider` (line ~42):

```dart
/// Cumulative all-months balance — global (NOT a family), month-independent.
/// Drives the hero, status chips, and withdraw CTA.
final walletBalanceProvider =
    FutureProvider.autoDispose<CoachPayoutBalance>((ref) async {
  return ref.watch(walletRepositoryProvider).getBalance();
});
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/wallet/providers/wallet_balance_provider_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/features/wallet/data/api_wallet_repository.dart lib/features/wallet/providers/wallet_providers.dart test/features/wallet/providers/wallet_balance_provider_test.dart
git commit -m "feat(wallet): add getBalance() repo method + walletBalanceProvider"
```

---

### Task 4: FE — batch withdrawal provider (`payoutBatchRequestProvider`)

**Files:**
- Modify: `lib/features/wallet/providers/wallet_providers.dart` (add state classes + notifier + provider)
- Test: `test/features/wallet/providers/payout_batch_request_test.dart` (create)

**Interfaces:**
- Consumes: `walletRepositoryProvider.requestWithdrawal(period)` (existing), `walletBalanceProvider`/`withdrawalHistoryProvider`/`walletSummaryProvider`/`walletPayoutsProvider` (for invalidation).
- Produces: `BatchPeriodResult {period, ok, reason?}`; `PayoutBatchState {isRunning, results, okCount, total, allOk, anyFailed}`; `PayoutBatchNotifier.run(List<String> periods, {required String currentPeriod}) → Future<PayoutBatchState>` and `.clear()`; `payoutBatchRequestProvider`.

- [ ] **Step 1: Write the failing test**

Create `test/features/wallet/providers/payout_batch_request_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class _FakeRepo implements ApiWalletRepository {
  _FakeRepo(this._behavior);
  final Future<PayoutRequest> Function(String period) _behavior;

  @override
  Future<PayoutRequest> requestWithdrawal(String period) => _behavior(period);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PayoutRequest _dummy(String period) => PayoutRequest(
      id: 1,
      period: period,
      totalAmountCents: 0,
      status: 'pending',
      requestedAt: DateTime(2026),
    );

void main() {
  test('run: all periods succeed', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async => _dummy(p)),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run(['2026-04', '2026-05'], currentPeriod: '2026-07');

    expect(state.allOk, isTrue);
    expect(state.okCount, 2);
    expect(state.isRunning, isFalse);
  });

  test('run: one period fails, batch continues and reports it', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async {
          if (p == '2026-05') throw Exception('active request exists');
          return _dummy(p);
        }),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run(['2026-04', '2026-05', '2026-06'], currentPeriod: '2026-07');

    expect(state.okCount, 2);
    expect(state.anyFailed, isTrue);
    expect(state.total, 3);
    final failed = state.results.firstWhere((r) => !r.ok);
    expect(failed.period, '2026-05');
    expect(failed.reason, contains('active request'));
  });

  test('run: empty periods is a no-op', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async => _dummy(p)),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run([], currentPeriod: '2026-07');

    expect(state.total, 0);
    expect(state.isRunning, isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/wallet/providers/payout_batch_request_test.dart`
Expected: FAIL (`payoutBatchRequestProvider` undefined).

- [ ] **Step 3: Implement the batch provider**

In `lib/features/wallet/providers/wallet_providers.dart`, add after `payoutRequestActionProvider` (line ~97):

```dart
// ──────────────────────────────────────────────────────────────────────────
// Batch withdrawal — "Cairkan semua sekaligus"
//
// The cumulative model withdraws every outstanding period in one tap. The BE
// request model is per-period, so we POST once per period. We NEVER abort on a
// single failure (e.g. a period that raced into an active request): record the
// per-period outcome and continue, then report the aggregate.

class BatchPeriodResult {
  const BatchPeriodResult({required this.period, required this.ok, this.reason});
  final String period;
  final bool ok;
  final String? reason; // null when ok
}

class PayoutBatchState {
  const PayoutBatchState({this.isRunning = false, this.results = const []});
  final bool isRunning;
  final List<BatchPeriodResult> results;

  int get okCount => results.where((r) => r.ok).length;
  int get total => results.length;
  bool get allOk => results.isNotEmpty && results.every((r) => r.ok);
  bool get anyFailed => results.any((r) => !r.ok);
}

class PayoutBatchNotifier extends Notifier<PayoutBatchState> {
  @override
  PayoutBatchState build() => const PayoutBatchState();

  /// POSTs one payout-request per period, sequentially. Returns the final state.
  /// `currentPeriod` is the month currently shown in Riwayat Sesi — its
  /// per-period providers are invalidated too so its rows reflect the new
  /// "Diproses" status.
  Future<PayoutBatchState> run(
    List<String> periods, {
    required String currentPeriod,
  }) async {
    if (periods.isEmpty) return state;

    state = const PayoutBatchState(isRunning: true);
    final repo = ref.read(walletRepositoryProvider);
    final results = <BatchPeriodResult>[];

    for (final period in periods) {
      try {
        await repo.requestWithdrawal(period);
        results.add(BatchPeriodResult(period: period, ok: true));
      } catch (e) {
        results.add(
          BatchPeriodResult(period: period, ok: false, reason: e.toString()),
        );
      }
    }

    // Server is source of truth — re-fetch everything that could have changed.
    ref.invalidate(walletBalanceProvider);
    ref.invalidate(withdrawalHistoryProvider);
    ref.invalidate(walletSummaryProvider(currentPeriod));
    ref.invalidate(walletPayoutsProvider(currentPeriod));

    state = PayoutBatchState(isRunning: false, results: results);
    return state;
  }

  void clear() => state = const PayoutBatchState();
}

final payoutBatchRequestProvider =
    NotifierProvider<PayoutBatchNotifier, PayoutBatchState>(
  PayoutBatchNotifier.new,
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/wallet/providers/payout_batch_request_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/wallet/providers/wallet_providers.dart test/features/wallet/providers/payout_batch_request_test.dart
git commit -m "feat(wallet): add payoutBatchRequestProvider for cairkan-semua"
```

---

### Task 5: FE — `WalletPeriod.shortLabel` + rewire `WalletHero` to balance

**Files:**
- Modify: `lib/features/wallet/utils/wallet_period.dart` (add `shortLabel`)
- Modify: `lib/features/wallet/presentation/widgets/wallet_hero.dart` (read `walletBalanceProvider`; new label + 3 states)
- Test: `test/features/wallet/utils/wallet_period_test.dart` (create — shortLabel only)

**Interfaces:**
- Consumes: `walletBalanceProvider` (Task 3), `CoachPayoutBalance` getters (Task 2).
- Produces: `WalletPeriod.shortLabel(String period) → String` ("Apr 2026").

- [ ] **Step 1: Write the failing test**

Create `test/features/wallet/utils/wallet_period_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/utils/wallet_period.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  test('shortLabel formats YYYY-MM to "MMM yyyy" id', () {
    expect(WalletPeriod.shortLabel('2026-04'), 'Apr 2026');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/wallet/utils/wallet_period_test.dart`
Expected: FAIL (`shortLabel` undefined).

- [ ] **Step 3: Add `shortLabel`**

In `lib/features/wallet/utils/wallet_period.dart`, add after `longLabel`:

```dart
  /// "Apr 2026" — short Indonesian period label. Used by the hero subtitle
  /// ("sejak Apr 2026").
  static String shortLabel(String period) =>
      DateFormat.yMMM('id').format(parseOrNow(period));
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/wallet/utils/wallet_period_test.dart`
Expected: PASS.

- [ ] **Step 5: Rewire `WalletHero` to the cumulative balance**

Replace the body of `lib/features/wallet/presentation/widgets/wallet_hero.dart` with the version below. Changes: watch `walletBalanceProvider` instead of `walletSummaryProvider(period)`; label → "SALDO BELUM DICAIRKAN"; number → `outstandingCents`; subtitle → session count + oldest outstanding period; three states.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:hyperarena/features/wallet/utils/wallet_period.dart';

/// The wallet's emotional anchor: a teal gradient hero. Shows the coach's
/// CUMULATIVE (all-months) withdrawable balance, not the selected month — so a
/// coach always sees money waiting regardless of which month they browse.
class WalletHero extends ConsumerWidget {
  const WalletHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppSurfaces.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
          boxShadow: AppShadows.colored,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -32,
              right: -32,
              child: _decorativeCircle(120, alpha: 0.08),
            ),
            Positioned(
              top: 24,
              right: 56,
              child: _decorativeCircle(40, alpha: 0.06),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: balanceAsync.when(
                data: (balance) => _HeroContent(
                  balance: balance,
                  currency: currency,
                ),
                loading: () => const _HeroSkeleton(),
                error: (_, _) => _HeroError(
                  onRetry: () => ref.invalidate(walletBalanceProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _decorativeCircle(double size, {required double alpha}) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      );
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.balance, required this.currency});
  final CoachPayoutBalance balance;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final split = Formatters.splitCurrency(balance.outstandingCents, currency);
    final oldestPeriod = balance.outstandingPeriods.isNotEmpty
        ? balance.outstandingPeriods.first
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.account_balance_wallet_rounded,
                size: 14, color: Colors.white),
            const SizedBox(width: AppDimensions.xs),
            Text(
              'SALDO BELUM DICAIRKAN',
              style: AppTypography.overline.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                split.prefix,
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                child: Text(
                  split.number,
                  style: AppTypography.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        _subtitle(oldestPeriod),
      ],
    );
  }

  Widget _subtitle(String? oldestPeriod) {
    // State 1: money waiting.
    if (balance.canWithdraw) {
      final since =
          oldestPeriod != null ? ' · sejak ${WalletPeriod.shortLabel(oldestPeriod)}' : '';
      return _pill(
        icon: Icons.event_rounded,
        label: '${balance.outstandingSessionCount} sesi$since',
      );
    }
    // State 2: had earnings, all withdrawn.
    if (balance.hasAnyActivity) {
      return _pill(
        icon: Icons.check_circle_rounded,
        label: 'Semua penghasilan sudah dicairkan',
      );
    }
    // State 3: never earned.
    return _pill(
      icon: Icons.hourglass_empty_rounded,
      label: 'Belum ada penghasilan',
    );
  }

  Widget _pill({required IconData icon, required String label}) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar(double w, double h, {double opacity = 0.18}) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(140, 10),
        const SizedBox(height: AppDimensions.lg),
        bar(220, 36),
        const SizedBox(height: AppDimensions.md),
        bar(120, 24),
      ],
    );
  }
}

class _HeroError extends StatelessWidget {
  const _HeroError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cloud_off_rounded, color: Colors.white, size: 28),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gagal memuat saldo',
                style: AppTypography.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Periksa koneksi dan coba lagi.',
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.16),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          child: const Text('Ulangi'),
        ),
      ],
    );
  }
}
```

- [ ] **Step 6: Analyze + run all wallet tests**

Run: `flutter analyze lib/features/wallet && flutter test test/features/wallet/`
Expected: no analyzer errors; existing + new tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/features/wallet/utils/wallet_period.dart lib/features/wallet/presentation/widgets/wallet_hero.dart test/features/wallet/utils/wallet_period_test.dart
git commit -m "feat(wallet): hero shows cumulative belum-dicairkan balance"
```

---

### Task 6: FE — rewire `WalletStatusChips` to balance

**Files:**
- Modify: `lib/features/wallet/presentation/widgets/wallet_status_chips.dart`

**Interfaces:**
- Consumes: `walletBalanceProvider`, `CoachPayoutBalance` getters.

- [ ] **Step 1: Rewire the chips**

In `lib/features/wallet/presentation/widgets/wallet_status_chips.dart`:

1. Replace the import `coach_payout_summary.dart` with `coach_payout_balance.dart`.
2. In `build`, replace the two lines
   ```dart
   final period = ref.watch(walletPeriodProvider);
   final summaryAsync = ref.watch(walletSummaryProvider(period));
   ```
   with
   ```dart
   final balanceAsync = ref.watch(walletBalanceProvider);
   ```
   and change `summaryAsync.when(data: (summary) => _row(summary, currency), ...)`
   to `balanceAsync.when(data: (balance) => _row(balance, currency), ...)`.
3. Replace `_row`'s signature + body:

```dart
  Widget _row(CoachPayoutBalance balance, String currency) {
    if (!balance.hasAnyActivity) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Expanded(
          child: _Chip(
            label: 'Belum dicairkan',
            amount: balance.outstandingCents,
            currency: currency,
            dotColor: AppColors.warning,
            isLeading: true,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Chip(
            label: 'Diproses',
            amount: balance.diprosesCents,
            currency: currency,
            dotColor: AppColors.neutral400,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Chip(
            label: 'Sudah dicairkan',
            amount: balance.paidCents,
            currency: currency,
            dotColor: AppColors.success,
          ),
        ),
      ],
    );
  }
```

(`_Chip` is unchanged.)

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/features/wallet/presentation/widgets/wallet_status_chips.dart`
Expected: no errors (no lingering `walletPeriodProvider`/`walletSummaryProvider`/`CoachPayoutSummary` references).

- [ ] **Step 3: Commit**

```bash
git add lib/features/wallet/presentation/widgets/wallet_status_chips.dart
git commit -m "feat(wallet): status chips read cumulative balance"
```

---

### Task 7: FE — rewire `WalletWithdrawCta` (batch cairkan + K3 disclosure + K4 copy)

**Files:**
- Modify: `lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart`
- Test: `test/features/wallet/widgets/wallet_withdraw_cta_test.dart` (create — button visibility by state)

**Interfaces:**
- Consumes: `walletBalanceProvider`, `payoutBatchRequestProvider` (Task 4), `walletPeriodProvider` (for `currentPeriod`), `WalletPeriod.longLabel`, `Formatters.formatCurrency`, `AppRoutes.coachWithdrawalHistory`.

- [ ] **Step 1: Write the failing widget test**

Create `test/features/wallet/widgets/wallet_withdraw_cta_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_withdraw_cta.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeRepo implements ApiWalletRepository {
  _FakeRepo(this._balance);
  final CoachPayoutBalance _balance;
  @override
  Future<CoachPayoutBalance> getBalance() async => _balance;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(WidgetTester tester, CoachPayoutBalance balance) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        walletRepositoryProvider.overrideWithValue(_FakeRepo(balance)),
        tenantCurrencyProvider.overrideWithValue('IDR'),
      ],
      child: const MaterialApp(
        home: Scaffold(body: WalletWithdrawCta()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  testWidgets('shows Cairkan button when outstanding > 0', (tester) async {
    await _pump(
      tester,
      const CoachPayoutBalance(
        outstandingCents: 300000,
        outstandingPeriods: ['2026-04'],
      ),
    );
    expect(find.textContaining('Cairkan'), findsOneWidget);
  });

  testWidgets('hides Cairkan button and shows disclosure when only diproses', (tester) async {
    await _pump(
      tester,
      const CoachPayoutBalance(requestedCents: 300000),
    );
    expect(find.textContaining('Cairkan'), findsNothing);
    expect(find.textContaining('diproses'), findsOneWidget);
  });

  testWidgets('shows nothing when zero activity', (tester) async {
    await _pump(tester, const CoachPayoutBalance());
    expect(find.textContaining('Cairkan'), findsNothing);
    expect(find.textContaining('diproses'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/wallet/widgets/wallet_withdraw_cta_test.dart`
Expected: FAIL (CTA still reads summary; disclosure text absent).

- [ ] **Step 3: Rewire the CTA widget**

Replace the top-level `WalletWithdrawCta` class and its `_build`/`_openConfirmation` (down to, but NOT including, `_ActiveRequestPill`) in `lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart`. Update imports: remove `coach_payout_summary.dart`; add `coach_payout_balance.dart` and `wallet_period.dart` is already imported; keep the rest.

```dart
/// Cumulative withdraw CTA. Three visual states:
///   1. **Primary button** — `balance.canWithdraw` → "Cairkan Rp X (semua bulan)".
///      Tap → confirmation sheet → batch POST (one per outstanding period).
///   2. **In-flight disclosure** — no outstanding but `diprosesCents > 0` →
///      "N permintaan sedang diproses → Lihat Riwayat" (deep-links to history).
///   3. **Hidden** — nothing outstanding and nothing in flight.
class WalletWithdrawCta extends ConsumerWidget {
  const WalletWithdrawCta({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: balanceAsync.when(
        data: (balance) => _build(context, ref, balance, currency),
        loading: () => const _CtaSkeleton(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _build(
    BuildContext context,
    WidgetRef ref,
    CoachPayoutBalance balance,
    String currency,
  ) {
    if (!balance.canWithdraw) {
      // Nothing to withdraw. If money is in flight, show the disclosure.
      if (balance.diprosesCents > 0) {
        return const _InFlightDisclosure();
      }
      return const SizedBox.shrink();
    }

    final amount = Formatters.formatCurrency(balance.outstandingCents, currency);
    final periods = balance.outstandingPeriods;
    final batch = ref.watch(payoutBatchRequestProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.xs,
            bottom: AppDimensions.xs,
          ),
          child: Text(
            'Siap dicairkan',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppShadows.button,
            ),
            child: ElevatedButton(
              onPressed: batch.isRunning
                  ? null
                  : () => _openConfirmation(context, ref, periods, amount),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimensions.base),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                elevation: 0,
              ),
              child: batch.isRunning
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cairkan $amount',
                          style: AppTypography.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (periods.length > 1)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.xs,
              top: AppDimensions.xs,
            ),
            child: Text(
              'Mencakup ${periods.length} bulan',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openConfirmation(
    BuildContext context,
    WidgetRef ref,
    List<String> periods,
    String formattedAmount,
  ) async {
    AppHaptics.tap();
    final currentPeriod = ref.read(walletPeriodProvider);
    await _WithdrawConfirmationSheet.show(
      context: context,
      periods: periods,
      currentPeriod: currentPeriod,
      formattedAmount: formattedAmount,
    );
  }
}

/// Deep-links to the withdrawal history list (multiple in-flight requests can
/// exist in the cumulative model, so there's no single request to open).
class _InFlightDisclosure extends StatelessWidget {
  const _InFlightDisclosure();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(AppRoutes.coachWithdrawalHistory),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    size: 16, color: AppColors.infoDark),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permintaan sedang diproses',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.infoDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lihat riwayat pencairan',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.infoDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.infoDark),
            ],
          ),
        ),
      ),
    );
  }
}
```

Delete the now-unused `_ActiveRequestPill` class (it depended on a single `activeRequestId`).

- [ ] **Step 4: Update `_WithdrawConfirmationSheet` for batch**

Replace the `_WithdrawConfirmationSheet` widget's fields, `show`, and submit handler so it takes `periods` + `currentPeriod` and calls the batch provider. Change the constructor/params from `{period, formattedAmount}` to `{periods, currentPeriod, formattedAmount}`. In `show`, thread the new params. In `build`, replace the per-period label with cumulative copy and drive the confirm button off `payoutBatchRequestProvider`:

```dart
  // params:
  final List<String> periods;
  final String currentPeriod;
  final String formattedAmount;
```

Confirm-button handler (replace the old single-period submit call):

```dart
                onPressed: batch.isRunning
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        final result = await ref
                            .read(payoutBatchRequestProvider.notifier)
                            .run(widget.periods, currentPeriod: widget.currentPeriod);
                        navigator.pop();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              result.allOk
                                  ? 'Permintaan pencairan diajukan (${result.okCount} bulan).'
                                  : '${result.okCount} dari ${result.total} bulan berhasil diajukan. Sisanya menunggu permintaan aktif selesai.',
                            ),
                          ),
                        );
                      },
```

Where the sheet reads `action`/`period`, use `final batch = ref.watch(payoutBatchRequestProvider);` and the period label:

```dart
    final coversLabel = widget.periods.length == 1
        ? WalletPeriod.longLabel(widget.periods.first)
        : 'Mencakup ${widget.periods.length} bulan: '
            '${widget.periods.map(WalletPeriod.shortLabel).join(', ')}';
```

Use `coversLabel` where the old sheet printed "Periode $periodLabel", and title the sheet "Cairkan ${widget.formattedAmount}". In `dispose`, call `ref.read(payoutBatchRequestProvider.notifier).clear()` instead of the old action notifier.

- [ ] **Step 5: Run test + analyze**

Run: `flutter analyze lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart && flutter test test/features/wallet/widgets/wallet_withdraw_cta_test.dart`
Expected: no analyzer errors; 3 widget tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart test/features/wallet/widgets/wallet_withdraw_cta_test.dart
git commit -m "feat(wallet): batch cairkan-semua CTA + in-flight disclosure"
```

---

### Task 8: FE — recompose `CoachWalletScreen` (move month selector under Riwayat Sesi; refresh balance)

**Files:**
- Modify: `lib/features/wallet/presentation/screens/coach_wallet_screen.dart`

**Interfaces:**
- Consumes: `walletBalanceProvider` (refresh), existing widgets.

- [ ] **Step 1: Recompose the sliver list**

In `lib/features/wallet/presentation/screens/coach_wallet_screen.dart`:

1. In `onRefresh`, also invalidate + await the balance:
```dart
        onRefresh: () async {
          ref.invalidate(walletBalanceProvider);
          ref.invalidate(walletSummaryProvider(period));
          ref.invalidate(walletPayoutsProvider(period));
          await Future.wait([
            ref.read(walletBalanceProvider.future),
            ref.read(walletPayoutsProvider(period).future),
          ]);
        },
```

2. Reorder the slivers: remove `WalletPeriodSelector` from the top; keep `WalletHero` → chips → CTA at top; move the selector into the "Riwayat Sesi" header row. Replace the slivers list (from the first child through `_sectionHeader`) with:

```dart
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.sm)),
            const SliverToBoxAdapter(child: WalletHero()),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.lg)),
            const SliverToBoxAdapter(child: WalletStatusChips()),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.lg)),
            const SliverToBoxAdapter(child: WalletWithdrawCta()),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
            SliverToBoxAdapter(child: _sectionHeader()),
            const SliverToBoxAdapter(child: WalletPeriodSelector()),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.sm)),
            // ... payoutsAsync.when(...) unchanged ...
```

3. Update `_sectionHeader()` to clarify the selector filters history:

```dart
  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Row(
        children: [
          Text(
            'Riwayat Sesi',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            'Per bulan',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/features/wallet/presentation/screens/coach_wallet_screen.dart`
Expected: no errors (`WalletPeriodSelector` still imported + used; no unused imports).

- [ ] **Step 3: Commit**

```bash
git add lib/features/wallet/presentation/screens/coach_wallet_screen.dart
git commit -m "feat(wallet): move month selector under Riwayat Sesi; refresh balance"
```

---

### Task 9: End-to-end verification (both platforms)

**Files:** none (verification only)

- [ ] **Step 1: Full wallet test suite + analyze**

Run: `flutter analyze lib/features/wallet && flutter test test/features/wallet/`
Expected: clean analyze; all wallet tests pass.

- [ ] **Step 2: Run the app on Android against Herd**

Confirm backend is on `develop` and the balance endpoint is live (Task 1 Step 6 curl). Then:
Run: `./scripts/run-local.sh -d emulator-5554`
Navigate: Profile (coach) → Wallet.
Expected: hero shows "SALDO BELUM DICAIRKAN Rp 300.000 · 1 sesi · sejak Apr 2026" REGARDLESS of the month in Riwayat Sesi; chips cumulative; "Cairkan Rp 300.000" present. Switch months in Riwayat Sesi → only the session list changes, hero stays.

- [ ] **Step 3: Exercise cairkan-semua**

Tap "Cairkan Rp 300.000" → confirm sheet ("Cairkan Rp 300.000") → confirm.
Expected: success snackbar; hero recomputes to Rp 0 with "Semua penghasilan sudah dicairkan"; "Diproses" chip now Rp 300.000; CTA replaced by "Permintaan sedang diproses → Lihat riwayat pencairan".

- [ ] **Step 4: Verify iOS parity**

Run on the iOS simulator; repeat Step 2 visual checks (same backend, so data identical).

- [ ] **Step 5: Final commit (if any residual formatting)**

```bash
git add -A && git commit -m "chore(wallet): cumulative balance end-to-end verified" --allow-empty
```

---

## Notes for the executor

- Backend commits land on `develop` (Task 1); FE commits on `feature/wallet-cumulative-balance` (Tasks 2–9). Do not merge either without the user's go-ahead.
- If Task 1 Step 6 curl returns HTML, the route cache wasn't cleared — re-run `php artisan optimize:clear`.
- The design doc (source of truth) is `docs/superpowers/specs/2026-07-03-coach-wallet-cumulative-balance-design.md`; K-numbers referenced in code comments map to it.
