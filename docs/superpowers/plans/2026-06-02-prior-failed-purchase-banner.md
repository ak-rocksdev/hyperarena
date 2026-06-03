# Prior Failed Purchase Banner — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Surface a "prior failed purchase" banner on the marketplace session detail screen when a member has an expired/cancelled/rejected purchase for that session in the last 30 days and is not currently booked.

**Architecture:** The BE adds a `prior_failed_purchase` nullable object to the `user_status` block in `SessionController::show()`. The Flutter model (`UserSessionStatus`) gains a nested Freezed class `PriorFailedPurchase`. The session detail screen renders a status-specific amber banner only when `prior != null && !isBooked`.

**Tech Stack:** Laravel 12 (PHP 8.2), Flutter 3 (Dart), Freezed, json_serializable, PHPUnit, Laravel Sanctum.

---

## File Map

### Backend
- **Modify:** `C:\laragon\www\hypercoach\app\Http\Controllers\Marketplace\SessionController.php` — add `prior_failed_purchase` query + field in `user_status`
- **Modify:** `C:\laragon\www\hypercoach\tests\Feature\Http\MarketplaceSessionControllerTest.php` — add 3 new test methods

### Flutter
- **Modify:** `D:\projects\Flutter\hyperarena\lib\features\session\data\models\marketplace_session_detail.dart` — add `PriorFailedPurchase` Freezed class + field on `UserSessionStatus`
- **Regenerated (auto):** `marketplace_session_detail.freezed.dart`, `marketplace_session_detail.g.dart`
- **Modify:** `D:\projects\Flutter\hyperarena\lib\features\session\presentation\screens\marketplace_session_detail_screen.dart` — insert `_PriorFailedBanner` widget + conditional render

---

## Task 1 — BE: add `prior_failed_purchase` to SessionController

**Files:**
- Modify: `C:\laragon\www\hypercoach\app\Http\Controllers\Marketplace\SessionController.php` (lines 80–156)

- [ ] **Step 1: Read the existing show() method to confirm current structure**

Open `SessionController.php` and verify the `user_status` block ends with:
```php
'user_status' => array_merge([
    'credit_balance' => $creditBalance,
    'is_booked' => $existingBooking !== null,
    'booking_id' => $existingBooking?->id,
    'payment_status' => $paymentStatus,
], $this->reviewEligibility->compute($session, $account?->student_profile_id)),
```
This is the insertion point.

- [ ] **Step 2: Insert the prior-failed-purchase query block**

After the `if ($account)` block (around line 108, after `}`) and before the `$participants = ...` line, insert:

```php
        $priorFailedPurchase = null;
        if ($account !== null && $existingBooking === null) {
            $prior = Purchase::withoutGlobalScope('tenant')
                ->where('student_profile_id', $account->student_profile_id)
                ->where('session_id', $session->id)
                ->whereIn('status', ['expired', 'cancelled', 'rejected'])
                ->where('created_at', '>=', now()->subDays(30))
                ->latest('updated_at')
                ->first();

            if ($prior !== null) {
                $priorFailedPurchase = [
                    'purchase_id' => $prior->id,
                    'status'      => $prior->status,
                    'failed_at'   => $prior->updated_at?->toIso8601String(),
                ];
            }
        }
```

Note: `Purchase` is already imported at the top of the file (`use App\Models\Purchase;`) — no new import needed.

- [ ] **Step 3: Add `prior_failed_purchase` to the `user_status` array**

Change the `user_status` block from:
```php
            'user_status' => array_merge([
                'credit_balance' => $creditBalance,
                'is_booked' => $existingBooking !== null,
                'booking_id' => $existingBooking?->id,
                'payment_status' => $paymentStatus,
            ], $this->reviewEligibility->compute($session, $account?->student_profile_id)),
```
To:
```php
            'user_status' => array_merge([
                'credit_balance' => $creditBalance,
                'is_booked' => $existingBooking !== null,
                'booking_id' => $existingBooking?->id,
                'payment_status' => $paymentStatus,
                'prior_failed_purchase' => $priorFailedPurchase,
            ], $this->reviewEligibility->compute($session, $account?->student_profile_id)),
```

- [ ] **Step 4: Run Pint to fix formatting**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe vendor/bin/pint app/Http/Controllers/Marketplace/SessionController.php
```

Expected: one file formatted (or "no files changed" if already clean).

---

## Task 2 — BE: write 3 tests for `prior_failed_purchase`

**Files:**
- Modify: `C:\laragon\www\hypercoach\tests\Feature\Http\MarketplaceSessionControllerTest.php`

The existing `setUp()` already creates `$this->tenant`, `$this->session`, `$this->product`, and `$this->user` — reuse those. For tests that need a member account, create a `StudentProfile` + `StudentAccount` inline (same pattern as `test_join_with_credits_returns_confirmed`).

- [ ] **Step 1: Add helper method `_makeStudentAccount` to reduce repetition**

Append a `private` helper at the bottom of the class (before the final `}`):

```php
    private function makeStudentAccount(): \App\Models\StudentProfile
    {
        app()->instance('current_tenant', $this->tenant);

        $profile = \App\Models\StudentProfile::create([
            'tenant_id' => $this->tenant->id,
            'first_name' => 'Test',
            'last_name' => 'Player',
        ]);

        \App\Models\StudentAccount::create([
            'user_id'            => $this->user->id,
            'student_profile_id' => $profile->id,
            'claimed_at'         => now(),
        ]);

        app()->forgetInstance('current_tenant');

        return $profile;
    }
```

- [ ] **Step 2: Write test — expired purchase surfaces in user_status**

Append to the class:

```php
    public function test_session_detail_includes_prior_failed_purchase_when_member_had_expired_one(): void
    {
        $profile = $this->makeStudentAccount();

        // Create expired purchase for this session
        \App\Models\Purchase::create([
            'student_profile_id' => $profile->id,
            'product_id'         => $this->product->id,
            'session_id'         => $this->session->id,
            'status'             => 'expired',
            'payment_method'     => 'manual',
            'provider'           => 'manual',
            'amount_base'        => 50000,
            'fee_amount'         => 0,
            'amount_total'       => 50000,
            'currency'           => 'IDR',
            'created_at'         => now()->subDays(5),
            'updated_at'         => now()->subDays(4),
        ]);

        Sanctum::actingAs($this->user);

        $response = $this->getJson("/api/v1/marketplace/sessions/{$this->session->id}");

        $response->assertOk();
        $this->assertEquals('expired', $response->json('user_status.prior_failed_purchase.status'));
        $this->assertNotNull($response->json('user_status.prior_failed_purchase.purchase_id'));
        $this->assertNotNull($response->json('user_status.prior_failed_purchase.failed_at'));
    }
```

- [ ] **Step 3: Write test — omits prior failure when currently booked**

```php
    public function test_session_detail_omits_prior_failed_purchase_when_currently_booked(): void
    {
        $profile = $this->makeStudentAccount();

        // Create an expired purchase
        \App\Models\Purchase::create([
            'student_profile_id' => $profile->id,
            'product_id'         => $this->product->id,
            'session_id'         => $this->session->id,
            'status'             => 'expired',
            'payment_method'     => 'manual',
            'provider'           => 'manual',
            'amount_base'        => 50000,
            'fee_amount'         => 0,
            'amount_total'       => 50000,
            'currency'           => 'IDR',
            'created_at'         => now()->subDays(3),
            'updated_at'         => now()->subDays(2),
        ]);

        // Also create an active booking (session_students row)
        \App\Models\SessionStudent::create([
            'session_id'         => $this->session->id,
            'student_profile_id' => $profile->id,
            'booked_at'          => now(),
        ]);

        Sanctum::actingAs($this->user);

        $response = $this->getJson("/api/v1/marketplace/sessions/{$this->session->id}");

        $response->assertOk();
        $this->assertNull($response->json('user_status.prior_failed_purchase'));
        $this->assertTrue($response->json('user_status.is_booked'));
    }
```

Note: check that `\App\Models\SessionStudent` exists — it is referenced in the controller as `$session->sessionStudents()`. If the model name differs (e.g., `SessionEnrollment`), adjust accordingly.

- [ ] **Step 4: Verify SessionStudent model name**

```bash
find /c/laragon/www/hypercoach/app/Models -name "Session*.php" | head -10
```

If the file is `SessionStudent.php`, proceed. If it's named differently, update the `\App\Models\SessionStudent::create(...)` line in the test above to match.

- [ ] **Step 5: Write test — omits purchase older than 30 days**

```php
    public function test_session_detail_omits_prior_failed_purchase_when_older_than_30_days(): void
    {
        $profile = $this->makeStudentAccount();

        // Create expired purchase from 31 days ago
        \App\Models\Purchase::create([
            'student_profile_id' => $profile->id,
            'product_id'         => $this->product->id,
            'session_id'         => $this->session->id,
            'status'             => 'expired',
            'payment_method'     => 'manual',
            'provider'           => 'manual',
            'amount_base'        => 50000,
            'fee_amount'         => 0,
            'amount_total'       => 50000,
            'currency'           => 'IDR',
            'created_at'         => now()->subDays(31),
            'updated_at'         => now()->subDays(31),
        ]);

        Sanctum::actingAs($this->user);

        $response = $this->getJson("/api/v1/marketplace/sessions/{$this->session->id}");

        $response->assertOk();
        $this->assertNull($response->json('user_status.prior_failed_purchase'));
    }
```

- [ ] **Step 6: Run Pint on the test file**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe vendor/bin/pint tests/Feature/Http/MarketplaceSessionControllerTest.php
```

---

## Task 3 — BE: run tests + commit + deploy

- [ ] **Step 1: Run the Marketplace + SessionDetail test filter**

```bash
cd /c/laragon/www/hypercoach
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter='MarketplaceSessionControllerTest' 2>&1 | tail -10
```

Expected: `Tests: 7 passed` (4 existing + 3 new). If any fail, read the full output and fix before proceeding.

- [ ] **Step 2: Broad regression check**

```bash
/c/laragon/bin/php/php-8.2.28-Win32-vs16-x64/php.exe artisan test --filter='Marketplace|SessionDetail' 2>&1 | tail -5
```

Expected: no failures.

- [ ] **Step 3: Commit BE changes**

```bash
cd /c/laragon/www/hypercoach
git add app/Http/Controllers/Marketplace/SessionController.php tests/Feature/Http/MarketplaceSessionControllerTest.php
git commit -m "Marketplace: surface prior_failed_purchase in session detail user_status

Lets mobile show 'Anda pernah memesan' banner for members who had an
expired/cancelled/rejected purchase for this session in the last 30 days
and are not currently booked."
```

No `Co-Authored-By`.

- [ ] **Step 4: Push and deploy**

```bash
git push origin develop
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh develop 2>&1 | tail -3"
```

---

## Task 4 — Flutter: add `PriorFailedPurchase` Freezed class + field

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\session\data\models\marketplace_session_detail.dart`

- [ ] **Step 1: Add `PriorFailedPurchase` class and `priorFailedPurchase` field**

In `marketplace_session_detail.dart`, after the closing `}` of `UserSessionStatus`, append the new Freezed class:

```dart
@freezed
class PriorFailedPurchase with _$PriorFailedPurchase {
  const factory PriorFailedPurchase({
    @JsonKey(name: 'purchase_id') required int purchaseId,
    required String status,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
  }) = _PriorFailedPurchase;

  factory PriorFailedPurchase.fromJson(Map<String, dynamic> json) =>
      _$PriorFailedPurchaseFromJson(json);
}
```

And inside `UserSessionStatus`, add the new optional field after `reviewBlockedReason`:

```dart
@freezed
class UserSessionStatus with _$UserSessionStatus {
  const factory UserSessionStatus({
    @JsonKey(name: 'credit_balance') @Default(0) int creditBalance,
    @JsonKey(name: 'is_booked') @Default(false) bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson) String? bookingId,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'can_review') @Default(false) bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
    @JsonKey(name: 'prior_failed_purchase') PriorFailedPurchase? priorFailedPurchase,
  }) = _UserSessionStatus;

  factory UserSessionStatus.fromJson(Map<String, dynamic> json) =>
      _$UserSessionStatusFromJson(json);
}
```

- [ ] **Step 2: Run build_runner**

```bash
cd /d/projects/Flutter/hyperarena
dart run build_runner build --delete-conflicting-outputs 2>&1 | tail -10
```

Expected: `[INFO] Succeeded after ...` with no errors. The files `marketplace_session_detail.freezed.dart` and `marketplace_session_detail.g.dart` will be regenerated.

- [ ] **Step 3: Verify generated files include PriorFailedPurchase**

Check that the `.g.dart` file now contains `PriorFailedPurchase` JSON serialization:

```bash
grep -n "PriorFailedPurchase\|prior_failed_purchase" /d/projects/Flutter/hyperarena/lib/features/session/data/models/marketplace_session_detail.g.dart
```

Expected: lines for `_$PriorFailedPurchaseFromJson`, `prior_failed_purchase`, `purchaseId`, `failedAt`.

---

## Task 5 — Flutter: add `_PriorFailedBanner` widget + conditional render

**Files:**
- Modify: `D:\projects\Flutter\hyperarena\lib\features\session\presentation\screens\marketplace_session_detail_screen.dart`

- [ ] **Step 1: Add the `_PriorFailedBanner` widget class**

Append the following class near the bottom of the file, after `_EmptySlotAvatar` and before `_PulseHighlight`:

```dart
// ── Prior failed purchase banner ──────────────────────────────

class _PriorFailedBanner extends StatelessWidget {
  final PriorFailedPurchase prior;

  const _PriorFailedBanner({required this.prior});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (prior.status) {
      'expired' => (
        Icons.history,
        'Anda pernah memesan sesi ini',
        'Pembayaran sebelumnya kedaluwarsa. Slot sudah dilepas, silakan pesan kembali jika masih ingin gabung.',
      ),
      'cancelled' => (
        Icons.cancel_outlined,
        'Pesanan sebelumnya dibatalkan',
        'Anda membatalkan pesanan untuk sesi ini. Silakan pesan kembali jika masih ingin gabung.',
      ),
      'rejected' => (
        Icons.block,
        'Pesanan sebelumnya ditolak',
        'Pembayaran sebelumnya ditolak admin. Silakan pesan kembali jika masih ingin gabung.',
      ),
      _ => (
        Icons.info_outline,
        'Pesanan sebelumnya tidak berhasil',
        'Silakan pesan kembali jika masih ingin gabung.',
      ),
    };

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppDimensions.md,
      ),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.warningDark),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.warningDark,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warningDark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

Note: uses `AppColors.warningLight` / `AppColors.warningDark` (design-system tokens already in `app_colors.dart`) rather than raw `Colors.amber.*`.

- [ ] **Step 2: Add banner to the `_DetailBody` build method**

In `_DetailBody.build()`, the `Column` inside `SliverToBoxAdapter` currently starts:

```dart
children: [
  Text(session.safeTitle, style: AppTypography.headingLarge),
  if (session.tenant != null) ...[
    ...
  ],
  const SizedBox(height: AppDimensions.lg),
  // Date & time card
  _InfoCard(...)
```

Insert the banner AFTER the `const SizedBox(height: AppDimensions.lg)` that follows the tenant line, and BEFORE the date/time `_InfoCard`. The result should be:

```dart
  const SizedBox(height: AppDimensions.lg),

  // Prior failed purchase banner — shown when member had a non-confirmed
  // purchase for this session in the last 30 days and is not currently booked
  if (userStatus.priorFailedPurchase != null && !userStatus.isBooked)
    _PriorFailedBanner(prior: userStatus.priorFailedPurchase!),

  // Date & time card
  _InfoCard(
    icon: Icons.calendar_today,
    ...
  ),
```

- [ ] **Step 3: Run flutter analyze on the session feature**

```bash
cd /d/projects/Flutter/hyperarena
flutter analyze lib/features/session/ 2>&1 | tail -10
```

Expected: `No issues found!` (or only pre-existing warnings — zero new errors).

---

## Task 6 — Flutter: build APK + commit

- [ ] **Step 1: Build release APK**

```bash
cd /d/projects/Flutter/hyperarena
flutter build apk --release --target=lib/main_dev.dart --dart-define=APP_ENV=dev --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana 2>&1 | tail -5
```

Expected: `Built build/app/outputs/flutter-apk/app-release.apk`.

- [ ] **Step 2: Copy to releases/**

```bash
cp /d/projects/Flutter/hyperarena/build/app/outputs/flutter-apk/app-release.apk \
   /d/projects/Flutter/hyperarena/releases/HyperArena-v0.3.3+13-dev-prior-failed-banner-20260602.apk
ls -lh /d/projects/Flutter/hyperarena/releases/HyperArena-v0.3.3+13-dev-prior-failed-banner-20260602.apk
```

Expected: file size listed (typically 20–40 MB for a release APK).

- [ ] **Step 3: Commit Flutter changes**

```bash
cd /d/projects/Flutter/hyperarena
git add lib/features/session/data/models/marketplace_session_detail.dart \
        lib/features/session/data/models/marketplace_session_detail.freezed.dart \
        lib/features/session/data/models/marketplace_session_detail.g.dart \
        lib/features/session/presentation/screens/marketplace_session_detail_screen.dart \
        releases/HyperArena-v0.3.3+13-dev-prior-failed-banner-20260602.apk
git commit -m "Session detail: banner for prior expired/cancelled/rejected purchase

Shows when member has a non-confirmed prior purchase for this session
(last 30 days) and isn't currently booked. Status-specific wording
(expired/cancelled/rejected). Amber soft styling — informational, not alarming."
```

No `Co-Authored-By`.

---

## Self-Review Checklist

- [ ] BE field returns `null` when no prior purchase found?
- [ ] BE returns `null` when `$account` is null (guest)?
- [ ] BE returns `null` when `$existingBooking !== null` (currently booked)?
- [ ] BE caps the lookback to 30 days via `created_at >= now()->subDays(30)`?
- [ ] BE only matches statuses in `['expired', 'cancelled', 'rejected']`?
- [ ] 3 new BE tests pass (expired surfaces, booked suppresses, >30d suppresses)?
- [ ] Flutter `PriorFailedPurchase` Freezed class has `purchaseId`, `status`, `failedAt` with correct `@JsonKey` names?
- [ ] `UserSessionStatus` has `@JsonKey(name: 'prior_failed_purchase')` on the new field?
- [ ] `build_runner` ran cleanly — no conflicts?
- [ ] Banner only rendered when `priorFailedPurchase != null && !isBooked`?
- [ ] 3 status variants (expired/cancelled/rejected) have distinct copy + icons?
- [ ] Banner uses design-system tokens (`AppColors.warningLight`, `AppDimensions.*`) not raw `Colors.*`?
- [ ] `flutter analyze` zero new errors?
- [ ] APK builds and is copied to `releases/`?
- [ ] Both commits have no `Co-Authored-By` line?
