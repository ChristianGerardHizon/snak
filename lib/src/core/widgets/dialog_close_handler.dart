import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Handles keyboard escape key for dialog dismissal.
///
/// Wraps dialog content to intercept Escape key presses and either:
/// - Close immediately (if [onClose] is null or returns true)
/// - Show confirmation dialog (if [onClose] returns false initially)
///
/// Usage with dirty guard:
/// ```dart
/// return DialogCloseHandler(
///   onClose: (ctx) => dirtyGuard.confirmDiscard(ctx),
///   child: PopScope(
///     canPop: false,
///     onPopInvokedWithResult: dirtyGuard.onPopInvokedWithResult,
///     child: Column(/* dialog content */),
///   ),
/// );
/// ```
///
/// Usage without dirty guard (immediate close):
/// ```dart
/// return DialogCloseHandler(
///   child: Column(/* dialog content */),
/// );
/// ```
class DialogCloseHandler extends StatelessWidget {
  const DialogCloseHandler({
    super.key,
    required this.child,
    this.onClose,
    this.enabled = true,
  });

  /// The dialog content to wrap.
  final Widget child;

  /// Called when user presses Escape.
  /// Returns true to close, false to prevent closing.
  /// If null, defaults to immediate close.
  final Future<bool> Function(BuildContext context)? onClose;

  /// Whether escape key handling is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) async {
              if (onClose != null) {
                final shouldClose = await onClose!(context);
                if (shouldClose && context.mounted) {
                  context.pop();
                }
              } else {
                context.pop();
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
