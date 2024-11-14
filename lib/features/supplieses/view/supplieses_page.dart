import 'package:flutter/material.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          const FrostedAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70, left: 16, right: 16),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 8),
              BoxCard(id: 0),
              SizedBox(height: 8),
              BoxCard(id: 0),
              SizedBox(height: 8),
              BoxCard(id: 0),
              // SizedBox(height: kBottomNavigationBarHeight + 70),
            ])),
          )
        ],
      ),
    );
  }
}
