# PRD — Payment System (Manual + Virtual Account via Xendit)

**Status:** Design — pre-implementation
**Owners:** Flutter (this repo) + Laravel BE (`C:\laragon\www\hypercoach`)
**Created:** 2026-06-01
**Branding:** User must never see "Xendit". All UI says HyperArena.

---

## 1. Goal

Let a player pay for a session booking via either (a) **manual bank transfer** with proof upload, or (b) **automatic virtual account** that confirms via webhook. Let the organizer admin enable/disable each method per club.

## 2. Scope

### In scope (this spec)
- DB migration: tenant payment settings + extend `purchases` table.
- BE service: `PaymentGateway` orchestrator + `XenditGateway` provider (internal class).
- API endpoints: list available methods, create purchase + payment intent, poll status, webhook handler, admin toggle settings.
- Web admin UI: payment-method toggle page + manual-transfer bank details.
- Mobile UI: checkout screen (method picker), VA waiting screen, manual upload screen revamp.
- Push notification on payment status change.
- Audit log for every payment state change.

### Deferred (separate specs / future phases)
- QRIS via Xendit (P5)
- E-wallet (OVO/GoPay/DANA/ShopeePay) (P5)
- Automated refund via Xendit refund API (V2)
- Official PDF invoice / receipt generation (V2)
- Xendit XenPlatform (sub-account model) for marketplace-grade settlement (V2+)
- Per-tenant Xendit credentials (V2+, currently single platform account)
- Card payments (V3)
- Subscription / recurring (V3)

### Out of scope (won't do)
- Bypass Xendit and integrate per-bank APIs directly.
- Crypto payment.
- Cash-on-venue with reconciliation tooling.

## 3. Branding constraint (CRITICAL)

The user-facing surface MUST NEVER reference Xendit. Verification matrix:

| Surface | Allowed text | Forbidden text |
|---|---|---|
| Mobile checkout method picker | "Virtual Account", "Transfer Manual", "QRIS" (P5) | "Xendit", "Xendit VA", "Powered by Xendit" |
| Mobile VA waiting screen | "Bayar via VA Bank Mandiri / BCA / BRI / BNI" + bank logo + VA number | "Xendit VA", any Xendit logo |
| Mobile error/empty | "Pembayaran tidak tersedia", "Coba lagi" | "Xendit error", error codes from Xendit |
| Web admin settings page | "Metode Pembayaran", "Virtual Account otomatis" | "Xendit settings", "Xendit credentials" |
| Push notification | "Pembayaran berhasil — HyperArena" | "via Xendit" |
| API JSON response | `payment_method: "va_bca"`, `provider: "automatic"` | `xendit_*` keys in any response body |
| Email (V2) | "HyperArena Payment Receipt" | "Xendit invoice" |

Internal allowed (server logs, BE service class names, DB columns, env vars): `XENDIT_API_KEY`, `xendit_callback_id` column, `Log::info('Xendit webhook received')`. Only platform-level super-admins see these.

Implementation pattern: thin abstraction layer `PaymentGateway` exposes generic methods; provider implementation `XenditGateway` is hidden behind it. If we swap provider later, only `XenditGateway` is replaced.

## 4. Architecture

### 4.1 Money flow (single Xendit platform account)

```
Player checkout → BE create Purchase (pending_payment) + SessionStudent (pending_payment)
       │
       ├── if manual: return tenant bank details
       │     player transfers offline, uploads proof
       │     admin reviews + confirms via existing organizer sheet
       │     Purchase + SessionStudent → confirmed
       │
       └── if automatic VA:
             BE call XenditGateway.createVA(amount, external_id, bank)
             Xendit returns va_number + callback_id + expires_at
             Purchase row updated with VA details
             Mobile shows VA + countdown + status polling
             Player transfers via m-banking
             Xendit webhook → BE verify signature + IP + dedupe event
             Purchase + SessionStudent → confirmed
             FCM push to player
```

### 4.2 Component diagram

```
┌─────────────────────────┐         ┌──────────────────────────┐
│  Flutter Mobile App     │         │  Web Admin SPA           │
│  - CheckoutScreen       │         │  - SettingsPaymentScreen │
│  - VaWaitingScreen      │         └────────────┬─────────────┘
│  - ManualProofScreen    │                      │
└────────────┬────────────┘                      │
             │ HTTPS Bearer / Cookie             │
             ▼                                   ▼
┌──────────────────────────────────────────────────────────────┐
│                  Laravel BE                                  │
│                                                              │
│  Routes  ──> Controllers ──> PaymentGateway (abstract)       │
│                                  │                           │
│                                  ├──> ManualProvider         │
│                                  │     (existing upload-     │
│                                  │      proof flow, revamped)│
│                                  │                           │
│                                  └──> XenditGateway          │
│                                       (createVA, getVA,      │
│                                        verifyWebhook)        │
│                                                              │
│  Webhook endpoint: POST /webhooks/xendit/callback            │
│       │                                                      │
│       ▼                                                      │
│  XenditWebhookService                                        │
│   - signature verify (X-Callback-Token header)               │
│   - IP whitelist (Xendit IPs)                                │
│   - event dedupe (xendit_webhook_events table)               │
│   - update Purchase + SessionStudent + activity_log + FCM    │
└──────────────────────────────────────────────────────────────┘
             │
             ▼
        ┌────────────┐                ┌────────────────┐
        │  MySQL     │                │  Xendit API    │
        │ purchases  │                │ (sandbox/live) │
        │ tenant_*   │                └────────────────┘
        │ session_*  │
        │ activity_* │
        └────────────┘
```

### 4.3 Service composition

| Layer | Class | Responsibility |
|---|---|---|
| Controller | `MarketplacePurchaseController` | HTTP routing, validation, response shaping |
| Orchestrator | `PaymentGateway` | Decide which provider, idempotency, DB transactional integrity |
| Provider — manual | `ManualPaymentProvider` | Resolve tenant bank details, accept proof upload (extends existing flow) |
| Provider — automatic | `XenditGateway` | Call Xendit API for VA creation, expose generic interface |
| Webhook handler | `XenditWebhookService` | Verify, dedupe, update state, fire side effects |
| Settings | `TenantPaymentSettingsService` | Toggle methods, read for marketplace endpoint |
| Notifications | existing FCM infrastructure | Payment confirmed push |

`PaymentGateway` exposes methods like `createPayment(purchase, method)` and returns a generic `PaymentIntent` value object. Mobile and controller never see `XenditGateway` directly.

```php
// Indicative interface (final signatures decided in P2 implementation)
interface PaymentGateway {
    public function createPayment(Purchase $purchase, string $method): PaymentIntent;
    public function getStatus(Purchase $purchase): PurchaseStatus;
}

final readonly class PaymentIntent {
    public function __construct(
        public string $providerLabel,       // 'manual' | 'automatic'
        public string $methodKey,           // 'manual' | 'va_bca' | ...
        public int $feeAmount,
        public int $totalAmount,
        public ?string $vaNumber = null,
        public ?string $vaBank = null,
        public ?CarbonInterface $expiresAt = null,
        public ?array $bankDetails = null,  // for manual
    ) {}
}
```

## 5. Data model

### 5.1 New table: `tenant_payment_settings`

One row per tenant. Default seeded for existing tenants: manual_enabled=true, automatic methods disabled until admin opts in.

```sql
CREATE TABLE tenant_payment_settings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tenant_id BIGINT UNSIGNED NOT NULL UNIQUE,
  manual_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  va_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  qris_enabled BOOLEAN NOT NULL DEFAULT FALSE,     -- P5
  ewallet_enabled BOOLEAN NOT NULL DEFAULT FALSE,  -- P5
  -- which VA banks are enabled (only meaningful when va_enabled=true)
  va_banks JSON NOT NULL DEFAULT (JSON_ARRAY('BCA','MANDIRI','BRI','BNI')),
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  CONSTRAINT fk_tps_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);
```

Per-tenant Xendit credentials (`xendit_api_key`) NOT stored here in V1 — single platform key from `.env`. Adding per-tenant key is V2+ (when XenPlatform is set up).

### 5.2 Extend `purchases` table (all additive, nullable)

```sql
ALTER TABLE purchases
  ADD COLUMN payment_provider ENUM('manual','xendit') NULL AFTER status,
  ADD COLUMN payment_method VARCHAR(32) NULL AFTER payment_provider,
  ADD COLUMN idempotency_key CHAR(36) NULL AFTER payment_method,
  ADD COLUMN xendit_callback_id VARCHAR(64) NULL AFTER idempotency_key,
  ADD COLUMN xendit_external_id VARCHAR(64) NULL AFTER xendit_callback_id,
  ADD COLUMN xendit_va_number VARCHAR(32) NULL AFTER xendit_external_id,
  ADD COLUMN xendit_va_bank VARCHAR(16) NULL AFTER xendit_va_number,
  ADD COLUMN xendit_fee_amount INT UNSIGNED NULL DEFAULT 0 AFTER xendit_va_bank,
  ADD COLUMN xendit_expires_at DATETIME NULL AFTER xendit_fee_amount,
  ADD UNIQUE KEY uniq_purchases_idempotency_key (idempotency_key),
  ADD UNIQUE KEY uniq_purchases_xendit_external_id (xendit_external_id);
```

Values:
- `payment_provider` (internal DB column): `'manual' | 'xendit'`. **Never returned to mobile** — controller maps to API field `provider: "manual" | "automatic"` per §7. The `xendit` provider value is hidden behind the generic `"automatic"` label in any client-facing response.
- `payment_method`: `'manual' | 'va_bca' | 'va_mandiri' | 'va_bri' | 'va_bni'` (V1). P5 adds: `'qris' | 'ewallet_ovo' | 'ewallet_gopay' | ...`.
- `xendit_fee_amount`: in smallest unit (rupiah for IDR — IDR is zero-decimal, so whole rupiah). Stored on purchase for settlement accounting.
- `xendit_external_id`: convention `hypercoach-{env}-purchase-{id}` (e.g., `hypercoach-dev-purchase-42`). Sent to Xendit on VA creation. Used to route webhook back to purchase. UNIQUE.
- `idempotency_key`: UUID provided by mobile client to prevent duplicate purchase creation on network retry. UNIQUE.

Backward-compat: existing rows have `payment_provider=NULL` — treated as legacy manual flow in app logic.

### 5.3 New table: `xendit_webhook_events`

Dedupe webhook replays. Xendit may send same event multiple times on retry.

```sql
CREATE TABLE xendit_webhook_events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  xendit_event_id VARCHAR(64) NOT NULL UNIQUE,  -- Xendit's id field in payload
  event_type VARCHAR(64) NOT NULL,              -- 'fixed_va.paid', 'invoice.expired', etc.
  payload JSON NOT NULL,                        -- full body for audit
  processed_at TIMESTAMP NULL,                  -- null = received but not yet processed
  created_at TIMESTAMP NOT NULL
);
```

Handler logic: insert row with `processed_at=NULL` first (catch duplicate via unique key), process, then UPDATE processed_at. If duplicate insert fails, return 200 immediately (already processed).

### 5.4 Settlement integration

`SessionFinancialService::forSession()` already supports custom cost streams. Add new system-tracked stream with:

- Internal key (DB / service layer): `payment_gateway_fees`
- Aggregation: `SUM(purchases.xendit_fee_amount)` over confirmed purchases of the session.
- User-facing label (organizer admin, mobile settlement breakdown): **"Biaya Payment Gateway"** — never says "Xendit" anywhere in the UI text.

`FinancialStreamX::displayLabel` extension already supports key-to-label mapping; add the entry there so any FE that renders streams uses the friendly label automatically.

## 6. Tenant payment settings

### 6.1 Resolution logic (read path)

When mobile calls `GET /api/v1/marketplace/tenants/{slug}/payment-methods`:

```
1. Load tenant_payment_settings row.
   - If missing: lazy-create with defaults (manual_enabled=true, others=false)
     inside a DB transaction. P2 migration also backfills one row per
     existing tenant, so lazy-create handles only future tenant creation
     races.
2. Check platform-level Xendit configured:
   - if XENDIT_API_KEY not set in .env, force all automatic methods to disabled
3. Build response array:
   - if manual_enabled AND tenant has bank details → include manual method
   - if va_enabled AND xendit configured → include each bank in va_banks JSON
   - (qris, ewallet — P5)
4. Return [] if nothing enabled (mobile shows "Pembayaran belum tersedia, hubungi organizer")
```

### 6.2 Write path (admin toggle)

`PATCH /api/v1/admin/tenant/payment-settings` body:

```json
{
  "manual_enabled": true,
  "va_enabled": true,
  "va_banks": ["BCA", "MANDIRI"],
  "qris_enabled": false,
  "ewallet_enabled": false
}
```

Validation: if `va_enabled=true`, `va_banks` must be non-empty subset of supported banks. If `manual_enabled=true`, tenant must have bank details set (else 422). Activity log entry on change.

## 7. API spec

### 7.1 Mobile-facing

#### `GET /api/v1/marketplace/tenants/{slug}/payment-methods`
List of enabled payment methods for a tenant. No auth required (public marketplace).

**Response 200:**
```json
{
  "methods": [
    {
      "key": "manual",
      "provider": "manual",
      "label": "Transfer Manual",
      "description": "Transfer ke rekening bank, upload bukti pembayaran",
      "icon": "bank_transfer",
      "fee_amount": 0,
      "bank_details": {
        "bank_name": "BCA",
        "account_number": "1234567890",
        "account_holder": "Petenis Kelana"
      }
    },
    {
      "key": "va_bca",
      "provider": "automatic",
      "label": "Virtual Account BCA",
      "description": "Bayar via BCA Virtual Account, verifikasi otomatis",
      "icon": "va_bca",
      "fee_amount": 4000
    },
    {
      "key": "va_mandiri",
      "provider": "automatic",
      "label": "Virtual Account Mandiri",
      "description": "Bayar via Mandiri Virtual Account, verifikasi otomatis",
      "icon": "va_mandiri",
      "fee_amount": 4000
    }
  ]
}
```

No `xendit_*` keys exposed. `fee_amount` already calculated server-side from Xendit fee tiers.

#### `POST /api/v1/marketplace/purchases`
Create purchase + payment intent. Idempotent via `Idempotency-Key` header.

**Request:**
```json
{
  "product_id": 6,
  "session_id": 41,
  "payment_method": "va_bca"
}
```
Header: `Idempotency-Key: <client-generated-uuid-v4>`

**Response 201 (automatic VA):**
```json
{
  "purchase_id": 30,
  "session_student_id": 75,
  "status": "pending_payment",
  "provider": "automatic",
  "payment_method": "va_bca",
  "amount_base": 175000,
  "fee_amount": 4000,
  "amount_total": 179000,
  "va_number": "8808912345678",
  "va_bank": "BCA",
  "expires_at": "2026-06-02T23:00:00+07:00",
  "instructions_url": null
}
```

**Response 201 (manual):**
```json
{
  "purchase_id": 31,
  "session_student_id": 76,
  "status": "pending_payment",
  "provider": "manual",
  "payment_method": "manual",
  "amount_base": 175000,
  "fee_amount": 0,
  "amount_total": 175000,
  "bank_details": { "bank_name": "BCA", "account_number": "...", "account_holder": "..." },
  "proof_upload_url": "/api/v1/marketplace/purchases/31/proof"
}
```

**Error 422:** payment method not enabled for tenant, capacity full, session expired, etc.
**Error 409:** duplicate idempotency key with different request body.

#### `GET /api/v1/marketplace/purchases/{id}/status`
Polling endpoint. Returns current status.

**Response 200:**
```json
{
  "purchase_id": 30,
  "status": "confirmed",  // pending_payment | confirmed | cancelled | expired
  "paid_at": "2026-06-02T20:15:33+07:00",
  "session_student_id": 75
}
```

Cache `Cache-Control: no-cache`. Mobile polls every 5s during waiting screen, back off to 10s after 60s, stop after 30 minutes (assume user abandoned).

#### `POST /api/v1/marketplace/purchases/{id}/proof`
Manual flow only. Multipart upload of payment proof image.

### 7.2 Admin-facing

#### `GET /api/v1/admin/tenant/payment-settings`
Read current settings. Permission: `manage-tenant-settings`.

#### `PATCH /api/v1/admin/tenant/payment-settings`
Update toggles. Validation + activity log per §6.2.

### 7.3 Webhook

#### `POST /webhooks/xendit/callback`
Single endpoint, no auth (signature-based). Nginx-level IP whitelist for Xendit IPs.

**Headers:** `X-Callback-Token: <token-matching-XENDIT_WEBHOOK_TOKEN>`

**Body (VA paid):**
```json
{
  "id": "evt_abc123",
  "callback_virtual_account_id": "va_def456",
  "external_id": "hypercoach-dev-purchase-30",
  "amount": 179000,
  "transaction_timestamp": "2026-06-02T20:15:33+07:00",
  "bank_code": "BCA",
  ...
}
```

**Handler logic:**
1. Verify `X-Callback-Token` matches `config('xendit.webhook_token')`. If not, return 401.
2. Insert into `xendit_webhook_events` with `xendit_event_id = body.id`. If duplicate (already processed), return 200 immediately.
3. Find purchase by `xendit_external_id = body.external_id`. If not found, log + return 200 (don't 4xx — Xendit will retry indefinitely).
4. Validate amount matches expected (`purchases.amount_paid + xendit_fee_amount`). If mismatch, mark purchase `disputed` + alert admin.
5. In DB transaction: update purchase → `confirmed`, update session_student → `confirmed`, write activity_log entry, set `xendit_webhook_events.processed_at = NOW()`.
6. Fire FCM push to player.
7. Return 200 always (even on internal errors — log + investigate, don't block Xendit retries beyond what we want).

## 8. Purchase state machine

```
              ┌─────────────────┐
              │  pending_payment│  (initial state after checkout)
              └────────┬────────┘
                       │
       ┌───────────────┼───────────────┬──────────────────┐
       │               │               │                  │
       ▼               ▼               ▼                  ▼
  ┌─────────┐     ┌─────────┐    ┌──────────┐      ┌──────────┐
  │confirmed│     │cancelled│    │ expired  │      │ disputed │
  │(paid)   │     │(admin/  │    │ (cron    │      │ (amount  │
  │         │     │player)  │    │  past    │      │  mismatch│
  │         │     │         │    │  expires │      │  in webhook│
  │         │     │         │    │  _at)    │      │  )       │
  └─────────┘     └─────────┘    └──────────┘      └──────────┘
                                       │
                                       │ (player retry)
                                       ▼
                                ┌───────────────┐
                                │ new purchase  │
                                │ (separate id) │
                                └───────────────┘
```

Transitions:
- `pending_payment → confirmed`: webhook (VA) OR admin confirm (manual).
- `pending_payment → cancelled`: admin reject (manual) OR player cancel within grace period.
- `pending_payment → expired`: cron job (run hourly) marks past `xendit_expires_at`. Auto-releases the `session_student` row (sets cancelled_at).
- `pending_payment → disputed`: webhook with mismatched amount. Requires admin review.

VA expiry default: 24 hours from creation. Configurable via `XENDIT_VA_EXPIRY_HOURS` env, default 24.

## 9. Mobile UX spec

### 9.1 Checkout screen

Triggered from session detail "Book" button.

Layout (top to bottom):
- AppBar: "Pesan Sesi" + back
- Summary card: session title + venue + date + 1× peserta
- Price breakdown:
  ```
  Harga sesi          Rp 175.000
  Biaya admin         Rp   4.000   (only if non-manual method selected)
  ─────────────────────────────
  Total               Rp 179.000
  ```
- Method picker section header: "Metode Pembayaran"
- Method cards (only enabled methods from `/payment-methods` API):
  - Each: icon + label + sub-description + fee chip (if >0) + radio
  - Selected card has primary border, others outline
- CTA: "Bayar Sekarang" (full-width, primary)
- Footer: "Dengan mengonfirmasi, Anda setuju dengan syarat & ketentuan"

States:
- Loading methods (skeleton cards)
- No methods enabled → empty state: "Belum ada metode pembayaran. Hubungi organizer untuk info."
- Submitting (button disabled, spinner)
- Error (toast + button enabled)

### 9.2 VA waiting screen

Triggered after successful checkout with automatic method.

Layout:
- AppBar: "Menunggu Pembayaran" + close (× confirm dialog)
- Hero card:
  - Bank logo (BCA/Mandiri/BRI/BNI) — 80px
  - "Virtual Account BCA"
  - VA number — big monospace, copy button to right
  - "Berlaku sampai: 02 Jun 2026, 23:00 (24 jam)"
  - Live countdown: "Sisa waktu 23 jam 45 menit"
- Amount card:
  - "Bayar Tepat" + big Rp 179.000 + copy button
- Instructions accordion:
  - "Cara bayar via m-BCA" → expandable steps
  - Includes Mandiri/BRI/BNI variants based on bank
- Status badge: "Menunggu pembayaran ..." with subtle pulse animation
- Footer: "Sudah bayar? Klik refresh" + manual refresh button (forces poll)

Polling: every 5s for 60s, then 10s for 5 min, then 30s onwards. Stop at 30 min total.

On status `confirmed`: animate success ✓ → show "Pembayaran berhasil" 2s → navigate to BookingDetailScreen.

On status `expired`: show "VA sudah expired" + "Pesan ulang" button → back to checkout.

### 9.3 Manual upload screen revamp

Replace existing flow. Cleaner state tracking.

Layout:
- Hero card: bank details (large, copy buttons)
- Amount: Rp 175.000 + copy
- Upload section: drag/tap to upload bukti image (camera or gallery)
- Preview thumbnail after upload
- Status: "Menunggu verifikasi admin" (after upload) with timestamp
- Status updates via polling (same endpoint as VA)
- On admin confirm → push notif + screen updates

### 9.4 Status detail screen (post-payment)

After confirmation, show booking detail with:
- Big ✓ "Pesanan dikonfirmasi"
- Session details
- Payment receipt summary
- "Lihat tiket / detail sesi" button
- "Add to calendar" button (future)

## 10. Web admin UX spec

### 10.1 Settings page: `/admin/settings/payment-methods`

Permission gate: `manage-tenant-settings`.

Layout:
- Page header: "Metode Pembayaran" + breadcrumb
- Intro text: "Atur metode pembayaran yang bisa dipilih anggota saat memesan sesi"
- Method toggle cards (vertical stack):

  **Card 1: Transfer Manual**
  - Title + toggle switch
  - If on: collapsible section with bank details form (`bank_name`, `account_number`, `account_holder`, `payment_instructions` notes)
  - Validation: if toggle on, bank details required (disable toggle off until form fixed)

  **Card 2: Virtual Account otomatis**
  - Title + toggle switch
  - Sub-description: "Anggota bayar via VA, verifikasi otomatis (biaya admin ditanggung anggota)"
  - If platform Xendit not configured: toggle disabled + tooltip "Belum tersedia, hubungi platform admin"
  - If on: checkbox list "Bank yang diterima" — BCA / Mandiri / BRI / BNI (multi-select, at least one required)

  **Card 3: QRIS otomatis** — `disabled` (greyed) in V1, label "(akan datang)"

  **Card 4: E-Wallet otomatis** — `disabled` (greyed) in V1, label "(akan datang)"

- Sticky footer: "Simpan Perubahan" + reset button
- After save: toast "Perubahan tersimpan, anggota akan lihat metode terbaru saat checkout berikutnya"

## 11. Push notification spec

Trigger: purchase status changes `pending_payment → confirmed`.

Payload (FCM data message):
```json
{
  "type": "payment_confirmed",
  "purchase_id": "30",
  "session_id": "41",
  "session_title": "Petenis Kelana — Kelas Tenis",
  "amount_total": "179000",
  "method": "va_bca"
}
```

Notification text (Indonesian):
- Title: "Pembayaran berhasil ✓"
- Body: "Pesanan kamu untuk {session_title} sudah dikonfirmasi"
- Tap action: deep-link to BookingDetailScreen(purchase_id)

No mention of "Xendit". HyperArena branding via app icon.

## 12. Security checklist

| Item | Approach | Status |
|---|---|---|
| Xendit API key in .env (not committed) | Standard Laravel env | ✓ design |
| Webhook signature verification | `X-Callback-Token` header == `XENDIT_WEBHOOK_TOKEN` env | ✓ design |
| Webhook IP whitelist | Nginx `allow` directives for Xendit IPs (list in deploy/) | ✓ design |
| Webhook replay protection | `xendit_webhook_events` dedupe table | ✓ design |
| Idempotency on create-purchase | `Idempotency-Key` header → `purchases.idempotency_key` UNIQUE | ✓ design |
| DB transactional integrity | DB::transaction wrap purchase + xendit call + session_student | ✓ design |
| No Xendit secret in logs | Custom log redactor for Xendit-prefixed keys | TODO |
| Rate limit on create-purchase | Laravel throttle middleware: 10 per minute per user | ✓ design |
| Webhook always returns 200 (after dedupe insert) | Avoid Xendit-side retry storm | ✓ design |
| Activity log every state change | `Spatie\ActivityLog` entries on Purchase model events | ✓ design |
| Permission checks on admin endpoints | `manage-tenant-settings` permission | ✓ design |
| Mobile bearer token required for purchases endpoints | Sanctum middleware | ✓ design |
| HTTPS only for all endpoints | nginx 301 from http | ✓ existing |
| Sensitive data masking in admin UI | account_number show last 4 only by default, reveal on click | TODO |

## 13. Test plan

### Unit tests
- `PaymentGateway::createPayment()` routes to correct provider per method
- `XenditGateway::createVA()` mocks Xendit API responses (sandbox + error cases)
- `XenditWebhookService::process()` handles: valid payment, invalid signature, duplicate event, amount mismatch, missing purchase
- `TenantPaymentSettingsService::availableMethods()` filters correctly per config
- Idempotency: duplicate POST with same `Idempotency-Key` returns same purchase
- Purchase state machine: forbidden transitions throw

### Feature tests
- `POST /api/v1/marketplace/purchases` with manual method → returns bank details
- `POST /api/v1/marketplace/purchases` with va_bca → returns VA number, no `xendit_*` keys in response
- `GET /api/v1/marketplace/tenants/{slug}/payment-methods` → filters by tenant settings
- `POST /webhooks/xendit/callback` valid signature + payload → updates purchase to confirmed, creates activity log, sends FCM (mocked)
- `POST /webhooks/xendit/callback` invalid signature → 401
- `POST /webhooks/xendit/callback` duplicate event → 200 immediately
- `PATCH /api/v1/admin/tenant/payment-settings` → updates settings, fires activity log
- Concurrent checkout (same idempotency key, simultaneous requests) → only one purchase row created

### Integration tests (against Xendit sandbox)
- Create VA against real Xendit sandbox, simulate paid callback via Xendit simulator
- Verify VA expiry behavior
- Verify fee amount accuracy (compare API response vs. stored)

### Manual test scenarios
- Mobile: book session with manual → upload proof → admin confirm via web → mobile receives push
- Mobile: book session with VA BCA → transfer via Xendit simulator → mobile receives push + screen updates
- Admin: toggle VA off → mobile next checkout doesn't show VA option
- Admin: edit bank details → mobile next checkout shows new details
- VA expiry: leave VA unpaid for 24+1 hours → cron marks expired → mobile shows "expired" + retry CTA

## 14. Phased implementation

| Phase | Scope | Deps | Effort estimate |
|---|---|---|---|
| **P1 — Design spec** | This document + writing-plans output | — | 1 day (mostly done) |
| **P2 — BE foundation** | `tenant_payment_settings` migration + table + service + admin settings endpoints (GET/PATCH) + revamped manual flow + new `Idempotency-Key` support + `payment_method` enum extension on purchases | P1 | 1.5 days |
| **P3 — Web admin UI** | Vue settings page with 4 toggle cards + bank details form + validation | P2 | 1 day |
| **P4a — BE Xendit VA** | `XenditGateway` service + Xendit SDK install + create-VA endpoint + webhook handler + `xendit_webhook_events` table + sandbox testing + activity log integration + FCM trigger + scheduled cron task to expire stale `pending_payment` purchases (hourly: `Purchases::where('xendit_expires_at', '<', now())->update(...)`) | P2 | 2 days |
| **P4b — Mobile UI** | Checkout screen revamp + VA waiting screen + manual upload revamp + payment method picker model + polling logic + push notif handler + status detail screen | P4a | 2 days |
| **P5 (later)** | QRIS via Xendit (Qr Code API) + eWallet (DANA/OVO/etc.) + per-method P2 spec additions | P4 | TBD |
| **V2 (later)** | Automated refund + PDF invoice/receipt + per-tenant Xendit credentials (XenPlatform) | — | TBD |

Total V1 (P1-P4b): ~7-8 dev days.

### Deployment order
1. P2 + P3 deployed together (admin can configure manual, mobile continues with old flow unchanged).
2. P4a deployed (BE ready for VA, but mobile doesn't call it yet).
3. P4b deployed (mobile starts offering VA in checkout).

## 15. Deferred checklist (track for later)

- [ ] **PDF invoice/receipt generation** — HyperArena-branded, via Spatie Browsershot, on payment confirmed. Email + downloadable.
- [ ] **Email notifications** — payment confirmed, payment expired, payment refunded. Templates with HyperArena branding only.
- [ ] **Xendit refund API integration** — admin clicks refund → BE calls Xendit refund → tracks state.
- [ ] **QRIS via Xendit QrCode API** — single QR for all wallets.
- [ ] **E-wallet (OVO, GoPay, DANA, ShopeePay, LinkAja)** — Xendit eWallet API.
- [ ] **Card payments** — Xendit Cards API with 3DS.
- [ ] **Direct Debit** — Xendit Direct Debit for recurring.
- [ ] **Per-tenant Xendit account** (XenPlatform sub-accounts) — when multi-tenant scale demands it.
- [ ] **Settlement automation** — push notification to organizer "Rp X siap cair, klik tarik" + payout flow.
- [ ] **Anti-fraud** — duplicate device detection, velocity checks on player checkout.
- [ ] **Currency expansion** — MYR support if Malaysia tenants adopt VA.
- [ ] **Recurring subscriptions** — coaching packages billed monthly.
- [ ] **Apple Pay / Google Pay** via Xendit tokenization (V3+).
- [ ] **Secret rotation runbook** — process for rotating XENDIT_API_KEY without downtime.
- [ ] **Webhook secret rotation** — similar.
- [ ] **Sensitive data masking in admin UI** — account_number partial display.
- [ ] **Log redactor** — strip Xendit-prefixed values from Laravel logs.

## 16. Open questions / decisions log

| # | Question | Decision | Date |
|---|---|---|---|
| 1 | Xendit products to start with | VA (BCA/Mandiri/BRI/BNI) only in V1; QRIS + eWallet in P5 | 2026-06-01 |
| 2 | Toggle granularity | 4 grouped: Manual / VA-all / QRIS / eWallet, plus `va_banks` JSON for per-bank subset | 2026-06-01 |
| 3 | Xendit account model | Single platform account in V1; XenPlatform sub-accounts deferred to V2 | 2026-06-01 |
| 4 | Mobile flow after VA selection | Combo push notif + polling fallback | 2026-06-01 |
| 5 | Fees | Player absorbs, added to checkout total | 2026-06-01 |
| 6 | Refund handling | Manual admin only in V1; automated in V2 | 2026-06-01 |
| 7 | Manual flow | Revamp with cleaner state tracking (not keep legacy as-is) | 2026-06-01 |
| 8 | Branding | Never show "Xendit" to end users; HyperArena only | 2026-06-01 |
| 9 | VA expiry duration | 24 hours default, configurable via env | 2026-06-01 |
| 10 | Polling interval | 5s for 1m, 10s for 5m, 30s thereafter; stop at 30m | 2026-06-01 |
| 11 | Idempotency strategy | Client UUID via `Idempotency-Key` header → UNIQUE column on `purchases` | 2026-06-01 |
| 12 | Webhook idempotency | `xendit_webhook_events` table with unique `xendit_event_id` | 2026-06-01 |
| 13 | Existing `PaymentMethodType` enum migration | Keep old aliases (`bankTransfer` → `manual`) via JSON serialization compatibility layer | 2026-06-01 |
| Future-V2 | Per-tenant fee absorption split (e.g., organizer absorbs 50%) | Open — defer to V2 if needed | — |
| Future-V2 | Multi-currency (MYR) | Open — current scope IDR only | — |

---

*End of spec.*
