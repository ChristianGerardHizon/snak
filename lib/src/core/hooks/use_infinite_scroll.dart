import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom hook for infinite scroll detection.
///
/// Returns a ScrollController that triggers [onLoadMore] when the user
/// scrolls near the bottom of the list.
///
/// Example:
/// ```dart
/// final scrollController = useInfiniteScroll(
///   onLoadMore: () => ref.read(controllerProvider.notifier).loadMore(),
///   hasMore: paginatedState.hasMore,
///   isLoading: paginatedState.isLoadingMore,
/// );
/// ```
ScrollController useInfiniteScroll({
  required VoidCallback onLoadMore,
  required bool hasMore,
  required bool isLoading,
  double threshold = 200.0,
}) {
  final scrollController = useScrollController();

  useEffect(() {
    void listener() {
      if (isLoading || !hasMore) return;

      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;

      if (maxScroll - currentScroll <= threshold) {
        onLoadMore();
      }
    }

    scrollController.addListener(listener);
    return () => scrollController.removeListener(listener);
  }, [hasMore, isLoading]);

  return scrollController;
}
