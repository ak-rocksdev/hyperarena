import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';

abstract class TenantRepository {
  Future<List<TenantSummary>> getTenants({String? search});
}
