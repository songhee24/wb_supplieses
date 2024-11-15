import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/bloc/supplies_tab_index_cubit.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesesPage extends StatefulWidget {
  const SuppliesesPage({super.key});

  @override
  State<SuppliesesPage> createState() => _SuppliesesPageState();
}

class _SuppliesesPageState extends State<SuppliesesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        context.read<SuppliesTabIndexCubit>().setTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          FrostedAppBar(
            tabController: _tabController,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 130, left: 16, right: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          _tabController.index == 0
                              ? _buildSupplyTabContent()
                              : const Center(
                                  child: Text('box'),
                                ),
                        ],
                      );
                    },
                  ),
                  // SizedBox(height: kBottomNavigationBarHeight + 70),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildSupplyTabContent() {
  return const Column(
    children: [
      BoxCard(id: 0),
      SizedBox(height: 8),
      BoxCard(id: 1),
      SizedBox(height: 8),
      BoxCard(id: 2),
    ],
  );
}
