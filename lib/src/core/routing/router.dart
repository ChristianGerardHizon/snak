import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dialog_dismissing_observer.dart';
import 'router_utils.dart';
import 'routes/home.routes.dart';

part 'router.g.dart';

/// Global navigator key for root navigation.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Global ScaffoldMessenger key for showing snackbars on root scaffold.
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Provides the GoRouter instance for the application.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: HomeRoute.path,
    debugLogDiagnostics: true,
    observers: [SentryNavigatorObserver(), DialogDismissingObserver()],
    redirect: RouterUtils.redirect,
    errorBuilder: RouterUtils.errorBuilder,
    routes: [
      $homeRoute,
    ],
  );
}
