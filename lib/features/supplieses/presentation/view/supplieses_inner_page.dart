import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

import '../../domain/entities/supplies_entity.dart';

class SuppliesesInnerPage extends StatefulWidget {
  final SuppliesEntity? suppliesEntity;

  const SuppliesesInnerPage({super.key, this.suppliesEntity});

  @override
  State<SuppliesesInnerPage> createState() => _SuppliesesInnerPageState();
}

class _SuppliesesInnerPageState extends State<SuppliesesInnerPage> {
  @override
  void initState() {
    context.read<SuppliesBloc>().add(
        (BoxesBySuppliesIdEvent(suppliesId: '${widget.suppliesEntity!.id}')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: kToolbarHeight * 1.7,
            backgroundColor: Colors.transparent,
            pinned: true,
            // automaticallyImplyLeading: false,
            snap: false,
            title: null,
            // title: SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Text(suppliesEntity.name),
            // ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Text(
              //     suppliesEntity?.name ?? '',
              //   ),
              // ),
              title: Container(
                color: Colors.grey.withOpacity(0.11),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SizedBox(
                        height: kToolbarHeight * 2.5,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 19),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 40),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            widget.suppliesEntity?.name ??
                                                ''))),
                              )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BlocBuilder<SuppliesBloc, SuppliesState>(
                                    builder: (context, state) {
                                      if (state.suppliesStatus == SuppliesStatus.success) {
                                        return Text(
                                          '${state.boxEntities?.length ?? 0}',
                                          // Dynamically get box count
                                          style: const TextStyle(fontSize: 16),
                                        );
                                      }
                                      return const Text(
                                        '0',
                                        // Default value when no data is available
                                        style: TextStyle(fontSize: 16),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                    'lib/assets/box.png',
                                    width: 28,
                                    height: 28,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<SuppliesBloc, SuppliesState>(
            builder: (context, state) {
              if (state is BoxError) {
                // Show an error dialog and also return a sliver widget
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
                      content: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.6),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: const Text(
                          'Что то пошло не так блять',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  );
                });

                // Return an empty sliver as fallback
                return const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                );
              } else if (state.suppliesStatus == SuppliesStatus.success) {
                if(state.boxEntities != null && state.boxEntities!.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('Коробов нет'),
                    ),
                  );
                }

                // Update the boxCount using a StatefulBuilder or setState safely
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   setState(() {
                //     boxCount = state.boxEntities!.length;
                //   });
                // });

                // Render the list of boxes
                return SliverPadding(
                  padding: const EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight + 100,
                      left: 16,
                      right: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final box = state.boxEntities![index];
                        return ListTile(
                          title: Text(
                              '${box.boxNumber} кол-во товаров: ${box.productEntities?.length ?? 0}'),
                        );
                      },
                      childCount: state.boxEntities?.length ?? 0,
                    ),
                  ),
                );
              }

              // For loading or unexpected states, return a placeholder Sliver
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text('Что-то пошло не так...'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
