// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $reportRoute,
    ];

RouteBase get $reportRoute => GoRouteData.$route(
      path: '/reports/:id',
      factory: $ReportRoute._fromState,
    );

mixin $ReportRoute on GoRouteData {
  static ReportRoute _fromState(GoRouterState state) => ReportRoute(
        id: state.pathParameters['id']!,
      );

  ReportRoute get _self => this as ReportRoute;

  @override
  String get location => GoRouteData.$location(
        '/reports/${Uri.encodeComponent(_self.id)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
