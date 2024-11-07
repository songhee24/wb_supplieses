import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/app/router/routes.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final router = GoRouter(
  initialLocation: PathKeys.supplieses(),
  navigatorKey: _rootNavigatorKey,
  routes: Routes.routes,
);