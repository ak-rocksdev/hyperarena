# Organizer — Edit Session + Cover Photo — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let an organizer edit an existing session's details (reusing the create form in an "edit mode") and manage its single cover photo (camera / gallery / interactive 16:9 crop / replace / remove).

**Architecture:** Two decoupled phases. **Phase 1 (cover photo)** ships first and independently: one new BE delete route + a self-contained Flutter cover editor reachable from the detail hero and the post-create prompt. **Phase 2 (edit)** reuses the existing `CreateSessionScreen` + `CreateSessionDraft` in an edit mode, hydrated from a new flat `editPayload` BE endpoint and saved through a new `PUT` route that reuses the existing admin `SessionController@update`.

**Tech Stack:** Flutter (Riverpod `Notifier`, go_router, Dio via `ApiClient`, freezed, `image_picker`, new `image_cropper`) + Laravel 12 (Sanctum, spatie permissions, existing `resolve.tenant.from-user` middleware).

## Global Constraints

- Two repos: FE `/Users/abdulkadir/Projects/Dev/Mobile/hyperarena`, BE `/Users/abdulkadir/Projects/Dev/Web/hypercoach`.
- Copy is **Indonesian**, sentence case, active voice.
- WCAG AA: do not use `AppColors.textTertiary` (#94A3B8) for essential text; use `textSecondary` / `neutral500`.
- No API keys or secrets committed.
- BE reuses existing admin controllers via `resolve.tenant.from-user`; tenant is always from the authenticated user (never an `X-Tenant` header).
- BE cover contract: `PhotoService::HERO_UPLOAD_RULES` = `required, image, mimes:jpg,jpeg,png,webp, max:5120, dimensions:max_width=4096,max_height=4096`. Upload field name is `photo`. Single cover per session (`sessions.photo_path`); **not** a gallery.
- BE `Session` model maps to table `coaching_sessions`. Marketplace API base is `/api/v1/marketplace/...`.
- **BE test fixtures:** for a "normal, editable" session, use the exact `status` string that `POST organizer/sessions` produces (create one via the endpoint first if unsure) — do not guess the enum value. `update()` only blocks `cancelled`/`completed`, so any other real status is editable.
- **FE repo tests:** use whichever mocking approach the existing `api_organizer_repository_test.dart` already uses (mocktail on `ApiClient`, or `http_mock_adapter` on Dio). The plan's test snippets assume mocktail on `ApiClient`; adapt the mechanics to the file — the assertion (a request hits the right method + path) is what matters.
- Deviations from the design spec (`docs/superpowers/specs/2026-07-06-...`), all discovered from the real code: prefill uses a new flat `editPayload` endpoint (not `Admin@show`); `getSessionDetail` replacement is dropped (not needed); `toUpdatePayload` is folded into the existing `toCreatePayload`.

---

# PHASE 1 — Cover Photo Management (ships independently)

## Task 1: BE — expose `DELETE organizer/sessions/{id}/photo`

**Files:**
- Modify: `routes/api.php` (organizer mutations group, ~line 748-753)
- Test: `tests/Feature/Marketplace/OrganizerSessionPhotoTest.php` (create)

**Interfaces:**
- Produces: `DELETE /api/v1/marketplace/organizer/sessions/{id}/photo` → `Admin\SessionPhotoController@destroy` (already exists; clears `photo_path`, returns `{session}`).

- [ ] **Step 1: Write the failing test**

Create `tests/Feature/Marketplace/OrganizerSessionPhotoTest.php`. Mirror the setup helpers from `tests/Feature/Marketplace/OrganizerCreateSessionTest.php` (copy `setUp`, `makeTenant`, `makeUser`, `makeCoach` verbatim), then add:

```php
    private function makeSession(array $overrides = []): \App\Models\Session
    {
        return \App\Models\Session::create(array_merge([
            'tenant_id' => $this->tenant->id,
            'type' => 'group',
            'start_at' => now()->addDay(),
            'duration_minutes' => 90,
            'capacity' => 8,
            'status' => 'scheduled',
            'photo_path' => 'abc12345',
        ], $overrides));
    }

    public function test_organizer_deletes_session_photo(): void
    {
        Sanctum::actingAs($this->organizer);
        $session = $this->makeSession();

        $this->deleteJson("/api/v1/marketplace/organizer/sessions/{$session->id}/photo")
            ->assertOk();

        $this->assertDatabaseHas('coaching_sessions', [
            'id' => $session->id,
            'photo_path' => null,
        ]);
    }

    public function test_delete_photo_requires_manage_sessions(): void
    {
        $member = $this->makeUser($this->tenant, 'member', 'member@primary.test');
        Sanctum::actingAs($member);
        $session = $this->makeSession();

        $this->deleteJson("/api/v1/marketplace/organizer/sessions/{$session->id}/photo")
            ->assertStatus(403);
    }

    public function test_delete_photo_is_tenant_scoped(): void
    {
        $otherTenant = $this->makeTenant('other-org', bank: true, subscribed: true);
        $otherSession = $this->makeSession(['tenant_id' => $otherTenant->id]);
        Sanctum::actingAs($this->organizer);

        // destroy() finds by id but the photo belongs to another tenant's session;
        // manage-sessions on the acting tenant must not clear another tenant's photo.
        $this->deleteJson("/api/v1/marketplace/organizer/sessions/{$otherSession->id}/photo");

        $this->assertDatabaseHas('coaching_sessions', [
            'id' => $otherSession->id,
            'photo_path' => 'abc12345',
        ]);
    }
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /Users/abdulkadir/Projects/Dev/Web/hypercoach && php artisan test --filter=OrganizerSessionPhotoTest`
Expected: FAIL — the DELETE route returns 405/404 (route not defined).

- [ ] **Step 3: Add the route**

In `routes/api.php`, inside the `ensure.subscription` group that already holds `POST organizer/sessions/{id}/photo` (after that line), add:

```php
                Route::delete('organizer/sessions/{id}/photo', [\App\Http\Controllers\Admin\SessionPhotoController::class, 'destroy'])
                    ->whereNumber('id');
```

- [ ] **Step 4: Add a tenant guard to `destroy` (fixes the tenant-scoping test)**

`SessionPhotoController@destroy` (`app/Http/Controllers/Admin/SessionPhotoController.php`) currently `find($id)` without tenant scoping. After `$session = Session::find($id);` and its null check, add:

```php
        if ($session->tenant_id !== app('current_tenant')->id) {
            return response()->json(['message' => 'Session not found.'], 404);
        }
```

(The admin route binds `current_tenant` from the `X-Tenant` header; the organizer route binds it from the user — both are set before this controller runs.)

- [ ] **Step 5: Run tests to verify they pass**

Run: `php artisan test --filter=OrganizerSessionPhotoTest`
Expected: PASS (3 tests).

- [ ] **Step 6: Commit**

```bash
cd /Users/abdulkadir/Projects/Dev/Web/hypercoach
git add routes/api.php app/Http/Controllers/Admin/SessionPhotoController.php tests/Feature/Marketplace/OrganizerSessionPhotoTest.php
git commit -m "feat(marketplace): organizer DELETE session photo route + tenant guard

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 2: FE — add `image_cropper` + native config

**Files:**
- Modify: `pubspec.yaml`, `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Add the dependency (pins the resolved latest)**

Run: `cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena && flutter pub add image_cropper`
Expected: `pubspec.yaml` gains an `image_cropper:` line under `# Media`; `flutter pub get` succeeds.

- [ ] **Step 2: Add iOS permission strings (currently MISSING — camera would crash)**

In `ios/Runner/Info.plist`, inside the top-level `<dict>`, add:

```xml
	<key>NSCameraUsageDescription</key>
	<string>Aplikasi memakai kamera untuk mengambil foto sampul sesi.</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Aplikasi mengakses galeri untuk memilih foto sampul sesi.</string>
```

- [ ] **Step 3: Register the crop activity on Android**

In `android/app/src/main/AndroidManifest.xml`, inside `<application>...</application>`, add:

```xml
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar" />
```

- [ ] **Step 4: Verify it builds**

Run: `flutter pub get && flutter analyze`
Expected: No new analyzer errors. (A full `flutter build apk --debug` is optional but confirms the manifest merge.)

- [ ] **Step 5: Commit**

```bash
cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena
git add pubspec.yaml pubspec.lock ios/Runner/Info.plist android/app/src/main/AndroidManifest.xml
git commit -m "chore(deps): add image_cropper + camera/photo permissions & UCrop activity

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 3: FE — repository delete method + filename on upload

**Files:**
- Modify: `lib/features/organizer/data/organizer_repository.dart` (interface)
- Modify: `lib/features/organizer/data/api_organizer_repository.dart:498-511` (upload) + add delete
- Modify: `lib/features/organizer/data/mock_organizer_repository.dart` (implement the new method so it compiles)
- Test: `test/features/organizer/data/api_organizer_repository_test.dart`

**Interfaces:**
- Produces: `Future<void> deleteSessionCoverPhoto(String sessionId)` on `OrganizerRepository`.

- [ ] **Step 1: Write the failing test**

In `test/features/organizer/data/api_organizer_repository_test.dart`, following the existing test style there (it uses `http_mock_adapter`/`mocktail` around `ApiClient`), add a test asserting the DELETE path. Mirror the existing `uploadSessionCoverPhoto` test's harness; the assertion:

```dart
  test('deleteSessionCoverPhoto DELETEs the organizer photo path', () async {
    // arrange the mock ApiClient to expect a DELETE and record the path
    await repo.deleteSessionCoverPhoto('42');
    verify(() => apiClient.delete(
      '/v1/marketplace/organizer/sessions/42/photo',
    )).called(1);
  });
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena && flutter test test/features/organizer/data/api_organizer_repository_test.dart`
Expected: FAIL — `deleteSessionCoverPhoto` not defined on `OrganizerRepository`.

- [ ] **Step 3: Add to the interface**

In `lib/features/organizer/data/organizer_repository.dart`, next to `uploadSessionCoverPhoto`:

```dart
  /// Remove the cover photo from a session (reverts to the tenant-logo
  /// fallback). No-op server-side if the session has none.
  Future<void> deleteSessionCoverPhoto(String sessionId);
```

- [ ] **Step 4: Implement in the API repo + add a filename to the upload**

In `lib/features/organizer/data/api_organizer_repository.dart`, change the upload's `MultipartFile.fromFile` to include a filename (so the server's `mimes` rule sees an extension), and add the delete method right after `uploadSessionCoverPhoto`:

```dart
  @override
  Future<void> uploadSessionCoverPhoto(String sessionId, File photo) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
      });
      await _apiClient.post(
        '/v1/marketplace/organizer/sessions/$sessionId/photo',
        data: formData,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<void> deleteSessionCoverPhoto(String sessionId) async {
    try {
      await _apiClient.delete(
        '/v1/marketplace/organizer/sessions/$sessionId/photo',
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
```

- [ ] **Step 5: Implement in the mock repo (so the app + tests compile)**

In `lib/features/organizer/data/mock_organizer_repository.dart`, add:

```dart
  @override
  Future<void> deleteSessionCoverPhoto(String sessionId) async {}
```

- [ ] **Step 6: Run to verify it passes**

Run: `flutter test test/features/organizer/data/api_organizer_repository_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/features/organizer/data/organizer_repository.dart lib/features/organizer/data/api_organizer_repository.dart lib/features/organizer/data/mock_organizer_repository.dart test/features/organizer/data/api_organizer_repository_test.dart
git commit -m "feat(organizer): repo deleteSessionCoverPhoto + filename on cover upload

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 4: FE — the `SessionCoverEditor` flow (source → crop → upload/remove)

**Files:**
- Create: `lib/features/organizer/presentation/widgets/create_session/session_cover_editor.dart`
- Test: `test/features/organizer/widgets/session_cover_editor_test.dart` (create)

**Interfaces:**
- Produces: `Future<bool> editSessionCover(BuildContext context, WidgetRef ref, {required String sessionId, required bool hasPhoto})` — runs the whole flow (source sheet → pick → 16:9 crop → upload, or confirm → remove), shows its own snackbars, returns `true` if the cover changed (so callers can invalidate providers), `false` if cancelled/failed.

- [ ] **Step 1: Write the failing widget test (source sheet options)**

Create `test/features/organizer/widgets/session_cover_editor_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';

void main() {
  testWidgets('source sheet shows Hapus only when a photo exists',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showCoverSourceSheet(context, hasPhoto: true),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Ambil foto'), findsOneWidget);
    expect(find.text('Pilih dari galeri'), findsOneWidget);
    expect(find.text('Hapus sampul'), findsOneWidget);
  });

  testWidgets('source sheet hides Hapus when no photo', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showCoverSourceSheet(context, hasPhoto: false),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Hapus sampul'), findsNothing);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/organizer/widgets/session_cover_editor_test.dart`
Expected: FAIL — `showCoverSourceSheet` / file not found.

- [ ] **Step 3: Implement the editor**

Create `lib/features/organizer/presentation/widgets/create_session/session_cover_editor.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

/// The three outcomes of the source-selection sheet.
enum CoverSourceChoice { camera, gallery, remove }

/// Bottom sheet that offers Camera / Gallery (+ Remove when a photo exists).
/// Extracted so it can be widget-tested without the picker/cropper.
Future<CoverSourceChoice?> showCoverSourceSheet(
  BuildContext context, {
  required bool hasPhoto,
}) {
  return showModalBottomSheet<CoverSourceChoice>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Ambil foto'),
            onTap: () => Navigator.pop(ctx, CoverSourceChoice.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Pilih dari galeri'),
            onTap: () => Navigator.pop(ctx, CoverSourceChoice.gallery),
          ),
          if (hasPhoto)
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text(
                'Hapus sampul',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => Navigator.pop(ctx, CoverSourceChoice.remove),
            ),
        ],
      ),
    ),
  );
}

/// Full cover-photo flow. Returns true when the cover changed.
Future<bool> editSessionCover(
  BuildContext context,
  WidgetRef ref, {
  required String sessionId,
  required bool hasPhoto,
}) async {
  final choice = await showCoverSourceSheet(context, hasPhoto: hasPhoto);
  if (choice == null || !context.mounted) return false;

  if (choice == CoverSourceChoice.remove) {
    return _removeCover(context, ref, sessionId);
  }

  final source = choice == CoverSourceChoice.camera
      ? ImageSource.camera
      : ImageSource.gallery;

  final File? cropped = await _pickAndCrop(context, source);
  if (cropped == null || !context.mounted) return false;

  return _upload(context, ref, sessionId, cropped);
}

Future<File?> _pickAndCrop(BuildContext context, ImageSource source) async {
  try {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (picked == null) return null;

    // The cropper's confirm screen IS the preview step (16:9 locked; the
    // server re-crops to 16:9 as a safety net).
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Atur sampul',
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Atur sampul',
          aspectRatioLockEnabled: true,
          rotateButtonsHidden: true,
          resetButtonHidden: true,
        ),
      ],
    );
    return cropped == null ? null : File(cropped.path);
  } on PlatformException {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak bisa mengakses kamera/galeri. Beri izin di Pengaturan.',
          ),
        ),
      );
    }
    return null;
  }
}

Future<bool> _upload(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
  File file,
) async {
  _showBlockingProgress(context);
  try {
    await ref
        .read(organizerRepositoryProvider)
        .uploadSessionCoverPhoto(sessionId, file);
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    _invalidate(ref, sessionId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sampul diperbarui')),
      );
    }
    return true;
  } catch (_) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengunggah sampul'),
          action: SnackBarAction(
            label: 'Coba lagi',
            onPressed: () => _upload(context, ref, sessionId, file),
          ),
        ),
      );
    }
    return false;
  }
}

Future<bool> _removeCover(
  BuildContext context,
  WidgetRef ref,
  String sessionId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus sampul?'),
      content: const Text('Sesi akan memakai gambar bawaan klub.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  _showBlockingProgress(context);
  try {
    await ref
        .read(organizerRepositoryProvider)
        .deleteSessionCoverPhoto(sessionId);
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    _invalidate(ref, sessionId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sampul dihapus')),
      );
    }
    return true;
  } catch (_) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus sampul')),
      );
    }
    return false;
  }
}

void _showBlockingProgress(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void _invalidate(WidgetRef ref, String sessionId) {
  ref.invalidate(organizerSessionDetailProvider(sessionId));
  ref.invalidate(organizerSessionsProvider);
}
```

Note: confirm the exact provider names in `lib/features/organizer/providers/organizer_providers.dart` — this plan uses `organizerSessionDetailProvider(sessionId)` and `organizerSessionsProvider` (both referenced elsewhere in the codebase). If the sessions list provider has a different name, use the one `getMySessions` feeds.

- [ ] **Step 4: Run to verify it passes**

Run: `flutter test test/features/organizer/widgets/session_cover_editor_test.dart`
Expected: PASS (2 tests). Then `flutter analyze` — clean.

- [ ] **Step 5: Commit**

```bash
git add lib/features/organizer/presentation/widgets/create_session/session_cover_editor.dart test/features/organizer/widgets/session_cover_editor_test.dart
git commit -m "feat(organizer): SessionCoverEditor (camera/gallery/crop/remove)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 5: FE — cover editor on the session-detail hero

**Files:**
- Modify: `lib/features/organizer/presentation/widgets/session_detail_hero.dart` (wrap `SessionHero` in a `Stack`, overlay a `ScrimIconButton`)

**Interfaces:**
- Consumes: `editSessionCover(...)` (Task 4), `ScrimIconButton` (`lib/shared/widgets/scrim_icon_button.dart`).

- [ ] **Step 1: Make the hero a `ConsumerWidget` overlay**

`SessionDetailHero` is already a `ConsumerWidget`. Replace the bare `SessionHero(...)` child (the first child of the inner `Column`) with a `Stack` that overlays an edit button:

```dart
          Stack(
            children: [
              SessionHero(
                photoUrls: session.photoUrls,
                photoPath: session.photoPath,
                size: SessionHeroSize.lg,
                borderRadius: 0,
                enableZoom: true,
                heroTag: 'organizer-session-hero-${session.id}',
              ),
              Positioned(
                top: AppDimensions.sm,
                right: AppDimensions.sm,
                child: Builder(
                  builder: (context) => ScrimIconButton(
                    icon: Icons.photo_camera_outlined,
                    semanticLabel: 'Ubah sampul',
                    onPressed: () => editSessionCover(
                      context,
                      ref,
                      sessionId: session.id,
                      hasPhoto: session.photoPath != null,
                    ),
                  ),
                ),
              ),
            ],
          ),
```

Add imports at the top of the file:

```dart
import 'package:hyperarena/shared/widgets/scrim_icon_button.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';
```

- [ ] **Step 2: Verify**

Run: `flutter analyze`
Expected: clean. (Manual: on the organizer session detail, a camera scrim button sits top-right of the hero and opens the source sheet.)

- [ ] **Step 3: Commit**

```bash
git add lib/features/organizer/presentation/widgets/session_detail_hero.dart
git commit -m "feat(organizer): change/remove cover from the session-detail hero

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 6: FE — upgrade the post-create prompt to the new editor

**Files:**
- Modify: `lib/features/organizer/presentation/screens/create_session_screen.dart:127-186` (`_submit` + delete `_pickAndUploadCover`)

- [ ] **Step 1: Route the post-create prompt through `editSessionCover`**

In `create_session_screen.dart`, in `_submit`, replace:

```dart
      final wantPhoto = await showPostCreatePhotoPrompt(context);
      if (wantPhoto) await _pickAndUploadCover(session.id);
```

with:

```dart
      final wantPhoto = await showPostCreatePhotoPrompt(context);
      if (wantPhoto && mounted) {
        await editSessionCover(
          context,
          ref,
          sessionId: session.id,
          hasPhoto: false,
        );
      }
```

Then delete the now-unused `_pickAndUploadCover` method (lines 173-186) and, if nothing else uses them, the `import 'package:image_picker/image_picker.dart';` and `dart:io` imports. Add:

```dart
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';
```

- [ ] **Step 2: Verify**

Run: `flutter analyze && flutter test test/features/organizer/`
Expected: clean + green (no test referenced `_pickAndUploadCover`).

- [ ] **Step 3: Commit**

```bash
git add lib/features/organizer/presentation/screens/create_session_screen.dart
git commit -m "feat(organizer): post-create photo prompt uses camera/gallery/crop editor

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

**► Phase 1 ships here as its own checkpoint.** Verify live (add/replace/remove a cover from the detail hero + post-create prompt on Android, then iPhone) before starting Phase 2.

---

# PHASE 2 — Edit Session (reuse the create form)

## Task 7: BE — flat `editPayload` endpoint for prefill

**Files:**
- Modify: `app/Http/Controllers/Admin/SessionController.php` (add `editPayload` method)
- Modify: `routes/api.php` (organizer read group)
- Test: `tests/Feature/Marketplace/OrganizerEditSessionTest.php` (create)

**Interfaces:**
- Produces: `GET /api/v1/marketplace/organizer/sessions/{id}/edit-payload` → `{data: {id, coach_ids[], type, title, date, start_time, duration_minutes, capacity, venue_id, venue:{id,name}|null, price, notes, status, photo_path, photo_urls}}`. `date`/`start_time` are tenant-local (inverse of `update`'s UTC conversion).

- [ ] **Step 1: Write the failing test**

Create `tests/Feature/Marketplace/OrganizerEditSessionTest.php` reusing the `OrganizerCreateSessionTest` setup helpers (copy `setUp`/`makeTenant`/`makeUser`/`makeCoach`), plus a `makeSession` helper that attaches the coach:

```php
    private function makeSession(array $overrides = []): \App\Models\Session
    {
        $session = \App\Models\Session::create(array_merge([
            'tenant_id' => $this->tenant->id,
            'type' => 'group',
            'start_at' => \Carbon\Carbon::parse('2026-08-01 02:00:00'), // 09:00 Asia/Jakarta
            'duration_minutes' => 90,
            'capacity' => 8,
            'title' => 'Latihan Pagi',
            'status' => 'scheduled',
        ], $overrides));
        $session->coaches()->sync([$this->coach->id]);
        return $session;
    }

    public function test_edit_payload_returns_tenant_local_flat_shape(): void
    {
        Sanctum::actingAs($this->organizer);
        $session = $this->makeSession();

        $this->getJson("/api/v1/marketplace/organizer/sessions/{$session->id}/edit-payload")
            ->assertOk()
            ->assertJsonPath('data.id', $session->id)
            ->assertJsonPath('data.coach_ids.0', $this->coach->id)
            ->assertJsonPath('data.title', 'Latihan Pagi')
            ->assertJsonPath('data.date', '2026-08-01')
            ->assertJsonPath('data.start_time', '09:00')
            ->assertJsonPath('data.status', 'scheduled');
    }

    public function test_edit_payload_requires_manage_sessions(): void
    {
        $member = $this->makeUser($this->tenant, 'member', 'member@primary.test');
        Sanctum::actingAs($member);
        $session = $this->makeSession();

        $this->getJson("/api/v1/marketplace/organizer/sessions/{$session->id}/edit-payload")
            ->assertStatus(403);
    }
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd /Users/abdulkadir/Projects/Dev/Web/hypercoach && php artisan test --filter=OrganizerEditSessionTest`
Expected: FAIL — route not defined (404/405).

- [ ] **Step 3: Add the `editPayload` method**

In `app/Http/Controllers/Admin/SessionController.php`, add:

```php
    public function editPayload(Request $request, int $id): JsonResponse
    {
        if (! $request->user()->hasPermissionTo('manage-sessions')) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $session = Session::with(['coaches:id', 'venue:id,name'])->find($id);

        if (! $session || $session->tenant_id !== app('current_tenant')->id) {
            return response()->json(['message' => 'Session not found.'], 404);
        }

        $tz = app('current_tenant')->timezone ?? 'Asia/Kuala_Lumpur';
        $local = \Carbon\Carbon::parse($session->start_at)->setTimezone($tz);

        return response()->json(['data' => [
            'id' => $session->id,
            'coach_ids' => $session->coaches->pluck('id')->values(),
            'type' => $session->type,
            'title' => $session->title,
            'date' => $local->format('Y-m-d'),
            'start_time' => $local->format('H:i'),
            'duration_minutes' => $session->duration_minutes,
            'capacity' => $session->capacity,
            'venue_id' => $session->venue_id,
            'venue' => $session->venue
                ? ['id' => $session->venue->id, 'name' => $session->venue->name]
                : null,
            'price' => $session->price,
            'notes' => $session->notes,
            'status' => $session->status,
            'photo_path' => $session->photo_path,
            'photo_urls' => $session->photo_urls,
        ]]);
    }
```

- [ ] **Step 4: Add the route**

In `routes/api.php`, inside the `resolve.tenant.from-user` group, next to `organizer/sessions/{id}/duplicate-payload`:

```php
            Route::get('organizer/sessions/{id}/edit-payload', [SessionController::class, 'editPayload'])
                ->whereNumber('id');
```

- [ ] **Step 5: Run to verify it passes**

Run: `php artisan test --filter=OrganizerEditSessionTest`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add app/Http/Controllers/Admin/SessionController.php routes/api.php tests/Feature/Marketplace/OrganizerEditSessionTest.php
git commit -m "feat(marketplace): organizer session edit-payload endpoint (flat, tenant-local)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 8: BE — expose `PUT organizer/sessions/{id}`

**Files:**
- Modify: `routes/api.php` (organizer mutations group)
- Test: `tests/Feature/Marketplace/OrganizerEditSessionTest.php` (extend)

**Interfaces:**
- Produces: `PUT /api/v1/marketplace/organizer/sessions/{id}` → `Admin\SessionController@update` (partial update; 422 on cancelled/completed; 422 coach-conflict; returns `{session}`).

- [ ] **Step 1: Write the failing tests**

Add to `OrganizerEditSessionTest`:

```php
    public function test_organizer_updates_own_session(): void
    {
        Sanctum::actingAs($this->organizer);
        $session = $this->makeSession();

        $this->putJson("/api/v1/marketplace/organizer/sessions/{$session->id}", [
            'title' => 'Judul Baru',
            'capacity' => 12,
        ])->assertOk();

        $this->assertDatabaseHas('coaching_sessions', [
            'id' => $session->id,
            'title' => 'Judul Baru',
            'capacity' => 12,
        ]);
    }

    public function test_cannot_update_completed_session(): void
    {
        Sanctum::actingAs($this->organizer);
        $session = $this->makeSession(['status' => 'completed']);

        $this->putJson("/api/v1/marketplace/organizer/sessions/{$session->id}", [
            'title' => 'X',
        ])->assertStatus(422);
    }

    public function test_update_requires_manage_sessions(): void
    {
        $member = $this->makeUser($this->tenant, 'member', 'm2@primary.test');
        Sanctum::actingAs($member);
        $session = $this->makeSession();

        $this->putJson("/api/v1/marketplace/organizer/sessions/{$session->id}", [
            'title' => 'X',
        ])->assertStatus(403);
    }
```

- [ ] **Step 2: Run to verify they fail**

Run: `php artisan test --filter=OrganizerEditSessionTest`
Expected: the three new tests FAIL (route not defined).

- [ ] **Step 3: Add the route**

In `routes/api.php`, inside the `ensure.subscription` group (next to `POST organizer/sessions`):

```php
                Route::put('organizer/sessions/{id}', [SessionController::class, 'update'])
                    ->whereNumber('id');
```

- [ ] **Step 4: Run to verify all pass**

Run: `php artisan test --filter=OrganizerEditSessionTest`
Expected: PASS (5 tests total).

- [ ] **Step 5: Commit**

```bash
git add routes/api.php tests/Feature/Marketplace/OrganizerEditSessionTest.php
git commit -m "feat(marketplace): organizer PUT session update route

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 9: FE — draft `sessionId` + notifier hydrate/dirty/submit-routing

**Files:**
- Modify: `lib/features/organizer/data/models/create_session_draft.dart` (add `sessionId`)
- Modify: `lib/features/organizer/providers/create_session_provider.dart` (hydrate, isDirty, submit routing, reset)
- Run: build_runner (freezed)
- Test: `test/features/organizer/providers/create_session_provider_test.dart` (create)

**Interfaces:**
- Produces: `CreateSessionDraft.sessionId` (`int?`); `CreateSessionDraftNotifier.hydrate(CreateSessionDraft)`, `bool get isDirty`; `submit()` routes to update when `sessionId != null`.

- [ ] **Step 1: Add `sessionId` to the freezed model**

In `create_session_draft.dart`, add the field as the first factory param:

```dart
  const factory CreateSessionDraft({
    int? sessionId, // null = create, non-null = editing an existing session
    @Default(<int>[]) List<int> coachIds,
```

- [ ] **Step 2: Regenerate freezed**

Run: `cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena && dart run build_runner build --delete-conflicting-outputs`
Expected: `create_session_draft.freezed.dart` + `.g.dart` updated, no errors.

- [ ] **Step 3: Write the failing notifier tests**

Create `test/features/organizer/providers/create_session_provider_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';

void main() {
  test('hydrate seeds state and starts not dirty; edits mark dirty', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(createSessionDraftProvider.notifier);

    const seed = CreateSessionDraft(
      sessionId: 42,
      coachIds: [1],
      title: 'Awal',
      durationMinutes: 90,
    );
    notifier.hydrate(seed);

    expect(container.read(createSessionDraftProvider).sessionId, 42);
    expect(notifier.isDirty, isFalse);

    notifier.setTitle('Diubah');
    expect(notifier.isDirty, isTrue);
  });

  test('reset clears the baseline and the draft', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(createSessionDraftProvider.notifier);

    notifier.hydrate(const CreateSessionDraft(sessionId: 7, coachIds: [1]));
    notifier.reset();

    expect(container.read(createSessionDraftProvider).sessionId, isNull);
    expect(notifier.isDirty, isFalse);
  });
}
```

- [ ] **Step 4: Run to verify they fail**

Run: `flutter test test/features/organizer/providers/create_session_provider_test.dart`
Expected: FAIL — `hydrate`/`isDirty` not defined.

- [ ] **Step 5: Implement in the notifier**

In `create_session_provider.dart`, add a baseline field + methods, and route `submit`:

```dart
class CreateSessionDraftNotifier extends Notifier<CreateSessionDraft> {
  CreateSessionDraft? _baseline;

  @override
  CreateSessionDraft build() => const CreateSessionDraft();

  /// Seed the draft from an existing session's edit-payload and snapshot a
  /// baseline for dirty-tracking.
  void hydrate(CreateSessionDraft draft) {
    _baseline = draft;
    state = draft;
  }

  /// True once the hydrated draft differs from its baseline (edit mode).
  bool get isDirty => _baseline != null && state != _baseline;
```

Change `reset` to also clear the baseline:

```dart
  void reset() {
    _baseline = null;
    state = const CreateSessionDraft();
  }
```

Change `submit` to route by `sessionId`:

```dart
  Future<OpenSession> submit() async {
    final repo = ref.read(organizerRepositoryProvider);
    final result = state.sessionId == null
        ? await repo.createSession(state)
        : await repo.updateSession(state.sessionId!.toString(), state);
    _invalidateOrganizerQueries();
    return result;
  }
```

Add the session-detail invalidation so an edited session's detail refreshes. In `_invalidateOrganizerQueries`, if editing, also invalidate the detail; simplest is to invalidate it in `submit` after a successful edit:

```dart
    if (state.sessionId != null) {
      ref.invalidate(organizerSessionDetailProvider(state.sessionId!.toString()));
    }
```
(placed right before `return result;`, with `organizerSessionDetailProvider` imported from `organizer_providers.dart`.)

- [ ] **Step 6: Run to verify they pass**

Run: `flutter test test/features/organizer/providers/create_session_provider_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 7: Commit**

```bash
git add lib/features/organizer/data/models/create_session_draft.dart lib/features/organizer/data/models/create_session_draft.freezed.dart lib/features/organizer/data/models/create_session_draft.g.dart lib/features/organizer/providers/create_session_provider.dart test/features/organizer/providers/create_session_provider_test.dart
git commit -m "feat(organizer): draft sessionId + hydrate/isDirty + submit routing

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 10: FE — repo `getEditPayload` + `updateSession`

**Files:**
- Modify: `lib/features/organizer/data/organizer_repository.dart` (add `getEditPayload`)
- Modify: `lib/features/organizer/data/api_organizer_repository.dart` (implement both)
- Modify: `lib/features/organizer/data/mock_organizer_repository.dart` (stub `getEditPayload`)
- Test: `test/features/organizer/data/api_organizer_repository_test.dart`

**Interfaces:**
- Consumes: `CreateSessionDraft` (with `sessionId`).
- Produces: `Future<CreateSessionDraft> getEditPayload(String sessionId)`; a working `updateSession` (`PUT`, body = `toCreatePayload()`).

- [ ] **Step 1: Write the failing tests**

Add to `api_organizer_repository_test.dart`:

```dart
  test('getEditPayload maps the flat edit-payload into a draft', () async {
    // mock ApiClient.get(...edit-payload) → the flat shape
    when(() => apiClient.get(
      '/v1/marketplace/organizer/sessions/42/edit-payload',
    )).thenAnswer((_) async => Response(
      requestOptions: RequestOptions(path: ''),
      data: {'data': {
        'id': 42, 'coach_ids': [1, 2], 'type': 'group', 'title': 'Pagi',
        'date': '2026-08-01', 'start_time': '09:00', 'duration_minutes': 90,
        'capacity': 8, 'venue_id': 3, 'venue': {'id': 3, 'name': 'GOR'},
        'price': 50000, 'notes': null, 'status': 'scheduled',
      }},
    ));

    final draft = await repo.getEditPayload('42');

    expect(draft.sessionId, 42);
    expect(draft.coachIds, [1, 2]);
    expect(draft.title, 'Pagi');
    expect(draft.date, DateTime.parse('2026-08-01'));
    expect(draft.startTime, '09:00');
    expect(draft.venueId, '3');
    expect(draft.venueName, 'GOR');
  });

  test('updateSession PUTs toCreatePayload to the organizer path', () async {
    // mock put + the sessions re-fetch used to return the updated OpenSession
    await repo.updateSession('42', const CreateSessionDraft(
      sessionId: 42, coachIds: [1], type: SessionType.group,
      date: /* a DateTime */ null, startTime: '09:00',
    ));
    verify(() => apiClient.put(
      '/v1/marketplace/organizer/sessions/42',
      data: any(named: 'data'),
    )).called(1);
  });
```

(Use the file's existing mock harness for the sessions re-fetch; if `updateSession` re-fetches the list like `createSession` does, stub `GET /v1/marketplace/organizer/sessions` to return a list containing id `42`.)

- [ ] **Step 2: Run to verify they fail**

Run: `flutter test test/features/organizer/data/api_organizer_repository_test.dart`
Expected: FAIL — `getEditPayload` undefined; `updateSession` throws `UnimplementedError`.

- [ ] **Step 3: Add `getEditPayload` to the interface**

In `organizer_repository.dart`, next to `getDuplicatePayload`:

```dart
  /// Pre-fill draft for editing [sessionId] (all editable fields + sessionId).
  Future<CreateSessionDraft> getEditPayload(String sessionId);
```

- [ ] **Step 4: Implement both in the API repo**

In `api_organizer_repository.dart`, add `getEditPayload` (model it on `getDuplicatePayload`) and replace the `updateSession` stub:

```dart
  @override
  Future<CreateSessionDraft> getEditPayload(String sessionId) async {
    try {
      final response = await _apiClient.get(
        '/v1/marketplace/organizer/sessions/$sessionId/edit-payload',
      );
      final json = _unwrapMap(response.data);
      return CreateSessionDraft(
        sessionId: (json['id'] as num).toInt(),
        coachIds: ((json['coach_ids'] as List?) ?? const [])
            .map((e) => (e as num).toInt())
            .toList(),
        type: SessionType.values.asNameMap()[json['type'] as String?] ??
            SessionType.group,
        title: json['title'] as String?,
        date: json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : null,
        startTime: json['start_time'] as String?,
        durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 60,
        capacity: (json['capacity'] as num?)?.toInt(),
        venueId: json['venue_id']?.toString(),
        venueName: (json['venue'] as Map<String, dynamic>?)?['name'] as String?,
        price: (json['price'] as num?)?.toInt(),
        notes: json['notes'] as String?,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<OpenSession> updateSession(
    String sessionId,
    CreateSessionDraft draft,
  ) async {
    try {
      // update accepts exactly the create field set (partial-friendly).
      await _apiClient.put(
        '/v1/marketplace/organizer/sessions/$sessionId',
        data: draft.toCreatePayload(),
      );
      _sessionsCache = null;
      _sessionsCacheTime = null;
      final sessions = await _fetchSessions();
      for (final session in sessions) {
        if (session.id == sessionId) return session;
      }
      return getSessionDetail(sessionId);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
```

- [ ] **Step 5: Stub in the mock repo**

In `mock_organizer_repository.dart`, add (returning a representative draft so the mock app path works):

```dart
  @override
  Future<CreateSessionDraft> getEditPayload(String sessionId) async =>
      CreateSessionDraft(sessionId: int.tryParse(sessionId), coachIds: const [1]);
```

- [ ] **Step 6: Run to verify they pass**

Run: `flutter test test/features/organizer/data/api_organizer_repository_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/features/organizer/data/organizer_repository.dart lib/features/organizer/data/api_organizer_repository.dart lib/features/organizer/data/mock_organizer_repository.dart test/features/organizer/data/api_organizer_repository_test.dart
git commit -m "feat(organizer): repo getEditPayload + real updateSession (PUT)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 11: FE — `CreateSessionScreen` edit mode

**Files:**
- Modify: `lib/features/organizer/presentation/screens/create_session_screen.dart`
- Test: `test/features/organizer/screens/create_session_edit_mode_test.dart` (create)

**Interfaces:**
- Consumes: `getEditPayload`, notifier `hydrate`/`isDirty`, `submit()` routing (Tasks 9–10), `editSessionCover` (Task 4).
- Produces: `CreateSessionScreen({String? sessionId})`.

- [ ] **Step 1: Add the constructor param + edit-mode init**

Change the widget constructor:

```dart
class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key, this.sessionId});

  final String? sessionId; // non-null = edit mode

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}
```

In `_CreateSessionScreenState`, add an `_isEdit` getter and an edit-mode init that hydrates the draft + prefills controllers, skipping the payment guard:

```dart
  bool get _isEdit => widget.sessionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadForEdit());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkPaymentGuard());
    }
  }

  Future<void> _loadForEdit() async {
    try {
      final draft = await ref
          .read(organizerRepositoryProvider)
          .getEditPayload(widget.sessionId!);
      if (!mounted) return;
      _notifier.hydrate(draft);
      _titleCtrl.text = draft.title ?? '';
      _notesCtrl.text = draft.notes ?? '';
      _priceCtrl.text = draft.price != null
          ? Formatters.groupDigits(
              Formatters.fromMinorUnits(
                draft.price!,
                ref.read(tenantCurrencyProvider),
              ).toInt().toString(),
              ref.read(tenantCurrencyProvider),
            )
          : '';
      setState(() {}); // reflect prefill
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Gagal memuat sesi. Coba lagi.');
      }
    }
  }
```

(The price prefill mirrors the existing `_onDuplicatePicked` formatting at `create_session_screen.dart:98-109`.)

- [ ] **Step 2: Branch the build for edit mode (single scroll + AppBar + discard guard)**

In `build`, when `_isEdit`, render a single-scroll form with a plain `AppBar` and a discard-guarding `PopScope` instead of the stepped `CreateSessionHeader`:

```dart
  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createSessionDraftProvider);
    if (_isEdit) return _buildEditScaffold(draft);
    return _buildCreateScaffold(draft); // existing Scaffold body, unchanged
  }

  Widget _buildEditScaffold(CreateSessionDraft draft) {
    final dirty = ref.read(createSessionDraftProvider.notifier).isDirty;
    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmDiscard();
        if (leave && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: AppSurfaces.background,
        appBar: AppBar(title: const Text('Edit sesi')),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.base,
                  AppDimensions.base,
                  AppDimensions.base,
                  AppDimensions.xxl,
                ),
                child: Column(
                  children: [
                    _buildStep1(draft), // reused — see Step 3 gating
                    const SizedBox(height: AppDimensions.md),
                    _buildStep2(draft),
                  ],
                ),
              ),
            ),
            if (_error != null) _errorBanner(),
            _buildEditFooter(draft, dirty),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buang perubahan?'),
        content: const Text('Perubahan yang belum disimpan akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjut edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buang',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  Widget _buildEditFooter(CreateSessionDraft draft, bool dirty) {
    return SafeArea(
      minimum: const EdgeInsets.all(AppDimensions.base),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeightLg,
        child: FilledButton(
          onPressed: (dirty && draft.canSubmit && !_submitting) ? _submitEdit : null,
          child: _submitting
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Simpan perubahan'),
        ),
      ),
    );
  }
```

- [ ] **Step 3: Gate create-only bits + add the cover tile inside `_buildStep1`/`_buildStep2`**

In `_buildStep1`, wrap the quick-start/duplicate block so it only shows in create mode:

```dart
        if (!_isEdit && showDuplicate) ...[
          // existing FormSectionCard duplicate block
        ],
```

In `_buildStep2` (capacity/venue section area), add a cover tile in edit mode that opens the editor, reading the current photo from the detail provider:

```dart
        if (_isEdit) ...[
          const SizedBox(height: AppDimensions.md),
          Consumer(
            builder: (context, ref, _) {
              final detail =
                  ref.watch(organizerSessionDetailProvider(widget.sessionId!));
              final hasPhoto = detail.valueOrNull?.photoPath != null;
              return PickerTile(
                icon: Icons.photo_camera_outlined,
                label: 'Sampul',
                placeholder: 'Tambah foto sampul',
                value: hasPhoto ? 'Foto terpasang' : null,
                onTap: () => editSessionCover(
                  context, ref,
                  sessionId: widget.sessionId!,
                  hasPhoto: hasPhoto,
                ),
              );
            },
          ),
        ],
```

- [ ] **Step 4: Add `_submitEdit`**

```dart
  Future<void> _submitEdit() async {
    setState(() { _submitting = true; _error = null; });
    try {
      await _notifier.submit(); // routes to updateSession
      if (!mounted) return;
      _notifier.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan disimpan')),
      );
      Navigator.of(context).pop();
    } on ValidationException catch (e) {
      if (!mounted) return;
      final firstError = e.errors.values
          .expand((m) => m).map((m) => m.toString()).firstOrNull;
      setState(() => _error = firstError ?? 'Gagal menyimpan. Coba lagi.');
    } on ForbiddenException {
      if (!mounted) return;
      setState(() => _error = 'Sesi ini tidak bisa diubah.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal menyimpan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
```

Add imports as needed: `session_cover_editor.dart`, and ensure `organizerSessionDetailProvider`, `PickerTile`, `Consumer` are in scope (all already imported/available in this feature).

- [ ] **Step 5: Write a widget test**

Create `test/features/organizer/screens/create_session_edit_mode_test.dart`: pump `CreateSessionScreen(sessionId: '42')` with a `ProviderScope` overriding `organizerRepositoryProvider` with a fake whose `getEditPayload` returns a known draft; assert the AppBar shows "Edit sesi", the title field is prefilled, and "Simpan perubahan" is disabled until a field changes.

```dart
  testWidgets('edit mode prefills and gates Save on dirty', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [organizerRepositoryProvider.overrideWithValue(fakeRepo)],
      child: const MaterialApp(home: CreateSessionScreen(sessionId: '42')),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Edit sesi'), findsOneWidget);
    expect(find.text('Pagi'), findsOneWidget); // prefilled title
    final saveBtn = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan perubahan'),
    );
    expect(saveBtn.onPressed, isNull); // not dirty yet

    await tester.enterText(find.byType(TextField).first, 'Judul baru');
    await tester.pump();
    final saveBtn2 = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan perubahan'),
    );
    expect(saveBtn2.onPressed, isNotNull);
  });
```

- [ ] **Step 6: Run tests + analyze**

Run: `flutter test test/features/organizer/ && flutter analyze`
Expected: green + clean.

- [ ] **Step 7: Commit**

```bash
git add lib/features/organizer/presentation/screens/create_session_screen.dart test/features/organizer/screens/create_session_edit_mode_test.dart
git commit -m "feat(organizer): CreateSessionScreen edit mode (single-scroll, dirty-tracking, cover tile)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 12: FE — edit route + detail-screen entry point

**Files:**
- Modify: `lib/routing/app_routes.dart` (add `organizerEditSession`)
- Modify: `lib/routing/app_router.dart` (add the GoRoute)
- Modify: `lib/features/organizer/presentation/screens/organizer_session_detail_screen.dart` (AppBar Edit action)

- [ ] **Step 1: Add the route constant**

In `app_routes.dart`, next to `organizerParticipants`:

```dart
  static String organizerEditSession(String id) => '/organizer/session/$id/edit';
```

- [ ] **Step 2: Add the GoRoute**

In `app_router.dart`, next to the participants route:

```dart
      GoRoute(
        path: '/organizer/session/:id/edit',
        builder: (_, state) =>
            CreateSessionScreen(sessionId: state.pathParameters['id']!),
      ),
```

- [ ] **Step 3: Add the Edit action to the detail AppBar**

In `organizer_session_detail_screen.dart`, add an `actions:` list to the `AppBar`, gated on editable status (the `data:` builder already has `session`; move the AppBar into the `AsyncValueWidget`'s data builder, or read the status there). Minimal approach — add a computed action inside the `data:` builder by hoisting the `Scaffold` so `session` is in scope:

```dart
      appBar: AppBar(
        title: const Text('Detail Sesi'),
        leading: /* existing back IconButton */,
        actions: [
          if (sessionAsync.valueOrNull != null &&
              sessionAsync.value!.status != OpenSessionStatus.cancelled &&
              sessionAsync.value!.status != OpenSessionStatus.completed)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit sesi',
              onPressed: () =>
                  context.push(AppRoutes.organizerEditSession(sessionId)),
            ),
        ],
      ),
```

(`sessionAsync` is already read at the top of `build`; `context.push` + `AppRoutes` are already imported.)

- [ ] **Step 4: Verify + analyze**

Run: `flutter analyze && flutter test test/features/organizer/`
Expected: clean + green. Manual: detail screen shows a pencil action (hidden for cancelled/completed) → opens the edit form prefilled.

- [ ] **Step 5: Commit**

```bash
git add lib/routing/app_routes.dart lib/routing/app_router.dart lib/features/organizer/presentation/screens/organizer_session_detail_screen.dart
git commit -m "feat(organizer): edit-session route + detail-screen edit action

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

**► Phase 2 verification (live):** edit a session's title/schedule/venue/price/coaches → Save reflects on the detail; confirm dirty-tracking (Save disabled until changed), discard guard, coach-conflict 422 surfaced, and cover tile opens the editor. Android via `adb`, then iPhone.

---

## Cross-cutting verification (end of both phases)
- BE: `cd /Users/abdulkadir/Projects/Dev/Web/hypercoach && php artisan test` — all green.
- FE: `cd /Users/abdulkadir/Projects/Dev/Mobile/hyperarena && flutter analyze && flutter test` — clean + green.
- Live device pass against Herd `http://hypercoach.test`.
