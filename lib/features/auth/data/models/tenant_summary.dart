import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_summary.freezed.dart';
part 'tenant_summary.g.dart';

@freezed
class TenantSummary with _$TenantSummary {
  const factory TenantSummary({
    required int id,
    required String name,
    required String slug,
    String? logoUrl,
  }) = _TenantSummary;

  factory TenantSummary.fromJson(Map<String, dynamic> json) =>
      _$TenantSummaryFromJson(json);
}
