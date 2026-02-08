# HyperArena — Future Phases Roadmap

> Quick reference for what comes after Phase 4. Each phase will get its own detailed plan when we start it.

---

## Phase 4.1: UI Polish — Missing Flows, Venue Reviews & Discovery (NEXT)

**Status:** Planning
**Plan:** `docs/plans/2026-02-08-phase4.1-ui-polish-venue-reviews.md`
**Scope:** Venue reviews (5-star, public), functional search & filter, forgot password, WhatsApp deep links, payment countdown timer, booking cancellation, coach availability, wire remaining TODOs, empty/loading states.

---

## Phase 5: Backend API Integration & Real Data

**Status:** Not started
**Scope:**
- Laravel backend setup (migrations, Sanctum auth, all API endpoints)
- Replace all MockRepository implementations with Dio HTTP clients
- Real login/register/token refresh, social login via Firebase
- Image upload to S3 (avatars, venue photos, payment proofs)
- Deep linking from push notifications
- This is the **non-negotiable blocker** before production

---

## Phase 6: Payment Integration

**Status:** Not started
**Scope:**
- Xendit or Midtrans integration (QRIS + bank transfer)
- Real payment flow with webhook-based confirmation
- Auto-expire unpaid bookings
- Payout settlement for coaches, venue owners, organizers
- Payment history per user

---

## Phase 7: Search, Maps & Discovery

**Status:** Not started
**Scope:**
- Google Maps on explore screens (venue markers, directions)
- Geo-location detection + distance calculation
- Meilisearch for full-text search (venues, coaches, sessions)
- Faceted filtering (sport, price, rating, distance)
- Sort by nearest, cheapest, highest rated
- Favorites/wishlists

---

## Phase 8: Real-Time Features & Chat

**Status:** Not started
**Scope:**
- WebSocket integration for live session updates
- In-app chat (replace WhatsApp redirect)
- Live notifications via FCM
- "X players just joined" real-time updates

---

## Phase 9: Recurring Bookings & Subscriptions

**Status:** Not started
**Scope:**
- Weekly/monthly recurring court bookings
- Coach monthly packages (8/12 sessions)
- Auto-renewal with payment retry

---

## Phase 10: Gamification Completion & Social

**Status:** Not started
**Scope:**
- Streak system (consecutive bookings/reviews)
- Seasonal challenges
- Leaderboards (top XP per sport, top coaches by rating)
- Find partners by similar level
- Invite to group sessions

---

## Phase 11: Admin Web Panel

**Status:** Not started
**Scope:**
- Vue.js + Inertia.js dashboard (within Laravel)
- User management, verification workflows
- Booking monitoring, dispute resolution
- Review moderation
- Gamification config
- Analytics/reporting
