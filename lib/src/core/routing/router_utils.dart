import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/home.routes.dart';

/// Utility functions for router configuration.
abstract class RouterUtils {
  /// No auth or version gates in the shell-only app.
  static String? redirect(BuildContext context, GoRouterState state) => null;

  /// Cross-fade page transition shared by all routes. Avoids the white/black
  /// slide flash that Material's default route transition shows on web.
  static CustomTransitionPage<T> fadePage<T>(
    GoRouterState state,
    Widget child, {
    Duration duration = const Duration(milliseconds: 220),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Error page builder for unknown routes.
  static Widget errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '404',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => const HomeRoute().go(context),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
