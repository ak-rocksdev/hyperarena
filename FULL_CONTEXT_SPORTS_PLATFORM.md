# SportHub — Sports Court, Coaching & Community Platform

## Complete Product Context Document

> **Purpose:** Dokumen ini berisi seluruh konteks produk, bisnis, dan teknis dari platform SportHub. Digunakan sebagai referensi utama untuk development, analisis, dan decision-making.

---

## 1. PRODUCT OVERVIEW

### 1.1 What Is This?

SportHub adalah platform marketplace yang menghubungkan **pemilik lapangan olahraga**, **pelatih (coach)**, **penyelenggara sesi (organizer/host)**, dan **pemain (player)** dalam satu ekosistem digital. Platform ini mengakomodir:

- Penyewaan lapangan olahraga (tennis, padel, badminton, futsal, basketball, dll)
- Pemesanan jasa coaching (private, group, camp)
- Penyelenggaraan open session / group session oleh organizer
- Sistem feedback dua arah (player ↔ coach, player → venue)
- Career tracking / rapor pemain
- Gamifikasi untuk engagement dan retention

### 1.2 Problem Statement

Saat ini di Indonesia:

- **Booking lapangan** dilakukan via WhatsApp — tidak terstruktur, rawan double booking, tidak ada historical data
- **Mencari coach** hanya via mulut ke mulut atau Instagram — tidak ada standar penilaian
- **Organizer/host** mengelola sesi secara manual — koordinasi jadwal, collect uang, cari venue dan coach semuanya via chat
- **Player** tidak punya record progress latihan mereka — setiap pindah coach, mulai dari nol
- **Antara sewa lapangan dan coaching terpisah** — tidak ada satu platform yang menyatukan keduanya

### 1.3 Solution

Satu platform yang menyatukan seluruh ekosistem olahraga rekreasi:

- **Venue owners** mendapat management tool + marketing channel
- **Coaches** mendapat lead generation + student management (CRM)
- **Organizers** mendapat tools untuk scale bisnis mereka tanpa kehilangan margin
- **Players** mendapat kemudahan booking + career tracking + komunitas + gamifikasi

### 1.4 Unique Value Propositions

1. **All-in-One** — court booking + coaching + organizer sessions dalam satu app
2. **0% Transaction Fee** — uang mengalir langsung antar aktor, platform tidak potong transaksi
3. **Career Tracking** — rapor pemain terakumulasi dari waktu ke waktu berdasarkan assessment coach
4. **Gamification-First** — XP, level, badges, streak membuat orang ketagihan berolahraga
5. **Smart Matchmaking** (Phase 2) — cari lawan/partner yang selevel
6. **Organizer Empowerment** — mengakui dan memperkuat peran "agen" yang sudah ada di dunia nyata

---

## 2. USER ROLES & ACTORS

### 2.1 Player (Pemain/Peserta)

**Who:** End user yang ingin bermain olahraga, sewa lapangan, atau ikut coaching.

**Needs:**
- Cari dan booking lapangan dengan mudah
- Cari coach yang sesuai sport, level, dan budget
- Ikut open session / group coaching tanpa ribet
- Track progress latihan (rapor)
- Temukan teman main / lawan yang selevel

**Capabilities in App:**
- Browse & search venue, court, coach, open session
- Booking court langsung
- Booking coaching session
- Join open session yang dibuat organizer
- Upload bukti pembayaran (QRIS / transfer)
- Memberikan rating & review ke: coach, venue, organizer, sesama player
- Melihat career dashboard / rapor (radar chart skill per sport)
- Mengumpulkan XP, naik level, unlock badges
- Melihat booking history

---

### 2.2 Court Owner (Pemilik Lapangan/Venue)

**Who:** Pemilik atau pengelola venue olahraga. Bisa punya satu atau multiple venue. Setiap venue bisa punya beberapa court dengan sport berbeda.

**Needs:**
- Mengelola jadwal lapangan secara efisien (goodbye WhatsApp chaos)
- Meningkatkan occupancy rate
- Mendapatkan exposure ke lebih banyak player
- Melihat analytics performa bisnis

**Capabilities in App:**
- Register venue + multiple courts
- Set atribut per court: sport type, indoor/outdoor, surface type (hard court, clay, grass, synthetic), facilities (lighting, AC, shower, parking)
- Set schedule availability per court per slot (per jam atau per 30 menit)
- Set pricing: regular, peak hours, off-peak hours
- Upload QRIS image + input bank transfer info
- View & manage bookings (confirm/reject payment proof)
- View ratings & reviews dari player
- View basic analytics: occupancy rate, revenue summary, popular slots
- Affiliate coaches ke venue (opsional)

---

### 2.3 Coach (Pelatih)

**Who:** Pelatih olahraga, bisa independen (freelance) atau terafiliasi dengan venue tertentu. Bisa punya spesialisasi di satu atau beberapa sport.

**Needs:**
- Mendapatkan murid baru (lead generation)
- Mengelola jadwal dan murid secara profesional
- Membangun reputasi (rating, portfolio)
- Track progress murid

**Capabilities in App:**
- Register coach profile: sport specialization, certifications, experience, bio, photos/videos
- Set availability schedule
- Create coaching packages: private (1-on-1), group (1:4-8), intensive camp, subscription mingguan
- Link to venue (opsional) atau set sebagai independent coach
- View & manage bookings (confirm/reject payment)
- Upload QRIS image + input bank transfer info
- Post-session: input player assessment (rapor)
  - Sport-specific skill ratings (1-10 per skill area)
  - Text feedback / notes
  - Recommended focus areas
- View CRM: semua murid, session history, progress tracking
- View ratings dari player
- View earnings summary

**Coach Assessment Template (contoh Tennis):**
- Forehand (1-10)
- Backhand (1-10)
- Serve (1-10)
- Volley (1-10)
- Footwork (1-10)
- Game Strategy (1-10)
- Mental Game (1-10)
- Overall notes (free text)
- Focus area (multi-select dari skills)

**Coach Assessment Template (contoh Badminton):**
- Smash (1-10)
- Drop Shot (1-10)
- Net Play (1-10)
- Footwork (1-10)
- Service (1-10)
- Defense/Lift (1-10)
- Game Strategy (1-10)
- Stamina/Endurance (1-10)

> Setiap sport memiliki template skill yang berbeda. Template ini bisa dikonfigurasi dari admin panel.

---

### 2.4 Organizer / Session Host

**Who:** Orang yang berperan sebagai penengah/kurator — menghubungkan court yang tepat, coach yang tepat, dan player yang tepat. Di dunia nyata, mereka sudah eksis dan menjalankan bisnis ini via WhatsApp. Mereka bisa jadi mantan pemain, enthusiast, atau siapa saja yang punya network di komunitas olahraga.

**Real-World Context:**
- Organizer mencari court yang available dan harganya cocok
- Mengumpulkan 8-10 orang player
- Menghubungkan dengan coach yang sesuai
- Mengkoordinasi jadwal semua pihak
- Mengumpulkan uang dari player, membayar court dan coach, sisanya menjadi margin

**Financial Example (Real):**
```
Group Coaching Session (2 jam):
- Coach fee: Rp 750.000
- Court rental: Rp 300.000
- Total cost: Rp 1.050.000

Jika charge Rp 150.000/orang:
- 10 peserta: Rp 1.500.000 → margin Rp 450.000
- 8 peserta: Rp 1.200.000 → margin Rp 150.000

Jika charge Rp 175.000/orang:
- 10 peserta: Rp 1.750.000 → margin Rp 700.000
- 8 peserta: Rp 1.400.000 → margin Rp 350.000

Potensi income organizer: Rp 6.000.000 - 28.000.000/bulan
(asumsi 2 session/hari, 20 hari/bulan)
```

**Capabilities in App:**
- Create "Open Session"
  - Set: sport, target level, venue + court, coach, tanggal, waktu
  - Set: harga per peserta
  - Set: min/max peserta
  - Set: deadline join (H-X sebelum session)
  - Pilih pricing model: margin (harga final saja) atau transparent (breakdown visible)
  - Publish ke app / private (hanya untuk follower)
- Manage peserta: approve/reject, waitlist, blast notification
- Handle payment collection: player bayar ke organizer, organizer bayar court + coach
- View session history & earnings analytics
- Build community: followers, regulars, invite/share session link
- Receive ratings & reviews dari player

**Pricing Model Options:**

Model 1 — Margin Pricing (default, player hanya lihat harga final):
```
Harga per peserta: Rp 150.000
(breakdown tidak ditampilkan ke player)
```

Model 2 — Transparent Pricing (opsional, breakdown visible):
```
Court: Rp 300.000 ÷ 10 = Rp 30.000/orang
Coach: Rp 750.000 ÷ 10 = Rp 75.000/orang
Organizing fee:           Rp 45.000/orang
Total:                    Rp 150.000/orang
```

---

### 2.5 Platform Admin (Super Admin)

**Who:** Tim internal platform. Mengelola seluruh ekosistem.

**Capabilities (Web Only):**
- Verify venue & coach registration (approval flow)
- User management (all roles): CRUD, suspend, ban
- Booking monitoring & dispute resolution
- Review moderation (flagged content)
- Gamification configuration: XP rules, badge management, level thresholds
- Sport management: add/edit sport types, assessment templates per sport
- Reports & analytics: user growth, booking trends, revenue
- Platform settings: terms & conditions, notification templates
- Subscription management: manage plans, billing

---

## 3. PAYMENT SYSTEM

### 3.1 Design Principle

**0% transaction fee** — platform tidak memotong dari setiap transaksi. Uang mengalir langsung antar aktor. Platform monetize melalui subscription dan featured listing.

### 3.2 Payment Methods Available

Setiap merchant (venue owner, coach, organizer) menyediakan metode pembayaran mereka sendiri:

1. **QRIS** — merchant upload gambar QRIS mereka. Player lihat dan scan dari app, bayar via banking app masing-masing.
2. **Bank Transfer** — merchant input: bank name, account number, account holder name. Player transfer manual.

### 3.3 Payment Flow

```
Player melakukan booking
→ Status: PENDING PAYMENT
→ Player lihat halaman pembayaran:
  ├── QRIS image (full screen, pinch to zoom)
  └── ATAU bank transfer details
→ Player bayar di luar app (via banking app / ATM)
→ Player upload bukti pembayaran (foto/screenshot)
→ Status: WAITING CONFIRMATION
→ Owner/Coach/Organizer review bukti bayar
  ├── Confirm → Status: CONFIRMED → notifikasi ke player
  └── Reject → Status: REJECTED → notifikasi ke player (alasan rejection)
→ Jika dalam 1 jam tidak upload bukti → Status: EXPIRED (slot released)
```

### 3.4 Payment Flows Per Booking Type

**Direct Court Booking:**
```
Player → pays → Venue Owner (QRIS/Transfer milik venue)
```

**Direct Coaching Booking (coach independent):**
```
Player → pays → Coach (QRIS/Transfer milik coach)
```

**Coaching + Court Booking:**
```
Option A: Coach affiliated with venue
  Player → pays → Venue Owner (single payment, coach dibayar oleh venue)

Option B: Coach independent
  Player → pays → Court Owner (untuk sewa lapangan)
  Player → pays → Coach (untuk coaching fee)
  (dua transaksi terpisah, atau coach yang handle court payment)
```

**Open Session via Organizer:**
```
Player → pays → Organizer (QRIS/Transfer milik organizer)
Organizer → pays → Venue Owner (di luar app)
Organizer → pays → Coach (di luar app)
```

---

## 4. RATING & REVIEW SYSTEM (TWO-WAY)

### 4.1 Review Directions

| From | To | Context |
|---|---|---|
| Player → Coach | Setelah coaching session selesai | Punctuality, communication, technical knowledge, motivation, value for money |
| Coach → Player | Setelah coaching session selesai | Skill assessment / rapor (sport-specific skill ratings + notes) |
| Player → Venue | Setelah booking court selesai | Kebersihan, kondisi court, lighting, parking, staff friendliness, value for money |
| Player → Organizer | Setelah open session selesai | Organization quality, communication, value for money, session quality |
| Player → Player | Setelah matchmaking / sparring (Phase 2) | Sportsmanship, skill accuracy, punctuality |

### 4.2 Rating Structure

- Star rating: 1-5 bintang
- Structured form fields (tergantung review type)
- Optional text review
- Submitted setelah session/booking completed
- Bisa submit review dalam 7 hari setelah session. Setelah itu expired.

### 4.3 Coach Assessment / Rapor (Special Case)

Ini bukan "review" biasa — ini assessment profesional yang terakumulasi menjadi player career data:

- Setiap coaching session yang selesai, coach BISA (opsional tapi encouraged) mengisi assessment form
- Form berisi skill-specific ratings (1-10) sesuai sport template
- Data ini ditampilkan di player career dashboard sebagai:
  - **Radar chart** (snapshot terkini)
  - **Line chart / progress chart** (perubahan skill over time)
  - **Assessment history** (list semua assessment dengan tanggal dan coach name)
- Player bisa share rapor mereka (export / screenshot)

---

## 5. GAMIFICATION SYSTEM

### 5.1 XP (Experience Points)

Setiap aktivitas memberikan XP:

| Activity | XP Earned |
|---|---|
| Complete court booking | +10 XP |
| Complete coaching session | +25 XP |
| Join & complete open session | +20 XP |
| Submit review (court) | +5 XP |
| Submit review (coach) | +5 XP |
| Submit review (organizer) | +5 XP |
| First booking ever | +20 XP (bonus) |
| Profile completed 100% | +15 XP |
| Try a new sport | +15 XP |

### 5.2 Level Tiers

| Level | XP Required | Badge |
|---|---|---|
| Rookie | 0-99 | 🟤 Bronze |
| Amateur | 100-299 | ⚪ Silver |
| Intermediate | 300-599 | 🟡 Gold |
| Advanced | 600-999 | 🔵 Platinum |
| Pro | 1000+ | 💎 Diamond |

Level ditampilkan di profile player sebagai badge icon.

### 5.3 Badges / Achievements (MVP Set)

| Badge | Nama | Condition |
|---|---|---|
| 🎾 | First Rally | Complete first booking |
| ⭐ | Critic | Submit first review |
| 📚 | Dedicated Learner | Complete 5 coaching sessions |
| 🏟️ | Explorer | Book at 3 different venues |
| 🎯 | Specialist | 10 bookings in the same sport |
| 🌟 | Rising Star | Reach Amateur level |
| 💪 | Committed | 10 total completed bookings |
| 🤝 | Team Player | Join 5 open sessions |

### 5.4 Coach Gamification

- Coach Level: berdasarkan jumlah session, rating rata-rata, retention rate
- "Top Coach" visibility: di search results
- Certification badges: verified by platform

### 5.5 Venue Gamification

- Venue Tier: berdasarkan rating, facilities, booking volume
- "Trending Venue" label: booking naik signifikan dalam periode tertentu

---

## 6. BUSINESS MODEL

### 6.1 Revenue Streams

#### Stream 1: Venue Owner Subscription (Primary)

| Tier | Price/Month | Features |
|---|---|---|
| Free | Rp 0 | 1 venue, max 2 courts, basic booking management, standard listing, platform watermark |
| Pro | Rp 299.000 | Unlimited courts, analytics dashboard, priority search, unlimited photos, promo tools, no watermark |
| Business | Rp 599.000 | All Pro + multi-venue, advanced analytics, featured listing, dedicated support, export reports |

#### Stream 2: Coach Subscription

| Tier | Price/Month | Features |
|---|---|---|
| Free | Rp 0 | Profile listing, max 5 active students, basic scheduling |
| Pro Coach | Rp 199.000 | Unlimited students, CRM, priority search, analytics, "Verified Pro Coach" badge, promo tools |

#### Stream 3: Organizer Subscription

| Tier | Price/Month | Features |
|---|---|---|
| Free | Rp 0 | Max 2 open sessions per week, max 10 peserta/session |
| Pro Organizer | Rp 249.000 | Unlimited sessions, analytics, priority listing, "Verified Organizer" badge, blast notifications, recurring session templates |

#### Stream 4: Featured Listing / Promoted Placement

- Venue featured on Home page: Rp 50.000-150.000/hari
- Venue top search position: Rp 500.000-1.000.000/minggu
- Coach "Recommended" placement: Rp 30.000-75.000/hari
- Self-serve dashboard: set budget, pilih durasi

#### Stream 5: Premium Player Membership (Phase 2)

| Tier | Price/Month | Features |
|---|---|---|
| Free Player | Rp 0 | Full booking access, basic gamification |
| Premium | Rp 49.000-79.000 | Advanced career analytics, priority matchmaking, early access booking, XP multiplier 1.5x, exclusive badges |

#### Stream 6: Tournament/Event Fee (Phase 2)

- Per participant: Rp 5.000-10.000
- Atau flat fee per event: Rp 200.000-500.000

### 6.2 Revenue Projection

**Year 1 — 1 Kota:**

| Source | Monthly (Mature, Month 6+) |
|---|---|
| Venue Subscription (30 paid) | Rp 11.970.000 |
| Coach Subscription (38 paid) | Rp 7.562.000 |
| Organizer Subscription (15 paid) | Rp 3.735.000 |
| Featured Listing | Rp 5.250.000 |
| **Total** | **Rp 28.517.000** |
| Annual estimate | ~Rp 230.000.000 |

**Year 2 — 3 Kota:**

| Source | Monthly (Mature) |
|---|---|
| Venue Subscription (105 paid) | Rp 41.895.000 |
| Coach Subscription (120 paid) | Rp 23.880.000 |
| Organizer Subscription (70 paid) | Rp 17.430.000 |
| Featured Listing | Rp 15.000.000 |
| Premium Player (750 paid) | Rp 44.250.000 |
| Tournament Fee | Rp 6.000.000 |
| **Total** | **Rp 148.455.000** |
| Annual estimate | ~Rp 1.300.000.000 - 1.500.000.000 |

### 6.3 Cost Structure (Monthly, Year 1)

| Item | Cost |
|---|---|
| Server & Infrastructure (AWS/GCP) | Rp 3.000.000 - 5.000.000 |
| Firebase (push notif, auth) | Rp 500.000 - 1.000.000 |
| Google Maps API | Rp 500.000 - 2.000.000 |
| Apple Developer Account (/12) | Rp 83.000 |
| Domain, SSL, etc | Rp 200.000 |
| Developer (1-2 orang) | Rp 15.000.000 - 30.000.000 |
| CS / Admin (1 part-time) | Rp 3.000.000 - 5.000.000 |
| Marketing & Acquisition | Rp 5.000.000 - 10.000.000 |
| Miscellaneous | Rp 2.000.000 |
| **Total** | **Rp 30.000.000 - 50.000.000** |

Break-even: bulan ke-8 sampai ke-12.

### 6.4 Revenue Flow Diagram

```
                    ┌──────────────────────┐
                    │    PLATFORM           │
                    │                      │
                    │  Revenue:            │
                    │  • Subscription ALL  │
                    │  • Featured Listing  │
                    │  • Premium Player    │
                    └───┬────┬────┬────┬───┘
                        │    │    │    │
          ┌─────────────┘    │    │    └──────────────┐
     Subscription       Subscription  Subscription   Premium Fee
          │                  │    │                    │
          ▼                  ▼    ▼                    ▼
   ┌──────────┐    ┌────────────────┐          ┌──────────┐
   │  VENUE   │    │   ORGANIZER    │          │  PLAYER  │
   │  OWNER   │    │  "The Glue"    │          │          │
   └────┬─────┘    └──┬──────┬──────┘          └──┬───────┘
        │             │      │                    │
        │◄────────────┘      └──────┐             │
        │ Sewa court                │             │
        │ (langsung)                ▼             │
        │                    ┌──────────┐         │
        │                    │  COACH   │         │
        │                    └────┬─────┘         │
        │                         │               │
        │◄────────────────────────┘               │
        │ Coach sewa court juga                   │
        │◄────────────────────────────────────────┘
        │ Direct booking
        ▼
   UANG TRANSAKSI MENGALIR LANGSUNG ANTAR AKTOR
   PLATFORM TIDAK MENYENTUH UANG TRANSAKSI (0% FEE)
```

### 6.5 Onboarding Strategy

**Phase 1: Supply First (Bulan 1-3)**
- Onboard 20-30 venue → FREE selamanya selama 6 bulan pertama (founding member)
- Onboard 30-50 coach → free tier
- Onboard 10-15 organizer → free tier + personal assistance
- Bantu setup profile, foto venue, konfigurasi jadwal (manual, hands-on)

**Phase 2: Demand Generation (Bulan 3-6)**
- Push marketing ke player: partner dengan komunitas olahraga lokal, sponsor event kecil, social media
- Organizer = customer acquisition channel gratis (setiap organizer bawa 50-200 player)
- Target: 1.000-2.000 player registered

**Phase 3: Monetization Kick-in (Bulan 6+)**
- Founding member free period habis → convert ke paid
- Introduce featured listing
- Upsell Free → Pro tiers
- Grandfathering: founding members dapat harga spesial selamanya

### 6.6 Competitive Moat

1. **Network Effect** — lebih banyak player → lebih banyak venue → lebih banyak player (flywheel)
2. **Data Moat** — career data / rapor terakumulasi dari puluhan coaching session, irreplaceable
3. **Gamification Lock-in** — XP, level, badges yang sudah dikumpulkan → switching cost tinggi
4. **Review Ecosystem** — ribuan review dan rating yang tidak bisa di-replicate overnight

---

## 7. FEATURES — COMPLETE LIST

### 7.1 Core Features (MVP)

1. **Multi-role Authentication** — single app, multiple roles (player, owner, coach, organizer)
2. **Venue & Court Listing** — browse, search, filter, detail page
3. **Court Booking** — slot selection, payment, confirmation flow
4. **Coach Listing** — browse, search, filter, detail page, packages
5. **Coaching Booking** — book session with or without court
6. **Open Session (Organizer)** — create, publish, manage participants, payment collection
7. **Payment System** — QRIS upload + bank transfer, payment proof upload, manual confirmation
8. **Rating & Review** — two-way (player ↔ coach, player → venue, player → organizer)
9. **Coach Assessment / Rapor** — sport-specific skill rating, accumulative career tracking
10. **Player Career Dashboard** — radar chart, progress over time, assessment history
11. **Gamification** — XP, level tiers, badges/achievements
12. **Booking Management** — for all roles: view, confirm, reject, history
13. **Notification System** — booking reminders, payment status, session updates
14. **Admin Panel (Web)** — user management, verification, moderation, analytics, gamification config

### 7.2 Phase 2 Features

1. **Smart Matchmaking** — find opponents/partners of similar level
2. **Community & Social Feed** — mini feed per venue/sport, post match results, groups
3. **Mini Tournament System** — bracket management, scoring, leaderboard
4. **In-App Wallet / Top-up** — balance system, optional
5. **Split Payment** — divide cost among multiple players
6. **Streak System** — weekly consistency rewards (like Duolingo)
7. **Seasonal Challenges** — quarterly challenges with rewards
8. **Recurring Booking** — auto-repeat weekly/monthly bookings
9. **Chat/Messaging In-App** — replace WhatsApp redirect
10. **Premium Player Membership** — advanced stats, priority matchmaking, XP multiplier

### 7.3 Phase 3 Features (Future)

1. **Coach Video Analysis** — upload training video, coach annotates
2. **AI Dynamic Pricing** — suggest optimal pricing based on demand patterns
3. **White-label Tournament** — brands can sponsor tournaments in-app
4. **Coach Marketplace** — coaches can bid on coaching requests
5. **Integration** — Google Calendar sync, Apple Health, Strava
6. **Multi-language Support**
7. **Virtual Trophy Room** — shareable achievement showcase

---

## 8. PLATFORM SPLIT

### 8.1 Mobile App (Flutter — Android + iOS)

**Player:**
- Browse & book courts, coaches, open sessions
- Gamification (XP, badges, leaderboard)
- Rating & review input
- Career dashboard / rapor
- Payment (view QRIS, upload bukti bayar)
- Booking management
- Notifications
- Profile & settings

**Court Owner:**
- Dashboard (today's bookings, revenue summary, pending confirmations)
- Booking management (confirm/reject payment proof)
- Venue & court management (simplified: edit info, photos)
- View ratings & reviews
- Payment settings (upload QRIS, input bank info)

**Coach:**
- Dashboard (today's sessions, earnings, rating)
- Schedule & availability management
- Booking management
- Post-session player assessment input
- Student list & progress tracking (simplified CRM)
- View ratings & reviews

**Organizer:**
- Dashboard (upcoming sessions, earnings, pending)
- Create & manage open sessions
- Participant management
- Community / followers
- Earnings analytics (simplified)

### 8.2 Web Admin Panel (Vue.js + Inertia.js + Laravel)

- Super Admin dashboard & analytics
- User management (all roles)
- Venue & Coach verification / approval
- Booking monitoring & dispute resolution
- Review moderation
- Gamification configuration (XP rules, badges, level thresholds)
- Sport management (sport types, assessment templates)
- Subscription & billing management
- Featured listing management
- Platform settings, T&C, notification templates
- Reports & export

### 8.3 Web Portal (Optional, Phase 2)

- Court Owner full analytics & management dashboard
- Coach full CRM & earnings dashboard
- Organizer advanced analytics

---

## 9. TECH STACK RECOMMENDATION

| Layer | Technology |
|---|---|
| Mobile | Flutter (single codebase → Android + iOS) |
| State Management | BLoC or Riverpod |
| Backend API | Laravel (PHP) |
| Database | MySQL / PostgreSQL |
| File Storage | S3-compatible (photos, QRIS images, payment proofs) |
| Push Notification | Firebase Cloud Messaging (FCM) |
| Authentication | Laravel Sanctum + Firebase Auth (social login) |
| Maps | Google Maps Flutter Plugin |
| Admin Web | Vue.js + Inertia.js (Laravel ecosystem) |
| Caching | Redis |
| Search | Laravel Scout + Meilisearch (for venue/coach search) |

---

## 10. KEY RISKS & MITIGATIONS

| Risk | Impact | Mitigation |
|---|---|---|
| Chicken & Egg: no players = no venues, no venues = no players | High | Supply-first strategy: onboard venues free. Organizers bring both supply AND demand. |
| Organizer bypass: player langsung ke coach/venue after knowing them | Medium | Organizer value > just connection (curation, management, group dynamics). Private session feature. Loyalty program. |
| Organizer fraud: collect money, cancel session | Medium | Rating system, minimum completion rate for verified badge, refund policy visible in profile. |
| Payment disputes (manual confirmation) | Medium | Timeout policy (1 hour), rejection with reason, dispute resolution by admin. |
| Coach assessment quality inconsistent | Low-Medium | Standardized template per sport, admin moderation, player can flag inaccurate assessments. |
| Low subscription conversion | Medium | Strong free tier to build habit, clear value demonstration (analytics, priority placement), grandfathering for early adopters. |

---

## 11. SUCCESS METRICS (KPIs)

### Growth Metrics
- Monthly Active Users (MAU) — per role
- Number of registered venues, coaches, organizers
- New user registrations per week

### Engagement Metrics
- Bookings per week (court, coaching, open session)
- Average sessions per player per month
- Gamification: % players who earned badges, average XP per player
- Review submission rate (% of completed bookings that get reviewed)
- Repeat booking rate

### Revenue Metrics
- Monthly Recurring Revenue (MRR) from subscriptions
- Subscription conversion rate (free → paid) per role
- Featured listing revenue
- Average Revenue Per User (ARPU) for paid merchants
- Churn rate per tier

### Quality Metrics
- Average venue rating
- Average coach rating
- Average organizer rating
- Payment confirmation time (avg time from upload to confirmed)
- Dispute rate

---

*Document Version: 1.0*
*Last Updated: February 2026*
*Status: Brainstorming → Ready for MVP Development*
