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
      // Add FloatingActionButton
      floatingActionButton: navigationShell.currentIndex == 0 ? FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ) : null,
      // Set the FAB location
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: navigationShell,
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 115,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 15),
            child: BottomAppBar(
              // Add the notched shape
              shape: const CircularNotchedRectangle(),
              elevation: 0,
              color: Colors.grey.withOpacity(0.11),
              notchMargin: 26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: destinations.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var destination = entry.value;
                  // Calculate the middle index

                  return InkResponse(
                    radius: 20,
                    onTap: () => navigationShell.goBranch(idx),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            destination.icon,
                            color: navigationShell.currentIndex == idx
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                          if (navigationShell.currentIndex == idx)
                            Text(
                              destination.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
