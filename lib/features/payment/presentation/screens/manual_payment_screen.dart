import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/clipboard.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/payment_method.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:image_picker/image_picker.dart';

class ManualPaymentScreen extends ConsumerStatefulWidget {
  const ManualPaymentScreen({
    super.key,
    required this.purchaseId,
    required this.amount,
    required this.bankDetails,
    this.sessionId,
    this.sessionLabel,
    this.sessionStartAt,
    this.venueName,
    this.paymentMethodLabel,
  });

  final int purchaseId;
  final int amount;
  final ManualBankDetails bankDetails;
  final int? sessionId;
  final String? sessionLabel;
  final DateTime? sessionStartAt;
  final String? venueName;
  final String? paymentMethodLabel;

  @override
  ConsumerState<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Setelah transfer, upload bukti pembayaran. Admin akan memverifikasi dalam maksimal 1×24 jam.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upload Bukti Transfer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _ProofUploadArea(file: _proofFile, onPick: _pickProof),
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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _proofFile == null || _uploading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: Text(_uploading ? 'Mengirim...' : 'Kirim Bukti'),
        ),
      ),
    );
  }

  Future<void> _pickProof() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null && mounted) {
      setState(() => _proofFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_proofFile == null) return;
    setState(() => _uploading = true);

    try {
      await ref.read(paymentRepositoryProvider).uploadProof(
        purchaseId: widget.purchaseId,
        proofFile: _proofFile!,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );
      if (!mounted) return;
      context.go(
        '/payment/success/${widget.purchaseId}?status=awaiting_review',
        extra: {
          'sessionId': widget.sessionId,
          'sessionLabel': widget.sessionLabel,
          'sessionStartAt': widget.sessionStartAt,
          'venueName': widget.venueName,
          'amount': widget.amount,
          'paymentMethodLabel': widget.paymentMethodLabel,
        },
      );
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
                Formatters.formatCurrency(amount, 'IDR'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => copyToClipboard(
                  context,
                  amount.toString(),
                  message: 'Nominal disalin',
                ),
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
          Text(
            details.bankName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No. Rekening',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      details.accountNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copyToClipboard(
                  context,
                  details.accountNumber,
                  message: 'Nomor rekening disalin',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Atas Nama: ${details.accountHolder}', style: const TextStyle(fontSize: 13)),
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
          border: Border.all(color: Colors.grey.shade400),
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
