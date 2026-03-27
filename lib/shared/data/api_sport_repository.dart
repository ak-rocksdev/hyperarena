import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/shared/data/models/sport_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cacheKey = 'marketplace_sports';

class ApiSportRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  ApiSportRepository(this._apiClient, this._prefs);

  /// Returns cached sports immediately, or fetches from API.
  List<SportFilter> getCached() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map(SportFilter.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches sports from API and updates cache. Returns the fresh list.
  Future<List<SportFilter>> fetchAndCache() async {
    try {
      final response = await _apiClient.get('/v1/marketplace/sports');
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List).cast<Map<String, dynamic>>();
      final sports = list.map(SportFilter.fromJson).toList();
      // Cache as JSON string
      _prefs.setString(_cacheKey, jsonEncode(list));
      return sports;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
