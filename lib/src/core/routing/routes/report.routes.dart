import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/report_viewer_page.dart';

part 'report.routes.g.dart';

@TypedGoRoute<ReportRoute>(path: ReportRoute.path)
class ReportRoute extends GoRouteData with $ReportRoute {
  const ReportRoute({required this.id});

  static const path = '/reports/:id';

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportViewerPage(reportId: id);
  }
}
