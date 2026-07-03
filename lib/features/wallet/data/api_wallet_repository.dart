import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_summary.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';

/// One repo for all coach wallet traffic — summary, per-session feed,
/// withdrawal request lifecycle. Mirrors BE branch feature/coach-wallet-earnings.
class ApiWalletRepository {
  ApiWalletRepository(this._apiClient);
  final ApiClient _apiClient;

  /// `GET /v1/coach/payouts/summary?period=YYYY-MM` — 4-bucket aggregation
  /// + session count + active request ID for CTA gating.
  Future<CoachPayoutSummary> getSummary(String period) async {
    try {
      final res = await _apiClient.get(
        '/v1/coach/payouts/summary',
        queryParameters: {'period': period},
      );
      return CoachPayoutSummary.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// `GET /v1/coach/payouts/balance` — cumulative all-months buckets +
  /// withdrawable periods. Drives the always-visible hero / chips / CTA.
  Future<CoachPayoutBalance> getBalance() async {
    try {
      final res = await _apiClient.get('/v1/coach/payouts/balance');
      return CoachPayoutBalance.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// `GET /v1/coach/payouts?period=YYYY-MM` — paginated; we fetch the first
  /// 50 (typical coach has ~15 sessions/month, headroom for outliers).
  Future<List<CoachPayout>> getPayouts(String period) async {
    try {
      final res = await _apiClient.get(
        '/v1/coach/payouts',
        queryParameters: {'period': period, 'per_page': 50},
      );
      final data = (res.data as Map<String, dynamic>)['data'] as List<dynamic>;
      return data
          .map((j) => CoachPayout.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// `POST /v1/coach/payout-requests` — coach taps "Cairkan Rp X".
  /// 409 → active request already exists. 422 → no pending payouts.
  Future<PayoutRequest> requestWithdrawal(String period) async {
    try {
      final res = await _apiClient.post(
        '/v1/coach/payout-requests',
        data: {'period': period},
      );
      return PayoutRequest.fromJson(
        (res.data as Map<String, dynamic>)['request'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// `GET /v1/coach/payout-requests` — list of past requests (paginated).
  /// Used by Withdrawal History screen.
  Future<List<PayoutRequest>> getWithdrawalHistory({
    String? period,
    String? status,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/coach/payout-requests',
        queryParameters: {
          'period': ?period,
          'status': ?status,
          'per_page': 30,
        },
      );
      final data = (res.data as Map<String, dynamic>)['data'] as List<dynamic>;
      return data
          .map((j) => PayoutRequest.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// `GET /v1/coach/payout-requests/{id}` — single request with linked
  /// payouts and rejection_note (when status=rejected).
  Future<PayoutRequest> getWithdrawalDetail(int id) async {
    try {
      final res = await _apiClient.get('/v1/coach/payout-requests/$id');
      return PayoutRequest.fromJson(
        (res.data as Map<String, dynamic>)['request'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
