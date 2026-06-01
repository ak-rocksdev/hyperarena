# Payment P4a — Backend Xendit VA Integration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Backend creates Xendit Virtual Account on demand, persists it on the purchase, receives webhook with signed payload, confirms purchase on `va_paid`, and expires unpaid VAs after 24h via cron.

**Architecture:** `XenditGateway implements PaymentGateway` (the `automatic` provider). Webhook handler at `POST /api/v1/webhooks/xendit/va` verifies signature + IP + dedup, dispatches `ConfirmPurchaseFromWebhook` job. Cron expires intents past `expires_at`.

**Tech Stack:** Laravel 12 + Guzzle, Spatie ActivityLog, Laravel Queue (database driver in dev), Laravel Scheduler.

**Repo:** `C:\laragon\www\hypercoach`.

**Branding rule (apply to every task):** internal columns may say `xendit_*`; API + log messages exposed to admin must say "automatic" / "Virtual Account" / "HyperArena". Never expose Xendit IDs/URLs outside backend internals.

---

## File Structure

| File | Responsibility |
|---|---|
| `database/migrations/YYYY_MM_DD_create_xendit_webhook_events_table.php` | Webhook event dedup table |
| `database/migrations/YYYY_MM_DD_add_xendit_columns_to_purchases_table.php` | Provider-specific columns on purchases |
| `app/Services/Payments/Gateways/XenditGateway.php` | The `automatic` provider impl |
| `app/Services/Payments/XenditApiClient.php` | Thin HTTP wrapper over Xendit VA API |
| `app/Services/Payments/PaymentGatewayFactory.php` | Modify: register `automatic` => XenditGateway |
| `app/Http/Controllers/Webhooks/XenditWebhookController.php` | Webhook receiver |
| `app/Jobs/ConfirmPurchaseFromXenditWebhook.php` | Idempotent purchase confirmation job |
| `app/Jobs/ExpireUnpaidPaymentIntents.php` | Cron job: mark `expires_at < now()` intents as `expired` |
| `app/Models/XenditWebhookEvent.php` | Eloquent model |
| `app/Console/Kernel.php` | Modify: schedule `ExpireUnpaidPaymentIntents` every 5 min |
| `config/payments.php` | New: Xendit API key, callback token, IP whitelist |
| `routes/api.php` | Modify: add webhook route (no auth, no CSRF) |
| `tests/Feature/Payments/XenditGatewayTest.php` | Unit/feature tests for createIntent |
| `tests/Feature/Webhooks/XenditWebhookTest.php` | Webhook signature, dedup, IP, payload tests |
| `tests/Feature/Payments/ExpireUnpaidIntentsTest.php` | Cron job test |

---

## Task 1: Migration — xendit_webhook_events table

**Files:**
- Create: `database/migrations/YYYY_MM_DD_create_xendit_webhook_events_table.php`

- [ ] **Step 1: Generate migration**

```bash
cd /c/laragon/www/hypercoach
php artisan make:migration create_xendit_webhook_events_table
```

- [ ] **Step 2: Define schema**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('xendit_webhook_events', function (Blueprint $table) {
            $table->id();
            $table->string('xendit_event_id')->unique();  // dedup key
            $table->string('event_type', 64)->index();
            $table->string('xendit_external_id')->nullable()->index();
            $table->json('payload');
            $table->string('processing_status', 32)->default('pending');
            // pending | processed | failed | duplicate
            $table->text('error_message')->nullable();
            $table->timestamp('received_at')->useCurrent();
            $table->timestamp('processed_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('xendit_webhook_events');
    }
};
```

- [ ] **Step 3: Run migration on local**

```bash
php artisan migrate
```

- [ ] **Step 4: Commit**

```bash
git add database/migrations/
git commit -m "Payment P4a: xendit_webhook_events table for webhook dedup"
```

---

## Task 2: Migration — add xendit columns to purchases

**Files:**
- Create: `database/migrations/YYYY_MM_DD_add_xendit_columns_to_purchases_table.php`

- [ ] **Step 1: Generate**

```bash
php artisan make:migration add_xendit_columns_to_purchases_table --table=purchases
```

- [ ] **Step 2: Define schema**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->string('xendit_va_id')->nullable()->after('payment_reference')->index();
            $table->string('xendit_va_account_number', 32)->nullable()->after('xendit_va_id');
            $table->string('xendit_va_bank_code', 16)->nullable()->after('xendit_va_account_number');
            $table->timestamp('payment_intent_expires_at')->nullable()->after('xendit_va_bank_code');
        });
    }

    public function down(): void
    {
        Schema::table('purchases', function (Blueprint $table) {
            $table->dropColumn([
                'xendit_va_id',
                'xendit_va_account_number',
                'xendit_va_bank_code',
                'payment_intent_expires_at',
            ]);
        });
    }
};
```

- [ ] **Step 3: Run + commit**

```bash
php artisan migrate
git add database/migrations/
git commit -m "Payment P4a: xendit_* columns on purchases for VA tracking"
```

---

## Task 3: Config file

**Files:**
- Create: `config/payments.php`

- [ ] **Step 1: Create config**

```php
<?php

return [
    'xendit' => [
        'enabled' => env('XENDIT_ENABLED', false),
        'api_key' => env('XENDIT_API_KEY'),
        'callback_token' => env('XENDIT_CALLBACK_TOKEN'),
        'ip_whitelist' => array_filter(explode(',', (string) env('XENDIT_IP_WHITELIST', ''))),
        'va_expiry_hours' => (int) env('XENDIT_VA_EXPIRY_HOURS', 24),
        'base_url' => env('XENDIT_BASE_URL', 'https://api.xendit.co'),
    ],
];
```

- [ ] **Step 2: Add to .env.example**

Edit `.env.example` (append at bottom):
```
# Payment Gateway — Xendit (P4a)
XENDIT_ENABLED=false
XENDIT_API_KEY=
XENDIT_CALLBACK_TOKEN=
XENDIT_IP_WHITELIST=
XENDIT_VA_EXPIRY_HOURS=24
XENDIT_BASE_URL=https://api.xendit.co
```

- [ ] **Step 3: Commit**

```bash
git add config/payments.php .env.example
git commit -m "Payment P4a: config/payments.php for Xendit credentials"
```

---

## Task 4: `XenditApiClient` (thin Guzzle wrapper)

**Files:**
- Create: `app/Services/Payments/XenditApiClient.php`
- Test: `tests/Feature/Payments/XenditApiClientTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Payments;

use App\Services\Payments\XenditApiClient;
use GuzzleHttp\Handler\MockHandler;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Psr7\Response;
use GuzzleHttp\Client;
use Tests\TestCase;

class XenditApiClientTest extends TestCase
{
    public function test_create_va_posts_to_correct_endpoint_and_returns_va_data(): void
    {
        $mock = new MockHandler([
            new Response(201, [], json_encode([
                'id' => 'va_abc123',
                'external_id' => 'PURCHASE-42',
                'bank_code' => 'BCA',
                'account_number' => '8808080808',
                'expected_amount' => 100000,
                'expiration_date' => '2026-06-02T12:00:00Z',
            ])),
        ]);
        $httpClient = new Client(['handler' => HandlerStack::create($mock)]);

        $client = new XenditApiClient(apiKey: 'test_key', baseUrl: 'https://api.xendit.co', httpClient: $httpClient);

        $result = $client->createVirtualAccount(
            externalId: 'PURCHASE-42',
            bankCode: 'BCA',
            name: 'PT Test',
            expectedAmount: 100000,
            expirationDate: '2026-06-02T12:00:00Z',
        );

        $this->assertEquals('va_abc123', $result['id']);
        $this->assertEquals('8808080808', $result['account_number']);
    }
}
```

- [ ] **Step 2: Run, expect FAIL** (class doesn't exist)

```bash
php artisan test --filter=XenditApiClientTest
```

- [ ] **Step 3: Implement**

```php
<?php

namespace App\Services\Payments;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;

class XenditApiClient
{
    public function __construct(
        private string $apiKey,
        private string $baseUrl = 'https://api.xendit.co',
        private ?Client $httpClient = null,
    ) {
        $this->httpClient ??= new Client(['timeout' => 15]);
    }

    /**
     * Create a Virtual Account via Xendit.
     *
     * @return array{id:string,external_id:string,bank_code:string,account_number:string,expected_amount:int,expiration_date:string}
     * @throws GuzzleException
     */
    public function createVirtualAccount(
        string $externalId,
        string $bankCode,
        string $name,
        int $expectedAmount,
        string $expirationDate,
    ): array {
        $response = $this->httpClient->post($this->baseUrl . '/callback_virtual_accounts', [
            'auth' => [$this->apiKey, ''],
            'json' => [
                'external_id' => $externalId,
                'bank_code' => $bankCode,
                'name' => substr($name, 0, 50),
                'expected_amount' => $expectedAmount,
                'is_closed' => true,
                'is_single_use' => true,
                'expiration_date' => $expirationDate,
            ],
            'headers' => [
                'Content-Type' => 'application/json',
            ],
        ]);

        return json_decode((string) $response->getBody(), true);
    }
}
```

- [ ] **Step 4: Run, expect PASS**

```bash
php artisan test --filter=XenditApiClientTest
```

- [ ] **Step 5: Pint + commit**

```bash
vendor/bin/pint app/Services/Payments/XenditApiClient.php tests/Feature/Payments/XenditApiClientTest.php
git add app/Services/Payments/XenditApiClient.php tests/Feature/Payments/XenditApiClientTest.php
git commit -m "Payment P4a: XenditApiClient (Guzzle wrapper for VA creation)"
```

---

## Task 5: `XenditGateway` (implements PaymentGateway)

**Files:**
- Create: `app/Services/Payments/Gateways/XenditGateway.php`
- Test: `tests/Feature/Payments/XenditGatewayTest.php`

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\Payments;

use App\Models\Purchase;
use App\Models\Tenant;
use App\Models\User;
use App\Services\Payments\Gateways\XenditGateway;
use App\Services\Payments\PaymentIntent;
use App\Services\Payments\XenditApiClient;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Mockery;
use Tests\TestCase;

class XenditGatewayTest extends TestCase
{
    use RefreshDatabase;

    public function test_create_intent_calls_xendit_and_returns_va_intent(): void
    {
        $apiClient = Mockery::mock(XenditApiClient::class);
        $apiClient->shouldReceive('createVirtualAccount')
            ->once()
            ->andReturn([
                'id' => 'va_abc123',
                'external_id' => 'PURCHASE-1',
                'bank_code' => 'BCA',
                'account_number' => '8808080808',
                'expected_amount' => 100000,
                'expiration_date' => '2026-06-02T12:00:00Z',
            ]);

        $tenant = Tenant::factory()->create();
        $user = User::factory()->create(['tenant_id' => $tenant->id]);
        $purchase = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'user_id' => $user->id,
            'amount' => 100000,
            'status' => 'pending',
        ]);

        $gateway = new XenditGateway($apiClient, vaExpiryHours: 24);

        $intent = $gateway->createIntent($purchase, ['bank_code' => 'BCA']);

        $this->assertInstanceOf(PaymentIntent::class, $intent);
        $this->assertEquals('automatic', $intent->provider);
        $this->assertEquals('BCA', $intent->vaBank);
        $this->assertEquals('8808080808', $intent->vaAccountNumber);

        $purchase->refresh();
        $this->assertEquals('va_abc123', $purchase->xendit_va_id);
        $this->assertEquals('8808080808', $purchase->xendit_va_account_number);
        $this->assertEquals('BCA', $purchase->xendit_va_bank_code);
        $this->assertNotNull($purchase->payment_intent_expires_at);
    }
}
```

- [ ] **Step 2: Run, expect FAIL**

```bash
php artisan test --filter=XenditGatewayTest
```

- [ ] **Step 3: Implement gateway**

```php
<?php

namespace App\Services\Payments\Gateways;

use App\Models\Purchase;
use App\Services\Payments\PaymentGateway;
use App\Services\Payments\PaymentIntent;
use App\Services\Payments\XenditApiClient;
use Carbon\Carbon;

class XenditGateway implements PaymentGateway
{
    public function __construct(
        private XenditApiClient $apiClient,
        private int $vaExpiryHours = 24,
    ) {}

    public function providerKey(): string
    {
        return 'automatic';
    }

    public function createIntent(Purchase $purchase, array $params): PaymentIntent
    {
        $bankCode = $params['bank_code'] ?? throw new \InvalidArgumentException('bank_code required for automatic');

        $expiresAt = Carbon::now()->addHours($this->vaExpiryHours);

        $vaData = $this->apiClient->createVirtualAccount(
            externalId: 'PURCHASE-' . $purchase->id,
            bankCode: $bankCode,
            name: $purchase->tenant->name,
            expectedAmount: $purchase->amount,
            expirationDate: $expiresAt->toIso8601String(),
        );

        $purchase->forceFill([
            'payment_method' => 'automatic',
            'xendit_va_id' => $vaData['id'],
            'xendit_va_account_number' => $vaData['account_number'],
            'xendit_va_bank_code' => $vaData['bank_code'],
            'payment_intent_expires_at' => $expiresAt,
        ])->save();

        return new PaymentIntent(
            provider: 'automatic',
            status: 'awaiting_payment',
            vaBank: $vaData['bank_code'],
            vaAccountNumber: $vaData['account_number'],
            expiresAt: $expiresAt->toIso8601String(),
            instructions: null,
        );
    }

    public function confirmIntent(Purchase $purchase, array $webhookPayload): bool
    {
        // Called from webhook handler — sets purchase confirmed
        if ($purchase->status === 'confirmed') {
            return true; // idempotent
        }

        $purchase->forceFill([
            'status' => 'confirmed',
            'confirmed_at' => now(),
            'payment_proof_path' => null, // automatic — no proof needed
        ])->save();

        return true;
    }
}
```

- [ ] **Step 4: Run, expect PASS**

```bash
php artisan test --filter=XenditGatewayTest
```

- [ ] **Step 5: Register in PaymentGatewayFactory**

Edit `app/Services/Payments/PaymentGatewayFactory.php` — add to `make()` method:
```php
return match ($provider) {
    'manual' => app(ManualPaymentProvider::class),
    'automatic' => app(\App\Services\Payments\Gateways\XenditGateway::class),
    default => throw new \InvalidArgumentException("Unknown provider: $provider"),
};
```

Register XenditGateway in a service provider (`AppServiceProvider::register`):
```php
$this->app->singleton(\App\Services\Payments\XenditApiClient::class, function () {
    return new \App\Services\Payments\XenditApiClient(
        apiKey: config('payments.xendit.api_key'),
        baseUrl: config('payments.xendit.base_url'),
    );
});

$this->app->singleton(\App\Services\Payments\Gateways\XenditGateway::class, function ($app) {
    return new \App\Services\Payments\Gateways\XenditGateway(
        $app->make(\App\Services\Payments\XenditApiClient::class),
        config('payments.xendit.va_expiry_hours'),
    );
});
```

- [ ] **Step 6: Pint + commit**

```bash
vendor/bin/pint app/Services/Payments/Gateways/XenditGateway.php app/Services/Payments/PaymentGatewayFactory.php app/Providers/AppServiceProvider.php tests/Feature/Payments/XenditGatewayTest.php
git add -A
git commit -m "Payment P4a: XenditGateway provider + factory + DI registration"
```

---

## Task 6: Webhook controller + signature verification

**Files:**
- Create: `app/Http/Controllers/Webhooks/XenditWebhookController.php`
- Create: `app/Models/XenditWebhookEvent.php`
- Modify: `routes/api.php`
- Test: `tests/Feature/Webhooks/XenditWebhookTest.php`

- [ ] **Step 1: Create model**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class XenditWebhookEvent extends Model
{
    protected $fillable = [
        'xendit_event_id',
        'event_type',
        'xendit_external_id',
        'payload',
        'processing_status',
        'error_message',
        'received_at',
        'processed_at',
    ];

    protected $casts = [
        'payload' => 'array',
        'received_at' => 'datetime',
        'processed_at' => 'datetime',
    ];
}
```

- [ ] **Step 2: Write failing test (signature rejection)**

```php
<?php

namespace Tests\Feature\Webhooks;

use App\Models\XenditWebhookEvent;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class XenditWebhookTest extends TestCase
{
    use RefreshDatabase;

    public function test_rejects_invalid_callback_token(): void
    {
        config(['payments.xendit.callback_token' => 'secret_token']);

        $response = $this->postJson('/api/v1/webhooks/xendit/va', [
            'id' => 'evt_1',
            'status' => 'COMPLETED',
        ], ['X-CALLBACK-TOKEN' => 'wrong_token']);

        $response->assertStatus(401);
        $this->assertDatabaseCount('xendit_webhook_events', 0);
    }

    public function test_accepts_valid_token_and_persists_event(): void
    {
        config(['payments.xendit.callback_token' => 'secret_token']);
        config(['payments.xendit.ip_whitelist' => []]); // disable IP check

        $payload = [
            'id' => 'evt_1',
            'callback_virtual_account_id' => 'va_abc',
            'external_id' => 'PURCHASE-1',
            'amount' => 100000,
            'payment_id' => 'pay_xyz',
            'transaction_timestamp' => '2026-06-01T12:00:00Z',
        ];

        $response = $this->postJson('/api/v1/webhooks/xendit/va', $payload, [
            'X-CALLBACK-TOKEN' => 'secret_token',
        ]);

        $response->assertOk();
        $this->assertDatabaseHas('xendit_webhook_events', [
            'xendit_event_id' => 'evt_1',
        ]);
    }

    public function test_dedups_duplicate_event_ids(): void
    {
        config(['payments.xendit.callback_token' => 'secret_token']);
        config(['payments.xendit.ip_whitelist' => []]);

        XenditWebhookEvent::create([
            'xendit_event_id' => 'evt_1',
            'event_type' => 'va_paid',
            'payload' => [],
            'processing_status' => 'processed',
        ]);

        $response = $this->postJson('/api/v1/webhooks/xendit/va', [
            'id' => 'evt_1',
        ], ['X-CALLBACK-TOKEN' => 'secret_token']);

        $response->assertOk();
        $this->assertDatabaseCount('xendit_webhook_events', 1); // not duplicated
    }
}
```

- [ ] **Step 3: Run, expect FAIL**

```bash
php artisan test --filter=XenditWebhookTest
```

- [ ] **Step 4: Implement controller**

```php
<?php

namespace App\Http\Controllers\Webhooks;

use App\Http\Controllers\Controller;
use App\Jobs\ConfirmPurchaseFromXenditWebhook;
use App\Models\XenditWebhookEvent;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class XenditWebhookController extends Controller
{
    public function handle(Request $request): JsonResponse
    {
        // 1. Verify callback token
        $expectedToken = config('payments.xendit.callback_token');
        $providedToken = $request->header('X-CALLBACK-TOKEN');

        if (!$expectedToken || !hash_equals($expectedToken, (string) $providedToken)) {
            Log::warning('Payment webhook: invalid callback token', ['ip' => $request->ip()]);
            return response()->json(['error' => 'unauthorized'], 401);
        }

        // 2. Verify IP (optional — empty list = skip)
        $whitelist = config('payments.xendit.ip_whitelist', []);
        if (!empty($whitelist) && !in_array($request->ip(), $whitelist, true)) {
            Log::warning('Payment webhook: IP not whitelisted', ['ip' => $request->ip()]);
            return response()->json(['error' => 'forbidden'], 403);
        }

        // 3. Dedup
        $eventId = $request->input('id');
        if (!$eventId) {
            return response()->json(['error' => 'missing id'], 422);
        }

        $existing = XenditWebhookEvent::where('xendit_event_id', $eventId)->first();
        if ($existing) {
            return response()->json(['status' => 'duplicate', 'event' => $eventId]);
        }

        // 4. Persist event
        $event = XenditWebhookEvent::create([
            'xendit_event_id' => $eventId,
            'event_type' => $this->classifyEvent($request->all()),
            'xendit_external_id' => $request->input('external_id'),
            'payload' => $request->all(),
            'processing_status' => 'pending',
            'received_at' => now(),
        ]);

        // 5. Dispatch async job (so 200 is returned fast)
        ConfirmPurchaseFromXenditWebhook::dispatch($event->id);

        return response()->json(['status' => 'received', 'event' => $eventId]);
    }

    private function classifyEvent(array $payload): string
    {
        // VA paid event has callback_virtual_account_id + payment_id
        if (isset($payload['callback_virtual_account_id']) && isset($payload['payment_id'])) {
            return 'va_paid';
        }
        return 'unknown';
    }
}
```

- [ ] **Step 5: Register route (NO auth, NO CSRF)**

Edit `routes/api.php` — add OUTSIDE any auth group:
```php
Route::post('/v1/webhooks/xendit/va', [
    \App\Http\Controllers\Webhooks\XenditWebhookController::class, 'handle',
])->name('webhooks.xendit.va');
```

Verify it's excluded from CSRF if using sanctum statefuldomains by ensuring it's `/api/*` (Laravel default).

- [ ] **Step 6: Run, expect PASS**

```bash
php artisan test --filter=XenditWebhookTest
```

- [ ] **Step 7: Pint + commit**

```bash
vendor/bin/pint app/Http/Controllers/Webhooks/XenditWebhookController.php app/Models/XenditWebhookEvent.php routes/api.php tests/Feature/Webhooks/XenditWebhookTest.php
git add -A
git commit -m "Payment P4a: webhook controller with token + IP + dedup"
```

---

## Task 7: `ConfirmPurchaseFromXenditWebhook` job

**Files:**
- Create: `app/Jobs/ConfirmPurchaseFromXenditWebhook.php`
- Test: `tests/Feature/Webhooks/ConfirmPurchaseJobTest.php`

- [ ] **Step 1: Write failing test**

```php
<?php

namespace Tests\Feature\Webhooks;

use App\Jobs\ConfirmPurchaseFromXenditWebhook;
use App\Models\Purchase;
use App\Models\Tenant;
use App\Models\User;
use App\Models\XenditWebhookEvent;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ConfirmPurchaseJobTest extends TestCase
{
    use RefreshDatabase;

    public function test_confirms_pending_purchase_on_va_paid_event(): void
    {
        $tenant = Tenant::factory()->create();
        $user = User::factory()->create(['tenant_id' => $tenant->id]);
        $purchase = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'user_id' => $user->id,
            'amount' => 100000,
            'status' => 'pending',
            'payment_method' => 'automatic',
            'xendit_va_id' => 'va_abc',
        ]);

        $event = XenditWebhookEvent::create([
            'xendit_event_id' => 'evt_1',
            'event_type' => 'va_paid',
            'xendit_external_id' => "PURCHASE-{$purchase->id}",
            'payload' => [
                'id' => 'evt_1',
                'callback_virtual_account_id' => 'va_abc',
                'external_id' => "PURCHASE-{$purchase->id}",
                'amount' => 100000,
                'payment_id' => 'pay_xyz',
            ],
            'processing_status' => 'pending',
        ]);

        (new ConfirmPurchaseFromXenditWebhook($event->id))->handle();

        $purchase->refresh();
        $event->refresh();

        $this->assertEquals('confirmed', $purchase->status);
        $this->assertNotNull($purchase->confirmed_at);
        $this->assertEquals('processed', $event->processing_status);
        $this->assertNotNull($event->processed_at);
    }

    public function test_amount_mismatch_fails_event_without_confirming(): void
    {
        $tenant = Tenant::factory()->create();
        $purchase = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'amount' => 100000,
            'status' => 'pending',
            'xendit_va_id' => 'va_abc',
        ]);

        $event = XenditWebhookEvent::create([
            'xendit_event_id' => 'evt_1',
            'event_type' => 'va_paid',
            'xendit_external_id' => "PURCHASE-{$purchase->id}",
            'payload' => [
                'callback_virtual_account_id' => 'va_abc',
                'external_id' => "PURCHASE-{$purchase->id}",
                'amount' => 50000, // wrong
                'payment_id' => 'pay_xyz',
            ],
            'processing_status' => 'pending',
        ]);

        (new ConfirmPurchaseFromXenditWebhook($event->id))->handle();

        $purchase->refresh();
        $event->refresh();

        $this->assertEquals('pending', $purchase->status); // NOT confirmed
        $this->assertEquals('failed', $event->processing_status);
        $this->assertStringContainsString('amount mismatch', $event->error_message);
    }
}
```

- [ ] **Step 2: Run, expect FAIL**

```bash
php artisan test --filter=ConfirmPurchaseJobTest
```

- [ ] **Step 3: Implement**

```php
<?php

namespace App\Jobs;

use App\Models\Purchase;
use App\Models\XenditWebhookEvent;
use App\Services\Payments\PaymentGatewayFactory;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ConfirmPurchaseFromXenditWebhook implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(public int $eventId) {}

    public function handle(PaymentGatewayFactory $factory): void
    {
        $event = XenditWebhookEvent::find($this->eventId);
        if (!$event || $event->processing_status !== 'pending') {
            return;
        }

        if ($event->event_type !== 'va_paid') {
            $event->update([
                'processing_status' => 'failed',
                'error_message' => 'Unsupported event type: ' . $event->event_type,
                'processed_at' => now(),
            ]);
            return;
        }

        // Extract purchase from external_id (format: PURCHASE-{id})
        $externalId = $event->xendit_external_id;
        if (!preg_match('/^PURCHASE-(\d+)$/', $externalId, $m)) {
            $event->update([
                'processing_status' => 'failed',
                'error_message' => 'Invalid external_id format: ' . $externalId,
                'processed_at' => now(),
            ]);
            return;
        }

        $purchaseId = (int) $m[1];

        DB::transaction(function () use ($event, $purchaseId, $factory) {
            $purchase = Purchase::lockForUpdate()->find($purchaseId);
            if (!$purchase) {
                $event->update([
                    'processing_status' => 'failed',
                    'error_message' => "Purchase $purchaseId not found",
                    'processed_at' => now(),
                ]);
                return;
            }

            // Idempotent: already confirmed
            if ($purchase->status === 'confirmed') {
                $event->update([
                    'processing_status' => 'processed',
                    'processed_at' => now(),
                ]);
                return;
            }

            // Amount verification
            $webhookAmount = (int) ($event->payload['amount'] ?? 0);
            if ($webhookAmount !== (int) $purchase->amount) {
                Log::critical('Payment webhook amount mismatch', [
                    'purchase_id' => $purchase->id,
                    'expected' => $purchase->amount,
                    'received' => $webhookAmount,
                ]);
                $event->update([
                    'processing_status' => 'failed',
                    'error_message' => "amount mismatch: expected {$purchase->amount}, got {$webhookAmount}",
                    'processed_at' => now(),
                ]);
                return;
            }

            // VA ID verification
            $webhookVaId = $event->payload['callback_virtual_account_id'] ?? null;
            if ($webhookVaId !== $purchase->xendit_va_id) {
                $event->update([
                    'processing_status' => 'failed',
                    'error_message' => "VA id mismatch: expected {$purchase->xendit_va_id}, got {$webhookVaId}",
                    'processed_at' => now(),
                ]);
                return;
            }

            // Confirm via gateway
            $gateway = $factory->make('automatic');
            $gateway->confirmIntent($purchase, $event->payload);

            $event->update([
                'processing_status' => 'processed',
                'processed_at' => now(),
            ]);
        });
    }
}
```

- [ ] **Step 4: Run, expect PASS**

```bash
php artisan test --filter=ConfirmPurchaseJobTest
```

- [ ] **Step 5: Pint + commit**

```bash
vendor/bin/pint app/Jobs/ConfirmPurchaseFromXenditWebhook.php tests/Feature/Webhooks/ConfirmPurchaseJobTest.php
git add -A
git commit -m "Payment P4a: ConfirmPurchaseFromXenditWebhook job (idempotent + amount/va verify)"
```

---

## Task 8: Expire unpaid VAs cron job

**Files:**
- Create: `app/Jobs/ExpireUnpaidPaymentIntents.php`
- Modify: `app/Console/Kernel.php` (or `bootstrap/app.php` for L11+)
- Test: `tests/Feature/Payments/ExpireUnpaidIntentsTest.php`

- [ ] **Step 1: Write failing test**

```php
<?php

namespace Tests\Feature\Payments;

use App\Jobs\ExpireUnpaidPaymentIntents;
use App\Models\Purchase;
use App\Models\Tenant;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExpireUnpaidIntentsTest extends TestCase
{
    use RefreshDatabase;

    public function test_marks_expired_pending_purchases_as_expired(): void
    {
        $tenant = Tenant::factory()->create();

        $expired = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'status' => 'pending',
            'payment_method' => 'automatic',
            'payment_intent_expires_at' => Carbon::now()->subHour(),
        ]);

        $stillValid = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'status' => 'pending',
            'payment_method' => 'automatic',
            'payment_intent_expires_at' => Carbon::now()->addHour(),
        ]);

        $manualPending = Purchase::factory()->create([
            'tenant_id' => $tenant->id,
            'status' => 'pending',
            'payment_method' => 'manual',
            'payment_intent_expires_at' => null,
        ]);

        (new ExpireUnpaidPaymentIntents())->handle();

        $this->assertEquals('expired', $expired->fresh()->status);
        $this->assertEquals('pending', $stillValid->fresh()->status);
        $this->assertEquals('pending', $manualPending->fresh()->status); // manual not affected
    }
}
```

- [ ] **Step 2: Run, expect FAIL**

```bash
php artisan test --filter=ExpireUnpaidIntentsTest
```

- [ ] **Step 3: Implement**

```php
<?php

namespace App\Jobs;

use App\Models\Purchase;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ExpireUnpaidPaymentIntents implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function handle(): void
    {
        $count = Purchase::query()
            ->where('status', 'pending')
            ->where('payment_method', 'automatic')
            ->whereNotNull('payment_intent_expires_at')
            ->where('payment_intent_expires_at', '<', now())
            ->update(['status' => 'expired']);

        if ($count > 0) {
            Log::info("Expired {$count} unpaid VA payment intents");
        }
    }
}
```

- [ ] **Step 4: Run, expect PASS**

```bash
php artisan test --filter=ExpireUnpaidIntentsTest
```

- [ ] **Step 5: Schedule** (Laravel 12 uses `routes/console.php` or `bootstrap/app.php`)

In `routes/console.php`:
```php
use App\Jobs\ExpireUnpaidPaymentIntents;
use Illuminate\Support\Facades\Schedule;

Schedule::job(new ExpireUnpaidPaymentIntents)->everyFiveMinutes();
```

- [ ] **Step 6: Pint + commit**

```bash
vendor/bin/pint app/Jobs/ExpireUnpaidPaymentIntents.php routes/console.php tests/Feature/Payments/ExpireUnpaidIntentsTest.php
git add -A
git commit -m "Payment P4a: ExpireUnpaidPaymentIntents job + 5-min schedule"
```

---

## Task 9: Update `purchases` status enum to include `expired`

**Files:**
- Modify or create: `database/migrations/YYYY_MM_DD_extend_purchases_status_enum.php`

- [ ] **Step 1: Check current status column**

```bash
php artisan tinker --execute="dump(DB::select('SHOW COLUMNS FROM purchases LIKE \"status\"'));"
```

If status is ENUM and `expired` is missing, add migration. If it's `string`, skip this task.

- [ ] **Step 2: Create migration if needed**

```bash
php artisan make:migration extend_purchases_status_enum --table=purchases
```

```php
public function up(): void
{
    DB::statement("ALTER TABLE purchases MODIFY COLUMN status ENUM('pending','confirmed','rejected','cancelled','expired') NOT NULL DEFAULT 'pending'");
}
public function down(): void
{
    DB::statement("ALTER TABLE purchases MODIFY COLUMN status ENUM('pending','confirmed','rejected','cancelled') NOT NULL DEFAULT 'pending'");
}
```

- [ ] **Step 3: Run + commit**

```bash
php artisan migrate
git add database/migrations/
git commit -m "Payment P4a: extend purchases status enum to include 'expired'"
```

---

## Task 10: Update marketplace `POST purchases` to route to gateway

**Files:**
- Modify: `app/Http/Controllers/Marketplace/PurchaseController.php` (created in P2)

- [ ] **Step 1: Verify P2 controller exists + read it**

```bash
ls app/Http/Controllers/Marketplace/PurchaseController.php
```

- [ ] **Step 2: Update `store()` to handle `automatic` provider**

In `PurchaseController::store()`, after validation, dispatch to factory:
```php
public function store(StorePurchaseRequest $request, PaymentGatewayFactory $factory): JsonResponse
{
    // ... existing tenant + product lookup ...

    // Create purchase row
    $purchase = Purchase::create([
        'tenant_id' => $tenantId,
        'user_id' => auth()->id(),
        'product_id' => $product->id,
        'amount' => $product->price,
        'status' => 'pending',
        'payment_method' => $request->validated('payment_method'),
    ]);

    // Build PaymentIntent via gateway
    try {
        $gateway = $factory->make($request->validated('payment_method'));
        $intent = $gateway->createIntent($purchase, $request->validated('params', []));
    } catch (\Throwable $e) {
        $purchase->update(['status' => 'cancelled']);
        return response()->json([
            'message' => 'Gagal membuat pembayaran. Coba lagi.',
            'error' => $e->getMessage(),
        ], 502);
    }

    return response()->json([
        'purchase_id' => $purchase->id,
        'payment_intent' => $intent->toArray(),
    ], 201);
}
```

- [ ] **Step 3: Update request validation to accept `params.bank_code`**

In `StorePurchaseRequest::rules()`:
```php
return [
    'product_id' => ['required', 'integer'],
    'payment_method' => ['required', 'in:manual,automatic'],
    'params' => ['array'],
    'params.bank_code' => ['required_if:payment_method,automatic', 'in:BCA,MANDIRI,BRI,BNI'],
];
```

- [ ] **Step 4: Add integration test**

In existing `tests/Feature/Marketplace/PurchaseControllerTest.php` or create:
```php
public function test_create_automatic_purchase_returns_va_intent(): void
{
    // ... mock XenditApiClient via $this->mock(...) ...
    // POST /api/v1/marketplace/purchases with payment_method=automatic, params.bank_code=BCA
    // assert response 201 with payment_intent.provider=automatic, va_account_number set
}
```

- [ ] **Step 5: Run all payment tests**

```bash
php artisan test --filter='Payment|Webhook|Purchase'
```

- [ ] **Step 6: Pint + commit**

```bash
vendor/bin/pint app/Http/Controllers/Marketplace/PurchaseController.php app/Http/Requests/StorePurchaseRequest.php
git add -A
git commit -m "Payment P4a: PurchaseController routes to automatic gateway for VA creation"
```

---

## Task 11: Deploy + smoke test on dev

**Files:** none (verification)

- [ ] **Step 1: Push develop branch**

```bash
git push origin develop
```

- [ ] **Step 2: Backup dev DB before migration**

```bash
ssh ak_rocks@103.157.97.233 "mysqldump -u ak_rocks -p'Abdulkad2586.' hypercoach_dev > /srv/www/hypercoach_dev/backups/pre-p4a-$(date +%Y%m%d-%H%M%S).sql"
```

- [ ] **Step 3: Deploy**

```bash
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh develop"
```

- [ ] **Step 4: Run migrations on dev**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan migrate --force"
```

- [ ] **Step 5: Add Xendit sandbox creds to dev .env**

User obtains XENDIT_API_KEY (sandbox) + XENDIT_CALLBACK_TOKEN from Xendit dashboard, then:
```bash
ssh ak_rocks@103.157.97.233
sudo nano /srv/www/hypercoach_dev/shared/.env
# Set:
# XENDIT_ENABLED=true
# XENDIT_API_KEY=xnd_development_xxx
# XENDIT_CALLBACK_TOKEN=xxx
# XENDIT_IP_WHITELIST=  # empty for now, add prod IPs later
sudo systemctl reload php8.2-fpm
exit
```

- [ ] **Step 6: Smoke test webhook receiver**

```bash
# From local
curl -X POST https://devapp.hyperscore.cloud/api/v1/webhooks/xendit/va \
  -H 'X-CALLBACK-TOKEN: <token>' \
  -H 'Content-Type: application/json' \
  -d '{"id":"test_1","callback_virtual_account_id":"va_test","external_id":"PURCHASE-99","amount":100000,"payment_id":"pay_test"}'
# Expect: 200 {"status":"received","event":"test_1"}
```

- [ ] **Step 7: Smoke test create VA via API**

Use existing admin → enable VA → as a member, call:
```bash
curl -X POST https://<tenant>.devapp.hyperscore.cloud/api/v1/marketplace/purchases \
  -H 'Authorization: Bearer <token>' \
  -H 'Content-Type: application/json' \
  -d '{"product_id":1,"payment_method":"automatic","params":{"bank_code":"BCA"}}'
# Expect: 201 with payment_intent containing va_account_number from Xendit sandbox
```

Verify in Xendit dashboard: VA was created with external_id `PURCHASE-{id}`.

- [ ] **Step 8: Trigger Xendit sandbox VA simulator → verify webhook arrives + purchase confirmed**

In Xendit dashboard, find the VA, click "Simulate payment". Then:
```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan queue:work --once"
# (or queue:work as daemon)
# Verify in DB: purchases.status = confirmed, xendit_webhook_events.processing_status = processed
```

- [ ] **Step 9: Test expiry cron**

```bash
ssh ak_rocks@103.157.97.233 "cd /srv/www/hypercoach_dev/current && php artisan schedule:run"
# Then manually create a pending purchase with payment_intent_expires_at = past, run schedule:run again
# Verify status = expired
```

---

## P4a Self-Verification Checklist

- [ ] All tests pass: `php artisan test --filter='Payment|Webhook|Purchase'`
- [ ] Xendit sandbox VA creation works from production code path
- [ ] Webhook signature verification rejects wrong token (401)
- [ ] Webhook dedup prevents duplicate processing
- [ ] Amount mismatch logs critical + marks event failed (not confirmed)
- [ ] Cron runs every 5 min on dev (`ssh ... "crontab -l"` shows Laravel schedule)
- [ ] **NO "Xendit" in any user-facing API response field name or value** — grep responses
- [ ] All log messages with admin-visible context use "automatic" / "VA" / "HyperArena"

---

## P4a Spec Coverage

- §7.1 Provider configuration table (`automatic` = XenditGateway)
- §7.2 VA creation flow (5 steps, matches `XenditGateway::createIntent`)
- §7.3 Webhook handler (signature + IP + dedup + amount verify)
- §7.4 Expiry cron (5-minute schedule)
- §8.2 Webhook events table schema
- §11 Security checklist: signature, IP, dedup, amount, idempotent confirm

Deferred to P5: QRIS + eWallet providers, payout API, refund webhook.

Once P4a verified green end-to-end with sandbox payment, proceed to P4b.
