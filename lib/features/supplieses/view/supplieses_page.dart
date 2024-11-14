import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [Tab(text: 'Поставки'),Tab(text: 'Коробки')],
          ),
          automaticallyImplyLeading: false,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 8),
                BoxCard(id: 0),
                SizedBox(height: 8),
                BoxCard(id: 0),
                SizedBox(height: 8),
                BoxCard(id: 0),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
