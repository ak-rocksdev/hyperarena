# Expired-State UX Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix contradictory expired-payment UI across three screens so the app shows a coherent terminal state (clear error icon + "Pesan Ulang" CTA) instead of confusing live countdown + cancel buttons + wrong status pills.

**Architecture:** Three targeted edits — (1) add `onExpired` callback to `CountdownTimer`, (2) wire the callback in `VaWaitingScreen` to auto-navigate and hide stale buttons, (3) upgrade `PaymentSuccessScreen` expired variant with `BookingSummaryCard` + dual buttons, (4) insert a "Pesan Ulang" branch in `_buildActionButton` in the session detail screen for users with `priorFailedPurchase`.

**Tech Stack:** Flutter 3.x, Riverpod, GoRouter, Dart

---

## File Map

| File | Change |
|---|---|
| `lib/features/payment/presentation/widgets/countdown_timer.dart` | Add optional `onExpired` callback; fire once when reaching zero |
| `lib/features/payment/presentation/screens/va_waiting_screen.dart` | Wire `onExpired`, hide cancel/bayar-nanti buttons when locally expired, add `_navigateToExpiredSuccess()` |
| `lib/features/payment/presentation/screens/payment_success_screen.dart` | Expired variant: new subtitle, BookingSummaryCard, dual buttons (Pesan Ulang + Kembali ke Beranda) |
| `lib/features/session/presentation/screens/marketplace_session_detail_screen.dart` | New "Pesan Ulang" branch in `_buildActionButton` after "isBooked" block |

---

## Task 1 — `CountdownTimer`: add `onExpired` callback

**Files:**
- Modify: `lib/features/payment/presentation/widgets/countdown_timer.dart`

- [ ] **Step 1: Add `onExpired` param and `_calledExpired` guard**

  Replace the entire file content with:

  ```dart
  import 'dart:async';
  import 'package:flutter/material.dart';

  class CountdownTimer extends StatefulWidget {
    const CountdownTimer({
      super.key,
      required this.expiresAt,
      this.onExpired,
    });

    final DateTime expiresAt;
    /// Called exactly once when the countdown reaches zero.
    /// Safe to trigger navigation from here.
    final VoidCallback? onExpired;

    @override
    State<CountdownTimer> createState() => _CountdownTimerState();
  }

  class _CountdownTimerState extends State<CountdownTimer> {
    Timer? _timer;
    Duration _remaining = Duration.zero;
    bool _calledExpired = false;

    @override
    void initState() {
      super.initState();
      _tick();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    void _tick() {
      if (!mounted) return;
      final remaining = widget.expiresAt.difference(DateTime.now());
      final isZero = remaining.isNegative || remaining == Duration.zero;
      setState(() => _remaining = isZero ? Duration.zero : remaining);

      if (isZero && !_calledExpired) {
        _calledExpired = true;
        // Fire after the current frame so callers can safely trigger navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.onExpired?.call();
        });
      }
    }

    String _format(Duration d) {
      final h = d.inHours.toString().padLeft(2, '0');
      final m = (d.inMinutes % 60).toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }

    @override
    Widget build(BuildContext context) {
      final expired = _remaining == Duration.zero;
      return Text(
        expired ? 'Kedaluwarsa' : 'Berlaku: ${_format(_remaining)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: expired ? Colors.red : Colors.amber.shade800,
        ),
      );
    }
  }
  ```

- [ ] **Step 2: Run flutter analyze on the widget file**

  ```
  flutter analyze lib/features/payment/presentation/widgets/countdown_timer.dart
  ```

  Expected: `No issues found!`

---

## Task 2 — `VaWaitingScreen`: local-expiry nav + hide stale buttons

**Files:**
- Modify: `lib/features/payment/presentation/screens/va_waiting_screen.dart`

Current state:
- `ref.listen` auto-navigates on server-confirmed `expired` status — keep this.
- `CountdownTimer` shows "Kedaluwarsa" text only — no callback.
- Cancel + Bayar Nanti buttons always visible.

Changes needed:
1. Add `_localExpired` state bool (starts `false`).
2. In `initState`, check if already past expiry at mount time; if so, post-frame navigate immediately.
3. Pass `onExpired` to `CountdownTimer` that sets `_localExpired = true` and calls `_navigateToExpiredSuccess()`.
4. Hide Cancel + Bayar Nanti buttons when `_localExpired`.
5. Extract `_navigateToExpiredSuccess()` method that invalidates session cache and navigates to the success screen.

- [ ] **Step 1: Rewrite `_VaWaitingScreenState` to add local expiry**

  Replace the entire `va_waiting_screen.dart` with:

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:go_router/go_router.dart';
  import 'package:hyperarena/core/theme/app_enums.dart';
  import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
  import 'package:hyperarena/features/payment/data/models/purchase_status.dart';
  import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
  import 'package:hyperarena/features/payment/presentation/widgets/cost_breakdown_card.dart';
  import 'package:hyperarena/features/payment/presentation/widgets/countdown_timer.dart';
  import 'package:hyperarena/features/payment/presentation/widgets/refund_policy_card.dart';
  import 'package:hyperarena/features/payment/presentation/widgets/va_account_display.dart';
  import 'package:hyperarena/routing/app_routes.dart';
  import 'package:hyperarena/shared/providers/marketplace_providers.dart';

  class VaWaitingScreen extends ConsumerStatefulWidget {
    const VaWaitingScreen({
      super.key,
      required this.purchaseId,
      required this.amount,
      required this.intent,
      this.sessionId,
      this.sessionLabel,
      this.sessionStartAt,
      this.venueName,
      this.paymentMethodLabel,
    });

    final int purchaseId;
    final int amount;
    final PaymentIntent intent;
    final int? sessionId;
    final String? sessionLabel;
    final DateTime? sessionStartAt;
    final String? venueName;
    final String? paymentMethodLabel;

    @override
    ConsumerState<VaWaitingScreen> createState() => _VaWaitingScreenState();
  }

  class _VaWaitingScreenState extends ConsumerState<VaWaitingScreen> {
    bool _localExpired = false;

    @override
    void initState() {
      super.initState();
      // If already expired at mount time, navigate immediately after first frame
      final alreadyExpired = widget.intent.expiresAt != null &&
          widget.intent.expiresAt!.isBefore(DateTime.now());
      if (alreadyExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _navigateToExpiredSuccess();
        });
      }
    }

    void _navigateToExpiredSuccess() {
      if (!mounted) return;
      if (widget.sessionId != null) {
        ref.invalidate(
          marketplaceSessionDetailProvider(widget.sessionId.toString()),
        );
      }
      context.go(
        '/payment/success/${widget.purchaseId}?status=expired',
        extra: {
          'sessionId': widget.sessionId,
          'sessionLabel': widget.sessionLabel,
          'sessionStartAt': widget.sessionStartAt,
          'venueName': widget.venueName,
          'amount': widget.amount,
          'paymentMethodLabel': widget.paymentMethodLabel,
        },
      );
    }

    Future<void> _confirmCancel() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Batalkan Pesanan?'),
          content: const Text(
            'Pesanan akan dibatalkan dan slot di sesi akan dilepas. Anda dapat memesan kembali nanti selama sesi masih tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Tidak'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) return;

      try {
        await ref.read(paymentRepositoryProvider).cancelPurchase(widget.purchaseId);
        if (!mounted) return;
        if (widget.sessionId != null) {
          ref.invalidate(
            marketplaceSessionDetailProvider(widget.sessionId.toString()),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan dibatalkan.'),
            backgroundColor: Colors.grey,
          ),
        );
        context.go(AppRoutes.home(UserRole.player));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membatalkan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      final statusAsync = ref.watch(purchaseStatusStreamProvider(widget.purchaseId));

      // Auto-navigate when server confirms terminal status
      ref.listen<AsyncValue<PurchaseStatus>>(
        purchaseStatusStreamProvider(widget.purchaseId),
        (prev, next) {
          next.whenData((status) {
            if (status.status != 'confirmed' && status.status != 'expired') return;
            if (status.status == 'expired') {
              _navigateToExpiredSuccess();
            } else {
              context.go(
                '/payment/success/${widget.purchaseId}?status=${status.status}',
                extra: {
                  'sessionId': widget.sessionId,
                  'sessionLabel': widget.sessionLabel,
                  'sessionStartAt': widget.sessionStartAt,
                  'venueName': widget.venueName,
                  'amount': widget.amount,
                  'paymentMethodLabel': widget.paymentMethodLabel,
                },
              );
            }
          });
        },
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Menunggu Pembayaran'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VaAccountDisplay(
                bank: widget.intent.vaBank ?? '',
                accountNumber: widget.intent.vaNumber ?? '',
                amount: widget.amount,
              ),
              const SizedBox(height: 16),
              CostBreakdownCard(
                itemLabel: widget.sessionLabel ?? 'Pembayaran Sesi',
                basePrice: widget.intent.amountBase,
                adminFee: widget.intent.feeAmount,
              ),
              const SizedBox(height: 12),
              const RefundPolicyCard(),
              const SizedBox(height: 16),
              if (widget.intent.expiresAt != null)
                Center(
                  child: CountdownTimer(
                    expiresAt: widget.intent.expiresAt!,
                    onExpired: () {
                      if (!_localExpired) {
                        setState(() => _localExpired = true);
                        _navigateToExpiredSuccess();
                      }
                    },
                  ),
                ),
              const SizedBox(height: 24),
              const _InstructionsBlock(),
              const SizedBox(height: 24),
              statusAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(
                  'Cek status: $e',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                data: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Menunggu pembayaran… terkonfirmasi otomatis'),
                  ],
                ),
              ),
              // Hide stale action buttons once locally expired
              if (!_localExpired) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: _confirmCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Batalkan Pesanan'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(AppRoutes.home(UserRole.player)),
                  child: const Text('Bayar Nanti'),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }

  class _InstructionsBlock extends StatelessWidget {
    const _InstructionsBlock();

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cara Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('1. Buka aplikasi mobile banking atau ATM bank Anda'),
            Text('2. Pilih menu Virtual Account / Transfer VA'),
            Text('3. Masukkan nomor VA di atas'),
            Text('4. Konfirmasi jumlah pembayaran'),
            Text('5. Selesaikan transaksi — pembayaran akan terkonfirmasi otomatis'),
          ],
        ),
      );
    }
  }
  ```

- [ ] **Step 2: Run flutter analyze on the screen file**

  ```
  flutter analyze lib/features/payment/presentation/screens/va_waiting_screen.dart
  ```

  Expected: `No issues found!`

---

## Task 3 — `PaymentSuccessScreen`: upgrade expired variant

**Files:**
- Modify: `lib/features/payment/presentation/screens/payment_success_screen.dart`

Current expired variant:
- Subtitle: `'Waktu pembayaran sudah habis. Silakan booking ulang jika ingin melanjutkan.'`
- Single `OutlinedButton` "Kembali ke Beranda"
- `BookingSummaryCard` already rendered when `_canShowSummary` — good, keep

Changes:
1. Update expired subtitle text.
2. Replace single expired button with two buttons: primary `FilledButton` "Pesan Ulang" + secondary `TextButton` "Kembali ke Beranda".
3. Add `_onReorder()` method that invalidates session cache and navigates to session detail (or home as fallback).
4. Remove the existing `buttonText`/`buttonStyle` tuple — replace with explicit `if (widget.status == 'expired')` block in the build body.

- [ ] **Step 1: Rewrite `payment_success_screen.dart`**

  Replace the entire file content with:

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:go_router/go_router.dart';
  import 'package:hyperarena/core/theme/app_colors.dart';
  import 'package:hyperarena/core/theme/app_enums.dart';
  import 'package:hyperarena/features/auth/providers/auth_provider.dart';
  import 'package:hyperarena/features/payment/presentation/widgets/booking_summary_card.dart';
  import 'package:hyperarena/routing/app_routes.dart';
  import 'package:hyperarena/shared/providers/marketplace_providers.dart';

  class PaymentSuccessScreen extends ConsumerStatefulWidget {
    const PaymentSuccessScreen({
      super.key,
      required this.purchaseId,
      required this.status,
      this.sessionId,
      this.sessionLabel,
      this.sessionStartAt,
      this.venueName,
      this.amount,
      this.paymentMethodLabel,
    });

    final int purchaseId;
    final String status; // 'confirmed' | 'awaiting_review' | 'expired'
    final int? sessionId;
    final String? sessionLabel;
    final DateTime? sessionStartAt;
    final String? venueName;
    final int? amount;
    final String? paymentMethodLabel;

    @override
    ConsumerState<PaymentSuccessScreen> createState() =>
        _PaymentSuccessScreenState();
  }

  class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen>
      with SingleTickerProviderStateMixin {
    late final AnimationController _controller;
    late final Animation<double> _scale;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
      _controller.forward();

      if (widget.status == 'confirmed' || widget.status == 'awaiting_review') {
        HapticFeedback.mediumImpact();
      }
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    Future<void> _onFinish() async {
      // Only 'confirmed' has special routing — the user is enrolled, so bounce
      // back to the session detail with a success marker. All other terminal
      // statuses ('awaiting_review', 'expired', unknown) go home.
      if (widget.status == 'confirmed' && widget.sessionId != null) {
        ref.invalidate(
          marketplaceSessionDetailProvider(widget.sessionId.toString()),
        );
        if (!mounted) return;
        context.go(
          '${AppRoutes.marketplaceSession(widget.sessionId.toString())}?joined=1',
        );
        return;
      }

      context.go(AppRoutes.home(UserRole.player));
    }

    /// "Pesan Ulang" — go back to session detail so user can re-checkout.
    /// Invalidates the session cache first so fresh participant/status data loads.
    void _onReorder() {
      if (widget.sessionId != null) {
        ref.invalidate(
          marketplaceSessionDetailProvider(widget.sessionId.toString()),
        );
        context.go(AppRoutes.marketplaceSession(widget.sessionId.toString()));
      } else {
        context.go(AppRoutes.home(UserRole.player));
      }
    }

    @override
    Widget build(BuildContext context) {
      final (icon, color, title, subtitle) = switch (widget.status) {
        'confirmed' => (
          Icons.check_circle,
          Colors.green.shade600,
          'Pembayaran Berhasil',
          'Sesi Anda sudah terkonfirmasi. Sampai jumpa di lapangan!',
        ),
        'awaiting_review' => (
          Icons.access_time_filled,
          Colors.amber.shade700,
          'Menunggu Verifikasi',
          'Bukti transfer terkirim. Admin akan memverifikasi dalam 1×24 jam.',
        ),
        'expired' => (
          Icons.cancel,
          Colors.red.shade600,
          'Pembayaran Kedaluwarsa',
          'Waktu pembayaran sudah habis. Slot di sesi sudah dilepas, silakan pesan kembali jika masih ingin gabung.',
        ),
        _ => (
          Icons.info,
          Colors.grey,
          'Status Tidak Diketahui',
          'Hubungi admin klub jika ada masalah.',
        ),
      };

      final userName = ref.watch(authNotifierProvider)?.name ?? 'Anda';

      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: ScaleTransition(
                    scale: _scale,
                    child: Icon(icon, size: 80, color: color),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(subtitle, textAlign: TextAlign.center),
                if (_canShowSummary) ...[
                  const SizedBox(height: 24),
                  BookingSummaryCard(
                    sessionLabel: widget.sessionLabel!,
                    sessionStartAt: widget.sessionStartAt,
                    venueName: widget.venueName,
                    userName: userName,
                    amount: widget.amount!,
                    paymentMethodLabel: widget.paymentMethodLabel!,
                    paidAt: DateTime.now(),
                    status: widget.status,
                  ),
                ],
                const SizedBox(height: 24),
                // Expired variant: dual-button terminal state
                if (widget.status == 'expired') ...[
                  FilledButton.icon(
                    onPressed: _onReorder,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Pesan Ulang'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.home(UserRole.player)),
                    child: const Text('Kembali ke Beranda'),
                  ),
                ] else
                  ElevatedButton(
                    onPressed: _onFinish,
                    style: _primaryStyle(),
                    child: const Text('Selesai'),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    bool get _canShowSummary =>
        widget.sessionLabel != null &&
        widget.amount != null &&
        widget.paymentMethodLabel != null;

    ButtonStyle _primaryStyle() => ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
        );
  }
  ```

- [ ] **Step 2: Run flutter analyze on the screen file**

  ```
  flutter analyze lib/features/payment/presentation/screens/payment_success_screen.dart
  ```

  Expected: `No issues found!`

---

## Task 4 — Session detail: "Pesan Ulang" branch in `_buildActionButton`

**Files:**
- Modify: `lib/features/session/presentation/screens/marketplace_session_detail_screen.dart`

Current priority order in `_buildActionButton` (line ~700):
1. `isBooked` → "Lanjutkan Pembayaran" or status pill — lines 700–746
2. `isFull` → "Sesi Penuh" — lines 749–757
3. No credits + no bank info → "Tidak Dapat Bergabung" — lines 760–784
4. Credit mode + has credits → "Gabung Sekarang [X kredit]" — lines 787–827
5. Default → "Gabung Sekarang" — lines 830–845

**Insert new branch** at position 1.5 — AFTER the `isBooked` block closes (after line 746) and BEFORE `isFull` check (line 749):

```dart
// User had a recent failed purchase for this session — offer fresh re-book
if (!userStatus.isBooked && userStatus.priorFailedPurchase != null) {
  return FilledButton(
    onPressed: joinState.isLoading ? null : () => _onJoinTap(context, ref),
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      minimumSize: const Size(160, AppDimensions.buttonHeightMd),
    ),
    child: joinState.isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh, size: 18),
              SizedBox(width: 6),
              Text('Pesan Ulang'),
            ],
          ),
  );
}
```

- [ ] **Step 1: Locate the insertion point**

  In `marketplace_session_detail_screen.dart`, find the `_buildActionButton` method. The insertion target is the line:

  ```dart
      // Session full
      if (isFull) {
  ```

  The new block goes immediately before this line.

- [ ] **Step 2: Insert the new branch**

  In `_buildActionButton`, before `// Session full`:

  ```dart
      // User had a recent failed purchase — offer a re-book CTA
      if (!userStatus.isBooked && userStatus.priorFailedPurchase != null) {
        return FilledButton(
          onPressed: joinState.isLoading ? null : () => _onJoinTap(context, ref),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(160, AppDimensions.buttonHeightMd),
          ),
          child: joinState.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 6),
                    Text('Pesan Ulang'),
                  ],
                ),
        );
      }

      // Session full
      if (isFull) {
  ```

- [ ] **Step 3: Run flutter analyze on the session file**

  ```
  flutter analyze lib/features/session/presentation/screens/marketplace_session_detail_screen.dart
  ```

  Expected: `No issues found!`

---

## Task 5 — Full analyze + APK build + copy + commit

- [ ] **Step 1: Run flutter analyze across all changed features**

  ```
  flutter analyze lib/features/payment/ lib/features/session/
  ```

  Expected: `No issues found!` or only pre-existing warnings unrelated to this change.

- [ ] **Step 2: Build release APK**

  ```
  flutter build apk --release \
    --target=lib/main_dev.dart \
    --dart-define=APP_ENV=dev \
    --dart-define=API_BASE_URL=https://devapp.hyperscore.cloud/api \
    --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana
  ```

  Expected: `✓ Built build/app/outputs/flutter-apk/app-release.apk`

- [ ] **Step 3: Copy APK to releases/**

  ```
  cp build/app/outputs/flutter-apk/app-release.apk \
    releases/HyperArena-v0.3.3+17-dev-expired-ux-20260602.apk
  ```

  Verify: `ls -lh releases/HyperArena-v0.3.3+17-dev-expired-ux-20260602.apk`

- [ ] **Step 4: Stage and commit**

  ```bash
  git add lib/features/payment/presentation/widgets/countdown_timer.dart \
          lib/features/payment/presentation/screens/va_waiting_screen.dart \
          lib/features/payment/presentation/screens/payment_success_screen.dart \
          lib/features/session/presentation/screens/marketplace_session_detail_screen.dart
  git commit -m "Payment: expired-state terminal UX + Pesan Ulang flow

  - PaymentSuccessScreen expired variant upgraded with full BookingSummaryCard
    + Pesan Ulang as primary CTA (invalidates session cache, navigates to
    session detail for fresh checkout)
  - VaWaitingScreen: CountdownTimer now exposes onExpired callback; when local
    timer hits 0, screen immediately auto-navigates to expired success screen
    (no more contradictory state where countdown says expired but cancel/
    bayar-nanti buttons still visible)
  - Session detail button matrix: new 'Pesan Ulang' (teal primary) branch
    for users with prior_failed_purchase + not currently booked; replaces
    default 'Gabung Sekarang' to make the recovery action obvious"
  ```

  **No `Co-Authored-By` line.**

---

## Self-Review Checklist

- [ ] PaymentSuccessScreen expired variant has dual buttons (Pesan Ulang primary FilledButton + Kembali ke Beranda TextButton)?
- [ ] BookingSummaryCard renders for expired status? (verified in BookingSummaryCard — `_statusLabel`/`_statusColor` both handle `'expired'` correctly)
- [ ] CountdownTimer.onExpired callback added + fires once via `_calledExpired` guard?
- [ ] Auto-nav in VaWaitingScreen happens exactly once (both `_localExpired` guard on callback side and `_calledExpired` guard in timer)?
- [ ] Cancel + Bayar Nanti buttons hidden when `_localExpired = true`?
- [ ] Already-expired-at-mount handled via `initState` + `addPostFrameCallback`?
- [ ] Session detail button matrix has new "Pesan Ulang" branch positioned between isBooked block and isFull block?
- [ ] Prior failed purchase BANNER still rendered (it's in the body scroll area, not the bottom bar — unaffected)?
- [ ] `flutter analyze` clean?
- [ ] APK built and copied to `releases/`?
- [ ] No `Co-Authored-By` in commit message?
