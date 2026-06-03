# Coach Notifications + Role-Aware Filtering — Design Spec

**Date:** 2026-06-03
**Status:** Draft (awaiting user approval)
**Scope:** Cross-stack — Laravel BE (`C:\laragon\www\hypercoach`) + Flutter FE (`D:\projects\Flutter\hyperarena`)

---

## 1. Problem & Goal

### Current state

Multi-role users (e.g. Haris with `organizer` + `coach` + `player` roles) see all notifications in a single inbox regardless of active role. When Haris is in **Mode Coach**, the inbox surfaces player-payment notifications and organizer-purchase notifications — irrelevant noise that confuses the context.

Existing infrastructure:
- BE: ~20 `App\Notifications\*` classes (Laravel notifications, mostly member/organizer-focused). FCM channel via shared `HasFcmChannel` trait. `database` channel writes to `notifications` table (Spatie/Laravel standard schema).
- FE: `NotificationItem` model with 11-value `NotificationType` enum, `NotificationBell` widget on dashboards, `notifications_screen.dart`, `notification_route_resolver.dart` for tap navigation, FCM push handling.

Coach-specific notification types are absent. Coach has no in-app feedback when:
- Newly assigned to a session by an organizer
- Session schedule/venue changes for sessions they coach
- Sessions remain ungraded after completion

### Goal

Two cross-cutting changes that ship together as one feature:

1. **Role-aware notification filtering** — each notification is tagged with a `target_role`; the `/v1/notifications` endpoint only returns rows where `target_role IN ('all', user.active_role)`. Users in different modes see different inboxes.

2. **Three new coach notification types** that cover the most urgent coach workflows:
   - Coach assignment to a session
   - Schedule/venue change for an assigned session
   - Reminder when assessment is overdue

---

## 2. Decisions

| Decision | Value |
|---|---|
| **Filter scope** | In-app inbox only (bell badge + notifications screen). Push delivery unchanged. |
| **Role tagging mechanism** | BE schema change: add `target_role` column to `notifications` table. Filter at endpoint via `WHERE target_role IN ('all', user.active_role)`. |
| **MVP notification catalog** | 3 types: `CoachAssignedToSessionNotification`, `SessionScheduleChangedNotification`, `AssessmentReminderNotification`. |
| **Payout-per-session notification** | Deferred. Needs Wallet/Earnings screen design first. Not in this iteration. |
| **Push channel for new notifs** | All 3 push (FCM) + in-app. |
| **Cross-role push tap behavior** | No auto-role-switch. Tap navigates to destination; the active-role pill on dashboard remains source-of-truth for current mode. |
| **i18n** | Notification titles/bodies use Laravel lang strings via `__('notifications.<key>', $params, $locale)` — matches existing classes (e.g. `PayoutApproved`). Add new keys to `lang/id/notifications.php` (and other locales already present). Flutter inbox renders BE-provided strings as-is. |
| **Existing 20+ notification classes** | Backfill `target_role` via one-time migration command. Audience map in §3.2. New dispatches: each class sets `$targetRole` explicitly. |

---

## 3. Architecture

### High-level flow

```
Trigger (BE service mutation, e.g. session created/updated)
  ↓
Notification class dispatched → both channels:
  ├─ database channel  → notifications table (with target_role)
  └─ fcm channel       → device push (unchanged routing)
  ↓
FE inbox fetch GET /v1/notifications
  ↓
BE applies WHERE target_role IN ('all', active_role)
  ↓
FE renders filtered list. Bell count = unread filtered.
  ↓
User taps in-app → notification_route_resolver → screen
User taps push → same resolver via FCM handler → same screen
```

### Source-of-truth

- `notifications.target_role` is authoritative.
- `notifications.data` JSON ALSO includes `target_role` for FE convenience (no join needed).
- FE's `NotificationItem.targetRole` is informational — FE does NOT enforce filtering (BE has already done it).

---

## 4. Backend Changes

### 4.1 Migration

`database/migrations/2026_06_03_HHMMSS_add_target_role_to_notifications_table.php`:

```php
return new class extends Migration {
    public function up(): void {
        Schema::table('notifications', function (Blueprint $table) {
            $table->string('target_role', 16)->default('all')->after('data');
            $table->index('target_role');
        });

        Schema::table('coaching_sessions', function (Blueprint $table) {
            $table->timestamp('assessment_reminded_at')->nullable()->after('completion_state');
        });
    }

    public function down(): void {
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

### 4.2 Audience map (backfill + future dispatches)

| Notification class | target_role |
|---|---|
| `BookingCancelledByAdminNotification` | `player` |
| `BookingConfirmation` | `player` |
| `InvoiceIssued` | `organizer` |
| `InvoicePaid` | `organizer` |
| `MemberCancelledBookingNotification` | `organizer` |
| `NewPurchaseForOrganizer` | `organizer` |
| `NewStudentRegistered` | `organizer` |
| `PaymentProofUploaded` | `organizer` |
| `PaymentRejected` | `player` |
| `PayoutApproved` | `coach` |
| `ProgressUpdated` | `player` |
| `PurchaseConfirmedNotification` | `player` |
| `PurchasePending` | `player` |
| `SessionReminder` | `player` |
| `SkillEditedNotification` | `coach` |
| `SubscriptionStatusChanged` | `organizer` |
| `VenueCreatedNotification` | `organizer` |
| `VenueDeletionRequestedNotification` | `admin` |
| `VenueDeletionReviewedNotification` | `organizer` |

The map lives in `config/notifications.php` as the single source of truth:

```php
// config/notifications.php
return [
    'target_role_map' => [
        \App\Notifications\BookingCancelledByAdminNotification::class => 'player',
        \App\Notifications\BookingConfirmation::class => 'player',
        // ... (full map per table above)
        \App\Notifications\CoachAssignedToSessionNotification::class => 'coach',
        \App\Notifications\SessionScheduleChangedNotification::class => 'coach',
        \App\Notifications\AssessmentReminderNotification::class => 'coach',
    ],
];
```

Both the backfill command AND a model observer on `Illuminate\Notifications\DatabaseNotification::creating` read from this map. Net effect:

1. **Backfill command** (one-off, run after migration):
   ```php
   foreach (config('notifications.target_role_map') as $class => $role) {
       DB::table('notifications')
           ->where('type', $class)
           ->where('target_role', 'all') // only touch un-backfilled rows
           ->update(['target_role' => $role]);
   }
   ```

2. **Observer** registered in `AppServiceProvider::boot()`:
   ```php
   DatabaseNotification::creating(function ($n) {
       if ($n->target_role === 'all' || $n->target_role === null) {
           $map = config('notifications.target_role_map', []);
           $n->target_role = $map[$n->type] ?? 'all';
       }
   });
   ```

**Surgical benefit**: existing 20 notification classes are NOT touched. New types just add a row to the map. Observer guarantees future dispatches are correctly tagged.

### 4.3 New notification classes

All 3 classes follow the existing i18n pattern: titles/bodies via `__('notifications.<key>', $params, $notifiable->locale ?? 'id')`. New lang keys land in `lang/id/notifications.php` (plus matching locales already present in the project).

**`App\Notifications\CoachAssignedToSessionNotification`** (`target_role = 'coach'`)

- Constructor: `Session $session, Coach $coach`
- Channels: `['database', 'fcm']`
- `toArray()`: `{ type, target_role, session_id, session_name, starts_at, venue_name, route: '/coach/sessions/{id}' }`
- `toFcm()` uses keys `notifications.coach_assigned_to_session_title` ("Anda terdaftar sebagai coach") and `notifications.coach_assigned_to_session_body` ("{session_name} pada {starts_at}")

**`App\Notifications\SessionScheduleChangedNotification`** (`target_role = 'coach'`)

- Constructor: `Session $session, array $changedFields, Carbon $oldStartAt`
- Channels: `['database', 'fcm']`
- `toArray()`: `{ type, target_role, session_id, session_name, old_starts_at, new_starts_at, venue_name, changed_fields, route: '/coach/sessions/{id}' }`
- `toFcm()` uses keys `notifications.session_schedule_changed_title` and `notifications.session_schedule_changed_body`

**`App\Notifications\AssessmentReminderNotification`** (`target_role = 'coach'`)

- Constructor: `Session $session, Coach $coach, int $studentsUngraded`
- Channels: `['database', 'fcm']`
- `toArray()`: `{ type, target_role, session_id, session_name, students_ungraded_count, route: '/coach/sessions/{id}' }`
- `toFcm()` uses keys `notifications.assessment_reminder_title` and `notifications.assessment_reminder_body`

### 4.4 Trigger logic

**Coach assignment** — in the service / controller that calls `$session->coaches()->sync(...)`:

```php
$oldCoachIds = $session->coaches->pluck('id')->all();
$session->coaches()->sync($newCoachIds);
$addedCoachIds = array_diff($newCoachIds, $oldCoachIds);

foreach ($addedCoachIds as $coachId) {
    $coach = Coach::with('user')->find($coachId);
    if ($coach?->user) {
        $coach->user->notify(new CoachAssignedToSessionNotification($session->fresh(), $coach));
    }
}
```

Newly-added coaches notified. Removed coaches not notified (out of scope for MVP).

**Schedule change** — in `SessionService::update()` or equivalent:

```php
$dirty = [
    'start_at' => $session->isDirty('start_at') ? $session->getOriginal('start_at') : null,
    'duration_minutes' => $session->isDirty('duration_minutes') ? $session->getOriginal('duration_minutes') : null,
    'venue_id' => $session->isDirty('venue_id') ? $session->getOriginal('venue_id') : null,
];
$scheduleDirty = collect($dirty)->filter()->isNotEmpty();

$session->fill($payload)->save();

if ($scheduleDirty && $session->coaches->isNotEmpty()) {
    foreach ($session->coaches as $coach) {
        if ($coach->user) {
            $coach->user->notify(new SessionScheduleChangedNotification(
                $session->fresh(),
                array_filter($dirty),
                Carbon::parse($dirty['start_at'] ?? $session->start_at),
            ));
        }
    }
}
```

Non-schedule fields (`name`, `notes`, `capacity`) do NOT trigger this notification.

When schedule changes AND coach roster changes in the same save: newly-added coaches get `CoachAssignedToSession` (carrying the NEW schedule); existing coaches get `SessionScheduleChanged`. No double-notif.

**Assessment reminder** — scheduled command, hourly:

```php
// app/Console/Commands/SendAssessmentReminders.php
public function handle(): int {
    $cutoff = now()->subHours(4); // 4-hour grace
    $sessions = Session::query()
        ->where('completion_state', 'needs_grading')
        ->where('start_at', '<', $cutoff)
        ->whereNull('assessment_reminded_at')
        ->with('coaches.user')
        ->get();

    foreach ($sessions as $session) {
        $studentsUngraded = $session->sessionStudents()
            ->whereNull('cancelled_at')
            ->whereDoesntHave('sessionProgress', fn ($q) => $q->where('session_id', $session->id))
            ->count();
        if ($studentsUngraded === 0) continue;
        foreach ($session->coaches as $coach) {
            if ($coach->user) {
                $coach->user->notify(new AssessmentReminderNotification($session, $coach, $studentsUngraded));
            }
        }
        $session->update(['assessment_reminded_at' => now()]);
    }
    return 0;
}
```

Registered in `routes/console.php`:

```php
Schedule::command('coach:assessment-reminders')->hourly()->withoutOverlapping()->onOneServer();
```

Single-fire per session. If admin resets a session to `needs_grading` after `complete`, no re-reminder (acceptable for MVP).

### 4.5 Endpoint filter

In the controller that serves `/v1/notifications` (likely `Member\NotificationController@index` or shared):

```php
$activeRole = $request->user()->active_role ?? $request->user()->role;
$query->whereIn('target_role', ['all', $activeRole]);
```

Apply BEFORE pagination so `total` and cursor reflect filtered set. Index on `target_role` (per migration) keeps the WHERE cheap.

Unread count endpoint applies the same filter.

---

## 5. Frontend Changes

### 5.1 Model

`lib/features/notification/data/models/notification_item.dart`:

```dart
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
    @JsonKey(name: 'target_role') @Default('all') String targetRole,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
```

`targetRole` is a String (not enum). Defensive default `'all'` so old clients survive missing field.

### 5.2 `NotificationType` enum — add 3 values

```dart
enum NotificationType {
  // existing
  paymentReminder, sessionReminder, reviewRequest, assessmentReceived,
  bookingConfirmed, sessionFull, sessionCancelled, paymentConfirmed,
  paymentRejected, badge, general,
  // new
  coachAssignedToSession,
  sessionScheduleChange,
  assessmentReminder,
}
```

JSON-from-BE: the BE sends snake_case strings (`coach_assigned_to_session`, etc.). The enum's deserialization config maps each. Unknown types fall back to `general` (defensive).

### 5.3 Route resolver

`lib/features/notification/utils/notification_route_resolver.dart` — add cases:

```dart
case NotificationType.coachAssignedToSession:
case NotificationType.sessionScheduleChange:
case NotificationType.assessmentReminder:
  final sessionId = data['session_id'];
  if (sessionId == null) return null;
  return AppRoutes.coachSessionDetail(sessionId.toString());
```

All 3 share the same destination: `/coach/sessions/{id}`. The session detail screen handles whatever the coach needs (mark attendance, grade, view updated schedule).

### 5.4 Notification tile rendering

`lib/features/notification/presentation/widgets/notification_tile.dart` — extend the icon mapping helper:

| Type | Icon | Accent |
|---|---|---|
| `coachAssignedToSession` | `Icons.assignment_ind` | warning palette (informational) |
| `sessionScheduleChange` | `Icons.event_repeat` | warning palette (needs attention) |
| `assessmentReminder` | `Icons.rate_review_outlined` | warning palette (needs action) |

Body strings come from BE — no FE templating needed.

### 5.5 Provider + screen — no changes

`notification_providers.dart` continues to call `getNotifications()`. Result is now BE-filtered. `NotificationBell` and `NotificationsScreen` work as-is.

The existing `_invalidateAllFeatureProviders()` in `auth_provider.dart` already invalidates `notificationListProvider` and `unreadCountProvider` on role switch — inbox refreshes automatically with the new role's filtered set. No new wiring.

---

## 6. Non-Goals

1. Payout-per-session or batch-payout notifications. Deferred pending Wallet/Earnings screen design.
2. Push tap auto-role-switch. Cross-role push tap navigates to destination; user remains in current mode.
3. Per-category mute/unmute settings.
4. Notification grouping / digest (e.g. bulk-assigned 5 sessions → 5 push notifs, not 1 digest).
5. Email/SMS channels for the 3 new types.
6. Notification recall / soft-delete on session deletion. Stale notifs are tolerated.
7. Removed-coach notification when admin removes coach from session.
8. Per-class `$targetRole` property on existing 20 notification classes. The config map + observer (§4.2) handles tagging without touching those classes.

---

## 7. Out of Scope (potential follow-ups)

- Wallet/Earnings screen + per-session payout notifications.
- Notification preferences UI (toggle per category).
- Role-aware push channel routing (suppress push when user inactive in target role).
- Digest notifications for high-volume bulk events.
- Auto role-switch on cross-context push tap.

---

## 8. File Plan

### Backend — `C:\laragon\www\hypercoach`

**Created:**
```
database/migrations/2026_06_03_HHMMSS_add_target_role_to_notifications_table.php
app/Console/Commands/BackfillNotificationTargetRole.php
app/Console/Commands/SendAssessmentReminders.php
app/Notifications/CoachAssignedToSessionNotification.php
app/Notifications/SessionScheduleChangedNotification.php
app/Notifications/AssessmentReminderNotification.php
tests/Feature/Notifications/CoachAssignedToSessionNotificationTest.php
tests/Feature/Notifications/SessionScheduleChangedNotificationTest.php
tests/Feature/Notifications/AssessmentReminderCommandTest.php
tests/Feature/Notifications/NotificationIndexFilterTest.php
tests/Feature/Notifications/BackfillNotificationTargetRoleTest.php
```

**Modified:**
```
config/notifications.php                            (NEW config file — central target_role map)
app/Providers/AppServiceProvider.php                (register DatabaseNotification creating observer)
routes/console.php                                  (schedule the reminder command)
app/Http/Controllers/<exact path TBD via grep>      (apply target_role filter to /v1/notifications + unread-count)
app/Services/SessionService.php (or equivalent)     (dispatch assignment + schedule-change notifs)
lang/id/notifications.php                           (add 6 new keys: 3 titles + 3 bodies for new notifs)
lang/<other locales>/notifications.php              (if present, add same keys)
```

**Implementation note**: before coding, run `grep -rln "Route::.*notifications" routes/` to find the actual controller serving `/v1/notifications` (likely `Member\NotificationController@index`, but verify). Same for unread-count endpoint. The 20 existing notification classes are NOT modified.

### Frontend — `D:\projects\Flutter\hyperarena`

**Modified:**
```
lib/features/notification/data/models/notification_item.dart    (add targetRole field, add 3 enum values)
lib/features/notification/utils/notification_route_resolver.dart (handle 3 new types)
lib/features/notification/presentation/widgets/notification_tile.dart (icon mapping for new types)
```

**Created:**
```
test/features/notification/utils/notification_route_resolver_test.dart (add 3 new test cases)
test/features/notification/data/models/notification_item_test.dart (target_role parsing + defensive default)
```

No new FE screens, no new providers.

---

## 9. Testing Strategy

### BE feature tests

| Test | Asserts |
|---|---|
| `AddTargetRoleToNotificationsMigrationTest` | Migration up/down; default `'all'`; index present |
| `BackfillNotificationTargetRoleTest` | Existing rows updated per audience map; idempotent (re-run does not overwrite non-`all` rows) |
| `NotificationIndexFilterTest` | Multi-role user gets correct filtered list per `active_role` switch |
| `CoachAssignedToSessionNotificationTest` | Fires on coach attach (not on unchanged sync); payload + target_role correct |
| `SessionScheduleChangedNotificationTest` | Fires on start_at/venue/duration change; skips name/notes-only edits; fires to all assigned coaches |
| `AssessmentReminderCommandTest` | Stale session triggers dispatch; sets `assessment_reminded_at`; second run skips; 0-ungraded sessions skipped |

### FE widget/unit tests

- `NotificationItem.fromJson` parses `target_role`; defensive `'all'` default for missing/unknown.
- `NotificationType` deserialization for `coach_assigned_to_session`, `session_schedule_change`, `assessment_reminder`. Unknown type → `general`.
- `notification_route_resolver` returns `/coach/sessions/{id}` for the 3 new types when `session_id` is present; returns `null` when absent.

### Manual smoke (post-deploy)

1. Login as Haris (multi-role user). Switch to Coach mode. Inbox shows coach + all notifs; no organizer/player items.
2. Switch to Organizer mode. Inbox refreshes; coach items disappear, organizer items appear.
3. As organizer (Haris in organizer mode), edit a session: change start_at + add a new coach. Verify (a) newly-added coach gets `CoachAssignedToSession` push, (b) all existing coaches get `SessionScheduleChanged` push.
4. Run `php artisan coach:assessment-reminders` manually after creating a stale `needs_grading` session 4+ hours old. Verify the assigned coach gets the reminder push.

---

## 10. Migration Order (deployment)

1. **BE**: deploy migration (adds `target_role` column + `assessment_reminded_at` column). Existing rows default to `'all'` — visible to everyone (no regression).
2. **BE**: run `php artisan notifications:backfill-target-role` once. Existing rows now correctly tagged.
3. **BE**: deploy code changes — config map + observer + 3 new notification classes + scheduled job + endpoint filter clause active. No existing notification classes modified.
4. **FE**: deploy APK with model + enum + resolver updates. (FE survived between step 2 and 4 because BE's API kept returning `target_role` field unused by FE; FE's defensive default `'all'` accepts everything.)
5. **Verify**: smoke test (§9) on devapp.

Rollback at any step is independent. Migration `down()` clean. Endpoint filter is a one-line revert.
