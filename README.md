<p align="center">
  <img src="assets/brand/hyperarena_logo.png" width="160" alt="HyperArena Logo"/>
</p>

<h1 align="center">HyperArena</h1>

<p align="center">
  <strong>All-in-one sports booking & coaching platform</strong><br/>
  Book courts, find coaches, run sessions, track progress — multi-tenant SaaS for Indonesian & Malaysian sports communities.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.10-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/Status-Beta-orange" alt="Beta"/>
  <img src="https://img.shields.io/badge/Backend-Laravel%2012-FF2D20?logo=laravel" alt="Laravel 12"/>
</p>

---

## About

HyperArena connects **players**, **coaches**, **organizers**, and **venue owners** in one sports ecosystem. Built for the Indonesian and Malaysian recreational sports community where court bookings, coaching, and group sessions are currently scattered across WhatsApp groups and Instagram DMs.

The Flutter mobile app is paired with a Laravel multi-tenant backend (each pilot school is a tenant) and deployed against two environments: `devapp.hyperscore.cloud` for testing and `api.hyperarena.hyperscore.cloud` for production.

### Supported Sports

| | Sport |
|---|---|
| 🎾 | Tennis |
| 🏓 | Padel |
| 🏸 | Badminton |
| ⚽ | Futsal |
| 🏀 | Basketball |
| 🏐 | Volleyball |
| 🏓 | Table Tennis |

---

## Key Features

### For Players / Members
- **Court Booking** — Browse venues, pick a date, select time slots, and book instantly
- **Coach Discovery** — Find certified coaches via marketplace, view rates, book sessions
- **Join Open Sessions** — Jump into community sessions organized by local hosts
- **Career Tracking** — View skill assessments, radar charts, and progress over time
- **Gamification** — Earn XP, level up through tiers, maintain streaks
- **Payment** — Manual transfer + Xendit Virtual Account flows

### For Coaches
- **Command-Center Dashboard** — Operational → performance → student layers in one scroll: today's schedule, action items (unmarked attendance, ungraded assessments, students needing attention), performance metrics (earnings, sessions, active students), recent assessments, attention list, sport breakdown
- **Role Pill** — "MODE COACH" indicator with tap-to-switch when multi-role
- **Student Roster** — Searchable + filterable list; "Belum Dinilai" chip filter pulls ungraded students
- **Assessment Flow** — Per-session grading panel with skill scoring, enrollment requirements, recommendations
- **Enrollment Management** — Enroll students into programs/levels directly from the student detail screen
- **Role-Aware Notifications** — Inbox filtered by active role: coach mode sees coach + global notifs only (assignment, schedule changes, assessment reminders); switching to organizer mode swaps the view

### For Organizers (Tenant Admins)
- **Club Management** — Create and manage your sports club, member profiles, sessions
- **Session Hosting** — Schedule sessions, assign coaches (triggers in-app + push notification to assigned coach), manage participants
- **Earnings Dashboard** — Per-coach payout visibility, batch approval workflow
- **Rich Member Cards** — Member tiers, activity status, streaks, roles at a glance

### For Venue Owners
- **Booking Queue** — Confirm, settle, or reject incoming bookings from one inbox
- **Venue Management** — Add courts, set rates, manage availability per venue

### Cross-cutting
- **Multi-tenant Marketplace** — Browse sessions, coaches, and venues across tenants from one app
- **Multi-role Switching** — One user can be Coach + Member + Admin; switch contexts via profile, with inbox + dashboard auto-refreshing per active role
- **FCM Push Notifications** — Operational + performance triggers with deep-link routing to relevant screens
- **Review System** — Rate venues and coaches with detailed star ratings (coach-side review visibility is intentionally gated per design rule)
- **Multi-currency** — Tenant-aware Rupiah (IDR) and Ringgit (MYR) formatting; cents-vs-rupiah unit handled centrally via `Formatters.formatCurrency`

---

## Architecture

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.10 |
| State Management | Riverpod (composition API) |
| Routing | go_router |
| Networking | Dio + tenant subdomain resolution |
| Models | Freezed 2.5 + json_serializable |
| Push | Firebase Messaging (FCM) + flutter_local_notifications |
| Storage | shared_preferences + flutter_secure_storage |
| Charts | fl_chart |
| Structure | Feature-first modular architecture |

### Patterns

- **Repository abstraction** — Data flows through abstract repos; the runtime swaps mock vs API implementations via `Provider.overrideWith` (mock for tests, API in production binding)
- **Section-result partial failure** — Dashboard aggregates wrap each sub-fetch in `SectionResult<T>` so a single failure doesn't blank the screen
- **Role-aware filtering** — Backend tags every notification with `target_role`; the `/v1/notifications` endpoint filters by user's active role server-side
- **Tenant-time formatting** — Backend serializes timestamps in tenant timezone offset; FE renders as-is

---

## Getting Started

### Prerequisites

- Flutter SDK 3.10+ (Dart 3.10+)
- Android Studio or VS Code with Flutter extensions
- An Android device or emulator
- (For local backend) Laragon + PHP 8.2 + Laravel 12 backend running at `C:\laragon\www\hypercoach`

### Run the App

```bash
# Install dependencies
flutter pub get

# Run against the dev VPS (devapp.hyperscore.cloud) — RECOMMENDED for daily dev
flutter run --target=lib/main_dev.dart \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana

# Run against production VPS (api.hyperarena.hyperscore.cloud)
./scripts/run-production.sh    # Linux/macOS
./scripts/run-production.ps1   # Windows PowerShell

# Run against local Laravel backend (Laragon on LAN IP)
./scripts/run-local.sh
./scripts/run-local.ps1

# Build release APK against dev env
flutter build apk --release --target=lib/main_dev.dart \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana

# Build release APK against production
./scripts/build-production.sh
```

VS Code users: pick **"Flutter (local)"** or **"Flutter (production)"** from the Run and Debug panel.

> Environment selection is compile-time via `--dart-define`. See [docs/flutter-environment.md](docs/flutter-environment.md) for the full env table. For local-backend setup (Laragon, LAN IP, firewall), see [docs/local-dev-setup.md](docs/local-dev-setup.md). Built APKs land in `build/app/outputs/flutter-apk/`; the convention for naming + archiving release builds is in [releases/README.md](releases/README.md).

---

## Testing

```bash
# Run the full test suite
flutter test

# Run a specific feature's tests
flutter test test/features/coach/

# Run a single file
flutter test test/features/coach/presentation/widgets/dashboard/coach_role_pill_test.dart
```

Tests use `flutter_test` + `flutter_riverpod`'s `ProviderScope.overrides` for repository mocking. Widget tests cover render + interaction; provider tests cover state + partial-failure semantics.

---

## Project Structure

```
lib/
  core/                     # Shared theme, widgets, utils, network, storage
    network/                # Dio client, error handling
    theme/                  # App colors, dimensions, typography, surfaces
    utils/                  # Formatters, SectionResult, gamification helpers
    widgets/                # AppLoader, EmptyState, AsyncValueWidget, ShimmerLoading
  features/                 # Feature modules
    auth/                   # Login, register, role switching
    booking/                # Court booking flow + status
    coach/                  # Coach dashboard, schedule, students, assessments, enrollment
      data/                 # Models, repositories (mock + API)
      providers/            # Riverpod providers
      presentation/         # Screens + widgets (including dashboard/* widgets)
    club/                   # Club summary, coach student roster, student detail
    home/                   # Player home & explore
    notification/           # In-app inbox, FCM push handling, route resolver
    organizer/              # Club management, sessions, earnings
    profile/                # User profile, career tracking
    payment/                # Manual transfer + Xendit VA flows
    review/                 # Venue & coach reviews
    session/                # Open session details + share booking
    venue/                  # Venue browsing & details
  routing/                  # GoRouter config, AppRoutes, RoleShell
  shared/                   # Cross-feature widgets + providers
docs/
  superpowers/specs/        # Design specs (one per feature)
  superpowers/plans/        # Implementation plans
releases/                   # Build artifacts (gitignored, naming convention in releases/README.md)
```

---

## Development Phases

| Phase | Description | Status |
|---|---|---|
| Phase 0 | Foundation — splash, auth, booking flow, explore | Done |
| Phase 1 | UI polish — animations, depth, onboarding | Done |
| Phase 2 | Coach role — dashboard, booking, assessments | Done |
| Phase 3 | Organizer — club management, sessions, dashboard | Done |
| Phase 4 | Reviews, gamification, career tracking | Done |
| Phase 4.1 | Venue reviews, search/filter, UI polish | Done |
| Phase 5 | Backend API integration | Done (mock→API flip shipped) |
| Phase 5.1 | Coach dashboard real-data integration + filter chips + enrollment CTA | Done |
| Phase 5.2 | Role-aware notifications + 3 coach notification types | Done |
| Phase 6 | Payment integration (manual transfer + Xendit VA) | Done |
| Phase 7 | Wallet/Earnings + per-session payout notifications | Planned |
| Phase 8 | i18n (currently Indonesian-only on mobile; BE supports id/en/ms) | Planned |

---

## Environments

| Env | API Base URL | Default Tenant | Notes |
|---|---|---|---|
| `production` | `api.hyperarena.hyperscore.cloud/api` | `petenis-kelana` | Live users. Build via `scripts/build-production.*`. |
| `dev` | `devapp.hyperscore.cloud/api` | `petenis-kelana` | Internal testing. Green "DEV" ribbon on every screen. |
| `local` | `http://<LAN_IP>:8080/api` | varies | Laragon at `C:\laragon\www\hypercoach`. Use `main_local.dart` flavor. |

See [releases/README.md](releases/README.md) for the env matrix and APK naming convention.

---

## License

This project is proprietary software. All rights reserved.
