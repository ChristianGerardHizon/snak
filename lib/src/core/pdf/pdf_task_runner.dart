import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/pdf_loading_overlay.dart';

/// Result of a PDF generation task.
sealed class PdfTaskResult {}

/// PDF was generated successfully.
class PdfTaskSuccess extends PdfTaskResult {
  PdfTaskSuccess(this.bytes);
  final Uint8List bytes;
}

/// PDF generation was cancelled by the user.
class PdfTaskCancelled extends PdfTaskResult {}

/// Orchestrates PDF generation with a loading overlay.
///
/// 1. Shows a [PdfLoadingOverlay] dialog.
/// 2. Runs [preload] on the main thread (e.g. loading assets via rootBundle).
/// 3. Runs [generate] on the main thread to build the PDF bytes.
/// 4. Dismisses the overlay and returns the result.
///
/// Generation runs on the main thread because the `pdf` package relies on
/// internal state (font management, etc.) that does not survive isolate
/// serialization on desktop platforms, causing crashes on macOS/Windows.
/// The overlay still provides visual feedback while awaiting the future.
///
/// If the user cancels, the result is [PdfTaskCancelled] and the overlay
/// is dismissed immediately.
Future<PdfTaskResult> runPdfTask<P>({
  required BuildContext context,
  required String message,
  required Future<P> Function() preload,
  required FutureOr<Uint8List> Function(P payload) generate,
}) async {
  var cancelled = false;
  final navigatorState = Navigator.of(context, rootNavigator: true);

  // Show overlay (non-blocking — the dialog future completes when dismissed)
  unawaited(
    PdfLoadingOverlay.show(
      navigatorState.context,
      message: message,
      onCancel: () {
        cancelled = true;
        navigatorState.pop();
      },
    ),
  );

  try {
    // Phase 1: Preload (main thread)
    final payload = await preload();
    if (cancelled) return PdfTaskCancelled();

    // Phase 2: Generate PDF bytes (main thread)
    final bytes = await generate(payload);
    if (cancelled) return PdfTaskCancelled();

    return PdfTaskSuccess(bytes);
  } finally {
    // Dismiss overlay if still showing
    if (!cancelled && navigatorState.context.mounted) {
      navigatorState.pop();
    }
  }
}
