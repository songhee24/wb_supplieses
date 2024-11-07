import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class Routes {
  Routes._();

  static final List<GoRoute> routes = [
    GoRoute(path: '/', builder: (context, state) => const SuppliesesPage())
  ];
}