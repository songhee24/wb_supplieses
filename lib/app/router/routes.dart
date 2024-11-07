import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

class Routes {
  Routes._();

  static final List<GoRoute> routes = [
    GoRoute(path: PathKeys.supplieses(), builder: (context, state) => const SuppliesesPage())
  ];
}