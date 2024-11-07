import 'package:flutter/material.dart';
import 'package:wb_supplieses/app/router/app_router.dart';
import 'package:wb_supplieses/app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'BAXA ZAEBES',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
    );
  }
}