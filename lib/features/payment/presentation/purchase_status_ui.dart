import 'package:flutter/material.dart';

/// Single source for user-facing purchase status chips: (label, color).
/// Used by the purchase list and purchase detail so new statuses (and their
/// wording) can never drift between screens again.
(String, Color) purchaseStatusUi(String status) => switch (status) {
      'pending_payment' => ('Menunggu Pembayaran', Colors.amber.shade700),
      'pending_confirmation' => (
          'Menunggu Verifikasi Admin',
          Colors.amber.shade700,
        ),
      'confirmed' => ('Berhasil', Colors.green.shade700),
      'cancelled' => ('Dibatalkan', Colors.grey.shade600),
      'expired' => ('Kedaluwarsa', Colors.red.shade600),
      'rejected' => ('Ditolak', Colors.red.shade800),
      _ => (status, Colors.grey),
    };
