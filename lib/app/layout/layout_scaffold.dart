import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/app/router/bottom_destination.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = const LinearGradient(
        colors: [Color(0xff4a4460), Color(0xff1c1925), Color(0xff4e4e4e)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        tileMode: TileMode.clamp);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: navigationShell),
      bottomNavigationBar: NavigationBar(
          elevation: 0,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          labelBehavior:
              NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: destinations
              .map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                  selectedIcon: Icon(destination.icon,
                      color: Theme.of(context).primaryColor),
                ),
              )
              .toList()),
    );
  }
}
