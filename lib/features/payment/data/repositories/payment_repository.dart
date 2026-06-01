import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/models/payment_method.dart';
import 'package:hyperarena/features/payment/data/models/purchase_status.dart';

class PaymentRepository {
  PaymentRepository(this._apiClient);

  final ApiClient _apiClient;

  // ---------------------------------------------------------------------------
  // UUID v4 — inline generator (no `uuid` package in pubspec.yaml)
  // ---------------------------------------------------------------------------
  static String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    final h = bytes.map(hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }

  // ---------------------------------------------------------------------------
  // 1. Public endpoint — no auth required.
  // ---------------------------------------------------------------------------

  /// Returns the list of payment methods available for the given tenant.
  Future<List<PaymentMethod>> getAvailableMethods(String tenantSlug) async {
    try {
      final response = await _apiClient.get(
        '/v1/marketplace/tenants/$tenantSlug/payment-methods',
      );
      final methods = (response.data['methods'] as List)
          .map((json) => PaymentMethod.fromJson(json as Map<String, dynamic>))
          .toList();
      return methods;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 2. Auth required.
  // ---------------------------------------------------------------------------

  /// Creates a purchase intent.
  ///
  /// An [Idempotency-Key] header (UUID v4) is generated per call to prevent
  /// duplicate purchases on network retry.
  Future<PaymentIntent> createPurchase({
    required int productId,
    required int sessionId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _apiClient.post(
        '/v1/marketplace/purchases',
        data: {
          'product_id': productId,
          'session_id': sessionId,
          'payment_method': paymentMethod,
        },
        extraHeaders: {'Idempotency-Key': _generateUuidV4()},
      );
      return PaymentIntent.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Auth required. Polled by the VA waiting screen.
  // ---------------------------------------------------------------------------

  /// Returns the current status of a purchase.
  Future<PurchaseStatus> getStatus(int purchaseId) async {
    try {
      final response = await _apiClient.get(
        '/v1/marketplace/purchases/$purchaseId/status',
      );
      return PurchaseStatus.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 4. Auth required. Manual-transfer flow.
  // ---------------------------------------------------------------------------

  /// Uploads a transfer proof image for a manual-payment purchase.
  Future<void> uploadProof({
    required int purchaseId,
    required File proofFile,
    String? note,
  }) async {
    try {
      final form = FormData.fromMap({
        'proof': await MultipartFile.fromFile(proofFile.path),
        'note': ?note,
      });
      await _apiClient.post(
        '/v1/marketplace/purchases/$purchaseId/proof',
        data: form,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
