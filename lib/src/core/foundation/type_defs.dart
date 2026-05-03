import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// JSON object type alias
typedef Json = Map<String, dynamic>;

/// JSON array type alias
typedef JsonList = List<Json>;

/// Future that returns Either<Failure, T>
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Async callback with no parameters
typedef AsyncCallback = Future<void> Function();

/// Async callback with a value parameter
typedef AsyncValueCallback<T> = Future<void> Function(T value);

/// Callback that returns a value
typedef ValueCallback<T> = void Function(T value);

/// Result from a paginated query.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.page,
    required this.totalItems,
    required this.totalPages,
  });

  /// The items for this page.
  final List<T> items;

  /// Current page number (1-indexed).
  final int page;

  /// Total number of items available.
  final int totalItems;

  /// Total number of pages.
  final int totalPages;

  /// Returns true if there are more pages to load.
  bool get hasMore => page < totalPages;
}

/// Future that returns Either<Failure, PaginatedResult<T>>
typedef FutureEitherPaginated<T> = Future<Either<Failure, PaginatedResult<T>>>;
