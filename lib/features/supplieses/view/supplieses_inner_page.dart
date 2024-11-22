import 'dart:ui';

import 'package:flutter/material.dart';

class SuppliesesInnerPage extends StatelessWidget {
  final String suppliesId;

  const SuppliesesInnerPage({super.key, required this.suppliesId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            // automaticallyImplyLeading: false,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.11),
                ),
              ),
              title: Container(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Коробки'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text('box'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
