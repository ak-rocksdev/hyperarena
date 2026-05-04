<p align="center">
  <img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" width="120" alt="HyperArena Logo"/>
</p>

<h1 align="center">HyperArena</h1>

<p align="center">
  <strong>All-in-one sports booking & community platform</strong><br/>
  Book courts, find coaches, join sessions, track your progress — all in one app.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/Status-Beta-orange" alt="Beta"/>
</p>

---

## About

HyperArena connects **players**, **coaches**, **organizers**, and **venue owners** in one sports ecosystem. Built for the Indonesian recreational sports community where court bookings, coaching, and group sessions are currently scattered across WhatsApp groups and Instagram DMs.

### Supported Sports

| | Sport |
|---|---|
| :tennis: | Tennis |
| :ping_pong: | Padel |
| :badminton: | Badminton |
| :soccer: | Futsal |
| :basketball: | Basketball |
| :volleyball: | Volleyball |
| :table_tennis_paddle_and_ball: | Table Tennis |

---

## Key Features

### For Players
- **Court Booking** — Browse venues, pick a date, select time slots, and book instantly
- **Coach Discovery** — Find certified coaches, view packages, book private or group sessions
- **Join Open Sessions** — Jump into community sessions organized by local hosts
- **Career Tracking** — View your skill assessments, radar charts, and progress over time
- **Gamification** — Earn XP, level up through tiers (Rookie to Pro), maintain streaks

### For Coaches
- **Dashboard** — At-a-glance stats, upcoming schedules, and recent assessments
- **Student Management** — Track all students, write assessments with skill radar charts
- **Booking Management** — Accept coaching requests, manage your schedule

### For Organizers
- **Club Management** — Create and manage your sports club with member profiles
- **Session Hosting** — Create open sessions, manage participants
- **Rich Member Cards** — See member tiers, activity status, streaks, and roles at a glance

### General
- **Multi-role Support** — Switch between Player, Coach, and Organizer roles
- **Review System** — Rate venues and coaches with detailed star ratings
- **Dark Mode Ready** — Full dark theme support baked into the design system
- **Bilingual** — Indonesian and English, with Rupiah currency formatting

---

## Architecture

| Layer | Technology |
|---|---|
| Framework | Flutter 3.38 |
| State Management | Riverpod |
| Routing | go_router |
| Models | Freezed + json_serializable |
| Structure | Feature-first modular architecture |

The app uses a **repository abstraction pattern** — all data flows through abstract repositories. The runtime is always-online (talks to the production VPS by default); mock repositories live in the codebase for unit-test overrides only.

---

## Getting Started

### Prerequisites

- Flutter SDK 3.38+
- Android Studio or VS Code with Flutter extensions
- An Android device or emulator

### Run the App

```bash
# Get dependencies
flutter pub get

# Run against production VPS (default — flagless `flutter run` also works)
./scripts/run-production.sh   # Linux/macOS
./scripts/run-production.ps1  # Windows PowerShell

# Run against local Laravel backend
./scripts/run-local.sh
./scripts/run-local.ps1

# Build release APK
./scripts/build-production.sh
```

VS Code users: pick **"Flutter (local)"** or **"Flutter (production)"** from the Run and Debug panel.

> Environment selection is compile-time via `--dart-define`. See [docs/flutter-environment.md](docs/flutter-environment.md) for the full env table, "adding a new variable" recipe, and troubleshooting. For local-backend setup (Laragon, LAN IP, firewall), see [docs/local-dev-setup.md](docs/local-dev-setup.md).

---

## Project Structure

```
lib/
  core/           # Shared theme, widgets, utils, mocks
  features/       # Feature modules
    auth/         # Login, register, sport selection
    booking/      # Court booking flow
    coach/        # Coach dashboard, assessments, students
    home/         # Player home & explore
    organizer/    # Club management, sessions
    profile/      # User profile, career tracking
    review/       # Venue & coach reviews
    session/      # Open session details
    venue/        # Venue browsing & details
  router/         # App routing configuration
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
| Phase 5 | Backend API integration | Planned |
| Phase 6 | Payment integration (QRIS, bank transfer) | Planned |

---

## License

This project is proprietary software. All rights reserved.
