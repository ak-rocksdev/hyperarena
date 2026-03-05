# HyperArena — Flutter API Contract

## Document Purpose

This document is a self-contained reference for implementing the Flutter mobile app against the HyperArena backend (Laravel API). It captures the full product context, every available API endpoint, authentication flow, data models, and conventions.

**Intended audience:** AI coding tools and developers working on the Flutter app at `D:\projects\Flutter\hyperarena`.

**Backend codebase:** `C:\laragon\www\hypercoach` (Laravel 12, being rebranded from HyperCoach to HyperArena).

---

## 1. Product Context

### What is HyperArena?

A multi-tenant sports platform that unifies coaching management, venue/arena discovery, and session booking. Originally two separate products:

- **HyperCoach** (web app, Laravel + Vue 3) — coaching school management with sessions, attendance, credit packages, progress tracking, and billing
- **HyperArena** (mobile app, Flutter) — sports marketplace for players, coaches, venues, and organizers

Both products are merging into one platform under the **HyperArena** brand. The Laravel backend serves both the Vue web dashboard and the Flutter mobile app via the same REST API.

### Architecture

```
┌─────────────────────────────────────────────┐
│            Laravel Backend (API)             │
│                                             │
│  /api/v1/auth/*       Authentication        │
│  /api/v1/admin/*      School/venue admin    │
│  /api/v1/coach/*      Coach operations      │
│  /api/v1/member/*     Player/member ops     │
│  /api/v1/platform/*   Super-admin (web)     │
│  /api/v1/arenas       Arena discovery       │
│  /api/v1/sports       Sports master data    │
│  /api/v1/notifications  In-app notifs       │
│                                             │
├──────────────┬──────────────────────────────┤
│              │                              │
│  Vue 3 SPA   │     Flutter Mobile App       │
│  (Web)       │     (Android + iOS)          │
│              │                              │
│  Cookie auth │     Bearer token auth        │
│  Subdomain   │     X-Tenant header          │
│  tenant res. │     tenant resolution        │
└──────────────┴──────────────────────────────┘
```

### User Roles

| Role | Description | Available On |
|---|---|---|
| `admin` | Manages a tenant (school owner, venue owner, organizer, solo coach) | Web + Mobile |
| `coach` | Conducts sessions, marks attendance, records progress | Web + Mobile |
| `member` | Participates in sessions (player, student, parent managing children) | Web + Mobile |
| `super-admin` | Platform operator, manages tenants and plans | Web only |

A user can hold multiple roles simultaneously and switch between them via `PUT /api/v1/auth/switch-role`.

### Tenant Types

Each tenant (organization) has a type that determines its features:

| Type | Example | Credit System | Curriculum | Venue Mgmt | Marketplace |
|---|---|---|---|---|---|
| `school` | Skate school | Yes | Yes | No | Optional |
| `venue` | Tennis club | Optional | No | Yes | Yes |
| `coach_practice` | Freelance coach | Optional | Yes | No | Yes |
| `organizer` | Session organizer | No | No | No | Yes |

---

## 2. Authentication

### Login Flow (Flutter)

```
POST /api/v1/auth/login
Headers:
  Content-Type: application/json
  X-Client-Type: mobile
  X-Tenant: {tenant_slug}        (required for tenant-scoped login)
  X-Device-Name: {device_info}   (optional, used as token name)

Body:
{
  "email": "user@example.com",
  "password": "password123"
}

Response (201):
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "+628123456789",
    "locale": "en",
    "active_role": "member",
    "tenant_id": 1,
    "roles": [
      { "name": "member" },
      { "name": "coach" }
    ],
    "permissions": [
      { "name": "view-sessions" },
      { "name": "book-sessions" },
      ...
    ],
    "tenant": {
      "id": 1,
      "name": "Joseph Skate School",
      "slug": "josephskate",
      "country": "MY",
      "city": "Kuala Lumpur",
      "timezone": "Asia/Kuala_Lumpur",
      "currency": "MYR",
      "default_locale": "en",
      "logo_path": "tenants/1/logo.png",
      "description": "Learn to skate!",
      "type": "school",
      "has_credit_system": true,
      "has_curriculum": true,
      "has_venue_management": false,
      "is_listed_on_marketplace": false
    },
    "student_account": null,
    "student_guardians": [
      {
        "id": 1,
        "student_profile_id": 3,
        "relationship": "parent",
        "is_primary": true
      }
    ]
  },
  "token": "1|abc123def456..."
}
```

### Token Lifecycle

1. **Obtain:** Login or register returns a `token` string
2. **Store:** Save in secure storage (Flutter `flutter_secure_storage`)
3. **Use:** Include in every request as `Authorization: Bearer {token}`
4. **Refresh user data:** `GET /api/v1/auth/me` — returns fresh user object
5. **Logout:** `POST /api/v1/auth/logout` — server deletes the token

### Registration Flow

```
POST /api/v1/auth/register
Headers:
  Content-Type: application/json
  X-Client-Type: mobile
  X-Tenant: {tenant_slug}

Body:
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone": "+628198765432",
  "password": "securepass123",
  "password_confirmation": "securepass123"
}

Response (201):
{
  "user": { ... },    // same structure as login
  "token": "2|xyz789..."
}
```

Registration auto-assigns the `member` role.

### All Auth Endpoints

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/api/v1/auth/login` | Public | Login, returns user + token |
| POST | `/api/v1/auth/register` | Public | Register, returns user + token |
| POST | `/api/v1/auth/logout` | Bearer | Delete token, logout |
| GET | `/api/v1/auth/me` | Bearer | Get current user with all relationships |
| PUT | `/api/v1/auth/switch-role` | Bearer | Switch active role `{ role: "coach" }` |
| PUT | `/api/v1/auth/profile` | Bearer | Update name, phone |
| PUT | `/api/v1/auth/password` | Bearer | Change password |
| PUT | `/api/v1/auth/locale` | Bearer | Set language `{ locale: "en" }` |
| POST | `/api/v1/auth/device-token` | Bearer | Register FCM token |
| DELETE | `/api/v1/auth/device-token` | Bearer | Remove FCM token |

---

## 3. Tenant Resolution

Flutter identifies which tenant to interact with via the `X-Tenant` header:

```
X-Tenant: josephskate
```

This header must be included on ALL requests to tenant-scoped endpoints (admin, coach, member routes). Public endpoints (arenas, sports, plans) do not require it.

The value is the tenant's `slug` field (the same string used as the subdomain on web: `josephskate.hyperarena.app`).

**Login flow:** The user must know their tenant slug to log in. The Flutter app can:
- Store the slug after first login
- Allow the user to enter their school/organization URL
- Browse the marketplace and discover tenants

---

## 4. Request & Response Conventions

### Headers for Every Request

```
Authorization: Bearer {token}        (for authenticated endpoints)
Content-Type: application/json
Accept: application/json
X-Client-Type: mobile                (identifies Flutter client)
X-Tenant: {slug}                     (for tenant-scoped endpoints)
```

### Response Format

All responses use named keys:

```json
{ "user": { ... } }
{ "coach": { ... } }
{ "session": { ... } }
{ "students": [ ... ] }
```

Never assume `response.data.data` — always read the named key.

### Pagination

Paginated endpoints return Laravel's pagination structure:

```json
{
  "data": [ ... ],
  "links": {
    "first": "...?page=1",
    "last": "...?page=5",
    "prev": null,
    "next": "...?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 5,
    "per_page": 15,
    "to": 15,
    "total": 73
  }
}
```

Use `?page=N` and `?per_page=N` query parameters.

### Monetary Values

All monetary values are **integers in the smallest currency unit** (cents, sen):
- `price: 5000` for MYR means RM 50.00 (divide by 100)
- `price: 150000` for IDR means Rp 150.000 (divide by 100, but IDR typically shows no decimals — format as `Rp 1.500`)

The currency string comes from the tenant or the record itself.

### Timestamps

All timestamps are **UTC** in the database. Convert to the tenant's timezone for display.

```json
{
  "start_at": "2026-03-10T09:00:00.000000Z",
  "created_at": "2026-03-05T14:30:00.000000Z"
}
```

Tenant timezone is available at `user.tenant.timezone` (e.g., `"Asia/Kuala_Lumpur"`).

### Date Fields

Date-only fields (no time component):

```json
{
  "date_of_birth": "2015-06-15",
  "effective_from": "2026-03-01"
}
```

### Relationship Names in JSON

Laravel serializes relationship names as **snake_case**:

```json
{
  "student_guardians": [...],
  "coach_rates": [...],
  "session_students": [...],
  "level_skills": [...]
}
```

### Error Responses

Validation errors (422):
```json
{
  "message": "The email field is required.",
  "errors": {
    "email": ["The email field is required."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

Auth errors (401):
```json
{
  "message": "Unauthenticated."
}
```

Permission errors (403):
```json
{
  "message": "Forbidden."
}
```

Subscription gate (403):
```json
{
  "message": "Active subscription required.",
  "code": "SUBSCRIPTION_REQUIRED"
}
```

Not found (404):
```json
{
  "message": "Tenant not found."
}
```

---

## 5. API Endpoints — Complete Reference

### 5.1 Public Endpoints (No Auth Required)

```
GET  /api/v1/school                                  Tenant landing page data
GET  /api/v1/plans                                   Available subscription plans
GET  /api/v1/plans?currency=MYR                      Plans filtered by currency
GET  /api/v1/public/countries                         Country list
GET  /api/v1/public/countries/{code}/cities           Cities with timezones
POST /api/v1/register-tenant/validate                 Validate field (slug, email)
POST /api/v1/register-tenant/validate-voucher         Check voucher code
POST /api/v1/register-tenant                          Full tenant registration
GET  /api/v1/sports                                   List all active sports
GET  /api/v1/arenas                                   Browse arenas (filterable)
GET  /api/v1/arenas/{id}                              Arena detail with sports
```

### 5.2 Admin Endpoints (Requires Bearer + X-Tenant)

**Dashboard:**
```
GET  /api/v1/admin/dashboard
```
Returns: `{ stats, today_sessions, recent_activity }`

**Coaches:**
```
GET    /api/v1/admin/coaches                          Paginated list
POST   /api/v1/admin/coaches                          Create coach + rate
GET    /api/v1/admin/coaches/{id}                     Detail
PUT    /api/v1/admin/coaches/{id}                     Update
PATCH  /api/v1/admin/coaches/{id}/deactivate          Toggle status
GET    /api/v1/admin/coaches/{coachId}/rates           Rate history
POST   /api/v1/admin/coaches/{coachId}/rates           Add new rate
```

**Products:**
```
GET    /api/v1/admin/products                         Paginated, filterable
POST   /api/v1/admin/products                         Create
GET    /api/v1/admin/products/{id}                    Detail
PUT    /api/v1/admin/products/{id}                    Update
PATCH  /api/v1/admin/products/{id}/deactivate         Toggle
```

**Students:**
```
GET    /api/v1/admin/students                         List (optional ?include_balance=1)
POST   /api/v1/admin/students                         Create with optional guardian
GET    /api/v1/admin/students/{id}                    Detail
PUT    /api/v1/admin/students/{id}                    Update
```

**Sessions:**
```
GET    /api/v1/admin/sessions                         Filterable (date, coach, type, status)
POST   /api/v1/admin/sessions                         Create (with conflict check)
GET    /api/v1/admin/sessions/{id}                    Detail with students/attendance
PUT    /api/v1/admin/sessions/{id}                    Update
PATCH  /api/v1/admin/sessions/{id}/cancel             Cancel (with credit reversal)
PATCH  /api/v1/admin/sessions/{id}/complete           Mark complete (triggers payout)
POST   /api/v1/admin/sessions/{id}/students           Add student
DELETE /api/v1/admin/sessions/{sessionId}/students/{studentId}  Remove student
```

**Purchases:**
```
GET    /api/v1/admin/purchases                        Filterable (status, student, date)
GET    /api/v1/admin/purchases/pending-count           Badge count
GET    /api/v1/admin/purchases/{id}                   Detail
POST   /api/v1/admin/purchases                        Admin-create (auto-confirms)
PATCH  /api/v1/admin/purchases/{id}/confirm            Confirm payment
PATCH  /api/v1/admin/purchases/{id}/cancel             Cancel
```

**Credits:**
```
GET    /api/v1/admin/credits                          Full ledger with summary
GET    /api/v1/admin/students/{id}/credits             Student ledger
GET    /api/v1/admin/students/{id}/credits/balance     Student balance
POST   /api/v1/admin/credits/adjust                   Manual adjustment
```

**Payouts:**
```
GET    /api/v1/admin/payouts                          Filterable (period, coach, status)
GET    /api/v1/admin/payouts/summary                  Aggregate by coach
PATCH  /api/v1/admin/payouts/{id}/approve              Approve
PATCH  /api/v1/admin/payouts/{id}/mark-paid            Mark paid
PATCH  /api/v1/admin/payouts/bulk-approve              Bulk approve
PATCH  /api/v1/admin/payouts/bulk-mark-paid            Bulk mark paid
```

**Curriculum (Programs, Levels, Skills):**
```
GET    /api/v1/admin/programs                         List
POST   /api/v1/admin/programs                         Create
GET    /api/v1/admin/programs/{id}                    Detail with levels
PUT    /api/v1/admin/programs/{id}                    Update
DELETE /api/v1/admin/programs/{id}                    Delete (if no enrollments)
GET    /api/v1/admin/programs/{programId}/levels       List levels
POST   /api/v1/admin/programs/{programId}/levels       Create level
GET    /api/v1/admin/programs/{programId}/levels/{id}  Level detail
PUT    /api/v1/admin/programs/{programId}/levels/{id}  Update level
DELETE /api/v1/admin/programs/{programId}/levels/{id}  Delete level
GET    /api/v1/admin/skills                           All skills
POST   /api/v1/admin/skills                           Create skill
GET    /api/v1/admin/skills/{id}                      Skill detail
PUT    /api/v1/admin/skills/{id}                      Update
DELETE /api/v1/admin/skills/{id}                      Delete (if unassigned)
GET    /api/v1/admin/levels/{levelId}/skills           Level-skill assignments
POST   /api/v1/admin/levels/{levelId}/skills           Assign skill to level
PUT    /api/v1/admin/levels/{levelId}/skills/sync      Bulk replace
PUT    /api/v1/admin/levels/{levelId}/skills/reorder   Reorder
DELETE /api/v1/admin/levels/{levelId}/skills/{id}      Remove assignment
```

**Enrollments:**
```
GET    /api/v1/admin/enrollments                      Filterable (program, student, status)
POST   /api/v1/admin/enrollments                      Enroll student
GET    /api/v1/admin/enrollments/{id}                 Detail
PUT    /api/v1/admin/enrollments/{id}                 Update level/status
```

**Users:**
```
GET    /api/v1/admin/users                            Search/filter by role
POST   /api/v1/admin/users                            Create with roles
GET    /api/v1/admin/users/{id}                       Detail
PUT    /api/v1/admin/users/{id}                       Update
POST   /api/v1/admin/users/{id}/roles                 Add role
DELETE /api/v1/admin/users/{id}/roles/{role}           Remove role
POST   /api/v1/admin/users/{id}/guardians              Link to student
DELETE /api/v1/admin/users/{id}/guardians/{guardianId} Unlink
POST   /api/v1/admin/users/{id}/student-account        Create self-managed link
DELETE /api/v1/admin/users/{id}/student-account        Remove self-managed link
```

**Settings:**
```
GET    /api/v1/admin/settings                         Tenant settings
PUT    /api/v1/admin/settings                         Update settings + logo
```

**Billing:**
```
GET    /api/v1/admin/billing                          Billing overview
GET    /api/v1/admin/billing/plans                    Available plans
POST   /api/v1/admin/billing/subscribe                Subscribe to plan
PATCH  /api/v1/admin/billing/cancel                   Cancel subscription
POST   /api/v1/admin/billing/redeem-voucher           Redeem voucher code
POST   /api/v1/admin/billing/upload-proof             Upload payment proof
GET    /api/v1/admin/billing/usage                    Current usage
GET    /api/v1/admin/billing/plan-usage               Plan limits vs usage
GET    /api/v1/admin/billing/invoices/{invoice}/pdf   Download invoice PDF
```

**Arenas (admin):**
```
POST   /api/v1/admin/arenas/{id}/claim                Claim arena for tenant
```

### 5.3 Coach Endpoints (Requires Bearer + X-Tenant)

```
GET    /api/v1/coach/sessions                         Own sessions (filterable)
GET    /api/v1/coach/sessions/{id}                    Session detail
GET    /api/v1/coach/sessions/{sessionId}/attendance   Attendance list
POST   /api/v1/coach/sessions/{sessionId}/attendance   Mark single
POST   /api/v1/coach/sessions/{sessionId}/attendance/bulk  Mark multiple
PUT    /api/v1/coach/sessions/{sessionId}/attendance/{id}  Update status
GET    /api/v1/coach/sessions/{sessionId}/progress     Progress entries
POST   /api/v1/coach/sessions/{sessionId}/progress     Record progress
POST   /api/v1/coach/sessions/{sessionId}/progress/copy-from-last  Copy previous
GET    /api/v1/coach/enrollments                      Student enrollments
POST   /api/v1/coach/enrollments                      Enroll student
PUT    /api/v1/coach/enrollments/{id}                 Update enrollment
PUT    /api/v1/coach/enrollments/{id}/withdraw         Withdraw student
GET    /api/v1/coach/programs                         Active programs (read-only)
GET    /api/v1/coach/programs/{id}/levels              Levels for program
GET    /api/v1/coach/levels/{levelId}/skills           Skills for level
GET    /api/v1/coach/payouts                          Own payout history
```

### 5.4 Member Endpoints (Requires Bearer + X-Tenant)

```
GET    /api/v1/member/students                        Own children + self-managed
POST   /api/v1/member/students                        Add child
GET    /api/v1/member/students/{id}                   Student detail
PUT    /api/v1/member/students/{id}                   Update student
GET    /api/v1/member/sessions/available               Bookable sessions
GET    /api/v1/member/bookings                        Upcoming bookings
GET    /api/v1/member/bookings/history                 Past bookings
POST   /api/v1/member/bookings                        Book session
DELETE /api/v1/member/bookings/{id}                   Cancel booking
GET    /api/v1/member/products                        Available packages
GET    /api/v1/member/purchases                       Own purchases
POST   /api/v1/member/purchases                       Create purchase
POST   /api/v1/member/purchases/{id}/proof             Upload payment proof
GET    /api/v1/member/students/{id}/credits            Credit ledger
GET    /api/v1/member/students/{id}/credits/balance    Credit balance
GET    /api/v1/member/students/{id}/progress           Progress timeline
GET    /api/v1/member/students/{id}/progress/monthly   Monthly report
```

### 5.5 Notification Endpoints (Requires Bearer, no X-Tenant needed)

```
GET    /api/v1/notifications                          Paginated list
GET    /api/v1/notifications/unread-count              Badge count
PATCH  /api/v1/notifications/{id}/read                 Mark read
PATCH  /api/v1/notifications/read-all                  Mark all read
```

### 5.6 Utility Endpoints

```
GET    /api/v1/subscription-status                    Tenant subscription status (any role)
```

---

## 6. Data Models — Dart Mapping Reference

These are the key backend models and how they serialize to JSON. Use this to build Dart/Freezed model classes.

### User

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+628123456789",
  "locale": "en",
  "active_role": "member",
  "tenant_id": 1,
  "created_at": "2026-03-01T10:00:00.000000Z",
  "roles": [{ "name": "member" }],
  "permissions": [{ "name": "view-sessions" }, { "name": "book-sessions" }],
  "tenant": { ... },
  "student_guardians": [{ ... }],
  "student_account": null
}
```

### Tenant

```json
{
  "id": 1,
  "name": "Joseph Skate School",
  "slug": "josephskate",
  "country": "MY",
  "city": "Kuala Lumpur",
  "timezone": "Asia/Kuala_Lumpur",
  "currency": "MYR",
  "default_locale": "en",
  "logo_path": "tenants/1/logo.png",
  "description": "Learn to skate with us!",
  "type": "school",
  "has_venue_management": false,
  "has_credit_system": true,
  "has_curriculum": true,
  "is_listed_on_marketplace": false,
  "accepted_payment_modes": ["credits"],
  "onboarding_completed_at": "2026-02-15T08:00:00.000000Z"
}
```

### Coach

```json
{
  "id": 1,
  "tenant_id": 1,
  "user_id": 2,
  "bio": "10 years skating experience",
  "status": "active",
  "current_rate": {
    "id": 3,
    "rate_per_session": 8000,
    "currency": "MYR",
    "effective_from": "2026-03-01"
  },
  "user": {
    "id": 2,
    "name": "Coach Mike",
    "email": "mike@example.com",
    "phone": "+628111222333"
  },
  "coach_rates": [{ ... }, { ... }]
}
```

### Session (coaching_sessions table)

```json
{
  "id": 1,
  "tenant_id": 1,
  "coach_id": 1,
  "type": "group",
  "start_at": "2026-03-10T09:00:00.000000Z",
  "duration_minutes": 60,
  "capacity": 8,
  "status": "scheduled",
  "notes": "Beginner group session",
  "booked_count": 5,
  "coach": { ... },
  "session_students": [
    {
      "id": 1,
      "student_profile_id": 3,
      "booked_at": "2026-03-08T14:00:00.000000Z",
      "cancelled_at": null,
      "student_profile": { ... }
    }
  ],
  "attendances": [{ ... }]
}
```

### StudentProfile

```json
{
  "id": 3,
  "tenant_id": 1,
  "first_name": "Alex",
  "last_name": "Doe",
  "date_of_birth": "2015-06-15",
  "photo_path": null,
  "notes": null,
  "credit_balance": 8
}
```

### Product

```json
{
  "id": 1,
  "name": "Group 8-Session Package",
  "description": "8 group skating sessions",
  "type": "group_package",
  "session_type": "group",
  "price": 24000,
  "currency": "MYR",
  "credit_amount": 8,
  "is_active": true
}
```

### CreditLedger Entry

```json
{
  "id": 1,
  "tenant_id": 1,
  "student_profile_id": 3,
  "amount": -1,
  "type": "deduction",
  "reference_type": "attendance",
  "reference_id": 5,
  "notes": "Session #12 attendance",
  "expires_at": null,
  "created_at": "2026-03-10T10:00:00.000000Z"
}
```

### Attendance

```json
{
  "id": 5,
  "session_id": 1,
  "student_profile_id": 3,
  "status": "present",
  "marked_by": 2,
  "marked_at": "2026-03-10T09:15:00.000000Z"
}
```

### Payout

```json
{
  "id": 1,
  "coach_id": 1,
  "session_id": 1,
  "rate_applied": 8000,
  "currency": "MYR",
  "amount": 8000,
  "status": "pending",
  "period": "2026-03",
  "approved_by": null,
  "approved_at": null,
  "paid_at": null
}
```

### Arena

```json
{
  "id": 1,
  "tenant_id": null,
  "name": "Taman Skatepark BSD",
  "address": "Jl. BSD Raya No.10",
  "city": "Tangerang Selatan",
  "country_code": "ID",
  "latitude": -6.3024,
  "longitude": 106.6524,
  "description": "Public skatepark with halfpipe and rails",
  "type": "public",
  "status": "unclaimed",
  "is_free_access": true,
  "facilities": {
    "parking": true,
    "lighting": true,
    "restroom": false
  },
  "photos": ["arenas/1/photo1.jpg"],
  "created_by_user_id": 5,
  "claimed_by_user_id": null,
  "claimed_at": null,
  "sports": [
    {
      "id": 5,
      "name": "Skateboard",
      "slug": "skateboard",
      "icon": "skateboard",
      "category": "board",
      "pivot": {
        "attributes": {
          "obstacles": ["halfpipe", "rail", "bowl"],
          "skill_level": "all_levels"
        }
      }
    }
  ]
}
```

### Sport

```json
{
  "id": 1,
  "name": "Tennis",
  "slug": "tennis",
  "icon": "tennis",
  "category": "racket",
  "description": "Court-based racket sport",
  "is_active": true,
  "sort_order": 1
}
```

### Notification

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "type": "App\\Notifications\\BookingConfirmation",
  "data": {
    "type": "booking_confirmed",
    "session_id": 1,
    "student_name": "Alex Doe",
    "session_type": "group",
    "start_at": "2026-03-10T09:00:00.000000Z",
    "message": "Booking confirmed for Alex Doe on March 10 at 09:00"
  },
  "read_at": null,
  "created_at": "2026-03-08T14:00:00.000000Z"
}
```

---

## 7. Push Notifications (FCM)

### Device Token Registration

After login, register the FCM token:

```
POST /api/v1/auth/device-token
Headers: Authorization: Bearer {token}

Body:
{
  "token": "fcm_registration_token_string",
  "platform": "android",
  "device_name": "Samsung Galaxy S24"
}

Response (201):
{
  "device_token": {
    "id": 1,
    "token": "fcm_...",
    "platform": "android",
    "device_name": "Samsung Galaxy S24"
  }
}
```

On logout, remove the token:

```
DELETE /api/v1/auth/device-token
Body: { "token": "fcm_registration_token_string" }
```

### FCM Payload Structure

All push notifications include a `data` field for deep linking:

```json
{
  "notification": {
    "title": "Booking Confirmed",
    "body": "Booking confirmed for Alex Doe on March 10 at 09:00"
  },
  "data": {
    "type": "booking_confirmed",
    "session_id": "1",
    "student_name": "Alex Doe"
  }
}
```

### Notification Types and Navigation Targets

| `data.type` | Data Fields | Navigate To |
|---|---|---|
| `booking_confirmed` | `session_id`, `student_name` | Session detail screen |
| `session_reminder` | `session_id`, `session_type`, `start_at` | Session detail screen |
| `purchase_confirmed` | `purchase_id`, `credits_added`, `student_name` | Credit ledger screen |
| `payout_approved` | `payout_id`, `amount`, `currency`, `period` | Payout list screen |
| `payment_rejected` | `subscription_id`, `reason` | Billing/subscription screen |
| `progress_updated` | `session_id`, `student_name`, `progress_status` | Progress detail screen |

---

## 8. Key Business Logic Reference

### Credit System

- Credits are tracked via a **ledger** (every movement is a row)
- Balance = SUM of all non-expired ledger entries for a student
- Positive amounts = credits added (purchase, adjustment)
- Negative amounts = credits deducted (attendance, adjustment)
- Credits deducted automatically when coach marks attendance as "present" or "late"
- Credits can expire (tenant-configurable via `credit_expiry_enabled` and `credit_expiry_days`)

### Session Lifecycle

```
scheduled → completed (all attendance marked, auto-completes)
scheduled → cancelled (admin cancels, credits reversed for attended students)
```

### Purchase Lifecycle

```
pending_payment → confirmed (admin confirms, credits allocated)
pending_payment → cancelled (admin cancels)
```

### Payout Lifecycle

```
pending → approved (admin approves) → paid (admin marks paid)
```

### Attendance → Credit Deduction Flow

```
Coach marks student "present" or "late"
  → AttendanceMarked event fires
  → DeductCreditOnAttendance listener runs
  → CreditService::deductCredit() creates -1 ledger entry
  → If student has 0 credits: attendance still recorded, flagged for admin
```

### Booking Rules

- Group sessions: capacity check (booked_count < capacity)
- No double-booking same student for same session
- Cancelled bookings can be reactivated

---

## 9. File Upload Endpoints

Several endpoints accept file uploads as multipart form data:

| Endpoint | Field Name | Max Size | Accepted Types |
|---|---|---|---|
| `PUT /api/v1/admin/settings` | `logo` | 2MB | image/* |
| `POST /api/v1/member/purchases/{id}/proof` | `proof` | 5MB | image/* |
| `POST /api/v1/admin/billing/upload-proof` | `proof` | 5MB | image/* |

Flutter should use `MultipartFile` with Dio for these uploads.

---

## 10. Internationalization

The API supports 3 languages: English (en), Bahasa Indonesia (id), Bahasa Melayu (ms).

- Validation error messages are returned in the user's `locale`
- Notification messages are translated
- The user's locale is set via `PUT /api/v1/auth/locale`
- Flutter should send `Accept-Language: {locale}` header for proper error message language

---

## 11. Current Flutter App State

**Location:** `D:\projects\Flutter\hyperarena`
**Status:** UI-complete with mock data (207 Dart files)

**Architecture:**
- State management: Riverpod 2.6.1
- Routing: GoRouter 14.8.1
- Serialization: Freezed 2.5.8 + JsonSerializable
- Networking: Dio 5.7.0 (installed but not wired up)
- Local storage: SharedPreferences

**What exists:**
- All screens for 4 roles (player, coach, organizer, court owner)
- 50+ routes with auth guards
- Abstract repository interfaces for all features
- Mock repository implementations with realistic test data
- Freezed model classes (partially matching the API — will need updating)

**What needs to happen:**
1. Update Freezed models to match the API JSON structures documented above
2. Create a Dio HTTP client with auth interceptor (Bearer token, X-Tenant, X-Client-Type headers)
3. Implement real repository classes that call the API instead of returning mock data
4. Add secure token storage (flutter_secure_storage)
5. Add FCM integration (firebase_messaging package)
6. Handle notification deep linking (navigate to correct screen based on FCM data.type)
7. Add tenant selection/discovery flow (user enters their organization slug or browses marketplace)

---

*Document created: 2026-03-05*
*Based on backend audit of HyperCoach Laravel API (51 endpoints, 30 models, 8 services)*
*Backend plan: `docs/plans/2026-03-05-flutter-backend-readiness-design.md`*
