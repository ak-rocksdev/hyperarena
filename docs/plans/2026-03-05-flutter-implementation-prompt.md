# Flutter Implementation Prompt

Copy and paste this as the first message in a new Claude Code conversation when you're ready to implement.

---

## Prompt

I'm wiring up the HyperArena Flutter app to a real Laravel backend API. The full API contract is at `docs/plans/2026-03-05-flutter-api-contract.md` — please read it fully before starting. It contains every endpoint, auth flow, data model JSON shape, FCM payload structure, and conventions.

The Flutter app is at `D:\projects\Flutter\hyperarena`. It's UI-complete with 207 Dart files, using Riverpod for state management, GoRouter for routing, Freezed for models, and Dio (installed but not wired up). Currently everything uses mock repositories — the goal is to replace them with real API calls.

The backend is a Laravel API that supports bearer token auth via Sanctum. Flutter identifies itself with these headers on every request:
- `Authorization: Bearer {token}`
- `X-Client-Type: mobile`
- `X-Tenant: {tenant_slug}` (for tenant-scoped endpoints)

Before starting implementation, explore the current codebase structure — especially `lib/core/config/`, `lib/features/`, and existing mock repositories — to understand the patterns already in place.

Implementation priorities (in order):

1. **Dio HTTP client setup** — create an API client service with auth interceptor (bearer token, X-Tenant, X-Client-Type headers), error handling, and base URL config
2. **Secure token storage** — store/retrieve auth token using flutter_secure_storage
3. **Auth flow** — replace mock auth repository with real login/register/logout API calls, handle token lifecycle
4. **Tenant selection** — add flow for user to enter or select their organization (tenant slug)
5. **Update Freezed models** — align Dart models with the API JSON structures documented in the contract (snake_case keys, integer monetary values, UTC timestamps)
6. **Replace mock repositories** — one feature at a time, starting with the most-used: sessions, bookings, students, then coaches, credits, progress
7. **FCM integration** — firebase_messaging setup, device token registration, notification deep linking based on `data.type` field
8. **Arena browsing** — wire up public arena/sports endpoints (no tenant required)

Key conventions from the API:
- All monetary values are integers in cents/sen — divide by 100 for display
- All timestamps are UTC — convert to tenant timezone for display
- Pagination uses `{ data: [], meta: { current_page, last_page, total } }`
- Response format uses named keys: `{ user: {...} }`, `{ session: {...} }` — never assume `response.data.data`

Start by exploring the codebase, then implement step 1 (Dio client). After each step, verify it works before moving to the next.
