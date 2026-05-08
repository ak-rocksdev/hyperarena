/// Generic cursor-paginated response from marketplace API.
class CursorPage<T> {
  final List<T> items;
  final String? nextCursor;
  final int perPage;

  /// Total matching rows across all pages. Optional — endpoints that
  /// don't compute it return null and callers fall back to
  /// `items.length` for display.
  final int? total;

  const CursorPage({
    required this.items,
    this.nextCursor,
    required this.perPage,
    this.total,
  });

  bool get hasMore => nextCursor != null;

  /// Parse a Laravel cursorPaginate() JSON response.
  static CursorPage<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = (json['data'] as List).cast<Map<String, dynamic>>();
    return CursorPage(
      items: data.map(fromJson).toList(),
      nextCursor: json['next_cursor'] as String?,
      perPage: json['per_page'] as int? ?? 15,
      total: (json['total'] as num?)?.toInt(),
    );
  }
}
