// lib/features/auth/presentation/screens/tenant_picker_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

class TenantPickerScreen extends ConsumerStatefulWidget {
  const TenantPickerScreen({super.key});

  @override
  ConsumerState<TenantPickerScreen> createState() => _TenantPickerScreenState();
}

class _TenantPickerScreenState extends ConsumerState<TenantPickerScreen> {
  final _searchController = TextEditingController();
  List<TenantSummary> _tenants = [];
  bool _isLoading = true;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadTenants({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repo = ref.read(tenantRepositoryProvider);
      final tenants = await repo.getTenants(search: search);
      if (mounted) {
        setState(() {
          _tenants = tenants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat daftar tenant';
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadTenants(search: query.isEmpty ? null : query);
    });
  }

  Future<void> _selectTenant(TenantSummary tenant) async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.saveTenantSlug(tenant.slug);
    ref.read(tenantSlugProvider.notifier).state = tenant.slug;
    if (mounted) {
      context.go(AppRoutes.organizerDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Tenant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari tenant...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: AppTypography.bodyMedium),
                            const SizedBox(height: AppDimensions.sm),
                            TextButton(
                              onPressed: () => _loadTenants(),
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                      )
                    : _tenants.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada tenant ditemukan',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding:
                                const EdgeInsets.all(AppDimensions.base),
                            itemCount: _tenants.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppDimensions.sm),
                            itemBuilder: (_, index) {
                              final tenant = _tenants[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  backgroundImage: tenant.logoUrl != null
                                      ? NetworkImage(tenant.logoUrl!)
                                      : null,
                                  child: tenant.logoUrl == null
                                      ? Text(
                                          tenant.name[0].toUpperCase(),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(tenant.name,
                                    style: AppTypography.bodyMedium
                                        .copyWith(
                                            fontWeight: FontWeight.w600)),
                                subtitle: Text(tenant.slug,
                                    style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary)),
                                trailing:
                                    const Icon(Icons.chevron_right),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusSm),
                                  side: BorderSide(
                                      color: AppColors.neutral200),
                                ),
                                onTap: () => _selectTenant(tenant),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
