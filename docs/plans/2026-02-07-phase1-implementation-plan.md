# Phase 1: Player Core — Auth, Venue Discovery, Court Booking

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the complete Player role experience — authentication, venue browsing, court booking flow, and booking management — all with mock data.

**Architecture:** Feature-first (auth/venue/booking/profile/home), Riverpod providers for state, abstract repositories with mock implementations, go_router with auth guards. Freezed models with JSON serialization. Mock-first: all data from MockRepository, 500ms delay for realism.

**Tech Stack:** Flutter 3.38, Riverpod 2.6, go_router 14.8, Freezed 2.5, shared_preferences, cached_network_image, shimmer, image_picker

**Existing patterns (Phase 0):** AppColors, AppTypography, AppDimensions, AppSurfaces, AppShadows, AppAnimations tokens. ThemeExtensions for Sport/BookingStatus/Gamification/Rating. Core widgets: AsyncValueWidget, AppButton (4 variants), EmptyState, ErrorView. Player shell with 4-tab bottom nav. Enums in `app_enums.dart`: Sport, BookingStatus, BookingType, LevelTier, UserRole, PaymentMethodType.

---

## Task 1: Core Utilities — Formatters, Validators, AppTextField, ShimmerLoading

**Files:**
- Create: `lib/core/utils/formatters.dart`
- Create: `lib/core/utils/validators.dart`
- Create: `lib/core/widgets/app_text_field.dart`
- Create: `lib/core/widgets/shimmer_loading.dart`

**Step 1: Create formatters.dart**

```dart
// Rupiah: formatRupiah(150000) → "Rp 150.000"
// Date: formatDate(DateTime) → "15 Feb 2026"
// Time: formatTime("07:00") → "07:00"
// Duration: formatDuration(2) → "2 jam"
import 'package:intl/intl.dart';

abstract final class Formatters {
  static final _rupiahFormat = NumberFormat.currency(
    locale: 'id', symbol: 'Rp ', decimalDigits: 0,
  );
  static String formatRupiah(int amount) => _rupiahFormat.format(amount);
  static String formatDate(DateTime date) => DateFormat('dd MMM yyyy', 'id').format(date);
  static String formatDateShort(DateTime date) => DateFormat('dd MMM', 'id').format(date);
  static String formatDuration(int hours) => '$hours jam';
}
```

**Step 2: Create validators.dart**

Indonesian error strings. Return `String?` for `TextFormField.validator`.

```dart
abstract final class Validators {
  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;
  static String? email(String? value) { /* RegExp check, 'Email tidak valid' */ }
  static String? phone(String? value) { /* +62/08 check, 'Nomor telepon tidak valid' */ }
  static String? minLength(int min) => (String? value) { /* 'Minimal $min karakter' */ };
  static String? passwordMatch(String password) => (String? value) {
    return value != password ? 'Password tidak cocok' : null;
  };
}
```

**Step 3: Create app_text_field.dart**

Wrapper around `TextFormField` using theme's `InputDecorationTheme`. Props: `label`, `hint`, `prefixIcon`, `suffixIcon`, `obscureText`, `controller`, `validator`, `keyboardType`, `textInputAction`, `onFieldSubmitted`.

**Step 4: Create shimmer_loading.dart**

Uses `shimmer` package with `AppSurfaces.shimmerBase`/`shimmerHighlight`. Factory constructors: `ShimmerLoading.card({height})`, `ShimmerLoading.line({width, height})`, `ShimmerLoading.circle({radius})`.

**Step 5: Verify + Commit**

```bash
flutter analyze
git add lib/core/utils/ lib/core/widgets/app_text_field.dart lib/core/widgets/shimmer_loading.dart
git commit -m "feat: add core utilities — formatters, validators, text field, shimmer"
```

---

## Task 2: Freezed Data Models — Auth + Profile

**Files:**
- Create: `lib/features/auth/data/models/user.dart`
- Create: `lib/features/auth/data/models/auth_token.dart`
- Create: `lib/features/profile/data/models/player_profile.dart`
- Create: `build.yaml` (configure snake_case JSON)

**Step 1: Create build.yaml at project root**

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake
```

**Step 2: Create User model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    required UserRole role,
    @Default(false) bool isVerified,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Step 3: Create AuthToken model**

Fields: `token`, `refreshToken`, `expiresAt` (DateTime).

**Step 4: Create PlayerProfile model**

Fields: `userId`, `bio?`, `city`, `sports` (List<Sport>), `selfAssessedLevels` (Map<String, String> — keep simple for JSON), `totalXp` (default 0), `levelTier`, `profileCompletionPct` (default 0).

**Step 5: Run build_runner**

```bash
cd D:\projects\Flutter\hyperarena
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

**Step 6: Commit**

```bash
git add build.yaml lib/features/auth/data/models/ lib/features/profile/data/models/
git commit -m "feat: add Freezed models for User, AuthToken, PlayerProfile"
```

---

## Task 3: Freezed Data Models — Venue + Court + CourtSlot

**Files:**
- Create: `lib/features/venue/data/models/venue.dart`
- Create: `lib/features/venue/data/models/court.dart`
- Create: `lib/features/venue/data/models/court_slot.dart`

**Step 1: Create Court model**

```dart
@freezed
class Court with _$Court {
  const factory Court({
    required String id,
    required String venueId,
    required String name,
    required Sport sportType,
    String? surfaceType,   // "hard_court", "clay", "synthetic", etc.
    required String environment,  // "indoor", "outdoor", "covered"
    @Default([]) List<String> photos,
    @Default(true) bool isActive,
  }) = _Court;
  factory Court.fromJson(Map<String, dynamic> json) => _$CourtFromJson(json);
}
```

**Step 2: Create CourtSlot model**

Fields: `id`, `courtId`, `date` (DateTime), `startTime` (String "HH:mm"), `endTime` (String "HH:mm"), `price` (int, Rupiah), `isPeak` (bool), `isAvailable` (bool).

**Step 3: Create Venue model**

Fields: `id`, `ownerId`, `name`, `description`, `address`, `city`, `latitude`, `longitude`, `phone?`, `whatsappNumber?`, `facilities` (List<String>), `photos` (List<String>), `isVerified`, `avgRating` (double), `totalReviews` (int), `courts` (List<Court>).

**Step 4: Run build_runner + verify + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
git add lib/features/venue/data/models/
git commit -m "feat: add Freezed models for Venue, Court, CourtSlot"
```

---

## Task 4: Freezed Data Models — Booking + PaymentMethodInfo + BookingSummary

**Files:**
- Create: `lib/features/booking/data/models/booking.dart`
- Create: `lib/features/booking/data/models/payment_method_info.dart`
- Create: `lib/features/booking/data/models/booking_summary.dart`

**Step 1: Create Booking model**

Fields: `id`, `bookingType` (BookingType), `bookingCode`, `playerId`, `venueId?`, `courtId?`, `bookingDate` (DateTime), `startTime`, `endTime`, `totalAmount` (int), `status` (BookingStatus), `paymentMethod` (PaymentMethodType), `paymentProofUrl?`, `expiresAt?` (DateTime), `createdAt` (DateTime), `venueName?`, `courtName?` (denormalized for list display).

**Step 2: Create PaymentMethodInfo model**

Fields: `id`, `type` (PaymentMethodType), `bankName?`, `accountNumber?`, `accountHolderName?`, `qrisImageUrl?`.

**Step 3: Create BookingSummary model (wizard state)**

Fields: all nullable/defaulted. `court?` (Court), `venue?` (Venue), `date?` (DateTime), `slots` (List<CourtSlot>, default []), `totalAmount` (int, default 0), `paymentMethod?` (PaymentMethodType). Factory `BookingSummary.empty()`.

**Step 4: Run build_runner + verify + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
git add lib/features/booking/data/models/
git commit -m "feat: add Freezed models for Booking, PaymentMethodInfo, BookingSummary"
```

---

## Task 5: Mock Data — Users, Venues, Bookings, Slot Generator

**Files:**
- Create: `lib/core/mocks/mock_users.dart`
- Create: `lib/core/mocks/mock_venues.dart`
- Create: `lib/core/mocks/mock_bookings.dart`
- Create: `lib/core/mocks/mock_data.dart`

**Step 1: Create mock_users.dart**

3 users with Indonesian names. Primary: Budi Santoso (player), email budi@email.com. Include a PlayerProfile with 2 sports (tennis, badminton), 350 XP (rookie tier).

**Step 2: Create mock_venues.dart**

5 venues in Jakarta with 2-3 courts each. Realistic names: "GOR Senayan Sports Center", "Tennis Club Kemang", "Padel House PIK", "Lapangan Badminton Sudirman", "Futsal Arena Kelapa Gading". Real Jakarta addresses. Varied sports. Photos: picsum.photos placeholders.

**Step 3: Create mock_bookings.dart**

6 bookings in various states: pendingPayment (today+2), waitingConfirmation (today+3), confirmed (today+5), completed (today-3), cancelled (today-7), expired (today-1). Use relative dates from `DateTime.now()`.

**Step 4: Create mock_data.dart**

Central registry: `MockData.currentUser`, `MockData.currentProfile`, `MockData.venues`, `MockData.bookings`. Include `MockData.generateSlots(String courtId, DateTime date)` — generates 15 hourly slots (07:00–22:00), peak hours (07:00–09:00, 17:00–21:00) at +50% price, ~30% randomly unavailable.

**Step 5: Create PaymentMethodInfo mocks per venue**

Each venue has 1 QRIS + 1 bank transfer (BCA) payment method.

**Step 6: Verify + commit**

```bash
flutter analyze
git add lib/core/mocks/
git commit -m "feat: add mock data — users, venues, bookings, slot generator"
```

---

## Task 6: Auth Repository + Auth Provider + Auth State

**Files:**
- Create: `lib/features/auth/data/auth_repository.dart`
- Create: `lib/features/auth/data/mock_auth_repository.dart`
- Create: `lib/features/auth/providers/auth_provider.dart`
- Create: `lib/shared/providers/auth_state_provider.dart`

**Step 1: Create abstract AuthRepository**

```dart
abstract class AuthRepository {
  Future<(User, AuthToken)> login(String email, String password);
  Future<(User, AuthToken)> register({
    required String name, required String email,
    required String phone, required String password,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
}
```

**Step 2: Create MockAuthRepository**

Login: 500ms delay, return MockData.currentUser + fake token. Register: same but with provided name/email. Logout: no-op.

**Step 3: Create auth_provider.dart**

`NotifierProvider` holding `User?`. Methods: `login()`, `register()`, `logout()`, `checkAuth()`. Persists user JSON + token to SharedPreferences. On `build()`, reads from SharedPreferences to restore session.

**Step 4: Create auth_state_provider.dart**

Simple derived provider for global access: `ref.watch(authNotifierProvider)`.

**Step 5: Create DI provider**

`authRepositoryProvider` that switches mock/real based on `appConfigProvider.useMockData`.

**Step 6: Verify + commit**

```bash
flutter analyze
git add lib/features/auth/data/ lib/features/auth/providers/ lib/shared/providers/auth_state_provider.dart
git commit -m "feat: add auth repository, mock implementation, auth provider"
```

---

## Task 7: Router Overhaul — Auth Guards + All Phase 1 Routes

**Files:**
- Modify: `lib/routing/app_router.dart`

**Step 1: Rewrite router with auth redirect**

- `initialLocation: '/splash'`
- `redirect` function: check `ref.watch(authNotifierProvider)` — if not authenticated and not on auth route → `/auth/login`; if authenticated and on auth route → `/player/home`
- Pre-auth routes: `/splash`, `/onboarding`, `/auth/login`, `/auth/register`, `/auth/sport-selection`
- Player shell (4 tabs): keep existing `StatefulShellRoute.indexedStack`, update builders to use real screen classes (import placeholders initially, replace as screens are built)
- Full-screen routes outside shell: `/venue/:id`, `/booking/:id`
- Booking flow routes: `/booking/flow/court/:courtId`, `/booking/flow/slots`, `/booking/flow/summary`, `/booking/flow/payment`, `/booking/flow/confirmation/:bookingId`

**Step 2: Temporarily use placeholder widgets for unbuilt screens**

Keep `_PlaceholderScreen` for screens not yet implemented. Replace them task-by-task as screens are built.

**Step 3: Verify + commit**

```bash
flutter analyze
git add lib/routing/app_router.dart
git commit -m "feat: overhaul router with auth guards and Phase 1 routes"
```

---

## Task 8: Splash + Onboarding Screens

**Files:**
- Create: `lib/features/auth/presentation/screens/splash_screen.dart`
- Create: `lib/features/auth/presentation/screens/onboarding_screen.dart`

**Step 1: Create SplashScreen**

Logo centered with fade-in animation (`AppAnimations.slow`). After 2s: check auth provider — if authenticated → `context.go('/player/home')`, if first launch (check SharedPreferences `onboarding_complete`) → `context.go('/onboarding')`, else → `context.go('/auth/login')`.

**Step 2: Create OnboardingScreen**

3-slide PageView:
1. "Cari & Booking Lapangan" — court icon, subtitle about easy booking
2. "Temukan Coach Terbaik" — coach icon, subtitle about pro coaches
3. "Lacak Perkembangan" — chart icon, subtitle about tracking progress

Bottom: dot indicators, "Lewati" skip button, "Selanjutnya"/"Mulai" button. On complete: save `onboarding_complete: true`, navigate to `/auth/login`.

**Step 3: Update router to use these screens, verify + commit**

```bash
flutter analyze
git add lib/features/auth/presentation/screens/ lib/routing/app_router.dart
git commit -m "feat: add splash screen and onboarding flow"
```

---

## Task 9: Login + Register Screens

**Files:**
- Create: `lib/features/auth/presentation/screens/login_screen.dart`
- Create: `lib/features/auth/presentation/screens/register_screen.dart`

**Step 1: Create LoginScreen**

`ConsumerStatefulWidget`. Form with: email `AppTextField`, password `AppTextField` (obscure toggle), "Masuk" full-width `AppButton`. Error: SnackBar. "Belum punya akun? Daftar" link → `/auth/register`. On submit: `ref.read(authNotifierProvider.notifier).login()`, navigate to `/player/home`.

**Step 2: Create RegisterScreen**

Form: name, email, phone (+62 prefix), password, confirm password. "Daftar" button. "Sudah punya akun? Masuk" link. On submit: `register()`, navigate to `/auth/sport-selection`.

**Step 3: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/auth/presentation/screens/ lib/routing/app_router.dart
git commit -m "feat: add login and register screens"
```

---

## Task 10: Sport Selection Screen

**Files:**
- Create: `lib/features/auth/presentation/screens/sport_selection_screen.dart`
- Create: `lib/features/auth/presentation/widgets/sport_chip_selector.dart`

**Step 1: Create SportChipSelector widget**

`FilterChip` styled with `SportThemeExtension` colors. Props: `Sport`, `isSelected`, `onToggle`. Shows sport icon + name.

**Step 2: Create SportSelectionScreen**

Title "Pilih Olahraga Favorit". Grid of `SportChipSelector` for all `Sport.values`. Multi-select. When sport selected, show `DropdownButton<LevelTier>` for self-assessment. "Lanjutkan" button (disabled until >= 1 sport). On submit: update profile, navigate to `/player/home`.

Sport icons mapping: tennis → `Icons.sports_tennis`, badminton → `Icons.sports`, futsal → `Icons.sports_soccer`, basketball → `Icons.sports_basketball`, volleyball → `Icons.sports_volleyball`, padel → `Icons.sports_tennis`, tableTennis → `Icons.sports`.

**Step 3: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/auth/presentation/ lib/routing/app_router.dart
git commit -m "feat: add sport selection screen with level self-assessment"
```

---

## Task 11: Venue Repository + Providers

**Files:**
- Create: `lib/features/venue/data/venue_repository.dart`
- Create: `lib/features/venue/data/mock_venue_repository.dart`
- Create: `lib/features/venue/providers/venue_list_provider.dart`
- Create: `lib/features/venue/providers/venue_detail_provider.dart`
- Create: `lib/features/venue/providers/venue_filter_provider.dart`
- Create: `lib/features/venue/providers/court_slots_provider.dart`

**Step 1: Create abstract VenueRepository**

```dart
abstract class VenueRepository {
  Future<List<Venue>> getVenues({Sport? sport, String? city});
  Future<Venue> getVenue(String id);
  Future<List<CourtSlot>> getCourtSlots(String courtId, DateTime date);
}
```

**Step 2: Create MockVenueRepository**

Uses `MockData.venues`, filters by sport. `getCourtSlots` uses `MockData.generateSlots()`. 500ms delay.

**Step 3: Create providers**

- `venueFilterProvider` — `NotifierProvider` with `VenueFilterState` (sport?, city?). Methods: `setSport()`, `reset()`.
- `venueListProvider` — `AsyncNotifierProvider` that watches filter and calls `repo.getVenues()`.
- `venueDetailProvider(String id)` — `FutureProvider.family`.
- `courtSlotsProvider` — `FutureProvider.family` taking `({String courtId, DateTime date})`.
- `venueRepositoryProvider` — DI switch based on `useMockData`.

**Step 4: Run build_runner (if using @riverpod codegen), verify + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
git add lib/features/venue/data/ lib/features/venue/providers/
git commit -m "feat: add venue repository, mock implementation, providers"
```

---

## Task 12: Explore Screen + Venue List + Venue Widgets

**Files:**
- Create: `lib/features/venue/presentation/screens/explore_screen.dart`
- Create: `lib/features/venue/presentation/screens/venue_list_screen.dart`
- Create: `lib/features/venue/presentation/widgets/venue_card.dart`
- Create: `lib/features/venue/presentation/widgets/facility_chips.dart`

**Step 1: Create ExploreScreen**

`DefaultTabController` with 3 tabs: "Lapangan" | "Coach" | "Sesi". Only tab 0 active (`VenueListScreen`). Others show `EmptyState(message: 'Segera hadir')`.

**Step 2: Create VenueCard widget**

Card with: venue photo (16:9, `CachedNetworkImage`, shimmer placeholder), name (`titleMedium`), address (`bodySmall`), star + rating + review count, sport chips row, price range (`priceSmall`). Tap → `context.push('/venue/${venue.id}')`.

**Step 3: Create FacilityChips widget**

Horizontal row of small chips with icons: parking → `Icons.local_parking`, shower → `Icons.shower`, wifi → `Icons.wifi`, canteen → `Icons.restaurant`, locker → `Icons.lock`.

**Step 4: Create VenueListScreen**

Sport filter chips at top (horizontal scroll, `SportChipSelector`). Below: `AsyncValueWidget` wrapping `venueListProvider` → list of `VenueCard`. Pull-to-refresh via `RefreshIndicator`. Loading: shimmer cards. Empty: `EmptyState`.

**Step 5: Update router (replace Explore tab placeholder), verify + commit**

```bash
flutter analyze
git add lib/features/venue/presentation/ lib/routing/app_router.dart
git commit -m "feat: add explore screen, venue list with filtering, venue card"
```

---

## Task 13: Venue Detail Screen + Court Card

**Files:**
- Create: `lib/features/venue/presentation/screens/venue_detail_screen.dart`
- Create: `lib/features/venue/presentation/widgets/court_card.dart`

**Step 1: Create CourtCard widget**

Card showing: court name, sport chip (colored via `SportThemeExtension`), surface type, environment badge (indoor/outdoor), "Booking" `AppButton` → sets court+venue in booking flow provider, navigates to `/booking/flow/court/${court.id}`.

**Step 2: Create VenueDetailScreen**

Full-screen (pushed, no bottom nav). `CustomScrollView` with:
- `SliverAppBar` with expandable photo (first photo from `venue.photos`)
- Venue name + verified icon
- Address row with location icon
- Rating stars + review count
- `FacilityChips` row
- Description text
- "Lapangan Tersedia" section header
- List of `CourtCard` widgets for each court
- WhatsApp button (placeholder)

Uses `AsyncValueWidget` wrapping `venueDetailProvider(id)`.

**Step 3: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/venue/presentation/ lib/routing/app_router.dart
git commit -m "feat: add venue detail screen with court listing"
```

---

## Task 14: Booking Repository + Providers

**Files:**
- Create: `lib/features/booking/data/booking_repository.dart`
- Create: `lib/features/booking/data/mock_booking_repository.dart`
- Create: `lib/features/booking/providers/booking_flow_provider.dart`
- Create: `lib/features/booking/providers/booking_list_provider.dart`
- Create: `lib/features/booking/providers/booking_detail_provider.dart`

**Step 1: Create abstract BookingRepository**

```dart
abstract class BookingRepository {
  Future<Booking> createBooking({
    required String courtId, required String venueId,
    required DateTime date, required String startTime, required String endTime,
    required int totalAmount, required PaymentMethodType paymentMethod,
    String? venueName, String? courtName,
  });
  Future<List<Booking>> getBookings({BookingStatus? status});
  Future<Booking> getBooking(String id);
  Future<Booking> uploadPaymentProof(String bookingId, String proofUrl);
  Future<Booking> cancelBooking(String id);
}
```

**Step 2: Create MockBookingRepository**

`createBooking`: generates booking code `BK-yyyyMMdd-XXXX`, status `pendingPayment`, expiresAt = now+1h. Returns from `MockData.bookings` for list/detail. 500ms delay.

**Step 3: Create BookingFlowProvider**

`NotifierProvider` holding `BookingSummary`. Methods: `selectCourt(Court, Venue)`, `selectDate(DateTime)`, `selectSlots(List<CourtSlot>)`, `selectPaymentMethod(PaymentMethodType)`, `submit()` → calls repo, returns Booking, `reset()`.

**Step 4: Create list + detail providers**

- `bookingListProvider` — `AsyncNotifierProvider`, fetch via repo
- `bookingDetailProvider(String id)` — `FutureProvider.family`
- `bookingRepositoryProvider` — DI switch

**Step 5: Run build_runner, verify + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
git add lib/features/booking/data/ lib/features/booking/providers/
git commit -m "feat: add booking repository, mock implementation, flow + list providers"
```

---

## Task 15: Booking Flow — Date Selection + Slot Selection Screens

**Files:**
- Create: `lib/features/booking/presentation/screens/booking_date_screen.dart`
- Create: `lib/features/booking/presentation/screens/slot_selection_screen.dart`
- Create: `lib/features/booking/presentation/widgets/date_picker_strip.dart`
- Create: `lib/features/booking/presentation/widgets/slot_grid.dart`

**Step 1: Create DatePickerStrip widget**

Horizontal scroll of next 14 days. Each tile: day name (Sen/Sel/Rab/...) + date number. Selected tile: `AppColors.primary` background, white text. Unselected: surface background.

**Step 2: Create BookingDateScreen**

Shows court+venue info card at top (from flow provider). `DatePickerStrip` below. When date selected: fetch slots via `courtSlotsProvider`. Show loading shimmer while fetching. "Lanjutkan" button disabled until date selected.

**Step 3: Create SlotGrid widget**

`GridView` with 2 columns. Each tile: time range + price. Colors: green (available) → `AppColors.success50` bg, gray (booked) → `AppColors.neutral100`, blue (selected) → `AppColors.primary50`. Tap available → toggle selection. Running total at bottom.

**Step 4: Create SlotSelectionScreen**

Selected date header. `SlotGrid` with slots from provider. Bottom bar: total amount + "Lanjutkan" button. On continue: `bookingFlowProvider.selectSlots()`, navigate to summary.

**Step 5: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/booking/presentation/ lib/routing/app_router.dart
git commit -m "feat: add booking date selection and slot selection screens"
```

---

## Task 16: Booking Flow — Summary, Payment, Confirmation Screens

**Files:**
- Create: `lib/features/booking/presentation/screens/booking_summary_screen.dart`
- Create: `lib/features/booking/presentation/screens/payment_screen.dart`
- Create: `lib/features/booking/presentation/screens/booking_confirmation_screen.dart`

**Step 1: Create BookingSummaryScreen**

Shows: venue name, court name, date, time range, duration, price per slot breakdown, total. "Lanjutkan ke Pembayaran" `AppButton`. On tap: `bookingFlowProvider.submit()` → creates booking → navigate to payment with booking ID.

**Step 2: Create PaymentScreen**

Two tabs: "QRIS" | "Transfer Bank". QRIS tab: placeholder image. Bank tab: bank name, account number (copy to clipboard button), account holder. Countdown timer from `booking.expiresAt` ("Bayar dalam mm:ss"). "Saya Sudah Bayar" button → update status to `waitingConfirmation` → navigate to confirmation.

**Step 3: Create BookingConfirmationScreen**

Success: large check icon (green), "Booking Berhasil Dibuat!", booking code, brief summary. "Lihat Booking Saya" button → `context.go('/player/bookings')` (clears flow stack).

**Step 4: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/booking/presentation/screens/ lib/routing/app_router.dart
git commit -m "feat: add booking summary, payment, and confirmation screens"
```

---

## Task 17: Booking List + Booking Detail Screens

**Files:**
- Create: `lib/features/booking/presentation/screens/booking_list_screen.dart`
- Create: `lib/features/booking/presentation/screens/booking_detail_screen.dart`
- Create: `lib/features/booking/presentation/widgets/booking_card.dart`
- Create: `lib/features/booking/presentation/widgets/status_badge.dart`
- Create: `lib/features/booking/presentation/widgets/status_stepper.dart`

**Step 1: Create StatusBadge widget**

Small colored badge using `BookingStatusThemeExtension`. Indonesian labels: pendingPayment → "Menunggu Pembayaran", waitingConfirmation → "Menunggu Konfirmasi", confirmed → "Terkonfirmasi", completed → "Selesai", cancelled → "Dibatalkan", rejected → "Ditolak", expired → "Kadaluarsa".

**Step 2: Create BookingCard widget**

Card with: sport chip, venue+court name, date+time, `StatusBadge`, price. Tap → `context.push('/booking/${booking.id}')`.

**Step 3: Create StatusStepper widget**

Horizontal stepper: Dibuat → Pembayaran → Konfirmasi → Selesai. Active step highlighted with primary color, completed steps with check icon, error states (rejected/cancelled) in red.

**Step 4: Create BookingListScreen**

TabBar: "Mendatang" | "Selesai". Each tab: `AsyncValueWidget` → list of `BookingCard`. Pull-to-refresh. Empty state per tab.

**Step 5: Create BookingDetailScreen**

Full-screen. `StatusStepper` at top. Booking info card (venue, court, date, time, code). Payment section. "Batalkan Booking" button (for cancellable states, with confirmation dialog). Uses `bookingDetailProvider(id)`.

**Step 6: Update router, verify + commit**

```bash
flutter analyze
git add lib/features/booking/presentation/ lib/routing/app_router.dart
git commit -m "feat: add booking list with status tabs, booking detail with stepper"
```

---

## Task 18: Home Screen + Profile Screen + Final Wiring

**Files:**
- Create: `lib/features/home/presentation/screens/home_screen.dart`
- Create: `lib/features/profile/presentation/screens/profile_screen.dart`
- Modify: `lib/routing/app_router.dart` (final cleanup — remove all placeholders)

**Step 1: Create HomeScreen**

Greeting: time-based "Selamat Pagi/Siang/Sore/Malam, {name}!". Upcoming booking card (if any, from bookingListProvider — first upcoming). "Cari Lapangan" CTA `AppButton` → `/player/explore`. Sport quick-access chips (horizontal scroll, tapping navigates to explore with that sport filter).

**Step 2: Create ProfileScreen**

Avatar placeholder circle, user name, level badge (`GamificationThemeExtension` color), XP progress bar (`LinearProgressIndicator`, totalXp / nextTierThreshold). Quick stats row: total bookings, sports count. Menu items via `ListTile`: "Edit Profil" (placeholder), "Pencapaian" (placeholder), "Pengaturan" (placeholder), "Keluar" (calls logout, navigates to `/auth/login`).

**Step 3: Final router cleanup**

Remove all `_PlaceholderScreen` usages. Ensure every route points to a real screen. Verify all navigation paths work.

**Step 4: Full verification**

```bash
flutter analyze
flutter build apk --debug -t lib/main_mock.dart
```

Run on emulator and manually test:
- Splash → Onboarding → Login → Home
- Home → Explore → Venue List → Venue Detail → Book Court → Date → Slots → Summary → Payment → Confirmation
- Bookings tab → Booking detail
- Profile → Logout → Login

**Step 5: Final commit**

```bash
git add lib/features/home/ lib/features/profile/ lib/routing/app_router.dart
git commit -m "feat: add home screen, profile screen, finalize Phase 1 routing"
```

---

## Verification Checklist

After all 18 tasks:

1. `flutter analyze` → zero issues
2. `flutter build apk --debug -t lib/main_mock.dart` → builds successfully
3. Run on emulator — full flow works:
   - [ ] Splash → Onboarding (3 slides) → Login
   - [ ] Login → Home with greeting
   - [ ] Explore tab → Venue list with sport filter
   - [ ] Tap venue → Venue detail with courts
   - [ ] Tap "Booking" → Date selection → Slot selection → Summary → Payment → Confirmation
   - [ ] Bookings tab → Upcoming/Past tabs → Booking detail with status stepper
   - [ ] Profile → Logout → Back to login
4. All Indonesian text (Bahasa Indonesia primary)
5. Rupiah formatting correct (Rp 150.000)
6. Theme colors match design system
