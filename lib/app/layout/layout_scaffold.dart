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
        colors: [Color(0xff33265a), Color(0xff1c1925), Color(0xff382375)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        tileMode: TileMode.clamp);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SafeArea(bottom: false, child: navigationShell)),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 15),
          child: NavigationBar(
              surfaceTintColor: Colors.amber,
              elevation: 0,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              backgroundColor: Colors.grey.withOpacity(0.11),
              indicatorColor: Colors.transparent,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: destinations
                  .map(
                    (destination) => NavigationDestination(
                      icon: Icon(destination.icon),
                      label: destination.label,
                      selectedIcon: Icon(destination.icon, color: Colors.white),
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}
