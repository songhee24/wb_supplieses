import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final bool? showLeading;
  final TabController tabController;

  const FrostedAppBar({super.key, this.actions, this.showLeading = false, required this.tabController});

  @override
  Widget build(BuildContext context) {
    const kToolbarHeightCustom = kToolbarHeight * 2;

    return DefaultTabController(
      length: 2,
      child: SliverAppBar(
        toolbarHeight: kToolbarHeightCustom - 40,
        automaticallyImplyLeading: showLeading!,
        backgroundColor: Colors.transparent,
        pinned: true,
        floating: true,
        snap: false,
        actions: actions ?? [],
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SizedBox(
              height: kToolbarHeightCustom,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.only(top: kToolbarHeight + 15),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Поставки'),
                    Tab(text: 'Коробки'),
                  ],
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.purpleAccent.withOpacity(0.5)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
