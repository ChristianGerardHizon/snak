import 'package:flutter/material.dart';

/// Modal loading dialog shown during PDF generation.
///
/// Displays an indeterminate progress indicator with a cancel button.
/// Blocks the Android back button via [PopScope].
class PdfLoadingOverlay extends StatelessWidget {
  const PdfLoadingOverlay({
    super.key,
    required this.message,
    required this.onCancel,
  });

  final String message;
  final VoidCallback onCancel;

  /// Shows the overlay as a modal dialog and returns the dialog's [BuildContext]
  /// so the caller can dismiss it via [Navigator.pop].
  static Future<void> show(
    BuildContext context, {
    required String message,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => PdfLoadingOverlay(
        message: message,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
