import 'package:flutter/material.dart';

/// Widget shown at the end of a paginated list.
///
/// Displays either a loading indicator (when loading more) or
/// an "End of the list" message (when all items are loaded).
class EndOfListIndicator extends StatelessWidget {
  const EndOfListIndicator({
    super.key,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    this.endMessage = 'End of the list',
    this.loadingMessage = 'Loading more...',
  });

  /// Whether more items are currently being loaded.
  final bool isLoadingMore;

  /// Whether all items have been loaded.
  final bool hasReachedEnd;

  /// Message to show when all items are loaded.
  final String endMessage;

  /// Message to show while loading.
  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                loadingMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hasReachedEnd) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 24,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                endMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
