# Coach Notifications + Role-Aware Filtering Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** `docs/superpowers/specs/2026-06-03-coach-notifications-role-filter.md`

**Goal:** Tag every notification with a `target_role`, filter the `/v1/notifications` and unread-count endpoints by the user's active role, and ship three new coach-context notifications (assignment, schedule change, assessment reminder) so multi-role users see only role-relevant inbox content.

**Architecture:** BE schema gains a `target_role` column (default `all`). A single config map drives both a one-off backfill and a model observer that auto-tags every future dispatch. The notification controller adds one `whereIn` clause for filtering. Three new notification classes use the existing FCM+database channels and reuse Laravel lang strings for i18n. Flutter adds a defensive `targetRole` field, three enum values, and three resolver cases — no FE filtering logic, no new screens.

**Tech Stack:** Laravel 12 + Spatie ActivityLog, MySQL, Spatie Permission, `laravel-notification-channels/fcm`, PHPUnit. Flutter 3.x, Riverpod, Freezed 2.5, go_router. Tests use `LazilyRefreshDatabase` (BE) and `flutter_test` (FE).

---

## Scope Clarifications

These come from the spec self-review and BE exploration done while drafting this plan:

1. **No SessionService extraction.** Existing pattern is controller-direct (`$session->coaches()->sync(...)` lives inside `Admin\SessionController@store` and `@update`). The plan adds dispatch logic inline in the same controller — consistent with existing pattern, no new service abstraction.
2. **Notification controller is `App\Http\Controllers\NotificationController`** (root namespace, NOT `Member\NotificationController` as the spec speculated). Two methods need the filter clause: `index()` and `unreadCount()`.
3. **Scheduled commands go in `routes/console.php`** per Laravel 12 convention (not `app/Console/Kernel.php`).

---

## File Structure

### Backend — `C:\laragon\www\hypercoach`

| Path | Responsibility | Created/Modified |
|---|---|---|
| `database/migrations/2026_06_03_xxxxxx_add_target_role_to_notifications_table.php` | Schema: add `target_role` + `assessment_reminded_at` | Created |
| `config/notifications.php` | Single source of truth: notification class FQCN → target_role map | Created |
| `app/Observers/NotificationTargetRoleObserver.php` | Auto-tags every `DatabaseNotification::creating` event via config map | Created |
| `app/Providers/AppServiceProvider.php` | Register the observer in `boot()` | Modified |
| `app/Console/Commands/BackfillNotificationTargetRole.php` | One-off command: update existing rows per map | Created |
| `app/Console/Commands/SendAssessmentReminders.php` | Hourly cron command for assessment reminders | Created |
| `routes/console.php` | Schedule the reminder command hourly | Modified |
| `app/Notifications/CoachAssignedToSessionNotification.php` | New notif: coach added to a session | Created |
| `app/Notifications/SessionScheduleChangedNotification.php` | New notif: session start_at/venue/duration changed | Created |
| `app/Notifications/AssessmentReminderNotification.php` | New notif: session completed but ungraded | Created |
| `lang/id/notifications.php` | Indonesian strings: 3 titles + 3 bodies | Modified |
| `app/Http/Controllers/NotificationController.php` | Apply `whereIn('target_role', ['all', $activeRole])` filter to `index()` + `unreadCount()` | Modified |
| `app/Http/Controllers/Admin/SessionController.php` | Dispatch the two session-context notifs after `coaches()->sync(...)` | Modified |
| `tests/Feature/Notifications/NotificationTargetRoleObserverTest.php` | Observer auto-tags from config map | Created |
| `tests/Feature/Notifications/BackfillNotificationTargetRoleTest.php` | Backfill updates rows per map, idempotent | Created |
| `tests/Feature/Notifications/NotificationIndexFilterTest.php` | Index endpoint filters by active_role | Created |
| `tests/Feature/Notifications/CoachAssignedToSessionTest.php` | Dispatch on session create with coach + on update adding new coach | Created |
| `tests/Feature/Notifications/SessionScheduleChangedTest.php` | Dispatch on start_at/venue/duration change; skip on name/notes only | Created |
| `tests/Feature/Notifications/AssessmentReminderCommandTest.php` | Stale session triggers dispatch; sets `assessment_reminded_at`; idempotent | Created |

### Frontend — `D:\projects\Flutter\hyperarena`

| Path | Responsibility | Created/Modified |
|---|---|---|
| `lib/features/notification/data/models/notification_item.dart` | Add `targetRole` field + 3 new `NotificationType` values | Modified |
| `lib/features/notification/data/api_notification_repository.dart` | `_parseNotification` reads `target_role`; `_mapType`/`_titleFor`/`_bodyFor`/`_routeFor` get 3 new coach cases | Modified |
| `lib/features/notification/utils/notification_route_resolver.dart` | 3 new cases routing to `/coach/sessions/{id}` (FCM push tap path) | Modified |
| `lib/features/notification/presentation/widgets/notification_tile.dart` | Icon mapping for 3 new types | Modified |
| `test/features/notification/utils/notification_route_resolver_test.dart` | 3 new test cases | Modified |

---

## Phase 1 — BE Foundation: Migration, Config Map, Observer

### Task 1.1: Migration — add `target_role` and `assessment_reminded_at` columns

**Files:**
- Create: `C:\laragon\www\hypercoach\database\migrations\2026_06_03_xxxxxx_add_target_role_to_notifications_table.php` (use real timestamp from `php artisan make:migration`)

- [ ] **Step 1: Generate migration**

```bash
cd /c/laragon/www/hypercoach
php artisan make:migration add_target_role_to_notifications_table
```

Open the new file (timestamp will be today's date).

- [ ] **Step 2: Replace migration body**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('notifications', function (Blueprint $table) {
            // 'all' = visible regardless of activeRole.
            // Other values gate visibility via WHERE clause in
            // NotificationController@index and @unreadCount.
            $table->string('target_role', 16)->default('all')->after('data');
            $table->index('target_role');
        });

        Schema::table('coaching_sessions', function (Blueprint $table) {
            // Set when AssessmentReminderNotification fires. Single-fire policy:
            // once stamped, the hourly command skips re-reminding.
            $table->timestamp('assessment_reminded_at')->nullable()->after('completion_state');
        });
    }

    public function down(): void
    {
        Schema::table('coaching_sessions', function (Blueprint $table) {
            $table->dropColumn('assessment_reminded_at');
        });
        Schema::table('notifications', function (Blueprint $table) {
            $table->dropIndex(['target_role']);
            $table->dropColumn('target_role');
        });
    }
};
```

- [ ] **Step 3: Run migration locally**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan migrate
```

Expected: `Migrating: 2026_06_03_xxxxxx_add_target_role_to_notifications_table` then `Migrated:`.

- [ ] **Step 4: Verify schema**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="echo Schema::hasColumn('notifications', 'target_role') ? 'OK target_role' : 'FAIL';"
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="echo Schema::hasColumn('coaching_sessions', 'assessment_reminded_at') ? 'OK assessment_reminded_at' : 'FAIL';"
```

Expected: both print `OK ...`.

- [ ] **Step 5: Commit**

```bash
cd /c/laragon/www/hypercoach
git checkout -b feature/coach-notifications-role-filter
git add database/migrations/
git commit -m "Notifications: add target_role + assessment_reminded_at columns"
```

---

### Task 1.2: Config map — `config/notifications.php`

**Files:**
- Create: `C:\laragon\www\hypercoach\config\notifications.php`

- [ ] **Step 1: Create config file**

```php
<?php

/*
|--------------------------------------------------------------------------
| Notification target-role map
|--------------------------------------------------------------------------
|
| Maps notification class FQCN -> the role its content is relevant to.
| Drives:
|   1) BackfillNotificationTargetRole one-off command (existing rows)
|   2) NotificationTargetRoleObserver (every future dispatch)
|
| Unmapped classes default to 'all' (visible to every role). Add a row
| here when introducing a new notification type.
|
*/

return [
    'target_role_map' => [
        // Player audience
        \App\Notifications\BookingCancelledByAdminNotification::class => 'player',
        \App\Notifications\BookingConfirmation::class => 'player',
        \App\Notifications\PaymentRejected::class => 'player',
        \App\Notifications\ProgressUpdated::class => 'player',
        \App\Notifications\PurchaseConfirmedNotification::class => 'player',
        \App\Notifications\PurchasePending::class => 'player',
        \App\Notifications\SessionReminder::class => 'player',

        // Organizer audience
        \App\Notifications\InvoiceIssued::class => 'organizer',
        \App\Notifications\InvoicePaid::class => 'organizer',
        \App\Notifications\MemberCancelledBookingNotification::class => 'organizer',
        \App\Notifications\NewPurchaseForOrganizer::class => 'organizer',
        \App\Notifications\NewStudentRegistered::class => 'organizer',
        \App\Notifications\PaymentProofUploaded::class => 'organizer',
        \App\Notifications\SubscriptionStatusChanged::class => 'organizer',
        \App\Notifications\VenueCreatedNotification::class => 'organizer',
        \App\Notifications\VenueDeletionReviewedNotification::class => 'organizer',

        // Coach audience
        \App\Notifications\PayoutApproved::class => 'coach',
        \App\Notifications\SkillEditedNotification::class => 'coach',
        \App\Notifications\CoachAssignedToSessionNotification::class => 'coach',
        \App\Notifications\SessionScheduleChangedNotification::class => 'coach',
        \App\Notifications\AssessmentReminderNotification::class => 'coach',

        // Admin/platform audience
        \App\Notifications\VenueDeletionRequestedNotification::class => 'admin',
    ],
];
```

- [ ] **Step 2: Verify config loads**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="dump(count(config('notifications.target_role_map')));"
```

Expected: prints `21` (or whatever the actual count is — the array should not be empty).

- [ ] **Step 3: Commit**

```bash
git add config/notifications.php
git commit -m "Notifications: add target_role config map"
```

---

### Task 1.3: Observer — auto-tag notifications on creation

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Observers\NotificationTargetRoleObserver.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\NotificationTargetRoleObserverTest.php`
- Modify: `C:\laragon\www\hypercoach\app\Providers\AppServiceProvider.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Tenant;
use App\Models\User;
use App\Notifications\PaymentRejected;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class NotificationTargetRoleObserverTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function makeUser(): User
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'Test', 'slug' => 'test', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        return User::create([
            'tenant_id' => $tenant->id,
            'name' => 'X', 'email' => 'x@x.com', 'password' => 'p',
        ]);
    }

    public function test_observer_tags_known_notification_class_from_config_map(): void
    {
        $user = $this->makeUser();

        // PaymentRejected is mapped to 'player' in config/notifications.php
        $user->notify(new PaymentRejected(/* args: */ ...));
        // NOTE: PaymentRejected constructor signature must be respected.
        // If it takes specific args, use a Mockery / partial-mock pattern OR
        // a stub class for the test. Replace with whatever the simplest
        // construction path is for THIS notification class.

        $this->assertSame('player', $user->notifications()->latest()->first()->target_role);
    }

    public function test_observer_defaults_unmapped_to_all(): void
    {
        $user = $this->makeUser();

        $unmapped = new class extends \Illuminate\Notifications\Notification {
            public function via(object $notifiable): array { return ['database']; }
            public function toArray(object $notifiable): array { return ['x' => 1]; }
        };
        $user->notify($unmapped);

        $this->assertSame('all', $user->notifications()->latest()->first()->target_role);
    }
}
```

If `PaymentRejected`'s constructor is non-trivial (takes models), replace its block with a custom test notification that resolves to a known FQCN present in the config map. Simplest approach: add a temporary mapping in the test using `Config::set('notifications.target_role_map', [TestNotification::class => 'player'])`.

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter NotificationTargetRoleObserverTest
```

Expected: FAIL — observer doesn't exist yet, `target_role` defaults to 'all' for all notifications including PaymentRejected.

- [ ] **Step 3: Write the observer**

`app/Observers/NotificationTargetRoleObserver.php`:

```php
<?php

namespace App\Observers;

use Illuminate\Notifications\DatabaseNotification;

class NotificationTargetRoleObserver
{
    public function creating(DatabaseNotification $notification): void
    {
        // Skip if already set explicitly (the dispatcher knew best).
        if ($notification->target_role !== null && $notification->target_role !== 'all') {
            return;
        }

        $map = config('notifications.target_role_map', []);
        $notification->target_role = $map[$notification->type] ?? 'all';
    }
}
```

- [ ] **Step 4: Register observer in AppServiceProvider**

Edit `app/Providers/AppServiceProvider.php`. Inside `boot()`, add:

```php
use App\Observers\NotificationTargetRoleObserver;
use Illuminate\Notifications\DatabaseNotification;
// ... existing imports

public function boot(): void
{
    // ... existing boot logic
    DatabaseNotification::observe(NotificationTargetRoleObserver::class);
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter NotificationTargetRoleObserverTest
```

Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add app/Observers/NotificationTargetRoleObserver.php app/Providers/AppServiceProvider.php tests/Feature/Notifications/NotificationTargetRoleObserverTest.php
git commit -m "Notifications: observer auto-tags target_role from config map"
```

---

## Phase 2 — BE Backfill: Existing Rows

### Task 2.1: Backfill command

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Console\Commands\BackfillNotificationTargetRole.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\BackfillNotificationTargetRoleTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Tenant;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Notifications\DatabaseNotification;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

class BackfillNotificationTargetRoleTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function seedRow(User $user, string $type, string $targetRole): string
    {
        $id = (string) Str::uuid();
        DB::table('notifications')->insert([
            'id' => $id,
            'type' => $type,
            'notifiable_type' => User::class,
            'notifiable_id' => $user->id,
            'data' => json_encode(['x' => 1]),
            'target_role' => $targetRole,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        return $id;
    }

    public function test_backfill_updates_rows_per_map(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $user = User::create([
            'tenant_id' => $tenant->id, 'name' => 'U',
            'email' => 'u@x.com', 'password' => 'p',
        ]);

        // Seed rows in their pre-backfill state (target_role = 'all').
        $playerRow = $this->seedRow($user, \App\Notifications\PaymentRejected::class, 'all');
        $coachRow = $this->seedRow($user, \App\Notifications\PayoutApproved::class, 'all');

        Artisan::call('notifications:backfill-target-role');

        $this->assertSame(
            'player',
            DB::table('notifications')->where('id', $playerRow)->value('target_role')
        );
        $this->assertSame(
            'coach',
            DB::table('notifications')->where('id', $coachRow)->value('target_role')
        );
    }

    public function test_backfill_is_idempotent_and_does_not_overwrite_non_all_rows(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't', 'country' => 'ID',
            'timezone' => 'Asia/Jakarta', 'currency' => 'IDR', 'default_locale' => 'id',
        ]);
        $user = User::create([
            'tenant_id' => $tenant->id, 'name' => 'U',
            'email' => 'u@x.com', 'password' => 'p',
        ]);

        // Row already correctly tagged — must not be touched.
        $tagged = $this->seedRow($user, \App\Notifications\PaymentRejected::class, 'player');

        // Sentinel: manually-tagged value the backfill must not stomp.
        DB::table('notifications')->where('id', $tagged)->update(['target_role' => 'manual-sentinel']);

        Artisan::call('notifications:backfill-target-role');

        $this->assertSame(
            'manual-sentinel',
            DB::table('notifications')->where('id', $tagged)->value('target_role')
        );
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter BackfillNotificationTargetRoleTest
```

Expected: FAIL — command doesn't exist (`Command "notifications:backfill-target-role" is not defined.`).

- [ ] **Step 3: Write the command**

`app/Console/Commands/BackfillNotificationTargetRole.php`:

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class BackfillNotificationTargetRole extends Command
{
    protected $signature = 'notifications:backfill-target-role';

    protected $description = 'One-off: tag existing notifications.target_role from config/notifications.php map. Only touches rows currently set to "all".';

    public function handle(): int
    {
        $map = config('notifications.target_role_map', []);
        if (empty($map)) {
            $this->error('config/notifications.php target_role_map is empty — nothing to do.');
            return self::FAILURE;
        }

        $total = 0;
        foreach ($map as $class => $role) {
            $updated = DB::table('notifications')
                ->where('type', $class)
                ->where('target_role', 'all')
                ->update(['target_role' => $role]);
            if ($updated > 0) {
                $this->line("  {$class} -> {$role}: {$updated} rows");
                $total += $updated;
            }
        }

        $this->info("Done. {$total} rows updated.");
        return self::SUCCESS;
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter BackfillNotificationTargetRoleTest
```

Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Console/Commands/BackfillNotificationTargetRole.php tests/Feature/Notifications/BackfillNotificationTargetRoleTest.php
git commit -m "Notifications: add backfill-target-role command"
```

---

## Phase 3 — BE Endpoint Filter

### Task 3.1: Apply `target_role` filter to `index()` and `unreadCount()`

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\NotificationController.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\NotificationIndexFilterTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Plan;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class NotificationIndexFilterTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function setupTenantAndUser(string $activeRole, array $availableRoles): User
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
            'tenant_id' => $tenant->id, 'plan_id' => $plan->id,
            'status' => 'active', 'started_at' => now(),
        ]);

        $user = User::create([
            'tenant_id' => $tenant->id, 'name' => 'Multi',
            'email' => 'multi@x.com', 'password' => 'p',
            'active_role' => $activeRole,
        ]);
        foreach ($availableRoles as $r) {
            $user->assignRole($r);
        }
        return $user;
    }

    private function seedNotif(User $user, string $type, string $targetRole): void
    {
        DB::table('notifications')->insert([
            'id' => (string) Str::uuid(),
            'type' => $type,
            'notifiable_type' => User::class,
            'notifiable_id' => $user->id,
            'data' => json_encode(['x' => 1]),
            'target_role' => $targetRole,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_index_returns_only_notifs_matching_active_role_or_all(): void
    {
        $user = $this->setupTenantAndUser('coach', ['coach', 'organizer']);

        $this->seedNotif($user, \App\Notifications\PaymentRejected::class, 'player');
        $this->seedNotif($user, \App\Notifications\PayoutApproved::class, 'coach');
        $this->seedNotif($user, \App\Notifications\NewPurchaseForOrganizer::class, 'organizer');
        $this->seedNotif($user, \App\Notifications\PayoutApproved::class, 'all');

        Sanctum::actingAs($user);

        $res = $this->getJson('http://t.hypercoach.local/api/v1/notifications');
        $res->assertOk();
        $data = $res->json('data');

        $roles = collect($data)->pluck('target_role')->all();
        $this->assertContains('coach', $roles);
        $this->assertContains('all', $roles);
        $this->assertNotContains('player', $roles);
        $this->assertNotContains('organizer', $roles);
    }

    public function test_index_swaps_visibility_when_active_role_changes(): void
    {
        $user = $this->setupTenantAndUser('organizer', ['coach', 'organizer']);

        $this->seedNotif($user, \App\Notifications\PayoutApproved::class, 'coach');
        $this->seedNotif($user, \App\Notifications\NewPurchaseForOrganizer::class, 'organizer');

        Sanctum::actingAs($user);

        $res = $this->getJson('http://t.hypercoach.local/api/v1/notifications');
        $roles = collect($res->json('data'))->pluck('target_role')->all();
        $this->assertContains('organizer', $roles);
        $this->assertNotContains('coach', $roles);
    }

    public function test_unread_count_respects_filter(): void
    {
        $user = $this->setupTenantAndUser('coach', ['coach', 'organizer']);

        // 2 unread coach + 3 unread organizer + 1 unread all
        for ($i = 0; $i < 2; $i++) $this->seedNotif($user, \App\Notifications\PayoutApproved::class, 'coach');
        for ($i = 0; $i < 3; $i++) $this->seedNotif($user, \App\Notifications\NewPurchaseForOrganizer::class, 'organizer');
        $this->seedNotif($user, \App\Notifications\PayoutApproved::class, 'all');

        Sanctum::actingAs($user);

        $res = $this->getJson('http://t.hypercoach.local/api/v1/notifications/unread-count');
        $res->assertOk();
        $this->assertSame(3, $res->json('count'));  // 2 coach + 1 all
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter NotificationIndexFilterTest
```

Expected: FAIL — all 3 tests fail because the controller currently returns every notification regardless of target_role.

- [ ] **Step 3: Apply the filter clause to both methods**

Replace `app/Http/Controllers/NotificationController.php` `index()` and `unreadCount()` methods:

```php
/**
 * GET /notifications — list user's notifications (paginated, newest first)
 *
 * Filtered by target_role to match the user's active role (or 'all').
 */
public function index(Request $request): JsonResponse
{
    $activeRole = $request->user()->active_role ?? $request->user()->role;

    $notifications = $request->user()
        ->notifications()
        ->whereIn('target_role', ['all', $activeRole])
        ->orderBy('created_at', 'desc')
        ->paginate($request->input('per_page', 15));

    return response()->json($notifications);
}

/**
 * GET /notifications/unread-count — count of unread notifications
 *
 * Filtered by target_role to match the user's active role (or 'all').
 */
public function unreadCount(Request $request): JsonResponse
{
    $activeRole = $request->user()->active_role ?? $request->user()->role;

    $count = $request->user()
        ->unreadNotifications()
        ->whereIn('target_role', ['all', $activeRole])
        ->count();

    return response()->json(['count' => $count]);
}
```

`$request->user()->role` falls back when `active_role` is null — handles users who haven't gone through role-switching yet.

- [ ] **Step 4: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter NotificationIndexFilterTest
```

Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Http/Controllers/NotificationController.php tests/Feature/Notifications/NotificationIndexFilterTest.php
git commit -m "Notifications: filter index + unread-count by target_role active_role"
```

---

## Phase 4 — BE Notification Classes (3 tasks)

### Task 4.1: `CoachAssignedToSessionNotification`

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\CoachAssignedToSessionNotification.php`
- Modify: `C:\laragon\www\hypercoach\lang\id\notifications.php`

- [ ] **Step 1: Add Indonesian lang strings**

In `lang/id/notifications.php`, add (alongside existing keys):

```php
    'coach_assigned_to_session_title' => 'Anda terdaftar sebagai coach',
    'coach_assigned_to_session_body' => ':session_name pada :starts_at',
```

If the file doesn't exist (verify with `ls lang/id/notifications.php`), create it. If it exists, append before the closing `];`.

- [ ] **Step 2: Write the notification class**

```php
<?php

namespace App\Notifications;

use App\Models\Coach;
use App\Models\Session;
use App\Notifications\Concerns\HasFcmChannel;
use App\Support\TenantTime;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class CoachAssignedToSessionNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(
        private Session $session,
        private Coach $coach,
    ) {}

    public function via(object $notifiable): array
    {
        return ['database', 'fcm'];
    }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';
        $startsAt = TenantTime::format($this->session->start_at);

        return [
            'type' => self::class,
            'session_id' => $this->session->id,
            'session_name' => $this->session->name,
            'starts_at' => $startsAt,
            'venue_name' => $this->session->venue?->name,
            'route' => "/coach/sessions/{$this->session->id}",
            'title' => __('notifications.coach_assigned_to_session_title', [], $locale),
            'body' => __('notifications.coach_assigned_to_session_body', [
                'session_name' => $this->session->name,
                'starts_at' => $startsAt,
            ], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);

        return (new FcmMessage(notification: new FcmNotification(
            title: $payload['title'],
            body: $payload['body'],
        )))
            ->data([
                'type' => 'coach_assigned_to_session',
                'session_id' => (string) $this->session->id,
                'route' => $payload['route'],
            ]);
    }
}
```

If `App\Support\TenantTime` doesn't exist or has a different method name, check existing notifications (e.g. `PayoutApproved`) for the actual date-format helper used.

- [ ] **Step 3: Write the dispatch test**

Test for this notification's dispatch is part of Task 5.1 (the controller change). Here we only verify the class compiles and instantiates correctly. Quick sanity check:

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="dump(class_exists(\App\Notifications\CoachAssignedToSessionNotification::class));"
```

Expected: prints `true`.

- [ ] **Step 4: Commit**

```bash
git add app/Notifications/CoachAssignedToSessionNotification.php lang/id/notifications.php
git commit -m "Notifications: add CoachAssignedToSessionNotification"
```

---

### Task 4.2: `SessionScheduleChangedNotification`

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\SessionScheduleChangedNotification.php`
- Modify: `C:\laragon\www\hypercoach\lang\id\notifications.php`

- [ ] **Step 1: Add Indonesian lang strings**

Append to `lang/id/notifications.php`:

```php
    'session_schedule_changed_title' => 'Perubahan jadwal sesi',
    'session_schedule_changed_body' => ':session_name kini pada :new_starts_at',
```

- [ ] **Step 2: Write the notification class**

```php
<?php

namespace App\Notifications;

use App\Models\Session;
use App\Notifications\Concerns\HasFcmChannel;
use App\Support\TenantTime;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Carbon;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class SessionScheduleChangedNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(
        private Session $session,
        private array $changedFields,
        private Carbon $oldStartAt,
    ) {}

    public function via(object $notifiable): array
    {
        return ['database', 'fcm'];
    }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';
        $newStartsAt = TenantTime::format($this->session->start_at);

        return [
            'type' => self::class,
            'session_id' => $this->session->id,
            'session_name' => $this->session->name,
            'old_starts_at' => TenantTime::format($this->oldStartAt),
            'new_starts_at' => $newStartsAt,
            'venue_name' => $this->session->venue?->name,
            'changed_fields' => array_keys($this->changedFields),
            'route' => "/coach/sessions/{$this->session->id}",
            'title' => __('notifications.session_schedule_changed_title', [], $locale),
            'body' => __('notifications.session_schedule_changed_body', [
                'session_name' => $this->session->name,
                'new_starts_at' => $newStartsAt,
            ], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);

        return (new FcmMessage(notification: new FcmNotification(
            title: $payload['title'],
            body: $payload['body'],
        )))
            ->data([
                'type' => 'session_schedule_change',
                'session_id' => (string) $this->session->id,
                'route' => $payload['route'],
            ]);
    }
}
```

- [ ] **Step 3: Sanity check**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="dump(class_exists(\App\Notifications\SessionScheduleChangedNotification::class));"
```

Expected: prints `true`.

- [ ] **Step 4: Commit**

```bash
git add app/Notifications/SessionScheduleChangedNotification.php lang/id/notifications.php
git commit -m "Notifications: add SessionScheduleChangedNotification"
```

---

### Task 4.3: `AssessmentReminderNotification`

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Notifications\AssessmentReminderNotification.php`
- Modify: `C:\laragon\www\hypercoach\lang\id\notifications.php`

- [ ] **Step 1: Add Indonesian lang strings**

Append to `lang/id/notifications.php`:

```php
    'assessment_reminder_title' => 'Penilaian belum diisi',
    'assessment_reminder_body' => ':students_count murid menunggu penilaian di sesi :session_name',
```

- [ ] **Step 2: Write the notification class**

```php
<?php

namespace App\Notifications;

use App\Models\Coach;
use App\Models\Session;
use App\Notifications\Concerns\HasFcmChannel;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

class AssessmentReminderNotification extends Notification implements ShouldQueue
{
    use HasFcmChannel, Queueable;

    public function __construct(
        private Session $session,
        private Coach $coach,
        private int $studentsUngraded,
    ) {}

    public function via(object $notifiable): array
    {
        return ['database', 'fcm'];
    }

    public function toArray(object $notifiable): array
    {
        $locale = $notifiable->locale ?? 'id';

        return [
            'type' => self::class,
            'session_id' => $this->session->id,
            'session_name' => $this->session->name,
            'students_ungraded_count' => $this->studentsUngraded,
            'route' => "/coach/sessions/{$this->session->id}",
            'title' => __('notifications.assessment_reminder_title', [], $locale),
            'body' => __('notifications.assessment_reminder_body', [
                'students_count' => $this->studentsUngraded,
                'session_name' => $this->session->name,
            ], $locale),
        ];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $payload = $this->toArray($notifiable);

        return (new FcmMessage(notification: new FcmNotification(
            title: $payload['title'],
            body: $payload['body'],
        )))
            ->data([
                'type' => 'assessment_reminder',
                'session_id' => (string) $this->session->id,
                'route' => $payload['route'],
            ]);
    }
}
```

- [ ] **Step 3: Sanity check + commit**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan tinker --execute="dump(class_exists(\App\Notifications\AssessmentReminderNotification::class));"
git add app/Notifications/AssessmentReminderNotification.php lang/id/notifications.php
git commit -m "Notifications: add AssessmentReminderNotification"
```

---

## Phase 5 — BE Trigger Wiring

### Task 5.1: Dispatch `CoachAssignedToSession` on session create + coach add

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Admin\SessionController.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\CoachAssignedToSessionTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\CoachAssignedToSessionNotification;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Notification;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class CoachAssignedToSessionTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private User $adminUser;
    private Coach $coach1;
    private Coach $coach2;

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

        $this->adminUser = User::create([
            'tenant_id' => $this->tenant->id, 'name' => 'Admin',
            'email' => 'admin@x.com', 'password' => 'p',
        ]);
        $this->adminUser->assignRole('admin');

        $u1 = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C1', 'email' => 'c1@x.com', 'password' => 'p']);
        $u2 = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C2', 'email' => 'c2@x.com', 'password' => 'p']);
        $u1->assignRole('coach');
        $u2->assignRole('coach');

        $this->coach1 = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $u1->id, 'status' => 'active']);
        $this->coach2 = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $u2->id, 'status' => 'active']);
    }

    public function test_dispatch_on_session_create_to_each_assigned_coach(): void
    {
        Notification::fake();
        Sanctum::actingAs($this->adminUser);

        $payload = [
            'name' => 'Sesi Test',
            'type' => 'group',
            'start_at' => now()->addDay()->toIso8601String(),
            'duration_minutes' => 60,
            'capacity' => 10,
            'coach_ids' => [$this->coach1->id, $this->coach2->id],
        ];

        $this->postJson('http://t.hypercoach.local/api/v1/admin/sessions', $payload)
             ->assertCreated();

        Notification::assertSentTo(
            [$this->coach1->user, $this->coach2->user],
            CoachAssignedToSessionNotification::class
        );
    }

    public function test_dispatch_only_to_newly_added_coach_on_update(): void
    {
        // Pre-create session with coach1
        $session = Session::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'Existing',
            'type' => 'group',
            'start_at' => now()->addDay(),
            'duration_minutes' => 60,
            'capacity' => 10,
            'status' => 'scheduled',
        ]);
        $session->coaches()->sync([$this->coach1->id]);

        Notification::fake();
        Sanctum::actingAs($this->adminUser);

        // Update: add coach2; coach1 stays
        $payload = [
            'name' => 'Existing',
            'type' => 'group',
            'start_at' => $session->start_at->toIso8601String(),
            'duration_minutes' => 60,
            'capacity' => 10,
            'coach_ids' => [$this->coach1->id, $this->coach2->id],
        ];

        $this->putJson("http://t.hypercoach.local/api/v1/admin/sessions/{$session->id}", $payload)
             ->assertOk();

        // coach2 (newly added) gets notified
        Notification::assertSentTo($this->coach2->user, CoachAssignedToSessionNotification::class);
        // coach1 (already on session) does NOT get re-notified
        Notification::assertNotSentTo($this->coach1->user, CoachAssignedToSessionNotification::class);
    }
}
```

If the actual session-create / session-update payload shape differs from the test's body (field names, nested structures, etc.), inspect `app/Http/Requests/Admin/StoreSessionRequest.php` and `UpdateSessionRequest.php` for the canonical field list, then adapt the test bodies.

- [ ] **Step 2: Run test to verify it fails**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachAssignedToSessionTest
```

Expected: FAIL — `Notification::assertSentTo()` reports no notifications dispatched.

- [ ] **Step 3: Add dispatch logic in `SessionController@store`**

In `app/Http/Controllers/Admin/SessionController.php`, find the `store()` method around line 146. After the `$session->coaches()->sync($coachIds);` call (around line 184), append:

```php
// Notify each assigned coach.
if (!empty($coachIds)) {
    $coaches = Coach::with('user')->whereIn('id', $coachIds)->get();
    foreach ($coaches as $coach) {
        if ($coach->user) {
            $coach->user->notify(new \App\Notifications\CoachAssignedToSessionNotification($session->fresh(), $coach));
        }
    }
}
```

If the controller already imports `App\Models\Coach`, drop the `\App\Notifications\` FQCN prefix and add the import at the top.

- [ ] **Step 4: Add dispatch logic in `SessionController@update`**

In the same file, find the `update()` method around line 230. Before the `$session->coaches()->sync($newCoachIds);` call (around line 281), capture the existing coach IDs:

```php
$oldCoachIds = $session->coaches->pluck('id')->all();
```

After the sync, append:

```php
$addedCoachIds = array_diff($newCoachIds, $oldCoachIds);
if (!empty($addedCoachIds)) {
    $addedCoaches = Coach::with('user')->whereIn('id', $addedCoachIds)->get();
    foreach ($addedCoaches as $coach) {
        if ($coach->user) {
            $coach->user->notify(new \App\Notifications\CoachAssignedToSessionNotification($session->fresh(), $coach));
        }
    }
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter CoachAssignedToSessionTest
```

Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add app/Http/Controllers/Admin/SessionController.php tests/Feature/Notifications/CoachAssignedToSessionTest.php
git commit -m "Sessions: dispatch CoachAssignedToSession on create + on coach add"
```

---

### Task 5.2: Dispatch `SessionScheduleChanged` on start_at / venue / duration change

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Admin\SessionController.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\SessionScheduleChangedTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\SessionScheduleChangedNotification;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Notification;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class SessionScheduleChangedTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private User $adminUser;
    private Coach $coach;
    private Session $session;

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

        $this->adminUser = User::create([
            'tenant_id' => $this->tenant->id, 'name' => 'A',
            'email' => 'a@x.com', 'password' => 'p',
        ]);
        $this->adminUser->assignRole('admin');

        $u = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $u->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $u->id, 'status' => 'active']);

        $this->session = Session::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'S',
            'type' => 'group',
            'start_at' => now()->addDays(2),
            'duration_minutes' => 60,
            'capacity' => 10,
            'status' => 'scheduled',
        ]);
        $this->session->coaches()->sync([$this->coach->id]);
    }

    public function test_dispatch_on_start_at_change(): void
    {
        Notification::fake();
        Sanctum::actingAs($this->adminUser);

        $payload = [
            'name' => 'S',
            'type' => 'group',
            'start_at' => now()->addDays(3)->toIso8601String(),  // shifted
            'duration_minutes' => 60,
            'capacity' => 10,
            'coach_ids' => [$this->coach->id],
        ];

        $this->putJson("http://t.hypercoach.local/api/v1/admin/sessions/{$this->session->id}", $payload)
             ->assertOk();

        Notification::assertSentTo($this->coach->user, SessionScheduleChangedNotification::class);
    }

    public function test_skip_on_name_only_change(): void
    {
        Notification::fake();
        Sanctum::actingAs($this->adminUser);

        $payload = [
            'name' => 'New Name',  // only the name changed
            'type' => 'group',
            'start_at' => $this->session->start_at->toIso8601String(),
            'duration_minutes' => 60,
            'capacity' => 10,
            'coach_ids' => [$this->coach->id],
        ];

        $this->putJson("http://t.hypercoach.local/api/v1/admin/sessions/{$this->session->id}", $payload)
             ->assertOk();

        Notification::assertNotSentTo($this->coach->user, SessionScheduleChangedNotification::class);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter SessionScheduleChangedTest
```

Expected: FAIL — both tests assert dispatch behaviour that hasn't been wired yet.

- [ ] **Step 3: Add schedule-change dispatch in `SessionController@update`**

In `app/Http/Controllers/Admin/SessionController.php` `update()`, BEFORE the `$session->fill(...)->save();` (or equivalent — locate the actual save call), capture original values:

```php
$originalStartAt = $session->start_at;
$originalDurationMinutes = $session->duration_minutes;
$originalVenueId = $session->venue_id;
```

After the save (and after the existing coach-sync logic), add:

```php
$startAtChanged = !$originalStartAt->equalTo($session->fresh()->start_at);
$durationChanged = $originalDurationMinutes !== $session->fresh()->duration_minutes;
$venueChanged = $originalVenueId !== $session->fresh()->venue_id;

if ($startAtChanged || $durationChanged || $venueChanged) {
    $changedFields = [];
    if ($startAtChanged) $changedFields['start_at'] = $originalStartAt;
    if ($durationChanged) $changedFields['duration_minutes'] = $originalDurationMinutes;
    if ($venueChanged) $changedFields['venue_id'] = $originalVenueId;

    // Notify all assigned coaches EXCEPT those who are newly-added on this same
    // request — they already get CoachAssignedToSession with the new schedule.
    $existingCoachIds = array_intersect(
        $oldCoachIds ?? $session->coaches->pluck('id')->all(),
        $newCoachIds
    );
    $existingCoaches = Coach::with('user')->whereIn('id', $existingCoachIds)->get();

    foreach ($existingCoaches as $coach) {
        if ($coach->user) {
            $coach->user->notify(new \App\Notifications\SessionScheduleChangedNotification(
                $session->fresh(),
                $changedFields,
                \Illuminate\Support\Carbon::parse($originalStartAt),
            ));
        }
    }
}
```

This depends on `$oldCoachIds` being captured from Task 5.1 — keep both blocks in the same method.

- [ ] **Step 4: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter SessionScheduleChangedTest
```

Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Http/Controllers/Admin/SessionController.php tests/Feature/Notifications/SessionScheduleChangedTest.php
git commit -m "Sessions: dispatch SessionScheduleChanged on start_at/venue/duration change"
```

---

### Task 5.3: `SendAssessmentReminders` command + console schedule

**Files:**
- Create: `C:\laragon\www\hypercoach\app\Console\Commands\SendAssessmentReminders.php`
- Modify: `C:\laragon\www\hypercoach\routes\console.php`
- Test: `C:\laragon\www\hypercoach\tests\Feature\Notifications\AssessmentReminderCommandTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Notifications;

use App\Models\Coach;
use App\Models\Plan;
use App\Models\Session;
use App\Models\SessionStudent;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\TenantSubscription;
use App\Models\User;
use App\Notifications\AssessmentReminderNotification;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Notification;
use Tests\TestCase;

class AssessmentReminderCommandTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private Coach $coach;

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
        $u = User::create(['tenant_id' => $this->tenant->id, 'name' => 'C', 'email' => 'c@x.com', 'password' => 'p']);
        $u->assignRole('coach');
        $this->coach = Coach::create(['tenant_id' => $this->tenant->id, 'user_id' => $u->id, 'status' => 'active']);
    }

    private function makeStaleUngradedSession(int $bookedStudentCount): Session
    {
        $session = Session::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'Ungraded',
            'type' => 'group',
            'start_at' => now()->subHours(6),  // > 4-hour grace
            'duration_minutes' => 60,
            'capacity' => 10,
            'status' => 'completed',
            'completion_state' => 'needs_grading',
            'assessment_reminded_at' => null,
        ]);
        $session->coaches()->sync([$this->coach->id]);

        for ($i = 0; $i < $bookedStudentCount; $i++) {
            $sp = StudentProfile::create([
                'tenant_id' => $this->tenant->id,
                'first_name' => "S{$i}",
                'last_name' => 'X',
            ]);
            SessionStudent::create([
                'session_id' => $session->id,
                'student_profile_id' => $sp->id,
                'booked_at' => now()->subDays(2),
            ]);
        }

        return $session;
    }

    public function test_fires_on_stale_ungraded_session(): void
    {
        Notification::fake();

        $session = $this->makeStaleUngradedSession(3);

        Artisan::call('coach:assessment-reminders');

        Notification::assertSentTo($this->coach->user, AssessmentReminderNotification::class);
        $this->assertNotNull($session->fresh()->assessment_reminded_at);
    }

    public function test_does_not_re_fire_after_marked_reminded(): void
    {
        Notification::fake();

        $session = $this->makeStaleUngradedSession(3);
        $session->update(['assessment_reminded_at' => now()]);

        Artisan::call('coach:assessment-reminders');

        Notification::assertNothingSent();
    }

    public function test_skips_session_with_zero_ungraded_students(): void
    {
        Notification::fake();

        // Session with no booked students at all — ungraded count = 0
        $session = Session::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'Empty',
            'type' => 'group',
            'start_at' => now()->subHours(6),
            'duration_minutes' => 60,
            'capacity' => 10,
            'status' => 'completed',
            'completion_state' => 'needs_grading',
        ]);
        $session->coaches()->sync([$this->coach->id]);

        Artisan::call('coach:assessment-reminders');

        Notification::assertNothingSent();
        $this->assertNull($session->fresh()->assessment_reminded_at);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter AssessmentReminderCommandTest
```

Expected: FAIL — `Command "coach:assessment-reminders" is not defined.`

- [ ] **Step 3: Write the command**

`app/Console/Commands/SendAssessmentReminders.php`:

```php
<?php

namespace App\Console\Commands;

use App\Models\Coach;
use App\Models\Session;
use App\Notifications\AssessmentReminderNotification;
use Illuminate\Console\Command;

class SendAssessmentReminders extends Command
{
    protected $signature = 'coach:assessment-reminders';

    protected $description = 'Notify coaches about sessions completed but not yet graded (single-fire, hourly).';

    public function handle(): int
    {
        $cutoff = now()->subHours(4); // 4-hour grace before nagging

        $sessions = Session::query()
            ->where('completion_state', 'needs_grading')
            ->where('start_at', '<', $cutoff)
            ->whereNull('assessment_reminded_at')
            ->with('coaches.user')
            ->get();

        $dispatched = 0;
        foreach ($sessions as $session) {
            // Count students missing per-session progress.
            $studentsUngraded = $session->sessionStudents()
                ->whereNull('cancelled_at')
                ->whereDoesntHave('sessionProgress', fn ($q) => $q->where('session_id', $session->id))
                ->count();

            if ($studentsUngraded === 0) {
                continue;
            }

            foreach ($session->coaches as $coach) {
                if ($coach->user) {
                    $coach->user->notify(new AssessmentReminderNotification($session, $coach, $studentsUngraded));
                    $dispatched++;
                }
            }
            $session->update(['assessment_reminded_at' => now()]);
        }

        $this->info("Reminders dispatched: {$dispatched}");
        return self::SUCCESS;
    }
}
```

- [ ] **Step 4: Schedule the command in `routes/console.php`**

Append:

```php
use Illuminate\Support\Facades\Schedule;

Schedule::command('coach:assessment-reminders')
    ->hourly()
    ->withoutOverlapping()
    ->onOneServer();
```

(If the file already has the `Schedule` import, don't duplicate it.)

- [ ] **Step 5: Run test to verify it passes**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter AssessmentReminderCommandTest
```

Expected: PASS (3 tests).

- [ ] **Step 6: Commit**

```bash
git add app/Console/Commands/SendAssessmentReminders.php routes/console.php tests/Feature/Notifications/AssessmentReminderCommandTest.php
git commit -m "Sessions: hourly assessment-reminders command (single-fire policy)"
```

---

## Phase 6 — FE Updates

Switch to the Flutter repo:

```bash
cd /d/projects/Flutter/hyperarena
git status   # verify on feature/coach-dashboard-redesign or current working branch
```

### Task 6.1: `NotificationItem` model — add `targetRole` + 3 enum values

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\data\models\notification_item.dart`

- [ ] **Step 1: Replace the file**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

enum NotificationType {
  paymentReminder,
  sessionReminder,
  reviewRequest,
  assessmentReceived,
  bookingConfirmed,
  sessionFull,
  sessionCancelled,
  paymentConfirmed,
  paymentRejected,
  badge,
  general,
  // New (coach context)
  coachAssignedToSession,
  sessionScheduleChange,
  assessmentReminder,
}

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? actionRoute,
    String? relatedId,
    // Informational only — BE has already filtered the list by activeRole.
    // Defensive default 'all' so older clients survive missing field.
    @JsonKey(name: 'target_role') @Default('all') String targetRole,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
```

- [ ] **Step 2: Regenerate Freezed**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: regenerates `notification_item.freezed.dart` and `notification_item.g.dart` with the new field + enum values.

- [ ] **Step 3: Run analyzer**

```bash
flutter analyze lib/features/notification/data/models/notification_item.dart
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/notification/data/models/notification_item.dart lib/features/notification/data/models/notification_item.freezed.dart lib/features/notification/data/models/notification_item.g.dart
git commit -m "Notifications: add targetRole field + 3 new types to NotificationItem"
```

---

### Task 6.2: Repository parser — type mapping + title/body/route + targetRole

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\data\api_notification_repository.dart`

The repo's `_parseNotification` builds each `NotificationItem` from the BE response. It manually maps `data['type']` strings to:
1. `NotificationType` enum (via `_mapType`)
2. FE-side Indonesian title (via `_titleFor`)
3. FE-side Indonesian body (via `_bodyFor`)
4. `actionRoute` (via `_routeFor`)

We add 3 new cases to each helper plus thread `target_role` from the data into the constructed item.

- [ ] **Step 1: Read the existing file**

```bash
cat lib/features/notification/data/api_notification_repository.dart
```

Identify the current `_mapType`, `_titleFor`, `_bodyFor`, `_routeFor` switch expressions.

- [ ] **Step 2: Update `_mapType`**

Append to the switch in `_mapType()`:

```dart
'coach_assigned_to_session' => NotificationType.coachAssignedToSession,
'session_schedule_change' => NotificationType.sessionScheduleChange,
'assessment_reminder' => NotificationType.assessmentReminder,
```

These slot in BEFORE the `_ => NotificationType.general` default.

- [ ] **Step 3: Update `_titleFor`**

Append:

```dart
'coach_assigned_to_session' => 'Anda terdaftar sebagai coach',
'session_schedule_change' => 'Perubahan jadwal sesi',
'assessment_reminder' => 'Penilaian belum diisi',
```

Before the `_ => 'Notifikasi'` default.

- [ ] **Step 4: Update `_bodyFor`**

Append cases that read interpolation values from `data`:

```dart
'coach_assigned_to_session' => '${data['session_name'] ?? 'Sesi'} pada ${data['starts_at'] ?? ''}',
'session_schedule_change' => '${data['session_name'] ?? 'Sesi'} kini pada ${data['new_starts_at'] ?? ''}',
'assessment_reminder' => '${data['students_ungraded_count'] ?? 0} murid menunggu penilaian di sesi ${data['session_name'] ?? ''}',
```

The exact body strings should match BE's lang strings semantically; the FE format reads the parameters that `toArray()` writes into the `data` JSON in Phase 4.

- [ ] **Step 5: Update `_routeFor`**

Append:

```dart
'coach_assigned_to_session' ||
'session_schedule_change' ||
'assessment_reminder' => _coachSessionRoute(data),
```

Add the helper method at the bottom of the class:

```dart
String? _coachSessionRoute(Map<String, dynamic> data) {
  final sessionId = data['session_id']?.toString();
  if (sessionId == null) return null;
  return '/coach/sessions/$sessionId';
}
```

If `AppRoutes.coachSessionDetail(...)` exists (check `lib/routing/app_routes.dart`), prefer using it: `return AppRoutes.coachSessionDetail(sessionId);` — keeps route strings centralized.

- [ ] **Step 6: Thread `target_role` into the constructed item**

In `_parseNotification`, after `final dataType = data['type'] as String? ?? 'general';`, add:

```dart
final targetRole = data['target_role'] as String? ?? 'all';
```

Then in the `NotificationItem(...)` constructor call, add the field:

```dart
return NotificationItem(
  id: json['id'] as String,
  type: _mapType(dataType),
  title: _titleFor(dataType, data),
  body: _bodyFor(dataType, data),
  createdAt: DateTime.parse(json['created_at'] as String),
  isRead: json['read_at'] != null,
  actionRoute: _routeFor(dataType, data),
  relatedId: _relatedIdFor(dataType, data),
  targetRole: targetRole,  // NEW
);
```

- [ ] **Step 7: Run analyzer + full test suite**

```bash
flutter analyze lib/features/notification/data/api_notification_repository.dart
flutter test
```

Expected: clean analyzer, no test regressions.

- [ ] **Step 8: Commit**

```bash
git add lib/features/notification/data/api_notification_repository.dart
git commit -m "Notifications: parse target_role + map 3 new coach types in repo parser"
```

---

### Task 6.3: FCM push tap resolver — 3 new cases

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\utils\notification_route_resolver.dart`
- Test: `D:\projects\Flutter\hyperarena\test\features\notification\utils\notification_route_resolver_test.dart`

`notification_route_resolver.dart` handles tap on FCM push (when app is launched from notification). The repo parser (Task 6.2) handles in-app tile tap (which uses stored `actionRoute`). Both paths need the 3 new types.

Existing file structure (per `lib/features/notification/utils/notification_route_resolver.dart`):

```dart
class NotificationRouteResolver {
  String? resolve(String? type, Map<String, dynamic> data) {
    return switch (type) {
      // existing cases ...
      _ => null,
    };
  }
  // helpers below ...
}
```

- [ ] **Step 1: Add 3 new test cases**

In `test/features/notification/utils/notification_route_resolver_test.dart`, add inside the existing `void main()`:

```dart
test('coach_assigned_to_session resolves to /coach/sessions/{id}', () {
  final route = NotificationRouteResolver().resolve(
    'coach_assigned_to_session',
    {'session_id': 42},
  );
  expect(route, '/coach/sessions/42');
});

test('session_schedule_change resolves to /coach/sessions/{id}', () {
  final route = NotificationRouteResolver().resolve(
    'session_schedule_change',
    {'session_id': 7},
  );
  expect(route, '/coach/sessions/7');
});

test('assessment_reminder resolves to /coach/sessions/{id}', () {
  final route = NotificationRouteResolver().resolve(
    'assessment_reminder',
    {'session_id': 99},
  );
  expect(route, '/coach/sessions/99');
});

test('coach_assigned_to_session returns null when session_id missing', () {
  final route = NotificationRouteResolver().resolve(
    'coach_assigned_to_session',
    {},
  );
  expect(route, null);
});
```

(Note: existing resolver is instance-based — `NotificationRouteResolver().resolve(...)`. Verify against the existing test pattern in the same file before committing the test code.)

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/notification/utils/notification_route_resolver_test.dart
```

Expected: 4 new tests fail (resolver returns null for the unknown types).

- [ ] **Step 3: Add 3 cases to the resolver**

Edit `lib/features/notification/utils/notification_route_resolver.dart`. Inside the switch, BEFORE the `_ => null` default, add:

```dart
'coach_assigned_to_session' ||
'session_schedule_change' ||
'assessment_reminder' =>
  _coachSessionRoute(data),
```

Add a helper at the bottom of the class (mirrors `_sessionRoute` style):

```dart
String? _coachSessionRoute(Map<String, dynamic> data) {
  final sessionId = data['session_id']?.toString();
  if (sessionId == null) return null;
  return AppRoutes.coachSessionDetail(sessionId);
}
```

If `AppRoutes.coachSessionDetail(...)` does NOT exist yet, return the literal string `'/coach/sessions/$sessionId'` and note as a follow-up to add the named route helper.

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/notification/utils/notification_route_resolver_test.dart
```

Expected: PASS (4 new tests + existing tests; existing `payment_rejected` failure unchanged).

- [ ] **Step 5: Commit**

```bash
git add lib/features/notification/utils/notification_route_resolver.dart test/features/notification/utils/notification_route_resolver_test.dart
git commit -m "Notifications: push-tap resolver routes 3 new coach types to session detail"
```

---

### Task 6.4: Notification tile — icon mapping for 3 new types

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\notification\presentation\widgets\notification_tile.dart`

- [ ] **Step 1: Read the existing tile**

Open the file and locate the icon mapping function (likely a switch on `NotificationType`). The function returns an `IconData` and possibly a color.

- [ ] **Step 2: Add 3 cases to icon mapping**

In the icon helper:

```dart
case NotificationType.coachAssignedToSession:
  return Icons.assignment_ind;
case NotificationType.sessionScheduleChange:
  return Icons.event_repeat;
case NotificationType.assessmentReminder:
  return Icons.rate_review_outlined;
```

If a color helper also exists (e.g. `_colorForType`), assign the warning palette (consistent with the dashboard's "needs attention" pattern):

```dart
case NotificationType.coachAssignedToSession:
case NotificationType.sessionScheduleChange:
case NotificationType.assessmentReminder:
  return AppColors.warningDark;  // or whichever existing token the helper uses
```

If the file does not have a separate color helper, the icon alone is enough for MVP.

- [ ] **Step 3: Run analyzer**

```bash
flutter analyze lib/features/notification/presentation/widgets/notification_tile.dart
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/notification/presentation/widgets/notification_tile.dart
git commit -m "Notifications: tile icons for coach assigned + schedule change + assessment reminder"
```

---

## Phase 7 — Deploy & Verify

### Task 7.1: Deploy BE branch to dev

- [ ] **Step 1: Push BE branch**

```bash
cd /c/laragon/www/hypercoach
git push -u origin feature/coach-notifications-role-filter
```

- [ ] **Step 2: Deploy to dev server**

```bash
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh feature/coach-notifications-role-filter"
```

Expected: `Deploy complete! Release: <timestamp>` at the end of the output.

- [ ] **Step 3: Run migrations on dev**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan migrate --force"
```

Expected: `Migrating: 2026_06_03_xxxxxx_add_target_role_to_notifications_table` then `Migrated:`.

- [ ] **Step 4: Run backfill on dev**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan notifications:backfill-target-role"
```

Expected: prints per-class row counts updated + `Done. N rows updated.`

- [ ] **Step 5: Smoke-test endpoint**

```bash
curl -s -H "Accept: application/json" -o /dev/null -w "HTTP %{http_code}\n" "https://devapp.hyperscore.cloud/api/v1/notifications"
```

Expected: HTTP 401 (auth gate working). No 500. The endpoint is reachable and the filter clause is live.

---

### Task 7.2: Flutter APK rebuild + smoke test

- [ ] **Step 1: Rebuild dev APK**

```bash
cd /d/projects/Flutter/hyperarena
flutter build apk --release --target=lib/main_dev.dart --dart-define=APP_ENV=dev --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana
```

Expected: `✓ Built build/app/outputs/flutter-apk/app-release.apk (~63 MB)`.

- [ ] **Step 2: Copy to releases with descriptive name**

```bash
cp build/app/outputs/flutter-apk/app-release.apk "releases/HyperArena-v0.3.3+6-dev-coach-notifications-$(date +%Y%m%d).apk"
ls -lh releases/HyperArena-v0.3.3+6-dev-coach-notifications-*.apk
```

- [ ] **Step 3: Manual smoke test on device**

Install the APK + log in as Haris (multi-role user: organizer + coach + player).

1. **Filter visibility check** — open notifications bell as Coach:
   - Inbox shows: coach + all role notifs ONLY. No player payment/booking, no organizer purchase items.
   - Bell unread count reflects only coach + all unread.
2. **Role-switch refresh** — switch to Organizer via profile:
   - Inbox refreshes, coach items disappear, organizer items appear.
3. **Dispatch trigger — Coach assigned** — login as admin user; create a new session with Haris (as coach) assigned:
   - Haris receives a push notification "Anda terdaftar sebagai coach" with session info.
   - Tap → navigates to `/coach/sessions/<id>`.
4. **Dispatch trigger — Schedule change** — as admin, edit the session's start_at:
   - Haris receives "Perubahan jadwal sesi" push.
5. **Dispatch trigger — Assessment reminder** — manually invoke the command on dev:
   ```bash
   ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan coach:assessment-reminders"
   ```
   - Haris receives "Penilaian belum diisi" push for any stale ungraded session.

If anything fails: re-check the failing scenario, report the symptom + which step.

- [ ] **Step 4: Commit APK file + final summary** (Flutter repo)

```bash
git add releases/
git status   # verify nothing else accidentally staged
git commit -m "Build: coach notifications + role filter dev APK"
```

---

## Final Verification

- [ ] BE: run full suite: `cd /c/laragon/www/hypercoach && /c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test` — expected: 1310+ tests pass (1298 baseline + ~12 new), 0 new failures.
- [ ] FE: run full suite: `cd /d/projects/Flutter/hyperarena && flutter test` — expected: ~80 pass, 1 pre-existing `notification_route_resolver` failure for `payment_rejected` unchanged.
- [ ] `flutter analyze` — clean on modified files.
- [ ] Manual smoke (per Task 7.2 Step 3) passes for all 5 scenarios.
- [ ] If any fail: do not merge to develop. Investigate and fix in follow-up commits on the same branch.
