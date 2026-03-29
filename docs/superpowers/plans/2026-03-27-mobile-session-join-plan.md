# Mobile Session Join & Payment — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable mobile users to join marketplace sessions with a seamless credit-or-payment flow.

**Architecture:** New Laravel controller in `App\Http\Controllers\Marketplace` orchestrates existing services (BookingService, PurchaseService, CreditService) behind new endpoints at `/marketplace/sessions/{id}` and `/marketplace/sessions/{id}/join`. Flutter consumes these via new Freezed models and presentation screens based on the original commit `55092a5` design.

**Tech Stack:** Laravel 12 (backend), Flutter + Riverpod + Freezed (frontend), Dio (HTTP)

**Spec:** `docs/superpowers/specs/2026-03-27-mobile-session-join-design.md`

---

## Key Backend Context

Before implementing, understand these critical patterns:

### StudentProfile ↔ User link
There is NO `user_id` on `student_profiles`. The link goes through `student_accounts`:
- `student_accounts` has: `user_id`, `student_profile_id`, `claimed_at`
- To find a user's profile for a tenant: query `StudentAccount` → join `StudentProfile` → filter by `tenant_id`
- To auto-create: create `StudentProfile` (with `first_name`, `last_name`, `tenant_id`), then create `StudentAccount` linking `user_id` to it

### BelongsToTenant trait
Models using this trait (CreditLedger, Purchase, etc.) auto-set `tenant_id` from `app('current_tenant')` on creation and auto-scope queries. In marketplace context (no tenant resolved), you must bind the tenant manually:
```php
app()->instance('current_tenant', $tenant);
```

### BookingService::bookSession()
Returns `['success' => bool, 'booking' => SessionStudent, 'message' => string, 'code' => int]`. Always check `$result['success']` before proceeding.

### Route prefix
Marketplace routes use `/marketplace/*` (no `/v1/` prefix). Controllers live in `App\Http\Controllers\Marketplace\`.

### No factories
Only `UserFactory` exists. Tests must create records via `Model::create()`.

### Events
Registered in `AppServiceProvider::boot()` via `Event::listen()`, not EventServiceProvider.

---

## Chunk 1: Backend (Laravel)

### Task 1: MarketplaceSessionJoinService

Creates the orchestration service that coordinates existing services for the join flow.

**Files:**
- Create: `C:/laragon/www/hypercoach/app/Services/MarketplaceSessionJoinService.php`
- Create: `C:/laragon/www/hypercoach/app/Exceptions/SessionJoinException.php`
- Create: `C:/laragon/www/hypercoach/tests/Feature/Services/MarketplaceSessionJoinServiceTest.php`

- [ ] **Step 1: Create SessionJoinException**

```php
// app/Exceptions/SessionJoinException.php
namespace App\Exceptions;

use Symfony\Component\HttpKernel\Exception\HttpException;

class SessionJoinException extends HttpException
{
    public function __construct(string $message, int $statusCode = 422)
    {
        parent::__construct($statusCode, $message);
    }
}
```

- [ ] **Step 2: Write the MarketplaceSessionJoinService**

```php
// app/Services/MarketplaceSessionJoinService.php
namespace App\Services;

use App\Exceptions\SessionJoinException;
use App\Models\{User, Session, StudentProfile, StudentAccount, Product};
use Illuminate\Support\Facades\DB;

class MarketplaceSessionJoinService
{
    public function __construct(
        private BookingService $bookingService,
        private PurchaseService $purchaseService,
        private CreditService $creditService,
    ) {}

    /**
     * Join a marketplace session. Orchestrates credit check, booking, and purchase.
     * All operations wrapped in a DB transaction.
     */
    public function join(User $user, Session $session): array
    {
        $tenant = $session->tenant;

        // Pre-transaction validations
        if ($session->status !== 'scheduled') {
            throw new SessionJoinException('Sesi sudah dimulai atau selesai');
        }
        if ($session->start_at->isPast()) {
            throw new SessionJoinException('Sesi sudah dimulai atau selesai');
        }
        if (!$tenant->payment_bank_name || !$tenant->payment_account_number) {
            throw new SessionJoinException('Tenant belum mengatur pembayaran');
        }

        $product = Product::where('tenant_id', $tenant->id)
            ->where('session_type', $session->type)
            ->where('type', 'like', '%_single')
            ->where('is_active', true)
            ->first();

        if (!$product) {
            throw new SessionJoinException('Tenant belum mengatur harga sesi');
        }

        return DB::transaction(function () use ($user, $session, $tenant, $product) {
            // Bind tenant for BelongsToTenant trait (CreditLedger, Purchase, etc.)
            app()->instance('current_tenant', $tenant);

            // Resolve or auto-create StudentProfile via StudentAccount
            $profile = $this->resolveOrCreateProfile($user, $tenant);

            // Check if already booked
            $existingBooking = $session->sessionStudents()
                ->where('student_profile_id', $profile->id)
                ->whereNull('cancelled_at')
                ->exists();
            if ($existingBooking) {
                throw new SessionJoinException('Kamu sudah terdaftar di sesi ini');
            }

            // Check capacity
            $bookedCount = $session->sessionStudents()->whereNull('cancelled_at')->count();
            if ($session->capacity && $bookedCount >= $session->capacity) {
                throw new SessionJoinException('Sesi sudah penuh');
            }

            $balance = $this->creditService->getBalance($profile->id);

            if ($balance >= 1) {
                return $this->joinWithCredit($profile, $session, $balance);
            }

            return $this->joinWithPayment($profile, $session, $product);
        });
    }

    private function joinWithCredit(StudentProfile $profile, Session $session, int $currentBalance): array
    {
        $result = $this->bookingService->bookSession($profile->id, $session->id);
        if (!$result['success']) {
            throw new SessionJoinException($result['message'], $result['code'] ?? 422);
        }

        $booking = $result['booking'];
        $this->creditService->deductCredit(
            $profile->id,
            'booking',
            $booking->id,
            'Auto-deducted for marketplace session join',
        );

        $newBalance = $this->creditService->getBalance($profile->id);

        return [
            'status' => 'confirmed',
            'used_credit' => true,
            'credit_balance_after' => $newBalance,
            'purchase_id' => null,
            'expires_at' => null,
            'message' => 'Kamu bergabung menggunakan 1 kredit yang tersedia',
            'booking' => [
                'id' => $booking->id,
                'session_id' => $session->id,
                'booked_at' => $booking->booked_at->toIso8601String(),
            ],
        ];
    }

    private function joinWithPayment(StudentProfile $profile, Session $session, Product $product): array
    {
        $purchaseResult = $this->purchaseService->createPurchase($profile->id, $product->id);
        if (!$purchaseResult['success']) {
            throw new SessionJoinException('Gagal membuat pembelian');
        }
        $purchase = $purchaseResult['purchase'];

        $bookingResult = $this->bookingService->bookSession($profile->id, $session->id);
        if (!$bookingResult['success']) {
            throw new SessionJoinException($bookingResult['message'], $bookingResult['code'] ?? 422);
        }
        $booking = $bookingResult['booking'];

        $expiresAt = $purchase->created_at->addMinutes(30);

        return [
            'status' => 'pending_payment',
            'used_credit' => false,
            'credit_balance_after' => null,
            'purchase_id' => $purchase->id,
            'expires_at' => $expiresAt->toIso8601String(),
            'message' => 'Silakan lakukan pembayaran untuk menyelesaikan pendaftaran',
            'booking' => [
                'id' => $booking->id,
                'session_id' => $session->id,
                'booked_at' => $booking->booked_at->toIso8601String(),
            ],
        ];
    }

    /**
     * Find existing StudentProfile for user+tenant, or create one via StudentAccount.
     */
    private function resolveOrCreateProfile(User $user, $tenant): StudentProfile
    {
        // Check if user already has a profile for this tenant
        $account = StudentAccount::whereHas('studentProfile', function ($q) use ($tenant) {
            $q->where('tenant_id', $tenant->id);
        })->where('user_id', $user->id)->first();

        if ($account) {
            return $account->studentProfile;
        }

        // Auto-create
        $nameParts = explode(' ', $user->name, 2);
        $profile = StudentProfile::create([
            'tenant_id' => $tenant->id,
            'first_name' => $nameParts[0],
            'last_name' => $nameParts[1] ?? null,
        ]);

        StudentAccount::create([
            'user_id' => $user->id,
            'student_profile_id' => $profile->id,
            'claimed_at' => now(),
        ]);

        return $profile;
    }
}
```

- [ ] **Step 3: Write tests**

```php
// tests/Feature/Services/MarketplaceSessionJoinServiceTest.php
namespace Tests\Feature\Services;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\{User, Tenant, Session, StudentProfile, StudentAccount, Product, CreditLedger};
use App\Services\MarketplaceSessionJoinService;
use App\Exceptions\SessionJoinException;

class MarketplaceSessionJoinServiceTest extends TestCase
{
    use RefreshDatabase;

    private MarketplaceSessionJoinService $service;
    private Tenant $tenant;
    private User $user;
    private Session $session;
    private Product $product;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = app(MarketplaceSessionJoinService::class);

        $this->tenant = Tenant::create([
            'name' => 'Test Academy',
            'slug' => 'test-academy',
            'country' => 'ID',
            'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR',
            'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'PT Test',
        ]);

        $this->user = User::create([
            'name' => 'Haris Kelana',
            'email' => 'haris@test.com',
            'password' => bcrypt('password'),
        ]);

        $this->session = Session::create([
            'tenant_id' => $this->tenant->id,
            'type' => 'group',
            'capacity' => 8,
            'status' => 'scheduled',
            'start_at' => now()->addDay(),
            'duration_minutes' => 60,
        ]);

        $this->product = Product::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'Group Single',
            'type' => 'group_single',
            'session_type' => 'group',
            'price' => 75000,
            'currency' => 'IDR',
            'credit_amount' => 1,
            'is_active' => true,
        ]);
    }

    private function createProfileWithCredits(int $credits): StudentProfile
    {
        $profile = StudentProfile::create([
            'tenant_id' => $this->tenant->id,
            'first_name' => 'Haris',
            'last_name' => 'Kelana',
        ]);
        StudentAccount::create([
            'user_id' => $this->user->id,
            'student_profile_id' => $profile->id,
            'claimed_at' => now(),
        ]);
        if ($credits > 0) {
            CreditLedger::create([
                'tenant_id' => $this->tenant->id,
                'student_profile_id' => $profile->id,
                'amount' => $credits,
                'type' => 'purchase',
                'reference_type' => 'manual',
            ]);
        }
        return $profile;
    }

    public function test_join_with_existing_credits(): void
    {
        $this->createProfileWithCredits(2);

        $result = $this->service->join($this->user, $this->session);

        $this->assertEquals('confirmed', $result['status']);
        $this->assertTrue($result['used_credit']);
        $this->assertEquals(1, $result['credit_balance_after']);
        $this->assertNotNull($result['booking']);
    }

    public function test_join_without_credits_creates_pending_purchase(): void
    {
        $result = $this->service->join($this->user, $this->session);

        $this->assertEquals('pending_payment', $result['status']);
        $this->assertFalse($result['used_credit']);
        $this->assertNotNull($result['purchase_id']);
        $this->assertNotNull($result['expires_at']);
    }

    public function test_join_auto_creates_student_profile_and_account(): void
    {
        $this->assertDatabaseMissing('student_accounts', [
            'user_id' => $this->user->id,
        ]);

        $this->service->join($this->user, $this->session);

        $this->assertDatabaseHas('student_accounts', [
            'user_id' => $this->user->id,
        ]);
        // Verify profile created with correct tenant
        $account = StudentAccount::where('user_id', $this->user->id)->first();
        $this->assertEquals($this->tenant->id, $account->studentProfile->tenant_id);
    }

    public function test_join_fails_when_session_full(): void
    {
        $this->session->update(['capacity' => 1]);
        // Fill the one slot
        $otherProfile = StudentProfile::create([
            'tenant_id' => $this->tenant->id,
            'first_name' => 'Other',
        ]);
        $this->session->students()->attach($otherProfile->id, ['booked_at' => now()]);

        $this->expectException(SessionJoinException::class);
        $this->expectExceptionMessage('Sesi sudah penuh');
        $this->service->join($this->user, $this->session);
    }

    public function test_join_fails_when_already_booked(): void
    {
        $profile = $this->createProfileWithCredits(2);
        $this->session->students()->attach($profile->id, ['booked_at' => now()]);

        $this->expectException(SessionJoinException::class);
        $this->expectExceptionMessage('Kamu sudah terdaftar di sesi ini');
        $this->service->join($this->user, $this->session);
    }
}
```

- [ ] **Step 4: Run tests**

Run: `cd C:/laragon/www/hypercoach && php artisan test --filter=MarketplaceSessionJoinServiceTest`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd C:/laragon/www/hypercoach
git add app/Services/MarketplaceSessionJoinService.php app/Exceptions/SessionJoinException.php tests/Feature/Services/MarketplaceSessionJoinServiceTest.php
git commit -m "feat: add MarketplaceSessionJoinService with credit and payment paths"
```

---

### Task 2: Marketplace Session Controller & Routes

Adds the enriched detail endpoint, join endpoint, and proof upload.

**Files:**
- Modify: `C:/laragon/www/hypercoach/app/Http/Controllers/Marketplace/SessionController.php` — add `show` and `join` methods
- Create: `C:/laragon/www/hypercoach/app/Http/Controllers/Marketplace/PurchaseController.php` — proof upload
- Modify: `C:/laragon/www/hypercoach/routes/api.php` — add new routes
- Create: `C:/laragon/www/hypercoach/tests/Feature/Http/MarketplaceSessionControllerTest.php`

- [ ] **Step 1: Add `show` and `join` methods to existing SessionController**

```php
// Add to app/Http/Controllers/Marketplace/SessionController.php

use App\Models\{Product, StudentProfile, StudentAccount};
use App\Services\{CreditService, MarketplaceSessionJoinService};
use App\Exceptions\SessionJoinException;

public function show(Request $request, int $id): JsonResponse
{
    $session = Session::with(['tenant', 'coaches.user', 'sessionStudents.studentProfile'])
        ->findOrFail($id);

    $tenant = $session->tenant;
    $user = $request->user();

    // Bind tenant for scoped queries
    app()->instance('current_tenant', $tenant);

    // Resolve pricing
    $product = Product::withoutGlobalScope('tenant')
        ->where('tenant_id', $tenant->id)
        ->where('session_type', $session->type)
        ->where('type', 'like', '%_single')
        ->where('is_active', true)
        ->first();

    if (!$product) {
        return response()->json(['message' => 'Tenant belum mengatur harga sesi'], 422);
    }

    // User status via StudentAccount
    $creditBalance = 0;
    $existingBooking = null;
    $account = StudentAccount::whereHas('studentProfile', function ($q) use ($tenant) {
        $q->where('tenant_id', $tenant->id);
    })->where('user_id', $user->id)->first();

    if ($account) {
        $profile = $account->studentProfile;
        $creditService = app(CreditService::class);
        $creditBalance = $creditService->getBalance($profile->id);
        $existingBooking = $session->sessionStudents()
            ->where('student_profile_id', $profile->id)
            ->whereNull('cancelled_at')
            ->first();
    }

    // Participants
    $participants = $session->sessionStudents
        ->whereNull('cancelled_at')
        ->map(fn ($ss) => [
            'id' => $ss->student_profile_id,
            'name' => $ss->studentProfile
                ? trim(($ss->studentProfile->first_name ?? '') . ' ' . ($ss->studentProfile->last_name ?? ''))
                : 'Unknown',
            'booked_at' => $ss->booked_at?->toIso8601String(),
        ])->values();

    return response()->json([
        'session' => [
            'id' => $session->id,
            'name' => $session->name ?? 'Sesi Latihan',
            'type' => $session->type,
            'start_at' => $session->start_at->toIso8601String(),
            'duration_minutes' => $session->duration_minutes,
            'capacity' => $session->capacity,
            'booked_count' => $participants->count(),
            'notes' => $session->notes,
            'tenant' => $tenant ? ['id' => $tenant->id, 'name' => $tenant->name] : null,
            'venue' => null,
            'coaches' => $session->coaches->map(fn ($c) => [
                'id' => $c->id,
                'user' => $c->user ? [
                    'name' => $c->user->name,
                    'photo_urls' => $c->user->photo_urls ?? null,
                ] : null,
            ])->values(),
            'participants' => $participants,
        ],
        'pricing' => [
            'product_id' => $product->id,
            'price' => $product->price,
            'currency' => $product->currency,
            'label' => $product->name,
        ],
        'user_status' => [
            'credit_balance' => $creditBalance,
            'is_booked' => $existingBooking !== null,
            'booking_id' => $existingBooking?->id,
        ],
        'tenant_payment' => [
            'bank_name' => $tenant->payment_bank_name,
            'account_number' => $tenant->payment_account_number,
            'account_holder' => $tenant->payment_account_holder,
            'payment_instructions' => $tenant->payment_instructions,
        ],
    ]);
}

public function join(Request $request, int $id): JsonResponse
{
    $session = Session::with('tenant')->findOrFail($id);

    try {
        $joinService = app(MarketplaceSessionJoinService::class);
        $result = $joinService->join($request->user(), $session);
        return response()->json($result);
    } catch (SessionJoinException $e) {
        return response()->json(['message' => $e->getMessage()], $e->getStatusCode());
    }
}
```

- [ ] **Step 2: Create marketplace PurchaseController for proof upload**

```php
// app/Http/Controllers/Marketplace/PurchaseController.php
namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Models\{Purchase, StudentAccount};
use Illuminate\Http\{JsonResponse, Request};

class PurchaseController extends Controller
{
    public function uploadProof(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'proof' => ['required', 'image', 'max:5120'],
        ]);

        $purchase = Purchase::findOrFail($id);

        // Verify user owns this purchase via StudentAccount
        $ownsProfile = StudentAccount::where('user_id', $request->user()->id)
            ->where('student_profile_id', $purchase->student_profile_id)
            ->exists();

        if (!$ownsProfile) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $path = $request->file('proof')->store(
            "tenants/{$purchase->tenant_id}/proofs",
            'public',
        );

        $purchase->update([
            'payment_proof_path' => $path,
            'payment_proof_uploaded_at' => now(),
        ]);

        return response()->json(['message' => 'Bukti pembayaran berhasil diupload']);
    }
}
```

- [ ] **Step 3: Add routes to api.php**

Add inside the existing `Route::prefix('marketplace')->middleware(['auth:sanctum'])` group:

```php
Route::get('sessions/{id}', [Marketplace\SessionController::class, 'show']);
Route::post('sessions/{id}/join', [Marketplace\SessionController::class, 'join']);
Route::post('purchases/{id}/proof', [Marketplace\PurchaseController::class, 'uploadProof']);
```

- [ ] **Step 4: Write controller tests**

```php
// tests/Feature/Http/MarketplaceSessionControllerTest.php
// Test show returns enriched response with correct JSON structure
// Test join with credits returns confirmed
// Test join without credits returns pending_payment
// Test proof upload stores file and updates purchase
```

- [ ] **Step 5: Run tests**

Run: `cd C:/laragon/www/hypercoach && php artisan test --filter=MarketplaceSessionControllerTest`

- [ ] **Step 6: Commit**

```bash
cd C:/laragon/www/hypercoach
git add app/Http/Controllers/Marketplace/SessionController.php app/Http/Controllers/Marketplace/PurchaseController.php routes/api.php tests/Feature/Http/MarketplaceSessionControllerTest.php
git commit -m "feat: add marketplace session detail, join, and proof upload endpoints"
```

---

### Task 3: Session Cancellation Refund Listener

**Files:**
- Create: `C:/laragon/www/hypercoach/app/Events/SessionCancelled.php`
- Create: `C:/laragon/www/hypercoach/app/Listeners/RefundCreditsOnSessionCancellation.php`
- Modify: `C:/laragon/www/hypercoach/app/Providers/AppServiceProvider.php` — register event
- Create: `C:/laragon/www/hypercoach/tests/Feature/Listeners/RefundCreditsOnSessionCancellationTest.php`

- [ ] **Step 1: Create event**

```php
// app/Events/SessionCancelled.php
namespace App\Events;

use App\Models\Session;

class SessionCancelled
{
    public function __construct(public Session $session) {}
}
```

- [ ] **Step 2: Create listener**

```php
// app/Listeners/RefundCreditsOnSessionCancellation.php
namespace App\Listeners;

use App\Events\SessionCancelled;
use App\Services\CreditService;
use App\Models\Purchase;

class RefundCreditsOnSessionCancellation
{
    public function __construct(private CreditService $creditService) {}

    public function handle(SessionCancelled $event): void
    {
        $session = $event->session;
        $tenant = $session->tenant;

        // Bind tenant for BelongsToTenant trait
        app()->instance('current_tenant', $tenant);

        $bookings = $session->sessionStudents()->whereNull('cancelled_at')->get();

        foreach ($bookings as $booking) {
            // Check for pending purchase — cancel it
            $pendingPurchase = Purchase::withoutGlobalScope('tenant')
                ->where('student_profile_id', $booking->student_profile_id)
                ->where('status', 'pending_payment')
                ->latest()
                ->first();

            if ($pendingPurchase) {
                $pendingPurchase->update(['status' => 'cancelled']);
            } else {
                // Confirmed booking — refund 1 credit
                $this->creditService->addCredits(
                    $booking->student_profile_id,
                    1,
                    'refund',
                    'session_cancellation',
                    $session->id,
                    "Refund for cancelled session #{$session->id}",
                );
            }

            // Cancel the booking
            $booking->update(['cancelled_at' => now()]);

            // TODO: Send push notification "Sesi dibatalkan — 1 kredit dikembalikan"
        }
    }
}
```

- [ ] **Step 3: Register in AppServiceProvider::boot()**

Add to `app/Providers/AppServiceProvider.php`:
```php
Event::listen(SessionCancelled::class, RefundCreditsOnSessionCancellation::class);
```

- [ ] **Step 4: Write tests, run, and commit**

```bash
git commit -m "feat: add SessionCancelled event with credit refund listener"
```

---

### Task 4: Payment Expiry Scheduler

**Files:**
- Create: `C:/laragon/www/hypercoach/app/Console/Commands/ExpireStaleSessionPurchases.php`
- Modify: scheduler registration (routes/console.php or bootstrap/app.php)

- [ ] **Step 1: Create artisan command**

Finds purchases with `status = pending_payment` older than 30 minutes. Cancels them and their associated session_student bookings.

- [ ] **Step 2: Register in scheduler** (run every 5 minutes)

- [ ] **Step 3: Test manually and commit**

```bash
git commit -m "feat: add scheduled command to expire stale session purchases"
```

---

### Task 5: Organizer Participant Payment Endpoints

**Files:**
- Create: `C:/laragon/www/hypercoach/app/Http/Controllers/Marketplace/OrganizerSessionParticipantController.php`
- Modify: `C:/laragon/www/hypercoach/routes/api.php`

- [ ] **Step 1: Write the controller**

```php
// app/Http/Controllers/Marketplace/OrganizerSessionParticipantController.php
namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Models\{Session, Purchase};
use App\Services\PurchaseService;
use Illuminate\Http\{JsonResponse, Request};

class OrganizerSessionParticipantController extends Controller
{
    public function index(Request $request, int $sessionId): JsonResponse
    {
        $session = Session::with(['sessionStudents.studentProfile', 'tenant'])->findOrFail($sessionId);

        // Verify organizer owns this tenant
        // (authorization check depends on existing middleware/logic)

        app()->instance('current_tenant', $session->tenant);

        $participants = $session->sessionStudents->map(function ($ss) {
            $profile = $ss->studentProfile;
            $name = $profile
                ? trim(($profile->first_name ?? '') . ' ' . ($profile->last_name ?? ''))
                : 'Unknown';

            // Find associated purchase
            $purchase = Purchase::withoutGlobalScope('tenant')
                ->where('student_profile_id', $ss->student_profile_id)
                ->latest()
                ->first();

            $paymentStatus = 'confirmed_credit'; // default: joined via credit
            $paymentMethod = 'credit';

            if ($purchase) {
                $paymentMethod = 'bank_transfer';
                $paymentStatus = match ($purchase->status) {
                    'pending_payment' => $purchase->payment_proof_path
                        ? 'pending_confirmation'
                        : 'pending_payment',
                    'confirmed' => 'confirmed_transfer',
                    'cancelled' => 'rejected',
                    default => 'pending_payment',
                };
            }

            return [
                'student_name' => $name,
                'student_avatar_url' => $profile?->photo_urls['sm'] ?? null,
                'booking_id' => $ss->id,
                'booked_at' => $ss->booked_at?->toIso8601String(),
                'payment_status' => $paymentStatus,
                'payment_method' => $paymentMethod,
                'purchase_id' => $purchase?->id,
                'payment_proof_url' => $purchase?->payment_proof_path
                    ? asset('storage/' . $purchase->payment_proof_path)
                    : null,
                'amount_paid' => $purchase?->amount_paid,
                'currency' => $purchase?->currency,
            ];
        });

        return response()->json(['participants' => $participants]);
    }

    public function confirmPayment(Request $request, int $sessionId, int $purchaseId): JsonResponse
    {
        $session = Session::findOrFail($sessionId);
        app()->instance('current_tenant', $session->tenant);

        $purchaseService = app(PurchaseService::class);
        $result = $purchaseService->confirmPurchase($purchaseId, $request->user()->id);

        return response()->json($result);
    }

    public function rejectPayment(Request $request, int $sessionId, int $purchaseId): JsonResponse
    {
        $session = Session::findOrFail($sessionId);
        app()->instance('current_tenant', $session->tenant);

        $purchaseService = app(PurchaseService::class);
        $result = $purchaseService->cancelPurchase($purchaseId, $request->input('reason'));

        // Also cancel the booking
        $purchase = Purchase::find($purchaseId);
        if ($purchase) {
            $session->sessionStudents()
                ->where('student_profile_id', $purchase->student_profile_id)
                ->whereNull('cancelled_at')
                ->update(['cancelled_at' => now()]);
        }

        return response()->json($result);
    }
}
```

- [ ] **Step 2: Add routes**

Add to marketplace route group in `routes/api.php`:
```php
Route::get('organizer/sessions/{sessionId}/participants', [Marketplace\OrganizerSessionParticipantController::class, 'index']);
Route::patch('organizer/purchases/{purchaseId}/confirm', [Marketplace\OrganizerSessionParticipantController::class, 'confirmPayment'])->where('purchaseId', '[0-9]+');
Route::patch('organizer/purchases/{purchaseId}/reject', [Marketplace\OrganizerSessionParticipantController::class, 'rejectPayment'])->where('purchaseId', '[0-9]+');
```

Note: `confirmPayment` and `rejectPayment` take `sessionId` from the request context (they look up the session via the purchase's session_student relationship) — but we keep the route simple.

- [ ] **Step 3: Test and commit**

```bash
git commit -m "feat: add organizer session participant payment management endpoints"
```

---

### Task 6: Tenant Bank Validation at Session Creation

**Files:**
- Modify: `C:/laragon/www/hypercoach/app/Http/Requests/Admin/StoreSessionRequest.php` (or wherever session creation is validated)

- [ ] **Step 1: Add validation rule**

Add a custom validation rule or `after` callback that checks the tenant has `payment_bank_name`, `payment_account_number`, and `payment_account_holder` set. Return 422 if missing.

- [ ] **Step 2: Commit**

```bash
git commit -m "feat: validate tenant bank info on session creation"
```

---

## Chunk 2: Frontend (Flutter)

### Task 7: Freezed Models

**Files:**
- Create: `lib/features/session/data/models/marketplace_session_detail.dart`
- Create: `lib/features/session/data/models/tenant_payment_info.dart`
- Create: `lib/features/session/data/models/session_join_response.dart`

- [ ] **Step 1: Create MarketplaceSessionDetail model**

```dart
// lib/features/session/data/models/marketplace_session_detail.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/tenant_payment_info.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'marketplace_session_detail.freezed.dart';
part 'marketplace_session_detail.g.dart';

@freezed
class MarketplaceSessionDetail with _$MarketplaceSessionDetail {
  const factory MarketplaceSessionDetail({
    required MarketplaceSession session,
    required SessionPricing pricing,
    @JsonKey(name: 'user_status') required UserSessionStatus userStatus,
    @JsonKey(name: 'tenant_payment') required TenantPaymentInfo tenantPayment,
  }) = _MarketplaceSessionDetail;

  factory MarketplaceSessionDetail.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionDetailFromJson(json);
}

@freezed
class SessionPricing with _$SessionPricing {
  const factory SessionPricing({
    @JsonKey(name: 'product_id', fromJson: idFromJson) required String productId,
    required int price,
    required String currency,
    @Default('') String label,
  }) = _SessionPricing;

  factory SessionPricing.fromJson(Map<String, dynamic> json) =>
      _$SessionPricingFromJson(json);
}

@freezed
class UserSessionStatus with _$UserSessionStatus {
  const factory UserSessionStatus({
    @JsonKey(name: 'credit_balance') @Default(0) int creditBalance,
    @JsonKey(name: 'is_booked') @Default(false) bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson) String? bookingId,
  }) = _UserSessionStatus;

  factory UserSessionStatus.fromJson(Map<String, dynamic> json) =>
      _$UserSessionStatusFromJson(json);
}
```

- [ ] **Step 2: Add `nullableIdFromJson` to shared converters**

Add to `lib/shared/data/json_converters.dart`:
```dart
String? nullableIdFromJson(dynamic v) => v?.toString();
```

- [ ] **Step 3: Create TenantPaymentInfo model**

```dart
// lib/features/session/data/models/tenant_payment_info.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_payment_info.freezed.dart';
part 'tenant_payment_info.g.dart';

@freezed
class TenantPaymentInfo with _$TenantPaymentInfo {
  const factory TenantPaymentInfo({
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_holder') required String accountHolder,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
  }) = _TenantPaymentInfo;

  factory TenantPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$TenantPaymentInfoFromJson(json);
}
```

- [ ] **Step 4: Create SessionJoinResponse model**

```dart
// lib/features/session/data/models/session_join_response.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'session_join_response.freezed.dart';
part 'session_join_response.g.dart';

@freezed
class SessionJoinResponse with _$SessionJoinResponse {
  const factory SessionJoinResponse({
    required String status,
    @JsonKey(name: 'used_credit') required bool usedCredit,
    @JsonKey(name: 'credit_balance_after') int? creditBalanceAfter,
    @JsonKey(name: 'purchase_id') int? purchaseId,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    required String message,
    required JoinBookingInfo booking,
  }) = _SessionJoinResponse;

  factory SessionJoinResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionJoinResponseFromJson(json);
}

@freezed
class JoinBookingInfo with _$JoinBookingInfo {
  const factory JoinBookingInfo({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'session_id', fromJson: idFromJson) required String sessionId,
    @JsonKey(name: 'booked_at') required DateTime bookedAt,
  }) = _JoinBookingInfo;

  factory JoinBookingInfo.fromJson(Map<String, dynamic> json) =>
      _$JoinBookingInfoFromJson(json);
}
```

- [ ] **Step 5: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generated `.freezed.dart` and `.g.dart` files

- [ ] **Step 6: Commit**

```bash
git add lib/features/session/data/models/marketplace_session_detail.dart lib/features/session/data/models/tenant_payment_info.dart lib/features/session/data/models/session_join_response.dart lib/shared/data/json_converters.dart
git add lib/features/session/data/models/*.freezed.dart lib/features/session/data/models/*.g.dart
git commit -m "feat: add Freezed models for session detail, join response, and tenant payment"
```

---

### Task 8: Repository & Providers

**Files:**
- Modify: `lib/features/session/data/api_marketplace_session_repository.dart` — add `getSessionDetail`, `joinSession`, `uploadPaymentProof`
- Modify: `lib/shared/providers/marketplace_providers.dart` — add detail provider
- Create: `lib/features/session/providers/marketplace_session_join_provider.dart`

Note: This task depends on Task 7 (models must be generated first).

- [ ] **Step 1: Add methods to repository**

Add to `ApiMarketplaceSessionRepository`:
```dart
Future<MarketplaceSessionDetail> getSessionDetail(int id) async {
  try {
    final response = await _apiClient.get('/v1/marketplace/sessions/$id');
    return MarketplaceSessionDetail.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    rethrowDio(e);
  }
}

Future<SessionJoinResponse> joinSession(int sessionId) async {
  try {
    final response = await _apiClient.post('/v1/marketplace/sessions/$sessionId/join');
    return SessionJoinResponse.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    rethrowDio(e);
  }
}

Future<void> uploadPaymentProof(int purchaseId, String filePath) async {
  try {
    final formData = FormData.fromMap({
      'proof': await MultipartFile.fromFile(filePath),
    });
    await _apiClient.post('/v1/marketplace/purchases/$purchaseId/proof', data: formData);
  } on DioException catch (e) {
    rethrowDio(e);
  }
}
```

**Important:** Verify the API path prefix. The Flutter `ApiClient` baseUrl already includes `/api` (from `app_config.dart`). The Laravel routes are at `/marketplace/sessions/{id}`. So the repository path should be `/v1/marketplace/sessions/$id` ONLY if the Laravel routes have a `/v1` prefix configured in the route group. Check and align — if Laravel uses `/marketplace/*`, the Flutter path should be `/marketplace/sessions/$id` without `v1`.

- [ ] **Step 2: Add detail provider**

Add to `lib/shared/providers/marketplace_providers.dart`:
```dart
final marketplaceSessionDetailProvider =
    FutureProvider.family<MarketplaceSessionDetail, String>((ref, id) async {
  final repo = ref.watch(marketplaceSessionRepoProvider);
  return repo.getSessionDetail(int.parse(id));
});
```

- [ ] **Step 3: Create join provider**

```dart
// lib/features/session/providers/marketplace_session_join_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/session/data/models/session_join_response.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class MarketplaceSessionJoinState {
  final bool isLoading;
  final SessionJoinResponse? response;
  final String? error;

  const MarketplaceSessionJoinState({
    this.isLoading = false,
    this.response,
    this.error,
  });
}

class MarketplaceSessionJoinNotifier extends Notifier<MarketplaceSessionJoinState> {
  @override
  MarketplaceSessionJoinState build() => const MarketplaceSessionJoinState();

  Future<SessionJoinResponse?> join(int sessionId) async {
    state = const MarketplaceSessionJoinState(isLoading: true);
    try {
      final repo = ref.read(marketplaceSessionRepoProvider);
      final response = await repo.joinSession(sessionId);
      state = MarketplaceSessionJoinState(response: response);
      return response;
    } catch (e) {
      state = MarketplaceSessionJoinState(error: e.toString());
      return null;
    }
  }

  Future<bool> uploadProof(int purchaseId, String filePath) async {
    try {
      final repo = ref.read(marketplaceSessionRepoProvider);
      await repo.uploadPaymentProof(purchaseId, filePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  void reset() => state = const MarketplaceSessionJoinState();
}

final marketplaceSessionJoinProvider =
    NotifierProvider<MarketplaceSessionJoinNotifier, MarketplaceSessionJoinState>(
        MarketplaceSessionJoinNotifier.new);
```

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: add marketplace session repository methods and join provider"
```

---

### Task 9: Session Detail Screen Redesign

**Files:**
- Modify: `lib/features/session/presentation/screens/marketplace_session_detail_screen.dart` — full rewrite
- Modify: `lib/routing/app_router.dart` — change to path-parameter based route
- Modify: `lib/routing/app_routes.dart` — add new route constants

- [ ] **Step 1: Add route constants to AppRoutes**

```dart
static const marketplaceSessionPayment = '/marketplace/session/payment';
static const marketplaceSessionConfirmation = '/marketplace/session/confirmation';
```

- [ ] **Step 2: Update router to path-parameter approach**

Change from `_requireExtra<MarketplaceSession>` to:
```dart
GoRoute(
  path: '/marketplace/session/:id',
  builder: (_, state) => MarketplaceSessionDetailScreen(
    sessionId: state.pathParameters['id']!,
  ),
),
```

- [ ] **Step 3: Rewrite MarketplaceSessionDetailScreen**

Based on commit `55092a5` design. Key elements:
- Takes `sessionId` param, fetches via `marketplaceSessionDetailProvider(sessionId)`
- Shows loading/error/data states
- Horizontal `Wrap` grid for participants (circle avatars with initials, wrapping to next row)
- Empty slots as dashed circles (not selectable)
- Bottom bar: "Biaya per orang" + price + action button
- Button states: "Sudah Terdaftar" (disabled, success) / "Sesi Penuh" (disabled) / "Gabung Sekarang" (with credit badge if `creditBalance >= 1`)
- On tap "Gabung": if credits → show credit confirmation bottom sheet; if no credits → call join API → navigate to payment screen

- [ ] **Step 4: Test on device**

- [ ] **Step 5: Commit**

```bash
git commit -m "feat: redesign marketplace session detail with participant grid and join button"
```

---

### Task 10: Credit Confirmation Bottom Sheet

**Files:**
- Create: `lib/features/session/presentation/widgets/credit_confirmation_sheet.dart`

- [ ] **Step 1: Create the bottom sheet widget**

Shows: "Gunakan Kredit?" title, credit balance count, explanation text about refundability, Batal + Gabung buttons.

- [ ] **Step 2: Wire from session detail screen**

When user taps "Gabung" with `creditBalance >= 1`, show the sheet. On confirm, call `joinProvider.join(sessionId)` → navigate to confirmation screen.

- [ ] **Step 3: Commit**

```bash
git commit -m "feat: add credit confirmation bottom sheet for session join"
```

---

### Task 11: Payment Screen (Bank Transfer)

**Files:**
- Create: `lib/features/session/presentation/screens/marketplace_session_payment_screen.dart`

- [ ] **Step 1: Create payment screen**

- Countdown timer derived from `SessionJoinResponse.expiresAt`
- Price + session name at top (warning-colored card)
- Bank transfer details from `TenantPaymentInfo`
- `paymentInstructions` displayed below bank details
- No QRIS tab
- "Upload Bukti Pembayaran" button → image picker (camera/gallery)
- After upload → calls `joinProvider.uploadProof(purchaseId, filePath)`
- Navigates to waiting confirmation state

- [ ] **Step 2: Add route in app_router.dart**

- [ ] **Step 3: Test on device**

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: add marketplace session payment screen with bank transfer"
```

---

### Task 12: Confirmation & Waiting Screens

**Files:**
- Create: `lib/features/session/presentation/screens/marketplace_session_confirmation_screen.dart`

- [ ] **Step 1: Create confirmation screen (credit path)**

Animated checkmark (from commit `55092a5` pattern), session summary card (name, venue, date/time, price), "Berhasil Bergabung! 1 kredit telah digunakan.", "Kembali ke Explore" + "Kembali ke Beranda" buttons.

- [ ] **Step 2: Add waiting state for payment path**

"Bukti pembayaran terkirim. Menunggu konfirmasi dari penyelenggara." with Back to Explore button.

- [ ] **Step 3: Add routes in app_router.dart**

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: add marketplace session confirmation and waiting screens"
```

---

### Task 13: Notification Types Update

**Files:**
- Modify: `lib/features/notification/data/models/notification_item.dart` — add enum values
- Modify: `lib/features/notification/utils/notification_route_resolver.dart` — add/update routes

- [ ] **Step 1: Add new enum values**

Add `sessionCancelled`, `paymentConfirmed`, `paymentRejected` to `NotificationType` enum.

- [ ] **Step 2: Update NotificationRouteResolver**

```dart
'session_cancelled' ||
'payment_confirmed' => _marketplaceSessionRoute(data),
'payment_rejected' => _marketplaceSessionRoute(data), // was routing to AppRoutes.notifications
```

Add helper:
```dart
String? _marketplaceSessionRoute(Map<String, dynamic> data) {
  final sessionId = data['session_id']?.toString();
  if (sessionId == null) return null;
  return AppRoutes.marketplaceSession(sessionId);
}
```

- [ ] **Step 3: Run build_runner for notification model**

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: add session join notification types and route resolver updates"
```

---

### Task 14: End-to-End Testing & Cleanup

- [ ] **Step 1: Test credit path** — Login with user who has credits → session detail → tap Gabung → credit dialog → confirm → confirmation screen
- [ ] **Step 2: Test payment path** — Login with user, 0 credits → session detail → tap Gabung → payment screen with bank details → upload proof → waiting screen
- [ ] **Step 3: Test already-booked state** — Revisit session → button shows "Sudah Terdaftar"
- [ ] **Step 4: Test full session** — Session at capacity → button shows "Sesi Penuh"
- [ ] **Step 5: Run /simplify**
- [ ] **Step 6: Run /requesting-code-review**
