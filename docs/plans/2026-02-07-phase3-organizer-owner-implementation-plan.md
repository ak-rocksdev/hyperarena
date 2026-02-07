# Phase 3: Organizer + Court Owner Operations (MVP)

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Complete the two remaining business-critical supply roles after role-architecture refactor:  
1) Organizer can create and operate open sessions end-to-end, and  
2) Court Owner can manage venues/courts and confirm player payments from mobile.

**Primary UX objective:** Organizer dashboard must be action-led and operational:
`Fill slots -> collect money -> confirm players -> resolve issues -> close sessions`.

**Why this is the next phase:**  
- Phase 0/1/2 already covered foundation, player core, and coach role.  
- `2026-02-07-role-architecture-improvements.md` introduces 4-role routing and placeholders.  
- The highest product gap is operational tooling for Organizer and Court Owner.

**Architecture:** Keep Feature-First + Riverpod + mock-first repository contracts. Reuse existing session/venue/booking models where possible, extend only where needed.

**Tech Stack:** Flutter 3.38, Riverpod, go_router, Freezed/json_serializable, cached_network_image.

---

## Scope Boundaries

### In-Scope (Phase 3)
- Organizer dashboard with unified **Needs Attention** inbox.
- Organizer session CRUD + calendar/agenda operations.
- Organizer participant lifecycle (including refund/dispute-ready states).
- Organizer earnings + settlement status by session.
- Organizer communication entry points (message participants, reminder templates).
- Court Owner dashboard, venue list/basic editing, booking inbox, confirm/reject payment.
- Role-safe navigation + route guards using centralized `AppRoutes`.
- Mock data + providers + full UI states (loading/error/empty).

### Out-of-Scope (Phase 4+)
- Full review moderation flows.
- Advanced analytics and exports.
- Real API integration beyond current mock-first foundation.
- Tournament/matchmaking/social feed.

### Phase 3 Guardrails
- Default organizer dashboard timeframe: **Today + Next 7 days**.
- Dashboard order: `Needs Attention -> Next Sessions -> Create Session CTA -> Earnings Snapshot`.
- Keep monthly charts secondary.
- Treat reliability controls (cancel/refund/reschedule) as core, not polish.
- Keep notification copy actionable: "Confirm X payments" over generic activity pings.

---

## Task 1: Extend Domain Models for Organizer Operations

**Files:**
- Modify: `lib/features/session/data/models/open_session.dart`
- Create: `lib/features/session/data/models/session_participant.dart`
- Create: `lib/features/organizer/data/models/organizer_dashboard_stats.dart`
- Create: `lib/features/organizer/data/models/organizer_action_item.dart`

**Changes:**
- Add organizer-operational fields to `OpenSession` (status, joinDeadline, pricingModel, visibility, organizer fee/cost breakdown optional).
- Add `sessionHealth` fields (`fillRate`, `pendingPayments`, `isLowSignupRisk`, `joinDeadlineAtRisk`).
- Add `settlementStatus` per session (`pending`, `cleared`, `paidOut`).
- Add `SessionParticipant` model with extensible states:
  - `pendingPayment`
  - `confirmed`
  - `rejected`
  - `cancelledByPlayer`
  - `refunded`
  - `noShow`
  - `disputed`
- Add `OrganizerDashboardStats` model (upcoming count, pending payments, avg participants, monthly earnings, avg rating).
- Add `OrganizerActionItem` model for unified inbox (type, severity, sessionId, participantId, dueAt, actionableRoute).

**Verify:**
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

---

## Task 2: Organizer Repository Contract + Mock Implementation

**Files:**
- Create: `lib/features/organizer/data/organizer_repository.dart`
- Create: `lib/features/organizer/data/mock_organizer_repository.dart`
- Modify: `lib/core/mocks/mock_data.dart`
- Create/Modify mocks under `lib/core/mocks/` for organizer sessions and participants

**Repository methods (minimum):**
- `getDashboard()`
- `getMySessions({bool upcomingOnly = false})`
- `getAgenda({required DateTime from, required DateTime to})`
- `getSessionDetail(String sessionId)`
- `createSession(CreateSessionDraft draft)`
- `updateSession(String sessionId, CreateSessionDraft draft)`
- `duplicateSession(String sessionId, {required DateTime newDate})`
- `createFromTemplate(String templateId, DateTime date)`
- `rescheduleSession(String sessionId, {required DateTime newDate, required String newStartTime, required String newEndTime})`
- `cancelSession(String sessionId, {required String reason})`
- `completeSession(String sessionId)`
- `getParticipants(String sessionId)`
- `confirmParticipant(String participantId)`
- `rejectParticipant(String participantId, {required String reason})`
- `markNoShow(String participantId)`
- `requestRefund(String participantId, {required String reason})`
- `resolveDispute(String participantId, {required String resolution})`
- `getActionInbox({String? type, String? severity})`
- `sendParticipantMessage(String sessionId, {required String templateCode, String? customMessage, bool pendingOnly = false})`
- `getEarningsSummary()`
- `getSessionSettlement(String sessionId)`

**Verify:**
```bash
flutter analyze lib/features/organizer lib/core/mocks
```

---

## Task 3: Organizer Providers

**Files:**
- Create: `lib/features/organizer/providers/organizer_providers.dart`
- Create: `lib/features/organizer/providers/create_session_provider.dart`
- Create: `lib/features/organizer/providers/participant_management_provider.dart`

**Provider responsibilities:**
- DI switch: mock/real repository.
- Dashboard + sessions list async providers.
- Action inbox provider with filter state.
- Today/Next7 agenda provider.
- Session detail provider family.
- Create/edit session multi-step draft state notifier.
- Duplicate/template creation actions.
- Participant action handlers with optimistic refresh/invalidation.
- Settlement + earnings providers.

**Verify:**
```bash
flutter analyze lib/features/organizer/providers
```

---

## Task 4: Organizer Screens — Replace Placeholders

**Files:**
- Modify: `lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart`
- Modify/Create: `lib/features/organizer/presentation/screens/organizer_sessions_screen.dart`
- Create: `lib/features/organizer/presentation/screens/organizer_session_detail_screen.dart`
- Create: `lib/features/organizer/presentation/screens/create_session_screen.dart`
- Create: `lib/features/organizer/presentation/screens/participant_management_screen.dart`
- Modify: `lib/features/organizer/presentation/screens/organizer_community_screen.dart`
- Create: `lib/features/organizer/presentation/screens/organizer_earnings_screen.dart`

**UI requirements:**
- Dashboard (action-led):  
  1) Needs Attention inbox (top priority),  
  2) Next Sessions timeline (Today + Next 7 days),  
  3) Create Session CTA,  
  4) compact earnings snapshot.
- Sessions tab: list + agenda/calendar toggle.
- Session cards/detail show health chips: fill rate, pending payments, risk flags.
- Session detail: participant list, payment/refund/dispute state, confirm/reject/no-show/refund actions, cancel/complete actions.
- Create session: 4-5 step wizard (basic info, venue/coach, schedule/pricing, settings, review/publish) plus:
  - start from template
  - duplicate from prior session
- Community: followers list + invite/share actions.
- Earnings: available vs pending vs paid out + per-session settlement status.
- Communication entry points:
  - message all participants
  - message pending only
  - quick templates: `starts_in_2h`, `court_changed`, `payment_reminder`

**Verify:**
```bash
flutter analyze lib/features/organizer/presentation
```

---

## Task 5: Owner Repository Contract + Mock Implementation

**Files:**
- Create: `lib/features/owner/data/owner_repository.dart`
- Create: `lib/features/owner/data/mock_owner_repository.dart`
- Add/modify mocks in `lib/core/mocks/` for owner dashboard + owner booking queue

**Repository methods (minimum):**
- `getDashboard()`
- `getMyVenues()`
- `getVenueDetail(String venueId)`
- `updateVenueBasic(...)`
- `getBookingQueue({String? venueId})`
- `confirmBookingPayment(String bookingId)`
- `rejectBookingPayment(String bookingId, {required String reason})`
- `getCourtAvailabilityIssues()`
- `setCourtUnavailable(String courtId, {required DateTime from, required DateTime to, required String reason})`

**Verify:**
```bash
flutter analyze lib/features/owner lib/core/mocks
```

---

## Task 6: Owner Providers

**Files:**
- Create: `lib/features/owner/providers/owner_providers.dart`

**Provider responsibilities:**
- Owner dashboard async provider.
- Owner venue list + detail providers.
- Booking queue provider with action methods (confirm/reject).
- Refresh strategies after actions (invalidate list/detail).
- Court availability issue provider.
- Owner boundary signals provider (what owner must confirm vs what organizer controls).

**Verify:**
```bash
flutter analyze lib/features/owner/providers
```

---

## Task 7: Owner Screens — Replace Placeholders

**Files:**
- Modify: `lib/features/owner/presentation/screens/owner_dashboard_screen.dart`
- Modify: `lib/features/owner/presentation/screens/owner_venue_list_screen.dart`
- Create: `lib/features/owner/presentation/screens/owner_venue_detail_screen.dart`
- Create: `lib/features/owner/presentation/screens/owner_booking_queue_screen.dart`

**UI requirements:**
- Dashboard: today bookings, pending confirmations, quick revenue, occupancy summary.
- Venue list: cards + status + quick actions.
- Venue detail: basic info/court snapshot/edit button (MVP basic edit only).
- Booking queue: payment proof preview + confirm/reject with reason.
- Surface organizer-owner boundary clearly:
  - `Owner confirmation required`
  - `Organizer managed payment`
  - court unavailable / reassigned notices

**Verify:**
```bash
flutter analyze lib/features/owner/presentation
```

---

## Task 8: Routing + Role Navigation Finalization

**Files:**
- Modify: `lib/routing/app_router.dart`
- Modify: `lib/routing/app_routes.dart`
- Modify role-specific entry points/buttons in organizer/owner screens

**Changes:**
- Replace organizer/owner placeholders in shells with real screens.
- Add organizer full-screen routes: create/edit/detail/session participants/earnings.
- Add owner full-screen routes: venue detail, booking queue.
- Ensure redirect logic sends authenticated users to `AppRoutes.home(role)` for all 4 roles.
- Add routes for organizer action inbox and agenda/calendar views.

**Verify:**
```bash
flutter analyze lib/routing
```

---

## Task 9: Cross-Role Payment and Notification Hooks (Mock-Level)

**Files:**
- Modify: organizer/owner repositories + providers
- Optional helper: `lib/core/services/mock_notification_service.dart`

**Changes:**
- Organizer participant confirm/reject updates booking/session participant state consistently.
- Support cancel/refund/reschedule lifecycle with explicit reason capture.
- Owner confirm/reject updates booking status consistently.
- Trigger local in-app notification entries (mock) with actionable titles:
  - `Confirm 3 pending payments`
  - `Session join deadline in 3h`
  - `Refund request waiting`
- Maintain dispute state and evidence placeholder fields in mock domain models.

**Verify:**
```bash
flutter analyze
```

---

## Task 10: QA + Regression Pass

**Required checks:**
```bash
flutter analyze
flutter build apk --debug -t lib/main_mock.dart
```

**Manual flow matrix:**
1. Quick login Host -> organizer lands on Needs Attention + Next7 timeline.
2. Organizer payment approvals/rejections/no-show/refund/dispute actions update participant + booking state.
3. Organizer can duplicate session and create from template.
4. Organizer can send participant reminders from session detail.
5. Quick login Owner -> dashboard/venues/booking queue/court availability issue flow.
6. Owner confirm/reject booking payment -> reflected in player booking detail.
7. Player still can browse/join sessions and standard booking flow remains intact.
8. Coach flows from Phase 2 remain unaffected.

---

## Deliverables Checklist

- [ ] Organizer repositories, providers, and full screens implemented.
- [ ] Owner repositories, providers, and full screens implemented.
- [ ] No organizer/owner placeholder screen remains in active routes.
- [ ] All navigation uses `AppRoutes` constants.
- [ ] Organizer dashboard is action-led (inbox first) with Today+Next7 default.
- [ ] Participant lifecycle supports refund/dispute/no-show states in model layer.
- [ ] Session settlement status is visible in organizer earnings/session detail.
- [ ] Full app analyze/build passes in mock mode.
- [ ] Manual role-switch test passes for Player/Coach/Organizer/Owner.

---

## Suggested Sequencing (Execution Order)

1. Task 1-3 (Organizer data + providers)
2. Task 4 (Organizer UI)
3. Task 5-7 (Owner data + UI + boundary signals)
4. Task 8-9 (Routing + cross-role consistency + reliability controls)
5. Task 10 (QA hardening)

---

*Plan Version: 1.0*  
*Phase: 3 — Organizer + Court Owner Operations*  
*Date: 2026-02-07*
