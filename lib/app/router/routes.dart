import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/app/layout/layout_scaffold.dart';
import 'package:wb_supplieses/features/database/view/database_page.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

class Routes {
  Routes._();

  static final List<StatefulShellRoute> routes = [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: PathKeys.supplieses(),
                builder: (context, state) => const SuppliesesPage())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: PathKeys.uploadExelFile(),
                builder: (context, state) => const DatabasePage())
          ]),
        ])
  ];
}
