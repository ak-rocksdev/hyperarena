import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';
import 'package:hyperarena/features/auth/data/tenant_repository.dart';

class ApiTenantRepository implements TenantRepository {
  final ApiClient _apiClient;

  ApiTenantRepository(this._apiClient);

  @override
  Future<List<TenantSummary>> getTenants({String? search}) async {
    final response = await _apiClient.get('/v1/platform/tenants',
        queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
    });
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List<dynamic>;
    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final logoUrls = json['logo_urls'] as Map<String, dynamic>?;
      return TenantSummary(
        id: json['id'] as int,
        name: json['name'] as String,
        slug: json['slug'] as String,
        logoUrl: logoUrls?['md'] as String?,
      );
    }).toList();
  }
}
