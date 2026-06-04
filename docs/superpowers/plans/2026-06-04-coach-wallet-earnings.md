# Coach Wallet / Earnings + Withdrawal Request Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** `docs/superpowers/specs/2026-06-04-coach-wallet-earnings.md`

**Goal:** Ship a coach-facing Wallet flow (3 screens) backed by a new `PayoutRequest` entity, a withdrawal request endpoint, attendance-complete guard on session-complete, and 3 new coach-context notifications.

**Architecture:** BE adds a `payout_requests` table parallel to existing `payouts` (no breaking change to Vue admin). Mark-complete endpoints gain an attendance-complete validator (shape-changing — see §11 of spec). Flutter adds a self-contained `lib/features/wallet/` module with 3 screens (Wallet, Withdrawal History, Withdrawal Detail) + 1 confirmation sheet. 3 notification types slot into the existing role-aware framework. Dashboard's Earnings card swaps data source to the new summary endpoint.

**Tech Stack:** Laravel 12 + Spatie Permission + Spatie ActivityLog, MySQL, `laravel-notification-channels/fcm`, PHPUnit. Flutter 3.x, Riverpod, Freezed 2.5, go_router. Tests use `LazilyRefreshDatabase` (BE) and `flutter_test` (FE).

---

## Scope Clarifications

- **Attendance-complete guard is Shape-changing** (per spec §11): the mark-complete endpoints will start returning `422` with a new validation key. Vue admin team coordination required BEFORE prod deploy.
- **`tenant.payout_sla_days` exposure**: spec §12 Open Question #1. This plan **includes** adding it to `AuthUserPayload` (additive). FE uses it in the confirmation bottom sheet.
- **`AttendanceCompletenessChecker` placement**: spec §12 Open Question #3. This plan places it under `App\Support\` to match existing helper conventions (e.g. `App\Support\TenantTime`).
- **Preview gate**: explicit checkpoint at Phase 14, NOT optional. APK built + device-installed + user-approved before final merge.
- **frontend-design skill**: invoked during the FE screen-building phases by the subagent implementer to apply consistency-first design (existing tokens, Plus Jakarta Sans, etc.). UI/visual choices NOT made by this plan — they belong to the design phase.
- **`completion_state` is an accessor**, not a column. Queries that look "natural" like `where('completion_state', 'needs_grading')` will silently match nothing. Always use the underlying conditions (booked count vs attendance count, etc.).

---

## File Structure

### Backend — `C:\laragon\www\hypercoach`

| Path | Responsibility | Created/Modified |
|---|---|---|
| `database/migrations/2026_06_04_xxxxxx_create_payout_requests_table.php` | Schema: `payout_requests` table + `payouts.request_id` nullable FK | Created |
| `app/Models/PayoutRequest.php` | Eloquent model with `payouts()` relation, `BelongsToTenant`, ActivityLog | Created |
| `app/Services/PayoutRequestService.php` | `createForCoach`, `approve`, `reject` — all transactional | Created |
| `app/Http/Controllers/Coach/PayoutRequestController.php` | POST + index + show endpoints scoped to own coach | Created |
| `app/Http/Controllers/Admin/PayoutRequestController.php` | List + show + approve + reject endpoints (tenant-scoped) | Created |
| `app/Http/Controllers/Coach/PayoutController.php` | Add `@summary` action (do NOT split into new controller) | Modified |
| `app/Http/Controllers/Coach/SessionController.php` | Add attendance-complete guard before status flip | Modified |
| `app/Http/Controllers/Admin/SessionController.php` | Add attendance-complete guard in `@completeSession` | Modified |
| `app/Support/AttendanceCompletenessChecker.php` | Shared validator used by both controllers above | Created |
| `app/Exceptions/IncompleteAttendanceException.php` | 422 mapping for the guard failure | Created |
| `app/Listeners/GeneratePayoutOnSessionComplete.php` | Append `PayoutEarnedNotification` dispatch after each `Payout::create` | Modified |
| `app/Services/PayoutService.php` | Append `PayoutDisbursedNotification` dispatch after `markPaid` transition | Modified |
| `app/Support/AuthUserPayload.php` | Expose `tenant.payout_sla_days` in the auth user payload | Modified |
| `app/Notifications/PayoutEarnedNotification.php` | FCM + database, target_role=coach | Created |
| `app/Notifications/PayoutRequestApprovedNotification.php` | FCM + database, target_role=coach | Created |
| `app/Notifications/PayoutDisbursedNotification.php` | FCM + database, target_role=coach | Created |
| `config/notifications.php` | Add 3 new classes to `target_role_map` as `coach` | Modified |
| `lang/id/notifications.php` | Add 6 keys (3 titles + 3 bodies) | Modified |
| `routes/api.php` | Add 4 coach routes + 4 admin routes | Modified |
| `database/seeders/RoleAndPermissionSeeder.php` | Add `request-own-payouts` permission to coach role | Modified |

### Frontend — `D:\projects\Flutter\hyperarena`

| Path | Responsibility | Created/Modified |
|---|---|---|
| `lib/features/wallet/data/api_wallet_repository.dart` | All HTTP calls for /v1/coach/payouts*, /v1/coach/payout-requests* | Created |
| `lib/features/wallet/data/models/coach_payout.dart` | Freezed single-payout model | Created |
| `lib/features/wallet/data/models/coach_payout_summary.dart` | Freezed aggregate (hero + chips) | Created |
| `lib/features/wallet/data/models/payout_request.dart` | Freezed PayoutRequest model | Created |
| `lib/features/wallet/providers/wallet_period_provider.dart` | `StateProvider<String>` "YYYY-MM" | Created |
| `lib/features/wallet/providers/wallet_summary_provider.dart` | `FutureProvider.family<String, CoachPayoutSummary>` | Created |
| `lib/features/wallet/providers/wallet_payouts_provider.dart` | `FutureProvider.family<String, List<CoachPayout>>` | Created |
| `lib/features/wallet/providers/withdrawal_history_provider.dart` | `FutureProvider<List<PayoutRequest>>` | Created |
| `lib/features/wallet/providers/withdrawal_detail_provider.dart` | `FutureProvider.family<int, PayoutRequest>` | Created |
| `lib/features/wallet/providers/payout_request_action_provider.dart` | `NotifierProvider` for the CTA flow | Created |
| `lib/features/wallet/presentation/screens/coach_wallet_screen.dart` | Main Wallet screen (hero + chips + CTA + feed) | Created |
| `lib/features/wallet/presentation/screens/coach_withdrawal_history_screen.dart` | List of PayoutRequest records | Created |
| `lib/features/wallet/presentation/screens/coach_withdrawal_detail_screen.dart` | Single PayoutRequest + rejection_note | Created |
| `lib/features/wallet/presentation/widgets/wallet_period_selector.dart` | Prev/next + picker | Created |
| `lib/features/wallet/presentation/widgets/wallet_hero.dart` | Period total + sub-stats | Created |
| `lib/features/wallet/presentation/widgets/wallet_status_chips.dart` | 3-chip row | Created |
| `lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart` | Button + confirmation bottom sheet | Created |
| `lib/features/wallet/presentation/widgets/wallet_session_row.dart` | Per-payout list item | Created |
| `lib/features/wallet/presentation/widgets/withdrawal_request_row.dart` | Per-request list item for History | Created |
| `lib/routing/app_routes.dart` | Add 3 route helpers | Modified |
| `lib/routing/app_router.dart` | Add 3 GoRoutes under `/coach/wallet` | Modified |
| `lib/features/notification/data/models/notification_item.dart` | Add 3 enum values | Modified |
| `lib/features/notification/data/api_notification_repository.dart` | 3 new type-to-route + title/body mappings | Modified |
| `lib/features/notification/utils/notification_route_resolver.dart` | 3 push-tap cases routing to `/coach/wallet` | Modified |
| `lib/features/notification/presentation/widgets/notification_tile.dart` | 3 new icon mappings | Modified |
| `lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart` | Earnings card → call `walletSummaryProvider`, tap → push wallet | Modified |
| `lib/features/profile/presentation/screens/profile_screen.dart` | Add "Wallet" / "Penghasilan" menu entry | Modified |

---

## Phase 1 — BE Migration + Model + Permission

### Task 1.1: Create `payout_requests` table + add `payouts.request_id` FK

**Files:**
- Create: `C:\laragon\www\hypercoach\database\migrations\2026_06_04_xxxxxx_create_payout_requests_table.php`

- [ ] **Step 1: Generate migration**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan make:migration create_payout_requests_table
```

- [ ] **Step 2: Replace migration body**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('payout_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tenant_id')->constrained()->cascadeOnDelete();
            $table->foreignId('coach_id')->constrained()->cascadeOnDelete();
            $table->string('period', 7); // "YYYY-MM"
            $table->integer('total_amount_cents');
            $table->string('status', 16)->default('pending'); // pending|approved|rejected|cancelled
            $table->timestamp('requested_at');
            $table->timestamp('processed_at')->nullable();
            $table->foreignId('processed_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->text('rejection_note')->nullable();
            $table->timestamps();

            $table->index(['tenant_id', 'status']);
            $table->index(['coach_id', 'period']);
        });

        Schema::table('payouts', function (Blueprint $table) {
            $table->foreignId('request_id')->nullable()->after('approved_by')
                ->constrained('payout_requests')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('payouts', function (Blueprint $table) {
            $table->dropForeign(['request_id']);
            $table->dropColumn('request_id');
        });
        Schema::dropIfExists('payout_requests');
    }
};
```

- [ ] **Step 3: Run migration**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan migrate
```

Expected: `Migrating: 2026_06_04_xxxxxx_create_payout_requests_table` → `Migrated:`.

- [ ] **Step 4: Verify schema**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute='echo Schema::hasTable("payout_requests") ? "OK" : "FAIL"; echo PHP_EOL; echo Schema::hasColumn("payouts", "request_id") ? "OK" : "FAIL";'
```

Expected: prints `OK` twice.

- [ ] **Step 5: Commit**

```bash
git checkout -b feature/coach-wallet-earnings
git add database/migrations/
git commit -m "Wallet: create payout_requests table + add payouts.request_id FK"
```

---

### Task 1.2: Create `PayoutRequest` Eloquent model

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Models\PayoutRequest.php`
- Test: `C:\laragon\www\hypercoach\tests\Unit\PayoutRequestModelTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Unit;

use App\Models\Coach;
use App\Models\PayoutRequest;
use App\Models\Tenant;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class PayoutRequestModelTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_model_persists_fillable_fields(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $user = User::create([
            'tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p',
        ]);
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $user->id, 'status' => 'active']);

        $req = PayoutRequest::create([
            'tenant_id' => $tenant->id,
            'coach_id' => $coach->id,
            'period' => '2026-06',
            'total_amount_cents' => 60000000,
            'status' => 'pending',
            'requested_at' => now(),
        ]);

        $this->assertNotNull($req->id);
        $this->assertSame('pending', $req->fresh()->status);
        $this->assertInstanceOf(\Illuminate\Support\Carbon::class, $req->requested_at);
        $this->assertSame($coach->id, $req->coach->id);
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutRequestModelTest
```

Expected: FAIL — `App\Models\PayoutRequest` not found.

- [ ] **Step 3: Write the model**

```php
<?php

namespace App\Models;

use App\Traits\BelongsToTenant;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;

class PayoutRequest extends Model
{
    use HasFactory, LogsActivity, BelongsToTenant;

    protected $fillable = [
        'tenant_id', 'coach_id', 'period',
        'total_amount_cents', 'status',
        'requested_at', 'processed_at',
        'processed_by_user_id', 'rejection_note',
    ];

    protected function casts(): array
    {
        return [
            'requested_at' => 'datetime',
            'processed_at' => 'datetime',
            'total_amount_cents' => 'integer',
        ];
    }

    public function coach(): BelongsTo
    {
        return $this->belongsTo(Coach::class);
    }

    public function payouts(): HasMany
    {
        return $this->hasMany(Payout::class, 'request_id');
    }

    public function processedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'processed_by_user_id');
    }

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logOnly(['status', 'processed_by_user_id', 'processed_at']);
    }
}
```

If `App\Traits\BelongsToTenant` doesn't exist at this path, inspect `app/Models/Payout.php` (or another model) to find the correct trait reference and adjust the `use` statement.

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutRequestModelTest
```

Expected: PASS (1 test).

- [ ] **Step 5: Commit**

```bash
git add app/Models/PayoutRequest.php tests/Unit/PayoutRequestModelTest.php
git commit -m "Wallet: add PayoutRequest model"
```

---

### Task 1.3: Seed `request-own-payouts` permission

**Files:**
- Modify: `C:\laragon\www\hypercoach\database\seeders\RoleAndPermissionSeeder.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Permissions\RequestOwnPayoutsPermissionTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Permissions;

use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class RequestOwnPayoutsPermissionTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_seeder_creates_permission_and_assigns_to_coach_role(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);

        $perm = Permission::where('name', 'request-own-payouts')->first();
        $this->assertNotNull($perm, 'Permission "request-own-payouts" was not created');

        $coachRole = Role::where('name', 'coach')->first();
        $this->assertTrue($coachRole->hasPermissionTo('request-own-payouts'));
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter RequestOwnPayoutsPermissionTest
```

Expected: FAIL — permission not present.

- [ ] **Step 3: Update seeder**

Open `database/seeders/RoleAndPermissionSeeder.php`. Find the array of permissions (search for `view-own-payouts` to locate the cluster). Add `request-own-payouts` to the same cluster. Then find where `coach` role is given permissions and add `request-own-payouts` to that group.

Concrete pattern (adapt to the existing seeder's structure — it may use `Permission::firstOrCreate` or an array spread):

```php
// Inside the permissions list near 'view-own-payouts':
Permission::firstOrCreate(['name' => 'request-own-payouts', 'guard_name' => 'web']);

// Inside coach role assignment block:
$coachRole->givePermissionTo([
    // ... existing permissions ...
    'view-own-payouts',
    'request-own-payouts',
]);
```

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter RequestOwnPayoutsPermissionTest
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add database/seeders/RoleAndPermissionSeeder.php tests/Feature/Permissions/
git commit -m "Wallet: add request-own-payouts permission to coach role"
```

---

## Phase 2 — BE Service Layer

### Task 2.1: `PayoutRequestService` — create / approve / reject

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Services\PayoutRequestService.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Wallet\PayoutRequestServiceTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Wallet;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\PayoutRequest;
use App\Models\Tenant;
use App\Models\User;
use App\Services\PayoutRequestService;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class PayoutRequestServiceTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private Coach $coach;
    private User $adminUser;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleAndPermissionSeeder::class);
        $this->tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $coachUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);
        $this->adminUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'A', 'email' => 'a@x.com', 'password' => 'p']);
        $this->adminUser->assignRole('admin');
    }

    private function seedPendingPayout(string $period, int $amount): Payout
    {
        return Payout::create([
            'tenant_id' => $this->tenant->id,
            'coach_id' => $this->coach->id,
            'amount' => $amount,
            'currency' => 'IDR',
            'period' => $period,
            'status' => 'pending',
        ]);
    }

    public function test_create_for_coach_groups_pending_payouts(): void
    {
        $p1 = $this->seedPendingPayout('2026-06', 15000000);
        $p2 = $this->seedPendingPayout('2026-06', 20000000);

        $service = app(PayoutRequestService::class);
        $request = $service->createForCoach($this->coach, '2026-06');

        $this->assertSame('pending', $request->status);
        $this->assertSame(35000000, $request->total_amount_cents);
        $this->assertSame($request->id, $p1->fresh()->request_id);
        $this->assertSame($request->id, $p2->fresh()->request_id);
    }

    public function test_create_throws_when_active_request_exists(): void
    {
        $this->seedPendingPayout('2026-06', 15000000);
        $service = app(PayoutRequestService::class);
        $service->createForCoach($this->coach, '2026-06');

        $this->seedPendingPayout('2026-06', 15000000);
        $this->expectException(\DomainException::class);
        $service->createForCoach($this->coach, '2026-06');
    }

    public function test_create_throws_when_no_pending_payouts(): void
    {
        $service = app(PayoutRequestService::class);
        $this->expectException(\DomainException::class);
        $service->createForCoach($this->coach, '2026-06');
    }

    public function test_approve_transitions_request_and_payouts(): void
    {
        $p1 = $this->seedPendingPayout('2026-06', 15000000);
        $service = app(PayoutRequestService::class);
        $request = $service->createForCoach($this->coach, '2026-06');

        $approved = $service->approve($request, $this->adminUser);

        $this->assertSame('approved', $approved->status);
        $this->assertSame($this->adminUser->id, $approved->processed_by_user_id);
        $this->assertSame('approved', $p1->fresh()->status);
    }

    public function test_reject_keeps_payouts_pending(): void
    {
        $p1 = $this->seedPendingPayout('2026-06', 15000000);
        $service = app(PayoutRequestService::class);
        $request = $service->createForCoach($this->coach, '2026-06');

        $rejected = $service->reject($request, $this->adminUser, 'Verifikasi rekening dulu');

        $this->assertSame('rejected', $rejected->status);
        $this->assertSame('Verifikasi rekening dulu', $rejected->rejection_note);
        $this->assertSame('pending', $p1->fresh()->status);
    }
}
```

If the `Payout::create` fails because `amount` field expects different naming or extra fields are required, inspect `app/Models/Payout.php` `$fillable` and the migration to find the canonical field set, then adjust the test's `seedPendingPayout` helper.

- [ ] **Step 2: Run test, expect FAIL**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutRequestServiceTest
```

Expected: 5 tests fail.

- [ ] **Step 3: Write the service**

```php
<?php

namespace App\Services;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\PayoutRequest;
use App\Models\User;
use App\Notifications\PayoutRequestApprovedNotification;
use DomainException;
use Illuminate\Support\Facades\DB;

class PayoutRequestService
{
    public function __construct(private PayoutService $payoutService) {}

    public function createForCoach(Coach $coach, string $period): PayoutRequest
    {
        return DB::transaction(function () use ($coach, $period) {
            $existing = PayoutRequest::where('coach_id', $coach->id)
                ->where('period', $period)
                ->whereIn('status', ['pending', 'approved'])
                ->lockForUpdate()
                ->first();
            if ($existing) {
                throw new DomainException('Active request already exists for this period.');
            }

            $payouts = Payout::where('coach_id', $coach->id)
                ->where('period', $period)
                ->where('status', 'pending')
                ->whereNull('request_id')
                ->lockForUpdate()
                ->get();
            if ($payouts->isEmpty()) {
                throw new DomainException('No pending payouts to request.');
            }

            $request = PayoutRequest::create([
                'tenant_id' => $coach->tenant_id,
                'coach_id' => $coach->id,
                'period' => $period,
                'total_amount_cents' => $payouts->sum('amount'),
                'status' => 'pending',
                'requested_at' => now(),
            ]);

            Payout::whereIn('id', $payouts->pluck('id'))->update(['request_id' => $request->id]);

            return $request->fresh('payouts');
        });
    }

    public function approve(PayoutRequest $request, User $admin): PayoutRequest
    {
        return DB::transaction(function () use ($request, $admin) {
            if ($request->status !== 'pending') {
                throw new DomainException("Request is {$request->status}, cannot approve.");
            }

            $request->update([
                'status' => 'approved',
                'processed_at' => now(),
                'processed_by_user_id' => $admin->id,
            ]);

            foreach ($request->payouts as $payout) {
                if ($payout->status === 'pending') {
                    $this->payoutService->approvePayout($payout->id, $admin->id);
                }
            }

            $coach = $request->coach->loadMissing('user');
            if ($coach->user) {
                $coach->user->notify(new PayoutRequestApprovedNotification($request->fresh(), $coach));
            }

            return $request->fresh(['payouts']);
        });
    }

    public function reject(PayoutRequest $request, User $admin, ?string $note): PayoutRequest
    {
        return DB::transaction(function () use ($request, $admin, $note) {
            if ($request->status !== 'pending') {
                throw new DomainException("Request is {$request->status}, cannot reject.");
            }

            $request->update([
                'status' => 'rejected',
                'processed_at' => now(),
                'processed_by_user_id' => $admin->id,
                'rejection_note' => $note,
            ]);

            return $request->fresh(['payouts']);
        });
    }
}
```

The `approve` step calls `PayoutRequestApprovedNotification` which doesn't exist yet (Task 4.2 creates it). Until that task lands, **comment out the notify call** to keep the test green:

```php
// foreach ($request->payouts ...) { ... }
// if ($coach->user) {
//     $coach->user->notify(new PayoutRequestApprovedNotification($request->fresh(), $coach));
// }
```

Re-enable in Task 4.2 Step 4 below.

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutRequestServiceTest
```

Expected: 5/5 pass.

- [ ] **Step 5: Commit**

```bash
git add app/Services/PayoutRequestService.php tests/Feature/Wallet/PayoutRequestServiceTest.php
git commit -m "Wallet: add PayoutRequestService (create + approve + reject)"
```

---

## Phase 3 — BE Endpoints

### Task 3.1: `Coach\PayoutRequestController` + routes

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Http\Controllers\Coach\PayoutRequestController.php`
- Modify: `C:\laragon\www\hypercoach\routes\api.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Wallet\CoachPayoutRequestEndpointTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Wallet;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CoachPayoutRequestEndpointTest extends TestCase
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
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $this->tenant->id, 'plan_id' => $plan->id,
            'status' => 'active', 'started_at' => now(),
        ]);
        $this->coachUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $this->coachUser->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $this->coachUser->id, 'status' => 'active']);
        $this->baseUrl = 'http://t.hypercoach.local/api/v1';
    }

    private function pendingPayout(string $period, int $amount): Payout
    {
        return Payout::create([
            'tenant_id' => $this->tenant->id, 'coach_id' => $this->coach->id,
            'amount' => $amount, 'currency' => 'IDR', 'period' => $period, 'status' => 'pending',
        ]);
    }

    public function test_post_creates_request_with_pending_payouts(): void
    {
        $this->pendingPayout('2026-06', 15000000);
        $this->pendingPayout('2026-06', 20000000);
        Sanctum::actingAs($this->coachUser);

        $res = $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06']);
        $res->assertCreated();
        $this->assertSame('pending', $res->json('request.status'));
        $this->assertSame(35000000, $res->json('request.total_amount_cents'));
    }

    public function test_post_returns_409_when_active_request_exists(): void
    {
        $this->pendingPayout('2026-06', 15000000);
        Sanctum::actingAs($this->coachUser);

        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06'])->assertCreated();
        $this->pendingPayout('2026-06', 5000000);
        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06'])->assertStatus(409);
    }

    public function test_post_returns_422_when_no_pending_payouts(): void
    {
        Sanctum::actingAs($this->coachUser);
        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06'])->assertStatus(422);
    }

    public function test_post_returns_403_without_permission(): void
    {
        $this->coachUser->revokePermissionTo('request-own-payouts');
        Sanctum::actingAs($this->coachUser);
        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06'])->assertForbidden();
    }

    public function test_index_lists_own_requests(): void
    {
        $this->pendingPayout('2026-06', 15000000);
        Sanctum::actingAs($this->coachUser);
        $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06']);
        $res = $this->getJson("{$this->baseUrl}/coach/payout-requests");
        $res->assertOk();
        $this->assertCount(1, $res->json('data'));
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachPayoutRequestEndpointTest
```

Expected: route not found.

- [ ] **Step 3: Write the controller**

```php
<?php

namespace App\Http\Controllers\Coach;

use App\Http\Controllers\Controller;
use App\Models\Coach;
use App\Models\PayoutRequest;
use App\Services\PayoutRequestService;
use DomainException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PayoutRequestController extends Controller
{
    public function __construct(private PayoutRequestService $service) {}

    public function index(Request $request): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('view-own-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $coach = Coach::where('user_id', $request->user()->id)->firstOrFail();

        $query = PayoutRequest::where('coach_id', $coach->id)->with('payouts');

        if ($request->filled('period')) {
            $query->where('period', $request->input('period'));
        }
        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        return response()->json($query->orderByDesc('requested_at')->paginate($request->input('per_page', 15)));
    }

    public function show(Request $request, int $id): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('view-own-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $coach = Coach::where('user_id', $request->user()->id)->firstOrFail();
        $req = PayoutRequest::with(['payouts.session:id,start_at,duration_minutes', 'processedBy:id,name'])
            ->where('coach_id', $coach->id)
            ->find($id);

        if (! $req) {
            return response()->json(['message' => 'Not found.'], 404);
        }

        return response()->json(['request' => $req]);
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'period' => ['required', 'string', 'regex:/^\d{4}-\d{2}$/'],
        ]);

        if (! $request->user()->hasPermissionTo('request-own-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $coach = Coach::where('user_id', $request->user()->id)->firstOrFail();

        try {
            $req = $this->service->createForCoach($coach, $request->input('period'));
        } catch (DomainException $e) {
            $msg = $e->getMessage();
            $code = str_contains($msg, 'Active request') ? 409 : 422;
            return response()->json(['message' => $msg], $code);
        }

        return response()->json([
            'request' => [
                'id' => $req->id,
                'period' => $req->period,
                'total_amount_cents' => $req->total_amount_cents,
                'status' => $req->status,
                'requested_at' => $req->requested_at?->toIso8601String(),
                'linked_payout_count' => $req->payouts->count(),
            ],
        ], 201);
    }
}
```

- [ ] **Step 4: Add routes**

In `routes/api.php`, find the existing `Route::prefix('coach')` group (the one with `auth:sanctum`, `resolve.tenant`, etc.). Append:

```php
Route::post('/payout-requests', [\App\Http\Controllers\Coach\PayoutRequestController::class, 'store']);
Route::get('/payout-requests', [\App\Http\Controllers\Coach\PayoutRequestController::class, 'index']);
Route::get('/payout-requests/{id}', [\App\Http\Controllers\Coach\PayoutRequestController::class, 'show'])->whereNumber('id');
```

- [ ] **Step 5: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachPayoutRequestEndpointTest
```

Expected: 5/5 pass.

- [ ] **Step 6: Commit**

```bash
git add app/Http/Controllers/Coach/PayoutRequestController.php routes/api.php tests/Feature/Wallet/CoachPayoutRequestEndpointTest.php
git commit -m "Wallet: add Coach\\PayoutRequestController + routes"
```

---

### Task 3.2: `Admin\PayoutRequestController` + routes

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Http\Controllers\Admin\PayoutRequestController.php`
- Modify: `C:\laragon\www\hypercoach\routes\api.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Wallet\AdminPayoutRequestEndpointTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Wallet;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminPayoutRequestEndpointTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private Coach $coach;
    private User $coachUser;
    private User $adminUser;
    private string $baseUrl;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleAndPermissionSeeder::class);
        $this->tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $this->tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $this->coachUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $this->coachUser->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $this->coachUser->id, 'status' => 'active']);
        $this->adminUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'A', 'email' => 'a@x.com', 'password' => 'p']);
        $this->adminUser->assignRole('admin');
        $this->baseUrl = 'http://t.hypercoach.local/api/v1';
    }

    private function createRequest(): int
    {
        Payout::create([
            'tenant_id' => $this->tenant->id, 'coach_id' => $this->coach->id,
            'amount' => 15000000, 'currency' => 'IDR', 'period' => '2026-06', 'status' => 'pending',
        ]);
        Sanctum::actingAs($this->coachUser);
        return $this->postJson("{$this->baseUrl}/coach/payout-requests", ['period' => '2026-06'])->json('request.id');
    }

    public function test_admin_can_approve_request(): void
    {
        $id = $this->createRequest();
        Sanctum::actingAs($this->adminUser);
        $res = $this->postJson("{$this->baseUrl}/admin/payout-requests/{$id}/approve");
        $res->assertOk();
        $this->assertSame('approved', $res->json('request.status'));
    }

    public function test_admin_can_reject_with_note(): void
    {
        $id = $this->createRequest();
        Sanctum::actingAs($this->adminUser);
        $res = $this->postJson("{$this->baseUrl}/admin/payout-requests/{$id}/reject", ['note' => 'Cek rekening dulu']);
        $res->assertOk();
        $this->assertSame('rejected', $res->json('request.status'));
        $this->assertSame('Cek rekening dulu', $res->json('request.rejection_note'));
    }

    public function test_admin_list_returns_tenant_scoped(): void
    {
        $this->createRequest();
        Sanctum::actingAs($this->adminUser);
        $res = $this->getJson("{$this->baseUrl}/admin/payout-requests");
        $res->assertOk();
        $this->assertCount(1, $res->json('data'));
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

- [ ] **Step 3: Write the controller**

```php
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PayoutRequest;
use App\Services\PayoutRequestService;
use DomainException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PayoutRequestController extends Controller
{
    public function __construct(private PayoutRequestService $service) {}

    public function index(Request $request): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('manage-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $query = PayoutRequest::query()
            ->where('tenant_id', app('current_tenant')->id)
            ->with(['coach.user:id,name', 'payouts']);

        foreach (['period', 'status', 'coach_id'] as $field) {
            if ($request->filled($field)) {
                $query->where($field, $request->input($field));
            }
        }

        return response()->json($query->orderByDesc('requested_at')->paginate($request->input('per_page', 15)));
    }

    public function show(Request $request, int $id): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('manage-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $req = PayoutRequest::with(['coach.user', 'payouts.session', 'processedBy:id,name'])
            ->where('tenant_id', app('current_tenant')->id)
            ->find($id);
        if (! $req) {
            return response()->json(['message' => 'Not found.'], 404);
        }

        return response()->json(['request' => $req]);
    }

    public function approve(Request $request, int $id): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('manage-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $req = PayoutRequest::where('tenant_id', app('current_tenant')->id)->findOrFail($id);

        try {
            $req = $this->service->approve($req, $request->user());
        } catch (DomainException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json(['request' => $req]);
    }

    public function reject(Request $request, int $id): JsonResponse
    {
        $request->validate(['note' => ['nullable', 'string', 'max:500']]);

        if (! $request->user()->hasPermissionTo('manage-payouts')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $req = PayoutRequest::where('tenant_id', app('current_tenant')->id)->findOrFail($id);

        try {
            $req = $this->service->reject($req, $request->user(), $request->input('note'));
        } catch (DomainException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json(['request' => $req]);
    }
}
```

- [ ] **Step 4: Add routes**

In `routes/api.php`, find the existing `Route::prefix('admin')` group (look for `permission:manage-payouts` near existing payout routes). Append:

```php
Route::get('/payout-requests', [\App\Http\Controllers\Admin\PayoutRequestController::class, 'index'])
    ->middleware('permission:manage-payouts');
Route::get('/payout-requests/{id}', [\App\Http\Controllers\Admin\PayoutRequestController::class, 'show'])
    ->whereNumber('id')->middleware('permission:manage-payouts');
Route::post('/payout-requests/{id}/approve', [\App\Http\Controllers\Admin\PayoutRequestController::class, 'approve'])
    ->whereNumber('id')->middleware('permission:manage-payouts');
Route::post('/payout-requests/{id}/reject', [\App\Http\Controllers\Admin\PayoutRequestController::class, 'reject'])
    ->whereNumber('id')->middleware('permission:manage-payouts');
```

- [ ] **Step 5: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter AdminPayoutRequestEndpointTest
```

Expected: 3/3 pass.

- [ ] **Step 6: Commit**

```bash
git add app/Http/Controllers/Admin/PayoutRequestController.php routes/api.php tests/Feature/Wallet/AdminPayoutRequestEndpointTest.php
git commit -m "Wallet: add Admin\\PayoutRequestController + routes"
```

---

### Task 3.3: `Coach\PayoutController@summary` endpoint

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Coach\PayoutController.php`
- Modify: `C:\laragon\www\hypercoach\routes\api.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Wallet\CoachPayoutSummaryEndpointTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Wallet;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CoachPayoutSummaryEndpointTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_summary_aggregates_by_status(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $coachUser = User::create(['tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);

        foreach (['pending', 'pending', 'approved', 'paid', 'paid', 'paid'] as $status) {
            Payout::create([
                'tenant_id' => $tenant->id, 'coach_id' => $coach->id,
                'amount' => 1000000, 'currency' => 'IDR', 'period' => '2026-06', 'status' => $status,
            ]);
        }

        Sanctum::actingAs($coachUser);
        $res = $this->getJson('http://t.hypercoach.local/api/v1/coach/payouts/summary?period=2026-06');

        $res->assertOk()
            ->assertJsonPath('total_earned_cents', 6000000)
            ->assertJsonPath('pending_cents', 2000000)
            ->assertJsonPath('approved_cents', 1000000)
            ->assertJsonPath('paid_cents', 3000000);
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

- [ ] **Step 3: Add `@summary` action to `Coach\PayoutController`**

Append to `app/Http/Controllers/Coach/PayoutController.php`:

```php
public function summary(\Illuminate\Http\Request $request): \Illuminate\Http\JsonResponse
{
    $request->validate(['period' => ['required', 'string', 'regex:/^\d{4}-\d{2}$/']]);

    if (! $request->user()->hasPermissionTo('view-own-payouts')) {
        return response()->json(['message' => 'Forbidden.'], 403);
    }

    $coach = \App\Models\Coach::where('user_id', $request->user()->id)->first();
    if (! $coach) {
        return response()->json(['message' => 'Coach profile not found.'], 404);
    }

    $period = $request->input('period');
    $base = \App\Models\Payout::where('coach_id', $coach->id)->where('period', $period);

    $pending = (clone $base)->where('status', 'pending')->whereNull('request_id')->sum('amount');
    $requested = (clone $base)->where('status', 'pending')->whereNotNull('request_id')->sum('amount');
    $approved = (clone $base)->where('status', 'approved')->sum('amount');
    $paid = (clone $base)->where('status', 'paid')->sum('amount');
    $totalEarned = $pending + $requested + $approved + $paid;

    $sessionCount = (clone $base)->whereNotNull('session_id')->distinct('session_id')->count('session_id');

    $activeRequest = \App\Models\PayoutRequest::where('coach_id', $coach->id)
        ->where('period', $period)
        ->whereIn('status', ['pending', 'approved'])
        ->first();

    return response()->json([
        'period' => $period,
        'total_earned_cents' => (int) $totalEarned,
        'session_count' => $sessionCount,
        'student_count' => 0, // computed in dashboard; out-of-scope here
        'pending_cents' => (int) $pending,
        'requested_cents' => (int) $requested,
        'approved_cents' => (int) $approved,
        'paid_cents' => (int) $paid,
        'active_request_id' => $activeRequest?->id,
    ]);
}
```

- [ ] **Step 4: Add route**

In `routes/api.php`, inside the coach group near other payout routes:

```php
Route::get('/payouts/summary', [\App\Http\Controllers\Coach\PayoutController::class, 'summary']);
```

- [ ] **Step 5: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachPayoutSummaryEndpointTest
```

- [ ] **Step 6: Commit**

```bash
git add app/Http/Controllers/Coach/PayoutController.php routes/api.php tests/Feature/Wallet/CoachPayoutSummaryEndpointTest.php
git commit -m "Wallet: add coach payout summary endpoint"
```

---

## Phase 4 — BE Notifications

### Task 4.1: `PayoutEarnedNotification` + listener dispatch + lang keys

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\PayoutEarnedNotification.php`
- Modify: `C:\laragon\www\hypercoach\app\Listeners\GeneratePayoutOnSessionComplete.php`
- Modify: `C:\laragon\www\hypercoach\lang\id\notifications.php`
- Modify: `C:\laragon\www\hypercoach\config\notifications.php`

- [ ] **Step 1: Add lang keys**

Append to `lang/id/notifications.php` before the closing `];`:

```php
    'payout_earned_title' => 'Penghasilan baru',
    'payout_earned_body' => 'Rp :amount dari sesi :session_name',
    'payout_request_approved_title' => 'Permintaan pencairan disetujui',
    'payout_request_approved_body' => 'Rp :amount untuk periode :period',
    'payout_disbursed_title' => 'Pencairan berhasil',
    'payout_disbursed_body' => 'Rp :amount telah ditransfer ke rekening Anda',
```

- [ ] **Step 2: Create the notification class**

```php
<?php

namespace App\Notifications;

use App\Models\Coach;
use App\Models\Payout;
use App\Notifications\Concerns\HasFcmChannel;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class PayoutEarnedNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(private Payout $payout, private Coach $coach) {}

    public function via(object $notifiable): array
    {
        return ['database', 'fcm'];
    }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';
        $sessionName = $this->payout->session?->name ?? 'Sesi';
        $amountFormatted = number_format($this->payout->amount / 100, 0, ',', '.');

        return [
            'type' => self::class,
            'payout_id' => $this->payout->id,
            'session_id' => $this->payout->session_id,
            'session_name' => $sessionName,
            'amount_cents' => $this->payout->amount,
            'route' => '/coach/wallet',
            'title' => __('notifications.payout_earned_title', [], $locale),
            'body' => __('notifications.payout_earned_body', [
                'amount' => $amountFormatted,
                'session_name' => $sessionName,
            ], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);
        return FcmMessage::create()
            ->notification(FcmNotification::create()
                ->title($payload['title'])
                ->body($payload['body']))
            ->data([
                'type' => 'payout_earned',
                'payout_id' => (string) $this->payout->id,
                'route' => $payload['route'],
            ]);
    }
}
```

If the existing notification classes (e.g. `PayoutApproved.php`) use a different FcmMessage pattern (constructor-style vs fluent), match that pattern exactly.

- [ ] **Step 3: Add to config map**

In `config/notifications.php` `target_role_map`, add (in the coach audience block):

```php
\App\Notifications\PayoutEarnedNotification::class => 'coach',
```

- [ ] **Step 4: Dispatch from listener**

Edit `app/Listeners/GeneratePayoutOnSessionComplete.php`. Inside the existing `foreach ($session->coaches as $coach)` loop, AFTER the `if (! $result['success'])` block but BEFORE the `activity()` log, append:

```php
$coach->loadMissing('user');
if ($coach->user) {
    $coach->user->notify(new \App\Notifications\PayoutEarnedNotification($result['payout'], $coach));
}
```

- [ ] **Step 5: Write the dispatch test**

`tests/Feature/Notifications/PayoutEarnedNotificationTest.php`:

```php
<?php

namespace Tests\Feature\Notifications;

use App\Events\SessionCompleted;
use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\PayoutEarnedNotification;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Notification;
use Tests\TestCase;

class PayoutEarnedNotificationTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_dispatched_when_session_completed(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        Notification::fake();

        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $coachUser = User::create(['tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);

        // Coach rate so PayoutService can compute payout
        \App\Models\CoachRate::create([
            'tenant_id' => $tenant->id, 'coach_id' => $coach->id,
            'rate_per_session' => 15000000, 'currency' => 'IDR', 'effective_from' => now()->subYear(),
        ]);

        $session = Session::create([
            'tenant_id' => $tenant->id, 'type' => 'group',
            'start_at' => now()->subHours(2), 'duration_minutes' => 60, 'capacity' => 10,
            'status' => 'completed',
        ]);
        $session->coaches()->sync([$coach->id]);

        event(new SessionCompleted($session));

        Notification::assertSentTo($coachUser, PayoutEarnedNotification::class);
    }
}
```

If `CoachRate` field names differ, inspect the model + migration and adapt the seed.

- [ ] **Step 6: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutEarnedNotificationTest
```

- [ ] **Step 7: Commit**

```bash
git add app/Notifications/PayoutEarnedNotification.php app/Listeners/GeneratePayoutOnSessionComplete.php lang/id/notifications.php config/notifications.php tests/Feature/Notifications/PayoutEarnedNotificationTest.php
git commit -m "Wallet: add PayoutEarnedNotification + listener dispatch"
```

---

### Task 4.2: `PayoutRequestApprovedNotification` + service dispatch

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\PayoutRequestApprovedNotification.php`
- Modify: `C:\laragon\www\hypercoach\app\Services\PayoutRequestService.php` (uncomment notify block from Task 2.1)
- Modify: `C:\laragon\www\hypercoach\config\notifications.php`

- [ ] **Step 1: Create notification class**

```php
<?php

namespace App\Notifications;

use App\Models\Coach;
use App\Models\PayoutRequest;
use App\Notifications\Concerns\HasFcmChannel;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class PayoutRequestApprovedNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(private PayoutRequest $request, private Coach $coach) {}

    public function via(object $notifiable): array { return ['database', 'fcm']; }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';
        $amountFormatted = number_format($this->request->total_amount_cents / 100, 0, ',', '.');

        return [
            'type' => self::class,
            'request_id' => $this->request->id,
            'period' => $this->request->period,
            'total_amount_cents' => $this->request->total_amount_cents,
            'route' => '/coach/wallet',
            'title' => __('notifications.payout_request_approved_title', [], $locale),
            'body' => __('notifications.payout_request_approved_body', [
                'amount' => $amountFormatted,
                'period' => $this->request->period,
            ], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);
        return FcmMessage::create()
            ->notification(FcmNotification::create()->title($payload['title'])->body($payload['body']))
            ->data([
                'type' => 'payout_request_approved',
                'request_id' => (string) $this->request->id,
                'route' => $payload['route'],
            ]);
    }
}
```

- [ ] **Step 2: Add to config map**

In `config/notifications.php`:

```php
\App\Notifications\PayoutRequestApprovedNotification::class => 'coach',
```

- [ ] **Step 3: Uncomment notify in `PayoutRequestService::approve`**

In `app/Services/PayoutRequestService.php`, remove the comment markers around:

```php
$coach = $request->coach->loadMissing('user');
if ($coach->user) {
    $coach->user->notify(new PayoutRequestApprovedNotification($request->fresh(), $coach));
}
```

Add `use App\Notifications\PayoutRequestApprovedNotification;` at the top if not already there.

- [ ] **Step 4: Write test**

`tests/Feature/Notifications/PayoutRequestApprovedNotificationTest.php`:

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\PayoutRequestApprovedNotification;
use App\Services\PayoutRequestService;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Notification;
use Tests\TestCase;

class PayoutRequestApprovedNotificationTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_dispatched_when_request_approved(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        Notification::fake();

        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);

        $coachUser = User::create(['tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);
        $admin = User::create(['tenant_id' => $tenant->id, 'name' => 'A', 'email' => 'a@x.com', 'password' => 'p']);
        $admin->assignRole('admin');

        Payout::create([
            'tenant_id' => $tenant->id, 'coach_id' => $coach->id,
            'amount' => 15000000, 'currency' => 'IDR', 'period' => '2026-06', 'status' => 'pending',
        ]);

        $service = app(PayoutRequestService::class);
        $request = $service->createForCoach($coach, '2026-06');
        $service->approve($request, $admin);

        Notification::assertSentTo($coachUser, PayoutRequestApprovedNotification::class);
    }
}
```

- [ ] **Step 5: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutRequestApprovedNotificationTest
```

- [ ] **Step 6: Commit**

```bash
git add app/Notifications/PayoutRequestApprovedNotification.php app/Services/PayoutRequestService.php config/notifications.php tests/Feature/Notifications/PayoutRequestApprovedNotificationTest.php
git commit -m "Wallet: add PayoutRequestApprovedNotification + dispatch in service"
```

---

### Task 4.3: `PayoutDisbursedNotification` + markPaid dispatch

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\PayoutDisbursedNotification.php`
- Modify: `C:\laragon\www\hypercoach\app\Services\PayoutService.php`
- Modify: `C:\laragon\www\hypercoach\config\notifications.php`

- [ ] **Step 1: Create the notification**

```php
<?php

namespace App\Notifications;

use App\Models\Coach;
use App\Models\Payout;
use App\Notifications\Concerns\HasFcmChannel;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class PayoutDisbursedNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(private Payout $payout, private Coach $coach) {}

    public function via(object $notifiable): array { return ['database', 'fcm']; }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';
        $sessionName = $this->payout->session?->name ?? 'Sesi';
        $amountFormatted = number_format($this->payout->amount / 100, 0, ',', '.');

        return [
            'type' => self::class,
            'payout_id' => $this->payout->id,
            'session_name' => $sessionName,
            'amount_cents' => $this->payout->amount,
            'route' => '/coach/wallet',
            'title' => __('notifications.payout_disbursed_title', [], $locale),
            'body' => __('notifications.payout_disbursed_body', ['amount' => $amountFormatted], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);
        return FcmMessage::create()
            ->notification(FcmNotification::create()->title($payload['title'])->body($payload['body']))
            ->data([
                'type' => 'payout_disbursed',
                'payout_id' => (string) $this->payout->id,
                'route' => $payload['route'],
            ]);
    }
}
```

- [ ] **Step 2: Add to config map**

```php
\App\Notifications\PayoutDisbursedNotification::class => 'coach',
```

- [ ] **Step 3: Dispatch from `PayoutService::markPaid`**

In `app/Services/PayoutService.php`, locate `markPaid(int $payoutId)`. Just BEFORE the `return ['success' => true, ...]` (or equivalent return statement), append:

```php
$payout->loadMissing('coach.user');
if ($payout->coach?->user) {
    $payout->coach->user->notify(new \App\Notifications\PayoutDisbursedNotification($payout, $payout->coach));
}
```

If the method does not currently load coach/user, the loadMissing call above safely loads them on the fly.

- [ ] **Step 4: Write test**

`tests/Feature/Notifications/PayoutDisbursedNotificationTest.php`:

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Coach;
use App\Models\Payout;
use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\PayoutDisbursedNotification;
use App\Services\PayoutService;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Notification;
use Tests\TestCase;

class PayoutDisbursedNotificationTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_dispatched_when_marked_paid(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        Notification::fake();

        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $coachUser = User::create(['tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);

        $payout = Payout::create([
            'tenant_id' => $tenant->id, 'coach_id' => $coach->id,
            'amount' => 15000000, 'currency' => 'IDR', 'period' => '2026-06', 'status' => 'approved',
        ]);

        app(PayoutService::class)->markPaid($payout->id);

        Notification::assertSentTo($coachUser, PayoutDisbursedNotification::class);
    }
}
```

- [ ] **Step 5: Run + commit**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter PayoutDisbursedNotificationTest

git add app/Notifications/PayoutDisbursedNotification.php app/Services/PayoutService.php config/notifications.php tests/Feature/Notifications/PayoutDisbursedNotificationTest.php
git commit -m "Wallet: add PayoutDisbursedNotification + dispatch in markPaid"
```

---

## Phase 5 — BE Attendance-Complete Validator (Shape-changing — coord with Vue)

### Task 5.1: `AttendanceCompletenessChecker` + exception

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Support\AttendanceCompletenessChecker.php`
- Create: `C:\laragon\www\hypercoach\app\Exceptions\IncompleteAttendanceException.php`

- [ ] **Step 1: Create exception**

`app/Exceptions/IncompleteAttendanceException.php`:

```php
<?php

namespace App\Exceptions;

use Illuminate\Http\Exceptions\HttpResponseException;

class IncompleteAttendanceException extends HttpResponseException
{
    public function __construct(string $message)
    {
        parent::__construct(
            response()->json([
                'message' => $message,
                'errors' => ['attendance' => [$message]],
            ], 422)
        );
    }
}
```

- [ ] **Step 2: Create checker**

`app/Support/AttendanceCompletenessChecker.php`:

```php
<?php

namespace App\Support;

use App\Exceptions\IncompleteAttendanceException;
use App\Models\Session;

class AttendanceCompletenessChecker
{
    public function assertComplete(Session $session): void
    {
        $bookedCount = $session->sessionStudents()
            ->whereNull('cancelled_at')
            ->count();

        $attendanceCount = $session->attendances()->count();

        if ($attendanceCount < $bookedCount) {
            $missing = $bookedCount - $attendanceCount;
            throw new IncompleteAttendanceException(
                "Sesi tidak bisa diselesaikan: {$missing} murid belum di-mark kehadirannya."
            );
        }
    }
}
```

- [ ] **Step 3: Commit**

```bash
git add app/Support/AttendanceCompletenessChecker.php app/Exceptions/IncompleteAttendanceException.php
git commit -m "Sessions: add AttendanceCompletenessChecker + IncompleteAttendanceException"
```

---

### Task 5.2: Apply guard to `Coach\SessionController@complete`

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Coach\SessionController.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Sessions\CoachAttendanceCompletenessTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Sessions;

use App\Models\Attendance;
use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\SessionStudent;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CoachAttendanceCompletenessTest extends TestCase
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
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $this->tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $this->coachUser = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $this->coachUser->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $this->coachUser->id, 'status' => 'active']);
        $this->baseUrl = 'http://t.hypercoach.local/api/v1';
    }

    private function makeSessionWithStudents(int $studentCount): Session
    {
        $session = Session::create([
            'tenant_id' => $this->tenant->id, 'type' => 'group',
            'start_at' => now()->subHours(2), 'duration_minutes' => 60, 'capacity' => 10,
            'status' => 'scheduled',
        ]);
        $session->coaches()->sync([$this->coach->id]);
        for ($i = 0; $i < $studentCount; $i++) {
            $sp = StudentProfile::create([
                'tenant_id' => $this->tenant->id,
                'first_name' => "S{$i}", 'last_name' => 'X',
            ]);
            SessionStudent::create([
                'session_id' => $session->id,
                'student_profile_id' => $sp->id,
                'booked_at' => now()->subDays(1),
            ]);
        }
        return $session;
    }

    public function test_complete_rejects_422_when_attendance_incomplete(): void
    {
        $session = $this->makeSessionWithStudents(3);
        Sanctum::actingAs($this->coachUser);

        $res = $this->postJson("{$this->baseUrl}/coach/sessions/{$session->id}/complete");
        $res->assertStatus(422)
            ->assertJsonValidationErrors('attendance');
        $this->assertSame('scheduled', $session->fresh()->status);
    }

    public function test_complete_passes_when_all_attendance_marked(): void
    {
        $session = $this->makeSessionWithStudents(2);
        foreach ($session->sessionStudents as $ss) {
            Attendance::create([
                'session_id' => $session->id,
                'student_profile_id' => $ss->student_profile_id,
                'status' => 'present',
                'marked_by' => $this->coachUser->id,
                'marked_at' => now()->subHour(),
            ]);
        }
        Sanctum::actingAs($this->coachUser);

        $res = $this->postJson("{$this->baseUrl}/coach/sessions/{$session->id}/complete");
        $res->assertOk();
        $this->assertSame('completed', $session->fresh()->status);
    }

    public function test_complete_passes_when_zero_booked_students(): void
    {
        $session = $this->makeSessionWithStudents(0);
        Sanctum::actingAs($this->coachUser);

        $this->postJson("{$this->baseUrl}/coach/sessions/{$session->id}/complete")->assertOk();
        $this->assertSame('completed', $session->fresh()->status);
    }

    public function test_complete_ignores_cancelled_session_students(): void
    {
        $session = $this->makeSessionWithStudents(2);
        // Cancel one — should NOT count toward booked
        $session->sessionStudents()->first()->update(['cancelled_at' => now()]);
        // Only mark the remaining one
        $remaining = $session->sessionStudents()->whereNull('cancelled_at')->first();
        Attendance::create([
            'session_id' => $session->id,
            'student_profile_id' => $remaining->student_profile_id,
            'status' => 'present',
            'marked_by' => $this->coachUser->id,
            'marked_at' => now()->subHour(),
        ]);
        Sanctum::actingAs($this->coachUser);

        $this->postJson("{$this->baseUrl}/coach/sessions/{$session->id}/complete")->assertOk();
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

- [ ] **Step 3: Apply guard in `Coach\SessionController@complete`**

Open `app/Http/Controllers/Coach/SessionController.php`. Find the `complete` method (around line 90–128). BEFORE the line `if ($session->status !== 'completed') { $session->update(['status' => 'completed']); ... }`, insert:

```php
app(\App\Support\AttendanceCompletenessChecker::class)->assertComplete($session);
```

So the relevant block becomes:

```php
if ($session->status === 'cancelled') {
    return response()->json(['message' => 'Cannot complete a cancelled session.'], 422);
}

app(\App\Support\AttendanceCompletenessChecker::class)->assertComplete($session);

if ($session->status !== 'completed') {
    $session->update(['status' => 'completed']);
    event(new SessionCompleted($session));
    // ... existing activity log
}
```

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachAttendanceCompletenessTest
```

- [ ] **Step 5: Commit**

```bash
git add app/Http/Controllers/Coach/SessionController.php tests/Feature/Sessions/CoachAttendanceCompletenessTest.php
git commit -m "Sessions: enforce attendance-complete guard at coach mark-complete"
```

---

### Task 5.3: Apply guard to `Admin\SessionController@completeSession`

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Admin\SessionController.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Sessions\AdminAttendanceCompletenessTest.php`

- [ ] **Step 1: Write the failing test**

Same shape as Task 5.2 but: actingAs admin user, target `/v1/admin/sessions/{id}/complete` (verify exact path from `routes/api.php` if different).

```php
<?php

namespace Tests\Feature\Sessions;

use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\SessionStudent;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminAttendanceCompletenessTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_admin_complete_rejects_422_when_attendance_incomplete(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $admin = User::create(['tenant_id' => $tenant->id, 'name' => 'A', 'email' => 'a@x.com', 'password' => 'p']);
        $admin->assignRole('admin');

        $coachUser = User::create(['tenant_id' => $tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $coachUser->assignRole('coach');
        $coach = Coach::create(['tenant_id' => $tenant->id, 'user_id' => $coachUser->id, 'status' => 'active']);

        $session = Session::create([
            'tenant_id' => $tenant->id, 'type' => 'group',
            'start_at' => now()->subHours(2), 'duration_minutes' => 60, 'capacity' => 10,
            'status' => 'scheduled',
        ]);
        $session->coaches()->sync([$coach->id]);
        $sp = StudentProfile::create(['tenant_id' => $tenant->id, 'first_name' => 'S', 'last_name' => 'X']);
        SessionStudent::create(['session_id' => $session->id, 'student_profile_id' => $sp->id, 'booked_at' => now()->subDay()]);

        Sanctum::actingAs($admin);
        $this->postJson("http://t.hypercoach.local/api/v1/admin/sessions/{$session->id}/complete")
            ->assertStatus(422)
            ->assertJsonValidationErrors('attendance');
    }
}
```

Verify the admin complete endpoint path by `grep -n "complete" routes/api.php` in the admin group. Common forms: `POST /admin/sessions/{id}/complete` or via `PATCH`.

- [ ] **Step 2: Run test, expect FAIL**

- [ ] **Step 3: Apply guard**

Open `app/Http/Controllers/Admin/SessionController.php` `completeSession` method (around line 520-530). Just before `$session->update(['status' => 'completed']);` insert:

```php
app(\App\Support\AttendanceCompletenessChecker::class)->assertComplete($session);
```

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter AdminAttendanceCompletenessTest
```

- [ ] **Step 5: Commit**

```bash
git add app/Http/Controllers/Admin/SessionController.php tests/Feature/Sessions/AdminAttendanceCompletenessTest.php
git commit -m "Sessions: enforce attendance-complete guard at admin mark-complete"
```

---

## Phase 6 — BE Auth Payload (Open Question §12.1)

### Task 6.1: Expose `tenant.payout_sla_days` in `AuthUserPayload`

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Support\AuthUserPayload.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Auth\AuthUserPayloadExposesSlaTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Auth;

use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Support\AuthUserPayload;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class AuthUserPayloadExposesSlaTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_payout_sla_days_present_in_tenant_section(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
            'payout_sla_days' => 7,
        ]);
        $plan = Plan::create([
            'name' => 'P', 'included_active_students' => 100,
            'max_coaches' => 10, 'max_programs' => 10, 'is_active' => true,
        ]);
        TenantSubscription::create([
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id, 'status' => 'active', 'started_at' => now(),
        ]);
        $user = User::create(['tenant_id' => $tenant->id, 'name' => 'U', 'email' => 'u@x.com', 'password' => 'p']);

        $payload = AuthUserPayload::fromUser($user, ['tenant']);

        $this->assertSame(7, $payload['tenant']['payout_sla_days']);
    }
}
```

- [ ] **Step 2: Run test, expect FAIL**

- [ ] **Step 3: Modify `AuthUserPayload`**

Open `app/Support/AuthUserPayload.php`. Find where the `tenant` array is built (search for `'tenant' =>` or `tenant_currency`). Add the field:

```php
'tenant' => [
    // ... existing fields like id, slug, currency, timezone, brand_color
    'payout_sla_days' => (int) ($user->tenant->payout_sla_days ?? 14),
],
```

The exact location depends on the existing helper structure — adapt to whatever pattern is there (it may be a `array_merge` or a builder).

- [ ] **Step 4: Run test, expect PASS**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter AuthUserPayloadExposesSlaTest
```

- [ ] **Step 5: Commit**

```bash
git add app/Support/AuthUserPayload.php tests/Feature/Auth/AuthUserPayloadExposesSlaTest.php
git commit -m "Auth: expose tenant.payout_sla_days in auth user payload"
```

---

## Phase 7 — FE Models + Repository

Switch to Flutter:

```bash
cd /d/projects/Flutter/hyperarena
git status   # verify on main (will create feature branch in Task 7.1)
git checkout -b feature/coach-wallet-earnings
```

### Task 7.1: `CoachPayout` Freezed model

**Files:**
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\data\models\coach_payout.dart`

- [ ] **Step 1: Create model file**

```dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout.freezed.dart';
part 'coach_payout.g.dart';

@freezed
class CoachPayout with _$CoachPayout {
  const factory CoachPayout({
    required int id,
    @JsonKey(name: 'session_id') int? sessionId,
    @JsonKey(name: 'session_name') String? sessionName,
    required int amount,
    required String currency,
    required String period,
    required String status, // 'pending'|'approved'|'paid'
    @JsonKey(name: 'request_id') int? requestId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CoachPayout;

  factory CoachPayout.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutFromJson(json);
}
```

- [ ] **Step 2: Generate Freezed**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/features/wallet/data/models/coach_payout.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/wallet/data/models/coach_payout.dart lib/features/wallet/data/models/coach_payout.freezed.dart lib/features/wallet/data/models/coach_payout.g.dart
git commit -m "Wallet FE: add CoachPayout model"
```

---

### Task 7.2: `CoachPayoutSummary` Freezed model

**Files:**
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\data\models\coach_payout_summary.dart`

- [ ] **Step 1: Create**

```dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout_summary.freezed.dart';
part 'coach_payout_summary.g.dart';

@freezed
class CoachPayoutSummary with _$CoachPayoutSummary {
  const factory CoachPayoutSummary({
    required String period,
    @JsonKey(name: 'total_earned_cents') @Default(0) int totalEarnedCents,
    @JsonKey(name: 'session_count') @Default(0) int sessionCount,
    @JsonKey(name: 'student_count') @Default(0) int studentCount,
    @JsonKey(name: 'pending_cents') @Default(0) int pendingCents,
    @JsonKey(name: 'requested_cents') @Default(0) int requestedCents,
    @JsonKey(name: 'approved_cents') @Default(0) int approvedCents,
    @JsonKey(name: 'paid_cents') @Default(0) int paidCents,
    @JsonKey(name: 'active_request_id') int? activeRequestId,
  }) = _CoachPayoutSummary;

  const CoachPayoutSummary._();

  // Chip-friendly aggregates per spec §5.4.
  int get diprosesCents => requestedCents + approvedCents;

  factory CoachPayoutSummary.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutSummaryFromJson(json);
}
```

- [ ] **Step 2: Generate + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib/features/wallet/data/models/coach_payout_summary.dart
git add lib/features/wallet/data/models/coach_payout_summary.dart lib/features/wallet/data/models/coach_payout_summary.freezed.dart lib/features/wallet/data/models/coach_payout_summary.g.dart
git commit -m "Wallet FE: add CoachPayoutSummary model"
```

---

### Task 7.3: `PayoutRequest` Freezed model

**Files:**
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\data\models\payout_request.dart`

- [ ] **Step 1: Create**

```dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';

part 'payout_request.freezed.dart';
part 'payout_request.g.dart';

@freezed
class PayoutRequest with _$PayoutRequest {
  const factory PayoutRequest({
    required int id,
    required String period,
    @JsonKey(name: 'total_amount_cents') required int totalAmountCents,
    required String status, // 'pending'|'approved'|'rejected'|'cancelled'
    @JsonKey(name: 'requested_at') required DateTime requestedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'rejection_note') String? rejectionNote,
    @Default([]) List<CoachPayout> payouts,
  }) = _PayoutRequest;

  factory PayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestFromJson(json);
}
```

- [ ] **Step 2: Generate + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib/features/wallet/data/models/payout_request.dart
git add lib/features/wallet/data/models/payout_request.dart lib/features/wallet/data/models/payout_request.freezed.dart lib/features/wallet/data/models/payout_request.g.dart
git commit -m "Wallet FE: add PayoutRequest model"
```

---

### Task 7.4: `ApiWalletRepository`

**Files:**
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\data\api_wallet_repository.dart`

- [ ] **Step 1: Create**

```dart
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_summary.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:dio/dio.dart';

class ApiWalletRepository {
  ApiWalletRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<CoachPayoutSummary> getSummary(String period) async {
    try {
      final res = await _apiClient.get('/v1/coach/payouts/summary',
          queryParameters: {'period': period});
      return CoachPayoutSummary.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<List<CoachPayout>> getPayouts(String period) async {
    try {
      final res = await _apiClient.get('/v1/coach/payouts',
          queryParameters: {'period': period, 'per_page': 50});
      final list = (res.data['data'] as List)
          .map((j) => CoachPayout.fromJson(j as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<PayoutRequest> requestWithdrawal(String period) async {
    try {
      final res = await _apiClient.post('/v1/coach/payout-requests',
          data: {'period': period});
      return PayoutRequest.fromJson(res.data['request'] as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<List<PayoutRequest>> getWithdrawalHistory({String? period, String? status}) async {
    try {
      final res = await _apiClient.get('/v1/coach/payout-requests',
          queryParameters: {
            if (period != null) 'period': period,
            if (status != null) 'status': status,
          });
      final list = (res.data['data'] as List)
          .map((j) => PayoutRequest.fromJson(j as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<PayoutRequest> getWithdrawalDetail(int id) async {
    try {
      final res = await _apiClient.get('/v1/coach/payout-requests/$id');
      return PayoutRequest.fromJson(res.data['request'] as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
```

If `rethrowDio` is at a different path or named differently in this project, check `lib/features/club/data/api_club_repository.dart` for the canonical import + usage pattern.

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/wallet/data/api_wallet_repository.dart
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/wallet/data/api_wallet_repository.dart
git commit -m "Wallet FE: add ApiWalletRepository"
```

---

## Phase 8 — FE Providers

### Task 8.1: All wallet providers (period + summary + payouts + history + detail + action)

**Files:**
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\providers\wallet_providers.dart`

Bundled in one file for now since they're tightly related. Can be split later if grows.

- [ ] **Step 1: Create**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_summary.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final walletRepositoryProvider = Provider<ApiWalletRepository>(
  (ref) => ApiWalletRepository(ref.watch(apiClientProvider)),
);

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

final walletPeriodProvider = StateProvider<String>((ref) => _currentPeriod());

final walletSummaryProvider =
    FutureProvider.family<CoachPayoutSummary, String>((ref, period) async {
  return ref.watch(walletRepositoryProvider).getSummary(period);
});

final walletPayoutsProvider =
    FutureProvider.family<List<CoachPayout>, String>((ref, period) async {
  return ref.watch(walletRepositoryProvider).getPayouts(period);
});

final withdrawalHistoryProvider =
    FutureProvider<List<PayoutRequest>>((ref) async {
  return ref.watch(walletRepositoryProvider).getWithdrawalHistory();
});

final withdrawalDetailProvider =
    FutureProvider.family<PayoutRequest, int>((ref, id) async {
  return ref.watch(walletRepositoryProvider).getWithdrawalDetail(id);
});

class PayoutRequestActionState {
  const PayoutRequestActionState({this.isLoading = false, this.error, this.lastSuccess});
  final bool isLoading;
  final String? error;
  final PayoutRequest? lastSuccess;
}

class PayoutRequestActionNotifier extends Notifier<PayoutRequestActionState> {
  @override
  PayoutRequestActionState build() => const PayoutRequestActionState();

  Future<bool> requestWithdrawal(String period) async {
    state = const PayoutRequestActionState(isLoading: true);
    try {
      final req = await ref.watch(walletRepositoryProvider).requestWithdrawal(period);
      // Invalidate downstream providers
      ref.invalidate(walletSummaryProvider(period));
      ref.invalidate(walletPayoutsProvider(period));
      ref.invalidate(withdrawalHistoryProvider);
      state = PayoutRequestActionState(lastSuccess: req);
      return true;
    } catch (e) {
      state = PayoutRequestActionState(error: e.toString());
      return false;
    }
  }
}

final payoutRequestActionProvider =
    NotifierProvider<PayoutRequestActionNotifier, PayoutRequestActionState>(
  PayoutRequestActionNotifier.new,
);
```

- [ ] **Step 2: Verify analyze + commit**

```bash
flutter analyze lib/features/wallet/providers/wallet_providers.dart
git add lib/features/wallet/providers/wallet_providers.dart
git commit -m "Wallet FE: add wallet providers (period, summary, payouts, history, detail, action)"
```

---

## Phase 9 — FE Routing

### Task 9.1: Add 3 routes to `AppRoutes` + `app_router.dart`

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\routing\app_routes.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\routing\app_router.dart`

- [ ] **Step 1: Add to `app_routes.dart`**

Open the file and add (place near other coach routes):

```dart
static const coachWallet = '/coach/wallet';
static const coachWithdrawalHistory = '/coach/wallet/requests';
static String coachWithdrawalDetail(String id) => '/coach/wallet/requests/$id';
```

- [ ] **Step 2: Add GoRoutes to `app_router.dart`**

Inside the coach branch of the router (near `/coach/students/...`):

```dart
GoRoute(
  path: '/coach/wallet',
  builder: (_, _) => const CoachWalletScreen(),
),
GoRoute(
  path: '/coach/wallet/requests',
  builder: (_, _) => const CoachWithdrawalHistoryScreen(),
),
GoRoute(
  path: '/coach/wallet/requests/:id',
  builder: (_, state) => CoachWithdrawalDetailScreen(
    requestId: int.parse(state.pathParameters['id']!),
  ),
),
```

Add imports at the top:

```dart
import 'package:hyperarena/features/wallet/presentation/screens/coach_wallet_screen.dart';
import 'package:hyperarena/features/wallet/presentation/screens/coach_withdrawal_history_screen.dart';
import 'package:hyperarena/features/wallet/presentation/screens/coach_withdrawal_detail_screen.dart';
```

The screen widget classes don't exist yet — Tasks 10.x create them. Analyze will fail at this step; that's expected — proceed and the screens land in later tasks. To keep analyzer green, OPTION 1: comment out the imports + route bodies until screens land (each one re-enabled in its corresponding task). OPTION 2: stub the screen classes upfront as `class CoachWalletScreen extends StatelessWidget { ... return const Scaffold(); }` and replace bodies later. **Use OPTION 2** so analyze stays green through this task.

Create the stub screens NOW (just `Scaffold` with placeholder text) so the router compiles. Tasks 10.x will replace the bodies.

```dart
// lib/features/wallet/presentation/screens/coach_wallet_screen.dart
import 'package:flutter/material.dart';
class CoachWalletScreen extends StatelessWidget {
  const CoachWalletScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Wallet — TODO')));
}

// lib/features/wallet/presentation/screens/coach_withdrawal_history_screen.dart
import 'package:flutter/material.dart';
class CoachWithdrawalHistoryScreen extends StatelessWidget {
  const CoachWithdrawalHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('History — TODO')));
}

// lib/features/wallet/presentation/screens/coach_withdrawal_detail_screen.dart
import 'package:flutter/material.dart';
class CoachWithdrawalDetailScreen extends StatelessWidget {
  const CoachWithdrawalDetailScreen({super.key, required this.requestId});
  final int requestId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail $requestId — TODO')));
}
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/routing/app_routes.dart lib/routing/app_router.dart lib/features/wallet/presentation/screens/
```

- [ ] **Step 4: Commit**

```bash
git add lib/routing/ lib/features/wallet/presentation/screens/
git commit -m "Wallet FE: add 3 routes + stub screens (Tasks 10.x will fill bodies)"
```

---

## Phase 10 — FE Screens + Widgets (UI work)

> **⚠️ DESIGN PHASE.** Each task here is UI-heavy. Before implementing, the user/operator will provide visual mockups from `claude-design`. The implementer subagent uses `superpowers:frontend-design` skill to apply consistency-first design with existing tokens (`AppColors`, `AppTypography`, `AppDimensions`, `AppSurfaces`, `AppShadows`), Plus Jakarta Sans font, Electric Blue/Teal/Vivid Orange palette. **Do NOT proceed past the preview gate (Task 14.1) without user UI review.**

### Task 10.1: `CoachWalletScreen` + 5 widgets

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\wallet\presentation\screens\coach_wallet_screen.dart` (replace stub)
- Create: 5 widgets under `lib/features/wallet/presentation/widgets/`

Spec reference: §5.3 (screen layout), §5.4 (chip mapping), §5.4.1 (badge colors), §5.5 (withdrawal CTA flow).

This task is large and split across substeps. The implementer follows the spec layout literally + applies frontend-design skill to choose token references. Widget contracts:

- **`WalletPeriodSelector`** — reads + mutates `walletPeriodProvider`. Renders chevron prev/next + tappable label that opens a month-picker dialog.
- **`WalletHero`** — reads `walletSummaryProvider(period)`. Renders period name + `total_earned_cents` formatted via `Formatters.formatCurrency` + sub-text "X sesi · Y murid".
- **`WalletStatusChips`** — reads summary. Renders 3 chips per the §5.4 mapping. Hides whole row when total=0.
- **`WalletWithdrawCta`** — reads summary. Hidden when `pendingCents == 0` OR `activeRequestId != null`. Opens confirmation bottom sheet wrapping content in `SafeArea(top: false)` + viewInsets padding (mirrors the `EnrollmentDialog` fix shipped earlier).
- **`WalletSessionRow`** — renders one `CoachPayout`. Status badge colors per §5.4.1.

Code for each widget should match the visual spec. Sample shell for `coach_wallet_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_period_selector.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_hero.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_status_chips.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_withdraw_cta.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_session_row.dart';

class CoachWalletScreen extends ConsumerWidget {
  const CoachWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(walletPeriodProvider);
    final payoutsAsync = ref.watch(walletPayoutsProvider(period));

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
        children: [
          const WalletPeriodSelector(),
          const SizedBox(height: AppDimensions.lg),
          const WalletHero(),
          const SizedBox(height: AppDimensions.lg),
          const WalletStatusChips(),
          const SizedBox(height: AppDimensions.lg),
          const WalletWithdrawCta(),
          const SizedBox(height: AppDimensions.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenHorizontal),
            child: Text('Riwayat Sesi',
              style: Theme.of(context).textTheme.titleMedium),
          ),
          payoutsAsync.when(
            data: (list) => Column(
              children: list.map((p) => WalletSessionRow(payout: p)).toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppDimensions.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Text('Gagal memuat: $e'),
            ),
          ),
        ],
      ),
    );
  }
}
```

**TDD steps:**

- [ ] **Step 1: Write widget tests** for each of the 5 widgets (overrides `walletSummaryProvider` etc.)

(Implementer drafts these per `superpowers:test-driven-development` based on the widget contracts above. Each test verifies: render in known state, hide rules, tap behavior.)

- [ ] **Step 2: Run tests, expect FAIL**

- [ ] **Step 3: Implement each widget**

Apply `superpowers:frontend-design` for visual choices. Use existing tokens. Match approved mockup from `claude-design`.

- [ ] **Step 4: Run tests, expect PASS**

- [ ] **Step 5: Commit per widget (5 commits total + 1 for screen)**

```bash
# Per widget
git add lib/features/wallet/presentation/widgets/wallet_period_selector.dart test/features/wallet/presentation/widgets/wallet_period_selector_test.dart
git commit -m "Wallet FE: WalletPeriodSelector widget"
# ... repeat for hero, chips, cta, session_row

# Screen itself
git add lib/features/wallet/presentation/screens/coach_wallet_screen.dart test/features/wallet/presentation/screens/coach_wallet_screen_test.dart
git commit -m "Wallet FE: CoachWalletScreen composes widgets"
```

---

### Task 10.2: `CoachWithdrawalHistoryScreen` + `WithdrawalRequestRow`

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\wallet\presentation\screens\coach_withdrawal_history_screen.dart` (replace stub)
- Create: `D:\projects\Flutter\hyperarena\lib\features\wallet\presentation\widgets\withdrawal_request_row.dart`

Spec reference: §5.9.

- [ ] **Step 1: Write widget test for `WithdrawalRequestRow`** — verifies status badge color per state, displays period+amount+session count, taps push to detail route.

- [ ] **Step 2: Run, expect FAIL**

- [ ] **Step 3: Implement widget**

Status colors:
- `pending` → warning palette
- `approved` → info palette
- `rejected` → `AppColors.error` palette
- `cancelled` → muted neutral

Tap row → `context.push(AppRoutes.coachWithdrawalDetail(req.id.toString()))`.

- [ ] **Step 4: Implement screen**

Watches `withdrawalHistoryProvider`. Renders list of `WithdrawalRequestRow` or `EmptyState(icon: Icons.history_outlined, message: 'Belum ada permintaan pencairan')`.

- [ ] **Step 5: Run + commit**

```bash
flutter test test/features/wallet/presentation/
git add lib/features/wallet/presentation/widgets/withdrawal_request_row.dart lib/features/wallet/presentation/screens/coach_withdrawal_history_screen.dart test/features/wallet/presentation/
git commit -m "Wallet FE: WithdrawalHistoryScreen + WithdrawalRequestRow"
```

---

### Task 10.3: `CoachWithdrawalDetailScreen`

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\wallet\presentation\screens\coach_withdrawal_detail_screen.dart` (replace stub)

Spec reference: §5.10.

- [ ] **Step 1: Write widget test** — verifies rejection_note section appears only when status=rejected AND note is non-null; lists linked payouts; back button works.

- [ ] **Step 2: Run, expect FAIL**

- [ ] **Step 3: Implement**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class CoachWithdrawalDetailScreen extends ConsumerWidget {
  const CoachWithdrawalDetailScreen({super.key, required this.requestId});
  final int requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(withdrawalDetailProvider(requestId));
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pencairan')),
      body: async.when(
        data: (req) {
          final showRejection = req.status == 'rejected' &&
              req.rejectionNote != null &&
              req.rejectionNote!.isNotEmpty;
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            children: [
              // Header rows (Periode, Diajukan, Total, Status)
              Text('Periode: ${req.period}'),
              Text('Diajukan: ${Formatters.formatDateTime(req.requestedAt)}'),
              Text('Total: ${Formatters.formatCurrency(req.totalAmountCents, "IDR")}'),
              Text('Status: ${req.status}'),
              if (showRejection) ...[
                const SizedBox(height: AppDimensions.lg),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catatan Penolakan',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: AppDimensions.xs),
                      Text(req.rejectionNote!,
                          style: TextStyle(color: AppColors.warningDark)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.lg),
              Text('Sesi dalam permintaan (${req.payouts.length})',
                  style: Theme.of(context).textTheme.titleSmall),
              ...req.payouts.map((p) => ListTile(
                    title: Text(p.sessionName ?? 'Sesi'),
                    subtitle:
                        Text(Formatters.formatDate(p.createdAt)),
                    trailing: Text(Formatters.formatCurrency(p.amount, p.currency)),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      ),
    );
  }
}
```

- [ ] **Step 4: Run + commit**

```bash
flutter test test/features/wallet/presentation/screens/coach_withdrawal_detail_screen_test.dart
git add lib/features/wallet/presentation/screens/coach_withdrawal_detail_screen.dart test/features/wallet/presentation/screens/coach_withdrawal_detail_screen_test.dart
git commit -m "Wallet FE: CoachWithdrawalDetailScreen with rejection_note surfacing"
```

---

## Phase 11 — FE Notifications Integration

### Task 11.1: Add 3 enum values + 3 type→route mappings + 3 icons

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\data\models\notification_item.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\data\api_notification_repository.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\utils\notification_route_resolver.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\presentation\widgets\notification_tile.dart`
- Test: `D:\projects\Flutter\hyperarena\test\features\notification\utils\notification_route_resolver_test.dart`

- [ ] **Step 1: Add enum values**

In `notification_item.dart` add to `NotificationType` enum:

```dart
payoutEarned,
payoutRequestApproved,
payoutDisbursed,
```

Regenerate Freezed.

- [ ] **Step 2: Add `_mapType`/`_titleFor`/`_bodyFor`/`_routeFor` cases in repo**

In `api_notification_repository.dart`:

```dart
// _mapType
'payout_earned' => NotificationType.payoutEarned,
'payout_request_approved' => NotificationType.payoutRequestApproved,
'payout_disbursed' => NotificationType.payoutDisbursed,

// _titleFor
'payout_earned' => 'Penghasilan baru',
'payout_request_approved' => 'Permintaan pencairan disetujui',
'payout_disbursed' => 'Pencairan berhasil',

// _bodyFor
'payout_earned' => 'Rp ${data['amount_cents'] != null ? (data['amount_cents'] / 100).toInt() : 0} dari sesi ${data['session_name'] ?? ''}',
'payout_request_approved' => 'Periode ${data['period'] ?? ''}',
'payout_disbursed' => 'Telah ditransfer ke rekening Anda',

// _routeFor — all 3 to /coach/wallet
'payout_earned' ||
'payout_request_approved' ||
'payout_disbursed' => '/coach/wallet',
```

- [ ] **Step 3: Add 3 cases in `notification_route_resolver.dart`**

Before the `_ => null` default:

```dart
'payout_earned' ||
'payout_request_approved' ||
'payout_disbursed' => AppRoutes.coachWallet,
```

- [ ] **Step 4: Add tile icons**

In `notification_tile.dart`:

```dart
case NotificationType.payoutEarned:
  return Icons.savings_outlined;
case NotificationType.payoutRequestApproved:
  return Icons.check_circle_outline;
case NotificationType.payoutDisbursed:
  return Icons.account_balance;
```

And matching colors (info palette for approved; success/positive for earned + disbursed — implementer picks the closest existing token).

- [ ] **Step 5: Add 3 resolver tests**

In `notification_route_resolver_test.dart`:

```dart
test('payout_earned resolves to /coach/wallet', () {
  expect(NotificationRouteResolver().resolve('payout_earned', {}),
      AppRoutes.coachWallet);
});
test('payout_request_approved resolves to /coach/wallet', () {
  expect(NotificationRouteResolver().resolve('payout_request_approved', {}),
      AppRoutes.coachWallet);
});
test('payout_disbursed resolves to /coach/wallet', () {
  expect(NotificationRouteResolver().resolve('payout_disbursed', {}),
      AppRoutes.coachWallet);
});
```

- [ ] **Step 6: Run + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/features/notification/
git add lib/features/notification/ test/features/notification/
git commit -m "Wallet FE: integrate 3 payout notification types into notification system"
```

---

## Phase 12 — Dashboard + Profile Integration

### Task 12.1: Earnings card hook + profile menu entry

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\coach\presentation\widgets\dashboard\coach_dashboard_performance.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\profile\presentation\screens\profile_screen.dart`

- [ ] **Step 1: Hook Earnings card to wallet summary**

In `coach_dashboard_performance.dart`, watch `walletSummaryProvider` for the current period and replace the hardcoded 0 with `summary.totalEarnedCents`. Make the Earnings card tappable → `context.push(AppRoutes.coachWallet)`.

- [ ] **Step 2: Add Wallet entry to profile screen**

Add a ListTile under the Coach section (or wherever coach-specific items live in profile screen):

```dart
ListTile(
  leading: const Icon(Icons.account_balance_wallet_outlined),
  title: const Text('Wallet'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () => context.push(AppRoutes.coachWallet),
),
```

Only show when the user has the `coach` active role.

- [ ] **Step 3: Run analyze + smoke test on existing dashboard tests**

```bash
flutter analyze lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart lib/features/profile/presentation/screens/profile_screen.dart
flutter test test/features/coach/
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart lib/features/profile/presentation/screens/profile_screen.dart
git commit -m "Wallet FE: hook dashboard Earnings card + add profile entry"
```

---

## Phase 13 — Preview Gate + Deploy

### Task 13.1: Preview gate (BLOCKING — do not skip)

**Per spec §11 Non-Functional Constraints.**

- [ ] **Step 1: Build dev APK**

```bash
cd /d/projects/Flutter/hyperarena
flutter build apk --release --target=lib/main_dev.dart \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana
```

- [ ] **Step 2: Copy to releases**

```bash
cp build/app/outputs/flutter-apk/app-release.apk "releases/HyperArena-v0.3.3+6-dev-coach-wallet-preview-$(date +%Y%m%d).apk"
```

- [ ] **Step 3: Install on device + manual visual review by user**

User checks: Wallet screen layout, period selector, hero, chips, CTA, session feed, withdrawal history, withdrawal detail with rejection note.

**Do NOT proceed past this gate without explicit user OK.**

---

### Task 13.2: Deploy BE to dev + migrate + seed

- [ ] **Step 1: Push BE branch**

```bash
cd /c/laragon/www/hypercoach
git push -u origin feature/coach-wallet-earnings
```

- [ ] **Step 2: Deploy to dev**

```bash
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh feature/coach-wallet-earnings"
```

- [ ] **Step 3: Run migration + seeder on dev**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan migrate --force"
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan db:seed --class=RoleAndPermissionSeeder --force"
```

- [ ] **Step 4: Smoke test endpoints**

```bash
curl -s -H "Accept: application/json" -o /dev/null -w "HTTP %{http_code}\n" \
  "https://devapp.hyperscore.cloud/api/v1/coach/payouts/summary?period=2026-06"
```

Expected: 401 (auth gate, endpoint reachable, no 500).

- [ ] **Step 5: Manual flow test (per spec §10 step 7)**

User logs in as a coach on dev, completes a session with attendance fully marked, sees Payout row appear in Wallet, taps "Cairkan Rp X", confirms the bottom sheet, sees the request appear in Withdrawal History as `pending`, then admin (Vue web admin or `tinker` direct call until web UI ships) approves → coach Wallet shows updated state. Repeat the reject flow: admin rejects with a note, coach sees the rejected request in History + opens Detail to see the rejection_note.

---

### Task 13.3: Push Flutter branch + final preview build

- [ ] **Step 1: Push Flutter branch**

```bash
cd /d/projects/Flutter/hyperarena
git push -u origin feature/coach-wallet-earnings
```

- [ ] **Step 2: Build final dev APK**

```bash
flutter build apk --release --target=lib/main_dev.dart \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana
cp build/app/outputs/flutter-apk/app-release.apk \
  "releases/HyperArena-v0.4.0-dev-coach-wallet-$(date +%Y%m%d).apk"
```

- [ ] **Step 3: User final review**

Same checklist as Task 13.1. Once user approves, this branch is ready to merge to main.

---

## Phase 14 — Merge

### Task 14.1: Merge BE + FE branches (coordinate with Vue admin first)

- [ ] **Step 1: Coordinate with Vue admin team**

Per spec §11: confirm Vue team has handled the `422` attendance-incomplete response from mark-complete endpoints before merging BE branch to develop. If not yet, hold the BE merge until they ship that fix.

- [ ] **Step 2: Merge BE to develop (no-ff)**

```bash
cd /c/laragon/www/hypercoach
git checkout develop
git pull
git merge --no-ff feature/coach-wallet-earnings -m "Merge feature/coach-wallet-earnings: PayoutRequest entity, attendance-complete gate, 3 coach notifications, AuthUserPayload SLA exposure"
git push origin develop
```

- [ ] **Step 3: Merge FE to main (no-ff)**

```bash
cd /d/projects/Flutter/hyperarena
git checkout main
git pull
git merge --no-ff feature/coach-wallet-earnings -m "Merge feature/coach-wallet-earnings: Coach Wallet (3 screens), PayoutRequest flow, dashboard earnings hook"
git push origin main
```

- [ ] **Step 4: Delete merged branches (BOTH repos)**

```bash
git branch -d feature/coach-wallet-earnings
git push origin --delete feature/coach-wallet-earnings
```

---

## Self-Review (per writing-plans checklist)

### Spec coverage

| Spec section | Implementing task(s) |
|---|---|
| §0 Pre-flight Findings | Documented in plan header + §4.7 implementation |
| §1 Goal — 3 screens + 3 notifs + attendance gate | Phases 9–11 (UI), Phase 4 (notifs), Phase 5 (gate) |
| §2 Decisions | Mobile-first classification surfaced in Phase 5 commit + Task 14.1 coord step |
| §3 Architecture (PayoutRequest entity) | Phase 1–3 |
| §4.1 Migration | Task 1.1 |
| §4.2 PayoutRequest model | Task 1.2 |
| §4.3 PayoutRequestService | Task 2.1 |
| §4.4 Coach endpoints | Task 3.1 |
| §4.5 Admin endpoints | Task 3.2 |
| §4.5b Summary endpoint | Task 3.3 |
| §4.6 Notifications (×3) | Tasks 4.1, 4.2, 4.3 |
| §4.7 Attendance-complete gate | Tasks 5.1, 5.2, 5.3 |
| §5.3 Wallet screen | Task 10.1 |
| §5.4 Chip mapping (Diproses = requested + approved) | Task 7.2 (model getter) + Task 10.1 |
| §5.4.1 Per-row badge colors | Task 10.1 |
| §5.5 Withdrawal CTA confirmation | Task 10.1 (WalletWithdrawCta) |
| §5.8 Loading/empty/error states | Task 10.1 |
| §5.9 Withdrawal History screen | Task 10.2 |
| §5.10 Withdrawal Detail screen | Task 10.3 |
| §5.11 Routing | Task 9.1 |
| §6 Non-Goals | All 11 respected; #10 left as optional follow-up (not in plan) |
| §7 Permissions | Task 1.3 |
| §8 File Plan | Mirrored in plan File Structure |
| §9 Testing | TDD steps in every task |
| §10 Migration Order | Phase 13 |
| §11 Non-Functional + Classification | Coord step in Task 14.1 |
| §12 Open Q1 (SLA exposure) | Phase 6 |
| §12 Open Q2 (attendance count strictness) | Task 5.1 — count-only, documented |
| §12 Open Q3 (checker placement) | Task 5.1 — `App\Support\` |
| §12 Open Q4 (History entry point UX) | Implementer choice during 10.1 design pass |
| §12 Open Q5 (rejection deep-link) | Deferred per Non-Goal 1 |

### Placeholder scan

All tasks have concrete code blocks + exact commands. Task 10.1's widget-tests step delegates to `superpowers:test-driven-development` with explicit widget contracts above it — that's structured delegation, not a placeholder.

### Type consistency

- `CoachPayoutSummary` field names match across BE response and FE model JsonKey.
- `AttendanceCompletenessChecker.assertComplete` consistent across definition (Task 5.1) and callers (5.2, 5.3).
- All provider names + route helpers consistent across definition + usage.

No naming drift.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-04-coach-wallet-earnings.md`.

**Two execution options:**

1. **Subagent-Driven (recommended)** — fresh subagent per task, two-stage review between tasks. Best fit for this plan's 33 tasks across 14 phases.
2. **Inline Execution** — same session, batch execution with checkpoints.

Which approach?