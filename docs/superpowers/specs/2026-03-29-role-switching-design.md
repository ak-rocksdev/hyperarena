# Role-Switching Feature Design

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan.

**Goal:** Enable users with multiple roles (admin, coach) to switch to player mode and back without creating duplicate accounts.

**Architecture:** Implicit `member` access for all authenticated users. Backend (`PUT /auth/switch-role`) is the single source of truth. Flutter reads roles from the API and uses them for UI routing only. Player profile is auto-created on first switch to `member`.

**Tech Stack:** Laravel 12 (Spatie HasRoles, Sanctum), Flutter/Dart (Riverpod, Freezed, GoRouter, SharedPreferences)

---

## Scope

### In Scope

- Wire Flutter `switchRole()` to backend API
- Backend returns `active_role` and `can_switch_to` in `/me` response
- Implicit `member` access for all authenticated users (no Spatie auto-grant)
- Auto-create player profile on first switch to `member`
- Full provider reset + navigation on role switch
- Cold start recovery via SharedPreferences + `/me` validation
- Hide role-switch UI when only one switchable role
- One-time migration to set `active_role` for existing users

### Out of Scope

- `courtOwner` role (future phase, no backend mapping yet)
- Open/coachless sessions (future phase, requires web + Flutter sync)
- Web admin panel changes (no changes needed due to implicit access model)

---

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Access model | Implicit `member` — no Spatie auto-grant | Keeps Spatie roles clean for web admin panel. No role pollution. |
| Switch trigger | `PUT /auth/switch-role` | Backend is single source of truth. Flutter never makes auth decisions. |
| Switch effect | Immediate full reset | Different roles load different data. Full reset prevents stale state bugs. |
| API headers | No extra role header | Backend tracks `active_role` in DB. Adding a header creates second source of truth. |
| Recovery | `/me` returns `active_role` + local SharedPreferences cache | Backend is authoritative. Local cache is for fast cold start only. |
| Role authority | Spatie drives both web and mobile | One permission system, one source of truth. Flutter only decides what to show. |
| Switch UI visibility | Hidden when `availableRoles <= 1` | Regular players (only `member`) don't need a switcher. |
| Player profile | Auto-created on first switch to `member` | No blocking step. User can browse immediately. |

---

## Backend Changes (Laravel)

### 1. `/me` Endpoint Enhancement

The `/me` (or `/auth/me`) response must include:

```json
{
  "user": {
    "id": 1,
    "name": "Haris Mustamsikin",
    "email": "haris@example.com",
    "active_role": "admin",
    "roles": ["admin"],
    "can_switch_to": ["admin", "member"]
  }
}
```

- `active_role`: Current role (never null). If null in DB, default to highest-privilege Spatie role.
- `roles`: Spatie-assigned roles (unchanged).
- `can_switch_to`: All switchable roles = Spatie roles + implicit `member`. This is the authoritative list Flutter uses.

### 2. `SwitchRoleController` Update

Current flow (unchanged for non-member):
1. Validate role is a valid role string
2. Check `$user->hasRole($role)` via Spatie
3. Update `active_role` column

New flow for `member`:
1. If requested role is `member` → skip Spatie check (implicit access)
2. Update `active_role` to `member`
3. If user has no player profile → auto-create from user data
4. Return updated user data (same shape as `/me`)

```php
// Pseudocode for SwitchRoleController
public function __invoke(Request $request)
{
    $validated = $request->validate(['role' => 'required|string']);
    $user = $request->user();
    $role = $validated['role'];

    // Implicit member access for all authenticated users
    if ($role !== 'member' && !$user->hasRole($role)) {
        return response()->json(['message' => 'Unauthorized role'], 403);
    }

    $user->update(['active_role' => $role]);

    // Auto-create player profile on first member switch
    // Verify the correct relationship name in User model
    if ($role === 'member' && !$user->playerProfile()->exists()) {
        $this->createPlayerProfile($user);
    }

    // Return same shape as /me — includes active_role, roles, can_switch_to
    return new UserResource($user->fresh()->load('roles'));
}
```

### 3. Player Profile Auto-Creation

When switching to `member` for the first time. **Important:** The Laravel relationship name for the player profile must be verified against the actual User model. The coaching domain uses `StudentProfile` (for session students), but the general player profile may use a different model/relationship (e.g., `PlayerProfile` / `playerProfile()`). Check `User.php` for the correct relationship before implementing.

```php
private function createPlayerProfile(User $user): void
{
    $nameParts = explode(' ', $user->name, 2);
    // Use the correct relationship — verify in User model
    // This may be playerProfile(), studentProfile(), or similar
    $user->playerProfile()->create([
        'first_name' => $nameParts[0],
        'last_name'  => $nameParts[1] ?? null,
        // Other fields left null — user can complete later
    ]);
}
```

### 4. One-Time Migration

```php
// Set active_role for existing users where it's null
// Default to highest-privilege role
// Uses CASE WHEN for database portability (works on MySQL, PostgreSQL, SQLite)
DB::table('users')
    ->whereNull('active_role')
    ->update(['active_role' => DB::raw("(
        SELECT name FROM roles
        INNER JOIN model_has_roles ON roles.id = model_has_roles.role_id
        WHERE model_has_roles.model_id = users.id
        AND model_has_roles.model_type = 'App\\\\Models\\\\User'
        ORDER BY CASE name
            WHEN 'super-admin' THEN 1
            WHEN 'admin' THEN 2
            WHEN 'coach' THEN 3
            WHEN 'member' THEN 4
            ELSE 5
        END
        LIMIT 1
    )")]);
```

---

## Flutter Changes

### 1. Add Reverse Role Mapper

Create `userRoleToBackend()` in `role_mapper.dart` — the reverse of the existing `mapBackendRole()`:

```dart
/// Maps Flutter UserRole enum → backend role string.
/// Note: organizer maps to 'admin' (not 'super-admin') since the switch
/// endpoint validates against the user's actual Spatie roles.
String userRoleToBackend(UserRole role) => switch (role) {
  UserRole.player => 'member',
  UserRole.coach => 'coach',
  UserRole.organizer => 'admin',
  UserRole.courtOwner => 'court-owner', // future — not used yet
};
```

### 2. Wire `switchRole()` to Backend API

Current `AuthNotifier.switchRole()` (local only):
```dart
void switchRole(UserRole role) {
  state = state.whenData((user) => user.copyWith(role: role));
}
```

New flow — uses API response directly instead of manually constructing state:
```dart
Future<void> switchRole(UserRole role) async {
  // 1. Call backend — returns updated user data (same shape as /me)
  final backendRole = userRoleToBackend(role);
  final updatedUser = await authRepository.switchRole(backendRole);

  // 2. Update state from API response (not manual copyWith)
  // AuthNotifier is a Notifier<User?>, not AsyncNotifier — state is User?, not AsyncValue
  state = updatedUser;

  // 3. Persist to SharedPreferences
  await prefs.setString('active_role', backendRole);

  // 4. Invalidate all cached providers (see Section 6 for full list)
  _invalidateAllFeatureProviders();
}
```

**Loading state during switch:** Since `AuthNotifier` is a `Notifier` (not `AsyncNotifier`), use a separate provider for the switching-in-progress state:

```dart
/// True while a role switch API call is in flight.
final isSwitchingRoleProvider = StateProvider<bool>((ref) => false);
```

The `RoleSwitchSection` widget reads this to show a loading indicator and disable the switch tiles during the API call.

### 3. Update Auth Repository to Return User

Add `switchRole()` to the `AuthRepository` interface AND its implementations:

```dart
// In AuthRepository (abstract interface)
Future<User> switchRole(String role);

// In ApiAuthRepository (implementation)
@override
Future<User> switchRole(String role) async {
  final response = await _apiClient.put('/auth/switch-role', data: {'role': role});
  final json = response.data as Map<String, dynamic>;
  return AuthResponseMapper.mapUser(json);
}

// In MockAuthRepository
@override
Future<User> switchRole(String role) async {
  // Return mock user with updated activeRole
  return mockUser.copyWith(activeRole: role);
}
```

### 4. Update `AuthResponseMapper`

**Critical change:** Read `availableRoles` from `can_switch_to` (a flat string array), NOT from `roles` (an array of Spatie role objects). These have different structures:

```dart
// BEFORE (current code — reads from Spatie role objects):
// roles: [{"id": 1, "name": "admin", ...}]
availableRoles: _extractRoleNames(json['roles']),

// AFTER (reads from computed flat array):
// can_switch_to: ["admin", "member"]
availableRoles: (json['can_switch_to'] as List<dynamic>?)
    ?.cast<String>() ?? [],
```

Also read `active_role` directly instead of guessing from the roles array:
```dart
final activeRoleStr = json['active_role'] as String?;
final effectiveRole = activeRoleStr != null
    ? mapBackendRole(activeRoleStr)
    : _determineEffectiveRole(roles); // fallback for old API
```

**Fix `_updateUser` to respect backend role:** The current `_updateUser` preserves the existing local role on refresh:
```dart
// BEFORE — preserves old role, ignoring backend
final updated = current != null ? user.copyWith(role: current.role) : user;

// AFTER — uses backend's active_role as authoritative
// Only preserve local role if backend didn't specify one
final updated = user;
```

### 5. Update User Model

Ensure `User` model includes:
- `activeRole` (String?) — from backend's `active_role`
- `availableRoles` (List<String>) — from backend's `can_switch_to` (flat string array)

### 6. Full Provider Reset on Switch

After successful switch, invalidate all feature-specific providers. Explicit list to prevent missing any:

```dart
void _invalidateAllFeatureProviders() {
  // Marketplace providers (shared/providers/marketplace_providers.dart)
  ref.invalidate(marketplaceVenueListProvider);
  ref.invalidate(marketplaceSessionListProvider);
  ref.invalidate(marketplaceCoachListProvider);

  // Coach feature
  ref.invalidate(coachSessionListProvider);

  // Session feature
  ref.invalidate(sessionListProvider);

  // Organizer feature
  ref.invalidate(organizerDashboardProvider);
  ref.invalidate(organizerSessionsProvider);

  // Owner feature
  ref.invalidate(ownerDashboardProvider);

  // Notification feature
  ref.invalidate(unreadCountProvider);

  // Gamification feature
  ref.invalidate(badgeListProvider);

  // IMPORTANT: Check all providers in shared/providers/ and each
  // feature's providers/ directory. Every FutureProvider,
  // AsyncNotifierProvider, and NotifierProvider that loads
  // role-scoped data must be listed here.
}

// Navigate to new home
router.go(AppRoutes.home(role));
```

**Note for implementer:** Check all `*Provider` exports in `shared/providers/` and each feature's `providers/` directory. Every `FutureProvider`, `AsyncNotifierProvider`, and `NotifierProvider` that loads role-scoped data must be listed here.

### 7. Cold Start Recovery

On app launch:
1. Read `active_role` from SharedPreferences → show correct home screen immediately
2. Call `/me` endpoint
3. If backend's `active_role` differs from cached → update local state + navigate

**UX note:** The splash screen currently navigates after a 2-second delay. If `/me` returns after navigation has already occurred with a different role, the user will see a brief flash of the wrong home screen. This is an acceptable tradeoff — the correction happens within milliseconds of the `/me` response. If this proves jarring in testing, gate navigation on the `/me` response with a timeout fallback to the cached role.

### 8. Role-Switch UI Visibility

In `RoleSwitchSection`:
```dart
// Only show if user has more than one switchable role
if (user.availableRoles.length <= 1) return const SizedBox.shrink();
```

### 9. Update Mock Auth Repository

Update `MockAuthRepository` and mock user data to support the new feature:
- Add `switchRole()` method to mock repository
- Populate `availableRoles` in mock user objects (e.g., `['admin', 'member']`)
- Ensure mock mode exercises the role-switch flow

---

## Role Mapping Reference

| Backend (Spatie) | Flutter (UserRole) | Notes |
|------------------|-------------------|-------|
| `member` | `player` | Implicit for all users |
| `coach` | `coach` | Direct mapping |
| `admin` | `organizer` | Admin acts as organizer in Flutter |
| `super-admin` | `organizer` | Same as admin in Flutter |
| *(future)* | `courtOwner` | No backend mapping yet |

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| `PUT /auth/switch-role` fails (network) | Show error toast, stay on current role |
| `PUT /auth/switch-role` returns 403 | Show "Role not available" message |
| `/me` returns different `active_role` than cached | Override local state silently |
| Player profile creation fails | Log error, switch still succeeds (profile can be created later) |
| App killed mid-switch | Cold start reads SharedPreferences, `/me` corrects if needed |

---

## Testing Checklist

### Backend (Laravel)

- [ ] `/me` returns `active_role` field (never null)
- [ ] `/me` returns `can_switch_to` including implicit `member`
- [ ] `PUT /auth/switch-role` accepts `member` for any authenticated user
- [ ] `PUT /auth/switch-role` rejects roles user doesn't have (e.g., `coach` for plain member)
- [ ] `PUT /auth/switch-role` to `member` auto-creates player profile if missing
- [ ] `PUT /auth/switch-role` to `member` reuses existing player profile if present
- [ ] Auto-created profile has correct first_name/last_name from user.name
- [ ] Migration sets `active_role` for existing null users
- [ ] Player-scoped API endpoints work for users who switched to `member`
- [ ] Switch back from `member` to original role works correctly

### Frontend (Flutter)

- [ ] `switchRole()` calls backend API before updating local state
- [ ] `switchRole()` uses API response to update state (not manual copyWith)
- [ ] Switch fails gracefully if API returns error (stays on current role)
- [ ] Full provider reset happens after successful switch (all providers in invalidation list)
- [ ] Navigation goes to correct home screen per role
- [ ] `availableRoles` reads from `can_switch_to` (flat string array), NOT from `roles` (object array)
- [ ] `AuthResponseMapper` reads `active_role` from `/me` response
- [ ] `_updateUser` no longer preserves old role — uses backend's `active_role` as authoritative
- [ ] `userRoleToBackend()` reverse mapper correctly maps all roles (player→member, organizer→admin, etc.)
- [ ] Role-switch UI hidden when only one role available
- [ ] Role-switch UI shows when multiple roles available
- [ ] `isSwitchingRoleProvider` drives loading indicator during switch
- [ ] Cold start reads cached role from SharedPreferences
- [ ] Cold start overrides with `/me` response when it arrives
- [ ] Role switch from coach → player → coach preserves no stale state
- [ ] Role switch from admin/organizer → player → admin/organizer preserves no stale state
- [ ] Error toast shown on switch failure
- [ ] Mock auth repository updated with `switchRole()` and populated `availableRoles`

---

## Notes

- **`super-admin` and multi-tenancy:** When a `super-admin` switches to `member`, they should see data scoped to their current tenant (if applicable). The `tenantSlug` pattern in the codebase should handle this naturally since API scoping is per-request, but verify during implementation.
- **`organizer` in priority list:** The `_highestRole` priority list in `auth_response_mapper.dart` includes `'organizer'` — a Flutter-only name that the backend never returns. Clean this up as part of the mapper changes.

## Future Considerations

- **`courtOwner` role:** Will need backend Spatie role + Flutter mapping when venue owner features are built.
- **Open/coachless sessions:** Sessions without a coach, requiring web + Flutter sync. The player profile foundation built here supports this. See project memory for details.
- **Profile completion prompt:** After auto-creating a player profile, optionally prompt user to add photo/details. Not blocking — enhancement for later.
