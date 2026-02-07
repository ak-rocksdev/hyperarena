# SportHub — MVP Flutter Specification

## For AI-Assisted Development (Claude Code)

> **Purpose:** Dokumen ini berisi spesifikasi MVP yang actionable untuk development Flutter app. Mencakup screen map, data models, API contracts, booking flows, dan development phases.
>
> **Reference:** Lihat `FULL_CONTEXT_SPORTS_PLATFORM.md` untuk konteks bisnis lengkap.

---

## 1. MVP SCOPE DEFINITION

### 1.1 What's IN (Phase 1)

- [x] Multi-role auth (Player, Court Owner, Coach, Organizer — single app)
- [x] Venue & Court browsing, search, filter
- [x] Court booking with QRIS/Bank Transfer payment
- [x] Coach browsing, search, filter
- [x] Coaching session booking
- [x] Organizer: create & manage Open Sessions
- [x] Player join Open Sessions
- [x] Payment flow: upload bukti bayar, manual confirmation
- [x] Two-way rating & review
- [x] Coach → Player assessment (rapor / career tracking)
- [x] Player career dashboard (radar chart, progress)
- [x] Basic gamification: XP, level tiers, badges
- [x] Booking management (all roles)
- [x] Push notifications
- [x] Admin web panel (basic)

### 1.2 What's OUT (Phase 2+)

- [ ] Smart matchmaking
- [ ] Community & social feed
- [ ] Mini tournament system
- [ ] In-app wallet / top-up
- [ ] Split payment
- [ ] Streak system & seasonal challenges
- [ ] Recurring booking
- [ ] In-app chat (use WhatsApp redirect for MVP)
- [ ] Premium player membership
- [ ] Coach video analysis
- [ ] AI dynamic pricing

---

## 2. TECH STACK

```yaml
mobile:
  framework: Flutter (Android + iOS)
  state_management: flutter_bloc (BLoC pattern)  # or riverpod
  navigation: go_router
  http: dio
  local_storage: shared_preferences + hive
  maps: google_maps_flutter
  image_picker: image_picker
  charts: fl_chart  # for radar chart & progress chart
  notifications: firebase_messaging
  auth: firebase_auth (social login) + API token (Sanctum)
  image_cache: cached_network_image
  forms: flutter_form_builder

backend:
  framework: Laravel 11
  auth: Laravel Sanctum (API tokens)
  database: MySQL 8
  storage: S3-compatible (DigitalOcean Spaces / AWS S3)
  push_notifications: Firebase Cloud Messaging via Laravel
  search: Laravel Scout + Meilisearch
  cache: Redis
  api_format: JSON REST API
  documentation: Swagger / Scramble

admin_web:
  framework: Vue.js 3 + Inertia.js (within Laravel)
  ui: Metronic or Tailwind-based admin template
```

---

## 3. DATA MODELS

### 3.1 Users & Auth

```
users
├── id (ULID)
├── name
├── email (unique)
├── phone (unique, nullable)
├── password (hashed)
├── avatar_url (nullable)
├── role: enum [player, court_owner, coach, organizer, admin]
├── is_verified: boolean
├── is_active: boolean
├── firebase_uid (nullable, for social login)
├── fcm_token (nullable, for push notifications)
├── created_at
└── updated_at
```

> Note: Satu user = satu role di MVP. Multi-role (misal seseorang yang jadi player sekaligus organizer) bisa dihandle via role switching di Phase 2, atau dengan mendaftar dua akun.

### 3.2 Player Profile

```
player_profiles
├── id
├── user_id (FK → users)
├── bio (nullable)
├── date_of_birth (nullable)
├── gender: enum [male, female, other] (nullable)
├── city
├── sports: JSON array ["tennis", "padel", "badminton"]
├── self_assessed_levels: JSON {"tennis": "intermediate", "badminton": "beginner"}
├── total_xp: integer (default 0)
├── level_tier: enum [rookie, amateur, intermediate, advanced, pro]
├── profile_completion_pct: integer (0-100)
├── created_at
└── updated_at
```

### 3.3 Venue & Courts

```
venues
├── id
├── owner_id (FK → users, where role = court_owner)
├── name
├── description
├── address
├── city
├── latitude
├── longitude
├── phone
├── whatsapp_number (nullable)
├── facilities: JSON array ["parking", "shower", "wifi", "canteen", "locker"]
├── photos: JSON array of URLs
├── subscription_tier: enum [free, pro, business]
├── is_verified: boolean
├── is_active: boolean
├── avg_rating: decimal (computed, cached)
├── total_reviews: integer (computed, cached)
├── created_at
└── updated_at

courts
├── id
├── venue_id (FK → venues)
├── name (e.g., "Court A", "Lapangan 1")
├── sport_type: enum [tennis, padel, badminton, futsal, basketball, volleyball, table_tennis, other]
├── surface_type: enum [hard_court, clay, grass, synthetic, wood, rubber, concrete, other] (nullable)
├── environment: enum [indoor, outdoor, covered]
├── description (nullable)
├── photos: JSON array of URLs
├── is_active: boolean
├── created_at
└── updated_at

court_schedules (available slots)
├── id
├── court_id (FK → courts)
├── day_of_week: integer (0=Monday, 6=Sunday)
├── start_time: time (e.g., "07:00")
├── end_time: time (e.g., "08:00")
├── price: decimal (price per this slot)
├── is_peak: boolean
├── is_available: boolean
├── created_at
└── updated_at
```

### 3.4 Coaches

```
coach_profiles
├── id
├── user_id (FK → users, where role = coach)
├── bio
├── sports: JSON array ["tennis", "padel"]
├── certifications: JSON array [{name, issuer, year, photo_url}]
├── experience_years: integer
├── city
├── photos: JSON array of URLs
├── subscription_tier: enum [free, pro]
├── is_verified: boolean
├── is_active: boolean
├── avg_rating: decimal (computed, cached)
├── total_reviews: integer (computed, cached)
├── total_sessions: integer (computed, cached)
├── created_at
└── updated_at

coach_packages
├── id
├── coach_id (FK → coach_profiles)
├── name (e.g., "Private Session", "Group Coaching")
├── type: enum [private, group, camp]
├── sport_type
├── description
├── duration_minutes: integer
├── max_participants: integer (1 for private)
├── price: decimal (total price, not per person)
├── price_per_person: decimal (nullable, for group)
├── is_active: boolean
├── created_at
└── updated_at

coach_schedules (availability)
├── id
├── coach_id (FK → coach_profiles)
├── day_of_week: integer
├── start_time: time
├── end_time: time
├── is_available: boolean
├── created_at
└── updated_at

coach_venue_affiliations (many-to-many)
├── id
├── coach_id (FK → coach_profiles)
├── venue_id (FK → venues)
├── status: enum [pending, active, inactive]
├── created_at
└── updated_at
```

### 3.5 Organizer

```
organizer_profiles
├── id
├── user_id (FK → users, where role = organizer)
├── bio
├── sports: JSON array
├── city
├── photos: JSON array of URLs
├── subscription_tier: enum [free, pro]
├── is_verified: boolean
├── avg_rating: decimal (computed, cached)
├── total_reviews: integer
├── total_sessions_organized: integer
├── total_followers: integer (cached)
├── created_at
└── updated_at

organizer_followers
├── id
├── organizer_id (FK → organizer_profiles)
├── player_id (FK → player_profiles)
├── created_at
└── (no updated_at, follow is binary)
```

### 3.6 Bookings

```
bookings
├── id (ULID)
├── booking_type: enum [court, coaching, open_session]
├── booking_code: string (human-readable, e.g., "BK-20260215-XXXX")
├── player_id (FK → users)
├── venue_id (FK → venues, nullable)
├── court_id (FK → courts, nullable)
├── coach_id (FK → coach_profiles, nullable)
├── open_session_id (FK → open_sessions, nullable)
├── booking_date: date
├── start_time: time
├── end_time: time
├── total_amount: decimal
├── status: enum [pending_payment, waiting_confirmation, confirmed, rejected, cancelled, completed, expired]
├── payment_method: enum [qris, bank_transfer]
├── payment_proof_url: string (nullable)
├── payment_confirmed_at: datetime (nullable)
├── payment_confirmed_by: FK → users (nullable)
├── rejection_reason: string (nullable)
├── cancelled_at: datetime (nullable)
├── cancelled_by: enum [player, owner, coach, organizer, system] (nullable)
├── cancellation_reason: string (nullable)
├── notes: text (nullable)
├── expires_at: datetime (1 hour after creation if no payment proof)
├── created_at
└── updated_at
```

### 3.7 Open Sessions (Organizer Feature)

```
open_sessions
├── id
├── organizer_id (FK → organizer_profiles)
├── title (e.g., "Tennis Group Coaching — Intermediate")
├── description
├── sport_type
├── target_level: enum [beginner, intermediate, advanced, all]
├── venue_id (FK → venues, nullable — bisa manual input)
├── court_id (FK → courts, nullable)
├── venue_name_manual: string (nullable, jika venue belum di app)
├── venue_address_manual: string (nullable)
├── coach_id (FK → coach_profiles, nullable — bisa manual)
├── coach_name_manual: string (nullable, jika coach belum di app)
├── session_date: date
├── start_time: time
├── end_time: time
├── price_per_person: decimal
├── min_participants: integer
├── max_participants: integer
├── join_deadline: datetime
├── pricing_model: enum [margin, transparent]
├── cost_breakdown: JSON (nullable, for transparent model)
│   e.g., {"court_cost": 300000, "coach_cost": 750000, "organizing_fee_per_person": 45000}
├── visibility: enum [public, followers_only]
├── status: enum [open, full, confirmed, cancelled, completed]
├── photos: JSON array (nullable)
├── created_at
└── updated_at

open_session_participants
├── id
├── open_session_id (FK → open_sessions)
├── player_id (FK → users)
├── booking_id (FK → bookings)
├── status: enum [joined, waitlisted, confirmed, cancelled]
├── joined_at: datetime
└── updated_at
```

### 3.8 Payment Information

```
payment_methods (per merchant: venue owner, coach, organizer)
├── id
├── user_id (FK → users)
├── type: enum [qris, bank_transfer]
├── bank_name: string (nullable, for bank_transfer)
├── account_number: string (nullable, for bank_transfer)
├── account_holder_name: string (nullable, for bank_transfer)
├── qris_image_url: string (nullable, for qris)
├── is_primary: boolean
├── is_active: boolean
├── created_at
└── updated_at
```

### 3.9 Reviews & Ratings

```
reviews
├── id
├── booking_id (FK → bookings)
├── reviewer_id (FK → users)
├── reviewee_type: enum [coach, venue, organizer]
├── reviewee_id: integer (polymorphic: coach_profile.id, venue.id, or organizer_profile.id)
├── overall_rating: decimal (1.0 - 5.0)
├── structured_ratings: JSON
│   Coach example: {"punctuality": 5, "communication": 4, "technical_knowledge": 5, "motivation": 4, "value_for_money": 3}
│   Venue example: {"cleanliness": 4, "court_condition": 5, "facilities": 3, "staff": 4, "value_for_money": 4}
│   Organizer example: {"organization": 5, "communication": 4, "value_for_money": 4, "session_quality": 5}
├── comment: text (nullable)
├── is_published: boolean (default true, can be moderated)
├── created_at
└── updated_at
```

### 3.10 Coach Assessments (Player Rapor)

```
sport_assessment_templates
├── id
├── sport_type: enum
├── skills: JSON array
│   Tennis: ["forehand", "backhand", "serve", "volley", "footwork", "game_strategy", "mental_game"]
│   Badminton: ["smash", "drop_shot", "net_play", "footwork", "service", "defense_lift", "game_strategy", "stamina"]
├── created_at
└── updated_at

player_assessments
├── id
├── booking_id (FK → bookings)
├── coach_id (FK → coach_profiles)
├── player_id (FK → users)
├── sport_type
├── skill_ratings: JSON {"forehand": 8, "backhand": 6, "serve": 5, ...}
├── overall_notes: text (nullable)
├── focus_areas: JSON array ["serve", "footwork"]
├── assessed_at: datetime
├── created_at
└── updated_at
```

### 3.11 Gamification

```
xp_transactions
├── id
├── player_id (FK → player_profiles)
├── amount: integer (XP earned)
├── activity_type: enum [booking_completed, coaching_completed, open_session_completed, review_submitted, first_booking, profile_completed, new_sport_tried]
├── reference_id: integer (nullable, polymorphic reference)
├── description: string
├── created_at

badges
├── id
├── code: string (unique, e.g., "first_rally", "dedicated_learner")
├── name: string
├── description: string
├── icon_url: string
├── condition_type: string (untuk logic check)
├── condition_value: integer
├── sport_type: enum (nullable, null = all sports)
├── is_active: boolean
├── created_at
└── updated_at

player_badges
├── id
├── player_id (FK → player_profiles)
├── badge_id (FK → badges)
├── earned_at: datetime
├── created_at

level_tiers (config table)
├── id
├── name: string (e.g., "Rookie", "Amateur")
├── code: enum [rookie, amateur, intermediate, advanced, pro]
├── min_xp: integer
├── max_xp: integer (nullable for top tier)
├── badge_color: string
├── icon_url: string
```

### 3.12 Notifications

```
notifications
├── id
├── user_id (FK → users)
├── type: enum [booking_created, payment_uploaded, payment_confirmed, payment_rejected, booking_cancelled, booking_reminder, session_reminder, review_request, badge_earned, level_up, open_session_invite, participant_joined]
├── title: string
├── body: string
├── data: JSON (additional payload for deep linking)
├── is_read: boolean (default false)
├── read_at: datetime (nullable)
├── created_at
└── updated_at
```

---

## 4. SCREEN MAP & NAVIGATION

### 4.1 Player App Screens

```
/splash
/onboarding (3 slides: Book Courts, Find Coach, Track Progress)
/auth
├── /login (email/phone + password, Google Sign-In, Apple Sign-In)
├── /register
├── /register/sports-selection (multi-select sport interests)
├── /register/level-assessment (self-assess level per sport)
└── /forgot-password

/main (Bottom Navigation Bar — 4 tabs)
├── /home
│   ├── Search bar → /search
│   ├── Sport category chips (horizontal scroll)
│   ├── "Nearby Courts" section → horizontal card scroll
│   ├── "Top Rated Coaches" section → horizontal card scroll
│   ├── "Open Sessions" section → horizontal card scroll
│   ├── "Your Upcoming Booking" card (if any)
│   └── Gamification mini card (Level badge + XP progress bar)
│
├── /explore
│   ├── Tab: Courts | Coaches | Sessions
│   │
│   ├── /explore/courts
│   │   ├── Map view / List view toggle
│   │   ├── Filter sheet (sport, distance, price range, facilities, rating, environment)
│   │   ├── Sort (nearest, cheapest, highest rated)
│   │   ├── Court/Venue card list
│   │   └── → /venue/:id (Venue Detail)
│   │       ├── Photo gallery (swipeable)
│   │       ├── Info section (address, facilities, description)
│   │       ├── Map preview (tap to open maps)
│   │       ├── Court list within this venue
│   │       ├── "Book Now" → /booking/court/:courtId
│   │       ├── Reviews & ratings section
│   │       ├── Affiliated coaches (if any)
│   │       └── WhatsApp button
│   │
│   ├── /explore/coaches
│   │   ├── Filter sheet (sport, price range, rating, level specialty)
│   │   ├── Coach card list
│   │   └── → /coach/:id (Coach Detail)
│   │       ├── Photo + bio + certifications
│   │       ├── Packages offered (card list)
│   │       ├── Available schedule (calendar preview)
│   │       ├── Reviews & ratings section
│   │       ├── "Book Session" → /booking/coaching/:coachId
│   │       └── WhatsApp button
│   │
│   └── /explore/sessions (Open Sessions)
│       ├── Filter sheet (sport, level, date, price range, location)
│       ├── Session card list
│       │   ├── Sport badge
│       │   ├── Title, date, time
│       │   ├── Venue name + distance
│       │   ├── Coach name (if any)
│       │   ├── Price per person
│       │   ├── Participants: "7/10 spots"
│       │   ├── Organizer name + rating
│       │   └── [JOIN] button
│       └── → /session/:id (Session Detail)
│           ├── Full info (description, level, rules)
│           ├── Venue detail card (tap to expand)
│           ├── Coach detail card (tap to expand)
│           ├── Organizer card (with rating + total sessions organized)
│           ├── Participant list (names + levels, limited view)
│           ├── Price breakdown (if transparent pricing)
│           └── "Join Session" → /booking/session/:sessionId
│
├── /bookings
│   ├── Tab: Upcoming | Past
│   │
│   ├── Upcoming bookings list
│   │   ├── Status badge (color-coded)
│   │   │   ├── 🟡 PENDING PAYMENT
│   │   │   ├── 🟠 WAITING CONFIRMATION
│   │   │   ├── 🟢 CONFIRMED
│   │   │   ├── 🔴 REJECTED
│   │   │   └── ⚫ EXPIRED
│   │   └── → /booking-detail/:id
│   │       ├── Booking info (court/coach/session, date, time)
│   │       ├── Status stepper (visual progress)
│   │       ├── Payment section
│   │       │   ├── QRIS image (full screen, pinch to zoom)
│   │       │   ├── OR bank transfer details (copy-able)
│   │       │   └── "Upload Bukti Bayar" button → camera/gallery picker
│   │       ├── Cancel booking button (with confirmation dialog)
│   │       └── WhatsApp contact button
│   │
│   └── Past bookings list
│       └── → /booking-detail/:id
│           ├── Booking summary
│           ├── "Rate & Review" button (if not yet reviewed)
│           └── "View Assessment" button (if coach has submitted)
│
└── /profile
    ├── Profile header (avatar, name, sport badges, level badge + XP bar)
    ├── Quick stats (total sessions, total hours, sports played)
    │
    ├── 🏆 Achievements → /profile/achievements
    │   ├── Badges grid (earned = full color, locked = grayscale)
    │   ├── Badge detail (tap): name, description, how to earn, date earned
    │   └── Level progress section
    │
    ├── 📊 Career / Rapor → /profile/career
    │   ├── Sport selector tabs (Tennis | Badminton | etc.)
    │   ├── Radar chart (latest assessment snapshot)
    │   ├── Progress over time (line chart per skill)
    │   ├── Assessment history list
    │   │   └── → /assessment/:id (detail: coach name, date, all ratings, notes, focus areas)
    │   └── "No assessments yet" state (with CTA to book coaching)
    │
    ├── ⭐ My Reviews → /profile/reviews
    │   └── List of reviews I've given
    │
    ├── ⚙️ Settings → /profile/settings
    │   ├── Edit profile (name, avatar, bio, sports, levels)
    │   ├── Notification preferences (toggles)
    │   ├── Change password
    │   ├── Language
    │   └── Logout
    │
    └── ℹ️ Help & Support
```

### 4.2 Court Owner Screens

```
/owner (Bottom Navigation Bar — 4 tabs)
├── /owner/dashboard
│   ├── Today's bookings count
│   ├── Pending confirmations (alert badge, tappable → filter to pending)
│   ├── Revenue cards: Today | This Week | This Month
│   ├── Occupancy rate donut chart
│   └── Recent booking activity list
│
├── /owner/bookings
│   ├── Calendar strip (horizontal date picker)
│   ├── Court filter chips
│   ├── Booking cards with status badges
│   └── → /owner/booking-detail/:id
│       ├── Player info (name, phone, level)
│       ├── Court & time info
│       ├── Payment proof image (zoomable)
│       ├── [CONFIRM] / [REJECT] buttons
│       │   └── Reject requires reason input
│       └── WhatsApp player button
│
├── /owner/venues
│   ├── Venue list (if multiple)
│   └── → /owner/venue/:id
│       ├── Edit venue info (name, description, address, photos)
│       ├── Courts list
│       │   └── → /owner/court/:id
│       │       ├── Edit court info (name, sport, surface, environment, photos)
│       │       ├── Schedule management
│       │       │   ├── Day-of-week tabs
│       │       │   ├── Time slot grid (toggle available/unavailable)
│       │       │   └── Set price per slot (regular/peak)
│       │       └── View court-specific bookings
│       ├── Payment settings → /owner/payment-settings
│       │   ├── QRIS: upload/replace image
│       │   ├── Bank Transfer: input bank name, account number, holder name
│       │   └── Set primary method
│       └── View ratings & reviews
│
└── /owner/profile
    ├── Business profile
    ├── Subscription tier info + upgrade CTA
    ├── Notification settings
    └── Help & Logout
```

### 4.3 Coach Screens

```
/coach (Bottom Navigation Bar — 4 tabs)
├── /coach/dashboard
│   ├── Today's sessions list
│   ├── Pending confirmations count
│   ├── Monthly earnings card
│   ├── Average rating display
│   └── Quick action: "Set Today's Availability"
│
├── /coach/schedule
│   ├── Calendar view (monthly, with dots on dates with sessions)
│   ├── Day detail: session list for selected date
│   ├── Availability management
│   │   ├── Day-of-week tabs
│   │   └── Time slot toggles (available / unavailable)
│   └── → /coach/booking-detail/:id
│       ├── Player info + level
│       ├── Session info (package, date, time, venue)
│       ├── Payment proof (if direct booking to coach)
│       ├── [CONFIRM] / [REJECT]
│       ├── Status: completed? → "Submit Assessment" button
│       │   └── → /coach/assessment/create/:bookingId
│       │       ├── Player info (read-only)
│       │       ├── Sport auto-selected
│       │       ├── Skill sliders (1-10 per skill, based on sport template)
│       │       ├── Overall notes (text area)
│       │       ├── Focus areas (multi-select chips from skill list)
│       │       └── [Submit Assessment]
│       └── WhatsApp player
│
├── /coach/students
│   ├── Student list (all players who've had sessions)
│   ├── Search & filter
│   └── → /coach/student/:playerId
│       ├── Player profile summary
│       ├── Session history with this player
│       ├── Assessment history (timeline)
│       ├── Progress radar chart
│       └── "New Assessment" button
│
└── /coach/profile
    ├── Edit coach profile (bio, photos, certifications)
    ├── Manage packages → /coach/packages
    │   ├── Package list
    │   ├── Create new package
    │   └── Edit/deactivate package
    ├── Payment settings (QRIS + bank)
    ├── View my ratings & reviews
    ├── Subscription tier + upgrade CTA
    ├── Affiliated venues
    └── Logout
```

### 4.4 Organizer Screens

```
/organizer (Bottom Navigation Bar — 4 tabs)
├── /organizer/dashboard
│   ├── Upcoming sessions summary
│   ├── "X participants pending" alerts
│   ├── Monthly earnings card
│   ├── Quick stats: total sessions, avg participants, avg rating
│   └── [+ Create Session] FAB
│
├── /organizer/sessions
│   ├── Tab: Upcoming | Past
│   ├── Session cards with status + participant count
│   └── → /organizer/session/:id
│       ├── Session info (full detail)
│       ├── Participant management
│       │   ├── Participant list with payment status
│       │   ├── [Confirm] / [Reject] per participant payment
│       │   ├── Waitlist (if full)
│       │   └── "Blast Reminder" button (to unpaid)
│       ├── Session status management
│       │   ├── Cancel session (with reason, notify all)
│       │   └── Mark as completed
│       └── Earnings breakdown
│
│   /organizer/session/create (multi-step form)
│   ├── Step 1: Basic Info
│   │   ├── Title
│   │   ├── Sport type (dropdown)
│   │   ├── Target level (dropdown)
│   │   └── Description
│   ├── Step 2: Venue & Coach
│   │   ├── Search & select venue from app
│   │   │   └── Select specific court
│   │   ├── OR manual input (venue name + address)
│   │   ├── Search & select coach from app
│   │   └── OR manual input (coach name)
│   ├── Step 3: Schedule & Pricing
│   │   ├── Date picker
│   │   ├── Start time & end time
│   │   ├── Price per person
│   │   ├── Min participants
│   │   ├── Max participants
│   │   ├── Join deadline (date + time)
│   │   └── Pricing model toggle: Margin | Transparent
│   │       └── If transparent: input court cost + coach cost + organizing fee
│   ├── Step 4: Settings
│   │   ├── Visibility: Public | Followers Only
│   │   ├── Add photos (optional)
│   │   └── Additional notes
│   └── Step 5: Review & Publish
│       ├── Summary of all inputs
│       └── [Publish Session]
│
├── /organizer/community
│   ├── Followers list
│   ├── Total followers count
│   └── Invite link / share button
│
└── /organizer/profile
    ├── Edit profile (bio, photos)
    ├── Payment settings (QRIS + bank)
    ├── View my ratings & reviews
    ├── Earnings history → /organizer/earnings
    │   ├── Monthly summary chart
    │   └── Per-session breakdown list
    ├── Subscription tier + upgrade CTA
    └── Logout
```

---

## 5. CRITICAL BOOKING FLOWS

### 5.1 Court Booking Flow

```dart
// Step-by-step screen flow:

// 1. VenueDetailScreen
//    Player taps "Book Now" on a specific court
//    → Navigate to BookingDateScreen

// 2. BookingDateScreen
//    - Calendar widget (show next 14 days)
//    - Player selects date
//    → Fetch available slots for that court + date
//    → Navigate to SlotSelectionScreen

// 3. SlotSelectionScreen
//    - Time slot grid (color coded: green=available, gray=booked, blue=selected)
//    - Player taps to select one or more consecutive slots
//    - Show running total at bottom
//    - [Continue] button
//    → Navigate to BookingSummaryScreen

// 4. BookingSummaryScreen
//    - Court info card
//    - Date + time
//    - Duration
//    - Price breakdown
//    - Optional: "Add a Coach?" → opens coach search filtered by sport + time
//    - [Proceed to Payment] button
//    → Create booking (API call, status: pending_payment)
//    → Navigate to PaymentScreen

// 5. PaymentScreen
//    - Tab: QRIS | Bank Transfer (based on what venue has set up)
//    - QRIS tab: show QRIS image (full width, pinch to zoom)
//    - Bank Transfer tab: show bank name, account number (with copy button), account holder
//    - Countdown timer: "Bayar dalam 59:42" (1 hour expiry)
//    - [Saya Sudah Bayar] button
//    → Navigate to UploadProofScreen

// 6. UploadProofScreen
//    - Camera / Gallery picker
//    - Preview uploaded image
//    - [Upload & Submit] button
//    → Upload image to S3
//    → Update booking status: waiting_confirmation
//    → Send push notification to court owner
//    → Navigate to BookingConfirmationScreen

// 7. BookingConfirmationScreen
//    - Success animation
//    - "Menunggu konfirmasi dari pemilik lapangan"
//    - Booking detail summary
//    - "Lihat Booking Saya" button → /bookings
```

### 5.2 Coaching Booking Flow

```dart
// 1. CoachDetailScreen
//    Player taps "Book Session" on a specific package
//    → Navigate to CoachDateScreen

// 2. CoachDateScreen
//    - Calendar widget (only show dates where coach is available)
//    - Player selects date
//    → Fetch available time slots for that coach + date
//    → Navigate to TimeSelectionScreen

// 3. TimeSelectionScreen
//    - Available time slots based on coach schedule + package duration
//    - Player selects time
//    - [Continue]
//    → Navigate to CourtSelectionScreen (optional)

// 4. CourtSelectionScreen (optional step)
//    - "Does the session need a court?"
//    - Option A: "Coach has their own venue" → skip
//    - Option B: "I'll arrange my own court" → skip
//    - Option C: "Help me find a court" → show available courts for this sport + time
//      → Player selects court → adds court fee to total
//    - [Continue] → Navigate to BookingSummaryScreen

// 5. BookingSummaryScreen → PaymentScreen → UploadProofScreen → BookingConfirmationScreen
//    (same as court booking flow from step 4 onwards)
```

### 5.3 Open Session Join Flow

```dart
// 1. SessionDetailScreen
//    Player taps [Join Session]
//    → Check: is session full?
//      → Yes: offer waitlist
//      → No: continue
//    → Check: has join deadline passed?
//      → Yes: show "Registration closed"
//      → No: continue
//    → Navigate to SessionJoinSummaryScreen

// 2. SessionJoinSummaryScreen
//    - Session info (sport, level, date, time, venue, coach)
//    - Organizer info
//    - Price per person
//    - Price breakdown (if transparent pricing)
//    - "Spots remaining: 3/10"
//    - [Join & Pay] button
//    → Create booking (API call, status: pending_payment)
//    → Navigate to PaymentScreen (with organizer's QRIS/bank info)

// 3. PaymentScreen → UploadProofScreen → BookingConfirmationScreen
//    (same flow, but payment goes to organizer's QRIS/bank)
//    → Push notification to organizer
```

---

## 6. API ENDPOINT STRUCTURE

### 6.1 Auth

```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/forgot-password
POST   /api/auth/social-login (Google/Apple → Firebase UID exchange)
GET    /api/auth/me
PUT    /api/auth/update-profile
PUT    /api/auth/update-password
PUT    /api/auth/fcm-token
```

### 6.2 Player

```
GET    /api/player/profile
PUT    /api/player/profile
GET    /api/player/career/:sportType         (assessments + radar chart data)
GET    /api/player/assessments               (list all assessments)
GET    /api/player/assessments/:id           (detail)
GET    /api/player/gamification              (XP, level, badges)
GET    /api/player/badges                    (all badges + earned status)
GET    /api/player/reviews                   (reviews I've submitted)
```

### 6.3 Venues & Courts

```
GET    /api/venues                           (search, filter, paginated)
GET    /api/venues/:id                       (detail)
GET    /api/venues/:id/courts                (courts in this venue)
GET    /api/courts/:id/slots?date=YYYY-MM-DD (available slots for a date)

# Court Owner endpoints
POST   /api/owner/venues                     (create venue)
PUT    /api/owner/venues/:id                 (update venue)
POST   /api/owner/venues/:id/courts          (add court)
PUT    /api/owner/courts/:id                 (update court)
GET    /api/owner/courts/:id/schedules       (get schedule config)
PUT    /api/owner/courts/:id/schedules       (batch update schedule)
GET    /api/owner/dashboard                  (stats)
GET    /api/owner/bookings                   (filtered, paginated)
GET    /api/owner/bookings/:id               (detail)
PUT    /api/owner/bookings/:id/confirm       (confirm payment)
PUT    /api/owner/bookings/:id/reject        (reject with reason)
GET    /api/owner/reviews                    (reviews for my venues)
```

### 6.4 Coaches

```
GET    /api/coaches                          (search, filter, paginated)
GET    /api/coaches/:id                      (detail)
GET    /api/coaches/:id/packages             (available packages)
GET    /api/coaches/:id/slots?date=YYYY-MM-DD (available slots for date)

# Coach endpoints
GET    /api/coach/profile
PUT    /api/coach/profile
GET    /api/coach/schedules
PUT    /api/coach/schedules                  (batch update)
POST   /api/coach/packages                   (create package)
PUT    /api/coach/packages/:id
DELETE /api/coach/packages/:id
GET    /api/coach/dashboard                  (stats)
GET    /api/coach/bookings                   (filtered, paginated)
PUT    /api/coach/bookings/:id/confirm
PUT    /api/coach/bookings/:id/reject
GET    /api/coach/students                   (all students)
GET    /api/coach/students/:playerId         (student detail + history)
POST   /api/coach/assessments                (create assessment for a player)
GET    /api/coach/assessments                (all assessments I've given)
GET    /api/coach/reviews                    (reviews for me)
```

### 6.5 Organizer

```
GET    /api/organizer/profile
PUT    /api/organizer/profile
GET    /api/organizer/dashboard
POST   /api/organizer/sessions               (create open session)
PUT    /api/organizer/sessions/:id           (update)
GET    /api/organizer/sessions               (my sessions, filtered)
GET    /api/organizer/sessions/:id           (detail with participants)
PUT    /api/organizer/sessions/:id/cancel
PUT    /api/organizer/sessions/:id/complete
GET    /api/organizer/sessions/:id/participants
PUT    /api/organizer/participants/:id/confirm
PUT    /api/organizer/participants/:id/reject
GET    /api/organizer/followers
GET    /api/organizer/earnings

# Public
GET    /api/sessions                         (browse open sessions, filtered)
GET    /api/sessions/:id                     (detail)
POST   /api/sessions/:id/join                (player joins)
```

### 6.6 Bookings

```
POST   /api/bookings                         (create booking: court/coaching/session)
GET    /api/bookings                         (my bookings as player, filtered)
GET    /api/bookings/:id                     (detail)
PUT    /api/bookings/:id/upload-proof        (upload payment proof)
PUT    /api/bookings/:id/cancel              (player cancels)
```

### 6.7 Reviews

```
POST   /api/reviews                          (create review)
GET    /api/reviews?reviewee_type=coach&reviewee_id=X (get reviews for entity)
```

### 6.8 Payment Methods

```
GET    /api/payment-methods                  (my payment methods)
POST   /api/payment-methods                  (add method)
PUT    /api/payment-methods/:id              (update)
DELETE /api/payment-methods/:id
```

### 6.9 Notifications

```
GET    /api/notifications                    (paginated)
PUT    /api/notifications/:id/read
PUT    /api/notifications/read-all
GET    /api/notifications/unread-count
```

### 6.10 General / Utility

```
GET    /api/sports                           (list all sports + assessment templates)
GET    /api/config                           (app config: XP rules, level tiers, etc.)
POST   /api/upload                           (general file upload → S3)
```

---

## 7. GAMIFICATION LOGIC (Backend)

```php
// XP award triggers (Laravel Events / Observers):

// BookingObserver → on status change to 'completed':
//   if booking_type == 'court':        award 10 XP
//   if booking_type == 'coaching':     award 25 XP
//   if booking_type == 'open_session': award 20 XP
//   check if first_booking_ever:       award 20 XP bonus
//   check if new_sport_tried:          award 15 XP bonus

// ReviewObserver → on create:          award 5 XP

// PlayerProfileObserver → on profile_completion == 100%: award 15 XP

// After XP awarded:
//   recalculate player level_tier
//   check badge conditions
//   if new badge earned → create player_badge + push notification
//   if level up → push notification
```

---

## 8. NOTIFICATION TRIGGERS

| Event | Recipient | Title | Body |
|---|---|---|---|
| Booking created | Owner/Coach/Organizer | Booking baru | "[Player] booking [court/session] untuk [date] [time]" |
| Payment proof uploaded | Owner/Coach/Organizer | Bukti bayar diterima | "[Player] sudah upload bukti bayar. Silakan konfirmasi." |
| Payment confirmed | Player | Booking dikonfirmasi ✅ | "Booking kamu di [venue] pada [date] [time] sudah dikonfirmasi!" |
| Payment rejected | Player | Booking ditolak ❌ | "Bukti pembayaran kamu ditolak. Alasan: [reason]" |
| Booking cancelled | Relevant parties | Booking dibatalkan | "[Party] membatalkan booking [details]" |
| Booking reminder H-1 | Player | Reminder besok | "Jangan lupa! Kamu ada booking di [venue] besok [time]" |
| Booking reminder H-2jam | Player | Reminder 2 jam lagi | "2 jam lagi kamu main di [venue]! Siap-siap 🎾" |
| Booking expiry warning | Player | Segera bayar | "Booking kamu akan expired dalam 15 menit. Segera upload bukti bayar." |
| Review request | Player | Bagaimana pengalamannya? | "Kasih rating untuk [venue/coach] dari sesi kamu tadi!" |
| Assessment submitted | Player | Rapor baru dari coach | "Coach [name] sudah memberikan assessment untuk sesi [date]" |
| Badge earned | Player | Achievement unlocked! 🏆 | "Selamat! Kamu mendapatkan badge [badge_name]!" |
| Level up | Player | Level Up! | "Kamu naik ke level [tier_name]! Terus semangat! 💪" |
| New open session | Organizer followers | Sesi baru tersedia | "[Organizer] membuka sesi [sport] pada [date]" |
| Participant joined | Organizer | Peserta baru | "[Player] bergabung ke sesi [title]. [X/max] peserta." |
| Session minimum reached | Organizer + Participants | Sesi confirmed | "Minimum peserta tercapai! Sesi [title] pada [date] confirmed." |
| Session cancelled | Participants | Sesi dibatalkan | "Sesi [title] pada [date] dibatalkan oleh organizer. Alasan: [reason]" |

---

## 9. MVP DEVELOPMENT PHASES

### Phase 1A: Core Foundation (Week 1-8)

**Backend:**
- Database migrations (all tables)
- Auth system (register, login, social login, role-based)
- Venue & Court CRUD + search/filter API
- Court schedule & slot management API
- Booking creation + payment flow API
- File upload (S3) for photos, QRIS images, payment proofs
- Push notification service setup

**Flutter:**
- Project setup (folder structure, BLoC setup, routing, theme)
- Auth screens (splash, onboarding, login, register, sport selection)
- Home screen (player)
- Explore → Courts tab (list, filter, venue detail)
- Court booking flow (date → slots → summary → payment → upload proof → confirmation)
- My Bookings screen (upcoming/past, detail, status tracking)
- Court Owner screens (dashboard, bookings, confirm/reject, venue management)
- Profile screen (basic)

### Phase 1B: Coaching + Organizer (Week 9-14)

**Backend:**
- Coach CRUD + search/filter API
- Coach packages, schedule, booking API
- Coach assessment API + sport templates
- Organizer CRUD API
- Open session CRUD + participant management API
- Review & rating API

**Flutter:**
- Explore → Coaches tab (list, filter, coach detail)
- Coaching booking flow
- Coach screens (dashboard, schedule, bookings, assessment form, student list)
- Explore → Sessions tab (list, filter, session detail)
- Open session join flow
- Organizer screens (dashboard, create session, manage participants, community)
- Review & rating submission screens
- Player career dashboard (radar chart, progress, assessment history)

### Phase 1C: Gamification + Polish (Week 15-17)

**Backend:**
- XP transaction system + event listeners
- Badge system + condition checker
- Level tier calculation
- Gamification config API
- Notification triggers for all events

**Flutter:**
- Gamification UI (XP bar, level badge, achievement page)
- Notification center screen
- Push notification handling + deep linking
- Empty states, loading states, error handling
- UI polish, animations, transitions

### Phase 1D: Admin Web Panel (Week 15-17, parallel)

**Web (Vue.js + Inertia):**
- Admin dashboard
- User management (all roles)
- Venue & Coach verification
- Booking monitoring
- Review moderation
- Gamification config (XP rules, badges, levels)
- Sport & assessment template management
- Basic analytics / reports

### Phase 1E: Testing & Launch Prep (Week 18-20)

- Integration testing
- UAT with beta users (5-10 venues, 10-20 coaches, 5 organizers, 50 players)
- Bug fixes
- App Store & Play Store submission
- Launch marketing prep

---

## 10. FLUTTER PROJECT STRUCTURE (Suggested)

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, routing, theme
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── api_endpoints.dart
│   │   └── app_constants.dart        # XP values, level thresholds, etc.
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── formatters.dart           # currency, date, time
│   │   ├── validators.dart
│   │   └── helpers.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_interceptors.dart
│   │   └── api_exceptions.dart
│   └── services/
│       ├── storage_service.dart       # SharedPreferences / Hive
│       ├── notification_service.dart  # FCM setup
│       └── upload_service.dart        # S3 upload
│
├── data/
│   ├── models/                        # Data classes / JSON serializable
│   │   ├── user.dart
│   │   ├── venue.dart
│   │   ├── court.dart
│   │   ├── court_slot.dart
│   │   ├── coach.dart
│   │   ├── coach_package.dart
│   │   ├── organizer.dart
│   │   ├── open_session.dart
│   │   ├── booking.dart
│   │   ├── review.dart
│   │   ├── assessment.dart
│   │   ├── badge.dart
│   │   ├── notification_item.dart
│   │   └── payment_method.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── venue_repository.dart
│       ├── coach_repository.dart
│       ├── organizer_repository.dart
│       ├── booking_repository.dart
│       ├── review_repository.dart
│       ├── gamification_repository.dart
│       └── notification_repository.dart
│
├── blocs/                             # (or providers/ if using Riverpod)
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── venue/
│   ├── coach/
│   ├── organizer/
│   ├── booking/
│   ├── review/
│   ├── gamification/
│   └── notification/
│
├── presentation/
│   ├── common/                        # Shared widgets
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── rating_stars.dart
│   │   │   ├── sport_badge.dart
│   │   │   ├── level_badge.dart
│   │   │   ├── xp_progress_bar.dart
│   │   │   ├── status_badge.dart
│   │   │   ├── booking_card.dart
│   │   │   ├── venue_card.dart
│   │   │   ├── coach_card.dart
│   │   │   ├── session_card.dart
│   │   │   ├── review_card.dart
│   │   │   ├── radar_chart_widget.dart
│   │   │   ├── payment_method_display.dart
│   │   │   ├── qris_display.dart
│   │   │   ├── image_upload_widget.dart
│   │   │   └── empty_state_widget.dart
│   │   └── dialogs/
│   │       ├── confirmation_dialog.dart
│   │       └── filter_bottom_sheet.dart
│   │
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── sport_selection_screen.dart
│   │   └── level_assessment_screen.dart
│   │
│   ├── player/
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── explore/
│   │   │   ├── explore_screen.dart    # tab container
│   │   │   ├── courts_tab.dart
│   │   │   ├── coaches_tab.dart
│   │   │   └── sessions_tab.dart
│   │   ├── venue/
│   │   │   └── venue_detail_screen.dart
│   │   ├── coach/
│   │   │   └── coach_detail_screen.dart
│   │   ├── session/
│   │   │   └── session_detail_screen.dart
│   │   ├── booking/
│   │   │   ├── booking_date_screen.dart
│   │   │   ├── slot_selection_screen.dart
│   │   │   ├── booking_summary_screen.dart
│   │   │   ├── payment_screen.dart
│   │   │   ├── upload_proof_screen.dart
│   │   │   └── booking_confirmation_screen.dart
│   │   ├── my_bookings/
│   │   │   ├── my_bookings_screen.dart
│   │   │   └── booking_detail_screen.dart
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── achievements_screen.dart
│   │   │   ├── career_screen.dart
│   │   │   ├── assessment_detail_screen.dart
│   │   │   ├── my_reviews_screen.dart
│   │   │   └── settings_screen.dart
│   │   └── review/
│   │       └── submit_review_screen.dart
│   │
│   ├── owner/
│   │   ├── owner_dashboard_screen.dart
│   │   ├── owner_bookings_screen.dart
│   │   ├── owner_booking_detail_screen.dart
│   │   ├── venue_management_screen.dart
│   │   ├── court_management_screen.dart
│   │   ├── schedule_management_screen.dart
│   │   ├── payment_settings_screen.dart
│   │   └── owner_profile_screen.dart
│   │
│   ├── coach/
│   │   ├── coach_dashboard_screen.dart
│   │   ├── coach_schedule_screen.dart
│   │   ├── coach_booking_detail_screen.dart
│   │   ├── assessment_form_screen.dart
│   │   ├── students_screen.dart
│   │   ├── student_detail_screen.dart
│   │   ├── coach_packages_screen.dart
│   │   └── coach_profile_screen.dart
│   │
│   ├── organizer/
│   │   ├── organizer_dashboard_screen.dart
│   │   ├── organizer_sessions_screen.dart
│   │   ├── organizer_session_detail_screen.dart
│   │   ├── create_session_screen.dart  # multi-step
│   │   ├── participant_management_screen.dart
│   │   ├── organizer_community_screen.dart
│   │   ├── organizer_earnings_screen.dart
│   │   └── organizer_profile_screen.dart
│   │
│   └── notifications/
│       └── notifications_screen.dart
│
└── routes/
    └── app_router.dart                # go_router configuration
```

---

## 11. KEY UI COMPONENTS REFERENCE

### 11.1 Booking Status Badge Colors
```dart
// status_badge.dart
pending_payment     → Color(0xFFFFC107)  // Amber
waiting_confirmation → Color(0xFFFF9800)  // Orange
confirmed           → Color(0xFF4CAF50)  // Green
rejected            → Color(0xFFF44336)  // Red
cancelled           → Color(0xFF9E9E9E)  // Gray
completed           → Color(0xFF2196F3)  // Blue
expired             → Color(0xFF424242)  // Dark Gray
```

### 11.2 Level Tier Colors
```dart
rookie       → Color(0xFFCD7F32)  // Bronze
amateur      → Color(0xFFC0C0C0)  // Silver
intermediate → Color(0xFFFFD700)  // Gold
advanced     → Color(0xFF4FC3F7)  // Platinum Blue
pro          → Color(0xFFB388FF)  // Diamond Purple
```

### 11.3 Sport Icons (use emoji or custom icons)
```
tennis:       🎾
padel:        🏓 (or custom)
badminton:    🏸
futsal:       ⚽
basketball:   🏀
volleyball:   🏐
table_tennis: 🏓
```

### 11.4 Radar Chart (Career Dashboard)
```
Use fl_chart package → RadarChart widget
- Axes: skill names from sport assessment template
- Data sets:
  - Latest assessment (solid, primary color)
  - Previous assessment (dashed, lighter, for comparison)
- Scale: 0-10
```

---

## 12. IMPORTANT BUSINESS RULES

1. **Booking Expiry:** If payment proof not uploaded within 1 hour of booking creation → auto-expire, release slot.
2. **Review Window:** Player can submit review within 7 days of session completion. After that, review option disappears.
3. **Assessment Optional:** Coach assessment is encouraged but optional per session.
4. **Organizer Min Participants:** If minimum not reached by join deadline → organizer manually decides: proceed or cancel. If cancel → all participants notified.
5. **One Role Per Account (MVP):** A user registers as one role. If they want to be both player and organizer, they need separate accounts (or we implement role switching in Phase 2).
6. **XP Only for Completed Bookings:** XP is awarded only when booking status reaches 'completed', not at creation or confirmation.
7. **Slot Availability:** When a booking is created (even pending_payment), the slot is temporarily held. Released if expired.
8. **Payment Method Required:** Venue owners, coaches, and organizers must have at least one payment method configured before they can receive bookings.

---

*Document Version: 1.0*
*Last Updated: February 2026*
*Target: Flutter + Laravel MVP Development*
