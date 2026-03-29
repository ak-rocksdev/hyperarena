# Role-Switching Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable users with multiple roles to switch to player mode and back, with backend as source of truth and implicit `member` access for all authenticated users.

**Architecture:** Backend `PUT /auth/switch-role` is authoritative. Flutter reads `active_role` and `can_switch_to` from `/me` response. Player profile (StudentProfile + StudentAccount) auto-created on first `member` switch. Full provider reset on switch.

**Tech Stack:** Laravel 12 (Spatie HasRoles, Sanctum), Flutter/Dart (Riverpod, Freezed, GoRouter, SharedPreferences)

**Spec:** `docs/superpowers/specs/2026-03-29-role-switching-design.md`

---

## File Structure

### Laravel (C:\laragon\www\hypercoach)

| Action | File | Responsibility |
|--------|------|---------------|
| Modify | `app/Http/Controllers/Auth/MeController.php` | Add `active_role`, `can_switch_to` to response |
| Modify | `app/Http/Controllers/Auth/SwitchRoleController.php` | Implicit member access + auto-create player profile |
| Create | `database/migrations/xxxx_set_active_role_for_existing_users.php` | Backfill null `active_role` values |
| Create | `tests/Feature/Auth/SwitchRoleTest.php` | Feature tests for role switching |
| Create | `tests/Feature/Auth/MeEndpointTest.php` | Feature tests for /me response shape |

### Flutter (D:\projects\Flutter\hyperarena)

| Action | File | Responsibility |
|--------|------|---------------|
| Modify | `lib/features/auth/data/mappers/role_mapper.dart` | Add `userRoleToBackend()` reverse mapper |
| Modify | `lib/features/auth/data/auth_repository.dart` | Add `switchRole()` to interface |
| Modify | `lib/features/auth/data/api_auth_repository.dart` | Implement `switchRole()` API call |
| Modify | `lib/features/auth/data/mock_auth_repository.dart` | Mock `switchRole()` |
| Modify | `lib/features/auth/data/mappers/auth_response_mapper.dart` | Read `can_switch_to` + `active_role` |
| Modify | `lib/features/auth/providers/auth_provider.dart` | Wire to backend API, loading state, provider invalidation |
| Modify | `lib/shared/widgets/role_switch_section.dart` | Loading indicator, error handling |

---

## Chunk 1: Backend Changes

### Task 1: Migration — Backfill `active_role` for existing users

The `active_role` column already exists (nullable string) from migration `2026_03_02_124212`. We need to set it for users where it's currently null.

**Files:**
- Create: `C:\laragon\www\hypercoach\database\migrations\2026_03_29_000001_set_active_role_for_existing_users.php`

- [ ] **Step 1: Create the migration**

```bash
cd C:\laragon\www\hypercoach
php artisan make:migration set_active_role_for_existing_users
```

- [ ] **Step 2: Write the migration logic**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Set active_role for existing users where it's null
        // Defaults to highest-privilege Spatie role
        DB::table('users')
            ->whereNull('active_role')
            ->whereExists(function ($query) {
                $query->select(DB::raw(1))
                    ->from('model_has_roles')
                    ->whereColumn('model_has_roles.model_id', 'users.id')
                    ->where('model_has_roles.model_type', 'App\\Models\\User');
            })
            ->update(['active_role' => DB::raw("(
                SELECT r.name FROM roles r
                INNER JOIN model_has_roles mhr ON r.id = mhr.role_id
                WHERE mhr.model_id = users.id
                AND mhr.model_type = 'App\\\\Models\\\\User'
                ORDER BY CASE r.name
                    WHEN 'super-admin' THEN 1
                    WHEN 'admin' THEN 2
                    WHEN 'coach' THEN 3
                    WHEN 'member' THEN 4
                    ELSE 5
                END
                LIMIT 1
            )")]);
    }

    public function down(): void
    {
        // No rollback needed — active_role stays populated
    }
};
```

- [ ] **Step 3: Run the migration**

```bash
php artisan migrate
```

- [ ] **Step 4: Verify with tinker**

```bash
php artisan tinker
>>> \App\Models\User::whereNull('active_role')->count()
# Expected: 0
>>> \App\Models\User::pluck('active_role', 'name')->take(5)
# Expected: All users have a role string set
```

- [ ] **Step 5: Commit**

```bash
git add database/migrations/*set_active_role*
git commit -m "migration: backfill active_role for existing users"
```

---

### Task 2: Update MeController — Add `active_role` and `can_switch_to`

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Auth\MeController.php`

- [ ] **Step 1: Read the current MeController**

Read `C:\laragon\www\hypercoach\app\Http\Controllers\Auth\MeController.php` to understand the current response structure.

- [ ] **Step 2: Add `active_role` and `can_switch_to` to the response**

The MeController returns the User model directly (no UserResource). We need to append `active_role` (which already exists on the model) and compute `can_switch_to`.

Add a helper method and modify the response in MeController:

```php
// In MeController's __invoke method, after loading relations:
$user = $request->user();
$user->load(['roles:name', 'permissions:name', 'tenant.sport', 'studentAccount.studentProfile', 'studentGuardians.studentProfile']);
$user->append('photo_urls');

// Compute can_switch_to: Spatie roles + implicit 'member'
$spatieRoles = $user->roles->pluck('name')->toArray();
$canSwitchTo = array_values(array_unique(
    array_merge($spatieRoles, ['member'])
));

// Ensure active_role has a value (fallback to highest-privilege role)
if (! $user->active_role) {
    $priority = ['super-admin', 'admin', 'coach', 'member'];
    $defaultRole = collect($priority)->first(fn ($r) => in_array($r, $spatieRoles)) ?? 'member';
    $user->active_role = $defaultRole;
    $user->save();
}

// Return with computed field
$userData = $user->toArray();
$userData['can_switch_to'] = $canSwitchTo;

return response()->json($userData);
```

**Important:** The exact integration depends on the current response structure. Read the file first, then merge this logic into the existing `__invoke` method.

- [ ] **Step 3: Test manually with curl or Postman**

```bash
curl -H "Authorization: Bearer {token}" http://localhost:8000/v1/auth/me
```

Expected response includes:
```json
{
  "active_role": "admin",
  "can_switch_to": ["admin", "member"],
  "roles": [{"name": "admin"}]
}
```

- [ ] **Step 4: Commit**

```bash
git add app/Http/Controllers/Auth/MeController.php
git commit -m "feat: add active_role and can_switch_to to /me response"
```

---

### Task 3: Update SwitchRoleController — Implicit member + auto-create profile

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Auth\SwitchRoleController.php`

- [ ] **Step 1: Read the current SwitchRoleController**

Read `C:\laragon\www\hypercoach\app\Http\Controllers\Auth\SwitchRoleController.php`.

Current behavior:
- Validates `role` with `'in:admin,coach,member'`
- Checks `$user->hasRole($roleName)`
- Updates `active_role` column
- Returns user with loaded relations

- [ ] **Step 2: Add implicit member access**

Modify the validation and authorization logic:

```php
public function __invoke(Request $request)
{
    $validated = $request->validate([
        'role' => ['required', 'string', 'in:super-admin,admin,coach,member'],
    ]);

    $user = $request->user();
    $roleName = $validated['role'];

    // Implicit member access — all authenticated users can switch to member
    // For all other roles, validate against Spatie
    if ($roleName !== 'member' && ! $user->hasRole($roleName)) {
        return response()->json([
            'message' => 'You do not have this role.',
        ], 403);
    }

    $user->update(['active_role' => $roleName]);

    // Auto-create player profile (StudentProfile + StudentAccount) on first member switch
    if ($roleName === 'member') {
        $this->ensurePlayerProfile($user);
    }

    $user->load(['roles:name', 'permissions:name', 'tenant']);
    $user->append('photo_urls');

    // Add can_switch_to to response (same logic as MeController)
    $spatieRoles = $user->roles->pluck('name')->toArray();
    $canSwitchTo = array_values(array_unique(
        array_merge($spatieRoles, ['member'])
    ));

    $userData = $user->toArray();
    $userData['can_switch_to'] = $canSwitchTo;

    return response()->json($userData);
}
```

- [ ] **Step 3: Add player profile auto-creation method**

```php
private function ensurePlayerProfile(User $user): void
{
    // Check if user already has a StudentAccount (which links to StudentProfile)
    if ($user->studentAccount()->exists()) {
        return;
    }

    $nameParts = explode(' ', $user->name, 2);

    // Create StudentProfile within user's tenant
    $studentProfile = \App\Models\StudentProfile::create([
        'tenant_id'  => $user->tenant_id,
        'first_name' => $nameParts[0],
        'last_name'  => $nameParts[1] ?? null,
    ]);

    // Link User to StudentProfile via StudentAccount (self-managed access)
    \App\Models\StudentAccount::create([
        'user_id'            => $user->id,
        'student_profile_id' => $studentProfile->id,
        'claimed_at'         => now(),
    ]);
}
```

- [ ] **Step 4: Test manually**

```bash
# Switch admin user to member
curl -X PUT -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{"role": "member"}' \
  http://localhost:8000/v1/auth/switch-role

# Expected: 200 with updated user, active_role="member"
# Check DB: student_profiles and student_accounts should have new records
```

```bash
# Switch back to admin
curl -X PUT -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{"role": "admin"}' \
  http://localhost:8000/v1/auth/switch-role

# Expected: 200 with active_role="admin"
```

```bash
# Try switching member-only user to coach (should fail)
curl -X PUT -H "Authorization: Bearer {token_of_member}" \
  -H "Content-Type: application/json" \
  -d '{"role": "coach"}' \
  http://localhost:8000/v1/auth/switch-role

# Expected: 403 "You do not have this role."
```

- [ ] **Step 5: Commit**

```bash
git add app/Http/Controllers/Auth/SwitchRoleController.php
git commit -m "feat: implicit member access + auto-create player profile on switch"
```

---

### Task 4: Backend Feature Tests

**Files:**
- Create: `C:\laragon\www\hypercoach\tests\Feature\Auth\SwitchRoleTest.php`
- Create: `C:\laragon\www\hypercoach\tests\Feature\Auth\MeEndpointTest.php`

- [ ] **Step 1: Create SwitchRoleTest**

```php
<?php

namespace Tests\Feature\Auth;

use App\Models\StudentAccount;
use App\Models\StudentProfile;
use App\Models\Tenant;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class SwitchRoleTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        // Ensure roles exist
        foreach (['super-admin', 'admin', 'coach', 'member'] as $role) {
            Role::findOrCreate($role, 'api');
        }
    }

    private function createUserWithRole(string $roleName, ?Tenant $tenant = null): User
    {
        $tenant ??= Tenant::factory()->create();
        $user = User::factory()->create(['tenant_id' => $tenant->id]);
        $user->assignRole($roleName);
        return $user;
    }

    public function test_any_user_can_switch_to_member(): void
    {
        $user = $this->createUserWithRole('admin');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        $response->assertOk();
        $this->assertEquals('member', $user->fresh()->active_role);
    }

    public function test_member_switch_creates_student_profile_if_missing(): void
    {
        $user = $this->createUserWithRole('admin');

        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        $this->assertDatabaseHas('student_profiles', [
            'tenant_id' => $user->tenant_id,
            'first_name' => explode(' ', $user->name)[0],
        ]);
        $this->assertDatabaseHas('student_accounts', [
            'user_id' => $user->id,
        ]);
    }

    public function test_member_switch_reuses_existing_student_profile(): void
    {
        $user = $this->createUserWithRole('admin');

        // Pre-create profile
        $profile = StudentProfile::create([
            'tenant_id' => $user->tenant_id,
            'first_name' => 'Existing',
        ]);
        StudentAccount::create([
            'user_id' => $user->id,
            'student_profile_id' => $profile->id,
            'claimed_at' => now(),
        ]);

        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        // Should not create a second profile
        $this->assertCount(1, StudentAccount::where('user_id', $user->id)->get());
    }

    public function test_user_cannot_switch_to_unassigned_role(): void
    {
        $user = $this->createUserWithRole('member');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'coach']);

        $response->assertForbidden();
    }

    public function test_user_can_switch_to_assigned_role(): void
    {
        $user = $this->createUserWithRole('coach');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'coach']);

        $response->assertOk();
        $this->assertEquals('coach', $user->fresh()->active_role);
    }

    public function test_switch_response_includes_can_switch_to(): void
    {
        $user = $this->createUserWithRole('admin');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        $response->assertOk();
        $data = $response->json();
        $this->assertArrayHasKey('can_switch_to', $data);
        $this->assertContains('admin', $data['can_switch_to']);
        $this->assertContains('member', $data['can_switch_to']);
    }

    public function test_round_trip_admin_member_admin(): void
    {
        $user = $this->createUserWithRole('admin');

        // Switch to member
        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member'])
            ->assertOk();
        $this->assertEquals('member', $user->fresh()->active_role);

        // Switch back to admin
        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'admin'])
            ->assertOk();
        $this->assertEquals('admin', $user->fresh()->active_role);
    }

    public function test_super_admin_can_switch_to_member(): void
    {
        $user = $this->createUserWithRole('super-admin');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        $response->assertOk();
        $this->assertEquals('member', $user->fresh()->active_role);
    }

    public function test_super_admin_can_switch_back_to_super_admin(): void
    {
        $user = $this->createUserWithRole('super-admin');

        // Switch to member
        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member'])
            ->assertOk();

        // Switch back to super-admin
        $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'super-admin'])
            ->assertOk();
        $this->assertEquals('super-admin', $user->fresh()->active_role);
    }

    public function test_can_switch_to_includes_super_admin_for_super_admin_user(): void
    {
        $user = $this->createUserWithRole('super-admin');

        $response = $this->actingAs($user, 'sanctum')
            ->putJson('/v1/auth/switch-role', ['role' => 'member']);

        $canSwitchTo = $response->json('can_switch_to');
        $this->assertContains('super-admin', $canSwitchTo);
        $this->assertContains('member', $canSwitchTo);
    }
}
```

- [ ] **Step 2: Create MeEndpointTest**

```php
<?php

namespace Tests\Feature\Auth;

use App\Models\Tenant;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class MeEndpointTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        foreach (['super-admin', 'admin', 'coach', 'member'] as $role) {
            Role::findOrCreate($role, 'api');
        }
    }

    public function test_me_returns_active_role(): void
    {
        $tenant = Tenant::factory()->create();
        $user = User::factory()->create([
            'tenant_id' => $tenant->id,
            'active_role' => 'admin',
        ]);
        $user->assignRole('admin');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/v1/auth/me');

        $response->assertOk();
        $this->assertEquals('admin', $response->json('active_role'));
    }

    public function test_me_returns_can_switch_to_with_implicit_member(): void
    {
        $tenant = Tenant::factory()->create();
        $user = User::factory()->create([
            'tenant_id' => $tenant->id,
            'active_role' => 'admin',
        ]);
        $user->assignRole('admin');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/v1/auth/me');

        $response->assertOk();
        $canSwitchTo = $response->json('can_switch_to');
        $this->assertContains('admin', $canSwitchTo);
        $this->assertContains('member', $canSwitchTo);
    }

    public function test_me_sets_active_role_if_null(): void
    {
        $tenant = Tenant::factory()->create();
        $user = User::factory()->create([
            'tenant_id' => $tenant->id,
            'active_role' => null,
        ]);
        $user->assignRole('coach');

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/v1/auth/me');

        $response->assertOk();
        $this->assertEquals('coach', $response->json('active_role'));
        $this->assertEquals('coach', $user->fresh()->active_role);
    }
}
```

- [ ] **Step 3: Run tests**

```bash
cd C:\laragon\www\hypercoach
php artisan test tests/Feature/Auth/SwitchRoleTest.php
php artisan test tests/Feature/Auth/MeEndpointTest.php
```

Expected: All tests pass.

- [ ] **Step 4: Commit**

```bash
git add tests/Feature/Auth/SwitchRoleTest.php tests/Feature/Auth/MeEndpointTest.php
git commit -m "test: add feature tests for role switching and /me endpoint"
```

---

## Chunk 2: Flutter Changes

### Task 5: Add reverse role mapper

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\data\mappers\role_mapper.dart`

- [ ] **Step 1: Read the current role_mapper.dart**

Read `D:\projects\Flutter\hyperarena\lib\features\auth\data\mappers\role_mapper.dart`.

Current content (only has `mapBackendRole`):
```dart
UserRole mapBackendRole(String? activeRole) {
  return switch (activeRole) {
    'member' => UserRole.player,
    'coach' => UserRole.coach,
    'admin' => UserRole.organizer,
    'super-admin' => UserRole.organizer,
    _ => UserRole.player,
  };
}
```

- [ ] **Step 2: Add the reverse mapper**

Add below the existing function:

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

/// Find the original backend role string for a UserRole from the user's
/// availableRoles. This handles the super-admin ↔ organizer ambiguity:
/// both 'admin' and 'super-admin' map to UserRole.organizer, so when
/// switching back, we need the user's actual Spatie role string.
///
/// Falls back to [userRoleToBackend] if no match found in availableRoles.
String resolveBackendRole(UserRole role, List<String> availableRoles) {
  // For roles without ambiguity, direct mapping works
  if (role != UserRole.organizer) return userRoleToBackend(role);

  // For organizer: prefer super-admin if available, then admin
  if (availableRoles.contains('super-admin')) return 'super-admin';
  if (availableRoles.contains('admin')) return 'admin';
  return 'admin'; // fallback
}
```

**Why `resolveBackendRole`:** Both `admin` and `super-admin` map to `UserRole.organizer` in Flutter. When a super-admin switches to member and back, we must send `super-admin` (their actual Spatie role), not `admin`. The `resolveBackendRole` function checks the user's `availableRoles` to find the correct backend string.

- [ ] **Step 3: Commit**

```bash
cd D:\projects\Flutter\hyperarena
git add lib/features/auth/data/mappers/role_mapper.dart
git commit -m "feat: add userRoleToBackend reverse role mapper"
```

---

### Task 6: Add `switchRole()` to auth repository

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\data\auth_repository.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\data\api_auth_repository.dart`
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\data\mock_auth_repository.dart`

- [ ] **Step 1: Read all three files**

Read:
- `D:\projects\Flutter\hyperarena\lib\features\auth\data\auth_repository.dart`
- `D:\projects\Flutter\hyperarena\lib\features\auth\data\api_auth_repository.dart`
- `D:\projects\Flutter\hyperarena\lib\features\auth\data\mock_auth_repository.dart`

- [ ] **Step 2: Add to abstract interface**

In `auth_repository.dart`, add after the `getCurrentUser()` method:

```dart
/// Switch role via PUT /auth/switch-role. Returns updated User.
Future<User> switchRole(String role);
```

- [ ] **Step 3: Implement in ApiAuthRepository**

In `api_auth_repository.dart`, add:

```dart
@override
Future<User> switchRole(String role) async {
  try {
    final response = await _apiClient.put(
      '/v1/auth/switch-role',
      data: {'role': role},
    );
    final json = response.data as Map<String, dynamic>;
    return _mapper.parseUserResponse(json);
  } on DioException catch (e) {
    rethrowDio(e);
  }
}
```

**Note:** Check if `_mapper` is already available as a field, or if the mapper is used differently. The existing `getCurrentUser()` method shows the pattern to follow.

- [ ] **Step 4: Implement in MockAuthRepository**

In `mock_auth_repository.dart`, add:

```dart
@override
Future<User> switchRole(String role) async {
  await Future.delayed(const Duration(milliseconds: 300));
  // Return a mock user with the requested active role
  // Note: MockUsers uses organizerUser (not admin) — check mock_users.dart
  final mockUser = MockUsers.organizerUser;
  return mockUser.copyWith(
    activeRole: role,
    role: mapBackendRole(role),
    availableRoles: ['admin', 'member'],
  );
}
```

Import `mapBackendRole` from `role_mapper.dart` if needed.

- [ ] **Step 4b: Update MockUsers with populated `availableRoles`**

Read `lib/core/mocks/mock_users.dart` and update mock user objects to include `availableRoles`. Without this, the `RoleSwitchSection` will never show in mock mode (it hides when `availableRoles.length <= 1`):

```dart
// Example for organizerUser:
availableRoles: ['admin', 'member'],

// Example for coachUser:
availableRoles: ['coach', 'member'],

// Example for playerUser (single role — switch UI should be hidden):
availableRoles: ['member'],
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/auth_repository.dart
git add lib/features/auth/data/api_auth_repository.dart
git add lib/features/auth/data/mock_auth_repository.dart
git commit -m "feat: add switchRole to auth repository interface and implementations"
```

---

### Task 7: Update AuthResponseMapper — Read `can_switch_to` and `active_role`

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\data\mappers\auth_response_mapper.dart`

- [ ] **Step 1: Read the current mapper**

Read `D:\projects\Flutter\hyperarena\lib\features\auth\data\mappers\auth_response_mapper.dart`.

Key areas to change:
- `_parseUser()` (lines 29-51): Currently reads `availableRoles` from `_extractRoleNames(json['roles'])`
- `_highestRole()` (lines 76-83): Contains `'organizer'` which backend never returns

- [ ] **Step 2: Update `_parseUser()` to read from `can_switch_to`**

Change the `availableRoles` source:

```dart
// BEFORE:
final availableRoles = _extractRoleNames(json['roles']);

// AFTER — read from can_switch_to (flat string array) with fallback:
final canSwitchTo = json['can_switch_to'];
final availableRoles = canSwitchTo is List
    ? canSwitchTo.cast<String>().toList()
    : _extractRoleNames(json['roles']); // fallback for old API
```

- [ ] **Step 3: Update effective role determination to prefer `active_role`**

```dart
// BEFORE:
final activeRole = json['active_role'] as String?;
final effectiveRoleStr = activeRole ?? _highestRole(availableRoles);

// AFTER — same logic but clearer:
final activeRoleStr = json['active_role'] as String?;
final effectiveRoleStr = activeRoleStr ?? _highestRole(availableRoles);
```

This should already be correct based on the current code. Verify line by line.

- [ ] **Step 4: Clean up `_highestRole()` — remove 'organizer'**

```dart
// BEFORE:
const priority = ['super-admin', 'admin', 'organizer', 'coach', 'member'];

// AFTER — remove 'organizer' (Flutter-only name, backend never returns it):
const priority = ['super-admin', 'admin', 'coach', 'member'];
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/mappers/auth_response_mapper.dart
git commit -m "feat: read availableRoles from can_switch_to, clean up priority list"
```

---

### Task 8: Update AuthNotifier — Wire to backend, loading state, provider invalidation

This is the core Flutter change. Multiple modifications to `auth_provider.dart`.

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\auth\providers\auth_provider.dart`

- [ ] **Step 1: Read the current auth_provider.dart**

Read `D:\projects\Flutter\hyperarena\lib\features\auth\providers\auth_provider.dart`.

Key areas:
- Lines 17-18: SharedPreferences keys
- Lines 34-35: Provider definition
- Lines 113-120: `_updateUser()` — preserves old role
- Lines 122-130: `switchRole()` — local only

- [ ] **Step 2: Add `isSwitchingRoleProvider`**

Add near the top of the file (after the `authNotifierProvider` definition):

```dart
/// True while a role switch API call is in flight.
final isSwitchingRoleProvider = StateProvider<bool>((ref) => false);
```

- [ ] **Step 3: Rewrite `switchRole()` to call backend API**

Replace the current `switchRole()` method (lines 122-130):

```dart
/// Switch the current user's active role via backend API.
Future<void> switchRole(UserRole newRole) async {
  final current = state;
  if (current == null || current.role == newRole) return;

  // Use resolveBackendRole to handle super-admin ↔ organizer ambiguity
  final backendRole = resolveBackendRole(
    newRole,
    current.availableRoles,
  );

  try {
    // Call backend
    final repo = ref.read(authRepositoryProvider);
    final updatedUser = await repo.switchRole(backendRole);

    // Update state from API response
    state = updatedUser;
    _prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));

    // Full provider reset
    _invalidateAllFeatureProviders();
  } catch (e) {
    // Re-throw so the UI can show an error
    rethrow;
  }
}
```

Add the import for `resolveBackendRole` at the top:
```dart
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
```

- [ ] **Step 4: Fix `_updateUser()` to use backend's active_role**

Replace the current `_updateUser()` (lines 113-120):

```dart
void _updateUser(User user) {
  // Use backend's active_role as authoritative — do not preserve old role.
  // BEHAVIORAL CHANGE: Previously this preserved the local role via
  // user.copyWith(role: current.role). Now that /me returns active_role,
  // the backend is authoritative. This also means refreshUser() will
  // correctly update the role if it was changed server-side.
  _prefs.setString(_userKey, jsonEncode(user.toJson()));
  state = user;
}
```

**Cold start recovery note:** The existing `build()` method restores the user from SharedPreferences (which now includes the correct `activeRole`). The `refreshUser()` method is called from `_initializeAsyncServices()` which syncs with the backend's `/me` response. This flow already implements the spec's cold start recovery — no additional wiring needed. The user JSON serialized to SharedPreferences includes `activeRole` and `role`, so the cached user restores to the correct role on cold start.

- [ ] **Step 5: Add provider invalidation method**

Add this method to the `AuthNotifier` class:

```dart
/// Invalidate all feature-specific providers after role switch.
void _invalidateAllFeatureProviders() {
  // Marketplace providers (shared/providers/marketplace_providers.dart)
  ref.invalidate(marketplaceVenueListProvider);
  ref.invalidate(marketplaceSessionListProvider);
  ref.invalidate(marketplaceCoachListProvider);

  // Coach feature (coach/providers/)
  ref.invalidate(coachSessionListProvider);

  // Session feature (session/providers/session_providers.dart)
  ref.invalidate(sessionListProvider);

  // Organizer feature (organizer/providers/organizer_providers.dart)
  ref.invalidate(organizerDashboardProvider);
  ref.invalidate(organizerSessionsProvider);

  // Owner feature (owner/providers/owner_providers.dart)
  ref.invalidate(ownerDashboardProvider);

  // Notification feature (notification/providers/notification_providers.dart)
  ref.invalidate(notificationListProvider);
  ref.invalidate(unreadCountProvider);

  // Gamification feature (gamification/providers/gamification_providers.dart)
  ref.invalidate(badgeListProvider);

  // NOTE: Add any new role-scoped providers here as they are created.
  // Check shared/providers/ and each feature's providers/ directory.
}
```

Add the necessary imports at the top of the file. Only import providers that already exist — check each import compiles. **Verify every provider name before importing** — read the provider files to confirm exact names:

- `lib/shared/providers/marketplace_providers.dart` — `marketplaceVenueListProvider`, `marketplaceSessionListProvider`, `marketplaceCoachListProvider`
- `lib/features/coach/providers/coach_session_providers.dart` — `coachSessionListProvider`
- `lib/features/session/providers/session_providers.dart` — `sessionListProvider`
- `lib/features/organizer/providers/organizer_providers.dart` — `organizerDashboardProvider`, `organizerSessionsProvider`
- `lib/features/owner/providers/owner_providers.dart` — `ownerDashboardProvider`
- `lib/features/notification/providers/notification_providers.dart` — `notificationListProvider`, `unreadCountProvider`
- `lib/features/gamification/providers/gamification_providers.dart` — `badgeListProvider`

If any provider name doesn't match, read the file and use the correct exported name.

- [ ] **Step 6: Verify the file compiles**

```bash
cd D:\projects\Flutter\hyperarena
dart analyze lib/features/auth/providers/auth_provider.dart
```

Fix any import or type errors.

- [ ] **Step 7: Commit**

```bash
git add lib/features/auth/providers/auth_provider.dart
git commit -m "feat: wire switchRole to backend API with provider invalidation"
```

---

### Task 9: Update RoleSwitchSection — Loading indicator, error handling

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\shared\widgets\role_switch_section.dart`

- [ ] **Step 1: Read the current widget**

Read `D:\projects\Flutter\hyperarena\lib\shared\widgets\role_switch_section.dart`.

Key areas:
- Lines 23-34: Filters roles, hides if ≤ 1
- Lines 71-80: `_onRoleTap()` — calls `switchRole()` and `context.go()`

- [ ] **Step 2: Update `_onRoleTap()` to handle async + loading**

Replace the `_onRoleTap()` method:

```dart
Future<void> _onRoleTap(
  BuildContext context,
  WidgetRef ref,
  User user,
  UserRole newRole,
) async {
  if (newRole == user.role) return;

  // Set loading state
  ref.read(isSwitchingRoleProvider.notifier).state = true;

  try {
    await ref.read(authNotifierProvider.notifier).switchRole(newRole);
    if (context.mounted) {
      context.go(AppRoutes.home(newRole));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal beralih peran: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    ref.read(isSwitchingRoleProvider.notifier).state = false;
  }
}
```

- [ ] **Step 3: Add loading indicator to the build method**

In the widget's build method, watch the loading state and show an overlay or disable tiles:

```dart
final isSwitching = ref.watch(isSwitchingRoleProvider);
```

**Important:** The `_RoleTile` widget's `onTap` is typed as `VoidCallback` (non-nullable). You cannot pass `null`. Two approaches:

**Option A (preferred):** Change `_RoleTile.onTap` type to `VoidCallback?` and update the `InkWell` to use `onTap: widget.onTap`:
```dart
// In _RoleTile:
final VoidCallback? onTap; // change from VoidCallback to VoidCallback?

// In the tile builder:
onTap: isSwitching ? null : () => _onRoleTap(context, ref, user, role),
```

**Option B:** Keep the type and use an empty function:
```dart
onTap: isSwitching ? () {} : () => _onRoleTap(context, ref, user, role),
```

Optionally show a `CircularProgressIndicator` when `isSwitching` is true.

- [ ] **Step 4: Import isSwitchingRoleProvider**

Add import for `auth_provider.dart` if not already imported (it should be, since it already imports `authNotifierProvider`).

- [ ] **Step 5: Verify compilation**

```bash
dart analyze lib/shared/widgets/role_switch_section.dart
```

- [ ] **Step 6: Commit**

```bash
git add lib/shared/widgets/role_switch_section.dart
git commit -m "feat: add loading state and error handling to role switch UI"
```

---

### Task 10: Manual Integration Testing Checklist

No code changes — this is the verification step.

- [ ] **Step 1: Start backend**

```bash
cd C:\laragon\www\hypercoach
php artisan serve --host=0.0.0.0 --port=8000
```

- [ ] **Step 2: Verify `/me` response in browser/Postman**

- Login as an admin user
- Call `GET /v1/auth/me`
- Verify response includes `active_role` (non-null string)
- Verify response includes `can_switch_to` (array with Spatie roles + `member`)

- [ ] **Step 3: Test role switch flow on device/emulator**

1. Open the Flutter app, login as admin/coach user
2. Go to Profile screen
3. Verify role-switch section is visible (user has > 1 available role)
4. Tap "Player" / "Pemain" role tile
5. Verify loading indicator appears briefly
6. Verify app navigates to player home screen
7. Verify player home screen shows correct data (not stale coach/admin data)

- [ ] **Step 4: Test switch back**

1. From player home, go to Profile
2. Tap the original role (Admin/Coach)
3. Verify app navigates back to admin/coach home screen
4. Verify data is fresh (not stale from before the switch)

- [ ] **Step 5: Test error case**

1. Put device in airplane mode
2. Try to switch roles
3. Verify error toast appears: "Gagal beralih peran: ..."
4. Verify user stays on current role

- [ ] **Step 6: Test cold start recovery**

1. Switch to player mode
2. Kill the app (swipe away from recent apps)
3. Reopen the app
4. Verify it launches into player home screen (restored from SharedPreferences)

- [ ] **Step 7: Test first-time member switch creates profile**

1. Find or create a user in the backend that has NO student_account record
2. Login as that user in the Flutter app
3. Switch to player/member mode
4. Check the database: `student_profiles` and `student_accounts` tables should have new records for this user
5. Switch back and forth — profile should NOT be duplicated

- [ ] **Step 8: Commit any remaining changes**

Stage only the files changed for this feature (avoid `git add -A` which could stage unrelated files):

```bash
git status
# Review changed files — only stage role-switching related files
git add lib/core/mocks/mock_users.dart  # if updated
git commit -m "feat: complete role-switching feature implementation"
```
