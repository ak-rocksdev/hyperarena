# HyperArena — Flutter Architecture Design

> **Status:** Approved
> **Date:** 2026-02-07
> **Pattern:** Riverpod + Feature-First + go_router
> **Reference:** `DESIGN_SYSTEM.md`, `MVP_FLUTTER_SPECIFICATION.md`

---

## 1. ARCHITECTURE OVERVIEW

### 1.1 Core Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State management | Riverpod + codegen | Less boilerplate than BLoC, auto-dispose, compile-safe DI |
| Models | Freezed + json_serializable | Immutable state, generated copyWith/equality/JSON |
| Navigation | go_router | Role-based shells, deep linking, declarative guards |
| HTTP client | Dio | Interceptors for auth/locale, timeout config |
| Local storage | SharedPreferences + Hive | Preferences + structured cache |
| Theme | Design system tokens | `DESIGN_SYSTEM.md` → Dart files in `core/theme/` |
| Mock strategy | Abstract repositories | Swap mock/real via environment config, zero UI changes |
| Folder structure | Feature-first | Each feature owns its data, providers, and presentation |

### 1.2 App Scope (Mobile)

Three roles in **one app**: Player, Coach, Organizer.
Court Owner is **out of mobile scope** — handled via Laravel web panel.

### 1.3 Layered Architecture (per feature)

```
┌─────────────────────────────────┐
│  Presentation (Screens/Widgets) │  ref.watch() providers
├─────────────────────────────────┤
│  Providers (Riverpod Notifiers) │  Business logic, state
├─────────────────────────────────┤
│  Data (Repository + Models)     │  API calls, JSON parsing
├─────────────────────────────────┤
│  Core (Dio, Storage, Services)  │  Shared infrastructure
└─────────────────────────────────┘
```

Data flows **one direction**: Screen → Provider → Repository → API.
Screens never call repositories directly. Providers never call Dio directly.

---

## 2. ENVIRONMENT CONFIGURATION

HyperArena supports four environments. Switching is done via separate entry points — no code changes needed inside features.

### 2.1 Environments

| Environment | API Base URL | Data Source | Logging | Use Case |
|-------------|-------------|-------------|---------|----------|
| **mock** | — (none) | Mock repositories with fake data | Verbose | UI development, design iteration |
| **local** | `http://hyperarena.local/api` | Laravel local via Laragon | Verbose | API integration testing |
| **dev** | `https://dev-api.hyperarena.id/api` | Laravel on dev server | Verbose | QA, staging, beta testing |
| **production** | `https://api.hyperarena.id/api` | Laravel on production | Errors only | Live app |

> Note: Local development uses Laragon with virtual host `hyperarena.local`. On Android emulator, this domain won't resolve by default — add `10.0.2.2 hyperarena.local` to the emulator's `/etc/hosts`, or use your machine's LAN IP (e.g., `http://192.168.x.x/api`) as a fallback. iOS simulator shares the host's network, so `hyperarena.local` works directly.

### 2.2 Configuration Class

```dart
// core/config/app_config.dart

enum Environment { mock, local, dev, production }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool useMockData;
  final bool enableLogging;
  final bool showDebugBanner;
  final Duration mockDelay;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.useMockData,
    required this.enableLogging,
    required this.showDebugBanner,
    this.mockDelay = const Duration(milliseconds: 500),
  });

  bool get isProduction => environment == Environment.production;
  bool get isDev => environment == Environment.dev;
  bool get isLocal => environment == Environment.local;
  bool get isMock => environment == Environment.mock;

  static const mock = AppConfig(
    environment: Environment.mock,
    apiBaseUrl: '',
    useMockData: true,
    enableLogging: true,
    showDebugBanner: true,
    mockDelay: Duration(milliseconds: 500),
  );

  static const local = AppConfig(
    environment: Environment.local,
    apiBaseUrl: 'http://hyperarena.local/api',
    useMockData: false,
    enableLogging: true,
    showDebugBanner: true,
  );

  static const dev = AppConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://dev-api.hyperarena.id/api',
    useMockData: false,
    enableLogging: true,
    showDebugBanner: true,
  );

  static const production = AppConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.hyperarena.id/api',
    useMockData: false,
    enableLogging: false,
    showDebugBanner: false,
  );
}
```

### 2.3 Entry Points

Each environment has its own `main` file. Run with `flutter run -t lib/main_<env>.dart`.

```dart
// lib/main.dart (production — default)
void main() => bootstrap(AppConfig.production);

// lib/main_mock.dart
void main() => bootstrap(AppConfig.mock);

// lib/main_local.dart
void main() => bootstrap(AppConfig.local);

// lib/main_dev.dart
void main() => bootstrap(AppConfig.dev);
```

```dart
// lib/app_bootstrap.dart

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services that need async setup
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const HyperArenaApp(),
    ),
  );
}
```

### 2.4 Repository Auto-Switch

Repositories automatically select mock or real implementation based on environment:

```dart
// Example: venue_repository_provider.dart

@riverpod
VenueRepository venueRepository(Ref ref) {
  final config = ref.read(appConfigProvider);
  if (config.useMockData) {
    return MockVenueRepository(delay: config.mockDelay);
  }
  return ApiVenueRepository(ref.read(dioProvider));
}
```

Every feature's repository provider follows this same pattern. Screens and providers are completely unaware of which environment is active.

### 2.5 VS Code Launch Configs

```jsonc
// .vscode/launch.json
{
  "configurations": [
    { "name": "Mock",       "request": "launch", "type": "dart", "program": "lib/main_mock.dart" },
    { "name": "Local",      "request": "launch", "type": "dart", "program": "lib/main_local.dart" },
    { "name": "Dev",        "request": "launch", "type": "dart", "program": "lib/main_dev.dart" },
    { "name": "Production", "request": "launch", "type": "dart", "program": "lib/main.dart" }
  ]
}
```

---

## 3. PROJECT STRUCTURE

```
lib/
├── main.dart                         # Production entry point
├── main_mock.dart                    # Mock entry point
├── main_local.dart                   # Local API entry point
├── main_dev.dart                     # Dev server entry point
├── app_bootstrap.dart                # Shared bootstrap logic
├── app.dart                          # MaterialApp.router, theme, ProviderScope
│
├── core/
│   ├── config/
│   │   └── app_config.dart           # Environment enum + config class
│   │
│   ├── theme/                        # ← FROM DESIGN_SYSTEM.md
│   │   ├── app_colors.dart           # Brand, neutral, semantic (Sections 1.1–1.6)
│   │   ├── app_domain_colors.dart    # Sport, booking, level, rating (Sections 1.7–1.10)
│   │   ├── app_surfaces.dart         # Surface, overlay, gradient (Sections 1.4, 1.11–1.13)
│   │   ├── app_typography.dart       # Plus Jakarta Sans, type scale (Section 2)
│   │   ├── app_dimensions.dart       # Spacing, radius, component sizes (Section 3)
│   │   ├── app_shadows.dart          # Shadow/elevation tokens (Section 4)
│   │   ├── app_animations.dart       # Duration + curve tokens (Section 5)
│   │   ├── app_theme.dart            # Light ThemeData builder (Section 6)
│   │   ├── app_theme_dark.dart       # Dark ThemeData builder (Section 1.13)
│   │   ├── app_component_styles.dart # Reusable BoxDecoration factories (Section 7)
│   │   ├── app_enums.dart            # Sport, BookingStatus, LevelTier enums
│   │   ├── app_theme_extensions.dart # SportTheme, BookingStatusTheme, etc. (Section 8)
│   │   └── theme.dart                # Barrel export
│   │
│   ├── network/
│   │   ├── dio_client.dart           # Dio provider with auth/locale interceptors
│   │   ├── api_interceptors.dart     # Logging, error transform
│   │   └── api_exceptions.dart       # Typed exceptions (NetworkException, etc.)
│   │
│   ├── storage/
│   │   ├── storage_service.dart      # SharedPreferences wrapper
│   │   └── hive_service.dart         # Hive for structured cache (optional)
│   │
│   ├── services/
│   │   ├── notification_service.dart # FCM setup + token management
│   │   └── upload_service.dart       # S3 file upload
│   │
│   ├── utils/
│   │   ├── formatters.dart           # Currency (Rp), date (dd MMM yyyy), time
│   │   ├── validators.dart           # Email, phone, required field
│   │   └── helpers.dart              # WhatsApp launcher, map launcher
│   │
│   ├── constants/
│   │   └── api_endpoints.dart        # Route strings (if not inline)
│   │
│   ├── widgets/                      # Truly generic, not tied to any feature
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── app_scaffold.dart         # Standardized screen wrapper
│   │   ├── shimmer_loading.dart      # Skeleton placeholders (Section 7.13)
│   │   ├── empty_state.dart
│   │   ├── error_view.dart
│   │   └── async_value_widget.dart   # Generic .when() handler
│   │
│   └── mocks/                        # Mock data (only in mock environment)
│       ├── mock_data.dart            # Central mock registry
│       ├── mock_venues.dart
│       ├── mock_coaches.dart
│       ├── mock_bookings.dart
│       ├── mock_sessions.dart
│       ├── mock_users.dart
│       └── mock_gamification.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user.dart
│   │   │   │   └── auth_token.dart
│   │   │   ├── auth_repository.dart
│   │   │   └── mock_auth_repository.dart
│   │   ├── providers/
│   │   │   ├── auth_provider.dart        # Holds current user + token
│   │   │   └── auth_actions_provider.dart # Login, register, logout
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── onboarding_screen.dart
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   ├── sport_selection_screen.dart
│   │       │   └── level_assessment_screen.dart
│   │       └── widgets/
│   │           ├── social_login_buttons.dart
│   │           └── sport_chip_selector.dart
│   │
│   ├── venue/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── venue.dart
│   │   │   │   ├── court.dart
│   │   │   │   └── court_slot.dart
│   │   │   ├── venue_repository.dart
│   │   │   └── mock_venue_repository.dart
│   │   ├── providers/
│   │   │   ├── venue_list_provider.dart
│   │   │   ├── venue_detail_provider.dart    # Family by ID
│   │   │   ├── venue_filter_provider.dart    # Sync filter state
│   │   │   └── court_slots_provider.dart     # Family by courtId + date
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── venue_list_screen.dart
│   │       │   └── venue_detail_screen.dart
│   │       └── widgets/
│   │           ├── venue_card.dart
│   │           ├── court_card.dart
│   │           ├── slot_grid.dart
│   │           └── facility_chips.dart
│   │
│   ├── booking/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── booking.dart
│   │   │   │   └── booking_summary.dart    # Flow wizard state
│   │   │   ├── dto/
│   │   │   │   ├── create_booking_request.dart
│   │   │   │   └── upload_proof_request.dart
│   │   │   ├── booking_repository.dart
│   │   │   └── mock_booking_repository.dart
│   │   ├── providers/
│   │   │   ├── booking_list_provider.dart     # AsyncNotifier — my bookings
│   │   │   ├── booking_detail_provider.dart   # Family by ID
│   │   │   ├── booking_flow_provider.dart     # Notifier — multi-step wizard
│   │   │   └── booking_actions_provider.dart  # Confirm, reject, cancel
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── booking_date_screen.dart
│   │       │   ├── slot_selection_screen.dart
│   │       │   ├── booking_summary_screen.dart
│   │       │   ├── payment_screen.dart
│   │       │   ├── upload_proof_screen.dart
│   │       │   ├── booking_confirmation_screen.dart
│   │       │   ├── booking_list_screen.dart
│   │       │   └── booking_detail_screen.dart   # Role-aware
│   │       └── widgets/
│   │           ├── booking_card.dart
│   │           ├── status_stepper.dart
│   │           ├── status_badge.dart
│   │           └── payment_method_display.dart
│   │
│   ├── coach/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── coach.dart
│   │   │   │   ├── coach_package.dart
│   │   │   │   └── assessment.dart
│   │   │   ├── coach_repository.dart
│   │   │   └── mock_coach_repository.dart
│   │   ├── providers/
│   │   │   ├── coach_list_provider.dart
│   │   │   ├── coach_detail_provider.dart
│   │   │   ├── coach_filter_provider.dart
│   │   │   ├── coach_schedule_provider.dart   # Coach role: manage schedule
│   │   │   ├── student_list_provider.dart     # Coach role: my students
│   │   │   └── assessment_provider.dart       # Create + view assessments
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── coach_list_screen.dart      # Player browses
│   │       │   ├── coach_detail_screen.dart    # Player views
│   │       │   ├── coach_dashboard_screen.dart # Coach role
│   │       │   ├── coach_schedule_screen.dart  # Coach role
│   │       │   ├── student_list_screen.dart    # Coach role
│   │       │   ├── student_detail_screen.dart  # Coach role
│   │       │   ├── assessment_form_screen.dart # Coach role
│   │       │   └── assessment_detail_screen.dart
│   │       └── widgets/
│   │           ├── coach_card.dart
│   │           ├── package_card.dart
│   │           └── radar_chart_widget.dart
│   │
│   ├── session/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── open_session.dart
│   │   │   │   └── participant.dart
│   │   │   ├── session_repository.dart
│   │   │   └── mock_session_repository.dart
│   │   ├── providers/
│   │   │   ├── session_list_provider.dart
│   │   │   ├── session_detail_provider.dart
│   │   │   ├── session_filter_provider.dart
│   │   │   ├── create_session_provider.dart    # Organizer: multi-step form
│   │   │   └── participant_provider.dart       # Organizer: manage participants
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── session_list_screen.dart
│   │       │   ├── session_detail_screen.dart
│   │       │   ├── organizer_dashboard_screen.dart
│   │       │   ├── organizer_sessions_screen.dart
│   │       │   ├── create_session_screen.dart       # Multi-step
│   │       │   ├── participant_management_screen.dart
│   │       │   └── organizer_community_screen.dart
│   │       └── widgets/
│   │           ├── session_card.dart
│   │           ├── participant_list.dart
│   │           └── spots_progress_bar.dart
│   │
│   ├── review/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── review.dart
│   │   │   ├── review_repository.dart
│   │   │   └── mock_review_repository.dart
│   │   ├── providers/
│   │   │   ├── review_list_provider.dart
│   │   │   └── submit_review_provider.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── submit_review_screen.dart
│   │       │   └── review_list_screen.dart
│   │       └── widgets/
│   │           ├── review_card.dart
│   │           └── rating_stars.dart
│   │
│   ├── gamification/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── badge.dart
│   │   │   │   ├── xp_transaction.dart
│   │   │   │   └── level_tier.dart
│   │   │   ├── gamification_repository.dart
│   │   │   └── mock_gamification_repository.dart
│   │   ├── providers/
│   │   │   ├── gamification_provider.dart    # XP, level, stats
│   │   │   └── badges_provider.dart          # All badges + earned status
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── achievements_screen.dart
│   │       └── widgets/
│   │           ├── xp_progress_bar.dart
│   │           ├── level_badge.dart
│   │           └── badge_grid.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── player_profile.dart
│   │   │   ├── profile_repository.dart
│   │   │   └── mock_profile_repository.dart
│   │   ├── providers/
│   │   │   ├── profile_provider.dart
│   │   │   └── career_provider.dart          # Radar chart + assessment history
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── profile_screen.dart
│   │       │   ├── edit_profile_screen.dart
│   │       │   ├── career_screen.dart
│   │       │   ├── settings_screen.dart
│   │       │   └── my_reviews_screen.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           ├── sport_badges_row.dart
│   │           └── quick_stats_card.dart
│   │
│   └── notification/
│       ├── data/
│       │   ├── models/
│       │   │   └── notification_item.dart
│       │   ├── notification_repository.dart
│       │   └── mock_notification_repository.dart
│       ├── providers/
│       │   ├── notification_list_provider.dart
│       │   └── unread_count_provider.dart
│       └── presentation/
│           ├── screens/
│           │   └── notifications_screen.dart
│           └── widgets/
│               └── notification_tile.dart
│
├── shared/
│   ├── models/
│   │   └── enums.dart                # UserRole, Sport, BookingStatus, etc.
│   └── providers/
│       ├── app_config_provider.dart  # Environment config
│       ├── auth_state_provider.dart  # Current user, global access
│       ├── locale_provider.dart      # id / en
│       └── connectivity_provider.dart
│
└── routing/
    ├── app_router.dart               # GoRouter with role-based shells
    └── route_guards.dart             # Auth redirect logic
```

---

## 4. RIVERPOD PROVIDER PATTERNS

### 4.1 Pattern Reference

| Pattern | Riverpod Type | Use Case |
|---------|--------------|----------|
| Async data fetch | `AsyncNotifierProvider` | Lists, detail screens, dashboard data |
| Detail by ID | `FutureProvider.family` | `/venue/:id`, `/booking/:id` |
| Sync UI state | `NotifierProvider` | Filters, form state, booking flow wizard |
| Mutations | Methods on Notifier | Confirm, reject, cancel, submit |
| Singletons / DI | `Provider` | Dio, repositories, services |
| Simple derived | `Provider` | Computed values from other providers |

### 4.2 Async Data Fetching

```dart
// features/venue/providers/venue_list_provider.dart

@riverpod
class VenueList extends _$VenueList {
  @override
  Future<List<Venue>> build() async {
    final filter = ref.watch(venueFilterProvider);
    final repo = ref.read(venueRepositoryProvider);
    return repo.getVenues(
      sport: filter.sport,
      city: filter.city,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(venueRepositoryProvider).getVenues(),
    );
  }
}
```

Key behavior: When `venueFilterProvider` changes, this provider **automatically refetches**. No manual wiring needed.

### 4.3 Detail by ID (Family)

```dart
@riverpod
Future<Venue> venueDetail(Ref ref, String venueId) async {
  final repo = ref.read(venueRepositoryProvider);
  return repo.getVenue(venueId);
}
```

### 4.4 Sync State (Filters, Flows)

```dart
@riverpod
class VenueFilter extends _$VenueFilter {
  @override
  VenueFilterState build() => VenueFilterState.defaults();

  void setSport(Sport? sport) => state = state.copyWith(sport: sport);
  void setPriceRange(double min, double max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);
  void reset() => state = VenueFilterState.defaults();
}
```

### 4.5 Multi-Step Booking Flow

```dart
@riverpod
class BookingFlow extends _$BookingFlow {
  @override
  BookingSummary build() => BookingSummary.empty();

  void selectCourt(Court court) =>
      state = state.copyWith(court: court);

  void selectDate(DateTime date) =>
      state = state.copyWith(date: date);

  void selectSlots(List<CourtSlot> slots) =>
      state = state.copyWith(
        slots: slots,
        totalAmount: slots.fold(0, (sum, s) => sum + s.price),
      );

  void selectPaymentMethod(PaymentMethodType method) =>
      state = state.copyWith(paymentMethod: method);

  Future<Booking> submit() async {
    final repo = ref.read(bookingRepositoryProvider);
    final booking = await repo.createBooking(
      CreateBookingRequest.fromSummary(state),
    );
    // Reset flow after successful creation
    state = BookingSummary.empty();
    return booking;
  }
}
```

### 4.6 Repository DI with Environment Switch

```dart
@riverpod
VenueRepository venueRepository(Ref ref) {
  final config = ref.read(appConfigProvider);
  if (config.useMockData) {
    return MockVenueRepository(delay: config.mockDelay);
  }
  return ApiVenueRepository(ref.read(dioProvider));
}
```

### 4.7 Screen Consumption (Standard Pattern)

```dart
class VenueListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venues = ref.watch(venueListProvider);

    return venues.when(
      loading: () => const VenueListSkeleton(),   // Shimmer from Section 7.13
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(venueListProvider),
      ),
      data: (list) => list.isEmpty
          ? const EmptyState(message: 'No venues found')
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) => VenueCard(venue: list[i]),
            ),
    );
  }
}
```

---

## 5. DATA LAYER

### 5.1 Freezed Models

All models use Freezed for immutability, equality, copyWith, and JSON serialization.

```dart
// features/venue/data/models/venue.dart

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required String description,
    required String address,
    required String city,
    required double latitude,
    required double longitude,
    String? phone,
    String? whatsappNumber,
    required List<String> facilities,
    required List<String> photos,
    required bool isVerified,
    required double avgRating,
    required int totalReviews,
    required List<Court> courts,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) =>
      _$VenueFromJson(json);
}
```

### 5.2 Shared Enums

```dart
// shared/models/enums.dart

enum UserRole { player, coach, organizer }

enum Sport {
  tennis, padel, badminton, futsal,
  basketball, volleyball, tableTennis;
}

enum BookingStatus {
  pendingPayment, waitingConfirmation, confirmed,
  rejected, cancelled, completed, expired;
}

enum BookingType { court, coaching, openSession }

enum LevelTier { rookie, amateur, intermediate, advanced, pro }

enum PaymentMethodType { qris, bankTransfer }
```

These enums are shared between:
- **Data layer**: JSON parsing (`booking.status`)
- **Theme layer**: Design system colors (`sportColor(Sport.tennis)`)
- **UI layer**: Display logic (`statusBadge(BookingStatus.confirmed)`)

### 5.3 Repository Contract

Every repository follows the same abstract + implementation pattern:

```dart
// Abstract contract
abstract class VenueRepository {
  Future<List<Venue>> getVenues({Sport? sport, String? city, int page = 1});
  Future<Venue> getVenue(String id);
  Future<List<CourtSlot>> getCourtSlots(String courtId, DateTime date);
}

// Mock implementation
class MockVenueRepository implements VenueRepository {
  final Duration delay;
  MockVenueRepository({this.delay = const Duration(milliseconds: 500)});

  @override
  Future<List<Venue>> getVenues({Sport? sport, String? city, int page = 1}) async {
    await Future.delayed(delay);
    var venues = MockData.venues;
    if (sport != null) venues = venues.where((v) => /* filter */).toList();
    return venues;
  }
  // ...
}

// API implementation (added when backend is ready)
class ApiVenueRepository implements VenueRepository {
  final Dio _dio;
  ApiVenueRepository(this._dio);

  @override
  Future<List<Venue>> getVenues({Sport? sport, String? city, int page = 1}) async {
    final response = await _dio.get('/venues', queryParameters: {
      if (sport != null) 'sport': sport.name,
      if (city != null) 'city': city,
      'page': page,
    });
    return (response.data['data'] as List)
        .map((e) => Venue.fromJson(e))
        .toList();
  }
  // ...
}
```

### 5.4 Dio Client

```dart
// core/network/dio_client.dart

@riverpod
Dio dio(Ref ref) {
  final config = ref.read(appConfigProvider);
  final dio = Dio(BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  // Auth token injection
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final locale = ref.read(localeProvider);
      options.headers['Accept-Language'] = locale;
      handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        ref.read(authProvider.notifier).logout();
      }
      handler.next(error);
    },
  ));

  // Logging (non-production only)
  if (config.enableLogging) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return dio;
}
```

---

## 6. ROUTING

### 6.1 Role-Based Shell Architecture

```dart
// routing/app_router.dart

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null; // Splash handles its own navigation
      if (!isAuthenticated && !isAuthRoute) return '/auth/login';
      if (isAuthenticated && isAuthRoute) {
        return switch (authState!.role) {
          UserRole.player    => '/player/home',
          UserRole.coach     => '/coach/dashboard',
          UserRole.organizer => '/organizer/dashboard',
        };
      }
      return null;
    },
    routes: [
      // Pre-auth
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/sport-selection', builder: (_, __) => const SportSelectionScreen()),

      // Player shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.player,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/player/home', builder: (_, __) => const PlayerHomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/player/explore', builder: (_, __) => const ExploreScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/player/bookings', builder: (_, __) => const BookingListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/player/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),

      // Coach shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.coach,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/coach/dashboard', builder: (_, __) => const CoachDashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/coach/schedule', builder: (_, __) => const CoachScheduleScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/coach/students', builder: (_, __) => const StudentListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/coach/profile', builder: (_, __) => const CoachProfileScreen()),
          ]),
        ],
      ),

      // Organizer shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.organizer,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/organizer/dashboard', builder: (_, __) => const OrganizerDashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/organizer/sessions', builder: (_, __) => const OrganizerSessionsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/organizer/community', builder: (_, __) => const OrganizerCommunityScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/organizer/profile', builder: (_, __) => const OrganizerProfileScreen()),
          ]),
        ],
      ),

      // Shared routes (full screen, on top of any shell)
      GoRoute(path: '/venue/:id', builder: (_, state) =>
          VenueDetailScreen(id: state.pathParameters['id']!)),
      GoRoute(path: '/coach-detail/:id', builder: (_, state) =>
          CoachDetailScreen(id: state.pathParameters['id']!)),
      GoRoute(path: '/session/:id', builder: (_, state) =>
          SessionDetailScreen(id: state.pathParameters['id']!)),
      GoRoute(path: '/booking/:id', builder: (_, state) =>
          BookingDetailScreen(id: state.pathParameters['id']!)),
      GoRoute(path: '/booking/flow/court/:courtId', builder: (_, state) =>
          BookingDateScreen(courtId: state.pathParameters['courtId']!)),
      GoRoute(path: '/review/create/:bookingId', builder: (_, state) =>
          SubmitReviewScreen(bookingId: state.pathParameters['bookingId']!)),
      GoRoute(path: '/assessment/:id', builder: (_, state) =>
          AssessmentDetailScreen(id: state.pathParameters['id']!)),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
}
```

### 6.2 RoleShell Widget

One shell widget handles all roles, configured by the `UserRole` enum:

```dart
class RoleShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final UserRole role;

  const RoleShell({required this.navigationShell, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: _destinations(role),
      ),
    );
  }

  List<NavigationDestination> _destinations(UserRole role) => switch (role) {
    UserRole.player => [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
      NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Bookings'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
    UserRole.coach => [
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      NavigationDestination(icon: Icon(Icons.schedule_outlined), selectedIcon: Icon(Icons.schedule), label: 'Schedule'),
      NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Students'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
    UserRole.organizer => [
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Sessions'),
      NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Community'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
  };
}
```

---

## 7. DESIGN SYSTEM INTEGRATION

The theme layer maps directly from `DESIGN_SYSTEM.md` sections to Dart files.

### 7.1 Theme Setup in App

```dart
// app.dart

class HyperArenaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: 'HyperArena',
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light(),         // from app_theme.dart
      darkTheme: AppTheme.dark(),      // from app_theme_dark.dart
      themeMode: ThemeMode.system,     // respects system preference
      locale: const Locale('id'),      // Indonesian default
      supportedLocales: const [Locale('id'), Locale('en')],
      routerConfig: router,
    );
  }
}
```

### 7.2 Design System Token Access

```dart
// In any widget:

// Colors (Section 1)
Container(color: AppColors.primary)
Container(color: AppColors.sportColor(Sport.tennis))
Container(color: AppColors.bookingStatusColor(BookingStatus.confirmed))

// Typography (Section 2)
Text('Hello', style: AppTypography.headingLarge)
Text('Rp 150.000', style: AppTypography.price)

// Spacing (Section 3)
Padding(padding: EdgeInsets.all(AppDimensions.base))        // 16px
SizedBox(height: AppDimensions.md)                           // 12px
BorderRadius.circular(AppDimensions.radiusMd)                // 12px

// Shadows (Section 4)
Container(decoration: BoxDecoration(boxShadow: AppShadows.sm))

// Animations (Section 5)
AnimatedContainer(duration: AppAnimations.fast, curve: AppAnimations.standard)

// Component styles (Section 7)
Container(decoration: AppComponentStyles.venueCard())
Container(decoration: AppComponentStyles.statusBadge(BookingStatus.confirmed))

// Theme extensions (Section 8)
final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
final color = sportTheme.color(Sport.tennis);
```

### 7.3 Reduced Motion (Section 5.1 + Section 11)

```dart
// core/utils/helpers.dart

Duration animationDuration(BuildContext context, Duration normal) {
  return MediaQuery.of(context).disableAnimations
      ? Duration.zero
      : normal;
}

Curve animationCurve(BuildContext context, Curve normal) {
  return MediaQuery.of(context).disableAnimations
      ? Curves.easeInOut
      : normal;
}
```

---

## 8. BUILD ORDER

### Phase 0: Foundation
- Flutter project init (`flutter create`)
- `pubspec.yaml` dependencies
- `core/config/` — environment config + entry points
- `core/theme/` — all design system tokens as Dart files
- `core/widgets/` — AppButton, AppTextField, ShimmerLoading, EmptyState
- `core/mocks/` — mock data for all features
- `shared/models/enums.dart`
- `routing/app_router.dart` — Player shell only
- **Deliverable:** App launches with mock theme, empty Player shell navigates

### Phase 1: Auth + Venue + Booking (Player core)
- `features/auth/` — splash, onboarding, login, register, sport selection
- `features/venue/` — list, filter, detail
- `features/booking/` — full court booking wizard + booking list/detail
- **Deliverable:** Player can browse venues, book a court, see booking status

### Phase 2: Coach (Player views + Coach role)
- `features/coach/` — browse, detail, coaching booking
- Coach shell + dashboard, schedule, students, assessment form
- **Deliverable:** Player can book coaching. Coach can manage schedule + assess

### Phase 3: Session (Player views + Organizer role)
- `features/session/` — browse, detail, join flow
- Organizer shell + create session, participant management, community
- **Deliverable:** Player can join sessions. Organizer can create + manage

### Phase 4: Review + Gamification + Notification
- `features/review/` — submit + view reviews
- `features/gamification/` — XP bar, badges, achievements
- `features/profile/` — career dashboard with radar chart
- `features/notification/` — notification center
- **Deliverable:** Full Player experience complete

### Phase 5: API Integration (environment switch)
- Swap `main_mock.dart` → `main_local.dart`
- Implement `ApiXxxRepository` classes
- Test against local Laravel
- **Deliverable:** App works with real backend

---

## 9. CONVENTIONS

### 9.1 Naming

| Type | Convention | Example |
|------|-----------|---------|
| Files | snake_case | `venue_list_provider.dart` |
| Classes | PascalCase | `VenueListScreen` |
| Providers | camelCase | `venueListProvider` |
| Enums | PascalCase.camelCase | `BookingStatus.pendingPayment` |
| Constants | camelCase | `AppDimensions.base` |
| Routes | kebab-case in path | `/player/home`, `/venue/:id` |

### 9.2 Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports (core → shared → feature)
import 'package:hyperarena/core/theme/theme.dart';
import 'package:hyperarena/shared/models/enums.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
```

### 9.3 Feature Rules

1. A feature **never imports from another feature's `data/` or `providers/`**
2. Cross-feature data goes through `shared/`
3. Screens use `ConsumerWidget` or `ConsumerStatefulWidget`
4. All async UI uses `.when(loading:, error:, data:)` — no manual if-checks
5. Mock repositories simulate realistic delays (500ms default)
6. Every screen has 3 states: loading (shimmer), error (retry), empty (CTA)

### 9.4 Code Generation

After modifying any Freezed model or Riverpod provider:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or keep it running during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 10. DEPENDENCIES

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management + DI
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^14.0.0

  # Networking
  dio: ^5.4.0

  # Models
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0

  # Local Storage
  shared_preferences: ^2.2.0

  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.0
  fl_chart: ^0.68.0
  shimmer: ^3.0.0

  # Media
  image_picker: ^1.0.0

  # Maps
  google_maps_flutter: ^2.6.0

  # Firebase (added when needed, not in mock phase)
  # firebase_core: ^2.27.0
  # firebase_messaging: ^14.7.0
  # firebase_auth: ^4.17.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0

  # Linting
  flutter_lints: ^4.0.0
```

---

*Document Version: 1.0*
*Architecture: Riverpod + Feature-First + go_router*
*Environment: Mock → Local → Dev → Production*
*Design System: DESIGN_SYSTEM.md v1.0*
