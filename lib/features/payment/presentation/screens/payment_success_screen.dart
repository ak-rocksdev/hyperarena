import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';

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
        'Sesi Anda sudah terkonfirmasi. Sampai jumpa di lapangan!',
      ),
      'awaiting_review' => (
        Icons.access_time,
        Colors.amber,
        'Menunggu Verifikasi',
        'Bukti transfer terkirim. Admin akan memverifikasi dalam maksimal 1×24 jam.',
      ),
      'expired' => (
        Icons.cancel,
        Colors.red,
        'Pembayaran Kedaluwarsa',
        'Waktu pembayaran sudah habis. Silakan booking ulang jika ingin melanjutkan.',
      ),
      _ => (
        Icons.info,
        Colors.grey,
        'Status Tidak Diketahui',
        'Hubungi admin klub jika ada masalah.',
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
