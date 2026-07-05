# Organizer — Edit Session + Cover Photo Management — Design

**Date:** 2026-07-06
**Repos:** `hyperarena` (Flutter FE) + `hypercoach` (Laravel BE)
**Status:** Approved design → ready for implementation plan

## Goal

Let an organizer (1) edit an existing session's details and (2) manage its cover
photo (camera / gallery / interactive crop / replace / remove) — both built on
infrastructure that mostly already exists, with the two pieces deliberately
decoupled so the photo work ships first and independently.

## Architecture (the two principles that drive every decision)

1. **Create and edit share the field components and validation; they differ only
   in presentation and submit target.** One form, one validation source of
   truth — never two forms that can drift. Create stays a guided 2-step wizard;
   edit renders the same fields as a single scrollable page with dirty-tracking.
2. **Media is atomic, immediate, and decoupled from form Save.** The cover photo
   is its own self-contained editor that uploads the moment the user confirms —
   never bundled into the session form's submit. This mirrors how the backend
   models it (`POST /sessions/{id}/photo` needs an existing session id) and how
   the profile avatar already works.

**Build order (approved):** Phase 1 = cover photo (independent). Phase 2 = edit
form (reuses Phase 1's cover editor as one tile).

## Global constraints

- All UI work goes through the **frontend-design** skill; reuse existing theme
  tokens and components (`FormSectionCard`, `PickerTile`, `ScrimIconButton`,
  `SessionHero`/`SessionDetailHero`, bottom-sheet patterns).
- Copy is **Indonesian**, sentence case, active voice.
- WCAG AA: do not use `AppColors.textTertiary` (#94A3B8, fails) for essential
  text; use `textSecondary`/`neutral500` for meaningful content.
- **No API keys or secrets committed** (unchanged rule).
- Backend reuses existing Admin controllers via the `resolve.tenant.from-user`
  middleware; the tenant is always sourced from the authenticated user.

---

## Phase 1 — Cover Photo Management

The cover photo is a **single** image per session (`sessions.photo_path`),
server-cropped to 16:9, ≤5 MB, jpg/png/webp. This is **not** a gallery; a
multi-photo gallery is explicitly out of scope.

### 1.1 Backend (`hypercoach`)

- **Add one route** in the marketplace organizer group (beside the existing
  `POST organizer/sessions/{id}/photo`, `routes/api.php:751`, inside
  `resolve.tenant.from-user` + `ensure.subscription`):
  - `DELETE organizer/sessions/{id}/photo` → `Admin\SessionPhotoController@destroy`
    (admin already has this at `api.php:278`; controller is tenant-aware).
    Placed under `ensure.subscription` for parity with upload — intentional, but
    a reasonable spot to relax later if a lapsed organizer should still be able
    to remove a photo.
- Upload route already exists and needs no change. `PhotoService::HERO_UPLOAD_RULES`
  (`image, mimes:jpg,jpeg,png,webp, max:5120, dimensions:max 4096×4096`) is the
  contract the FE must respect.

### 1.2 Frontend (`hyperarena`)

**Dependencies & native config (prerequisites):**
- Add `image_cropper` (latest stable `^`) to `pubspec.yaml` (already has
  `image_picker: ^1.1.2`, `cached_network_image: ^3.4.1`).
- **iOS `ios/Runner/Info.plist` (currently MISSING — camera would crash):** add
  `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` with clear
  Indonesian rationale strings.
- **Android:** register `image_cropper`'s `UCropActivity` in
  `android/app/src/main/AndroidManifest.xml` per the package's install docs.

**Repository (`organizer_repository.dart` + `api_organizer_repository.dart`):**
- Add `Future<void> deleteSessionCoverPhoto(String sessionId)` → `DELETE
  /v1/marketplace/organizer/sessions/{id}/photo`.
- `uploadSessionCoverPhoto(id, File)` already exists (POST multipart field
  `photo`); keep as-is.

**The cover editor (one reusable flow):** a self-contained
`SessionCoverEditor` (a function `editSessionCover(BuildContext, {sessionId,
hasExistingPhoto})` plus its widgets), doing:
1. **Source sheet:** `Kamera` / `Galeri` (+ `Hapus sampul` when a photo exists).
2. **Pick:** `ImagePicker` with `maxWidth/maxHeight: 2048`, `imageQuality: 85`
   (client downscale keeps uploads well under 5 MB).
3. **Crop + preview:** `image_cropper` locked to **16:9** aspect ratio; the
   cropper's confirm screen serves as the preview/confirm step (retake = back).
4. **Upload immediately:** show progress on the hero; **optimistic** — display
   the local cropped file while uploading; on success invalidate providers; on
   failure revert to the prior image and offer **retry** (never destructive).
5. **Remove:** confirm dialog → `deleteSessionCoverPhoto` → hero reverts to the
   tenant-logo fallback.
- Handle permission denial gracefully (explain + offer to open Settings; do not
  crash or dead-end).

**Entry points (all call the same editor):**
- **Detail hero:** a `ScrimIconButton` "Ubah sampul" overlaid on
  `SessionDetailHero` (`session_detail_hero.dart` — no overlay today; this is the
  natural home).
- **Post-create prompt:** replace `create_session_screen.dart`'s gallery-only
  `_pickAndUploadCover` / `showPostCreatePhotoPrompt` path with the new editor
  (still optional, still post-create).
- **Edit screen cover tile:** added in Phase 2.

**State:** after upload/delete, invalidate the session-detail provider and the
sessions-list provider so the hero and lists reflect the new cover.

### 1.3 Phase 1 testing
- **BE:** feature test — `DELETE organizer/sessions/{id}/photo` as an organizer
  (auth gate, tenant scoping, clears `photo_path` + removes variants); another
  tenant cannot delete this session's photo.
- **FE:** repo test — `deleteSessionCoverPhoto` hits the right path; the source
  sheet renders `Hapus` only when a photo exists.

---

## Phase 2 — Edit Session (reuse the create form in "edit mode")

The backend edit logic already exists: `Admin\SessionController@update` +
`Admin\Requests\UpdateSessionRequest` (partial update; blocks `cancelled`/
`completed`; re-checks coach conflicts; notifies affected coaches). Exposing it
is route-only plus a prefill endpoint.

### 2.1 Backend (`hypercoach`)
- **Expose update** in the marketplace organizer group (inside
  `resolve.tenant.from-user` + `ensure.subscription`):
  - `PUT organizer/sessions/{id}` → `Admin\SessionController@update`.
- **Add a prefill endpoint** so the edit form reads fresh server data instead of
  the FE's current cached-list stub (`api_organizer_repository.dart:87-105`,
  marked TODO):
  - `GET organizer/sessions/{id}` → `Admin\SessionController@show` (admin already
    exposes `GET /admin/sessions/{id}`, `api.php:250`), reused via
    `resolve.tenant.from-user` — the same reuse pattern as update. This returns
    the full editable/admin shape (`coach_ids, type, start_at,
    duration_minutes, capacity, title, notes, venue_id + venue name, price,
    status, photo_urls`). **Not** the public `Marketplace\SessionController@show`
    (`api.php:686`), whose participant-facing payload omits `coach_ids`.
    Verify `Admin@show` includes `coach_ids` and the venue name; add them to its
    resource if missing.
- Editable fields (from `UpdateSessionRequest`): `coach_ids[]`, `type`,
  `start_at`, `duration_minutes`, `capacity`, `notes`, `title`, `venue_id`,
  `price`. **Not** editable here: `status` (dedicated cancel/complete endpoints),
  `photo` (Phase 1 endpoints).

### 2.2 Frontend (`hyperarena`)

**Draft/state (`create_session_draft.dart` + `create_session_provider.dart`):**
- Add `int? sessionId` to `CreateSessionDraft` (null = create, non-null = edit).
- Add `CreateSessionDraftNotifier.hydrateFromDetail(...)` that seeds the whole
  draft from the **`GET …/sessions/{id}` response** (not `OpenSession` — that
  model carries `primary_coach_name` but not the `coach_ids` array the form
  needs), and captures a **baseline** copy for dirty comparison. This likely
  needs a small `SessionEditDetail` DTO for the prefill payload.
- Add `bool get isDirty` (current draft ≠ baseline) and
  `Map<String,dynamic> toUpdatePayload()` (only changed/updatable fields).
- `submit()` routes to `repo.updateSession(sessionId!, state)` when
  `sessionId != null`, else `createSession`. Reset the draft on screen exit so
  create and edit never leak into each other (single shared provider — reset
  discipline is required; documented here as the chosen tradeoff over a
  `.family` provider, which is overkill for one-at-a-time editing).

**Repository:**
- Implement `updateSession(id, draft)` → `PUT /v1/marketplace/organizer/
  sessions/{id}` with `toUpdatePayload()` (replaces the current
  `UnimplementedError`); parse the returned session.
- Back the prefill with a real `GET .../sessions/{id}` call. The response is a
  superset: map its subset into `OpenSession` to also replace the
  `getSessionDetail` cached-list stub (improving the detail screen), and map the
  full payload into `SessionEditDetail` for the edit form's hydrate.

**Screen (`create_session_screen.dart` → create-or-edit):**
- Accept an optional `sessionId` (via route `/organizer/session/:id/edit`).
- **Edit mode differences:** single scrollable form (both current section groups
  stacked, no stepper / Next gating); AppBar title "Edit sesi"; hide the
  create-only quick-start/duplicate; **"Simpan perubahan" disabled until
  `isDirty`**; on hydrate, prefill the three `TextEditingController`s.
- **Discard guard:** back with unsaved changes → confirm-discard dialog.
- **Cover tile:** a section that shows the current cover and opens the Phase 1
  `SessionCoverEditor`.
- On successful save: invalidate session-detail + list providers, pop with a
  success snackbar.

**Routing & entry point:**
- Add route `/organizer/session/:id/edit` (`app_routes.dart` + `app_router.dart`),
  beside `:id/participants`.
- Add an **Edit action in `OrganizerSessionDetailScreen`'s AppBar** (actionless
  today), visible only when `status` is editable (not `cancelled`/`completed`).

### 2.3 Error handling
- `422` coach-conflict → inline message (same mapping as create's coach errors).
- `403` (locked session / inactive subscription) → clear Indonesian message.
- `422` on a session the BE considers terminal → surface "Sesi ini tidak bisa
  diubah" and route the user back.
- Optimistic-concurrency (session changed server-side mid-edit) is **out of
  scope** for v1 — last-write-wins, documented.

### 2.4 Phase 2 testing
- **BE:** `PUT organizer/sessions/{id}` — organizer updates own session (fields
  persist, correct `tenant_id`); coach-conflict → 422; editing a
  cancelled/completed session → 422; another tenant cannot update. `GET
  organizer/sessions/{id}` returns the editable shape.
- **FE:** repo test — `updateSession` posts `toUpdatePayload` to the right path
  and parses the result; unit tests for `hydrateFromDetail` + `isDirty`; an
  edit-mode widget test (single-scroll render, Save disabled until a field
  changes).

---

## Out of scope (explicit YAGNI)
- Multi-photo gallery (backend is single-cover).
- Pick-during-create with deferred upload (optional future affordance on the
  live preview).
- Optimistic-concurrency / conflict resolution on edit.
- Notifying **participants** (students) on reschedule — the backend currently
  notifies only **coaches**; changing that is a separate decision.

## Verification (end-to-end)
- BE: `php artisan test` green for the new update + photo-delete feature tests.
- FE: `flutter analyze` clean; `flutter test` green.
- Live on device (Herd `http://hypercoach.test`): add/replace/remove a cover
  from the detail hero and post-create prompt (Phase 1); edit a session's
  details and cover, confirm dirty-tracking + discard guard + coach-conflict
  handling (Phase 2). Android via `adb`, then iPhone.
