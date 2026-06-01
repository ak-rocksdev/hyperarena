# Payment P2 — BE Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add per-tenant payment-method settings + revamped manual flow + idempotent purchase creation, behind a generic `PaymentGateway` abstraction. No Xendit yet (P4a).

**Architecture:** Laravel 12 service layer. New `TenantPaymentSettings` model + `PaymentGateway` interface with `ManualPaymentProvider` impl. Existing `PurchaseService` orchestrates; controllers thin. All API responses use generic terms (`"manual"` / `"automatic"`) — `xendit_*` only appears in DB columns + service-internal code (added in P4a).

**Tech Stack:** Laravel 12, MySQL, Spatie\ActivityLog, Spatie\Permission, PHPUnit Feature tests with `LazilyRefreshDatabase`, Laravel Pint formatter.

**Repo:** `C:\laragon\www\hypercoach`. All file paths in tasks below are relative to that repo.

---

## File Structure

| File | Responsibility |
|---|---|
| `database/migrations/YYYY_MM_DD_HHMMSS_create_tenant_payment_settings_table.php` | Tenant settings schema + backfill for existing tenants |
| `database/migrations/YYYY_MM_DD_HHMMSS_add_payment_v1_fields_to_purchases.php` | Add 9 nullable columns to purchases for payment provider/method/idempotency |
| `app/Models/TenantPaymentSettings.php` | Eloquent model; `BelongsToTenant` trait; `va_banks` as `array` cast |
| `app/Models/Tenant.php` | Add `paymentSettings()` HasOne relation |
| `app/Models/Purchase.php` | Add new columns to `$fillable` + `$casts` (expires_at as datetime) |
| `app/Support/PaymentIntent.php` | Final readonly value object returned by `PaymentGateway::createPayment()` |
| `app/Contracts/PaymentGateway.php` | Interface — `createPayment`, `getStatus`. Future-proof for XenditGateway impl. |
| `app/Services/Payment/ManualPaymentProvider.php` | Implements `PaymentGateway` for `manual` method. Returns bank details + proof_upload_url. |
| `app/Services/Payment/PaymentGatewayFactory.php` | Resolves method string → provider impl (`manual` → ManualPaymentProvider; `va_*` → throws "not yet implemented" until P4a) |
| `app/Services/TenantPaymentSettingsService.php` | Read enabled methods for tenant (resolution rules per spec §6.1); write toggle |
| `app/Http/Controllers/Marketplace/PaymentMethodController.php` | `GET /marketplace/tenants/{slug}/payment-methods` |
| `app/Http/Controllers/Marketplace/MarketplacePurchaseController.php` | `POST /marketplace/purchases` (Idempotency-Key aware); `POST /purchases/{id}/proof`; `GET /purchases/{id}/status` |
| `app/Http/Controllers/Admin/PaymentSettingsController.php` | `GET` + `PATCH /admin/tenant/payment-settings` |
| `app/Http/Middleware/IdempotencyKey.php` | Reads `Idempotency-Key` header, attaches to request |
| `app/Http/Requests/Admin/UpdatePaymentSettingsRequest.php` | Validation: if va_enabled, va_banks subset; if manual_enabled, tenant has bank details |
| `app/Http/Requests/Marketplace/CreatePurchaseRequest.php` | Validation: product_id, session_id, payment_method (enum from enabled methods) |
| `routes/api.php` | Wire 4 new endpoints (3 marketplace + 1 admin group) |
| `tests/Feature/Payment/TenantPaymentSettingsTest.php` | Service unit + admin endpoint feature tests |
| `tests/Feature/Payment/MarketplacePaymentMethodsTest.php` | Read endpoint tests (toggle resolution, missing tenant, missing bank details) |
| `tests/Feature/Payment/MarketplaceCreatePurchaseManualTest.php` | Manual purchase create + idempotency + proof upload + status poll |
| `tests/Feature/Payment/IdempotencyKeyTest.php` | Duplicate POST returns same purchase row; mismatched body → 409 |

Existing files **not modified** in P2: `app/Services/PurchaseService.php` (stays as-is for backward compat — P2 wraps it from controller; refactor in P4a once both providers ready).

---

## Task 1: Create `tenant_payment_settings` table + model + backfill

**Files:**
- Create: `database/migrations/YYYY_MM_DD_HHMMSS_create_tenant_payment_settings_table.php` (artisan generates timestamp)
- Create: `app/Models/TenantPaymentSettings.php`
- Modify: `app/Models/Tenant.php` (add relation)
- Test: `tests/Feature/Payment/TenantPaymentSettingsTest.php` (model existence + relation)

- [ ] **Step 1: Generate migration file**

Run from repo root:
```bash
cd /c/laragon/www/hypercoach
php artisan make:migration create_tenant_payment_settings_table
```
Expected: file created at `database/migrations/YYYY_MM_DD_HHMMSS_create_tenant_payment_settings_table.php`. Note the exact filename for next step.

- [ ] **Step 2: Write migration content**

Replace migration body with:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('tenant_payment_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tenant_id')->unique()->constrained('tenants')->cascadeOnDelete();
            $table->boolean('manual_enabled')->default(true);
            $table->boolean('va_enabled')->default(false);
            $table->boolean('qris_enabled')->default(false);
            $table->boolean('ewallet_enabled')->default(false);
            $table->json('va_banks')->nullable(); // null until va_enabled; default in app layer
            $table->timestamps();
        });

        // Backfill one row per existing tenant with defaults (manual on, rest off)
        DB::table('tenants')->orderBy('id')->lazyById(100)->each(function ($tenant) {
            DB::table('tenant_payment_settings')->insert([
                'tenant_id' => $tenant->id,
                'manual_enabled' => true,
                'va_enabled' => false,
                'qris_enabled' => false,
                'ewallet_enabled' => false,
                'va_banks' => json_encode(['BCA', 'MANDIRI', 'BRI', 'BNI']),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tenant_payment_settings');
    }
};
```

- [ ] **Step 3: Create Model**

Create `app/Models/TenantPaymentSettings.php`:
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TenantPaymentSettings extends Model
{
    protected $fillable = [
        'tenant_id',
        'manual_enabled',
        'va_enabled',
        'qris_enabled',
        'ewallet_enabled',
        'va_banks',
    ];

    protected $casts = [
        'manual_enabled' => 'boolean',
        'va_enabled' => 'boolean',
        'qris_enabled' => 'boolean',
        'ewallet_enabled' => 'boolean',
        'va_banks' => 'array',
    ];

    public function tenant(): BelongsTo
    {
        return $this->belongsTo(Tenant::class);
    }
}
```

- [ ] **Step 4: Add Tenant relation**

In `app/Models/Tenant.php`, add inside the class body (place alphabetically near other relations):
```php
public function paymentSettings(): \Illuminate\Database\Eloquent\Relations\HasOne
{
    return $this->hasOne(TenantPaymentSettings::class);
}
```

- [ ] **Step 5: Write failing test**

Create `tests/Feature/Payment/TenantPaymentSettingsTest.php`:
```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Tenant;
use App\Models\TenantPaymentSettings;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class TenantPaymentSettingsTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_settings_table_seeded_for_existing_tenant(): void
    {
        $tenant = Tenant::create([
            'name' => 'Test Tenant',
            'slug' => 'test-tenant-' . uniqid(),
            'country' => 'ID',
            'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR',
            'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '123',
            'payment_account_holder' => 'PT Test',
        ]);

        // Settings row auto-created lazily by app — for now create explicitly
        TenantPaymentSettings::create([
            'tenant_id' => $tenant->id,
            'manual_enabled' => true,
            'va_banks' => ['BCA', 'MANDIRI', 'BRI', 'BNI'],
        ]);

        $tenant->refresh();
        $settings = $tenant->paymentSettings;

        $this->assertNotNull($settings);
        $this->assertTrue($settings->manual_enabled);
        $this->assertFalse($settings->va_enabled);
        $this->assertEquals(['BCA', 'MANDIRI', 'BRI', 'BNI'], $settings->va_banks);
    }
}
```

- [ ] **Step 6: Run test, expect failure (table missing)**

```bash
cd /c/laragon/www/hypercoach
php artisan test tests/Feature/Payment/TenantPaymentSettingsTest.php
```
Expected: FAIL because migration hasn't run on test DB.

- [ ] **Step 7: Run migration on test DB**

```bash
php artisan migrate --env=testing
```
Expected: migration runs, table created.

- [ ] **Step 8: Re-run test, expect pass**

```bash
php artisan test tests/Feature/Payment/TenantPaymentSettingsTest.php
```
Expected: PASS (1 test, 4 assertions).

- [ ] **Step 9: Lint + commit**

```bash
./vendor/bin/pint app/Models/TenantPaymentSettings.php app/Models/Tenant.php database/migrations/ tests/Feature/Payment/TenantPaymentSettingsTest.php
git add database/migrations/ app/Models/TenantPaymentSettings.php app/Models/Tenant.php tests/Feature/Payment/TenantPaymentSettingsTest.php
git commit -m "Payment P2: add tenant_payment_settings table + model + Tenant relation"
```

---

## Task 2: Extend `purchases` with payment provider/method/idempotency columns

**Files:**
- Create: `database/migrations/YYYY_MM_DD_HHMMSS_add_payment_v1_fields_to_purchases.php`
- Modify: `app/Models/Purchase.php`
- Test: `tests/Feature/Payment/PurchaseExtensionsTest.php`

- [ ] **Step 1: Generate migration**

```bash
php artisan make:migration add_payment_v1_fields_to_purchases
```

- [ ] **Step 2: Write migration content**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->enum('payment_provider', ['manual', 'xendit'])->nullable()->after('status');
            $table->string('payment_method', 32)->nullable()->after('payment_provider');
            $table->char('idempotency_key', 36)->nullable()->after('payment_method');
            $table->string('xendit_callback_id', 64)->nullable()->after('idempotency_key');
            $table->string('xendit_external_id', 64)->nullable()->after('xendit_callback_id');
            $table->string('xendit_va_number', 32)->nullable()->after('xendit_external_id');
            $table->string('xendit_va_bank', 16)->nullable()->after('xendit_va_number');
            $table->unsignedInteger('xendit_fee_amount')->nullable()->default(0)->after('xendit_va_bank');
            $table->dateTime('xendit_expires_at')->nullable()->after('xendit_fee_amount');

            $table->unique('idempotency_key', 'uniq_purchases_idempotency_key');
            $table->unique('xendit_external_id', 'uniq_purchases_xendit_external_id');
        });
    }

    public function down(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->dropUnique('uniq_purchases_idempotency_key');
            $table->dropUnique('uniq_purchases_xendit_external_id');
            $table->dropColumn([
                'payment_provider',
                'payment_method',
                'idempotency_key',
                'xendit_callback_id',
                'xendit_external_id',
                'xendit_va_number',
                'xendit_va_bank',
                'xendit_fee_amount',
                'xendit_expires_at',
            ]);
        });
    }
};
```

- [ ] **Step 3: Add columns to Purchase model `$fillable` + `$casts`**

In `app/Models/Purchase.php`, locate `$fillable` array and append the 9 new column names. Locate `$casts` and add:
```php
'xendit_expires_at' => 'datetime',
'xendit_fee_amount' => 'integer',
```

- [ ] **Step 4: Write failing test**

Create `tests/Feature/Payment/PurchaseExtensionsTest.php`:
```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Purchase;
use App\Models\StudentProfile;
use App\Models\Tenant;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class PurchaseExtensionsTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_purchase_accepts_payment_provider_and_idempotency_key(): void
    {
        $tenant = Tenant::factory()->create();
        $student = StudentProfile::factory()->create(['tenant_id' => $tenant->id]);

        $purchase = Purchase::create([
            'tenant_id' => $tenant->id,
            'student_profile_id' => $student->id,
            'status' => 'pending_payment',
            'amount_paid' => 175000,
            'currency' => 'IDR',
            'payment_provider' => 'manual',
            'payment_method' => 'manual',
            'idempotency_key' => '550e8400-e29b-41d4-a716-446655440000',
        ]);

        $this->assertEquals('manual', $purchase->payment_provider);
        $this->assertEquals('550e8400-e29b-41d4-a716-446655440000', $purchase->idempotency_key);
    }

    public function test_idempotency_key_is_unique(): void
    {
        $tenant = Tenant::factory()->create();
        $student = StudentProfile::factory()->create(['tenant_id' => $tenant->id]);

        Purchase::create([
            'tenant_id' => $tenant->id,
            'student_profile_id' => $student->id,
            'status' => 'pending_payment',
            'amount_paid' => 175000,
            'currency' => 'IDR',
            'idempotency_key' => 'unique-key-1',
        ]);

        $this->expectException(\Illuminate\Database\QueryException::class);

        Purchase::create([
            'tenant_id' => $tenant->id,
            'student_profile_id' => $student->id,
            'status' => 'pending_payment',
            'amount_paid' => 175000,
            'currency' => 'IDR',
            'idempotency_key' => 'unique-key-1', // duplicate
        ]);
    }
}
```

(Note: if `Tenant::factory()` or `StudentProfile::factory()` don't exist, check the existing test files for the manual creation pattern and use that.)

- [ ] **Step 5: Run test, expect failure**

```bash
php artisan test tests/Feature/Payment/PurchaseExtensionsTest.php
```
Expected: FAIL (columns missing).

- [ ] **Step 6: Run migration**

```bash
php artisan migrate --env=testing
```

- [ ] **Step 7: Re-run test, expect pass**

```bash
php artisan test tests/Feature/Payment/PurchaseExtensionsTest.php
```
Expected: 2 tests pass.

- [ ] **Step 8: Lint + commit**

```bash
./vendor/bin/pint database/migrations/ app/Models/Purchase.php tests/Feature/Payment/PurchaseExtensionsTest.php
git add database/migrations/ app/Models/Purchase.php tests/Feature/Payment/PurchaseExtensionsTest.php
git commit -m "Payment P2: add payment_provider/method/idempotency columns to purchases"
```

---

## Task 3: PaymentIntent value object + PaymentGateway interface

**Files:**
- Create: `app/Support/PaymentIntent.php`
- Create: `app/Contracts/PaymentGateway.php`
- Test: `tests/Unit/Payment/PaymentIntentTest.php`

- [ ] **Step 1: Create PaymentIntent value object**

Create `app/Support/PaymentIntent.php`:
```php
<?php

namespace App\Support;

use Carbon\CarbonInterface;

final readonly class PaymentIntent
{
    /**
     * Generic payment intent returned by PaymentGateway::createPayment().
     * Mobile/web never sees internal provider names — `providerLabel` maps
     * to 'manual' or 'automatic' for client-facing serialization.
     *
     * @param  array<string,mixed>|null  $bankDetails
     */
    public function __construct(
        public string $providerLabel,    // 'manual' | 'automatic'
        public string $methodKey,        // 'manual' | 'va_bca' | 'va_mandiri' | ...
        public int $baseAmount,
        public int $feeAmount,
        public int $totalAmount,
        public ?string $vaNumber = null,
        public ?string $vaBank = null,
        public ?CarbonInterface $expiresAt = null,
        public ?array $bankDetails = null,
        public ?string $proofUploadUrl = null,
    ) {}

    public function toArray(): array
    {
        return [
            'provider' => $this->providerLabel,
            'payment_method' => $this->methodKey,
            'amount_base' => $this->baseAmount,
            'fee_amount' => $this->feeAmount,
            'amount_total' => $this->totalAmount,
            'va_number' => $this->vaNumber,
            'va_bank' => $this->vaBank,
            'expires_at' => $this->expiresAt?->toIso8601String(),
            'bank_details' => $this->bankDetails,
            'proof_upload_url' => $this->proofUploadUrl,
        ];
    }
}
```

- [ ] **Step 2: Create PaymentGateway interface**

Create `app/Contracts/PaymentGateway.php`:
```php
<?php

namespace App\Contracts;

use App\Models\Purchase;
use App\Support\PaymentIntent;

interface PaymentGateway
{
    /**
     * Create a payment intent for the given purchase + method. Provider-
     * specific side effects (e.g., calling Xendit) happen inside.
     */
    public function createPayment(Purchase $purchase, string $method): PaymentIntent;

    /**
     * Read current external status of the purchase. For manual, just
     * returns the local purchase status (no external call).
     */
    public function getStatus(Purchase $purchase): string;
}
```

- [ ] **Step 3: Write unit test for PaymentIntent**

Create `tests/Unit/Payment/PaymentIntentTest.php`:
```php
<?php

namespace Tests\Unit\Payment;

use App\Support\PaymentIntent;
use Carbon\Carbon;
use PHPUnit\Framework\TestCase;

class PaymentIntentTest extends TestCase
{
    public function test_serializes_to_array_with_generic_keys(): void
    {
        $intent = new PaymentIntent(
            providerLabel: 'automatic',
            methodKey: 'va_bca',
            baseAmount: 175000,
            feeAmount: 4000,
            totalAmount: 179000,
            vaNumber: '8808912345678',
            vaBank: 'BCA',
            expiresAt: Carbon::parse('2026-06-02T23:00:00+07:00'),
        );

        $array = $intent->toArray();

        // No xendit_* keys should leak
        foreach (array_keys($array) as $key) {
            $this->assertStringNotContainsString('xendit', $key);
        }
        $this->assertEquals('automatic', $array['provider']);
        $this->assertEquals('va_bca', $array['payment_method']);
        $this->assertEquals(179000, $array['amount_total']);
        $this->assertEquals('8808912345678', $array['va_number']);
    }

    public function test_manual_intent_has_bank_details_no_va(): void
    {
        $intent = new PaymentIntent(
            providerLabel: 'manual',
            methodKey: 'manual',
            baseAmount: 175000,
            feeAmount: 0,
            totalAmount: 175000,
            bankDetails: [
                'bank_name' => 'BCA',
                'account_number' => '1234567890',
                'account_holder' => 'Petenis Kelana',
            ],
            proofUploadUrl: '/api/v1/marketplace/purchases/30/proof',
        );

        $array = $intent->toArray();

        $this->assertNull($array['va_number']);
        $this->assertEquals('BCA', $array['bank_details']['bank_name']);
        $this->assertStringContainsString('/proof', $array['proof_upload_url']);
    }
}
```

- [ ] **Step 4: Run test, expect pass (pure value-object, no other deps)**

```bash
php artisan test tests/Unit/Payment/PaymentIntentTest.php
```
Expected: 2 tests pass.

- [ ] **Step 5: Lint + commit**

```bash
./vendor/bin/pint app/Support/PaymentIntent.php app/Contracts/PaymentGateway.php tests/Unit/Payment/PaymentIntentTest.php
git add app/Support/PaymentIntent.php app/Contracts/PaymentGateway.php tests/Unit/Payment/PaymentIntentTest.php
git commit -m "Payment P2: PaymentIntent value object + PaymentGateway interface"
```

---

## Task 4: `ManualPaymentProvider`

**Files:**
- Create: `app/Services/Payment/ManualPaymentProvider.php`
- Test: `tests/Feature/Payment/ManualPaymentProviderTest.php`

- [ ] **Step 1: Write failing test**

Create `tests/Feature/Payment/ManualPaymentProviderTest.php`:
```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Purchase;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Services\Payment\ManualPaymentProvider;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class ManualPaymentProviderTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_creates_manual_intent_with_tenant_bank_details(): void
    {
        $tenant = Tenant::create([
            'name' => 'Test',
            'slug' => 'test-' . uniqid(),
            'country' => 'ID',
            'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR',
            'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'Petenis Kelana',
        ]);

        $student = StudentProfile::create([
            'tenant_id' => $tenant->id,
            'first_name' => 'Test',
            'last_name' => 'User',
        ]);

        $purchase = Purchase::create([
            'tenant_id' => $tenant->id,
            'student_profile_id' => $student->id,
            'status' => 'pending_payment',
            'amount_paid' => 175000,
            'currency' => 'IDR',
        ]);

        $provider = app(ManualPaymentProvider::class);
        $intent = $provider->createPayment($purchase, 'manual');

        $this->assertEquals('manual', $intent->providerLabel);
        $this->assertEquals(0, $intent->feeAmount);
        $this->assertEquals(175000, $intent->totalAmount);
        $this->assertEquals('BCA', $intent->bankDetails['bank_name']);
        $this->assertEquals('1234567890', $intent->bankDetails['account_number']);
        $this->assertStringContainsString("/purchases/{$purchase->id}/proof", $intent->proofUploadUrl);
    }
}
```

- [ ] **Step 2: Run test, expect failure (class missing)**

```bash
php artisan test tests/Feature/Payment/ManualPaymentProviderTest.php
```
Expected: FAIL "ManualPaymentProvider does not exist".

- [ ] **Step 3: Create ManualPaymentProvider**

Create `app/Services/Payment/ManualPaymentProvider.php`:
```php
<?php

namespace App\Services\Payment;

use App\Contracts\PaymentGateway;
use App\Models\Purchase;
use App\Support\PaymentIntent;

class ManualPaymentProvider implements PaymentGateway
{
    public function createPayment(Purchase $purchase, string $method): PaymentIntent
    {
        if ($method !== 'manual') {
            throw new \InvalidArgumentException(
                "ManualPaymentProvider only handles 'manual' method, got: {$method}"
            );
        }

        $tenant = $purchase->tenant;

        $purchase->update([
            'payment_provider' => 'manual',
            'payment_method' => 'manual',
            // Manual flow: no fee, totalAmount == amount_paid (already set)
        ]);

        return new PaymentIntent(
            providerLabel: 'manual',
            methodKey: 'manual',
            baseAmount: $purchase->amount_paid,
            feeAmount: 0,
            totalAmount: $purchase->amount_paid,
            bankDetails: [
                'bank_name' => $tenant->payment_bank_name,
                'account_number' => $tenant->payment_account_number,
                'account_holder' => $tenant->payment_account_holder,
            ],
            proofUploadUrl: "/api/v1/marketplace/purchases/{$purchase->id}/proof",
        );
    }

    public function getStatus(Purchase $purchase): string
    {
        // Manual: no external call, return local status
        return $purchase->status;
    }
}
```

- [ ] **Step 4: Re-run test, expect pass**

```bash
php artisan test tests/Feature/Payment/ManualPaymentProviderTest.php
```
Expected: 1 test passes, 5+ assertions.

- [ ] **Step 5: Lint + commit**

```bash
./vendor/bin/pint app/Services/Payment/ManualPaymentProvider.php tests/Feature/Payment/ManualPaymentProviderTest.php
git add app/Services/Payment/ManualPaymentProvider.php tests/Feature/Payment/ManualPaymentProviderTest.php
git commit -m "Payment P2: ManualPaymentProvider with bank-details + proof-upload intent"
```

---

## Task 5: `PaymentGatewayFactory` for method-to-provider resolution

**Files:**
- Create: `app/Services/Payment/PaymentGatewayFactory.php`
- Test: `tests/Feature/Payment/PaymentGatewayFactoryTest.php`

- [ ] **Step 1: Write failing test**

```php
<?php

namespace Tests\Feature\Payment;

use App\Services\Payment\ManualPaymentProvider;
use App\Services\Payment\PaymentGatewayFactory;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class PaymentGatewayFactoryTest extends TestCase
{
    use LazilyRefreshDatabase;

    public function test_resolves_manual_method_to_manual_provider(): void
    {
        $factory = app(PaymentGatewayFactory::class);
        $provider = $factory->forMethod('manual');

        $this->assertInstanceOf(ManualPaymentProvider::class, $provider);
    }

    public function test_throws_for_va_method_until_p4a(): void
    {
        $factory = app(PaymentGatewayFactory::class);

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('not yet available');

        $factory->forMethod('va_bca');
    }

    public function test_throws_for_unknown_method(): void
    {
        $factory = app(PaymentGatewayFactory::class);

        $this->expectException(\InvalidArgumentException::class);

        $factory->forMethod('unknown_method');
    }
}
```

- [ ] **Step 2: Create factory**

```php
<?php

namespace App\Services\Payment;

use App\Contracts\PaymentGateway;

class PaymentGatewayFactory
{
    public function __construct(
        private readonly ManualPaymentProvider $manual,
        // XenditGateway $xendit — injected in P4a
    ) {}

    public function forMethod(string $method): PaymentGateway
    {
        return match (true) {
            $method === 'manual' => $this->manual,
            str_starts_with($method, 'va_'),
            $method === 'qris',
            str_starts_with($method, 'ewallet_') => throw new \RuntimeException(
                "Automatic payment method '{$method}' not yet available — Xendit integration lands in P4a."
            ),
            default => throw new \InvalidArgumentException("Unknown payment method: {$method}"),
        };
    }
}
```

- [ ] **Step 3: Run tests, expect pass**

```bash
php artisan test tests/Feature/Payment/PaymentGatewayFactoryTest.php
```
Expected: 3 tests pass.

- [ ] **Step 4: Lint + commit**

```bash
./vendor/bin/pint app/Services/Payment/PaymentGatewayFactory.php tests/Feature/Payment/PaymentGatewayFactoryTest.php
git add app/Services/Payment/PaymentGatewayFactory.php tests/Feature/Payment/PaymentGatewayFactoryTest.php
git commit -m "Payment P2: PaymentGatewayFactory routes method to provider (manual only in P2)"
```

---

## Task 6: `TenantPaymentSettingsService` (read enabled methods + write toggles)

**Files:**
- Create: `app/Services/TenantPaymentSettingsService.php`
- Test: `tests/Feature/Payment/TenantPaymentSettingsServiceTest.php`

- [ ] **Step 1: Write failing test**

```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Tenant;
use App\Models\TenantPaymentSettings;
use App\Services\TenantPaymentSettingsService;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class TenantPaymentSettingsServiceTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function makeTenant(array $overrides = []): Tenant
    {
        return Tenant::create(array_merge([
            'name' => 'Test ' . uniqid(),
            'slug' => 'test-' . uniqid(),
            'country' => 'ID',
            'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR',
            'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'PT Test',
        ], $overrides));
    }

    public function test_lazy_creates_default_settings_if_missing(): void
    {
        $tenant = $this->makeTenant();
        $tenant->paymentSettings()->delete(); // ensure missing

        $service = app(TenantPaymentSettingsService::class);
        $methods = $service->availableMethods($tenant);

        $this->assertNotNull($tenant->fresh()->paymentSettings);
        $this->assertCount(1, $methods);
        $this->assertEquals('manual', $methods[0]['key']);
    }

    public function test_returns_only_manual_when_va_disabled(): void
    {
        $tenant = $this->makeTenant();
        TenantPaymentSettings::updateOrCreate(
            ['tenant_id' => $tenant->id],
            ['manual_enabled' => true, 'va_enabled' => false]
        );

        $methods = app(TenantPaymentSettingsService::class)->availableMethods($tenant);

        $keys = array_column($methods, 'key');
        $this->assertEquals(['manual'], $keys);
    }

    public function test_returns_va_methods_when_va_enabled_and_xendit_configured(): void
    {
        config(['xendit.api_key' => 'fake-key-for-test']);
        $tenant = $this->makeTenant();
        TenantPaymentSettings::updateOrCreate(
            ['tenant_id' => $tenant->id],
            [
                'manual_enabled' => true,
                'va_enabled' => true,
                'va_banks' => ['BCA', 'MANDIRI'],
            ]
        );

        $methods = app(TenantPaymentSettingsService::class)->availableMethods($tenant);

        $keys = array_column($methods, 'key');
        $this->assertContains('manual', $keys);
        $this->assertContains('va_bca', $keys);
        $this->assertContains('va_mandiri', $keys);
        $this->assertNotContains('va_bri', $keys); // not in va_banks
    }

    public function test_hides_va_when_xendit_not_configured(): void
    {
        config(['xendit.api_key' => null]);
        $tenant = $this->makeTenant();
        TenantPaymentSettings::updateOrCreate(
            ['tenant_id' => $tenant->id],
            ['va_enabled' => true, 'va_banks' => ['BCA']]
        );

        $methods = app(TenantPaymentSettingsService::class)->availableMethods($tenant);

        $keys = array_column($methods, 'key');
        $this->assertNotContains('va_bca', $keys);
    }

    public function test_hides_manual_when_tenant_missing_bank_details(): void
    {
        $tenant = $this->makeTenant([
            'payment_bank_name' => null,
            'payment_account_number' => null,
            'payment_account_holder' => null,
        ]);
        TenantPaymentSettings::updateOrCreate(
            ['tenant_id' => $tenant->id],
            ['manual_enabled' => true]
        );

        $methods = app(TenantPaymentSettingsService::class)->availableMethods($tenant);

        $this->assertEmpty($methods);
    }
}
```

- [ ] **Step 2: Create config stub for xendit**

Create `config/xendit.php`:
```php
<?php

return [
    'api_key' => env('XENDIT_API_KEY'),
    'webhook_token' => env('XENDIT_WEBHOOK_TOKEN'),
    'va_expiry_hours' => env('XENDIT_VA_EXPIRY_HOURS', 24),
    'external_id_prefix' => env('XENDIT_EXTERNAL_ID_PREFIX', 'hypercoach'),
];
```

- [ ] **Step 3: Create service**

```php
<?php

namespace App\Services;

use App\Models\Tenant;
use App\Models\TenantPaymentSettings;

class TenantPaymentSettingsService
{
    private const VA_FEE_AMOUNT = 4000; // IDR, indicative until P4a reads real Xendit fee tiers

    private const METHOD_DESCRIPTIONS = [
        'manual' => 'Transfer ke rekening bank, upload bukti pembayaran',
        'va_bca' => 'Bayar via BCA Virtual Account, verifikasi otomatis',
        'va_mandiri' => 'Bayar via Mandiri Virtual Account, verifikasi otomatis',
        'va_bri' => 'Bayar via BRI Virtual Account, verifikasi otomatis',
        'va_bni' => 'Bayar via BNI Virtual Account, verifikasi otomatis',
    ];

    public function settingsFor(Tenant $tenant): TenantPaymentSettings
    {
        return TenantPaymentSettings::firstOrCreate(
            ['tenant_id' => $tenant->id],
            [
                'manual_enabled' => true,
                'va_enabled' => false,
                'qris_enabled' => false,
                'ewallet_enabled' => false,
                'va_banks' => ['BCA', 'MANDIRI', 'BRI', 'BNI'],
            ]
        );
    }

    public function availableMethods(Tenant $tenant): array
    {
        $settings = $this->settingsFor($tenant);
        $methods = [];

        if ($settings->manual_enabled && $this->tenantHasBankDetails($tenant)) {
            $methods[] = [
                'key' => 'manual',
                'provider' => 'manual',
                'label' => 'Transfer Manual',
                'description' => self::METHOD_DESCRIPTIONS['manual'],
                'icon' => 'bank_transfer',
                'fee_amount' => 0,
                'bank_details' => [
                    'bank_name' => $tenant->payment_bank_name,
                    'account_number' => $tenant->payment_account_number,
                    'account_holder' => $tenant->payment_account_holder,
                ],
            ];
        }

        $xenditConfigured = ! empty(config('xendit.api_key'));

        if ($settings->va_enabled && $xenditConfigured) {
            foreach ($settings->va_banks ?? [] as $bank) {
                $key = 'va_' . strtolower($bank);
                $methods[] = [
                    'key' => $key,
                    'provider' => 'automatic',
                    'label' => 'Virtual Account ' . ucfirst(strtolower($bank)),
                    'description' => self::METHOD_DESCRIPTIONS[$key] ?? 'Virtual Account otomatis',
                    'icon' => $key,
                    'fee_amount' => self::VA_FEE_AMOUNT,
                ];
            }
        }

        // P5: append QRIS + eWallet here when implemented

        return $methods;
    }

    public function update(Tenant $tenant, array $payload): TenantPaymentSettings
    {
        $settings = $this->settingsFor($tenant);
        $settings->fill($payload);
        $settings->save();

        activity()
            ->performedOn($settings)
            ->causedBy(auth()->user())
            ->withProperties(['changes' => $settings->getChanges()])
            ->log('payment-settings.updated');

        return $settings;
    }

    private function tenantHasBankDetails(Tenant $tenant): bool
    {
        return ! empty($tenant->payment_bank_name)
            && ! empty($tenant->payment_account_number)
            && ! empty($tenant->payment_account_holder);
    }
}
```

- [ ] **Step 4: Run tests, expect pass**

```bash
php artisan test tests/Feature/Payment/TenantPaymentSettingsServiceTest.php
```
Expected: 5 tests pass.

- [ ] **Step 5: Lint + commit**

```bash
./vendor/bin/pint app/Services/TenantPaymentSettingsService.php config/xendit.php tests/Feature/Payment/TenantPaymentSettingsServiceTest.php
git add app/Services/TenantPaymentSettingsService.php config/xendit.php tests/Feature/Payment/TenantPaymentSettingsServiceTest.php
git commit -m "Payment P2: TenantPaymentSettingsService + xendit config stub"
```

---

## Task 7: `IdempotencyKey` middleware

**Files:**
- Create: `app/Http/Middleware/IdempotencyKey.php`
- Modify: `bootstrap/app.php` (register middleware alias)
- Test: `tests/Feature/Payment/IdempotencyKeyTest.php`

- [ ] **Step 1: Create middleware**

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IdempotencyKey
{
    public function handle(Request $request, Closure $next): Response
    {
        $key = $request->header('Idempotency-Key');

        if ($key !== null) {
            // Validate UUID v4 format (loose check)
            if (! preg_match('/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i', $key)) {
                return response()->json([
                    'message' => 'Invalid Idempotency-Key header (expected UUID v4).',
                ], 400);
            }
            $request->attributes->set('idempotency_key', strtolower($key));
        }

        return $next($request);
    }
}
```

- [ ] **Step 2: Register middleware alias in `bootstrap/app.php`**

In the `->withMiddleware(function (Middleware $middleware) { ... })` block, add:
```php
$middleware->alias([
    'idempotency' => \App\Http\Middleware\IdempotencyKey::class,
]);
```

- [ ] **Step 3: Write test (using throwaway route)**

```php
<?php

namespace Tests\Feature\Payment;

use Illuminate\Support\Facades\Route;
use Tests\TestCase;

class IdempotencyKeyTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Route::middleware('idempotency')->get('/_test/idem', function ($request) {
            return response()->json([
                'idempotency_key' => $request->attributes->get('idempotency_key'),
            ]);
        });
    }

    public function test_passes_through_when_no_header(): void
    {
        $this->getJson('/_test/idem')
            ->assertOk()
            ->assertJson(['idempotency_key' => null]);
    }

    public function test_passes_through_with_valid_uuid_lowercases_it(): void
    {
        $this->getJson('/_test/idem', ['Idempotency-Key' => '550E8400-E29B-41D4-A716-446655440000'])
            ->assertOk()
            ->assertJson(['idempotency_key' => '550e8400-e29b-41d4-a716-446655440000']);
    }

    public function test_400_when_header_malformed(): void
    {
        $this->getJson('/_test/idem', ['Idempotency-Key' => 'not-a-uuid'])
            ->assertStatus(400);
    }
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
php artisan test tests/Feature/Payment/IdempotencyKeyTest.php
```
Expected: 3 tests pass.

- [ ] **Step 5: Lint + commit**

```bash
./vendor/bin/pint app/Http/Middleware/IdempotencyKey.php bootstrap/app.php tests/Feature/Payment/IdempotencyKeyTest.php
git add app/Http/Middleware/IdempotencyKey.php bootstrap/app.php tests/Feature/Payment/IdempotencyKeyTest.php
git commit -m "Payment P2: Idempotency-Key middleware (UUID v4 validation)"
```

---

## Task 8: `GET /marketplace/tenants/{slug}/payment-methods` endpoint

**Files:**
- Create: `app/Http/Controllers/Marketplace/PaymentMethodController.php`
- Modify: `routes/api.php`
- Test: `tests/Feature/Payment/MarketplacePaymentMethodsTest.php`

- [ ] **Step 1: Write failing test**

```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Tenant;
use App\Models\TenantPaymentSettings;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Tests\TestCase;

class MarketplacePaymentMethodsTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function makeTenant(): Tenant
    {
        return Tenant::create([
            'name' => 'Petenis Test',
            'slug' => 'petenis-test-' . uniqid(),
            'country' => 'ID',
            'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR',
            'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'PT Petenis',
        ]);
    }

    public function test_returns_manual_method_for_default_tenant(): void
    {
        $tenant = $this->makeTenant();

        $response = $this->getJson("/api/v1/marketplace/tenants/{$tenant->slug}/payment-methods");

        $response->assertOk()
            ->assertJsonStructure([
                'methods' => [
                    '*' => ['key', 'provider', 'label', 'description', 'icon', 'fee_amount'],
                ],
            ]);

        $methods = $response->json('methods');
        $this->assertCount(1, $methods);
        $this->assertEquals('manual', $methods[0]['key']);
    }

    public function test_returns_404_for_unknown_tenant(): void
    {
        $this->getJson('/api/v1/marketplace/tenants/does-not-exist-slug/payment-methods')
            ->assertNotFound();
    }

    public function test_response_never_contains_xendit_keys(): void
    {
        config(['xendit.api_key' => 'fake']);
        $tenant = $this->makeTenant();
        TenantPaymentSettings::updateOrCreate(
            ['tenant_id' => $tenant->id],
            ['manual_enabled' => true, 'va_enabled' => true, 'va_banks' => ['BCA']]
        );

        $body = $this->getJson("/api/v1/marketplace/tenants/{$tenant->slug}/payment-methods")
            ->getContent();

        $this->assertStringNotContainsString('xendit', strtolower($body));
    }
}
```

- [ ] **Step 2: Create controller**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Models\Tenant;
use App\Services\TenantPaymentSettingsService;
use Illuminate\Http\JsonResponse;

class PaymentMethodController extends Controller
{
    public function __construct(
        private readonly TenantPaymentSettingsService $settings,
    ) {}

    public function index(string $slug): JsonResponse
    {
        $tenant = Tenant::where('slug', $slug)->firstOrFail();

        return response()->json([
            'methods' => $this->settings->availableMethods($tenant),
        ]);
    }
}
```

- [ ] **Step 3: Wire route**

In `routes/api.php`, find the `/v1` group and add (near other marketplace routes):
```php
Route::get('marketplace/tenants/{slug}/payment-methods', [
    \App\Http\Controllers\Marketplace\PaymentMethodController::class, 'index'
]);
```

- [ ] **Step 4: Run tests**

```bash
php artisan test tests/Feature/Payment/MarketplacePaymentMethodsTest.php
```
Expected: 3 tests pass.

- [ ] **Step 5: Lint + commit**

```bash
./vendor/bin/pint app/Http/Controllers/Marketplace/PaymentMethodController.php routes/api.php tests/Feature/Payment/MarketplacePaymentMethodsTest.php
git add app/Http/Controllers/Marketplace/PaymentMethodController.php routes/api.php tests/Feature/Payment/MarketplacePaymentMethodsTest.php
git commit -m "Payment P2: GET marketplace/tenants/{slug}/payment-methods endpoint"
```

---

## Task 9: `POST /marketplace/purchases` (manual only) + status + proof endpoints

**Files:**
- Create: `app/Http/Controllers/Marketplace/MarketplacePurchaseController.php`
- Create: `app/Http/Requests/Marketplace/CreatePurchaseRequest.php`
- Modify: `routes/api.php`
- Test: `tests/Feature/Payment/MarketplaceCreatePurchaseManualTest.php`

This task is the biggest in P2. It wires controller → service → factory → provider for manual flow, with Idempotency-Key + activity log.

- [ ] **Step 1: Write the CreatePurchaseRequest**

```php
<?php

namespace App\Http\Requests\Marketplace;

use Illuminate\Foundation\Http\FormRequest;

class CreatePurchaseRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    public function rules(): array
    {
        return [
            'product_id' => ['required', 'integer', 'exists:products,id'],
            'session_id' => ['required', 'integer', 'exists:coaching_sessions,id'],
            'payment_method' => ['required', 'string', 'max:32'],
        ];
    }
}
```

- [ ] **Step 2: Write feature test**

```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Product;
use App\Models\Purchase;
use App\Models\Session;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class MarketplaceCreatePurchaseManualTest extends TestCase
{
    use LazilyRefreshDatabase;

    private Tenant $tenant;

    private User $player;

    private StudentProfile $student;

    private Session $session;

    private Product $product;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleAndPermissionSeeder::class);

        $this->tenant = Tenant::create([
            'name' => 'Petenis', 'slug' => 'petenis-' . uniqid(),
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'PT Petenis',
        ]);

        $this->player = User::create([
            'name' => 'Player', 'email' => 'p@test.com',
            'password' => bcrypt('x'), 'tenant_id' => $this->tenant->id,
        ]);
        $this->player->assignRole('student');

        $this->student = StudentProfile::create([
            'tenant_id' => $this->tenant->id,
            'first_name' => 'Player', 'last_name' => 'Test',
        ]);

        $this->session = Session::create([
            'tenant_id' => $this->tenant->id, 'type' => 'group',
            'start_at' => now()->addDay(), 'duration_minutes' => 60,
            'capacity' => 8, 'status' => 'scheduled',
        ]);

        $this->product = Product::create([
            'tenant_id' => $this->tenant->id, 'name' => 'Grup Satuan',
            'type' => 'group_single', 'session_type' => 'group',
            'price' => 175000, 'is_active' => true,
        ]);
    }

    public function test_unauth_returns_401(): void
    {
        $this->postJson('/api/v1/marketplace/purchases', [])
            ->assertStatus(401);
    }

    public function test_creates_manual_purchase_returns_bank_details(): void
    {
        Sanctum::actingAs($this->player);

        $response = $this->postJson('/api/v1/marketplace/purchases', [
            'product_id' => $this->product->id,
            'session_id' => $this->session->id,
            'payment_method' => 'manual',
        ]);

        $response->assertCreated()
            ->assertJsonStructure([
                'purchase_id',
                'status',
                'provider',
                'payment_method',
                'amount_base',
                'fee_amount',
                'amount_total',
                'bank_details' => ['bank_name', 'account_number', 'account_holder'],
                'proof_upload_url',
            ]);

        $this->assertEquals('manual', $response->json('provider'));
        $this->assertEquals(0, $response->json('fee_amount'));
        $this->assertEquals(175000, $response->json('amount_total'));
        $this->assertStringNotContainsString('xendit', strtolower($response->getContent()));

        $this->assertDatabaseHas('purchases', [
            'id' => $response->json('purchase_id'),
            'payment_provider' => 'manual',
            'payment_method' => 'manual',
            'status' => 'pending_payment',
        ]);
    }

    public function test_idempotency_returns_same_purchase_on_replay(): void
    {
        Sanctum::actingAs($this->player);
        $key = '550e8400-e29b-41d4-a716-446655440000';

        $r1 = $this->postJson('/api/v1/marketplace/purchases', [
            'product_id' => $this->product->id,
            'session_id' => $this->session->id,
            'payment_method' => 'manual',
        ], ['Idempotency-Key' => $key])->assertCreated();

        $r2 = $this->postJson('/api/v1/marketplace/purchases', [
            'product_id' => $this->product->id,
            'session_id' => $this->session->id,
            'payment_method' => 'manual',
        ], ['Idempotency-Key' => $key])->assertCreated();

        $this->assertEquals($r1->json('purchase_id'), $r2->json('purchase_id'));
        $this->assertEquals(1, Purchase::where('idempotency_key', $key)->count());
    }

    public function test_rejects_method_not_enabled_for_tenant(): void
    {
        Sanctum::actingAs($this->player);
        // VA disabled for this tenant (default), should reject va_bca request
        $this->postJson('/api/v1/marketplace/purchases', [
            'product_id' => $this->product->id,
            'session_id' => $this->session->id,
            'payment_method' => 'va_bca',
        ])->assertStatus(422);
    }
}
```

- [ ] **Step 3: Create controller**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Http\Requests\Marketplace\CreatePurchaseRequest;
use App\Models\Product;
use App\Models\Purchase;
use App\Models\Session;
use App\Models\StudentProfile;
use App\Services\Payment\PaymentGatewayFactory;
use App\Services\TenantPaymentSettingsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MarketplacePurchaseController extends Controller
{
    public function __construct(
        private readonly PaymentGatewayFactory $factory,
        private readonly TenantPaymentSettingsService $settings,
    ) {}

    public function store(CreatePurchaseRequest $request): JsonResponse
    {
        $user = $request->user();
        $idempotencyKey = $request->attributes->get('idempotency_key');

        // Idempotency: if key + user match an existing purchase, return it
        if ($idempotencyKey !== null) {
            $existing = Purchase::where('idempotency_key', $idempotencyKey)->first();
            if ($existing !== null) {
                return response()->json($this->purchaseResponse($existing), 201);
            }
        }

        $product = Product::findOrFail($request->integer('product_id'));
        $session = Session::findOrFail($request->integer('session_id'));
        $tenant = $product->tenant;

        // Verify method is enabled for this tenant
        $enabledKeys = array_column($this->settings->availableMethods($tenant), 'key');
        $method = $request->string('payment_method')->toString();
        if (! in_array($method, $enabledKeys, true)) {
            return response()->json([
                'message' => 'Payment method not available for this tenant.',
                'errors' => ['payment_method' => ['Method not enabled.']],
            ], 422);
        }

        $student = StudentProfile::firstOrCreate(
            ['tenant_id' => $tenant->id, 'user_id' => $user->id],
            ['first_name' => $user->name, 'last_name' => '']
        );

        $purchase = DB::transaction(function () use ($tenant, $student, $product, $method, $idempotencyKey) {
            $row = Purchase::create([
                'tenant_id' => $tenant->id,
                'student_profile_id' => $student->id,
                'product_id' => $product->id,
                'status' => 'pending_payment',
                'amount_paid' => $product->price,
                'currency' => $tenant->currency ?? 'IDR',
                'idempotency_key' => $idempotencyKey,
            ]);

            $provider = $this->factory->forMethod($method);
            $intent = $provider->createPayment($row, $method);

            // ManualPaymentProvider already updated provider/method on the row
            $row->refresh();

            activity()
                ->performedOn($row)
                ->causedBy(auth()->user())
                ->withProperties(['payment_method' => $method, 'amount' => $intent->totalAmount])
                ->log('purchase.created');

            return [$row, $intent];
        });

        [$purchaseRow, $intent] = $purchase;

        return response()->json(
            array_merge(
                ['purchase_id' => $purchaseRow->id, 'status' => $purchaseRow->status],
                $intent->toArray(),
            ),
            201
        );
    }

    public function status(Purchase $purchase): JsonResponse
    {
        return response()->json([
            'purchase_id' => $purchase->id,
            'status' => $purchase->status,
            'paid_at' => $purchase->confirmed_at?->toIso8601String(),
        ]);
    }

    public function uploadProof(Request $request, Purchase $purchase): JsonResponse
    {
        $request->validate([
            'proof' => ['required', 'image', 'max:5120'],
        ]);

        if ($purchase->payment_provider !== 'manual') {
            return response()->json([
                'message' => 'Proof upload only supported for manual payments.',
            ], 422);
        }

        $path = $request->file('proof')->store(
            "payments/proofs/{$purchase->tenant_id}",
            'public'
        );

        $purchase->update(['payment_proof_path' => $path]);

        activity()
            ->performedOn($purchase)
            ->causedBy($request->user())
            ->log('purchase.proof_uploaded');

        return response()->json([
            'purchase_id' => $purchase->id,
            'status' => $purchase->status,
            'proof_url' => asset('storage/' . $path),
        ]);
    }

    private function purchaseResponse(Purchase $purchase): array
    {
        // Reconstruct intent shape for idempotent replay
        return [
            'purchase_id' => $purchase->id,
            'status' => $purchase->status,
            'provider' => $purchase->payment_provider === 'xendit' ? 'automatic' : 'manual',
            'payment_method' => $purchase->payment_method,
            'amount_base' => $purchase->amount_paid,
            'fee_amount' => $purchase->xendit_fee_amount ?? 0,
            'amount_total' => $purchase->amount_paid + ($purchase->xendit_fee_amount ?? 0),
            'va_number' => $purchase->xendit_va_number,
            'va_bank' => $purchase->xendit_va_bank,
            'expires_at' => $purchase->xendit_expires_at?->toIso8601String(),
        ];
    }
}
```

- [ ] **Step 4: Wire routes**

In `routes/api.php` inside the `auth:sanctum` middleware group under `/v1`:
```php
Route::middleware('idempotency')->post('marketplace/purchases', [
    \App\Http\Controllers\Marketplace\MarketplacePurchaseController::class, 'store'
]);
Route::get('marketplace/purchases/{purchase}/status', [
    \App\Http\Controllers\Marketplace\MarketplacePurchaseController::class, 'status'
]);
Route::post('marketplace/purchases/{purchase}/proof', [
    \App\Http\Controllers\Marketplace\MarketplacePurchaseController::class, 'uploadProof'
]);
```

- [ ] **Step 5: Run tests**

```bash
php artisan test tests/Feature/Payment/MarketplaceCreatePurchaseManualTest.php
```
Expected: 4 tests pass.

- [ ] **Step 6: Lint + commit**

```bash
./vendor/bin/pint app/Http/Controllers/Marketplace/MarketplacePurchaseController.php app/Http/Requests/Marketplace/CreatePurchaseRequest.php routes/api.php tests/Feature/Payment/MarketplaceCreatePurchaseManualTest.php
git add app/Http/Controllers/Marketplace/MarketplacePurchaseController.php app/Http/Requests/Marketplace/CreatePurchaseRequest.php routes/api.php tests/Feature/Payment/MarketplaceCreatePurchaseManualTest.php
git commit -m "Payment P2: POST marketplace/purchases (manual) + status + proof endpoints"
```

---

## Task 10: Admin endpoints `GET` + `PATCH /admin/tenant/payment-settings`

**Files:**
- Create: `app/Http/Controllers/Admin/PaymentSettingsController.php`
- Create: `app/Http/Requests/Admin/UpdatePaymentSettingsRequest.php`
- Modify: `routes/api.php`
- Test: `tests/Feature/Payment/AdminPaymentSettingsTest.php`

- [ ] **Step 1: Write request validation class**

```php
<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePaymentSettingsRequest extends FormRequest
{
    private const SUPPORTED_BANKS = ['BCA', 'MANDIRI', 'BRI', 'BNI'];

    public function authorize(): bool
    {
        return $this->user()?->hasPermissionTo('manage-tenant-settings') ?? false;
    }

    public function rules(): array
    {
        return [
            'manual_enabled' => ['required', 'boolean'],
            'va_enabled' => ['required', 'boolean'],
            'qris_enabled' => ['required', 'boolean'],
            'ewallet_enabled' => ['required', 'boolean'],
            'va_banks' => ['array'],
            'va_banks.*' => ['string', Rule::in(self::SUPPORTED_BANKS)],
        ];
    }

    public function withValidator($validator): void
    {
        $validator->after(function ($v) {
            if ($this->boolean('va_enabled') && empty($this->input('va_banks'))) {
                $v->errors()->add('va_banks', 'At least one bank required when VA enabled.');
            }
            if ($this->boolean('manual_enabled')) {
                $tenant = $this->user()->tenant ?? null;
                if (! $tenant
                    || empty($tenant->payment_bank_name)
                    || empty($tenant->payment_account_number)
                    || empty($tenant->payment_account_holder)
                ) {
                    $v->errors()->add('manual_enabled', 'Tenant bank details required before enabling manual.');
                }
            }
        });
    }
}
```

- [ ] **Step 2: Write controller**

```php
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UpdatePaymentSettingsRequest;
use App\Services\TenantPaymentSettingsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PaymentSettingsController extends Controller
{
    public function __construct(
        private readonly TenantPaymentSettingsService $service,
    ) {}

    public function show(Request $request): JsonResponse
    {
        $tenant = $request->user()->tenant;
        $settings = $this->service->settingsFor($tenant);

        return response()->json([
            'settings' => [
                'manual_enabled' => $settings->manual_enabled,
                'va_enabled' => $settings->va_enabled,
                'qris_enabled' => $settings->qris_enabled,
                'ewallet_enabled' => $settings->ewallet_enabled,
                'va_banks' => $settings->va_banks ?? [],
            ],
            'platform_xendit_configured' => ! empty(config('xendit.api_key')),
        ]);
    }

    public function update(UpdatePaymentSettingsRequest $request): JsonResponse
    {
        $tenant = $request->user()->tenant;
        $settings = $this->service->update($tenant, $request->validated());

        return response()->json([
            'message' => 'Payment settings updated.',
            'settings' => $settings,
        ]);
    }
}
```

- [ ] **Step 3: Wire routes**

In `routes/api.php` inside the admin/auth:sanctum group:
```php
Route::middleware('permission:manage-tenant-settings')->group(function () {
    Route::get('admin/tenant/payment-settings', [
        \App\Http\Controllers\Admin\PaymentSettingsController::class, 'show'
    ]);
    Route::patch('admin/tenant/payment-settings', [
        \App\Http\Controllers\Admin\PaymentSettingsController::class, 'update'
    ]);
});
```

- [ ] **Step 4: Write feature test**

```php
<?php

namespace Tests\Feature\Payment;

use App\Models\Tenant;
use App\Models\User;
use Database\Seeders\RoleAndPermissionSeeder;
use Illuminate\Foundation\Testing\LazilyRefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Permission;
use Tests\TestCase;

class AdminPaymentSettingsTest extends TestCase
{
    use LazilyRefreshDatabase;

    private function makeAdminUser(): User
    {
        $this->seed(RoleAndPermissionSeeder::class);

        // Ensure the permission exists (idempotent)
        Permission::firstOrCreate(['name' => 'manage-tenant-settings']);

        $tenant = Tenant::create([
            'name' => 'Test', 'slug' => 'test-' . uniqid(),
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1234567890',
            'payment_account_holder' => 'PT Test',
        ]);

        $user = User::create([
            'name' => 'Admin', 'email' => 'a@t.com',
            'password' => bcrypt('x'), 'tenant_id' => $tenant->id,
        ]);
        $user->givePermissionTo('manage-tenant-settings');

        return $user;
    }

    public function test_show_returns_default_settings(): void
    {
        $admin = $this->makeAdminUser();
        Sanctum::actingAs($admin);

        $this->getJson('/api/v1/admin/tenant/payment-settings')
            ->assertOk()
            ->assertJsonPath('settings.manual_enabled', true)
            ->assertJsonPath('settings.va_enabled', false)
            ->assertJsonPath('platform_xendit_configured', false);
    }

    public function test_patch_updates_va_enabled_and_banks(): void
    {
        $admin = $this->makeAdminUser();
        Sanctum::actingAs($admin);

        $this->patchJson('/api/v1/admin/tenant/payment-settings', [
            'manual_enabled' => true,
            'va_enabled' => true,
            'qris_enabled' => false,
            'ewallet_enabled' => false,
            'va_banks' => ['BCA', 'MANDIRI'],
        ])->assertOk();

        $this->getJson('/api/v1/admin/tenant/payment-settings')
            ->assertJsonPath('settings.va_enabled', true)
            ->assertJsonPath('settings.va_banks', ['BCA', 'MANDIRI']);
    }

    public function test_patch_rejects_va_enabled_without_banks(): void
    {
        $admin = $this->makeAdminUser();
        Sanctum::actingAs($admin);

        $this->patchJson('/api/v1/admin/tenant/payment-settings', [
            'manual_enabled' => true,
            'va_enabled' => true,
            'qris_enabled' => false,
            'ewallet_enabled' => false,
            'va_banks' => [],
        ])->assertStatus(422)
            ->assertJsonValidationErrors(['va_banks']);
    }

    public function test_user_without_permission_gets_403(): void
    {
        $this->seed(RoleAndPermissionSeeder::class);
        $tenant = Tenant::create([
            'name' => 'T', 'slug' => 't-' . uniqid(),
            'country' => 'ID', 'timezone' => 'Asia/Jakarta',
            'currency' => 'IDR', 'default_locale' => 'id',
            'payment_bank_name' => 'BCA',
            'payment_account_number' => '1', 'payment_account_holder' => 'X',
        ]);
        $user = User::create([
            'name' => 'X', 'email' => 'x@t.com',
            'password' => bcrypt('x'), 'tenant_id' => $tenant->id,
        ]);

        Sanctum::actingAs($user);
        $this->getJson('/api/v1/admin/tenant/payment-settings')->assertForbidden();
    }
}
```

- [ ] **Step 5: Run tests**

```bash
php artisan test tests/Feature/Payment/AdminPaymentSettingsTest.php
```
Expected: 4 tests pass.

- [ ] **Step 6: Lint + commit**

```bash
./vendor/bin/pint app/Http/Controllers/Admin/PaymentSettingsController.php app/Http/Requests/Admin/UpdatePaymentSettingsRequest.php routes/api.php tests/Feature/Payment/AdminPaymentSettingsTest.php
git add app/Http/Controllers/Admin/PaymentSettingsController.php app/Http/Requests/Admin/UpdatePaymentSettingsRequest.php routes/api.php tests/Feature/Payment/AdminPaymentSettingsTest.php
git commit -m "Payment P2: admin GET + PATCH /tenant/payment-settings endpoints"
```

---

## Task 11: Run migrations on dev DB + smoke test deployed endpoints

**Files:** none (deployment verification)

- [ ] **Step 1: Run migrations on local dev DB**

```bash
cd /c/laragon/www/hypercoach
php artisan migrate
```
Expected: both new migrations run successfully on `hypercoach_prod` (your local development DB).

- [ ] **Step 2: Run full test suite for regression check**

```bash
php artisan test --filter=Payment
```
Expected: all 20+ payment tests pass. If any existing non-Payment test breaks, investigate immediately.

- [ ] **Step 3: Push to origin develop branch**

```bash
git push origin develop
```

- [ ] **Step 4: Trigger dev deploy**

```bash
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh develop"
```
Expected: release activated, PHP-FPM reloaded.

- [ ] **Step 5: Run migrations on dev DB on server**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan migrate --force"
```
Expected: 2 migrations applied to `hypercoach_dev`.

- [ ] **Step 6: Smoke test deployed endpoints**

```bash
# 1. payment-methods on Petenis Kelana (dev)
curl -sk https://devapp.hyperscore.cloud/api/v1/marketplace/tenants/petenis-kelana/payment-methods | python -m json.tool
# Expected: { "methods": [ { "key": "manual", "provider": "manual", ... } ] }

# 2. unknown tenant 404
curl -sk -o /dev/null -w "HTTP %{http_code}\n" https://devapp.hyperscore.cloud/api/v1/marketplace/tenants/nope/payment-methods
# Expected: HTTP 404

# 3. response has no "xendit"
curl -sk https://devapp.hyperscore.cloud/api/v1/marketplace/tenants/petenis-kelana/payment-methods | grep -i xendit
# Expected: (empty) — no match, exit 1
```

- [ ] **Step 7: Final P2 commit + push**

If there's anything uncommitted (lint fixes etc.), commit. Otherwise, P2 is complete.

```bash
git status
git log --oneline -10
```
Expected: 10 commits ahead of original baseline, all P2-tagged.

---

## P2 Self-Verification Checklist

Before marking P2 done and moving to P3:

- [ ] All Payment tests pass (`php artisan test --filter=Payment`)
- [ ] Existing test suite still passes (`php artisan test`) — no regression
- [ ] `flutter analyze` not applicable (this is BE only)
- [ ] Pint passes on all new + modified files
- [ ] Dev deploy successful, endpoints respond 200 / 404 / 401 / 422 correctly
- [ ] Smoke test: `GET payment-methods` returns manual method for petenis-kelana, no xendit keys in body
- [ ] Activity log entries exist for `purchase.created`, `purchase.proof_uploaded`, `payment-settings.updated` (verify with `SELECT * FROM activity_log ORDER BY id DESC LIMIT 10`)
- [ ] **Manual end-to-end** via Postman: register fresh player → create purchase manual → upload proof → status endpoint shows pending_payment

---

## P2 Spec Coverage

This plan implements the following spec sections:

- §4.3 Service composition (PaymentGateway + factory)
- §5.1 tenant_payment_settings table
- §5.2 Purchases extension (added all 9 columns)
- §6.1 Resolution logic (lazy create + xendit-configured check)
- §6.2 Admin write path (with activity log)
- §7.1 GET payment-methods + POST purchases (manual) + GET status + POST proof
- §7.2 Admin GET + PATCH payment-settings
- §12 Security: idempotency middleware + activity log

Deferred to P4a: webhook handler, XenditGateway, xendit_webhook_events, cron expiry, P2 keeps controller branching on method but throws on VA methods until P4a registers XenditGateway in the factory.

Once P2 is verified green, proceed to P3 (web admin UI) per the index.
