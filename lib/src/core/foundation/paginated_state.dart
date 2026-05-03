/// Generic state for paginated data.
///
/// Holds the current list of items along with pagination metadata.
class PaginatedState<T> {
  const PaginatedState({
    required this.items,
    this.currentPage = 1,
    this.totalItems = 0,
    this.totalPages = 0,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  /// The loaded items.
  final List<T> items;

  /// Current page number (1-indexed).
  final int currentPage;

  /// Total number of items available.
  final int totalItems;

  /// Total number of pages.
  final int totalPages;

  /// Whether more items are currently being loaded.
  final bool isLoadingMore;

  /// Whether all items have been loaded.
  final bool hasReachedEnd;

  /// Returns true if there are more pages to load.
  bool get hasMore => currentPage < totalPages && !hasReachedEnd;

  /// Returns true if the list is empty.
  bool get isEmpty => items.isEmpty;

  /// Returns the number of loaded items.
  int get loadedCount => items.length;

  /// Creates initial empty state.
  factory PaginatedState.initial() => PaginatedState<T>(items: const []);

  /// Creates a copy with updated values.
  PaginatedState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalItems,
    int? totalPages,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  /// Appends new items to existing list.
  PaginatedState<T> appendItems(
    List<T> newItems, {
    required int page,
    required int totalItems,
    required int totalPages,
  }) {
    final hasReachedEnd = page >= totalPages;
    return copyWith(
      items: [...items, ...newItems],
      currentPage: page,
      totalItems: totalItems,
      totalPages: totalPages,
      isLoadingMore: false,
      hasReachedEnd: hasReachedEnd,
    );
  }

  /// Prepends a new item to the list (for create operations).
  PaginatedState<T> prependItem(T item) {
    return copyWith(
      items: [item, ...items],
      totalItems: totalItems + 1,
    );
  }

  /// Updates an item in the list.
  PaginatedState<T> updateItem(T item, bool Function(T) predicate) {
    final updatedItems = items.map((i) => predicate(i) ? item : i).toList();
    return copyWith(items: updatedItems);
  }

  /// Removes an item from the list.
  PaginatedState<T> removeItem(bool Function(T) predicate) {
    final filteredItems = items.where((i) => !predicate(i)).toList();
    return copyWith(
      items: filteredItems,
      totalItems: totalItems > 0 ? totalItems - 1 : 0,
    );
  }
}
