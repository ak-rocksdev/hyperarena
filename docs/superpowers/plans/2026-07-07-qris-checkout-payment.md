# QRIS Checkout Payment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make QRIS a fully working marketplace-checkout payment method — QR display + scan + automatic webhook confirmation — mirroring the existing Virtual Account (VA) flow, with the shared Rp5.000 Xendit fee.

**Architecture:** Backend adds a `XenditQrisGateway` (parallel to `XenditGateway`) that creates a Xendit QR via the existing `XenditApiClient::createQrCode`, stores it on the `Purchase`, and returns a `PaymentIntent` carrying the QR string; the existing webhook + confirm job are extended to accept the QR payment callback (normalizing its nested `data` envelope). Frontend adds a `qr_flutter`-rendered `QrisWaitingScreen` (parallel to `VaWaitingScreen`) and routes `qris` checkout intents to it. Everything else — Purchase model, webhook endpoint, status polling, fee, amount convention — is reused unchanged.

**Tech Stack:** Laravel 12 (hypercoach), Flutter + Riverpod + go_router (hyperarena), Xendit QR Code API 2022-07-31, `qr_flutter`.

**Repos & branches:** BE = `hypercoach` on `feature/qris-checkout-payment` (from `develop`). FE = `hyperarena` on `feature/qris-checkout-payment` (from `main`). Paths below are prefixed `hypercoach/` or `hyperarena/`.

## Global Constraints

- **Mirror VA exactly.** QRIS differs only in: create a QR (not a VA) and render a scannable QR (not a VA number). Do not invent new payment concepts.
- **Fee + expiry are config-driven and shared with VA:** `config('xendit.va_fee_amount')` (= `XENDIT_VA_FEE_AMOUNT`, 5000 local) and `config('xendit.va_expiry_minutes')` (= `XENDIT_VA_EXPIRY_MINUTES`, 15).
- **Amount convention (unchanged from VA):** the gateway charges `purchase->amount_paid` (base); the fee lives in `xendit_fee_amount`; client-facing total = base + fee.
- **Copy is Indonesian**, sentence case, active voice. WCAG AA: never use `AppColors.textTertiary` (#94A3B8) for essential text.
- **Karpathy guidelines:** minimum code that solves the problem; surgical changes (every changed line traces to a task); no speculative abstraction; match existing style.
- **No API keys/secrets committed** (`.env`, `storage/firebase-credentials.json` are gitignored).
- **`ewallet_*` stays out of scope** (still throws in the factory).

---

## File Map

**Backend (`hypercoach`):**
- Create: `database/migrations/2026_07_07_000000_add_xendit_qr_string_to_purchases.php` — adds one column.
- Modify: `app/Models/Purchase.php` — `$fillable` gains `xendit_qr_string`.
- Modify: `app/Support/PaymentIntent.php` — add `qrString` + `qr_string` in `toArray()`.
- Create: `app/Services/Payment/Gateways/XenditQrisGateway.php` — the QR gateway.
- Modify: `app/Providers/AppServiceProvider.php` — bind `XenditQrisGateway`.
- Modify: `app/Services/Payment/PaymentGatewayFactory.php` — inject + return it for `qris`.
- Modify: `app/Http/Controllers/Marketplace/MarketplacePurchaseController.php` — add `qr_string` to the store response.
- Modify: `app/Http/Controllers/Webhooks/XenditWebhookController.php` — normalize the nested QR envelope.
- Modify: `app/Jobs/ConfirmPurchaseFromXenditWebhook.php` — accept `qris_paid`.
- Create: `tests/Feature/Payment/XenditQrisGatewayTest.php`, `tests/Feature/Payment/MarketplaceCreatePurchaseQrisTest.php`, `tests/Feature/Webhooks/XenditQrWebhookTest.php`, `tests/Feature/Webhooks/ConfirmQrisPurchaseJobTest.php`.

> **Test conventions (whole plan, BE):** class-based PHPUnit (`extends TestCase`, `use LazilyRefreshDatabase`), Mockery for the Xendit client, no model factories (`Model::create([...])`). Mirror the nearest existing sibling: `XenditGatewayTest`, `MarketplaceCreatePurchaseAutomaticTest`, `XenditWebhookTest`, `ConfirmPurchaseJobTest`.

**Frontend (`hyperarena`):**
- Modify: `lib/features/payment/data/models/payment_intent.dart` — add `qrString`.
- Modify: `pubspec.yaml` — add `qr_flutter`.
- Create: `lib/features/payment/presentation/screens/qris_waiting_screen.dart` — the QR screen.
- Modify: `lib/routing/app_router.dart` — add `/payment/qris/:purchaseId`.
- Modify: `lib/features/payment/presentation/screens/checkout_screen.dart` — route `qris` to it.
- Create: `test/features/payment/qris_waiting_screen_test.dart`, `test/features/payment/checkout_routing_test.dart`.

---

## Task 1: Migration + Purchase model — `xendit_qr_string` column

**Files:**
- Create: `hypercoach/database/migrations/2026_07_07_000000_add_xendit_qr_string_to_purchases.php`
- Modify: `hypercoach/app/Models/Purchase.php` (`$fillable` array)
- Test: `hypercoach/tests/Feature/Payment/XenditQrisGatewayTest.php` (created here, first assertion only)

**Interfaces:**
- Produces: `purchases.xendit_qr_string` (nullable TEXT); `Purchase` mass-assignable `xendit_qr_string`.

> **Test-style note (applies to every BE test in this plan):** this suite is **class-based PHPUnit** — no Pest `it()`/`expect()`, no `tests/Pest.php`. And there are **no model factories** — build models with `Model::create([...])` using explicit fields, exactly like `tests/Feature/Payment/XenditGatewayTest.php` and `tests/Feature/Webhooks/ConfirmPurchaseJobTest.php`. This task creates the `XenditQrisGatewayTest` class shell (setUp + `makePurchase` helper) that Tasks 2 and 3 extend.

- [ ] **Step 1: Write the failing test** (`hypercoach/tests/Feature/Payment/XenditQrisGatewayTest.php`)

```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Product;
use App\Models\Purchase;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Services\Payment\Gateways\XenditQrisGateway;
use App\Services\Payment\XenditApiClient;
use App\Support\PaymentIntent;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Mockery;
use Tests\TestCase;

class XenditQrisGatewayTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private StudentProfile $student;
    private Product $product;

    protected function setUp(): void
    {
        parent::setUp();
        $this->tenant = Tenant::create([
            'name' => 'Test', 'slug' => 'test-'.uniqid(),
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1', 'payment_account_holder' => 'X',
        ]);
        $this->student = StudentProfile::create([
            'tenant_id' => $this->tenant->id,
            'first_name' => 'A', 'last_name' => 'B',
        ]);
        $this->product = Product::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'P', 'type' => 'group_single', 'session_type' => 'group',
            'price' => 80000, 'is_active' => true,
            'currency' => 'IDR', 'credit_amount' => 1,
        ]);
    }

    private function makePurchase(array $overrides = []): Purchase
    {
        return Purchase::create(array_merge([
            'tenant_id' => $this->tenant->id,
            'student_profile_id' => $this->student->id,
            'product_id' => $this->product->id,
            'status' => 'pending_payment',
            'amount_paid' => 80000,
            'currency' => 'IDR',
        ], $overrides));
    }

    public function test_xendit_qr_string_is_mass_assignable_and_persists(): void
    {
        $this->assertContains('xendit_qr_string', (new Purchase())->getFillable());

        $purchase = $this->makePurchase();
        $purchase->update(['xendit_qr_string' => '000201-QRIS']);
        $this->assertEquals('000201-QRIS', $purchase->fresh()->xendit_qr_string);
    }
}
```

- [ ] **Step 2: Run it — expect FAIL** (`xendit_qr_string` not fillable / column missing)

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: FAIL (`assertContains` fails, or a SQL error on the unknown `xendit_qr_string` column).

- [ ] **Step 3: Create the migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->text('xendit_qr_string')->nullable()->after('xendit_va_bank');
        });
    }

    public function down(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->dropColumn('xendit_qr_string');
        });
    }
};
```

- [ ] **Step 4: Add `xendit_qr_string` to `Purchase::$fillable`**

In `hypercoach/app/Models/Purchase.php`, add `'xendit_qr_string',` to the `$fillable` array immediately after `'xendit_va_bank',`.

- [ ] **Step 5: Run tests — expect PASS**

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
cd hypercoach && git add database/migrations/2026_07_07_000000_add_xendit_qr_string_to_purchases.php app/Models/Purchase.php tests/Feature/Payment/XenditQrisGatewayTest.php
git commit -m "feat(payment): add xendit_qr_string column to purchases"
```

---

## Task 2: `PaymentIntent` (Support) — carry `qrString`

**Files:**
- Modify: `hypercoach/app/Support/PaymentIntent.php`
- Test: `hypercoach/tests/Feature/Payment/XenditQrisGatewayTest.php` (append)

**Interfaces:**
- Consumes: nothing.
- Produces: `PaymentIntent` gains `public ?string $qrString = null`; `toArray()` emits `'qr_string' => $this->qrString`.

- [ ] **Step 1: Write the failing test** — add a method to `XenditQrisGatewayTest` (`PaymentIntent`, `Carbon` are already imported by Task 1)

```php
    public function test_payment_intent_serializes_qr_string(): void
    {
        $intent = new PaymentIntent(
            providerLabel: 'automatic',
            methodKey: 'qris',
            baseAmount: 80000,
            feeAmount: 5000,
            totalAmount: 85000,
            qrString: '000201-QRIS',
            expiresAt: Carbon::parse('2026-07-07T12:00:00Z'),
        );
        $this->assertEquals('000201-QRIS', $intent->toArray()['qr_string']);
    }
```

- [ ] **Step 2: Run it — expect FAIL** (`qrString` is not a constructor arg)

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: FAIL (unknown named argument `qrString`).

- [ ] **Step 3: Add `qrString` to `PaymentIntent`**

In `hypercoach/app/Support/PaymentIntent.php`, add a constructor property after `public ?string $vaBank = null,`:

```php
        public ?string $vaBank = null,
        public ?string $qrString = null,
```

And in `toArray()`, add after the `'va_bank'` line:

```php
            'va_bank' => $this->vaBank,
            'qr_string' => $this->qrString,
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
cd hypercoach && git add app/Support/PaymentIntent.php tests/Feature/Payment/XenditQrisGatewayTest.php
git commit -m "feat(payment): PaymentIntent carries qr_string"
```

---

## Task 3: `XenditQrisGateway` — create a QR payment

**Files:**
- Create: `hypercoach/app/Services/Payment/Gateways/XenditQrisGateway.php`
- Test: `hypercoach/tests/Feature/Payment/XenditQrisGatewayTest.php` (append)

**Interfaces:**
- Consumes: `XenditApiClient::createQrCode(referenceId, amount, expiresAt): array{id,reference_id,qr_string,status}` (exists); `PaymentIntent` with `qrString` (Task 2).
- Produces: `XenditQrisGateway implements PaymentGateway`. `createPayment(Purchase, 'qris'): PaymentIntent`. Stores `xendit_callback_id` = QR id, `xendit_external_id` = `{prefix}-PURCHASE-{id}`, `xendit_qr_string`, `xendit_fee_amount`, `xendit_expires_at`, `payment_method='qris'`, `payment_provider='xendit'`.

- [ ] **Step 1: Write the failing test** — add two methods to `XenditQrisGatewayTest` (mirrors `XenditGatewayTest::test_create_payment_with_va_bca_*`; all imports already present)

```php
    public function test_create_payment_with_qris_calls_xendit_and_persists(): void
    {
        $apiClient = Mockery::mock(XenditApiClient::class);
        $apiClient->shouldReceive('createQrCode')
            ->once()
            ->withArgs(function ($referenceId, $amount, $expiresAt) {
                return $amount === 80000 && str_starts_with($referenceId, 'hypercoach-PURCHASE-');
            })
            ->andReturn([
                'id' => 'qr_test_123',
                'reference_id' => 'hypercoach-PURCHASE-1',
                'qr_string' => '000201-QRIS-PAYLOAD',
                'status' => 'ACTIVE',
            ]);

        $gateway = new XenditQrisGateway($apiClient, 15, 'hypercoach', 5000);
        $purchase = $this->makePurchase();

        $intent = $gateway->createPayment($purchase, 'qris');

        $this->assertEquals('automatic', $intent->providerLabel);
        $this->assertEquals('qris', $intent->methodKey);
        $this->assertEquals('000201-QRIS-PAYLOAD', $intent->qrString);
        $this->assertEquals(5000, $intent->feeAmount);
        $this->assertEquals(85000, $intent->totalAmount);

        $purchase->refresh();
        $this->assertEquals('qris', $purchase->payment_method);
        $this->assertEquals('xendit', $purchase->payment_provider);
        $this->assertEquals('qr_test_123', $purchase->xendit_callback_id);
        $this->assertEquals('000201-QRIS-PAYLOAD', $purchase->xendit_qr_string);
        $this->assertStringContainsString('PURCHASE-', $purchase->xendit_external_id);
        $this->assertEquals(5000, $purchase->xendit_fee_amount);

        // Branding: no internal provider name leaks into the client-facing intent
        $this->assertStringNotContainsString('xendit', strtolower(json_encode($intent->toArray())));
    }

    public function test_create_payment_rejects_non_qris_method(): void
    {
        $apiClient = Mockery::mock(XenditApiClient::class);
        $apiClient->shouldNotReceive('createQrCode');
        $gateway = new XenditQrisGateway($apiClient, 15, 'hypercoach', 5000);

        $this->expectException(\InvalidArgumentException::class);
        $gateway->createPayment($this->makePurchase(), 'va_bca');
    }
```

- [ ] **Step 2: Run it — expect FAIL** (class does not exist)

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: FAIL (`Class "App\Services\Payment\Gateways\XenditQrisGateway" not found`).

- [ ] **Step 3: Create `XenditQrisGateway`** (mirror `XenditGateway`)

```php
<?php

namespace App\Services\Payment\Gateways;

use App\Contracts\PaymentGateway;
use App\Models\Purchase;
use App\Services\Payment\XenditApiClient;
use App\Support\PaymentIntent;
use Carbon\Carbon;

class XenditQrisGateway implements PaymentGateway
{
    public function __construct(
        private readonly XenditApiClient $apiClient,
        private readonly int $qrExpiryMinutes = 15,
        private readonly string $externalIdPrefix = 'hypercoach',
        private readonly int $feeAmount = 4000,
    ) {
        if (strlen($externalIdPrefix) > 32) {
            throw new \InvalidArgumentException(
                'XENDIT_EXTERNAL_ID_PREFIX too long: max 32 chars, got '.strlen($externalIdPrefix)
            );
        }
    }

    public function createPayment(Purchase $purchase, string $method): PaymentIntent
    {
        if ($method !== 'qris') {
            throw new \InvalidArgumentException(
                "XenditQrisGateway only handles 'qris', got: {$method}"
            );
        }

        $externalId = "{$this->externalIdPrefix}-PURCHASE-{$purchase->id}";
        $expiresAt = Carbon::now()->addMinutes($this->qrExpiryMinutes);

        $qr = $this->apiClient->createQrCode(
            referenceId: $externalId,
            amount: (int) $purchase->amount_paid,
            expiresAt: $expiresAt->toIso8601String(),
        );

        $purchase->forceFill([
            'payment_provider' => 'xendit',
            'payment_method' => 'qris',
            'xendit_callback_id' => $qr['id'],
            'xendit_external_id' => $externalId,
            'xendit_qr_string' => $qr['qr_string'],
            'xendit_fee_amount' => $this->feeAmount,
            'xendit_expires_at' => $expiresAt,
        ])->save();

        activity()
            ->performedOn($purchase)
            ->withProperties([
                'payment_provider' => 'automatic',
                'payment_method' => 'qris',
                'amount' => $purchase->amount_paid,
            ])
            ->log('Automatic payment intent created');

        return new PaymentIntent(
            providerLabel: 'automatic',
            methodKey: 'qris',
            baseAmount: (int) $purchase->amount_paid,
            feeAmount: $this->feeAmount,
            totalAmount: (int) $purchase->amount_paid + $this->feeAmount,
            qrString: $qr['qr_string'],
            expiresAt: $expiresAt,
        );
    }

    public function getStatus(Purchase $purchase): string
    {
        return $purchase->status;
    }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `cd hypercoach && php artisan test --filter=XenditQrisGatewayTest`
Expected: PASS (all cases).

- [ ] **Step 5: Commit**

```bash
cd hypercoach && git add app/Services/Payment/Gateways/XenditQrisGateway.php tests/Feature/Payment/XenditQrisGatewayTest.php
git commit -m "feat(payment): XenditQrisGateway creates and stores a QR payment"
```

---

## Task 4: Wire QRIS into the purchase flow (DI + factory + controller response)

**Files:**
- Modify: `hypercoach/app/Providers/AppServiceProvider.php`
- Modify: `hypercoach/app/Services/Payment/PaymentGatewayFactory.php`
- Modify: `hypercoach/app/Http/Controllers/Marketplace/MarketplacePurchaseController.php`
- Test: `hypercoach/tests/Feature/Payment/MarketplaceCreatePurchaseQrisTest.php` (new; mirror `MarketplaceCreatePurchaseAutomaticTest.php`)

**Interfaces:**
- Consumes: `XenditQrisGateway` (Task 3).
- Produces: `PaymentGatewayFactory::forMethod('qris')` returns `XenditQrisGateway`; `POST /api/v1/marketplace/purchases` with `payment_method=qris` returns JSON including `qr_string`.

- [ ] **Step 1: Write the failing feature test** (`hypercoach/tests/Feature/Payment/MarketplaceCreatePurchaseQrisTest.php`, class-based)

Copy `MarketplaceCreatePurchaseAutomaticTest.php` verbatim as the starting point (its `setUp` builds the tenant, `RoleAndPermissionSeeder`, member `User` + `StudentAccount`, `Session`/`Product`, `TenantPaymentSettings`, Sanctum acting-as, and `config(['xendit.api_key' => ...])` — the test env sets `XENDIT_API_KEY=''`, so this override is required or `availableMethods` hides automatic methods). Change the class name to `MarketplaceCreatePurchaseQrisTest`, enable QRIS on the settings (`qris_enabled => true`), reuse the **exact request path and request body** the VA test posts (only switching `payment_method` to `'qris'`), and swap the mock + assertions:

```php
    public function test_creates_a_qris_purchase_and_returns_the_qr_string(): void
    {
        // The test env leaves the fee unset → config default. Assert against it,
        // never a hard-coded number (local .env is 5000, CI is 4000).
        $expectedFee = (int) config('xendit.va_fee_amount', 4000);

        $this->mock(\App\Services\Payment\XenditApiClient::class, function ($m) {
            $m->shouldReceive('createQrCode')->once()->andReturn([
                'id' => 'qr_abc',
                'reference_id' => 'hypercoach-PURCHASE-x',
                'qr_string' => '000201-QR',
                'status' => 'ACTIVE',
            ]);
        });

        // <reuse the VA test's exact acting-as + POST call, payment_method => 'qris'>
        $res = $this->postJson(/* same path + body as the VA test */, [
            /* ...same product/session fields... */
            'payment_method' => 'qris',
        ]);

        $res->assertOk()
            ->assertJsonPath('provider', 'automatic')
            ->assertJsonPath('payment_method', 'qris')
            ->assertJsonPath('qr_string', '000201-QR')
            ->assertJsonPath('fee_amount', $expectedFee);

        $this->assertDatabaseHas('purchases', [
            'payment_method' => 'qris',
            'xendit_qr_string' => '000201-QR',
        ]);
    }

    public function test_factory_returns_the_qris_gateway(): void
    {
        $this->assertInstanceOf(
            \App\Services\Payment\Gateways\XenditQrisGateway::class,
            app(\App\Services\Payment\PaymentGatewayFactory::class)->forMethod('qris'),
        );
    }
```

- [ ] **Step 2: Run it — expect FAIL** (factory throws "QRIS + e-wallet land in P5"; no `qr_string` in response)

Run: `cd hypercoach && php artisan test --filter=MarketplaceCreatePurchaseQrisTest`
Expected: FAIL.

- [ ] **Step 3: Bind `XenditQrisGateway` in `AppServiceProvider`**

In `hypercoach/app/Providers/AppServiceProvider.php`, directly after the existing `XenditGateway` singleton binding, add:

```php
        $this->app->singleton(\App\Services\Payment\Gateways\XenditQrisGateway::class, function ($app) {
            return new \App\Services\Payment\Gateways\XenditQrisGateway(
                apiClient: $app->make(\App\Services\Payment\XenditApiClient::class),
                qrExpiryMinutes: (int) config('xendit.va_expiry_minutes', 15),
                externalIdPrefix: (string) config('xendit.external_id_prefix', 'hypercoach'),
                feeAmount: (int) config('xendit.va_fee_amount', 4000),
            );
        });
```

- [ ] **Step 4: Return the gateway from `PaymentGatewayFactory`**

In `hypercoach/app/Services/Payment/PaymentGatewayFactory.php`:
1. Add the import `use App\Services\Payment\Gateways\XenditQrisGateway;`.
2. Add a constructor param `private readonly XenditQrisGateway $qris,` after `private readonly XenditGateway $xendit,`.
3. Replace the `qris`/`ewallet_` throw block with:

```php
        if ($method === 'qris') {
            return $this->qris;
        }

        if (str_starts_with($method, 'ewallet_')) {
            throw new \RuntimeException(
                "Payment method '{$method}' not yet available — e-wallet lands in a later phase."
            );
        }
```

- [ ] **Step 5: Add `qr_string` to the store response**

In `hypercoach/app/Http/Controllers/Marketplace/MarketplacePurchaseController.php`, in the `$response = [...]` array in `store()`, add after the `'va_bank'` line:

```php
            'va_bank' => $purchase->xendit_va_bank,
            'qr_string' => $purchase->xendit_qr_string,
```

- [ ] **Step 6: Run tests — expect PASS**

Run: `cd hypercoach && php artisan test --filter=MarketplaceCreatePurchaseQrisTest`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
cd hypercoach && git add app/Providers/AppServiceProvider.php app/Services/Payment/PaymentGatewayFactory.php app/Http/Controllers/Marketplace/MarketplacePurchaseController.php tests/Feature/Payment/MarketplaceCreatePurchaseQrisTest.php
git commit -m "feat(payment): route qris checkout to XenditQrisGateway + expose qr_string"
```

---

## Task 5: Webhook — normalize the nested QR envelope

**Files:**
- Modify: `hypercoach/app/Http/Controllers/Webhooks/XenditWebhookController.php`
- Test: `hypercoach/tests/Feature/Webhooks/XenditQrWebhookTest.php` (new; mirror `tests/Feature/Webhooks/XenditWebhookTest.php`)

**Background:** Xendit QR (2022-07-31) delivers the payment webhook as a nested envelope `{ "event": "qr.payment", "data": { "id", "qr_id", "reference_id", "amount", "status", … } }`, whereas the controller reads flat top-level fields (correct for VA). Lifting `data` to the top level makes `classifyEvent` (which returns `qris_paid` when top-level `qr_id`/`qr_code` is present), the event-id/external-id extraction, and dispatch routing work for both shapes.

**⚠️ First — capture the real payload.** Before trusting the fixture below, trigger a Xendit **test** QR payment (see the live-verification runbook at the end) and log the actual webhook body (`Log::info('xendit qr webhook', $request->all())`). Confirm the field locations (`data.qr_id`, `data.reference_id`, `data.amount`, `data.status`, and the event id). Adjust the fixture/normalization if Xendit's shape differs from the assumption below, then remove the temporary log line.

**Interfaces:**
- Produces: after `handle()` normalization, a QR payload exposes `id`, `reference_id`, `qr_id`, `amount`, `status` at the top level; VA payloads are unchanged (no `data` key).

- [ ] **Step 1: Write the failing test** (`hypercoach/tests/Feature/Webhooks/XenditQrWebhookTest.php`, mirrors `XenditWebhookTest`)

```php
<?php

namespace Tests\Feature\Webhooks;

use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Queue;
use Tests\TestCase;

class XenditQrWebhookTest extends TestCase
{
    use LazilyRefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config(['xendit.callback_token' => 'secret_token']);
        config(['xendit.ip_whitelist' => []]);
    }

    public function test_accepts_and_classifies_a_nested_qr_payment_webhook(): void
    {
        Queue::fake();

        $payload = [
            'event' => 'qr.payment',
            'data' => [
                'id' => 'qrpy_evt_1',
                'qr_id' => 'qr_abc',
                'reference_id' => 'hypercoach-PURCHASE-999',
                'amount' => 80000,
                'status' => 'SUCCEEDED',
            ],
        ];

        $response = $this->postJson('/api/v1/webhooks/xendit/va', $payload, [
            'X-CALLBACK-TOKEN' => 'secret_token',
        ]);

        $response->assertOk()->assertJson(['status' => 'received', 'event' => 'qrpy_evt_1']);

        $this->assertDatabaseHas('xendit_webhook_events', [
            'xendit_event_id' => 'qrpy_evt_1',
            'event_type' => 'qris_paid',
            'xendit_external_id' => 'hypercoach-PURCHASE-999',
            'processing_status' => 'pending',
        ]);

        Queue::assertPushed(\App\Jobs\ConfirmPurchaseFromXenditWebhook::class);
    }
}
```

- [ ] **Step 2: Run it — expect FAIL** (no top-level `id` → 422 "missing id"; nothing persisted)

Run: `cd hypercoach && php artisan test --filter=XenditQrWebhookTest`
Expected: FAIL.

- [ ] **Step 3: Normalize the envelope at the top of `handle()`**

In `hypercoach/app/Http/Controllers/Webhooks/XenditWebhookController.php`, in `handle()`, immediately after `$payload = $request->all();` (step 3 comment), insert:

```php
        // Xendit QR (2022-07-31) nests the payment fields under `data`; lift them
        // to the top level so classification + extraction match the flat VA shape.
        if (isset($payload['data']) && is_array($payload['data'])) {
            $payload = array_merge($payload, $payload['data']);
        }
```

(The rest of `handle()` — `$eventId = $payload['id']`, the `XenditWebhookEvent` external-id capture, `classifyEvent`, and dispatch — is unchanged and now works for QR.)

- [ ] **Step 4: Run tests — expect PASS** (and confirm no VA regression)

Run: `cd hypercoach && php artisan test --filter=XenditQrWebhookTest && php artisan test --filter=XenditWebhookTest`
Expected: both PASS.

- [ ] **Step 5: Commit**

```bash
cd hypercoach && git add app/Http/Controllers/Webhooks/XenditWebhookController.php tests/Feature/Webhooks/XenditQrWebhookTest.php
git commit -m "feat(payment): normalize nested Xendit QR webhook envelope"
```

---

## Task 6: Confirm job — accept `qris_paid`

**Files:**
- Modify: `hypercoach/app/Jobs/ConfirmPurchaseFromXenditWebhook.php`
- Test: `hypercoach/tests/Feature/Webhooks/ConfirmQrisPurchaseJobTest.php` (new; mirror `tests/Feature/Webhooks/ConfirmPurchaseJobTest.php`)

**Interfaces:**
- Consumes: the stored event payload's top-level `qr_id`, `amount`, `status` (the controller normalized them out of the QR envelope in Task 5); `Purchase.xendit_callback_id` holds the QR id (Task 3).
- Produces: a `qris_paid` event with a matching `qr_id` + amount + `status=SUCCEEDED` confirms the purchase; mismatches / non-success mark the event failed.

- [ ] **Step 1: Write the failing tests** (`hypercoach/tests/Feature/Webhooks/ConfirmQrisPurchaseJobTest.php`, mirrors `ConfirmPurchaseJobTest` — calls the job directly, no HTTP)

```php
<?php

namespace Tests\Feature\Webhooks;

use App\Jobs\ConfirmPurchaseFromXenditWebhook;
use App\Models\Product;
use App\Models\Purchase;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\XenditWebhookEvent;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Illuminate\Support\Facades\Event;
use Tests\TestCase;

class ConfirmQrisPurchaseJobTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;
    private StudentProfile $student;
    private Product $product;

    protected function setUp(): void
    {
        parent::setUp();
        Event::fake(); // suppress purchase-confirmed listeners, exactly like ConfirmPurchaseJobTest

        $this->tenant = Tenant::create([
            'name' => 'Test', 'slug' => 'test-'.uniqid(),
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1', 'payment_account_holder' => 'X',
        ]);
        $this->student = StudentProfile::create([
            'tenant_id' => $this->tenant->id, 'first_name' => 'A', 'last_name' => 'B',
        ]);
        $this->product = Product::create([
            'tenant_id' => $this->tenant->id,
            'name' => 'P', 'type' => 'group_single', 'session_type' => 'group',
            'price' => 80000, 'is_active' => true, 'currency' => 'IDR', 'credit_amount' => 1,
        ]);
    }

    private function makeQrisPurchase(array $overrides = []): Purchase
    {
        $purchase = Purchase::create(array_merge([
            'tenant_id' => $this->tenant->id,
            'student_profile_id' => $this->student->id,
            'product_id' => $this->product->id,
            'status' => 'pending_payment',
            'amount_paid' => 80000,
            'currency' => 'IDR',
            'payment_provider' => 'xendit',
            'payment_method' => 'qris',
            'xendit_callback_id' => 'qr_match',
        ], $overrides));
        $purchase->update(['xendit_external_id' => "hypercoach-PURCHASE-{$purchase->id}"]);

        return $purchase;
    }

    // Payload holds the already-normalized top-level fields the controller lifts
    // out of the QR envelope before persisting the event (Task 5).
    private function makeQrEvent(Purchase $purchase, array $payloadOverrides = []): XenditWebhookEvent
    {
        $externalId = "hypercoach-PURCHASE-{$purchase->id}";

        return XenditWebhookEvent::create([
            'xendit_event_id' => 'evt_'.uniqid(),
            'event_type' => 'qris_paid',
            'xendit_external_id' => $externalId,
            'payload' => array_merge([
                'id' => 'qrpy_'.uniqid(),
                'qr_id' => 'qr_match',
                'reference_id' => $externalId,
                'amount' => 80000,
                'status' => 'SUCCEEDED',
            ], $payloadOverrides),
            'processing_status' => 'pending',
        ]);
    }

    public function test_confirms_pending_purchase_on_valid_qris_paid(): void
    {
        $purchase = $this->makeQrisPurchase();
        $event = $this->makeQrEvent($purchase);

        (new ConfirmPurchaseFromXenditWebhook($event->id))->handle();

        $this->assertEquals('confirmed', $purchase->fresh()->status);
        $this->assertEquals('processed', $event->fresh()->processing_status);
    }

    public function test_qr_id_mismatch_marks_event_failed_without_confirming(): void
    {
        $purchase = $this->makeQrisPurchase(['xendit_callback_id' => 'qr_real']);
        $event = $this->makeQrEvent($purchase, ['qr_id' => 'qr_WRONG']);

        (new ConfirmPurchaseFromXenditWebhook($event->id))->handle();

        $this->assertEquals('pending_payment', $purchase->fresh()->status);
        $this->assertEquals('failed', $event->fresh()->processing_status);
        $this->assertStringContainsString('QR id mismatch', $event->fresh()->error_message);
    }

    public function test_non_success_status_marks_event_failed_without_confirming(): void
    {
        $purchase = $this->makeQrisPurchase();
        $event = $this->makeQrEvent($purchase, ['status' => 'PENDING']);

        (new ConfirmPurchaseFromXenditWebhook($event->id))->handle();

        $this->assertEquals('pending_payment', $purchase->fresh()->status);
        $this->assertEquals('failed', $event->fresh()->processing_status);
        $this->assertStringContainsString('QR non-success status', $event->fresh()->error_message);
    }
}
```

- [ ] **Step 2: Run it — expect FAIL** (`ConfirmPurchaseFromXenditWebhook` rejects non-`va_paid`)

Run: `cd hypercoach && php artisan test --filter=ConfirmQrisPurchaseJobTest`
Expected: FAIL (`test_confirms_…` stays `pending_payment`; event failed "Unsupported event type: qris_paid").

- [ ] **Step 3: Extend the confirm job**

In `hypercoach/app/Jobs/ConfirmPurchaseFromXenditWebhook.php`, `handle()`:

Replace the type guard:

```php
        if ($event->event_type !== 'va_paid') {
            $this->markFailed($event, 'Unsupported event type: '.$event->event_type);
            return;
        }
```

with:

```php
        if (! in_array($event->event_type, ['va_paid', 'qris_paid'], true)) {
            $this->markFailed($event, 'Unsupported event type: '.$event->event_type);
            return;
        }
```

Replace the VA-id verification block:

```php
            // VA ID verification
            $webhookVaId = $payload['callback_virtual_account_id'] ?? null;
            if ($webhookVaId !== $purchase->xendit_callback_id) {
                $this->markFailed($event, "VA id mismatch: expected {$purchase->xendit_callback_id}, got {$webhookVaId}");
                return;
            }
```

with a branch by event type:

```php
            // Provider-id verification (+ QR success-status guard)
            if ($event->event_type === 'va_paid') {
                $webhookVaId = $payload['callback_virtual_account_id'] ?? null;
                if ($webhookVaId !== $purchase->xendit_callback_id) {
                    $this->markFailed($event, "VA id mismatch: expected {$purchase->xendit_callback_id}, got {$webhookVaId}");
                    return;
                }
            } else { // qris_paid
                $status = strtoupper((string) ($payload['status'] ?? ''));
                if (! in_array($status, ['SUCCEEDED', 'COMPLETED'], true)) {
                    $this->markFailed($event, "QR non-success status: {$status}");
                    return;
                }
                $webhookQrId = $payload['qr_id'] ?? null;
                if ($webhookQrId !== $purchase->xendit_callback_id) {
                    $this->markFailed($event, "QR id mismatch: expected {$purchase->xendit_callback_id}, got {$webhookQrId}");
                    return;
                }
            }
```

(The `-PURCHASE-(\d+)` parse and the `amount` verification above this block are unchanged and already read the normalized top-level `amount`.)

- [ ] **Step 4: Run tests — expect PASS** (and no VA-confirm regression)

Run: `cd hypercoach && php artisan test --filter=ConfirmQrisPurchaseJobTest && php artisan test --filter=ConfirmPurchaseJobTest`
Expected: both PASS (the VA confirm test proves the type-guard change didn't break `va_paid`).

- [ ] **Step 5: Commit**

```bash
cd hypercoach && git add app/Jobs/ConfirmPurchaseFromXenditWebhook.php tests/Feature/Webhooks/ConfirmQrisPurchaseJobTest.php
git commit -m "feat(payment): confirm purchases from qris_paid webhook"
```

**Backend milestone:** QRIS create + confirm work end-to-end (unit + feature).

---

## Task 7: FE — `PaymentIntent` model carries `qr_string`

**Files:**
- Modify: `hyperarena/lib/features/payment/data/models/payment_intent.dart`
- Regenerate: `payment_intent.freezed.dart` + `payment_intent.g.dart`
- Test: `hyperarena/test/features/payment/payment_intent_qr_test.dart` (new)

**Interfaces:**
- Produces: `PaymentIntent.qrString` (`@JsonKey(name: 'qr_string') String?`).

- [ ] **Step 1: Write the failing test** (`payment_intent_qr_test.dart`)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';

void main() {
  test('parses qr_string from json', () {
    final intent = PaymentIntent.fromJson(const {
      'purchase_id': 1,
      'status': 'pending_payment',
      'provider': 'automatic',
      'payment_method': 'qris',
      'amount_base': 80000,
      'fee_amount': 5000,
      'amount_total': 85000,
      'qr_string': '000201-QRIS',
    });
    expect(intent.qrString, '000201-QRIS');
  });
}
```

- [ ] **Step 2: Run it — expect FAIL** (`qrString` getter missing)

Run: `cd hyperarena && flutter test test/features/payment/payment_intent_qr_test.dart`
Expected: FAIL (compile error — no `qrString`).

- [ ] **Step 3: Add the field**

In `hyperarena/lib/features/payment/data/models/payment_intent.dart`, add after the `vaBank` line:

```dart
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'qr_string') String? qrString,
```

- [ ] **Step 4: Regenerate + run tests — expect PASS**

Run: `cd hyperarena && dart run build_runner build --delete-conflicting-outputs && flutter test test/features/payment/payment_intent_qr_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
cd hyperarena && git add lib/features/payment/data/models/payment_intent.dart lib/features/payment/data/models/payment_intent.freezed.dart lib/features/payment/data/models/payment_intent.g.dart test/features/payment/payment_intent_qr_test.dart
git commit -m "feat(payment): PaymentIntent model parses qr_string"
```

---

## Task 8: FE — `QrisWaitingScreen` (+ `qr_flutter`)

**Files:**
- Modify: `hyperarena/pubspec.yaml` (add `qr_flutter`)
- Create: `hyperarena/lib/features/payment/presentation/screens/qris_waiting_screen.dart`
- Test: `hyperarena/test/features/payment/qris_waiting_screen_test.dart` (new)

**Interfaces:**
- Consumes: `PaymentIntent.qrString` (Task 7); `purchaseStatusStreamProvider`, `CostBreakdownCard`, `CountdownTimer`, `RefundPolicyCard` (existing).
- Produces: `QrisWaitingScreen({required int purchaseId, required int amount, required PaymentIntent intent, int? sessionId, String? sessionLabel, DateTime? sessionStartAt, String? venueName, String? paymentMethodLabel})`.

- [ ] **Step 1: Add `qr_flutter` to `pubspec.yaml`**

Under `dependencies:`, add (matching the existing `^` style):

```yaml
  qr_flutter: ^4.1.0
```

Run: `cd hyperarena && flutter pub get`
Expected: resolves cleanly.

- [ ] **Step 2: Write the failing widget test** (`qris_waiting_screen_test.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/presentation/screens/qris_waiting_screen.dart';

void main() {
  testWidgets('renders a QR from qrString + shows the amount', (tester) async {
    const intent = PaymentIntent(
      purchaseId: 1, status: 'pending_payment', provider: 'automatic',
      paymentMethod: 'qris', amountBase: 80000, feeAmount: 5000,
      amountTotal: 85000, qrString: '000201-QRIS',
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: QrisWaitingScreen(purchaseId: 1, amount: 85000, intent: intent),
      ),
    ));
    await tester.pump();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.textContaining('Scan'), findsWidgets);
  });
}
```

The QR card sits above the status section, so the `purchaseStatusStreamProvider` stays in its loading state after a single `pump()` (the `statusAsync.when` renders a spinner) and never needs the network. If building it throws in the test harness, override it in the `ProviderScope`: `overrides: [purchaseStatusStreamProvider(1).overrideWith((ref) => const Stream.empty())]`.

- [ ] **Step 3: Run it — expect FAIL** (screen does not exist)

Run: `cd hyperarena && flutter test test/features/payment/qris_waiting_screen_test.dart`
Expected: FAIL (compile error — no `QrisWaitingScreen`).

- [ ] **Step 4: Create `QrisWaitingScreen`** (mirror `va_waiting_screen.dart`; QR card replaces the VA display; QR-specific instructions)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/models/purchase_status.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/widgets/cost_breakdown_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/countdown_timer.dart';
import 'package:hyperarena/features/payment/presentation/widgets/refund_policy_card.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class QrisWaitingScreen extends ConsumerStatefulWidget {
  const QrisWaitingScreen({
    super.key,
    required this.purchaseId,
    required this.amount,
    required this.intent,
    this.sessionId,
    this.sessionLabel,
    this.sessionStartAt,
    this.venueName,
    this.paymentMethodLabel,
  });

  final int purchaseId;
  final int amount;
  final PaymentIntent intent;
  final int? sessionId;
  final String? sessionLabel;
  final DateTime? sessionStartAt;
  final String? venueName;
  final String? paymentMethodLabel;

  @override
  ConsumerState<QrisWaitingScreen> createState() => _QrisWaitingScreenState();
}

class _QrisWaitingScreenState extends ConsumerState<QrisWaitingScreen> {
  bool _localExpired = false;

  Map<String, dynamic> get _navExtra => {
        'sessionId': widget.sessionId,
        'sessionLabel': widget.sessionLabel,
        'sessionStartAt': widget.sessionStartAt,
        'venueName': widget.venueName,
        'amount': widget.amount,
        'paymentMethodLabel': widget.paymentMethodLabel,
      };

  void _navigateToExpiredSuccess() {
    if (!mounted) return;
    if (widget.sessionId != null) {
      ref.invalidate(marketplaceSessionDetailProvider(widget.sessionId.toString()));
    }
    context.go('/payment/success/${widget.purchaseId}?status=expired', extra: _navExtra);
  }

  @override
  void initState() {
    super.initState();
    final alreadyExpired = widget.intent.expiresAt != null &&
        widget.intent.expiresAt!.isBefore(DateTime.now());
    if (alreadyExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _localExpired = true;
          _navigateToExpiredSuccess();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(purchaseStatusStreamProvider(widget.purchaseId));

    ref.listen<AsyncValue<PurchaseStatus>>(
      purchaseStatusStreamProvider(widget.purchaseId),
      (prev, next) {
        next.whenData((status) {
          if (status.status != 'confirmed' && status.status != 'expired') return;
          if (status.status == 'expired') {
            _navigateToExpiredSuccess();
          } else {
            context.go('/payment/success/${widget.purchaseId}?status=${status.status}', extra: _navExtra);
          }
        });
      },
    );

    final qr = widget.intent.qrString;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Pembayaran'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (qr == null || qr.isEmpty)
              _MissingQrCard(onHome: () => context.go(AppRoutes.home(UserRole.player)))
            else
              _QrCard(qrString: qr, amount: widget.amount),
            const SizedBox(height: 16),
            CostBreakdownCard(
              itemLabel: widget.sessionLabel ?? 'Pembayaran Sesi',
              basePrice: widget.intent.amountBase,
              adminFee: widget.intent.feeAmount,
            ),
            const SizedBox(height: 12),
            const RefundPolicyCard(),
            const SizedBox(height: 16),
            if (widget.intent.expiresAt != null)
              Center(
                child: CountdownTimer(
                  expiresAt: widget.intent.expiresAt!,
                  onExpired: () {
                    if (!_localExpired) {
                      setState(() => _localExpired = true);
                      _navigateToExpiredSuccess();
                    }
                  },
                ),
              ),
            const SizedBox(height: 24),
            const _QrisInstructionsBlock(),
            const SizedBox(height: 24),
            statusAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Cek status: $e',
                  style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              data: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _PulseDot(),
                  SizedBox(width: 8),
                  Text('Menunggu pembayaran… terkonfirmasi otomatis'),
                ],
              ),
            ),
            if (!_localExpired) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go(AppRoutes.home(UserRole.player)),
                child: const Text('Bayar Nanti'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  const _QrCard({required this.qrString, required this.amount});
  final String qrString;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Text('QRIS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          QrImageView(data: qrString, version: QrVersions.auto, size: 240),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(amount, 'IDR'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          const Text(
            'Scan QR dengan aplikasi e-wallet atau mobile banking',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MissingQrCard extends StatelessWidget {
  const _MissingQrCard({required this.onHome});
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text('QR tidak tersedia. Coba buat pembayaran lagi.',
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onHome, child: const Text('Kembali')),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();
  @override
  Widget build(BuildContext context) => Container(
        width: 10, height: 10,
        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      );
}

class _QrisInstructionsBlock extends StatelessWidget {
  const _QrisInstructionsBlock();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cara Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('1. Buka aplikasi e-wallet atau mobile banking Anda'),
          Text('2. Pilih menu Scan / QRIS / Bayar'),
          Text('3. Scan QR di atas'),
          Text('4. Konfirmasi jumlah pembayaran'),
          Text('5. Selesaikan transaksi — pembayaran akan terkonfirmasi otomatis'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Run tests — expect PASS**

Run: `cd hyperarena && flutter test test/features/payment/qris_waiting_screen_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
cd hyperarena && git add pubspec.yaml pubspec.lock lib/features/payment/presentation/screens/qris_waiting_screen.dart test/features/payment/qris_waiting_screen_test.dart
git commit -m "feat(payment): QrisWaitingScreen renders the QR + polls status"
```

(Note: `pubspec.lock` is gitignored in this repo — if `git add pubspec.lock` errors, omit it; do not force-add.)

---

## Task 9: FE — route + checkout dispatch

**Files:**
- Modify: `hyperarena/lib/routing/app_router.dart`
- Modify: `hyperarena/lib/features/payment/presentation/screens/checkout_screen.dart`
- Test: `hyperarena/test/features/payment/checkout_routing_test.dart` (new)

**Interfaces:**
- Consumes: `QrisWaitingScreen` (Task 8).
- Produces: route `/payment/qris/:purchaseId`; `CheckoutScreen._submit` sends `qris` intents there.

- [ ] **Step 1: Write the failing test** (`checkout_routing_test.dart`)

A focused unit test of the dispatch decision. Extract the target-path decision into a testable pure function on `_CheckoutScreenState` (or a top-level helper) and assert it:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/payment/presentation/screens/checkout_screen.dart';

void main() {
  test('qris routes to /payment/qris, va to /payment/va, manual to /payment/manual', () {
    expect(paymentTargetPath(provider: 'automatic', method: 'qris', id: 7), '/payment/qris/7');
    expect(paymentTargetPath(provider: 'automatic', method: 'va_bca', id: 7), '/payment/va/7');
    expect(paymentTargetPath(provider: 'manual', method: 'manual', id: 7), '/payment/manual/7');
  });
}
```

- [ ] **Step 2: Run it — expect FAIL** (`paymentTargetPath` undefined)

Run: `cd hyperarena && flutter test test/features/payment/checkout_routing_test.dart`
Expected: FAIL (compile error).

- [ ] **Step 3: Add `paymentTargetPath` + use it in `_submit`**

In `hyperarena/lib/features/payment/presentation/screens/checkout_screen.dart`, add a top-level helper (above the `CheckoutScreen` class):

```dart
/// Chooses the post-create payment route by provider/method.
String paymentTargetPath({
  required String provider,
  required String method,
  required int id,
}) {
  if (provider == 'manual') return '/payment/manual/$id';
  if (method == 'qris') return '/payment/qris/$id';
  return '/payment/va/$id';
}
```

Then rewrite the `_submit` navigation block (currently the `if (intent.provider == 'manual') … else …` at the end of `_submit`) to:

```dart
      final target = paymentTargetPath(
        provider: intent.provider,
        method: intent.paymentMethod,
        id: intent.purchaseId,
      );
      if (intent.provider == 'manual') {
        context.go(target, extra: {
          ...sharedExtra,
          'bankDetails': intent.bankDetails,
          'proofUploadUrl': intent.proofUploadUrl,
        });
      } else {
        context.go(target, extra: {...sharedExtra, 'intent': intent});
      }
```

- [ ] **Step 4: Add the route in `app_router.dart`**

In `hyperarena/lib/routing/app_router.dart`, directly after the `/payment/va/:purchaseId` `GoRoute` block, add (import `QrisWaitingScreen` at the top of the file alongside the other payment-screen imports):

```dart
      GoRoute(
        path: '/payment/qris/:purchaseId',
        builder: (ctx, state) {
          final extra = state.extra as Map<String, dynamic>;
          return QrisWaitingScreen(
            purchaseId: int.parse(state.pathParameters['purchaseId']!),
            amount: extra['amount'] as int,
            intent: extra['intent'] as PaymentIntent,
            sessionId: extra['sessionId'] as int?,
            sessionLabel: extra['sessionLabel'] as String?,
            sessionStartAt: extra['sessionStartAt'] as DateTime?,
            venueName: extra['venueName'] as String?,
            paymentMethodLabel: extra['paymentMethodLabel'] as String?,
          );
        },
      ),
```

- [ ] **Step 5: Run tests + analyze — expect PASS/clean**

Run: `cd hyperarena && flutter test test/features/payment/ && flutter analyze lib/features/payment lib/routing/app_router.dart`
Expected: tests PASS, analyze clean.

- [ ] **Step 6: Commit**

```bash
cd hyperarena && git add lib/routing/app_router.dart lib/features/payment/presentation/screens/checkout_screen.dart test/features/payment/checkout_routing_test.dart
git commit -m "feat(payment): route qris checkout to QrisWaitingScreen"
```

**Frontend milestone:** selecting QRIS renders a scannable QR and auto-confirms on payment.

---

## Runbook: register the Xendit QR-paid callback (ops, one-time per environment)

Not code. For the live webhook to arrive, register the account's **QR-paid** callback URL to the same endpoint the FVA callback uses:

- **Dashboard:** Settings → Developers → Webhooks → **QR Code** → set the URL to `https://<public-tunnel>/api/v1/webhooks/xendit/va`.
- **Or API** (test mode), same pattern as the FVA callback registration:
  ```bash
  curl -s -u "$XENDIT_TEST_KEY:" -X POST "https://api.xendit.co/callback_urls/qr_code" \
    -H "Content-Type: application/json" \
    -d '{"url":"https://<public-tunnel>/api/v1/webhooks/xendit/va"}'
  ```
  (Confirm the exact callback-type enum — `qr_code` — from the 400/200 response, mirroring how `fva_paid` was discovered.)

---

## Live end-to-end verification

On both emulators against local Herd (`QUEUE_CONNECTION=sync`, no worker):

1. Log in as a member of a tenant with `qris_enabled`; open a paid session → checkout → pick **QRIS** → **Lanjut Bayar**.
2. `QrisWaitingScreen` renders a scannable QR + amount + countdown.
3. **Capture the real webhook payload** (Task 5's temporary log) on the first run, confirm the `data` shape, remove the log.
4. Simulate the QR payment via the Xendit test API (QR simulate endpoint) → webhook lands on the tunnel → confirmation runs inline → the status stream flips to `confirmed` → screen auto-navigates to the success screen.
5. Repeat a VA payment to confirm no regression.

---

## Final verification (whole feature)
- BE: `cd hypercoach && php artisan test tests/Feature/Payment tests/Feature/Webhooks` green (VA + QRIS: gateway, create-purchase, webhook normalize, confirm job).
- FE: `cd hyperarena && flutter analyze` clean; `flutter test test/features/payment/` green.
- Live e2e above passes on Android + iOS.
