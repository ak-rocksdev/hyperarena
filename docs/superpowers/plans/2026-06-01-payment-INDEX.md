# Payment System V1 — Implementation Plan Index

**Spec:** `docs/PRD-payment-system-with-xendit-va.md`
**Created:** 2026-06-01

Four phase plans. Execute in order; each phase produces working, testable software on its own.

| Phase | File | Repo | Effort | Depends on |
|---|---|---|---|---|
| **P2 — BE Foundation** | [`2026-06-01-payment-p2-be-foundation.md`](./2026-06-01-payment-p2-be-foundation.md) | `C:\laragon\www\hypercoach` | ~1.5 days | spec |
| **P3 — Web Admin UI** | [`2026-06-01-payment-p3-admin-ui.md`](./2026-06-01-payment-p3-admin-ui.md) | `C:\laragon\www\hypercoach` | ~1 day | P2 |
| **P4a — BE Xendit VA** | [`2026-06-01-payment-p4a-xendit-be.md`](./2026-06-01-payment-p4a-xendit-be.md) | `C:\laragon\www\hypercoach` | ~2 days | P2 |
| **P4b — Mobile UI** | [`2026-06-01-payment-p4b-mobile-ui.md`](./2026-06-01-payment-p4b-mobile-ui.md) | `D:\projects\Flutter\hyperarena` | ~2 days | P2, P4a |

Execution: run one phase to completion (all tasks + tests green + commits pushed + deployed to dev), verify end-to-end at deployed boundary, then start next phase.

## Branding rule (enforced in every task involving user-facing surfaces)

User must NEVER see "Xendit". Internal code/columns/env may say `xendit_*`; API responses, mobile UI, web admin UI, push notifications, log lines visible to organizer admin — must say "HyperArena" / "Virtual Account" / "Payment Gateway" / "automatic".

## Deployment order

1. Merge P2 → deploy dev → smoke test manual flow end-to-end (still works as before, but via new abstraction).
2. Merge P3 → deploy dev → admin can toggle methods, but toggle has no effect yet on mobile.
3. Merge P4a → deploy dev → backend can create VA via Xendit sandbox + receive webhook. Test via Postman/curl + Xendit dashboard simulator.
4. Merge P4b → deploy dev APK → end-to-end test on Samsung Tab S9 with real VA payment via sandbox.
