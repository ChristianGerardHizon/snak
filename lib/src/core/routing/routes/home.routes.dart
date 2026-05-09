import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/home_page.dart';
import '../router_utils.dart';

part 'home.routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  static const path = '/';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      RouterUtils.fadePage(state, const HomePage());
}
