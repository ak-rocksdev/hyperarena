# Mobile Session Join & Payment Design

## Overview

Enable mobile users to join marketplace sessions through a streamlined flow that abstracts the underlying credit system. Users see a price, tap "Gabung," and either use existing credits instantly or pay via bank transfer — all in one seamless process.

## Architecture: Hybrid Orchestration (Approach 3)

New marketplace-scoped endpoints that internally orchestrate existing backend services (`BookingService`, `PurchaseService`, `CreditService`). No duplication of business logic.

---

## Backend

### Enriched Session Detail Endpoint

**`GET /v1/marketplace/sessions/{id}`** (auth required)

Returns everything the mobile detail screen needs in one call:

```json
{
  "session": {
    "id": 42,
    "name": "Badminton Sore",
    "type": "group",
    "start_at": "2026-03-28T16:00:00Z",
    "duration_minutes": 60,
    "capacity": 8,
    "booked_count": 5,
    "notes": "Bawa raket sendiri",
    "venue": { "name": "...", "location": { "..." } },
    "coaches": [{ "id": 1, "user": { "name": "Coach A", "photo_urls": {} } }],
    "participants": [
      { "id": 10, "name": "Haris Kelana", "booked_at": "2026-03-27T08:00:00Z" },
      { "id": 11, "name": "Rina Putri", "booked_at": "2026-03-27T09:00:00Z" }
    ]
  },
  "pricing": {
    "product_id": 15,
    "price": 75000,
    "currency": "IDR",
    "label": "Group Single Session"
  },
  "user_status": {
    "credit_balance": 2,
    "is_booked": false,
    "booking_id": null
  },
  "tenant_payment": {
    "bank_name": "BCA",
    "account_number": "1234567890",
    "account_holder": "PT HyperArena",
    "payment_instructions": "Sertakan kode booking di berita acara"
  }
}
```

Key behaviors:
- `pricing` resolved from `Products` table by matching tenant + `session_type` + `*_single` type. If no matching product exists, return 422: "Tenant belum mengatur harga sesi"
- `user_status.credit_balance` is the user's current non-expired credit balance for this tenant
- `tenant_payment` always included (bank info required for tenant to sell sessions)
- If user already booked, `is_booked: true` so mobile shows "Sudah Terdaftar"
- `participants` returns `SessionParticipant` objects with `{ id, name, booked_at }` — consistent with the existing list endpoint model

**Note:** This enriched response has a different shape than the list endpoint (`GET /v1/marketplace/sessions`). The Flutter app uses a dedicated `MarketplaceSessionDetail` Freezed model to parse this composite response, separate from the existing `MarketplaceSession` model used for the list.

### Join Session Endpoint

**`POST /v1/marketplace/sessions/{id}/join`** (auth required)

Request body: empty (credits) or multipart with `payment_proof` (future optimization).

**All operations are wrapped in a database transaction** to prevent orphaned records (e.g., purchase created but booking fails).

Backend orchestration:

```
DB::transaction(function () {
  1. Resolve or auto-create StudentProfile for (user, tenant)
  2. Check credit balance via CreditService

  IF balance >= 1:
    - BookingService.bookSession(studentProfileId, sessionId)
    - CreditService.deductCredit(studentProfileId, 'booking', sessionStudentId)
    - Return: { status: "confirmed", used_credit: true }

  IF balance == 0:
    - Find matching Product (tenant + session_type + single)
      - If no product found: abort with 422 "Tenant belum mengatur harga sesi"
    - PurchaseService.createPurchase(studentProfileId, productId)
    - BookingService.bookSession(studentProfileId, sessionId)
      - booking marked as "pending_payment"
    - Return: { status: "pending_payment", purchase_id: 99, used_credit: false }
})
```

Response — credit used (instant):
```json
{
  "status": "confirmed",
  "used_credit": true,
  "credit_balance_after": 1,
  "message": "Kamu bergabung menggunakan 1 kredit yang tersedia",
  "booking": {
    "id": 201,
    "session_id": 42,
    "booked_at": "2026-03-28T10:00:00Z"
  }
}
```

Response — payment needed:
```json
{
  "status": "pending_payment",
  "used_credit": false,
  "purchase_id": 99,
  "expires_at": "2026-03-28T10:30:00Z",
  "message": "Silakan lakukan pembayaran untuk menyelesaikan pendaftaran",
  "booking": {
    "id": 201,
    "session_id": 42,
    "booked_at": "2026-03-28T10:00:00Z"
  }
}
```

Note: `expires_at` is set to 30 minutes from creation. The mobile payment countdown timer derives from this field rather than hardcoding a duration. If the user reopens the payment screen, the remaining time is accurate.

### Upload Payment Proof

**`POST /v1/marketplace/purchases/{id}/proof`** (auth required)

Reuses existing `PurchaseController@uploadProof` logic. After admin confirms, `PurchaseConfirmed` event triggers credit allocation + deduction.

### Validations

- Session must be `scheduled` and not started
- Session not full
- User not already booked
- Tenant must have bank info configured (else 422: "Tenant belum mengatur pembayaran")
- Matching product must exist for the session type (else 422: "Tenant belum mengatur harga sesi")

### Error responses

| Condition | HTTP | Message |
|-----------|------|---------|
| Session full | 422 | "Sesi sudah penuh" |
| Already booked | 422 | "Kamu sudah terdaftar di sesi ini" |
| Session started/completed | 422 | "Sesi sudah dimulai atau selesai" |
| No bank info | 422 | "Tenant belum mengatur pembayaran" |
| No matching product | 422 | "Tenant belum mengatur harga sesi" |
| Network failure mid-join | Rolled back via DB transaction. Client shows: "Gagal bergabung, coba lagi" |

### StudentProfile Auto-Creation

When a mobile user joins a session for a tenant they haven't interacted with before, the backend silently auto-creates a `StudentProfile` under that tenant. The user never sees or knows about this — it's an internal implementation detail to keep existing services working.

### Session Cancellation & Credit Refund

New event: `SessionCancelled` triggers a listener that:
- Iterates all `session_students` for the cancelled session
- For confirmed bookings (credit or transfer): refunds 1 credit each via `CreditService.addCredits(type: 'refund')`. Note: refund is always in credits, not monetary. For transfer-paid bookings, the organizer handles actual bank refunds outside the system if needed.
- Pending-payment bookings: auto-cancels the purchase, no credit movement needed
- Sends push notification: "Sesi dibatalkan — 1 kredit dikembalikan"

### Payment Expiry

Backend cron job (Laravel scheduler) runs periodically to expire stale purchases:
- Purchases with `status = pending_payment` where `created_at + 30 minutes < now()`
- Sets `status = cancelled`, cancels the associated `session_student` booking, frees the slot

### Tenant Validation at Session Creation

When an organizer creates a session, the backend must validate that the tenant has bank account info configured (`payment_bank_name`, `payment_account_number`, `payment_account_holder`). Sessions cannot be listed on the marketplace without this.

---

## Organizer — Session Payment Management

### Participant List with Payment Status

On the organizer's session detail screen, a section showing all participants with payment status.

**`GET /v1/organizer/sessions/{id}/participants`**

```json
{
  "participants": [
    {
      "student_name": "Haris Kelana",
      "student_avatar_url": null,
      "booking_id": 201,
      "booked_at": "2026-03-28T10:00:00Z",
      "payment_status": "confirmed_credit",
      "payment_method": "credit",
      "purchase_id": null,
      "payment_proof_url": null,
      "amount_paid": null,
      "currency": null
    },
    {
      "student_name": "Budi Santoso",
      "student_avatar_url": null,
      "booking_id": 203,
      "booked_at": "2026-03-28T10:30:00Z",
      "payment_status": "pending_confirmation",
      "payment_method": "bank_transfer",
      "purchase_id": 99,
      "payment_proof_url": "https://...",
      "amount_paid": 75000,
      "currency": "IDR"
    }
  ]
}
```

All participant entries have the same shape. `amount_paid` and `currency` are null for credit-based bookings.

### Payment statuses

| Status | Label | Color | Description |
|--------|-------|-------|-------------|
| `confirmed_credit` | Dikonfirmasi - Kredit | Green | Used existing credit, auto-confirmed |
| `pending_payment` | Belum Bayar | Orange | Joined but no proof uploaded |
| `pending_confirmation` | Menunggu Konfirmasi | Yellow | Proof uploaded, awaiting organizer |
| `confirmed_transfer` | Dikonfirmasi - Transfer | Green | Organizer confirmed payment |
| `rejected` | Ditolak | Red | Organizer rejected proof |

### Organizer actions

- **"Lihat Bukti"** — full-screen image of payment proof
- **"Konfirmasi"** — `PATCH /v1/organizer/purchases/{id}/confirm` (wraps `PurchaseService.confirmPurchase()`)
- **"Tolak"** — `PATCH /v1/organizer/purchases/{id}/reject` (wraps `PurchaseService.cancelPurchase()`)

Organizer-scoped routes reuse the same services as admin, scoped to their own tenant's sessions.

---

## Mobile App — UI Flow

### Session Detail Screen (MarketplaceSessionDetailScreen)

**Routing change:** The current route passes a `MarketplaceSession` object via GoRouter `extra`. This must change to a path-parameter-based approach (`MarketplaceSessionDetailScreen(sessionId: id)`) so the screen fetches enriched data from the API. This is required for push notification deep-links which only have a session ID, not a full object.

**New screens** (separate from existing `SessionPaymentScreen`/`SessionConfirmationScreen` which use different state):
- `MarketplaceSessionPaymentScreen` — for the bank transfer payment flow
- `MarketplaceSessionConfirmationScreen` — for the credit-used success screen

New route constants in `AppRoutes`:
- `marketplaceSessionPayment`
- `marketplaceSessionConfirmation`

Based on the original design from commit `55092a5`:

- **Participants as horizontal `Wrap` grid** — circle avatars with initials, wrapping to next row. Host gets star badge. Empty slots shown as dashed circles (not selectable).
- **Bottom bar** — "Biaya per orang" + price from `pricing.price` + action button
- **Button states:**
  - `is_booked == true` → "Sudah Terdaftar" (disabled, success color)
  - Session full → "Sesi Penuh" (disabled)
  - `credit_balance >= 1` → "Gabung Sekarang" (with subtle badge: "1 kredit tersedia")
  - `credit_balance == 0` → "Gabung Sekarang" (normal)

### Credit Reminder Dialog

When `credit_balance >= 1` and user taps "Gabung Sekarang," show a confirmation bottom sheet:

> **Gunakan Kredit?**
> Kamu punya **2 kredit** tersedia. 1 kredit akan digunakan untuk bergabung di sesi ini. Tidak perlu melakukan pembayaran.
>
> _Kredit bisa dikembalikan jika sesi dibatalkan oleh penyelenggara._
>
> [ Batal ] [ **Gabung** ]

Tapping "Gabung" calls `POST /join` and navigates to Confirmation Screen.

### Payment Flow (credit_balance == 0)

1. **Payment Screen** — countdown timer derived from `expires_at` in join response (not hardcoded). Shows price + session name. **Bank transfer only** (QRIS tab hidden until tenant QRIS support is added). Displays tenant bank details (`bank_name`, `account_number`, `account_holder`) and `payment_instructions` prominently below the bank details. "Upload Bukti Pembayaran" button opens camera/gallery. After upload calls `POST /purchases/{id}/proof`.

2. **Waiting Confirmation Screen** — "Bukti pembayaran terkirim. Menunggu konfirmasi dari penyelenggara." Back to Explore button.

3. **Push notification** when admin confirms. Deep link to session detail showing "Sudah Terdaftar."

### Confirmation Screen (credit path)

Animated success screen from original design:
- Animated checkmark
- Session summary card (name, venue, date/time, price)
- "Berhasil Bergabung! 1 kredit telah digunakan."
- "Kembali ke Explore" + "Kembali ke Beranda" buttons

### Network Error Handling

If the join call fails due to network error, show: "Gagal bergabung. Periksa koneksi internet dan coba lagi." Since the backend wraps everything in a transaction, partial state is impossible — safe to retry.

---

## Flutter Models to Create

| Model | File | Purpose |
|-------|------|---------|
| `MarketplaceSessionDetail` | `lib/features/session/data/models/marketplace_session_detail.dart` | Parses the enriched detail endpoint response (session + pricing + user_status + tenant_payment) |
| `SessionPricing` | (nested in above) | `product_id`, `price`, `currency`, `label` |
| `UserSessionStatus` | (nested in above) | `credit_balance`, `is_booked`, `booking_id` |
| `TenantPaymentInfo` | `lib/features/session/data/models/tenant_payment_info.dart` | `bank_name`, `account_number`, `account_holder`, `payment_instructions`. Separate from existing `PaymentMethodInfo` which has different fields (`id`, `type`, `qrisImageUrl`) |
| `SessionJoinResponse` | `lib/features/session/data/models/session_join_response.dart` | `status`, `used_credit`, `credit_balance_after` (nullable — null for payment path), `purchase_id` (nullable), `expires_at` (nullable), `message`, `booking` |
| `JoinBookingInfo` | (nested in above) | `id`, `session_id`, `booked_at` — small Freezed class for the nested booking object |

---

## Push Notification Types

Add `sessionCancelled`, `paymentConfirmed`, `paymentRejected` to the `NotificationType` enum in `notification_item.dart`.

Update `NotificationRouteResolver` — note that the existing `payment_rejected` handler routes to `AppRoutes.notifications`; it should be updated to route to the session detail screen instead.

| Type | Route | Message |
|------|-------|---------|
| `sessionCancelled` | Session detail (by session ID) | "Sesi dibatalkan — 1 kredit dikembalikan" |
| `paymentConfirmed` | Session detail (by session ID) | "Pembayaran dikonfirmasi! Kamu terdaftar di sesi X" |
| `paymentRejected` | Session detail (by session ID) | "Pembayaran ditolak. Silakan coba lagi" |

---

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| User has credits from web | Credit reminder dialog, instant join, no payment |
| Session cancelled by organizer | Auto-refund 1 credit to confirmed participants (always in credits, not monetary). Pending-payment bookings auto-cancelled. Push notification sent |
| User tries to join full session | 422 from backend. Button already disabled on client |
| User already booked | Button shows "Sudah Terdaftar." Endpoint returns 422 if called anyway |
| Payment proof rejected | Push notification. Booking cancelled, slot freed. User can re-join |
| 30-min payment timer expires | Purchase auto-expired by backend cron. Booking cancelled, slot freed |
| Tenant has no bank info | Session not listed on marketplace (validation at session creation) |
| No matching product for session type | 422 from backend. Should not happen if tenant setup is correct |
| User switches tenants | New StudentProfile auto-created per tenant. Credits are tenant-scoped |
| Credit expiry | Follows tenant's `credit_expiry_enabled` + `credit_expiry_days`. Expired credits excluded from balance |
| Non-attendance | Credit stays deducted. No refund for non-attendance |
| User self-cancellation | Not supported. User must contact organizer |
| Network failure during join | DB transaction rolled back. Client shows retry message. Safe to retry |

## Out of Scope (Future)

- QRIS payment support (tenant upload QR code)
- User self-cancellation with configurable refund policy
- Payment gateway integration
- In-app credit package purchase
- Configurable cancellation policy per tenant/session
