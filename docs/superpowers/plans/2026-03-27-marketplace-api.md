# Marketplace API Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create cross-tenant marketplace API endpoints in Laravel and wire them into the Flutter Explore screen, replacing mock data with real API calls.

**Architecture:** Laravel gets a new `Marketplace` module (service + 4 controllers + routes) isolated from tenant-scoped code. Flutter gets new Freezed models matching API response shapes, API repository implementations with DioException unwrapping, cursor-based pagination, and skeleton/empty state UX.

**Tech Stack:** Laravel 12 (Sanctum auth, Eloquent), Flutter (Riverpod 2.6, Freezed, Dio 5.7, GoRouter)

**Spec:** `docs/superpowers/specs/2026-03-27-marketplace-api-design.md`

---

## Chunk 1: Laravel Backend

> All files in this chunk are at `C:\laragon\www\hypercoach`.
> Run commands from that directory.

### Task 1: Create MarketplaceService

**Files:**
- Create: `app/Services/MarketplaceService.php`

- [ ] **Step 1: Create the service class with all 5 query methods**

```php
<?php

namespace App\Services;

use App\Models\Coach;
use App\Models\Session;
use App\Models\Sport;
use App\Models\Venue;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Collection;

class MarketplaceService
{
    /**
     * List all active sports for filter chips.
     */
    public function getSports(): Collection
    {
        return Sport::active()->get(['id', 'name', 'slug', 'icon']);
    }

    /**
     * Browse venues with optional sport and search filters.
     */
    public function getVenues(array $filters = []): CursorPaginator
    {
        $perPage = min($filters['per_page'] ?? 15, 50);

        return Venue::with(['location', 'photos', 'sport:id,name'])
            ->active()
            ->when(! empty($filters['sport_id']), fn ($q) => $q->forSport((int) $filters['sport_id']))
            ->when(! empty($filters['search']), fn ($q) => $q->where(function ($sub) use ($filters) {
                $term = '%'.$filters['search'].'%';
                $sub->where('name', 'LIKE', $term)
                    ->orWhereHas('location', fn ($lq) => $lq
                        ->where('name', 'LIKE', $term)
                        ->orWhere('address', 'LIKE', $term));
            }))
            ->orderBy('name')
            ->cursorPaginate($perPage, ['*'], 'cursor', $filters['cursor'] ?? null);
    }

    /**
     * Get a single active venue by ID.
     */
    public function getVenueDetail(int $id): Venue
    {
        return Venue::with(['location', 'photos', 'sport:id,name'])
            ->active()
            ->findOrFail($id);
    }

    /**
     * Browse available sessions across all tenants.
     */
    public function getSessions(array $filters = []): CursorPaginator
    {
        $perPage = min($filters['per_page'] ?? 15, 50);

        return Session::withoutGlobalScopes()
            ->with([
                'coaches.user:id,name,photo_path',
                'venue.location',
                'tenant:id,name',
            ])
            ->withCount(['sessionStudents as booked_count' => fn ($q) => $q->whereNull('cancelled_at')])
            ->where('status', 'scheduled')
            ->where('start_at', '>', now())
            ->when(! empty($filters['sport_id']), fn ($q) => $q->whereHas('venue', fn ($vq) => $vq->where('sport_id', (int) $filters['sport_id'])))
            ->when(! empty($filters['search']), fn ($q) => $q->where('name', 'LIKE', '%'.$filters['search'].'%'))
            ->when(! empty($filters['date_from']), fn ($q) => $q->whereDate('start_at', '>=', $filters['date_from']))
            ->when(! empty($filters['date_to']), fn ($q) => $q->whereDate('start_at', '<=', $filters['date_to']))
            ->orderBy('start_at', 'asc')
            ->cursorPaginate($perPage, ['*'], 'cursor', $filters['cursor'] ?? null);
    }

    /**
     * Browse active coaches across all tenants.
     */
    public function getCoaches(array $filters = []): CursorPaginator
    {
        $perPage = min($filters['per_page'] ?? 15, 50);

        return Coach::withoutGlobalScopes()
            ->with(['user:id,name,email,photo_path', 'coachRates', 'tenant.sport:id,name'])
            ->where('status', 'active')
            ->when(! empty($filters['sport_id']), fn ($q) => $q->whereHas('tenant', fn ($tq) => $tq->where('sport_id', (int) $filters['sport_id'])))
            ->when(! empty($filters['search']), fn ($q) => $q->whereHas('user', fn ($uq) => $uq->where('name', 'LIKE', '%'.$filters['search'].'%')))
            ->cursorPaginate($perPage, ['*'], 'cursor', $filters['cursor'] ?? null);
    }
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `cd C:\laragon\www\hypercoach && php artisan tinker --execute="new App\Services\MarketplaceService();"`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
cd C:\laragon\www\hypercoach
git add app/Services/MarketplaceService.php
git commit -m "feat(marketplace): add MarketplaceService with cross-tenant queries

For HyperArena mobile app — marketplace endpoints.
Sports, venues, sessions (withoutGlobalScopes), coaches."
```

---

### Task 2: Create Marketplace Controllers

**Files:**
- Create: `app/Http/Controllers/Marketplace/SportController.php`
- Create: `app/Http/Controllers/Marketplace/VenueController.php`
- Create: `app/Http/Controllers/Marketplace/SessionController.php`
- Create: `app/Http/Controllers/Marketplace/CoachController.php`

- [ ] **Step 1: Create the Marketplace controller directory**

```bash
mkdir -p app/Http/Controllers/Marketplace
```

- [ ] **Step 2: Create SportController**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Services\MarketplaceService;
use Illuminate\Http\JsonResponse;

/**
 * @group Mobile App — Marketplace
 *
 * Cross-tenant marketplace endpoints for the HyperArena mobile app.
 * These endpoints do not require X-Tenant header.
 */
class SportController extends Controller
{
    public function __construct(private MarketplaceService $marketplace) {}

    public function index(): JsonResponse
    {
        $sports = $this->marketplace->getSports();

        return response()->json([
            'data' => $sports->map(fn ($sport) => [
                'id' => $sport->id,
                'name' => $sport->name,
                'icon' => $sport->icon ?? strtolower($sport->slug ?? $sport->name),
            ]),
        ]);
    }
}
```

- [ ] **Step 3: Create VenueController**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Services\MarketplaceService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Mobile App — Marketplace
 *
 * Cross-tenant marketplace endpoints for the HyperArena mobile app.
 * These endpoints do not require X-Tenant header.
 */
class VenueController extends Controller
{
    public function __construct(private MarketplaceService $marketplace) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'sport_id' => 'sometimes|integer|exists:sports,id',
            'search' => 'sometimes|string|max:100',
            'per_page' => 'sometimes|integer|min:1|max:50',
            'cursor' => 'sometimes|string',
        ]);

        $venues = $this->marketplace->getVenues($request->only(['sport_id', 'search', 'per_page', 'cursor']));

        return response()->json($venues);
    }

    public function show(int $id): JsonResponse
    {
        $venue = $this->marketplace->getVenueDetail($id);

        return response()->json(['data' => $venue]);
    }
}
```

- [ ] **Step 4: Create SessionController**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Services\MarketplaceService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Mobile App — Marketplace
 *
 * Cross-tenant marketplace endpoints for the HyperArena mobile app.
 * These endpoints do not require X-Tenant header.
 */
class SessionController extends Controller
{
    public function __construct(private MarketplaceService $marketplace) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'sport_id' => 'sometimes|integer|exists:sports,id',
            'search' => 'sometimes|string|max:100',
            'date_from' => 'sometimes|date_format:Y-m-d',
            'date_to' => 'sometimes|date_format:Y-m-d|after_or_equal:date_from',
            'per_page' => 'sometimes|integer|min:1|max:50',
            'cursor' => 'sometimes|string',
        ]);

        $sessions = $this->marketplace->getSessions(
            $request->only(['sport_id', 'search', 'date_from', 'date_to', 'per_page', 'cursor'])
        );

        return response()->json($sessions);
    }
}
```

- [ ] **Step 5: Create CoachController**

```php
<?php

namespace App\Http\Controllers\Marketplace;

use App\Http\Controllers\Controller;
use App\Services\MarketplaceService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Mobile App — Marketplace
 *
 * Cross-tenant marketplace endpoints for the HyperArena mobile app.
 * These endpoints do not require X-Tenant header.
 */
class CoachController extends Controller
{
    public function __construct(private MarketplaceService $marketplace) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'sport_id' => 'sometimes|integer|exists:sports,id',
            'search' => 'sometimes|string|max:100',
            'per_page' => 'sometimes|integer|min:1|max:50',
            'cursor' => 'sometimes|string',
        ]);

        $coaches = $this->marketplace->getCoaches($request->only(['sport_id', 'search', 'per_page', 'cursor']));

        return response()->json($coaches);
    }
}
```

- [ ] **Step 6: Commit**

```bash
cd C:\laragon\www\hypercoach
git add app/Http/Controllers/Marketplace/
git commit -m "feat(marketplace): add 4 marketplace controllers

SportController, VenueController, SessionController, CoachController.
For HyperArena mobile app — thin controllers delegating to MarketplaceService."
```

---

### Task 3: Register Marketplace Routes

**Files:**
- Modify: `C:\laragon\www\hypercoach\routes\api.php` (add after line 506, before file end)

- [ ] **Step 1: Add the marketplace route group to api.php**

Append before the final line of the file:

```php
// ─────────────────────────────────────────────────────────
// Mobile App — Marketplace (cross-tenant, no X-Tenant needed)
// ─────────────────────────────────────────────────────────
Route::prefix('marketplace')
    ->middleware(['auth:sanctum'])
    ->group(function () {
        Route::get('sports', [Marketplace\SportController::class, 'index']);
        Route::get('venues', [Marketplace\VenueController::class, 'index']);
        Route::get('venues/{id}', [Marketplace\VenueController::class, 'show']);
        Route::get('sessions', [Marketplace\SessionController::class, 'index']);
        Route::get('coaches', [Marketplace\CoachController::class, 'index']);
    });
```

Also add the import alias at the top of the file (with the existing use statements):

```php
use App\Http\Controllers\Marketplace;
```

- [ ] **Step 2: Verify routes are registered**

Run: `cd C:\laragon\www\hypercoach && php artisan route:list --path=marketplace`
Expected: 5 routes listed (GET marketplace/sports, venues, venues/{id}, sessions, coaches)

- [ ] **Step 3: Commit**

```bash
cd C:\laragon\www\hypercoach
git add routes/api.php
git commit -m "feat(marketplace): register marketplace routes

5 endpoints under api/v1/marketplace/* with auth:sanctum middleware.
No tenant resolution — cross-tenant by design."
```

---

### Task 4: Manual API Smoke Test

> Requires the Laravel server running at `hypercoach.local` and a valid Sanctum token.

- [ ] **Step 1: Test sports endpoint**

```bash
curl -H "Authorization: Bearer {TOKEN}" -H "Accept: application/json" \
  http://hypercoach.local/api/v1/marketplace/sports
```
Expected: JSON with `data` array of sports

- [ ] **Step 2: Test venues endpoint**

```bash
curl -H "Authorization: Bearer {TOKEN}" -H "Accept: application/json" \
  "http://hypercoach.local/api/v1/marketplace/venues?per_page=5"
```
Expected: JSON with `data` array and cursor pagination fields (`next_cursor`, `next_page_url`, etc.)

- [ ] **Step 3: Test sessions endpoint**

```bash
curl -H "Authorization: Bearer {TOKEN}" -H "Accept: application/json" \
  "http://hypercoach.local/api/v1/marketplace/sessions?per_page=5"
```
Expected: JSON with `data` array (may be empty if no future scheduled sessions exist)

- [ ] **Step 4: Test coaches endpoint**

```bash
curl -H "Authorization: Bearer {TOKEN}" -H "Accept: application/json" \
  "http://hypercoach.local/api/v1/marketplace/coaches?per_page=5"
```
Expected: JSON with `data` array of active coaches

- [ ] **Step 5: Test 401 without auth**

```bash
curl -H "Accept: application/json" \
  http://hypercoach.local/api/v1/marketplace/sports
```
Expected: 401 Unauthenticated

---

## Chunk 2: Flutter Frontend

> All files in this chunk are at `D:\projects\Flutter\hyperarena`.
> Run commands from that directory.

### Task 5: Create Shared Pagination and Sport Models

**Files:**
- Create: `lib/shared/data/models/cursor_page.dart`
- Create: `lib/shared/data/models/sport_filter.dart`
- Test: `test/shared/data/models/cursor_page_test.dart`

- [ ] **Step 1: Create the directory structure**

```bash
mkdir -p lib/shared/data/models
mkdir -p test/shared/data/models
```

- [ ] **Step 2: Create CursorPage<T>**

```dart
// lib/shared/data/models/cursor_page.dart

/// Generic cursor-paginated response from marketplace API.
class CursorPage<T> {
  final List<T> items;
  final String? nextCursor;
  final int perPage;

  const CursorPage({
    required this.items,
    this.nextCursor,
    required this.perPage,
  });

  bool get hasMore => nextCursor != null;

  /// Parse a Laravel cursorPaginate() JSON response.
  static CursorPage<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = (json['data'] as List).cast<Map<String, dynamic>>();
    return CursorPage(
      items: data.map(fromJson).toList(),
      nextCursor: json['next_cursor'] as String?,
      perPage: json['per_page'] as int? ?? 15,
    );
  }
}
```

- [ ] **Step 3: Write CursorPage test**

```dart
// test/shared/data/models/cursor_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

void main() {
  test('fromJson parses items and cursor', () {
    final json = {
      'data': [
        {'id': 1, 'name': 'Tennis'},
        {'id': 2, 'name': 'Padel'},
      ],
      'next_cursor': 'abc123',
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.items.length, 2);
    expect(page.nextCursor, 'abc123');
    expect(page.hasMore, true);
    expect(page.perPage, 15);
  });

  test('fromJson handles null cursor (last page)', () {
    final json = {
      'data': [
        {'id': 1, 'name': 'Tennis'},
      ],
      'next_cursor': null,
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.hasMore, false);
    expect(page.nextCursor, isNull);
  });

  test('fromJson handles empty data', () {
    final json = {
      'data': <dynamic>[],
      'next_cursor': null,
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.items, isEmpty);
    expect(page.hasMore, false);
  });
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/shared/data/models/cursor_page_test.dart`
Expected: 3 tests PASS

- [ ] **Step 5: Create SportFilter model**

```dart
// lib/shared/data/models/sport_filter.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_filter.freezed.dart';
part 'sport_filter.g.dart';

@freezed
class SportFilter with _$SportFilter {
  const factory SportFilter({
    required int id,
    required String name,
    required String icon,
  }) = _SportFilter;

  factory SportFilter.fromJson(Map<String, dynamic> json) =>
      _$SportFilterFromJson(json);
}
```

- [ ] **Step 6: Run build_runner for code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generates `sport_filter.freezed.dart` and `sport_filter.g.dart`

- [ ] **Step 7: Commit**

```bash
git add lib/shared/data/models/ test/shared/data/models/
git commit -m "feat: add CursorPage<T> pagination type and SportFilter model

Shared types for marketplace API integration.
CursorPage parses Laravel cursorPaginate() responses.
SportFilter replaces hardcoded Sport enum for API mode."
```

---

### Task 6: Create Marketplace Venue Model

**Files:**
- Create: `lib/features/venue/data/models/marketplace_venue.dart`

- [ ] **Step 1: Create the Freezed model**

```dart
// lib/features/venue/data/models/marketplace_venue.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_venue.freezed.dart';
part 'marketplace_venue.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceVenue with _$MarketplaceVenue {
  const factory MarketplaceVenue({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    required String status,
    SportInfo? sport,
    VenueLocation? location,
    @Default([]) List<VenuePhoto> photos,
  }) = _MarketplaceVenue;

  factory MarketplaceVenue.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceVenueFromJson(json);
}

@freezed
class VenueLocation with _$VenueLocation {
  const factory VenueLocation({
    required String name,
    String? address,
    double? lat,
    double? lng,
  }) = _VenueLocation;

  factory VenueLocation.fromJson(Map<String, dynamic> json) =>
      _$VenueLocationFromJson(json);
}

@freezed
class VenuePhoto with _$VenuePhoto {
  const factory VenuePhoto({
    required String url,
    String? caption,
  }) = _VenuePhoto;

  factory VenuePhoto.fromJson(Map<String, dynamic> json) =>
      _$VenuePhotoFromJson(json);
}

@freezed
class SportInfo with _$SportInfo {
  const factory SportInfo({
    required int id,
    required String name,
  }) = _SportInfo;

  factory SportInfo.fromJson(Map<String, dynamic> json) =>
      _$SportInfoFromJson(json);
}
```

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generates `.freezed.dart` and `.g.dart` files

- [ ] **Step 3: Commit**

```bash
git add lib/features/venue/data/models/marketplace_venue.dart
git add lib/features/venue/data/models/marketplace_venue.freezed.dart
git add lib/features/venue/data/models/marketplace_venue.g.dart
git commit -m "feat: add MarketplaceVenue Freezed model

Maps 1:1 to GET marketplace/venues API response.
Includes nested VenueLocation, VenuePhoto, SportInfo."
```

---

### Task 7: Create Marketplace Session Model

**Files:**
- Create: `lib/features/session/data/models/marketplace_session.dart`

- [ ] **Step 1: Create the Freezed model**

```dart
// lib/features/session/data/models/marketplace_session.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';

part 'marketplace_session.freezed.dart';
part 'marketplace_session.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceSession with _$MarketplaceSession {
  const factory MarketplaceSession({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    String? type,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    required int capacity,
    @JsonKey(name: 'booked_count') @Default(0) int bookedCount,
    String? notes,
    SessionTenant? tenant,
    MarketplaceSessionVenue? venue,
    @Default([]) List<SessionCoach> coaches,
  }) = _MarketplaceSession;

  factory MarketplaceSession.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionFromJson(json);
}

@freezed
class SessionTenant with _$SessionTenant {
  const factory SessionTenant({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
  }) = _SessionTenant;

  factory SessionTenant.fromJson(Map<String, dynamic> json) =>
      _$SessionTenantFromJson(json);
}

@freezed
class MarketplaceSessionVenue with _$MarketplaceSessionVenue {
  const factory MarketplaceSessionVenue({
    required String name,
    VenueLocation? location,
  }) = _MarketplaceSessionVenue;

  factory MarketplaceSessionVenue.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionVenueFromJson(json);
}

@freezed
class SessionCoach with _$SessionCoach {
  const factory SessionCoach({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    @JsonKey(name: 'photo_path') String? photoPath,
  }) = _SessionCoach;

  factory SessionCoach.fromJson(Map<String, dynamic> json) =>
      _$SessionCoachFromJson(json);
}
```

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generates `.freezed.dart` and `.g.dart` files

- [ ] **Step 3: Commit**

```bash
git add lib/features/session/data/models/marketplace_session.dart
git add lib/features/session/data/models/marketplace_session.freezed.dart
git add lib/features/session/data/models/marketplace_session.g.dart
git commit -m "feat: add MarketplaceSession Freezed model

Maps 1:1 to GET marketplace/sessions API response.
Includes nested SessionTenant, MarketplaceSessionVenue, SessionCoach."
```

---

### Task 8: Create Marketplace Coach Model

**Files:**
- Create: `lib/features/coach/data/models/marketplace_coach.dart`

- [ ] **Step 1: Create the Freezed model**

```dart
// lib/features/coach/data/models/marketplace_coach.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';

part 'marketplace_coach.freezed.dart';
part 'marketplace_coach.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceCoach with _$MarketplaceCoach {
  const factory MarketplaceCoach({
    @JsonKey(fromJson: _idFromJson) required String id,
    String? bio,
    CoachUser? user,
    SportInfo? sport,
    @JsonKey(name: 'rate_per_session') int? ratePerSession,
    String? currency,
  }) = _MarketplaceCoach;

  factory MarketplaceCoach.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCoachFromJson(json);
}

@freezed
class CoachUser with _$CoachUser {
  const factory CoachUser({
    required String name,
    @JsonKey(name: 'photo_path') String? photoPath,
  }) = _CoachUser;

  factory CoachUser.fromJson(Map<String, dynamic> json) =>
      _$CoachUserFromJson(json);
}
```

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generates `.freezed.dart` and `.g.dart` files

- [ ] **Step 3: Commit**

```bash
git add lib/features/coach/data/models/marketplace_coach.dart
git add lib/features/coach/data/models/marketplace_coach.freezed.dart
git add lib/features/coach/data/models/marketplace_coach.g.dart
git commit -m "feat: add MarketplaceCoach Freezed model

Maps 1:1 to GET marketplace/coaches API response.
Includes nested CoachUser. Reuses SportInfo from venue models."
```

---

### Task 9: Create Shared DioException Helper and API Repositories

> **Design note (Issue 4 from review):** The spec mentions abstract repository interfaces. We intentionally skip them here for simplicity — the concrete implementations are the only ones used, and we can extract interfaces later if test doubles are needed.

> **Design note (Issue 5 from review):** The `rethrowDio` helper is extracted into a shared utility to avoid duplication across 4 repository files.

**Files:**
- Create: `lib/core/network/dio_error_handler.dart` — shared DioException unwrapping utility
- Create: `lib/features/venue/data/api_marketplace_venue_repository.dart`
- Create: `lib/features/session/data/api_marketplace_session_repository.dart`
- Create: `lib/features/coach/data/api_marketplace_coach_repository.dart`
- Create: `lib/shared/data/api_sport_repository.dart`

- [ ] **Step 1: Create shared DioException unwrapping utility**

```dart
// lib/core/network/dio_error_handler.dart
import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';

/// Unwraps a DioException to rethrow the inner ApiException if present.
/// Used by all marketplace API repositories.
Never rethrowDio(DioException e) {
  if (e.error is ApiException) throw e.error!;
  throw e;
}
```

- [ ] **Step 2: Create ApiMarketplaceVenueRepository**

```dart
// lib/features/venue/data/api_marketplace_venue_repository.dart
import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceVenueRepository {
  final ApiClient _apiClient;

  ApiMarketplaceVenueRepository(this._apiClient);

  Future<CursorPage<MarketplaceVenue>> getVenues({
    int? sportId,
    String? search,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/venues',
          queryParameters: {
            if (sportId != null) 'sport_id': sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            if (perPage != null) 'per_page': perPage,
            if (cursor != null) 'cursor': cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceVenue.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<MarketplaceVenue> getVenueDetail(int id) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/venues/$id');
      final data = response.data as Map<String, dynamic>;
      return MarketplaceVenue.fromJson(
        data.containsKey('data')
            ? data['data'] as Map<String, dynamic>
            : data,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
```

- [ ] **Step 3: Create ApiMarketplaceSessionRepository**

```dart
// lib/features/session/data/api_marketplace_session_repository.dart
import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceSessionRepository {
  final ApiClient _apiClient;

  ApiMarketplaceSessionRepository(this._apiClient);

  Future<CursorPage<MarketplaceSession>> getSessions({
    int? sportId,
    String? search,
    String? dateFrom,
    String? dateTo,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/sessions',
          queryParameters: {
            if (sportId != null) 'sport_id': sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            if (dateFrom != null) 'date_from': dateFrom,
            if (dateTo != null) 'date_to': dateTo,
            if (perPage != null) 'per_page': perPage,
            if (cursor != null) 'cursor': cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceSession.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
```

- [ ] **Step 4: Create ApiMarketplaceCoachRepository**

```dart
// lib/features/coach/data/api_marketplace_coach_repository.dart
import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceCoachRepository {
  final ApiClient _apiClient;

  ApiMarketplaceCoachRepository(this._apiClient);

  Future<CursorPage<MarketplaceCoach>> getCoaches({
    int? sportId,
    String? search,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/coaches',
          queryParameters: {
            if (sportId != null) 'sport_id': sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            if (perPage != null) 'per_page': perPage,
            if (cursor != null) 'cursor': cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceCoach.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
```

- [ ] **Step 5: Create ApiSportRepository with caching**

```dart
// lib/shared/data/api_sport_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/shared/data/models/sport_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cacheKey = 'marketplace_sports';

class ApiSportRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  ApiSportRepository(this._apiClient, this._prefs);

  /// Returns cached sports immediately, or fetches from API.
  List<SportFilter> getCached() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map(SportFilter.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches sports from API and updates cache. Returns the fresh list.
  Future<List<SportFilter>> fetchAndCache() async {
    try {
      final response = await _apiClient.get('/v1/marketplace/sports');
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List).cast<Map<String, dynamic>>();
      final sports = list.map(SportFilter.fromJson).toList();
      // Cache as JSON string
      _prefs.setString(_cacheKey, jsonEncode(list));
      return sports;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
```

- [ ] **Step 6: Run analyzer**

Run: `dart analyze lib/core/network/dio_error_handler.dart lib/features/venue/data/api_marketplace_venue_repository.dart lib/features/session/data/api_marketplace_session_repository.dart lib/features/coach/data/api_marketplace_coach_repository.dart lib/shared/data/api_sport_repository.dart`
Expected: No issues found

- [ ] **Step 7: Commit**

```bash
git add lib/core/network/dio_error_handler.dart
git add lib/features/venue/data/api_marketplace_venue_repository.dart
git add lib/features/session/data/api_marketplace_session_repository.dart
git add lib/features/coach/data/api_marketplace_coach_repository.dart
git add lib/shared/data/api_sport_repository.dart
git commit -m "feat: add marketplace API repositories with shared DioException handler

Shared rethrowDio() utility in dio_error_handler.dart.
ApiMarketplaceVenueRepository, ApiMarketplaceSessionRepository,
ApiMarketplaceCoachRepository, ApiSportRepository (with SharedPreferences cache)."
```

---

### Task 10: Create Marketplace Providers

**Files:**
- Create: `lib/shared/providers/marketplace_providers.dart`

This task creates Riverpod providers for the marketplace repositories and state management for infinite scroll. These are NEW providers alongside the existing mock-oriented ones — the Explore screen will switch between them based on `useMockData`.

- [ ] **Step 1: Create marketplace providers**

```dart
// lib/shared/providers/marketplace_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/coach/data/api_marketplace_coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/session/data/api_marketplace_session_repository.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/venue/data/api_marketplace_venue_repository.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/api_sport_repository.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';
import 'package:hyperarena/shared/data/models/sport_filter.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

// ── Repository providers ──────────────────────────────────

final marketplaceVenueRepoProvider =
    Provider<ApiMarketplaceVenueRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceVenueRepository(apiClient);
});

final marketplaceSessionRepoProvider =
    Provider<ApiMarketplaceSessionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceSessionRepository(apiClient);
});

final marketplaceCoachRepoProvider =
    Provider<ApiMarketplaceCoachRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceCoachRepository(apiClient);
});

final sportRepoProvider = Provider<ApiSportRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApiSportRepository(apiClient, prefs);
});

// ── Sport filter chips ────────────────────────────────────

final sportFiltersProvider =
    AsyncNotifierProvider<SportFiltersNotifier, List<SportFilter>>(
        SportFiltersNotifier.new);

class SportFiltersNotifier extends AsyncNotifier<List<SportFilter>> {
  @override
  Future<List<SportFilter>> build() async {
    final repo = ref.read(sportRepoProvider);
    // Return cache immediately, refresh in background
    final cached = repo.getCached();
    if (cached.isNotEmpty) {
      // Fire-and-forget refresh
      repo.fetchAndCache().then((fresh) {
        if (state.hasValue) state = AsyncData(fresh);
      }).catchError((_) {});
      return cached;
    }
    return repo.fetchAndCache();
  }
}

/// Currently selected sport filter (null = all sports).
final selectedSportIdProvider = StateProvider<int?>((ref) => null);

// ── Marketplace list state ────────────────────────────────

class MarketplaceListState<T> {
  final List<T> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const MarketplaceListState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;

  MarketplaceListState<T> copyWith({
    List<T>? items,
    String? Function()? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
  }) {
    return MarketplaceListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
    );
  }
}

// ── Venue list notifier ───────────────────────────────────

final marketplaceVenueListProvider = NotifierProvider<
    MarketplaceVenueListNotifier,
    MarketplaceListState<MarketplaceVenue>>(MarketplaceVenueListNotifier.new);

class MarketplaceVenueListNotifier
    extends Notifier<MarketplaceListState<MarketplaceVenue>> {
  @override
  MarketplaceListState<MarketplaceVenue> build() {
    // Auto-refresh when sport filter changes
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  String? _searchQuery;

  Future<void> loadInitial({String? search}) async {
    _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceVenueRepoProvider);
      final page = await repo.getVenues(
        sportId: sportId,
        search: _searchQuery,
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceVenueRepoProvider);
      final page = await repo.getVenues(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Session list notifier ─────────────────────────────────

final marketplaceSessionListProvider = NotifierProvider<
    MarketplaceSessionListNotifier,
    MarketplaceListState<MarketplaceSession>>(
    MarketplaceSessionListNotifier.new);

class MarketplaceSessionListNotifier
    extends Notifier<MarketplaceListState<MarketplaceSession>> {
  @override
  MarketplaceListState<MarketplaceSession> build() {
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  String? _searchQuery;

  Future<void> loadInitial({String? search}) async {
    _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceSessionRepoProvider);
      final page = await repo.getSessions(
        sportId: sportId,
        search: _searchQuery,
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceSessionRepoProvider);
      final page = await repo.getSessions(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Coach list notifier ───────────────────────────────────

final marketplaceCoachListProvider = NotifierProvider<
    MarketplaceCoachListNotifier,
    MarketplaceListState<MarketplaceCoach>>(MarketplaceCoachListNotifier.new);

class MarketplaceCoachListNotifier
    extends Notifier<MarketplaceListState<MarketplaceCoach>> {
  @override
  MarketplaceListState<MarketplaceCoach> build() {
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  String? _searchQuery;

  Future<void> loadInitial({String? search}) async {
    _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceCoachRepoProvider);
      final page = await repo.getCoaches(
        sportId: sportId,
        search: _searchQuery,
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceCoachRepoProvider);
      final page = await repo.getCoaches(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}
```

- [ ] **Step 2: Run analyzer**

Run: `dart analyze lib/shared/providers/marketplace_providers.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/shared/providers/marketplace_providers.dart
git commit -m "feat: add marketplace Riverpod providers

Repository providers, sport filter with cache-first strategy,
and 3 list notifiers with infinite scroll state management
(initial load, load more, search, error, empty)."
```

---

### Task 11: Create Empty State and List Loading Widgets

**Files:**
- Create: `lib/shared/widgets/empty_state.dart`
- Create: `lib/shared/widgets/list_loading_indicator.dart`

- [ ] **Step 1: Create EmptyState widget**

```dart
// lib/shared/widgets/empty_state.dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.neutral300),
            const SizedBox(height: AppDimensions.base),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.base),
              TextButton(
                onPressed: onRetry,
                child: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create ListLoadingIndicator widget**

```dart
// lib/shared/widgets/list_loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

class ListLoadingIndicator extends StatelessWidget {
  const ListLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppDimensions.base),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/shared/widgets/empty_state.dart lib/shared/widgets/list_loading_indicator.dart
git commit -m "feat: add EmptyState and ListLoadingIndicator widgets

Shared UI components for marketplace list screens.
EmptyState shows icon + message + optional retry.
ListLoadingIndicator for pagination loading at list bottom."
```

---

### Task 12: Update Explore Screen with Marketplace Integration

This is the final wiring task. The Explore screen and its 3 list sub-screens need to:
1. Show dynamic sport filter chips from API (in API mode)
2. Use marketplace providers for list data (in API mode)
3. Show skeleton shimmer during initial load
4. Show empty state when no data
5. Support infinite scroll pagination
6. Keep mock mode working exactly as-is

> **Note (Issue 8):** The spec mentions "skeleton shimmer widgets per card type" as files to create. The existing `ShimmerLoading.card()` from `lib/core/widgets/shimmer_loading.dart` already provides card-shaped shimmer placeholders, so no new skeleton files are needed.

**Files:**
- Modify: `lib/features/venue/presentation/screens/explore_screen.dart` — add sport chips from API
- Modify: `lib/features/venue/presentation/screens/venue_list_screen.dart` — use marketplace provider in API mode
- Modify: `lib/features/session/presentation/screens/session_list_screen.dart` — use marketplace provider in API mode
- Modify: `lib/features/coach/presentation/screens/coach_list_screen.dart` — use marketplace provider in API mode

> **Note to implementer:** This task requires reading each of the 4 existing screen files first to understand their current structure before modifying. The key pattern for each list screen is the same — a `useMockData` branch:
>
> **Mock path:** Keep existing logic untouched.
> **API path:** Wrap in the reusable `_MarketplaceListView` pattern shown below.

- [ ] **Step 1: Read all 4 existing screen files to understand their structure**

Read:
- `lib/features/venue/presentation/screens/explore_screen.dart`
- `lib/features/venue/presentation/screens/venue_list_screen.dart`
- `lib/features/session/presentation/screens/session_list_screen.dart`
- `lib/features/coach/presentation/screens/coach_list_screen.dart`

- [ ] **Step 2: Update ExploreScreen to use dynamic sport chips in API mode**

Add imports for `appConfigProvider`, `marketplaceProviders`, `SportFilter`.
In the sport filter row, branch on `useMockData`:

```dart
// API mode sport chips — replace existing Sport enum chips when not mock
final useMock = ref.watch(appConfigProvider).useMockData;

if (useMock) {
  // ... existing Sport.values chip code unchanged ...
} else {
  final sportsAsync = ref.watch(sportFiltersProvider);
  final selectedId = ref.watch(selectedSportIdProvider);

  // "All" chip
  Widget allChip = FilterChip(
    label: const Text('Semua'),
    selected: selectedId == null,
    onSelected: (_) => ref.read(selectedSportIdProvider.notifier).state = null,
  );

  // Dynamic sport chips
  Widget sportChips = sportsAsync.when(
    loading: () => const SizedBox.shrink(),
    error: (_, __) => const SizedBox.shrink(),
    data: (sports) => Wrap(
      spacing: AppDimensions.sm,
      children: [
        allChip,
        ...sports.map((s) => FilterChip(
          label: Text(s.name),
          selected: selectedId == s.id,
          onSelected: (_) =>
            ref.read(selectedSportIdProvider.notifier).state =
              selectedId == s.id ? null : s.id,
        )),
      ],
    ),
  );
}
```

- [ ] **Step 3: Update VenueListScreen for marketplace mode**

Each list screen follows this exact pattern. Add a `ScrollController` for infinite scroll pagination:

```dart
// Inside the ConsumerStatefulWidget State class:

final _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    ref.read(marketplaceVenueListProvider.notifier).loadMore();
  }
}

// In build():
final useMock = ref.watch(appConfigProvider).useMockData;

if (useMock) {
  // ... existing mock FutureProvider path unchanged ...
} else {
  final state = ref.watch(marketplaceVenueListProvider);

  if (state.isLoading) {
    return Column(
      children: List.generate(3, (_) => ShimmerLoading.card()),
    );
  }
  if (state.error != null) {
    return EmptyState(
      icon: Icons.error_outline,
      message: 'Gagal memuat lapangan',
      onRetry: () => ref.read(marketplaceVenueListProvider.notifier).loadInitial(),
    );
  }
  if (state.isEmpty) {
    return EmptyState(
      icon: Icons.store_outlined,
      message: 'Belum ada lapangan tersedia',
    );
  }
  return ListView.builder(
    controller: _scrollController,
    itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
    itemBuilder: (context, index) {
      if (index == state.items.length) {
        return const ListLoadingIndicator();
      }
      final venue = state.items[index];
      // Build venue card using MarketplaceVenue fields:
      // venue.name, venue.sport?.name, venue.location?.address,
      // venue.photos.firstOrNull?.url
      return _buildVenueCard(context, venue);
    },
  );
}
```

Handle search by calling `notifier.loadInitial(search: query)` when search text changes.

- [ ] **Step 4: Update SessionListScreen for marketplace mode**

Same pattern as venues. Key differences:
- Provider: `marketplaceSessionListProvider`
- Empty: `EmptyState(icon: Icons.event_outlined, message: 'Belum ada sesi tersedia')`
- Card fields: `session.name`, `session.tenant?.name` ("oleh ..."), `session.venue?.name`, `session.startAt`, `session.durationMinutes`, capacity bar (`session.bookedCount / session.capacity`), `session.coaches`

- [ ] **Step 5: Update CoachListScreen for marketplace mode**

Same pattern:
- Provider: `marketplaceCoachListProvider`
- Empty: `EmptyState(icon: Icons.person_outlined, message: 'Belum ada coach tersedia')`
- Card fields: `coach.user?.name`, `coach.user?.photoPath`, `coach.sport?.name`, `coach.bio`, `coach.ratePerSession`

- [ ] **Step 6: Run full analyzer**

Run: `dart analyze lib/`
Expected: No issues

- [ ] **Step 7: Test mock mode still works**

Run: `flutter run -d chrome -t lib/main.dart`
Expected: Explore screen with all 3 tabs showing mock data, sport chips working

- [ ] **Step 8: Test API mode**

Run: `flutter run -d chrome -t lib/main_local.dart`
Expected: Explore screen loads real data from marketplace API. Empty states shown if no data. Skeleton shimmer on initial load.

- [ ] **Step 9: Commit**

```bash
git add lib/features/venue/presentation/screens/explore_screen.dart
git add lib/features/venue/presentation/screens/venue_list_screen.dart
git add lib/features/session/presentation/screens/session_list_screen.dart
git add lib/features/coach/presentation/screens/coach_list_screen.dart
git commit -m "feat: wire Explore screen to marketplace API

Dynamic sport filter chips from API with cache-first loading.
All 3 tabs (venues, sessions, coaches) use marketplace providers
in API mode with skeleton shimmer, empty states, infinite scroll.
Mock mode preserved unchanged."
```

---

### Task 13: Add Venue Map Section to Session Detail Screen

Add an embedded OpenStreetMap preview + "Buka di Maps" button to the session detail screen. Uses `flutter_map` (free, no API key) for the map widget and `url_launcher` (already in deps) for opening external map apps. Handles gracefully when lat/lng are null (address-only) or when all location data is missing (section hidden).

This task applies to **both** mock mode (OpenSession has venueId → look up from mock venues) and API mode (MarketplaceSession has venue.location with lat/lng/address).

**Files:**
- Modify: `pubspec.yaml` — add `flutter_map` and `latlong2` dependencies
- Create: `lib/shared/widgets/venue_location_section.dart` — reusable map+address widget
- Modify: `lib/features/session/presentation/screens/session_detail_screen.dart` — add the section

- [ ] **Step 1: Add flutter_map and latlong2 to pubspec.yaml**

```yaml
# Add under dependencies: (after url_launcher)
flutter_map: ^7.0.2
latlong2: ^0.9.1
```

Run: `flutter pub get`
Expected: Dependencies resolve successfully

- [ ] **Step 2: Commit dependency addition**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add flutter_map and latlong2 for venue map preview"
```

- [ ] **Step 3: Create VenueLocationSection widget**

```dart
// lib/shared/widgets/venue_location_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows venue location with optional map preview and "Buka di Maps" button.
///
/// - If [lat] and [lng] are provided: shows embedded map + marker + button.
/// - If only [address] is provided: shows address text only, no map.
/// - If [address] is also null/empty: widget renders nothing (SizedBox.shrink).
class VenueLocationSection extends StatelessWidget {
  final String? venueName;
  final String? address;
  final double? lat;
  final double? lng;

  const VenueLocationSection({
    super.key,
    this.venueName,
    this.address,
    this.lat,
    this.lng,
  });

  bool get _hasCoordinates => lat != null && lng != null;
  bool get _hasAddress => address != null && address!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Hide entirely if no location data at all
    if (!_hasCoordinates && !_hasAddress) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.sm),

        // Map preview (only when lat/lng available)
        if (_hasCoordinates) ...[
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppShadows.sm,
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat!, lng!),
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.hyperarena.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat!, lng!),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
        ],

        // Address + venue name
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (venueName != null && venueName!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: AppColors.neutral400),
                    const SizedBox(width: AppDimensions.xs),
                    Expanded(
                      child: Text(
                        venueName!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_hasAddress) ...[
                if (venueName != null && venueName!.isNotEmpty)
                  const SizedBox(height: AppDimensions.xs),
                Padding(
                  padding: const EdgeInsets.only(left: 26), // align with text above
                  child: Text(
                    address!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (_hasCoordinates) ...[
                const SizedBox(height: AppDimensions.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openInMaps(),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Buka di Maps'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  Future<void> _openInMaps() async {
    if (!_hasCoordinates) return;

    // Try Google Maps first (works on Android + iOS with gmaps installed)
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    }
  }
}
```

- [ ] **Step 4: Run analyzer on the new widget**

Run: `dart analyze lib/shared/widgets/venue_location_section.dart`
Expected: No issues found

- [ ] **Step 5: Commit the widget**

```bash
git add lib/shared/widgets/venue_location_section.dart
git commit -m "feat: add VenueLocationSection widget with embedded OSM map

Shows interactive map preview when lat/lng available, address text,
and 'Buka di Maps' button to open in external map app.
Gracefully hides when no location data present."
```

- [ ] **Step 6: Add VenueLocationSection to SessionDetailScreen**

In `session_detail_screen.dart`, add the section after the description block and before the review banner. The integration depends on the data source:

**Mock mode** — look up venue from mock data by `session.venueId`:
```dart
import 'package:hyperarena/core/mocks/mock_venues.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';

// Inside the data callback, after getting `session`:
final venue = MockVenues.all.where((v) => v.id == session.venueId).firstOrNull;
```

Then in the widget tree, after the description section and before the review banner:
```dart
// Venue location map
VenueLocationSection(
  venueName: session.venueName,
  address: venue?.address,
  lat: venue?.latitude,
  lng: venue?.longitude,
),
```

**API mode** — `MarketplaceSession.venue.location` already has lat/lng/address:
```dart
VenueLocationSection(
  venueName: marketplaceSession.venue?.name,
  address: marketplaceSession.venue?.location?.address,
  lat: marketplaceSession.venue?.location?.lat,
  lng: marketplaceSession.venue?.location?.lng,
),
```

> **Note to implementer:** The session detail screen currently only handles mock mode via `sessionListProvider` (which gives `OpenSession`). When integrating API mode in Task 12, this screen will need a branch for `MarketplaceSession` as well. For now in Task 13, wire up the mock path. The API path wiring happens naturally during Task 12's session detail integration.

- [ ] **Step 7: Run analyzer**

Run: `dart analyze lib/features/session/presentation/screens/session_detail_screen.dart`
Expected: No issues found

- [ ] **Step 8: Manual test**

Run: `flutter run -d chrome -t lib/main.dart`
Navigate to: Explore → Sesi tab → tap any session
Expected:
- Map preview appears with marker on venue location
- Address text shown below map
- "Buka di Maps" button opens Google Maps in browser/app
- If venue has no coordinates, only address text shows (no map, no button)

- [ ] **Step 9: Commit**

```bash
git add lib/features/session/presentation/screens/session_detail_screen.dart
git commit -m "feat: add venue location map to session detail screen

Embedded OpenStreetMap preview with marker, address text, and
'Buka di Maps' button. Gracefully handles missing coordinates."
```

---

## Post-Implementation

After all tasks are complete:

1. Run `/simplify` to review all changes for code quality
2. Run full test suite: `flutter test`
3. Run full analyzer: `dart analyze lib/`
4. Manual end-to-end test: login → Explore → all 3 tabs → scroll → filter by sport → search
5. Test session detail map: tap a session → verify map shows → tap "Buka di Maps" → verify external app opens
