# QRIS Payment for Marketplace Checkout — Design

**Date:** 2026-07-07
**Repos:** `hyperarena` (Flutter FE) + `hypercoach` (Laravel BE)
**Status:** Approved design → ready for implementation plan

## Goal

Make **QRIS** a fully working payment method in the marketplace checkout
(`Purchase`) flow — QR display + scan + automatic webhook confirmation — exactly
as the Virtual Account (VA) methods already work, carrying the same Xendit
transaction fee (currently Rp5.000). Today `PaymentGatewayFactory::forMethod('qris')`
throws `"QRIS + e-wallet land in P5"`, so selecting QRIS on checkout errors.

## Architecture (the principle that drives every decision)

**Mirror the VA flow.** QRIS differs from VA in only two places: (1) it creates a
Xendit **QR code** instead of a Virtual Account, and (2) the client shows a
**scannable QR** instead of a VA number. Everything else is reused verbatim — the
`Purchase` model, the webhook endpoint (which already classifies `qris_paid`), the
confirmation job (extended, not replaced), the status-polling waiting-screen
pattern, the fee, and the amount convention. No new payment concepts.

## Global constraints

- All UI work goes through the **frontend-design** skill; reuse existing theme
  tokens and components (mirror `va_waiting_screen.dart`, `CountdownTimer`,
  `purchaseStatusStreamProvider`).
- Copy is **Indonesian**, sentence case, active voice.
- WCAG AA: don't use `AppColors.textTertiary` (#94A3B8) for essential text.
- **No API keys or secrets committed** (`.env` is gitignored).
- Fee + expiry are **config-driven and shared with VA** — QRIS reads the same
  `XENDIT_VA_FEE_AMOUNT` (fee) and `XENDIT_VA_EXPIRY_MINUTES` (expiry, = 15 min)
  so the two methods never drift.

---

## What already exists (reused, no change)

- **`XenditApiClient::createQrCode(referenceId, amount, expiresAt)`** →
  `{id, reference_id, qr_string, status}` (DYNAMIC / IDR / api-version 2022-07-31).
- **`XenditWebhookController`** — validates `X-CALLBACK-TOKEN`, dedups by event id,
  persists `XenditWebhookEvent`, and **already** `classifyEvent()`s a
  `qr_id`/`qr_code` payload as `qris_paid`, then routes by external_id: a
  `…-PURCHASE-…` id dispatches `ConfirmPurchaseFromXenditWebhook`. Endpoint:
  `POST /api/v1/webhooks/xendit/va` (name is VA-era; it already handles both — not
  renamed, to avoid re-registering the existing FVA callback).
- **`XenditWebhookEvent`** captures `payload['external_id'] ?? payload['reference_id']`
  from the **top level** — but see **BE-6a**: Xendit's QR (2022-07-31) callback
  nests `reference_id`/`qr_id`/`amount` under a `data` envelope, so the controller
  needs a normalization pass before this extraction (and `classifyEvent`) works for
  QR. The existing `classifyEvent`'s `qris_paid` branch is a **flat-shape guess**,
  not verified against a real QR callback.
- **`PurchaseService::confirmPurchase()`** — fires `PurchaseConfirmed` + all
  listeners (credit allocation, notifications). VA confirm already uses it.
- **FE `purchaseStatusStreamProvider`** + `va_waiting_screen.dart` — polls status
  and auto-navigates to `/payment/success/:id` on `confirmed`/`expired`.
- **Fee/amount convention** (unchanged from VA): the gateway charges
  `purchase->amount_paid` (base); the fee lives in `xendit_fee_amount`; the
  client-facing total = base + fee.

---

## Backend (`hypercoach`)

### BE-1. Migration — one new column on `purchases`
- Add `xendit_qr_string` (`text`, nullable) after `xendit_va_bank`. Holds the
  EMVCo QRIS payload string the client renders.
- **Reuse** `xendit_callback_id` for the Xendit **QR id** (the same slot VA uses
  for its VA id) and `xendit_external_id` for `{prefix}-PURCHASE-{id}` (unchanged).
  No other new columns. `xendit_external_id` keeps its **unique** constraint; like
  VA, a purchase mints its QR intent once — the controller's `idempotency_key`
  guard prevents a duplicate `store`, so the stable `-PURCHASE-{id}` id never
  collides in the normal flow.

### BE-2. `XenditQrisGateway implements PaymentGateway` (new)
File: `app/Services/Payment/Gateways/XenditQrisGateway.php`, parallel to
`XenditGateway`. Constructor mirrors `XenditGateway`:
`(XenditApiClient $apiClient, int $qrExpiryMinutes, string $externalIdPrefix, int $feeAmount)`.

`createPayment(Purchase $purchase, string $method): PaymentIntent`:
- Guard: `$method === 'qris'`, else `InvalidArgumentException`.
- `$externalId = "{$this->externalIdPrefix}-PURCHASE-{$purchase->id}"` (same shape
  as VA → the webhook router + confirm job's `-PURCHASE-(\d+)` regex work unchanged).
- `$expiresAt = now()->addMinutes($this->qrExpiryMinutes)`.
- `$qr = $apiClient->createQrCode(referenceId: $externalId, amount: $purchase->amount_paid, expiresAt: $expiresAt->toIso8601String())`.
- `$purchase->forceFill([...])->save()`: `payment_provider='xendit'`,
  `payment_method='qris'`, `xendit_callback_id=$qr['id']`,
  `xendit_external_id=$externalId`, `xendit_qr_string=$qr['qr_string']`,
  `xendit_fee_amount=$this->feeAmount`, `xendit_expires_at=$expiresAt`.
- `activity()->…->log('Automatic payment intent created')` (provider label
  `automatic`, method `qris`) — parity with VA.
- Return `PaymentIntent(providerLabel:'automatic', methodKey:'qris',
  baseAmount:$purchase->amount_paid, feeAmount:$this->feeAmount,
  totalAmount:$purchase->amount_paid + $this->feeAmount,
  qrString:$qr['qr_string'], expiresAt:$expiresAt)`.
- `getStatus(Purchase $purchase): string => $purchase->status` (webhook-driven,
  same as VA).

### BE-3. DI registration (`AppServiceProvider`)
Register `XenditQrisGateway` as a singleton, mirroring the `XenditGateway`
binding:
```php
$this->app->singleton(XenditQrisGateway::class, fn ($app) => new XenditQrisGateway(
    apiClient: $app->make(XenditApiClient::class),
    qrExpiryMinutes: (int) config('xendit.va_expiry_minutes', 15),
    externalIdPrefix: (string) config('xendit.external_id_prefix', 'hypercoach'),
    feeAmount: (int) config('xendit.va_fee_amount', 4000),
));
```

### BE-4. `PaymentGatewayFactory`
- Inject `XenditQrisGateway $qris` into the constructor.
- `forMethod('qris')` → `return $this->qris;` (remove the `RuntimeException` throw).
- `ewallet_*` keeps throwing (still out of scope).

### BE-5. `PaymentIntent` (Support) + serialization
- Add `public ?string $qrString = null` to the constructor.
- `toArray()`: add `'qr_string' => $this->qrString`.

### BE-6a. `XenditWebhookController` — normalize the QR payment envelope
The controller today reads **flat top-level** fields (`payload['id']`,
`payload['external_id']/['reference_id']`, `payload['qr_id']`, `payload['amount']`)
— correct for the legacy VA callback. Xendit's **QR Code API 2022-07-31** (the
version `createQrCode` uses) delivers the payment webhook as a **nested envelope**:
`{ "event": "qr.payment", "data": { "id", "qr_id", "reference_id", "amount", "status", … } }`.
Left as-is, `classifyEvent` returns `unknown` and the external id / amount resolve
to null / 0 → the QR confirmation misroutes and fails.
- **First implementation step — capture the real payload.** Trigger a Xendit
  **test** QR payment (simulate) against a throwaway QR and log the exact webhook
  body. Code to that shape — do not trust this spec's field guesses.
- Add a normalization at the top of `handle()`: if the body carries a `data`
  object (QR envelope), unwrap `reference_id` / `qr_id` / `amount` / `status` from
  `data` while keeping the top-level event `id` for dedup. Then `classifyEvent`,
  the `XenditWebhookEvent` external-id capture, and the dispatch routing work
  unchanged for both VA (flat) and QR (nested). Cover both shapes with tests.

### BE-6b. `ConfirmPurchaseFromXenditWebhook` — accept `qris_paid`
- Change the type guard from `!== 'va_paid'` to allow both `va_paid` **and**
  `qris_paid` (reject anything else).
- `-PURCHASE-(\d+)` external-id parse, amount verification
  (`webhookAmount === purchase->amount_paid`), idempotency, `confirmPurchase`,
  activity log — **all unchanged** (reading the **normalized** payload from BE-6a).
- **Provider-id verification branches by event type:**
  - `va_paid`: `callback_virtual_account_id === purchase->xendit_callback_id` (existing).
  - `qris_paid`: `qr_id === purchase->xendit_callback_id` (the QR id we stored).
    Mismatch → `markFailed`.
- **Status guard:** for `qris_paid`, confirm only on a success status
  (`SUCCEEDED`/`COMPLETED`, per the captured payload) — ignore intermediate events.

### BE-7. Xendit "QR paid" callback registration (ops, not app code)
Xendit delivers QR payment callbacks to the account's **QR-paid** callback URL,
separate from the FVA callback. Point it at the same endpoint
(`…/api/v1/webhooks/xendit/va`). For local testing this is registered via the
Xendit API (as the FVA callback was); in the dashboard it is Settings →
Webhooks → QR Code. Documented as a runbook step, not code.

---

## Frontend (`hyperarena`)

### FE-1. `PaymentIntent` model
Add `@JsonKey(name: 'qr_string') String? qrString` to
`lib/features/payment/data/models/payment_intent.dart`; regenerate freezed/json.

### FE-2. `qr_flutter` dependency
Add `qr_flutter` (latest stable `^`) to `pubspec.yaml`. Renders the EMVCo
`qr_string` as a scannable QR via `QrImageView`.

### FE-3. `QrisWaitingScreen` (new) — mirrors `va_waiting_screen.dart`
File: `lib/features/payment/presentation/screens/qris_waiting_screen.dart`.
- Same scaffold/appbar/structure as `VaWaitingScreen`.
- Replaces `VaAccountDisplay` with a **QR card**: white rounded card containing
  `QrImageView(data: intent.qrString!, size: …)`, the amount
  (`amount_total`), and Indonesian guidance ("Scan QR dengan aplikasi e-wallet
  atau mobile banking").
- Reuses `CountdownTimer` (expiry from `intent.expiresAt`) and
  `purchaseStatusStreamProvider(purchaseId)` for polling.
- Auto-navigates to `/payment/success/:purchaseId?status=<status>` on
  `confirmed`/`expired` — identical `ref.listen` logic to `VaWaitingScreen`.
- Handles a missing `qrString` defensively (error state + back to home), never
  a blank screen.

### FE-4. Route + checkout dispatch
- Add route `/payment/qris/:purchaseId` in `app_router.dart` beside
  `/payment/va/:purchaseId`, building `QrisWaitingScreen` and reading the
  `intent` from `extra` (same pattern as the VA route).
- `CheckoutScreen._submit` dispatch becomes: `manual` → `/payment/manual/:id`;
  `intent.paymentMethod == 'qris'` → `/payment/qris/:id`; otherwise →
  `/payment/va/:id`. The `qris` branch passes the same `sharedExtra` + `intent`.

---

## Error handling
- **`422` method-not-enabled** (tenant lacks `qris_enabled`) → existing checkout
  error surface (unchanged path in `MarketplacePurchaseController@store`).
- **Xendit QR creation failure** (5xx/network) → the gateway throws; the checkout
  `_submit` catch shows the existing "Gagal memproses pembayaran" snackbar.
- **Webhook amount / qr-id mismatch** → `ConfirmPurchaseFromXenditWebhook`
  `markFailed` with a reason; purchase stays pending (never falsely confirmed).
- **QR expired before payment** → status stream emits `expired`; screen routes to
  the success screen's expired state (same as VA).

## Out of scope (explicit YAGNI)
- E-wallet (`ewallet_*`) methods — still deferred.
- Saving / sharing / downloading the QR image.
- Partial or over-payment handling (closed dynamic QR is exact-amount).
- Renaming the `…/webhooks/xendit/va` endpoint (cosmetic; would force
  re-registering the existing FVA callback).

## Testing

### Backend (`php artisan test`)
- **Gateway/factory:** `PaymentGatewayFactory::forMethod('qris')` returns
  `XenditQrisGateway` (no throw).
- **Intent creation:** `POST /api/v1/marketplace/purchases` with
  `payment_method=qris` and a mocked `XenditApiClient::createQrCode` → 200; the
  `Purchase` row has `payment_method=qris`, `xendit_qr_string` set,
  `xendit_callback_id` = the QR id, `xendit_fee_amount` = configured fee; the JSON
  response carries `qr_string` and `provider=automatic`.
- **Webhook confirm (real QR shape):** a `qris_paid` event built from the
  **captured nested envelope** (`data.qr_id`, `data.reference_id` = external_id,
  matching `data.amount`, `data.status = SUCCEEDED`) confirms the purchase;
  **amount mismatch** → failed; **qr_id mismatch** → failed; **non-success status**
  → ignored; duplicate event id → deduped. Keep a VA (flat) case in the same suite
  to prove BE-6a normalization handles both shapes.

### Frontend (`flutter analyze` + `flutter test`)
- `PaymentIntent.fromJson` parses `qr_string`.
- `CheckoutScreen` routes a `qris` intent to `/payment/qris/:id` (and VA to
  `/payment/va/:id`, manual to `/payment/manual/:id`).
- `QrisWaitingScreen` renders a `QrImageView` from `qrString`, shows the amount,
  and navigates on a `confirmed` status emission (mock the status provider).

## Verification (end-to-end, live)
On both emulators against local Herd: pick **QRIS** at checkout → QR screen
renders a scannable QR + countdown → simulate the QR payment via the Xendit test
API → webhook lands on the tunnel → confirmation runs **inline**
(`QUEUE_CONNECTION=sync`, no worker) → the status stream flips to `confirmed` →
screen auto-navigates to success. (Requires the public tunnel + a registered
QR-paid callback, same as VA testing.)
