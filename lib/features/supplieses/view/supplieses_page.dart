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

    context.read<SuppliesBloc>().add(SuppliesGetEvent(status: 'created'));
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
            sliver: AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return _tabController.index == 0
                    ? _buildSupplyTabContent()
                    : const SliverToBoxAdapter(
                  child: Center(
                    child: Text('box'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSupplyTabContent() {
    return BlocBuilder<SuppliesBloc, SuppliesState>(
      builder: (context, state) {
        if (state.suppliesStatus == SuppliesStatus.loading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.suppliesStatus == SuppliesStatus.failure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Что то пошло не так('),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SuppliesBloc>().add(SuppliesGetEvent(status: 'created'));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.supplieses.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('Поставок нет'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final supply = state.supplieses[index];
              return Column(
                children: [
                  SuppliesCard(
                    supplies: supply, // Assuming SuppliesCard accepts a supply parameter
                  ),
                  if (index < state.supplieses.length - 1)
                    const SizedBox(height: 8),
                ],
              );
            },
            childCount: state.supplieses.length,
          ),
        );
      },
    );
  }
}