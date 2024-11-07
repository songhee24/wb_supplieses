import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(PathKeys.supplieses());
        break;
      case 1:
        context.go(PathKeys.uploadExelFile());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) => _onItemTapped(context, index),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'Коробки'),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: 'Обновить базу')
        ]);
  }
}
