import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/report_viewer_page.dart';
import '../router_utils.dart';

part 'report.routes.g.dart';

@TypedGoRoute<ReportRoute>(path: ReportRoute.path)
class ReportRoute extends GoRouteData with $ReportRoute {
  const ReportRoute({required this.id});

  static const path = '/reports/:id';

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      RouterUtils.fadePage(state, ReportViewerPage(reportId: id));
}
