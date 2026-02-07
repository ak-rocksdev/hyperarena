# Coach Fix + Gallery + Gabung Flow Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix coach tab crash, fix Gabung button contrast, add venue gallery, and build full Gabung (join session) flow with member visualization.

**Architecture:** Bug fixes are inline edits. Gallery uses existing venue photos with a fullscreen viewer dialog. Gabung flow follows existing booking flow pattern: SessionDetailScreen (member avatars + slot selection) → SessionPaymentScreen → SessionConfirmationScreen. State managed via Riverpod StateNotifier mirroring BookingFlowNotifier pattern.

**Tech Stack:** Flutter, Riverpod, go_router, Freezed, cached_network_image

---

### Task 1: Fix Coach Tab Crash

**Files:**
- Modify: `lib/features/coach/presentation/widgets/coach_card.dart:148`

**What:** `_sportLabel(dynamic sport)` calls `sport.name` which fails because `dynamic` can't resolve Dart enum's `.name` getter. Replace with properly typed `Sport` parameter and reuse `SportChipSelector.sportLabel()`.

**Changes:**
- Remove `_sportLabel` static method entirely
- Import `SportChipSelector`
- Replace `_sportLabel(sport)` call with `SportChipSelector.sportLabel(sport)`

---

### Task 2: Fix Gabung Button Contrast

**Files:**
- Modify: `lib/features/session/presentation/widgets/session_card.dart`
- Modify: `lib/features/coach/presentation/widgets/coach_card.dart`

**What:** `FilledButton.tonal` uses Material 3 default (secondary tonal = teal bg + dark text). Replace with explicit `FilledButton` styled with `secondary` bg + white text for both "Gabung" and "Lihat" buttons.

**Button style:**
```dart
FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
  ),
  ...
)
```

---

### Task 3: Add Gallery Section to Venue Detail

**Files:**
- Modify: `lib/features/venue/presentation/screens/venue_detail_screen.dart`

**What:** Add a "Foto" section after facilities showing horizontal thumbnail scroll. Tapping a thumbnail opens fullscreen dialog with PageView for swiping between photos.

**Gallery section structure:**
- Section header "Foto" (after facilities, before description)
- Horizontal scroll of 120×90 rounded thumbnails with shadow
- Tap → `showDialog` with fullscreen PageView of photos
- PageView uses `CachedNetworkImage`, black background, close button

---

### Task 4: Session Join Flow — State + Mock Data

**Files:**
- Create: `lib/features/session/providers/session_join_provider.dart`
- Modify: `lib/core/mocks/mock_sessions.dart` — add `participants` field concept

**What:** Create a `SessionJoinNotifier` (StateNotifier) to track: selected session, selected slot index, payment method. Add mock participant names to sessions for avatar display.

---

### Task 5: Session Detail Screen (Gabung Flow Step 1)

**Files:**
- Create: `lib/features/session/presentation/screens/session_detail_screen.dart`

**What:** Full-screen detail page showing:
- Session info (title, sport, host, venue, date/time, level range, price)
- "Peserta" section: row of avatar circles for joined members + empty slots as dashed circles
- Tapping an empty slot selects it (highlighted border)
- Bottom bar: price + "Gabung" button → navigates to payment

---

### Task 6: Session Payment + Confirmation Screens

**Files:**
- Create: `lib/features/session/presentation/screens/session_payment_screen.dart`
- Create: `lib/features/session/presentation/screens/session_confirmation_screen.dart`

**What:** Simplified versions of existing booking payment/confirmation screens, adapted for session context. Payment shows QRIS + bank transfer. Confirmation shows success with session summary.

---

### Task 7: Wire Routes + Verify

**Files:**
- Modify: `lib/routing/app_router.dart`
- Modify: `lib/features/session/presentation/widgets/session_card.dart`

**Routes to add:**
- `/session/:id` → SessionDetailScreen
- `/session/flow/payment` → SessionPaymentScreen
- `/session/flow/confirmation` → SessionConfirmationScreen

**Wire:** SessionCard "Gabung" button → `context.push('/session/${session.id}')`

---

### Verification

```bash
flutter analyze
flutter run -t lib/main_mock.dart -d emulator-5554
```

Test: Login → Explore → Coach tab (no crash, cards render) → Sesi tab (Gabung button white on teal) → Tap "Gabung" on available session → Session detail (see members + empty slots) → Select slot → "Gabung" → Payment → Confirmation → Explore → Lapangan → Venue detail → scroll to gallery → tap photo → fullscreen viewer
