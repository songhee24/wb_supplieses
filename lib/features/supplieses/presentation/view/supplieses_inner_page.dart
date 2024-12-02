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
  bool supplyShipped = false;

  late final SuppliesBloc _suppliesBloc;

  @override
  void initState() {
    super.initState();
    _suppliesBloc = context.read<SuppliesBloc>();
    _suppliesBloc
        .add(BoxesBySuppliesIdEvent(suppliesEntity: widget.suppliesEntity!));
  }

  @override
  void dispose() {
    if (!supplyShipped) {
      _suppliesBloc.add(
          UpdateSuppliesBoxCountEvent(suppliesEntity: widget.suppliesEntity!));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
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
                                      if (state.suppliesStatus ==
                                          SuppliesStatus.success) {
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
              child: BlocBuilder<SuppliesBloc, SuppliesState>(
                  builder: (context, state) {
                if (state.suppliesStatus == SuppliesStatus.success && state.boxEntities!.isNotEmpty) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Поделиться поставкой',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.suppliesEntity?.boxes == null ||
                                state.boxEntities!.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  content: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0))),
                                    child: const Text(
                                      textAlign: TextAlign.center,
                                      'Коробов нет',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              supplyShipped = true;
                            });
                            _suppliesBloc.add(SuppliesShipBoxesEvent(
                                suppliesEntity: widget.suppliesEntity!,
                                boxEntities: widget.suppliesEntity!.boxes!));
                          },
                          child: const Text('Отправить поставку'),
                        ),
                      ),
                    ],
                  );
                }
                return const Center();
              }),
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
                if (state.boxEntities != null && state.boxEntities!.isEmpty) {
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
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.boxEntities?.length ?? 0,
                      (BuildContext context, int index) {
                        final box = state.boxEntities![index];
                        return SuppliesInnerBoxCard(
                            boxEntity: box,
                            suppliesEntity: widget.suppliesEntity);
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // Number of columns
                      crossAxisSpacing: 8,
                      // Horizontal space between grid items
                      mainAxisSpacing: 12,
                      // Vertical space between grid items
                      childAspectRatio:
                          1, // Width-to-height ratio of grid items
                    ),
                  ),
                );
              }

              // For loading or unexpected states, return a placeholder Sliver
              return const SliverToBoxAdapter(child: Center());
            },
          )
        ],
      ),
    );
  }
}
