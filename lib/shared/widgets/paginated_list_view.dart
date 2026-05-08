import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/load_more_error_tile.dart';

/// Cursor-paginated `ListView.builder` with the standard footer
/// behavior: spinner while a page is loading, retry tile when the last
/// page failed. Pairs with `MarketplaceListNotifier` — pass its state
/// fields (`items`, `isLoadingMore`, `loadMoreError`) and wire `onRetry`
/// to its `retryLoadMore`.
class PaginatedListView<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final ScrollController controller;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.controller,
    required this.onRefresh,
    required this.onRetry,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final hasFooter = isLoadingMore || loadMoreError != null;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
            ),
        itemCount: items.length + (hasFooter ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= items.length) {
            return loadMoreError != null
                ? LoadMoreErrorTile(onRetry: onRetry)
                : const ListLoadingIndicator();
          }
          return itemBuilder(context, items[i]);
        },
      ),
    );
  }
}
