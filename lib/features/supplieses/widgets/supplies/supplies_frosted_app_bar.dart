import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final bool? showLeading;

  const FrostedAppBar({super.key, this.actions, this.showLeading = false});

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
            child: const SizedBox(
              height: kToolbarHeightCustom,
              child: TabBar(
                padding: EdgeInsets.only(top: kToolbarHeightCustom - 60),
                dividerColor: Colors.transparent,
                tabs: [Tab(text: 'Поставки'), Tab(text: 'Коробки')],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
