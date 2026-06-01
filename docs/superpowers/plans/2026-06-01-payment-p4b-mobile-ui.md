# Payment P4b — Mobile Checkout + VA Waiting + Manual Upload Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Flutter app shows correct payment options based on tenant settings; user can pay via manual transfer (upload bukti) OR Virtual Account (auto-confirm with polling fallback for push); confirmation screen + push notifier when paid.

**Architecture:** Riverpod state per checkout flow. `PaymentMethodsRepository` fetches available methods from BE. `CheckoutScreen` is a single screen with method selector (radio cards). On select + continue → either `ManualPaymentScreen` (instructions + upload) or `VaWaitingScreen` (account number + polling). Polling stops on app foreground via lifecycle observer.

**Tech Stack:** Flutter 3.38, Riverpod, go_router, Freezed, dio, image_picker, flutter_local_notifications (optional push integration), Indonesian-only copy.

**Repo:** `D:\projects\Flutter\hyperarena`.

**Branding rule (apply to every task):** every user-visible string says "HyperArena" / "Virtual Account" / "Otomatis" / "Bank Transfer Manual". NEVER show "Xendit", `xendit_va_id`, or any provider name except bank names (BCA/Mandiri/BRI/BNI) which are bank brands, not provider.

---

## File Structure

| File | Responsibility |
|---|---|
| `lib/features/payment/data/models/payment_method.dart` | Freezed model: `PaymentMethod{provider, label, banks?, fees?}` |
| `lib/features/payment/data/models/payment_intent.dart` | Freezed model: `PaymentIntent{provider, status, vaBank?, vaAccountNumber?, expiresAt?, instructions?}` |
| `lib/features/payment/data/models/purchase_status.dart` | Freezed model: matches BE GET status |
| `lib/features/payment/data/repositories/payment_repository.dart` | dio calls: getMethods, createPurchase, getStatus, uploadProof |
| `lib/features/payment/data/providers/payment_providers.dart` | Riverpod providers (repo, methods, current intent, status stream) |
| `lib/features/payment/presentation/screens/checkout_screen.dart` | Method selector + continue |
| `lib/features/payment/presentation/screens/manual_payment_screen.dart` | Bank details + upload bukti |
| `lib/features/payment/presentation/screens/va_waiting_screen.dart` | VA account number + status polling |
| `lib/features/payment/presentation/screens/payment_success_screen.dart` | Confirmation |
| `lib/features/payment/presentation/widgets/payment_method_card.dart` | Radio card with logo + fee disclosure |
| `lib/features/payment/presentation/widgets/va_account_display.dart` | Bank logo + number + copy button + amount |
| `lib/features/payment/presentation/widgets/countdown_timer.dart` | Counts down expires_at |
| `lib/routing/app_router.dart` | Modify: add 4 payment routes |
| `lib/core/utils/clipboard.dart` | Helper for copy-to-clipboard with snackbar |

---

## Task 1: Models (Freezed)

**Files:**
- Create: `lib/features/payment/data/models/payment_method.dart`
- Create: `lib/features/payment/data/models/payment_intent.dart`
- Create: `lib/features/payment/data/models/purchase_status.dart`

- [ ] **Step 1: Create `PaymentMethod`**

```dart
// lib/features/payment/data/models/payment_method.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String provider, // 'manual' | 'automatic'
    required String label,
    @JsonKey(name: 'va_banks') List<String>? vaBanks,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    String? instructions,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

@freezed
class ManualBankDetails with _$ManualBankDetails {
  const factory ManualBankDetails({
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_holder') required String accountHolder,
  }) = _ManualBankDetails;

  factory ManualBankDetails.fromJson(Map<String, dynamic> json) =>
      _$ManualBankDetailsFromJson(json);
}
```

- [ ] **Step 2: Create `PaymentIntent`**

```dart
// lib/features/payment/data/models/payment_intent.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_intent.freezed.dart';
part 'payment_intent.g.dart';

@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    required String provider, // 'manual' | 'automatic'
    required String status, // 'awaiting_payment' | 'awaiting_proof' | 'confirmed' | 'expired'
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'va_account_number') String? vaAccountNumber,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String? instructions,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentFromJson(json);
}
```

- [ ] **Step 3: Create `PurchaseStatus`**

```dart
// lib/features/payment/data/models/purchase_status.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_status.freezed.dart';
part 'purchase_status.g.dart';

@freezed
class PurchaseStatus with _$PurchaseStatus {
  const factory PurchaseStatus({
    @JsonKey(name: 'purchase_id') required int purchaseId,
    required String status, // pending | confirmed | rejected | cancelled | expired
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required int amount,
    @JsonKey(name: 'va_account_number') String? vaAccountNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
  }) = _PurchaseStatus;

  factory PurchaseStatus.fromJson(Map<String, dynamic> json) =>
      _$PurchaseStatusFromJson(json);
}
```

- [ ] **Step 4: Generate Freezed**

```bash
cd /d/projects/Flutter/hyperarena
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/payment/data/models/
git commit -m "Payment P4b: PaymentMethod/Intent/Status freezed models"
```

---

## Task 2: Repository (dio HTTP calls)

**Files:**
- Create: `lib/features/payment/data/repositories/payment_repository.dart`

- [ ] **Step 1: Create repository**

```dart
// lib/features/payment/data/repositories/payment_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/payment_method.dart';
import '../models/payment_intent.dart';
import '../models/purchase_status.dart';

class PaymentRepository {
  PaymentRepository(this._dio);
  final Dio _dio;

  Future<List<PaymentMethod>> getAvailableMethods() async {
    final response = await _dio.get('/v1/marketplace/payment-methods');
    final methods = (response.data['methods'] as List)
        .map((j) => PaymentMethod.fromJson(j as Map<String, dynamic>))
        .toList();
    return methods;
  }

  Future<({int purchaseId, PaymentIntent intent})> createPurchase({
    required int productId,
    required String paymentMethod,
    Map<String, dynamic>? params,
  }) async {
    final response = await _dio.post(
      '/v1/marketplace/purchases',
      data: {
        'product_id': productId,
        'payment_method': paymentMethod,
        if (params != null) 'params': params,
      },
      options: Options(
        headers: {'Idempotency-Key': _generateUuidV4()},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return (
      purchaseId: data['purchase_id'] as int,
      intent: PaymentIntent.fromJson(data['payment_intent'] as Map<String, dynamic>),
    );
  }

  Future<PurchaseStatus> getStatus(int purchaseId) async {
    final response = await _dio.get('/v1/marketplace/purchases/$purchaseId');
    return PurchaseStatus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> uploadProof({
    required int purchaseId,
    required File proofFile,
    String? note,
  }) async {
    final form = FormData.fromMap({
      'proof': await MultipartFile.fromFile(proofFile.path),
      if (note != null) 'note': note,
    });
    await _dio.post(
      '/v1/marketplace/purchases/$purchaseId/proof',
      data: form,
    );
  }

  String _generateUuidV4() {
    // Tiny inline UUID v4; or use package:uuid if already in pubspec
    final rand = List.generate(16, (_) => DateTime.now().microsecondsSinceEpoch % 256);
    rand[6] = (rand[6] & 0x0f) | 0x40;
    rand[8] = (rand[8] & 0x3f) | 0x80;
    final hex = rand.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
```

If `package:uuid` is already in pubspec, replace `_generateUuidV4()` with `const Uuid().v4()`. Check `pubspec.yaml` first.

- [ ] **Step 2: Commit**

```bash
git add lib/features/payment/data/repositories/payment_repository.dart
git commit -m "Payment P4b: PaymentRepository (4 endpoints + idempotency key)"
```

---

## Task 3: Riverpod providers

**Files:**
- Create: `lib/features/payment/data/providers/payment_providers.dart`

- [ ] **Step 1: Create providers**

```dart
// lib/features/payment/data/providers/payment_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // existing
import '../models/payment_method.dart';
import '../models/purchase_status.dart';
import '../repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dio = ref.watch(dioProvider); // existing dio with auth interceptor
  return PaymentRepository(dio);
});

final availablePaymentMethodsProvider = FutureProvider<List<PaymentMethod>>((ref) async {
  return ref.watch(paymentRepositoryProvider).getAvailableMethods();
});

/// Polls purchase status every 3 seconds until confirmed/expired.
/// Caller MUST cancel by overriding scope or letting it dispose with the screen.
final purchaseStatusStreamProvider = StreamProvider.autoDispose
    .family<PurchaseStatus, int>((ref, purchaseId) async* {
  final repo = ref.watch(paymentRepositoryProvider);
  while (true) {
    try {
      final status = await repo.getStatus(purchaseId);
      yield status;
      if (status.status == 'confirmed' ||
          status.status == 'expired' ||
          status.status == 'cancelled' ||
          status.status == 'rejected') {
        return;
      }
    } catch (e) {
      // Swallow transient errors and keep polling
    }
    await Future<void>.delayed(const Duration(seconds: 3));
  }
});
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/payment/data/providers/payment_providers.dart
git commit -m "Payment P4b: Riverpod providers (repo, methods, status stream)"
```

---

## Task 4: `PaymentMethodCard` widget

**Files:**
- Create: `lib/features/payment/presentation/widgets/payment_method_card.dart`

- [ ] **Step 1: Create widget**

```dart
// lib/features/payment/presentation/widgets/payment_method_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isManual = method.provider == 'manual';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isManual ? Icons.account_balance : Icons.qr_code_2,
              size: 32,
              color: selected ? AppColors.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isManual
                        ? 'Transfer ke rekening klub, lalu upload bukti'
                        : 'Bayar via VA bank, otomatis terkonfirmasi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (!isManual && method.vaBanks != null && method.vaBanks!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Bank: ${method.vaBanks!.join(", ")}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/payment/presentation/widgets/payment_method_card.dart
git commit -m "Payment P4b: PaymentMethodCard widget"
```

---

## Task 5: `CheckoutScreen`

**Files:**
- Create: `lib/features/payment/presentation/screens/checkout_screen.dart`

- [ ] **Step 1: Create screen**

```dart
// lib/features/payment/presentation/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/payment_method.dart';
import '../../data/providers/payment_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.productId,
    required this.productLabel,
    required this.amount,
  });

  final int productId;
  final String productLabel;
  final int amount;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod? _selected;
  String? _selectedBank;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(availablePaymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: methodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat metode: $e')),
        data: (methods) {
          if (methods.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada metode pembayaran tersedia. Hubungi admin klub.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OrderSummaryCard(label: widget.productLabel, amount: widget.amount),
                const SizedBox(height: 24),
                const Text(
                  'Pilih metode pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...methods.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PaymentMethodCard(
                    method: m,
                    selected: _selected?.provider == m.provider,
                    onTap: () => setState(() {
                      _selected = m;
                      _selectedBank = m.vaBanks?.first;
                    }),
                  ),
                )),
                if (_selected?.provider == 'automatic' && _selected!.vaBanks != null) ...[
                  const SizedBox(height: 8),
                  const Text('Pilih Bank', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _selected!.vaBanks!.map((bank) {
                      final isSelected = _selectedBank == bank;
                      return ChoiceChip(
                        label: Text(bank),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedBank = bank),
                        selectedColor: AppColors.primary50,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: methodsAsync.maybeWhen(
        data: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _canSubmit() && !_submitting ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(_submitting ? 'Memproses...' : 'Lanjut Bayar'),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  bool _canSubmit() {
    if (_selected == null) return false;
    if (_selected!.provider == 'automatic') return _selectedBank != null;
    return true;
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final result = await ref.read(paymentRepositoryProvider).createPurchase(
        productId: widget.productId,
        paymentMethod: _selected!.provider,
        params: _selected!.provider == 'automatic'
            ? {'bank_code': _selectedBank}
            : null,
      );

      if (!mounted) return;

      if (_selected!.provider == 'manual') {
        context.push('/payment/manual/${result.purchaseId}', extra: {
          'amount': widget.amount,
          'bankDetails': _selected!.bankDetails,
          'instructions': _selected!.instructions,
        });
      } else {
        context.push('/payment/va/${result.purchaseId}', extra: {
          'amount': widget.amount,
          'intent': result.intent,
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.label, required this.amount});
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            'Rp ${_formatRupiah(amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int v) {
    return v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
```

(Import `PaymentMethodCard` from Task 4.)

- [ ] **Step 2: Commit**

```bash
git add lib/features/payment/presentation/screens/checkout_screen.dart
git commit -m "Payment P4b: CheckoutScreen with method selector + bank chips"
```

---

## Task 6: `ManualPaymentScreen` (bank details + upload bukti)

**Files:**
- Create: `lib/features/payment/presentation/screens/manual_payment_screen.dart`
- Create: `lib/core/utils/clipboard.dart` (if not exists)

- [ ] **Step 1: Create clipboard helper**

```dart
// lib/core/utils/clipboard.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> copyToClipboard(BuildContext context, String value, {String? message}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Disalin: $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
```

- [ ] **Step 2: Create screen**

```dart
// lib/features/payment/presentation/screens/manual_payment_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/clipboard.dart';
import '../../data/models/payment_method.dart';
import '../../data/providers/payment_providers.dart';

class ManualPaymentScreen extends ConsumerStatefulWidget {
  const ManualPaymentScreen({
    super.key,
    required this.purchaseId,
    required this.amount,
    required this.bankDetails,
    this.instructions,
  });

  final int purchaseId;
  final int amount;
  final ManualBankDetails bankDetails;
  final String? instructions;

  @override
  ConsumerState<ManualPaymentScreen> createState() =>
      _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends ConsumerState<ManualPaymentScreen> {
  File? _proofFile;
  bool _uploading = false;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer Manual')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AmountBox(amount: widget.amount),
            const SizedBox(height: 16),
            _BankDetailsCard(details: widget.bankDetails),
            if (widget.instructions != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(widget.instructions!),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Upload Bukti Transfer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _ProofUploadArea(
              file: _proofFile,
              onPick: _pickProof,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _proofFile == null || _uploading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(_uploading ? 'Mengirim...' : 'Kirim Bukti'),
        ),
      ),
    );
  }

  Future<void> _pickProof() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _proofFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    setState(() => _uploading = true);
    try {
      await ref.read(paymentRepositoryProvider).uploadProof(
        purchaseId: widget.purchaseId,
        proofFile: _proofFile!,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );
      if (!mounted) return;
      context.go('/payment/success/${widget.purchaseId}?status=awaiting_review');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload gagal: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}

class _AmountBox extends StatelessWidget {
  const _AmountBox({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Total Pembayaran'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rp ${amount.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => copyToClipboard(context, amount.toString(),
                    message: 'Jumlah disalin'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BankDetailsCard extends StatelessWidget {
  const _BankDetailsCard({required this.details});
  final ManualBankDetails details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(details.bankName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No. Rekening',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(details.accountNumber,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copyToClipboard(context, details.accountNumber,
                    message: 'Nomor rekening disalin'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Atas Nama: ${details.accountHolder}',
              style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProofUploadArea extends StatelessWidget {
  const _ProofUploadArea({required this.file, required this.onPick});
  final File? file;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: file != null ? 200 : 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(file!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  const Text('Pilih bukti transfer dari galeri'),
                ],
              ),
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/payment/presentation/screens/manual_payment_screen.dart lib/core/utils/clipboard.dart
git commit -m "Payment P4b: ManualPaymentScreen (bank details + image upload)"
```

---

## Task 7: `VaWaitingScreen` (account + polling)

**Files:**
- Create: `lib/features/payment/presentation/screens/va_waiting_screen.dart`
- Create: `lib/features/payment/presentation/widgets/va_account_display.dart`
- Create: `lib/features/payment/presentation/widgets/countdown_timer.dart`

- [ ] **Step 1: Create countdown timer widget**

```dart
// lib/features/payment/presentation/widgets/countdown_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.expiresAt});
  final DateTime expiresAt;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

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
    final remaining = widget.expiresAt.difference(DateTime.now());
    setState(() => _remaining = remaining.isNegative ? Duration.zero : remaining);
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
        color: expired ? Colors.red : Colors.amber.shade800,
      ),
    );
  }
}
```

- [ ] **Step 2: Create VA account display widget**

```dart
// lib/features/payment/presentation/widgets/va_account_display.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/clipboard.dart';

class VaAccountDisplay extends StatelessWidget {
  const VaAccountDisplay({
    super.key,
    required this.bank,
    required this.accountNumber,
    required this.amount,
  });

  final String bank;
  final String accountNumber;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Virtual Account $bank',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                accountNumber,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copyToClipboard(context, accountNumber,
                    message: 'Nomor VA disalin'),
              ),
            ],
          ),
          const Divider(height: 24),
          Text('Total Bayar',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(
            'Rp ${amount.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Create screen**

```dart
// lib/features/payment/presentation/screens/va_waiting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/payment_intent.dart';
import '../../data/providers/payment_providers.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/va_account_display.dart';

class VaWaitingScreen extends ConsumerWidget {
  const VaWaitingScreen({
    super.key,
    required this.purchaseId,
    required this.amount,
    required this.intent,
  });

  final int purchaseId;
  final int amount;
  final PaymentIntent intent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(purchaseStatusStreamProvider(purchaseId));

    // Auto-navigate on confirmation
    ref.listen(purchaseStatusStreamProvider(purchaseId), (prev, next) {
      next.whenData((status) {
        if (status.status == 'confirmed') {
          context.go('/payment/success/$purchaseId?status=confirmed');
        } else if (status.status == 'expired') {
          context.go('/payment/success/$purchaseId?status=expired');
        }
      });
    });

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
              bank: intent.vaBank ?? '',
              accountNumber: intent.vaAccountNumber ?? '',
              amount: amount,
            ),
            const SizedBox(height: 16),
            if (intent.expiresAt != null)
              Center(child: CountdownTimer(expiresAt: intent.expiresAt!)),
            const SizedBox(height: 24),
            const _InstructionsBlock(),
            const SizedBox(height: 24),
            statusAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Cek status: $e',
                  style: const TextStyle(color: Colors.red)),
              data: (status) => Row(
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
                  const Text('Menunggu pembayaran... otomatis terkonfirmasi'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Bayar Nanti'),
            ),
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
          Text('Cara Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('1. Buka aplikasi mobile banking / ATM bank Anda'),
          Text('2. Pilih menu Virtual Account / Transfer VA'),
          Text('3. Masukkan nomor VA di atas'),
          Text('4. Konfirmasi jumlah pembayaran'),
          Text('5. Selesaikan transaksi — akan terkonfirmasi otomatis'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/payment/presentation/screens/va_waiting_screen.dart \
  lib/features/payment/presentation/widgets/countdown_timer.dart \
  lib/features/payment/presentation/widgets/va_account_display.dart
git commit -m "Payment P4b: VaWaitingScreen with countdown + polling + auto-navigate"
```

---

## Task 8: `PaymentSuccessScreen`

**Files:**
- Create: `lib/features/payment/presentation/screens/payment_success_screen.dart`

- [ ] **Step 1: Create screen**

```dart
// lib/features/payment/presentation/screens/payment_success_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.purchaseId,
    required this.status,
  });

  final int purchaseId;
  final String status; // 'confirmed' | 'awaiting_review' | 'expired'

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, subtitle) = switch (status) {
      'confirmed' => (
        Icons.check_circle,
        Colors.green,
        'Pembayaran Berhasil',
        'Sesi Anda sudah terkonfirmasi.',
      ),
      'awaiting_review' => (
        Icons.access_time,
        Colors.amber,
        'Menunggu Verifikasi',
        'Bukti transfer terkirim. Admin akan verifikasi dalam 1×24 jam.',
      ),
      'expired' => (
        Icons.cancel,
        Colors.red,
        'Pembayaran Kedaluwarsa',
        'Silakan booking ulang jika ingin melanjutkan.',
      ),
      _ => (
        Icons.info,
        Colors.grey,
        'Status Tidak Diketahui',
        'Hubungi admin jika ada masalah.',
      ),
    };

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/payment/presentation/screens/payment_success_screen.dart
git commit -m "Payment P4b: PaymentSuccessScreen (3 status variants)"
```

---

## Task 9: Wire routes

**Files:**
- Modify: `lib/routing/app_router.dart`

- [ ] **Step 1: Add 4 routes**

In `lib/routing/app_router.dart` add inside top-level routes list:

```dart
GoRoute(
  path: '/payment/checkout',
  builder: (ctx, state) {
    final extra = state.extra as Map<String, dynamic>;
    return CheckoutScreen(
      productId: extra['productId'] as int,
      productLabel: extra['productLabel'] as String,
      amount: extra['amount'] as int,
    );
  },
),
GoRoute(
  path: '/payment/manual/:purchaseId',
  builder: (ctx, state) {
    final extra = state.extra as Map<String, dynamic>;
    return ManualPaymentScreen(
      purchaseId: int.parse(state.pathParameters['purchaseId']!),
      amount: extra['amount'] as int,
      bankDetails: extra['bankDetails'] as ManualBankDetails,
      instructions: extra['instructions'] as String?,
    );
  },
),
GoRoute(
  path: '/payment/va/:purchaseId',
  builder: (ctx, state) {
    final extra = state.extra as Map<String, dynamic>;
    return VaWaitingScreen(
      purchaseId: int.parse(state.pathParameters['purchaseId']!),
      amount: extra['amount'] as int,
      intent: extra['intent'] as PaymentIntent,
    );
  },
),
GoRoute(
  path: '/payment/success/:purchaseId',
  builder: (ctx, state) => PaymentSuccessScreen(
    purchaseId: int.parse(state.pathParameters['purchaseId']!),
    status: state.uri.queryParameters['status'] ?? 'confirmed',
  ),
),
```

Add imports at top of `app_router.dart`:
```dart
import '../features/payment/data/models/payment_intent.dart';
import '../features/payment/data/models/payment_method.dart';
import '../features/payment/presentation/screens/checkout_screen.dart';
import '../features/payment/presentation/screens/manual_payment_screen.dart';
import '../features/payment/presentation/screens/va_waiting_screen.dart';
import '../features/payment/presentation/screens/payment_success_screen.dart';
```

- [ ] **Step 2: Commit**

```bash
git add lib/routing/app_router.dart
git commit -m "Payment P4b: register 4 payment routes in app_router"
```

---

## Task 10: Wire CheckoutScreen entry from existing booking flow

**Files:**
- Modify: existing booking confirm screen (likely under `lib/features/booking/` or `lib/features/session/`)

- [ ] **Step 1: Find existing "book session" trigger**

```bash
cd /d/projects/Flutter/hyperarena
```

Use Grep tool to find where a booking is currently triggered (look for `bookSession`, `confirmBooking`, or similar API call). Replace that direct call with a navigation to `/payment/checkout`.

- [ ] **Step 2: Update existing booking screen**

Replace the existing "Konfirmasi Booking" / "Bayar Sekarang" button's onPressed:
```dart
onPressed: () {
  context.push('/payment/checkout', extra: {
    'productId': product.id, // or sessionProduct.id
    'productLabel': product.name,
    'amount': product.price,
  });
},
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/<modified file>
git commit -m "Payment P4b: route existing booking flow to /payment/checkout"
```

---

## Task 11: Build + manual test on Samsung Tab S9

**Files:** none (verification)

- [ ] **Step 1: Verify everything compiles**

```bash
flutter analyze
```

- [ ] **Step 2: Build dev APK**

```bash
flutter build apk --flavor dev --dart-define=API_BASE_URL=https://api-dev.hyperarena.hyperscore.cloud/api
```

(Or whatever existing build command matches `lib/main_dev.dart`.)

- [ ] **Step 3: Rename + install**

```bash
cp build/app/outputs/flutter-apk/app-dev-release.apk \
   releases/hyperarena-dev-payment-v1.apk
# Transfer to Samsung Tab S9 + install
```

- [ ] **Step 4: Smoke test scenarios**

Test as a member user on a tenant with both methods enabled in dev:

- ☐ Open existing session → tap Booking → reaches Checkout screen
- ☐ Checkout shows 2 method cards: "Transfer Manual" + "Virtual Account otomatis"
- ☐ Select Manual → continue → ManualPaymentScreen shows bank name, account number, amount, copy buttons work
- ☐ Pick image from gallery → tap "Kirim Bukti" → reaches Success "Menunggu Verifikasi"
- ☐ Back to checkout → Select Automatic → select BCA chip → continue → VaWaitingScreen shows VA number from Xendit sandbox
- ☐ Countdown timer ticks down from 24:00:00
- ☐ Trigger Xendit sandbox simulator from dashboard
- ☐ Within 3 seconds, polling detects confirmed → auto-navigates to Success "Pembayaran Berhasil"

Tenant with only manual enabled:
- ☐ Checkout shows only "Transfer Manual" card
- ☐ "Virtual Account" not visible at all

Tenant with no methods enabled (admin disabled both):
- ☐ Checkout shows "Belum ada metode pembayaran tersedia"

Branding check (visual scan every screen):
- ☐ No "Xendit" text anywhere
- ☐ All Indonesian copy
- ☐ HyperArena teal primary color throughout

---

## P4b Self-Verification Checklist

- [ ] `flutter analyze` zero errors / zero warnings related to new code
- [ ] All 4 routes navigate correctly
- [ ] Polling stops cleanly when screen disposes (no zombie timers in DevTools)
- [ ] Image upload works on Android (permissions OK)
- [ ] Clipboard copy works on Android
- [ ] Countdown survives orientation rotation (not critical, but verify)
- [ ] **No "Xendit" string anywhere in `lib/features/payment/`** — grep `Xendit` in lib/
- [ ] All copy strings are Indonesian (no English fallthroughs)

---

## P4b Spec Coverage

- §9.1 Method selector screen
- §9.2 Manual payment flow (bank display + upload)
- §9.3 VA waiting flow (account display + countdown + poll)
- §9.4 Success/awaiting-review/expired states
- §3 Branding — verified by grep
- §11 Mobile security: idempotency-key on createPurchase, no provider names in UI

Deferred to post-P4b: push notification on VA paid (graceful degradation — polling already covers this), QRIS/eWallet UI (P5), payment history screen.

---

## Final P4b Deployment

After local smoke test green on Samsung Tab S9, push develop:

```bash
git push origin develop
```

Tag release:
```bash
git tag mobile-v1.payment-2026-06-01
git push origin mobile-v1.payment-2026-06-01
```

Update `releases/CHANGELOG.md` (if exists) with payment system entry.
