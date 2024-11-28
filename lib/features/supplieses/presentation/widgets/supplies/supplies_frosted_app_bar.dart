import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final bool? showLeading;
  final TabController tabController;

  const FrostedAppBar({super.key, this.actions, this.showLeading = false, required this.tabController});

  @override
  Widget build(BuildContext context) {
    const kToolbarHeightCustom = kToolbarHeight * 2.3;

    return DefaultTabController(
      length: 2,
      child: SliverAppBar(
        toolbarHeight: kToolbarHeightCustom - 30,
        automaticallyImplyLeading: showLeading!,
        backgroundColor: Colors.transparent,
        pinned: true,
        floating: true,
        snap: false,
        actions: actions ?? [],
        flexibleSpace: Container(
          color: Colors.grey.withOpacity(0.11),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SizedBox(
                height: kToolbarHeightCustom + 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: const EdgeInsets.only(top: kToolbarHeight + 30),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Созданы'),
                      Tab(text: 'Загружены'),
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
      ),
    );
  }
}
