import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/app/router/bottom_destination.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    LinearGradient _gradient = const LinearGradient(
        colors: [Color(0xff5e4b98), Color(0xff33265a)],
        begin: FractionalOffset(100.0, 0.1),
        end: FractionalOffset(0.0, 0.5),
        tileMode: TileMode.clamp);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(decoration: BoxDecoration(gradient: _gradient),child: navigationShell,),
      bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: destinations
              .map((destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                  selectedIcon: Icon(destination.icon,
                      color: Theme.of(context).primaryColor)))
              .toList()),
    );
  }
}
