# Marketplace API — Design Spec

## Overview

HyperArena is a marketplace app where users browse venues, sessions, and coaches **across all tenants/clubs**. The existing Laravel backend (HyperCoach) is tenant-scoped — each club sees only its own data. This spec defines new **cross-tenant marketplace endpoints** for the HyperArena mobile app, plus Flutter-side integration to replace mock data with real API calls.

**Goal:** Wire the Flutter Explore screen (3 tabs: Lapangan, Coach, Sesi) to real backend data via dedicated marketplace API endpoints.

**Not in scope:** Rating/review system, venue price ranges, skill level tags, venue claiming flow. These are separate future phases.

---

## Architecture

### Approach: Dedicated Marketplace Module

New route group, controllers, and service — fully isolated from existing tenant-scoped code.

```
Routes:      api/v1/marketplace/*
Middleware:   auth:sanctum (authenticated, no tenant resolution)
Namespace:   App\Http\Controllers\Marketplace
Service:     App\Services\MarketplaceService
```

**Why separate:**
- No interference with existing tenant-scoped web app endpoints
- No `X-Tenant` header required — these are cross-tenant by design
- Clear boundary: any developer sees `Marketplace\*` and knows it's for the mobile app

**X-Tenant header handling:** The Flutter `ApiInterceptor` may attach `X-Tenant` if the user has a tenant slug set. The backend marketplace routes do NOT use `resolve.tenant` middleware, so any `X-Tenant` header sent is simply ignored. No special handling needed on either side.

**Docblock convention** on every controller:
```php
/**
 * @group Mobile App — Marketplace
 *
 * Cross-tenant marketplace endpoints for the HyperArena mobile app.
 * These endpoints do not require X-Tenant header.
 */
```

### Error Handling

All endpoints follow standard Laravel error responses:
- `401` — Unauthenticated (missing/invalid bearer token)
- `404` — Resource not found (`findOrFail`)
- `422` — Validation error (invalid params)
- `500` — Server error

Query param validation per endpoint:
- `sport_id`: integer, must exist in `sports` table (if provided)
- `per_page`: integer, range 1–50 (default 15)
- `date_from` / `date_to`: ISO date format `YYYY-MM-DD` (if provided)
- `cursor`: opaque string from previous response (if provided)
- `search`: string, max 100 chars (if provided)

---

## Pagination Envelope

All paginated endpoints use Laravel's `cursorPaginate()` which returns:

```json
{
  "data": [...],
  "path": "https://example.com/api/v1/marketplace/venues",
  "per_page": 15,
  "next_cursor": "eyJpZCI6MTZ9",
  "next_page_url": "https://example.com/api/v1/marketplace/venues?cursor=eyJpZCI6MTZ9",
  "prev_cursor": null,
  "prev_page_url": null
}
```

Flutter detects end-of-list when `next_cursor` is `null`.

---

## Endpoints

### 1. GET `marketplace/sports`

List all sports for the filter chips UI.

**Auth:** Required (Sanctum bearer token)
**Pagination:** None (small dataset, always return all)

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Tenis", "icon": "tennis" },
    { "id": 2, "name": "Padel", "icon": "padel" },
    { "id": 3, "name": "Badminton", "icon": "badminton" },
    { "id": 4, "name": "Futsal", "icon": "futsal" }
  ]
}
```

- `icon` field: sport name lowercased/slugified — Flutter maps this to a local icon asset
- If the `sports` table lacks an `icon` column, derive from `name`

---

### 2. GET `marketplace/venues`

Browse venues/arenas across all clubs.

**Auth:** Required
**Pagination:** Cursor-based (`cursorPaginate`)

**Query params:**
| Param | Type | Description |
|---|---|---|
| `sport_id` | int? | Filter by sport |
| `search` | string? | Text search on venue name or location address |
| `per_page` | int? | Items per page (default 15, max 50) |
| `cursor` | string? | Cursor for next page |

**Query logic:**
```php
Venue::with(['location', 'photos', 'sport'])
    ->active()
    ->when($sportId, fn($q) => $q->forSport($sportId))
    ->when($search, fn($q) => $q->where(function ($sub) use ($search) {
        $sub->where('name', 'LIKE', "%{$search}%")
            ->orWhereHas('location', fn($lq) => $lq
                ->where('name', 'LIKE', "%{$search}%")
                ->orWhere('address', 'LIKE', "%{$search}%"));
    }))
    ->orderBy('name')
    ->cursorPaginate($perPage);
```

Note: Search uses a nested `where(function ...)` to avoid `orWhereHas` bypassing `active()` and `forSport()` scopes. MySQL default collation is case-insensitive for `LIKE`.

**Response item shape:**
```json
{
  "id": 1,
  "name": "GOR Senayan Sports Center",
  "sport": { "id": 1, "name": "Tenis" },
  "location": {
    "name": "Gelora, Tanah Abang",
    "address": "Jl. Asia Afrika, Gelora, Tanah Abang",
    "lat": -6.2188,
    "lng": 106.8020
  },
  "photos": [
    { "url": "https://storage.example.com/venues/1/photo1.jpg", "caption": null }
  ],
  "status": "active"
}
```

Notes:
- All IDs are integers from the database. Flutter converts to `String` in the mapper layer.
- Venues are NOT tenant-scoped (no `withoutGlobalScopes` needed)
- `active()` scope filters out archived/merged venues
- No price range or rating in this phase — Flutter hides those UI elements when null

---

### 3. GET `marketplace/venues/{id}`

Venue detail.

**Auth:** Required
**Pagination:** N/A

**Query logic:**
```php
Venue::with(['location', 'photos', 'sport'])
    ->active()
    ->findOrFail($id);
```

**Response:** Same shape as list item. Returns `404` if venue not found or not active. Separate endpoint allows future enrichment (courts list, operating hours, description) without bloating the list response.

---

### 4. GET `marketplace/sessions`

Browse available sessions across all tenants.

**Auth:** Required
**Pagination:** Cursor-based

**Query params:**
| Param | Type | Description |
|---|---|---|
| `sport_id` | int? | Filter by sport (via venue's sport_id) |
| `date_from` | date? | Start date filter (YYYY-MM-DD) |
| `date_to` | date? | End date filter (YYYY-MM-DD) |
| `search` | string? | Text search on session name |
| `per_page` | int? | Items per page (default 15, max 50) |
| `cursor` | string? | Cursor for next page |

**Query logic:**
```php
Session::withoutGlobalScopes()
    ->with([
        'coaches.user:id,name,photo_path',
        'venue.location',
        'tenant:id,name',
    ])
    ->withCount(['sessionStudents as booked_count' => fn($q) => $q->whereNull('cancelled_at')])
    ->where('status', 'scheduled')
    ->where('start_at', '>', now())
    ->when($sportId, fn($q) => $q->whereHas('venue', fn($vq) => $vq->where('sport_id', $sportId)))
    ->when($search, fn($q) => $q->where('name', 'LIKE', "%{$search}%"))
    ->when($dateFrom, fn($q) => $q->whereDate('start_at', '>=', $dateFrom))
    ->when($dateTo, fn($q) => $q->whereDate('start_at', '<=', $dateTo))
    ->orderBy('start_at', 'asc')
    ->cursorPaginate($perPage);
```

**Response item shape:**
```json
{
  "id": 42,
  "name": "Badminton Sore",
  "type": "group",
  "start_at": "2026-03-27T16:00:00Z",
  "duration_minutes": 120,
  "capacity": 4,
  "booked_count": 3,
  "notes": null,
  "tenant": { "id": 1, "name": "Skate Malaysia Academy" },
  "venue": {
    "name": "GOR Senayan Sports Center",
    "location": { "name": "Gelora, Tanah Abang" }
  },
  "coaches": [
    { "id": 5, "name": "Sari Rahmawati", "photo_url": null }
  ]
}
```

Notes:
- `withoutGlobalScopes()` bypasses `BelongsToTenant` to show all tenants' sessions
- Only future, scheduled sessions are returned (all session types included — no type filter)
- `tenant.name` enables "oleh [organizer]" display on session cards
- `booked_count` + `capacity` enables the capacity progress bar
- `coaches[].id` is the `coach.user_id` (not `coach.id`) for consistency with user-facing identification

---

### 5. GET `marketplace/coaches`

Browse coaches across all tenants.

**Auth:** Required
**Pagination:** Cursor-based

**Query params:**
| Param | Type | Description |
|---|---|---|
| `sport_id` | int? | Filter by sport (via coach's tenant sport) |
| `search` | string? | Text search on coach name |
| `per_page` | int? | Items per page (default 15, max 50) |
| `cursor` | string? | Cursor for next page |

**Query logic:**
```php
Coach::withoutGlobalScopes()
    ->with(['user:id,name,email,photo_path', 'coachRates', 'tenant.sport'])
    ->where('status', 'active')
    ->when($sportId, fn($q) => $q->whereHas('tenant', fn($tq) => $tq->where('sport_id', $sportId)))
    ->when($search, fn($q) => $q->whereHas('user', fn($uq) => $uq->where('name', 'LIKE', "%{$search}%")))
    ->cursorPaginate($perPage);
```

**Response item shape:**
```json
{
  "id": 8,
  "bio": "10 tahun pengalaman melatih badminton",
  "user": {
    "name": "Sari Rahmawati",
    "photo_url": "https://storage.example.com/photos/sari.jpg"
  },
  "sport": { "id": 3, "name": "Badminton" },
  "rate_per_session": 42000,
  "currency": "IDR"
}
```

Notes:
- `id` is `coach.id` (the Coach model ID)
- `rate_per_session` is derived from the `coachRates` collection: the rate with the latest `effective_from` date that is `<= today`. If no rate exists, return `null`.
- `currency` from the same CoachRate record. If no rate, return `null`.
- `sport` derived from `coach.tenant.sport`
- No rating/review count — added in future phase when review system is built

---

## Flutter Side Integration

### ID Type Convention

All backend IDs are integers. Flutter Freezed models use `String id`. The mapper layer converts: `id: json['id'].toString()`.

### Model Strategy: New Marketplace Models

The existing Flutter models (`Venue`, `OpenSession`, `Coach`) are designed for mock data with different field shapes than the API responses. Rather than break mock mode by modifying existing models, create **new Freezed models** for marketplace API responses:

| API response | New Flutter model | Location |
|---|---|---|
| Venue list/detail | `MarketplaceVenue` | `lib/features/venue/data/models/marketplace_venue.dart` |
| Session list | `MarketplaceSession` | `lib/features/session/data/models/marketplace_session.dart` |
| Coach list | `MarketplaceCoach` | `lib/features/coach/data/models/marketplace_coach.dart` |
| Sport | `SportFilter` | `lib/shared/data/models/sport_filter.dart` |

Supporting nested models:
- `VenueLocation` (name, address, lat, lng)
- `VenuePhoto` (url, caption)
- `SessionTenant` (id, name)
- `SessionCoach` (id, name, photoUrl)
- `SportInfo` (id, name) — reused across venue/coach responses

These models map 1:1 to the API response shapes. The existing mock models remain untouched — mock mode continues to work as-is.

### Repository Interface Changes

Create **new repository interfaces** for marketplace data, separate from the existing mock-oriented interfaces:

```dart
abstract class MarketplaceVenueRepository {
  Future<CursorPage<MarketplaceVenue>> getVenues({int? sportId, String? search, int? perPage, String? cursor});
  Future<MarketplaceVenue> getVenueDetail(int id);
}

abstract class MarketplaceSessionRepository {
  Future<CursorPage<MarketplaceSession>> getSessions({int? sportId, String? search, String? dateFrom, String? dateTo, int? perPage, String? cursor});
}

abstract class MarketplaceCoachRepository {
  Future<CursorPage<MarketplaceCoach>> getCoaches({int? sportId, String? search, int? perPage, String? cursor});
}

abstract class MarketplaceSportRepository {
  Future<List<SportFilter>> getSports();
}
```

The existing `VenueRepository`, `SessionRepository`, `CoachRepository` interfaces remain unchanged for mock mode.

### Cursor Pagination Type

Create a shared generic type for cursor-paginated responses:

```dart
// lib/shared/data/models/cursor_page.dart
class CursorPage<T> {
  final List<T> items;
  final String? nextCursor;
  final int perPage;

  const CursorPage({required this.items, this.nextCursor, required this.perPage});

  bool get hasMore => nextCursor != null;
}
```

Parsing helper:
```dart
CursorPage<T> parseCursorPage<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
  final data = (json['data'] as List).cast<Map<String, dynamic>>();
  return CursorPage(
    items: data.map(fromJson).toList(),
    nextCursor: json['next_cursor'] as String?,
    perPage: json['per_page'] as int? ?? 15,
  );
}
```

### Sport Filters: Dynamic from API

The existing Flutter `Sport` enum is used for mock mode filter chips. For real API mode:

- Fetch `marketplace/sports` on login, cache in SharedPreferences as JSON
- Create `SportFilter` model (`{int id, String name, String icon}`)
- Explore screen reads from cache on build, refreshes in background
- Filter chips use `sport_id` (int) for API calls instead of enum values
- Mock mode continues using the existing `Sport` enum flow — no changes needed

### State Management for Infinite Scroll

Each list tab uses a `StateNotifier` (or `AsyncNotifier`) that holds:

```dart
class MarketplaceListState<T> {
  final List<T> items;
  final String? nextCursor;
  final bool isLoading;      // initial load
  final bool isLoadingMore;  // pagination
  final String? error;

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;
}
```

This replaces the current `FutureProvider<List<T>>` pattern which cannot handle append-on-scroll.

### Loading States

Every list screen follows this UX pattern:

| State | Display |
|---|---|
| **Initial load** | Skeleton shimmer placeholders matching card layout |
| **Pagination** | Small loader at list bottom, existing items remain visible |
| **Pull-to-refresh** | Standard Material refresh indicator, resets cursor |
| **Error** | Clear message + retry button ("Gagal memuat, coba lagi") |
| **Empty** | Friendly icon + descriptive text |

### Empty State Handling

Critical for production where data may be sparse. Each tab gets a specific empty message:
- Lapangan: "Belum ada lapangan tersedia"
- Sesi: "Belum ada sesi tersedia"
- Coach: "Belum ada coach tersedia"

---

## Files to Create/Modify

### Laravel (C:\laragon\www\hypercoach)

**Create:**
- `app/Http/Controllers/Marketplace/SportController.php`
- `app/Http/Controllers/Marketplace/VenueController.php`
- `app/Http/Controllers/Marketplace/SessionController.php`
- `app/Http/Controllers/Marketplace/CoachController.php`
- `app/Services/MarketplaceService.php`

**Modify:**
- `routes/api.php` — add `marketplace` route group with `auth:sanctum` middleware

### Flutter (D:\projects\Flutter\hyperarena)

**Create:**
- `lib/shared/data/models/cursor_page.dart` — generic cursor pagination type
- `lib/shared/data/models/sport_filter.dart` — SportFilter model
- `lib/features/venue/data/models/marketplace_venue.dart` — MarketplaceVenue + VenueLocation + VenuePhoto
- `lib/features/venue/data/api_venue_repository.dart` — API implementation
- `lib/features/session/data/models/marketplace_session.dart` — MarketplaceSession + nested types
- `lib/features/session/data/api_session_repository.dart` — API implementation
- `lib/features/coach/data/models/marketplace_coach.dart` — MarketplaceCoach
- `lib/features/coach/data/api_coach_repository.dart` — API implementation
- `lib/shared/data/api_sport_repository.dart` — sport list API + cache
- Skeleton shimmer widgets per card type
- Empty state widget (shared)

**Modify:**
- Venue/session/coach provider files — add marketplace providers (separate from mock providers)
- Explore screen tabs — use marketplace providers in API mode, add empty states, skeleton loading, infinite scroll
- Sports filter — load from API + cache instead of hardcoded enum in API mode

---

## Data Flow

```
Flutter Explore Screen
  ├── Sports chips ← GET marketplace/sports (cached in SharedPreferences)
  ├── Lapangan tab ← GET marketplace/venues?sport_id=X&cursor=Y
  ├── Coach tab    ← GET marketplace/coaches?sport_id=X&cursor=Y
  └── Sesi tab     ← GET marketplace/sessions?sport_id=X&cursor=Y
         │
         ▼
    Laravel Marketplace API (auth:sanctum, no tenant resolution)
         │
         ▼
    MarketplaceService
      ├── Venue → query global (no scope bypass needed)
      ├── Session → withoutGlobalScopes() (cross-tenant)
      └── Coach → withoutGlobalScopes() (cross-tenant)
```
