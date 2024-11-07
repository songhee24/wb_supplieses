import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';
import 'routes.dart';


class AppRouter {
  final GoRouter router = GoRouter(initialLocation: PathKeys.supplieses(), routes: Routes.routes);
}