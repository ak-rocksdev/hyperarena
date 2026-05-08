import 'package:flutter/material.dart';

/// Wraps an arbitrary widget in a `SliverPersistentHeader(pinned: true)`
/// so it sticks to the top of a `CustomScrollView` once the user scrolls
/// past it. Caller gives a fixed height — the child must fit. Drop
/// shadow appears once content scrolls underneath.
class PinnedListHeader extends StatelessWidget {
  final Widget child;
  final double height;
  final Color background;

  const PinnedListHeader({
    super.key,
    required this.child,
    required this.height,
    this.background = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHeaderDelegate(
        child: child,
        height: height,
        background: background,
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final Color background;

  const _PinnedHeaderDelegate({
    required this.child,
    required this.height,
    required this.background,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: background,
      elevation: overlapsContent ? 2 : 0,
      child: SizedBox(height: height, child: child),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) =>
      oldDelegate.height != height ||
      oldDelegate.child != child ||
      oldDelegate.background != background;
}
