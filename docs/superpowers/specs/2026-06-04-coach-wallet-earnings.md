# Coach Wallet / Earnings + Withdrawal Request — Design Spec

**Date:** 2026-06-04
**Status:** Draft v2 (post-review)
**Scope:** Cross-stack — Laravel BE (`C:\laragon\www\hypercoach`) + Flutter FE (`D:\projects\Flutter\hyperarena`)

**Mobile-first constraint with per-change classification:** BE improvements may be driven from mobile and Vue admin catches up later. Every BE change in this spec is classified as either **Additive** (safe — Vue ignores) or **Shape-changing** (requires Vue coordination + owner + ETA noted in §11). Default to additive unless a business reason demands otherwise.

---

## 0. Pre-flight Code Verification

These were investigated against the BE codebase before drafting v2 and are documented so subsequent edits don't re-litigate them.

| Question | Finding | Source |
|---|---|---|
| Laravel version | **12.0** | `composer.json: "laravel/framework": "^12.0"` |
| `attendances.status` enum | **`present | absent | late`** | `2026_02_12_150002_create_attendances_table.php` (column doc comment) |
| `Payout.amount` unit | Integer **cents** (no `_cents` suffix in DB) | `PayoutApproved.php` divides by 100 for display; matches stored value |
| `period` format | **`"YYYY-MM"`** (e.g. `"2026-06"`) | `payouts` migration; existing endpoints use same |
| `tenant.payout_sla_days` exposure | Column exists, default 14. **Not yet exposed in auth user payload** (`AuthUserPayload`). | `Admin\PayoutController` reads `$tenant->payout_sla_days` server-side only |
| Mark-complete trigger | Coach can self-complete via `POST /v1/coach/sessions/{id}/complete` (`Coach\SessionController@complete:108-128`); admin via `Admin\SessionController@completeSession:526` | grep + read |
| **Attendance-complete guard at mark-complete** | ❌ **NOT enforced anywhere.** Both endpoints transition status to `completed` after only checking the status precondition. The `GeneratePayoutOnSessionComplete` listener fires unconditionally. This is a **new requirement** added by this spec — see §4.7. | grep across `app/Http`, `app/Services`, `app/Listeners` |
| Per-session enrollment representation | `session_students` pivot. "Active enrollment" = `cancelled_at IS NULL`. | `Session::sessionStudents()` HasMany; `Session::students()` belongsToMany via same pivot |
| `completion_state` on `coaching_sessions` | **Accessor only**, computed in `Session::getCompletionStateAttribute` (lines 291-319). Returns `not_yet | needs_attendance | needs_grading | complete`. **Cannot be queried in raw SQL.** Affects how the attendance-complete guard is written (must use underlying conditions, not the accessor). | `app/Models/Session.php` |

These are **derived from code, not skill metadata.** The skill (v1.0.0) flagged "Session scheduling" and "Skill assessments" as `🔲 To build` — that is **stale**. Both are live in the Vue web admin today.

---

## 1. Problem & Goal

### Current state

Coach has no visibility into earnings inside the Flutter app. The dashboard's `Earnings` card displays `Rp 0` because `CoachPerformance.earningsThisMonthCents` is hardcoded to 0 — `CoachSession` has no payout field on the list endpoint, and `CoachDashboardPerformance` widget therefore cannot surface real numbers.

Backend has substantial infrastructure already:
- `Payout` model (`app/Models/Payout.php`) with `coach_id`, `session_id`, `amount`, `period`, `status`
- `payouts` table with statuses `pending | approved | paid`, SLA tracking via `sla_breach_notified_at`
- `Coach\PayoutController@index` exposes `GET /v1/coach/payouts` with `period` + `status` filters and pagination
- `App\Listeners\GeneratePayoutOnSessionComplete` already auto-creates a Payout row when a session is marked complete
- `Admin\PayoutController` + `PayoutService` handle approve + mark-paid flows
- `PayoutApproved` notification class exists for batch period notifications
- `coach_rates` table with `effective_from` dating, `payout_sla_days` on tenant

Backend is ~80% ready. Flutter has nothing — no wallet feature module, no providers, no screen.

There is no coach-initiated withdrawal request mechanism in the current flow. Payouts are only acted on by admins via the web UI: admin approves a payout (`PayoutService::approvePayout`), then marks it paid (`PayoutService::markPaid`). Coaches cannot signal "I want to cash out now" from inside the app.

### Goal

Ship three coach-facing screens that let a coach:

1. **Wallet (`/coach/wallet`)** — see total earnings per period, status breakdown (Belum Dicairkan / Diproses / Sudah Dicairkan), per-session feed, and request a batch withdrawal via one "Cairkan Rp X" button.
2. **Withdrawal History (`/coach/wallet/requests`)** — list past `PayoutRequest` records (filterable by period/status). Canonical place where a coach discovers a rejected request.
3. **Withdrawal Detail (`/coach/wallet/requests/{id}`)** — single request with linked payouts and the admin's `rejection_note` if rejected.

Plus three new push notifications during the lifecycle: new session payout earned, withdrawal request approved, payout disbursed.

Plus a **new attendance-complete gate** on the mark-complete endpoints (`Coach\SessionController@complete` and `Admin\SessionController@completeSession`) so that **a session can only be marked complete — and therefore generate a Payout — when every active (`cancelled_at IS NULL`) `session_student` has a row in `attendances` with status set**. "Complete" here means rolls are filled (`present | absent | late`), NOT that everyone attended. No-show is fine, as long as it's recorded. Skill assessments are **NOT** a precondition — assessment is a coach-side reflection workflow, not a payout gate.

Admin retains the existing direct-approve flow on payouts — they can approve and mark paid without a coach request. The new attendance gate, however, applies to BOTH admin and coach mark-complete actions.

---

## 2. Decisions

| Decision | Value |
|---|---|
| **Scope** | Coach role only. Not for player/admin/organizer. |
| **Primary frame** | Period total at the top (hero), status chips below, per-session feed at the bottom. |
| **Period selector** | Default current month, chevron prev/next + tap-to-open month picker for arbitrary navigation. |
| **Withdrawal UX** | Batch "Cairkan semua" — one tap requests all pending payouts in the selected period. |
| **BE state machine** | New entity `PayoutRequest` with its own lifecycle (`pending → approved → rejected`). `Payout.status` remains `pending | approved | paid` (Vue-compatible). |
| **Payout↔Request link** | Nullable FK `payouts.request_id`. Additive — Vue ignores. |
| **Admin direct flow** | Preserved. Admin can still approve and mark-paid without a request. Coach-initiated path is parallel. |
| **Notifications** | 3 new types, all `target_role='coach'`: earned, request-approved, disbursed. Rejection notification deferred. |
| **Dashboard Earnings card** | Switches data source to call the new wallet summary endpoint. Tap → push `/coach/wallet`. |
| **Wallet entry** | Profile menu OR notification deep-link. NOT a new bottom-nav tab. Preserves the 4-tab shell shipped earlier. |
| **i18n** | Indonesian only on mobile (consistent with project memory). BE lang keys via `__('notifications.<key>')`. |
| **Preview gate** | After FE renders end-to-end with seeded data, user reviews UI on a built APK before final commits. |
| **Design system** | All tokens from existing `AppColors`, `AppTypography`, `AppDimensions`, `AppSurfaces`, `AppShadows`. No new tokens unless absolutely necessary. |
| **Implementation skill** | `superpowers:frontend-design` invoked during implementation pass for the screen + widgets. |

---

## 3. Architecture

### Entities & flow

```
Existing (preserved)
  Payout (per-session)
    status: pending | approved | paid
    auto-generated by GeneratePayoutOnSessionComplete on session complete
    admin approves via Admin\PayoutController + PayoutService

NEW (additive)
  PayoutRequest (coach-initiated withdrawal batch)
    status: pending | approved | rejected | cancelled
    has many Payouts (via nullable FK payout.request_id)

Coach withdrawal path (NEW):
  coach taps "Cairkan Rp X" for period P
    ↓
  POST /v1/coach/payout-requests {period: P}
    ↓
  PayoutRequestService::createForCoach
    ├── selects all Payout where coach_id, period=P, status='pending', request_id is null
    ├── creates PayoutRequest(status='pending', total = sum of selected)
    └── sets payout.request_id on each selected payout

Admin acts on the request (NEW):
  POST /v1/admin/payout-requests/{id}/approve
    ↓
  PayoutRequestService::approve (inside transaction)
    ├── PayoutRequest.status = 'approved'
    ├── for each linked Payout: PayoutService::approvePayout (existing logic, transitions to 'approved')
    └── dispatch PayoutRequestApprovedNotification to coach

  POST /v1/admin/payout-requests/{id}/reject {note}
    ↓
  PayoutRequestService::reject
    ├── PayoutRequest.status = 'rejected'
    ├── linked Payouts stay 'pending' (no transition)
    ├── rejection_note saved
    └── (no notification in MVP)

Disbursement (existing flow, unchanged):
  Admin marks each Payout paid via existing per-payout endpoint
    ↓
  PayoutService::markPaid (existing, append dispatch)
    └── dispatch PayoutDisbursedNotification to coach
```

### Invariants

- A coach can have at most ONE active (`pending` or `approved`) `PayoutRequest` per period.
- A `Payout` belongs to at most ONE `PayoutRequest` (`request_id` is unique-per-payout because each payout is selected by one request only).
- Linked payouts in a request all share the same `period` as the request itself.
- A rejected request frees its linked payouts to be requested again later.

### Vue admin backward compatibility

- `Payout` table + status enum + `Admin\PayoutController` response shapes: **unchanged**.
- `payout.request_id` is a NEW additive field on responses — Vue ignores unknown JSON keys.
- `PayoutRequest` is a NEW resource — Vue admin extends a separate view to consume the new endpoints (out of scope for this spec; web team owns).
- Existing admin direct-approve endpoint still works the same way. If admin approves a payout that happens to be linked to a request, the request stays `pending` (slightly weird audit state — see §6 Non-Goal 10).

---

## 4. Backend Changes

### 4.1 Migration

`database/migrations/2026_06_04_xxxxxx_create_payout_requests_table.php`:

```php
return new class extends Migration {
    public function up(): void {
        Schema::create('payout_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tenant_id')->constrained()->cascadeOnDelete();
            $table->foreignId('coach_id')->constrained()->cascadeOnDelete();
            $table->string('period', 7); // "2026-06"
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

    public function down(): void {
        Schema::table('payouts', function (Blueprint $table) {
            $table->dropForeign(['request_id']);
            $table->dropColumn('request_id');
        });
        Schema::dropIfExists('payout_requests');
    }
};
```

### 4.2 PayoutRequest model

```php
class PayoutRequest extends Model
{
    use HasFactory, LogsActivity, BelongsToTenant;

    protected $fillable = [
        'tenant_id', 'coach_id', 'period',
        'total_amount_cents', 'status',
        'requested_at', 'processed_at',
        'processed_by_user_id', 'rejection_note',
    ];

    protected function casts(): array {
        return [
            'requested_at' => 'datetime',
            'processed_at' => 'datetime',
            'total_amount_cents' => 'integer',
        ];
    }

    public function coach(): BelongsTo { return $this->belongsTo(Coach::class); }
    public function payouts(): HasMany { return $this->hasMany(Payout::class, 'request_id'); }
    public function processedBy(): BelongsTo { return $this->belongsTo(User::class, 'processed_by_user_id'); }

    public function getActivitylogOptions(): LogOptions {
        return LogOptions::defaults()->logOnly(['status', 'processed_by_user_id', 'processed_at']);
    }
}
```

### 4.3 PayoutRequestService

```php
class PayoutRequestService
{
    public function __construct(private PayoutService $payoutService) {}

    public function createForCoach(Coach $coach, string $period): PayoutRequest
    {
        return DB::transaction(function () use ($coach, $period) {
            // Reject if active request exists
            $existing = PayoutRequest::where('coach_id', $coach->id)
                ->where('period', $period)
                ->whereIn('status', ['pending', 'approved'])
                ->lockForUpdate()
                ->first();
            if ($existing) {
                throw new \DomainException('Active request already exists for this period.');
            }

            $payouts = Payout::where('coach_id', $coach->id)
                ->where('period', $period)
                ->where('status', 'pending')
                ->whereNull('request_id')
                ->lockForUpdate()
                ->get();
            if ($payouts->isEmpty()) {
                throw new \DomainException('No pending payouts to request.');
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
                throw new \DomainException("Request is {$request->status}, cannot approve.");
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
                throw new \DomainException("Request is {$request->status}, cannot reject.");
            }

            $request->update([
                'status' => 'rejected',
                'processed_at' => now(),
                'processed_by_user_id' => $admin->id,
                'rejection_note' => $note,
            ]);
            // Linked payouts stay 'pending' — coach can request again.
            // Their request_id is intentionally retained as audit trail.

            return $request->fresh(['payouts']);
        });
    }
}
```

### 4.4 New endpoints

**Coach** (auth: `auth:sanctum` + `resolve.tenant` + new permission `request-own-payouts`):

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/v1/coach/payout-requests` | Create batch request `{period: "2026-06"}` |
| `GET` | `/v1/coach/payout-requests` | List own requests, paginated; filters `period`, `status` |
| `GET` | `/v1/coach/payout-requests/{id}` | Detail with linked payouts (own coach_id only) |
| `GET` | `/v1/coach/payouts/summary?period=YYYY-MM` | Aggregate for hero + status chips + active_request_id |

**Admin** (existing `auth:sanctum` + `permission:manage-payouts`):

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/v1/admin/payout-requests` | List all tenant requests; filters `period`, `status`, `coach_id` |
| `GET` | `/v1/admin/payout-requests/{id}` | Detail with linked payouts |
| `POST` | `/v1/admin/payout-requests/{id}/approve` | Triggers PayoutRequestService::approve |
| `POST` | `/v1/admin/payout-requests/{id}/reject` | Body `{note?: string}`. Triggers reject. |

**Summary endpoint response shape** (`GET /v1/coach/payouts/summary?period=YYYY-MM`):

```json
{
  "period": "2026-06",
  "total_earned_cents": 240000000,
  "session_count": 12,
  "student_count": 8,
  "pending_cents": 60000000,
  "requested_cents": 0,
  "approved_cents": 0,
  "paid_cents": 180000000,
  "active_request_id": null
}
```

- `pending_cents` = sum of payouts where status='pending' AND request_id IS NULL
- `requested_cents` = sum of payouts where status='pending' AND request_id IS NOT NULL (locked in active request)
- `approved_cents` = sum of payouts where status='approved' (awaiting payout)
- `paid_cents` = sum of payouts where status='paid'
- `active_request_id` = ID of the coach's pending-or-approved request for this period, else null

### 4.5 Permissions

Add 1 Spatie permission: `request-own-payouts`. Assigned to `coach` role in `RoleAndPermissionSeeder`. Existing `view-own-payouts` continues to gate `GET /v1/coach/payouts`.

### 4.6 Notifications

Three new classes, all `target_role='coach'` via `config/notifications.php` map (per the role-aware system shipped earlier):

#### `App\Notifications\PayoutEarnedNotification`
- Constructor: `Payout $payout, Coach $coach`
- Channels: `['database', 'fcm']`
- Dispatched: appended to `App\Listeners\GeneratePayoutOnSessionComplete` AFTER `Payout::create(...)`.
- Payload: `{ type, target_role, payout_id, session_id, session_name, amount_cents, route: '/coach/wallet' }`
- Lang keys: `notifications.payout_earned_title`, `notifications.payout_earned_body`

#### `App\Notifications\PayoutRequestApprovedNotification`
- Constructor: `PayoutRequest $request, Coach $coach`
- Channels: `['database', 'fcm']`
- Dispatched: inside `PayoutRequestService::approve` after transition.
- Payload: `{ type, target_role, request_id, period, total_amount_cents, route: '/coach/wallet' }`
- Lang keys: `notifications.payout_request_approved_title`, `notifications.payout_request_approved_body`

#### `App\Notifications\PayoutDisbursedNotification`
- Constructor: `Payout $payout, Coach $coach`
- Channels: `['database', 'fcm']`
- Dispatched: appended to `PayoutService::markPaid` after transition.
- Payload: `{ type, target_role, payout_id, session_name, amount_cents, route: '/coach/wallet' }`
- Lang keys: `notifications.payout_disbursed_title`, `notifications.payout_disbursed_body`

All 3 classes added to `config/notifications.php` `target_role_map` as `'coach'`. The observer + endpoint filter shipped earlier handles role-aware visibility automatically.

### 4.7 Attendance-complete validator on mark-complete endpoints (new requirement)

Per §1 and Pre-flight §0: **a session cannot be marked complete unless every active `session_student` has an `attendances` row with status set**. No-show is fine (`absent`) — the gate is "filled", not "all present". Skill assessments are NOT a precondition.

**Why here, not in the listener**: enforcing in the listener would generate Payouts then need to un-do them. Better fail fast at the controller (returns 422 before status flips and before listener fires).

**Implementation**: a shared validator method (extracted into `App\Services\SessionService` or `App\Support\AttendanceCompletenessChecker` — pick whichever matches existing conventions for "shared session-level rules") used by BOTH:
- `Coach\SessionController@complete` — before `$session->update(['status' => 'completed'])`
- `Admin\SessionController@completeSession` — same insertion point

**SQL form** (since `Session::completion_state` is an accessor and can't be queried):

```php
public function assertAttendanceComplete(Session $session): void
{
    $bookedCount = $session->sessionStudents()
        ->whereNull('cancelled_at')
        ->count();

    $attendanceCount = $session->attendances()
        ->count();
    // attendances.unique(session_id, student_profile_id) guarantees no double-counting

    if ($attendanceCount < $bookedCount) {
        throw new IncompleteAttendanceException(
            'Sesi tidak bisa diselesaikan: ' . ($bookedCount - $attendanceCount) . ' murid belum di-mark kehadirannya.'
        );
    }
}
```

The exception is mapped to a `422 Unprocessable Entity` response by Laravel's exception handler, with payload:

```json
{
  "message": "Sesi tidak bisa diselesaikan: 3 murid belum di-mark kehadirannya.",
  "errors": {
    "attendance": ["Sesi tidak bisa diselesaikan: 3 murid belum di-mark kehadirannya."]
  }
}
```

The Flutter FE doesn't need to call this directly — coach uses the Schedule tab's session detail flow to mark attendance, then attempts complete. If the complete fails, the existing session-detail screen surfaces the message (no Wallet involvement; Wallet is read-mostly).

**Vue admin coordination required** — see §11 Change Classification table. This is the one Shape-changing BE change in this spec.

**Edge cases:**
- Zero booked students (empty session) — `bookedCount = 0`, gate is trivially satisfied. Session can be marked complete and produces a Payout for the coach with no students. Acceptable; matches existing behavior.
- Student booked + immediately cancelled (`cancelled_at` set) — excluded from `bookedCount`. Correct.
- Student attendance row exists but status field is empty string — caught by the count comparison (we require a row, not a value). Acceptable for MVP; tighten later if needed.

---

## 5. Frontend Changes

### 5.1 New feature module

```
lib/features/wallet/
├── data/
│   ├── api_wallet_repository.dart
│   └── models/
│       ├── coach_payout.dart                (Freezed)
│       ├── coach_payout_summary.dart        (Freezed)
│       └── payout_request.dart              (Freezed)
├── providers/
│   ├── wallet_period_provider.dart          (StateProvider<String>)
│   ├── wallet_summary_provider.dart         (FutureProvider.family<String, CoachPayoutSummary>)
│   ├── wallet_payouts_provider.dart         (FutureProvider.family<String, List<CoachPayout>>)
│   └── payout_request_action_provider.dart  (NotifierProvider<...>)
└── presentation/
    ├── screens/
    │   └── coach_wallet_screen.dart
    └── widgets/
        ├── wallet_period_selector.dart
        ├── wallet_hero.dart
        ├── wallet_status_chips.dart
        ├── wallet_withdraw_cta.dart
        └── wallet_session_row.dart
```

### 5.2 Routing

Add `/coach/wallet` to `AppRoutes` + `app_router.dart`. Entry points:
- Coach profile screen — new "Wallet" / "Penghasilan" menu item
- Notification taps (the 3 new types resolve to this route)
- Coach dashboard Earnings card tap (new — currently no tap behaviour)

NOT added to the bottom nav tab bar. The 4-tab shell (Dashboard/Schedule/Students/Profile) stays as shipped.

### 5.3 Screen layout

```
┌─────────────────────────────────────┐
│ ← Wallet                         🔔 │
├─────────────────────────────────────┤
│ Periode                             │
│  ◀ Juni 2026 ▶                      │
├─────────────────────────────────────┤
│   Penghasilan Juni                  │
│   Rp 2.400.000                      │
│   12 sesi · 8 murid                 │
├─────────────────────────────────────┤
│ [● Belum Dicairkan  Rp 600.000]     │
│ [● Diproses         Rp 0]           │
│ [● Sudah Dicairkan  Rp 1.800.000]   │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 💰 Cairkan Rp 600.000           │ │
│ │    5 sesi pending               │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Riwayat Sesi                        │
│  7 Jun  Joko          Rp 150.000    │
│  Sesi Tennis           [Pending]    │
│  5 Jun  Anna          Rp 150.000    │
│  Sesi Tennis           [Sudah]      │
│  ...                                │
└─────────────────────────────────────┘
```

### 5.4 Status chip mapping (3 chips, summary covers 4 BE buckets)

The BE summary returns 4 amount buckets. From the coach's POV, "requested" and "approved" both mean "out of my hands, awaiting disbursement" — we merge them in the UI. The 3 chips MUST satisfy the invariant:

```
total_earned_cents == belum_dicairkan + diproses + sudah_dicairkan
```

| Chip label | Sum of BE fields | Coach mental model |
|---|---|---|
| **Belum Dicairkan** | `pending_cents` (= status=`pending` AND `request_id IS NULL`) | Bisa saya cairkan sekarang |
| **Diproses** | `requested_cents` + `approved_cents` | Sudah saya ajukan / admin sudah setujui — tunggu transfer |
| **Sudah Dicairkan** | `paid_cents` | Sudah masuk rekening |

The endpoint **still returns all 4 fields** (additive, useful for Vue admin). The merge happens FE-side.

### 5.4.1 Per-row status badge colors (existing tokens)

| Per-row status | Background | Text |
|---|---|---|
| Belum Dicairkan (status='pending' AND request_id IS NULL) | `AppColors.warningLight` | `AppColors.warningDark` |
| Diproses (status='pending' with request_id, OR status='approved') | `AppColors.neutral200` | `AppColors.textSecondary` |
| Sudah Dicairkan (status='paid') | success palette token (verify name at implementation time — likely `successLight` / `successDark`; if absent, add 2 tokens) | success palette text |

The "Disetujui" sub-state is folded into Diproses for the per-row badge — same color treatment. Coach doesn't need to distinguish between "I requested, admin not yet approved" vs "admin approved, transfer pending".

### 5.5 Withdrawal CTA confirmation flow

Tap "Cairkan Rp 600.000" → modal bottom sheet:

```
┌─────────────────────────────────────┐
│ Cairkan Penghasilan                 │
│                                     │
│ Periode    : Juni 2026              │
│ Total      : Rp 600.000             │
│ Dari       : 5 sesi pending         │
│                                     │
│ Setelah dikirim, admin akan         │
│ memverifikasi dan transfer ke       │
│ rekening Anda dalam {SLA} hari.     │
│                                     │
│ [Batal]    [Konfirmasi Pencairan]   │
└─────────────────────────────────────┘
```

`{SLA}` interpolated from `tenant.payout_sla_days` (already exposed on auth user payload as `tenant.payout_sla_days` — if not yet exposed, add to the auth user serializer; this is the smaller-of-two-evils additive change).

On confirm → `payoutRequestActionProvider.requestWithdrawal(period)` → POST → on success invalidate `walletSummaryProvider` and `walletPayoutsProvider` for the period → snackbar "Permintaan pencairan berhasil dikirim" → CTA hides (because `active_request_id` is now non-null).

The bottom sheet wraps content in `SafeArea(top: false)` + `viewInsets.bottom` padding (same pattern as `EnrollmentDialog` fix shipped earlier) so action buttons clear the gesture bar.

### 5.6 Dashboard Earnings card hook (small follow-up)

`CoachDashboardPerformance` currently reads from `coachDashboardSummaryProvider.performance.value.earningsThisMonthCents`, which is hardcoded to 0 in `ApiCoachDashboardRepository.getPerformance` because `CoachSession` model has no payout field.

Switch the Earnings card data source to call `walletSummaryProvider.family(currentPeriod)` directly. The `currentPeriod` is computed inline in the widget as `"${now.year}-${now.month.padLeft(2,'0')}"`. Sub-text becomes `"{sessionCount} sesi bulan ini"` from the same summary response.

Tap on the Earnings card → `context.push('/coach/wallet')`.

This is a one-widget plumbing change. The dashboard layout itself is unchanged.

### 5.7 Notification integration

`NotificationType` enum gains 3 values:
```dart
payoutEarned,
payoutRequestApproved,
payoutDisbursed,
```

`api_notification_repository.dart` `_mapType` / `_titleFor` / `_bodyFor` / `_routeFor` gain 3 cases each. Route helper:

```dart
String? _walletRoute(Map<String, dynamic> data) {
  // All 3 new payout notifications deep-link to /coach/wallet.
  // Period or session_id is informational only; screen reads the current period.
  return '/coach/wallet';
}
```

`notification_route_resolver.dart` (FCM push tap path) gains the same 3 cases routing to `/coach/wallet`.

`notification_tile.dart` icon mapping:
| Type | Icon | Color |
|---|---|---|
| `payoutEarned` | `Icons.savings_outlined` | `AppColors.success` (or closest green token) |
| `payoutRequestApproved` | `Icons.check_circle_outline` | `AppColors.info` |
| `payoutDisbursed` | `Icons.account_balance` | `AppColors.success` |

### 5.8 Loading / empty / error states (consistent with rest of app)

| Section | Loading | Empty | Error |
|---|---|---|---|
| Hero | shimmer skeleton (number + sub-text) | `EmptyState(icon: Icons.account_balance_wallet_outlined, message: 'Belum ada penghasilan periode ini')` | inline retry banner inside the hero |
| Status chips | shimmer × 3 chips | hide entire row when all 0 | hide if summary errored |
| Withdraw CTA | disabled with spinner during request | hidden when `pending_cents = 0` OR `active_request_id != null` | snackbar on error |
| Session feed | shimmer × 3 rows | `EmptyState(icon: Icons.history, message: 'Belum ada sesi periode ini')` | `AsyncValueWidget` default error |
| Period selector | always rendered | n/a | n/a |

### 5.9 Withdrawal History screen (NEW — `/coach/wallet/requests`)

Canonical destination for rejection visibility. Feeds from `GET /v1/coach/payout-requests` (existing endpoint, already designed in §4.4 — paginated, filterable by period + status).

Layout:

```
┌─────────────────────────────────────┐
│ ← Riwayat Pencairan              🔔 │
├─────────────────────────────────────┤
│ Filter:  [Semua ▾]   [2026-06 ▾]    │  ← optional, MVP can ship without
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 4 Jun 2026                       │ │
│ │ Rp 600.000 · 5 sesi              │ │
│ │ [Ditolak]                        │ │  ← red badge for rejected
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 1 Jun 2026                       │ │
│ │ Rp 1.800.000 · 12 sesi           │ │
│ │ [Disetujui]                      │ │  ← info-blue for approved
│ └─────────────────────────────────┘ │
│ ...                                 │
└─────────────────────────────────────┘
```

Status badge per row:
- **Menunggu** (status='pending'): `AppColors.warning` palette
- **Disetujui** (status='approved'): info palette
- **Ditolak** (status='rejected'): `AppColors.error` palette
- **Dibatalkan** (status='cancelled', forward-compat, not shown in MVP since FE can't trigger this state)

Tap a row → push `/coach/wallet/requests/{id}` (Detail screen).

Entry points:
- Wallet screen — add a small text link in the AppBar overflow OR below the status chips: "Lihat riwayat pencairan" → push `/coach/wallet/requests`
- Direct nav from notifications (future — rejection notif would deep-link here; deferred per §6 Non-Goal 1)

Empty state: `EmptyState(icon: Icons.history_outlined, message: 'Belum ada permintaan pencairan')`.

### 5.10 Withdrawal Detail screen (NEW — `/coach/wallet/requests/{id}`)

Single `PayoutRequest` view. Feeds from `GET /v1/coach/payout-requests/{id}` (returns the request + linked payouts).

Layout:

```
┌─────────────────────────────────────┐
│ ← Detail Pencairan               🔔 │
├─────────────────────────────────────┤
│ Periode    : Juni 2026              │
│ Diajukan   : 4 Jun 2026, 21:30      │
│ Total      : Rp 600.000             │
│ Status     : [Ditolak]              │
├─────────────────────────────────────┤
│ ⚠ Catatan Penolakan                 │
│ "Rekening bank Anda perlu           │   ← only visible if status='rejected'
│  diverifikasi ulang sebelum         │     and rejection_note is non-null
│  pencairan berikutnya."             │
├─────────────────────────────────────┤
│ Diproses oleh: Admin Sari           │   ← only after processed_at is set
│ Diproses pada: 4 Jun 2026, 23:15    │
├─────────────────────────────────────┤
│ Sesi dalam permintaan (5)           │
│   ▸ 1 Jun · Joko · Rp 150.000       │
│   ▸ 3 Jun · Anna · Rp 150.000       │
│   ...                               │
└─────────────────────────────────────┘
```

Rejection-note section uses `AppColors.warningLight` background + `AppColors.warningDark` text, same treatment as the existing "Belum terdaftar di program" banner pattern on coach student detail screen.

**No actions on this screen for MVP.** Coach can read but not cancel/dispute (deferred per §6 Non-Goals 1, 3). Going back to Wallet → if rejected, the linked payouts are now back in `pending`, so the "Cairkan Rp X" CTA reappears with the same total — coach can request again.

### 5.11 Routing summary

| Path | Screen | Notes |
|---|---|---|
| `/coach/wallet` | Wallet (§5.3) | Hero + chips + CTA + session feed |
| `/coach/wallet/requests` | Withdrawal History (§5.9) | List of requests |
| `/coach/wallet/requests/{id}` | Withdrawal Detail (§5.10) | Single request + rejection note |

All three added to `AppRoutes` + `app_router.dart`. None on the bottom nav. The Wallet screen is the entry; Riwayat Pencairan link inside Wallet (not a separate top-level entry).

---

## 6. Non-Goals

1. **No coach-side rejection push notification.** Rejection visibility is now provided by the Withdrawal History + Detail screens (§5.9–5.10) — coach sees rejected status + admin's `rejection_note` when opening either. A future iteration can layer in a push notification or a Wallet-screen banner indicator ("Permintaan terakhir ditolak — buka untuk lihat alasan") without restructuring the data model. Deliberately out of MVP to avoid over-engineering the notification surface.
2. **No partial approval.** Admin approves the whole request or rejects it.
3. **No coach cancel.** `cancelled` status exists in the schema for forward-compat. FE has no cancel button. If coach changes mind, admin handles via reject.
4. **No per-payout request.** The "Cairkan" CTA always batches ALL pending payouts in the selected period.
5. **No multi-period batching.** One request scopes to one period. Coach with pending across June and May submits two requests.
6. **No Wallet on the bottom nav.** Accessed via profile or notification deep-link.
7. **No charts or trend graphs.** Hero number + chips suffice for MVP.
8. **No CSV/PDF export.** Coaches who need this can screenshot.
9. **No bank account snapshot on PayoutRequest.** Tenant-side bank info reused. Schema has room for `bank_snapshot` JSON later.
10. **Admin direct-approve of a request-linked payout does NOT auto-update the request status (CANDIDATE CLEANUP).** Under the loosened mobile-first constraint this can be tidied up (e.g., when a `Payout` linked to a pending `PayoutRequest` is directly approved or paid by admin, reconcile the parent `PayoutRequest` status accordingly — auto-approve when all linked payouts reach `approved`, mark complete when all reach `paid`). Trade-off: extra service-level coordination + risk of edge cases when partial sets transition. Tagged as **optional follow-up**, not mandatory for MVP. Vue admin team can opt into surfacing a "Payout is part of request #X" warning instead, leaving auto-reconciliation deferred.
11. **No Wallet for non-coach roles.** Player/organizer/admin do not get a wallet feature in this iteration.

---

## 7. Out of Scope (potential follow-ups)

- Coach-initiated cancel of a pending request.
- Rejection notification + in-app banner for rejected requests.
- Earnings trend chart (week-over-week, month-over-month).
- CSV / PDF export of earnings statements.
- Multi-period batched withdrawal.
- Direct bank transfer integration (Xendit disbursement API, etc.) — currently disbursement is manual by admin.
- Vue admin UI for the new `payout_requests` resource (BE provides endpoints; web team consumes).

---

## 8. File Plan

### Backend — `C:\laragon\www\hypercoach`

**Created:**
```
database/migrations/2026_06_04_xxxxxx_create_payout_requests_table.php
app/Models/PayoutRequest.php
app/Services/PayoutRequestService.php
app/Http/Controllers/Coach/PayoutRequestController.php
app/Http/Controllers/Admin/PayoutRequestController.php
app/Notifications/PayoutEarnedNotification.php
app/Notifications/PayoutRequestApprovedNotification.php
app/Notifications/PayoutDisbursedNotification.php
tests/Feature/Payouts/PayoutRequestServiceTest.php
tests/Feature/Payouts/CoachPayoutRequestEndpointTest.php
tests/Feature/Payouts/AdminPayoutRequestEndpointTest.php
tests/Feature/Payouts/CoachPayoutSummaryEndpointTest.php
tests/Feature/Notifications/PayoutEarnedNotificationTest.php
tests/Feature/Notifications/PayoutRequestApprovedNotificationTest.php
tests/Feature/Notifications/PayoutDisbursedNotificationTest.php
```

**Modified:**
```
config/notifications.php                              (add 3 new classes to target_role_map as 'coach')
routes/api.php                                        (4 new coach + 4 new admin routes)
app/Http/Controllers/Coach/PayoutController.php       (add @summary action — keep in existing controller, do not split)
app/Listeners/GeneratePayoutOnSessionComplete.php     (dispatch PayoutEarnedNotification after Payout::create)
app/Services/PayoutService.php                        (dispatch PayoutDisbursedNotification at end of markPaid)
database/seeders/RoleAndPermissionSeeder.php          (add request-own-payouts permission to coach role)
lang/id/notifications.php                             (add 6 new keys: 3 titles + 3 bodies)
```

### Frontend — `D:\projects\Flutter\hyperarena`

**Created:**
```
lib/features/wallet/data/api_wallet_repository.dart
lib/features/wallet/data/models/coach_payout.dart        (+ .freezed + .g)
lib/features/wallet/data/models/coach_payout_summary.dart (+ .freezed + .g)
lib/features/wallet/data/models/payout_request.dart      (+ .freezed + .g)
lib/features/wallet/providers/wallet_period_provider.dart
lib/features/wallet/providers/wallet_summary_provider.dart
lib/features/wallet/providers/wallet_payouts_provider.dart
lib/features/wallet/providers/payout_request_action_provider.dart
lib/features/wallet/presentation/screens/coach_wallet_screen.dart
lib/features/wallet/presentation/screens/coach_withdrawal_history_screen.dart    (NEW §5.9)
lib/features/wallet/presentation/screens/coach_withdrawal_detail_screen.dart     (NEW §5.10)
lib/features/wallet/presentation/widgets/wallet_period_selector.dart
lib/features/wallet/presentation/widgets/wallet_hero.dart
lib/features/wallet/presentation/widgets/wallet_status_chips.dart
lib/features/wallet/presentation/widgets/wallet_withdraw_cta.dart
lib/features/wallet/presentation/widgets/wallet_session_row.dart
lib/features/wallet/presentation/widgets/withdrawal_request_row.dart             (NEW — list item for History)
lib/features/wallet/providers/withdrawal_history_provider.dart                   (NEW — FutureProvider<List<PayoutRequest>>)
lib/features/wallet/providers/withdrawal_detail_provider.dart                    (NEW — FutureProvider.family<int, PayoutRequest>)
test/features/wallet/presentation/widgets/*_test.dart   (one per widget)
test/features/wallet/presentation/screens/coach_withdrawal_history_screen_test.dart (NEW)
test/features/wallet/presentation/screens/coach_withdrawal_detail_screen_test.dart  (NEW)
test/features/wallet/providers/wallet_summary_provider_test.dart
test/features/wallet/providers/withdrawal_history_provider_test.dart             (NEW)
test/features/wallet/providers/withdrawal_detail_provider_test.dart              (NEW)
test/features/wallet/providers/payout_request_action_provider_test.dart
```

**BE (additional from initial draft):**
```
app/Support/AttendanceCompletenessChecker.php   (NEW — §4.7 shared validator)
app/Exceptions/IncompleteAttendanceException.php (NEW — §4.7 exception class, mapped to 422)
tests/Feature/Sessions/AttendanceCompletenessTest.php (NEW — covers mark-complete guard, both coach + admin endpoints)
```

**Modified:**
```
lib/routing/app_routes.dart                                                      (add coachWallet, coachWithdrawalHistory, coachWithdrawalDetail route helpers)
lib/routing/app_router.dart                                                      (add 3 new GoRoutes under /coach/wallet)
app/Http/Controllers/Coach/SessionController.php                                 (BE: insert attendance-complete guard before status flip — §4.7)
app/Http/Controllers/Admin/SessionController.php                                 (BE: same guard in @completeSession)
lib/features/notification/data/models/notification_item.dart                     (add 3 enum values)
lib/features/notification/data/api_notification_repository.dart                  (3 new type-to-route mappings)
lib/features/notification/utils/notification_route_resolver.dart                 (3 new push-tap cases)
lib/features/notification/presentation/widgets/notification_tile.dart            (3 new icon mappings)
lib/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart (Earnings card calls wallet_summary_provider; tap → push /coach/wallet)
lib/features/profile/presentation/screens/profile_screen.dart                    (add "Wallet" / "Penghasilan" menu entry — exact placement at implementation time)
```

---

## 9. Testing Strategy

### BE (Laravel feature tests, `LazilyRefreshDatabase`)

| Test | Asserts |
|---|---|
| `CreatePayoutRequestsTableMigrationTest` | up/down round-trip; FK + index present; `payouts.request_id` nullable FK added |
| `PayoutRequestServiceCreateTest` | happy path; throws when active request exists; throws when no pending payouts; correctly links payouts via FK; sums total correctly |
| `PayoutRequestServiceApproveTest` | transitions request to approved; calls `PayoutService::approvePayout` per linked payout; dispatches `PayoutRequestApprovedNotification`; throws if status != pending |
| `PayoutRequestServiceRejectTest` | transitions request to rejected; linked payouts stay pending; rejection_note saved; no notification dispatched |
| `CoachPayoutRequestEndpointTest` | POST happy path returns 201 + payload; 409 on duplicate active; 422 on no pending; 403 without permission; tenant scope leak guards |
| `AdminPayoutRequestEndpointTest` | approve + reject endpoints; permission gates; correct admin user recorded |
| `CoachPayoutSummaryEndpointTest` | correct totals per status; `active_request_id` reflects active request; null when none |
| `PayoutEarnedNotificationTest` | dispatched when listener runs; payload correct; target_role='coach' set by observer |
| `PayoutRequestApprovedNotificationTest` | dispatched in service approve |
| `PayoutDisbursedNotificationTest` | dispatched in `PayoutService::markPaid` |
| `AttendanceCompletenessTest` (NEW §4.7) | mark-complete returns 422 when any active session_student lacks attendance; succeeds when all `present|absent|late`; zero-booked session passes the gate (vacuous); cancelled session_students excluded from the count; applies on BOTH `Coach\SessionController@complete` AND `Admin\SessionController@completeSession`; chained: failed complete → no `SessionCompleted` event → no `Payout` row generated |

### FE (Flutter widget/unit tests)

| Component | Coverage |
|---|---|
| `WalletHero` | renders summary; shimmer on loading; inline retry on error |
| `WalletStatusChips` | renders 3 chips with correct amounts (Diproses = requested+approved); hides row when total=0; invariant total_earned == sum of 3 chips |
| `WalletWithdrawCta` | hidden when pending=0 OR active_request_id != null; opens confirmation sheet; submits via provider; success/error states |
| `WalletSessionRow` | renders payout row with correct status badge color per state (belum/diproses/sudah-dicairkan) |
| `WalletPeriodSelector` | prev/next changes provider state; picker dialog opens |
| `walletSummaryProvider` | parses summary JSON; defensive defaults for missing fields |
| `payoutRequestActionProvider` | success invalidates downstream providers; error surfaces message |
| `WithdrawalHistoryScreen` (NEW §5.9) | renders list with mocked PayoutRequest data; renders empty state when none; status badges color-coded |
| `WithdrawalDetailScreen` (NEW §5.10) | renders single request; shows rejection_note only when status='rejected' and note is non-null; lists linked payouts; back button returns to Wallet/History |
| `withdrawalHistoryProvider` (NEW) | parses paginated response; filters by period+status |
| `withdrawalDetailProvider` (NEW) | parses detail response with nested payouts |
| `notification_route_resolver` | 3 new types route to `/coach/wallet` |
| `NotificationItem.fromJson` | 3 new enum values parse correctly |

### Integration smoke test

One happy-path: coach lands on `/coach/wallet`, picks current month, taps "Cairkan", confirms in the sheet → request created, providers refresh, CTA hides, snackbar shown.

### Preview gate (manual)

Per the constraint: before merging, build APK + install on device + screenshot the screen end-to-end with seeded payouts on dev. User reviews UI. Iterate until OK. This is an explicit checkpoint in the implementation plan, not skipped.

---

## 10. Migration Order (deployment)

| Step | Action | Where | Risk if skipped |
|---|---|---|---|
| 1 | Migration: create `payout_requests` + add `request_id` to `payouts` | BE | Blocks all subsequent steps |
| 2 | Run permission seeder to add `request-own-payouts` to `coach` role | BE | Coach POST returns 403 |
| 3 | Add 3 new notification classes to `config/notifications.php` map | BE | New dispatches default to `target_role='all'` (visible to everyone — broken UX but not fatal) |
| 4 | Deploy BE code (controllers, service, notifications, listener+service hooks, lang strings) | BE | Endpoints not available, dispatches don't fire |
| 5 | Deploy FE code (wallet feature module + notification updates + dashboard plumbing) | FE | Coach has no entry point to wallet, but BE endpoints still callable |
| 6 | Preview gate: install APK on device, screenshot, user review | both | Skipping = potential UI regressions undetected |
| 7 | Smoke test on devapp: create test session → complete → verify notification + Payout row → coach requests → admin approves → verify notifications fire | dev | Production untested |
| 8 | Promote to prod (after dev stable for at least one sprint cycle) | both | Real users blocked from Wallet feature |

Rollback at each step independent. Migration `down()` reversible. Notification class registrations additive. Endpoint additions don't break existing endpoints.

---

## 11. Non-Functional Constraints + Change Classification

### Constraints

- **Mobile-first with explicit per-change classification** (replaces strict backward-compat). Default Additive unless flagged.
- **Design system consistency**: all new tokens (if any) added to existing theme files. All widgets use existing `AppColors`/`AppTypography`/`AppDimensions`/`AppSurfaces`/`AppShadows`. Font: **Plus Jakarta Sans**. Brand accents: Electric Blue / Teal / Vivid Orange — verified against `lib/core/theme/app_colors.dart` at implementation time.
- **Preview gate required**: APK built + device-installed + user-reviewed before merge.
- **frontend-design skill enforcement**: invoked during implementation pass per the consistency-first principle.
- **i18n**: Indonesian only on mobile (matches project memory). BE lang strings via existing `__('notifications.<key>', $params, $locale)` pattern.
- **Stack best practices**: Laravel — Form Request validation, Policy/permission gate, service layer, `DB::transaction`, feature test with `LazilyRefreshDatabase`. Flutter/Riverpod — feature-first, Freezed model, correct provider invalidation, widget/unit test coverage.

### Change Classification (per BE change in this spec)

Each entry: change description → classification → coordination notes.

| Change | Class | Notes |
|---|---|---|
| Create `payout_requests` table | Additive | New table, Vue ignores. |
| Add nullable FK `payouts.request_id` | Additive | Vue ignores unknown fields. Existing payout responses gain one optional JSON key. |
| New permission `request-own-payouts` | Additive | Vue admin unaffected. |
| New endpoints `/v1/coach/payout-requests*` + `/v1/admin/payout-requests*` | Additive | Net-new routes. Vue admin needs to build a UI later — flagged as a follow-up below. |
| New endpoint `GET /v1/coach/payouts/summary` | Additive | Net-new route. |
| Append `PayoutEarnedNotification` dispatch in `GeneratePayoutOnSessionComplete` | Additive | New notif row inserted; Vue admin already filters notifications page by user, unaffected. |
| Append `PayoutDisbursedNotification` dispatch in `PayoutService::markPaid` | Additive | Same. |
| Append `PayoutRequestApprovedNotification` dispatch in `PayoutRequestService::approve` | Additive | New service, no Vue impact. |
| **Attendance-complete validator on mark-complete endpoints** (§4.7) | **Shape-changing** | `Coach\SessionController@complete` and `Admin\SessionController@completeSession` gain a new failure mode: `422 Unprocessable Entity` with structured error when attendance is incomplete. Vue admin currently expects only `422` for the existing "status precondition" failure — it'll need to surface the new validation error key + message. **Coord owner: web team. Coord ETA: before mobile feature ships to prod.** Until coord lands, mobile-first means web admin temporarily loses the ability to mark a session complete with incomplete attendance — which is the desired behavior anyway. |

### Items the Vue admin team owns as follow-ups (not blocking this spec, but flagged)

1. Build admin UI to list + approve/reject `PayoutRequest` records (consumes new endpoints).
2. Surface "Payout is part of withdrawal request #X" warning on per-payout detail view (read the new `request_id` field).
3. Handle the new `422` validation error from mark-complete (when attendance incomplete) — display the structured message to admin.
4. (Optional) Reconcile `PayoutRequest.status` when admin direct-approves a request-linked payout — see §6 Non-Goal 10.

---

## 12. Open Questions (un-resolved at v2)

These items are flagged for the implementation plan to either resolve up-front or defer with an explicit decision.

1. **Expose `tenant.payout_sla_days` in auth user payload** — currently consumed server-side only. The Wallet withdrawal confirmation bottom sheet (§5.5) interpolates the SLA into the disclosure copy. Need to add the field to `App\Support\AuthUserPayload::fromUser` output as `tenant.payout_sla_days` (additive change — Vue ignores). If the implementation plan defers this, the bottom sheet hardcodes "beberapa hari kerja" instead.

2. **Attendance validator: detail-only vs aggregate** — §4.7 uses `count(attendances) >= count(active session_students)`. This is satisfied by ANY attendance row regardless of status validity. Tighter alternative: explicitly check `status IN ('present', 'absent', 'late')`. Decided in spec to use count-only (relies on attendance creation flow already validating status); the implementation plan can revisit if BE tests reveal an empty-status loophole.

3. **AttendanceCompletenessChecker placement** — proposed in `App\Support\` to match existing helper-class conventions. Alternative: as a method on `App\Services\SessionService` (if one exists or is created). Implementation plan picks based on existing code style; either works.

4. **Withdrawal History entry point UX** — §5.9 says "small text link in the AppBar overflow OR below the status chips". Final placement is a visual call best decided during the preview gate with the FE designer. Spec defers the exact pixel position.

5. **Notification deep-link for rejection (future)** — when a `PayoutRequestRejectedNotification` is later added, its route should target `/coach/wallet/requests/{id}` (not `/coach/wallet`) so the coach lands on the detail screen with the rejection note visible. Not implemented in MVP; flagged for the follow-up iteration.

---

## 13. Revision Log

### v2 (2026-06-04) — Post-review

Changes from v1 in response to product review:

- **§0 Pre-flight Code Verification** added — documents codebase findings (Laravel 12, attendance enum, mark-complete current behavior, accessor vs column, etc.) so future edits don't re-litigate them.
- **§1 Goal expanded** — now includes 3 screens (Wallet + Withdrawal History + Withdrawal Detail), plus the new attendance-complete gate at mark-complete.
- **§2 Decisions updated** — strict Vue backward-compat replaced with mobile-first + per-change classification.
- **§4.7 Attendance-complete validator (NEW)** — formalises the "absensi 100% terisi" gate, with reference SQL and explicit Vue coordination flag.
- **§5.4 Status chip mapping corrected** — "Diproses" now sums `requested_cents + approved_cents` (was missing approved); invariant `total_earned == sum(3 chips)` added.
- **§5.9 Withdrawal History screen (NEW)** — list of past PayoutRequest records.
- **§5.10 Withdrawal Detail screen (NEW)** — single request view with `rejection_note` surfacing.
- **§5.11 Routing summary** — added 3 routes under `/coach/wallet/...`.
- **§6 Non-Goal 1 rewritten** — rejection visibility now provided by History+Detail screens; push notif still deferred but no longer a feedback hole.
- **§6 Non-Goal 10 relaxed** — auto-reconcile `PayoutRequest.status` from direct-approve marked as candidate cleanup (optional follow-up).
- **§8 File Plan expanded** — added 2 new screens + their providers + their tests; added BE files for attendance validator (`AttendanceCompletenessChecker`, `IncompleteAttendanceException`).
- **§9 Testing updated** — added `AttendanceCompletenessTest` and the 2 new FE screen tests + 2 new provider tests.
- **§11 Change Classification (NEW)** — every BE change tagged Additive vs Shape-changing, with coordination owner + ETA for shape-changing items. Mark-complete validator is the only Shape-changing change; web team flagged as coord owner.
- **§12 Open Questions** added.
- Design system note tightened: font is **Plus Jakarta Sans**, brand accents Electric Blue / Teal / Vivid Orange (to be verified against `lib/core/theme/app_colors.dart` at implementation).
- Removed any "strict no breaking changes" framing — replaced with classification-driven approach.

### v1 (2026-06-04) — Initial draft

- Initial design: Wallet screen + PayoutRequest entity + 3 notifications. Strict Vue backward-compat constraint. 3-chip UI with imprecise mapping (missed `approved_cents`). No attendance gate. No History/Detail screens.
