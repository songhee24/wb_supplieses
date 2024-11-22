import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/app/layout/layout_scaffold.dart';
import 'package:wb_supplieses/features/database/database.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

class Routes {
  Routes._();

  static final List<StatefulShellRoute> routes = [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutScaffold(state: state, navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: PathKeys.supplieses(),
              builder: (context, state) => const SuppliesesPage(),
              routes: [
                GoRoute(
                  path: PathKeys.boxes(),
                  builder: (context, state) {
                    final suppliesId = state.pathParameters['suppliesId'];
                    return SuppliesesInnerPage(suppliesId: suppliesId!);
                  },
                )
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: PathKeys.uploadExelFile(),
              builder: (context, state) => const DatabasePage(),
            ),
          ]),
        ])
  ];
}
