import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';
import 'package:wb_supplieses/features/supplieses/presentation/widgets/box/box_search_input_selector.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxFormBottomSheet extends StatefulWidget {
  final BoxEntity? boxEntity;
  final SuppliesEntity suppliesEntity;

  const BoxFormBottomSheet(
      {super.key, required this.suppliesEntity, this.boxEntity});

  @override
  State<BoxFormBottomSheet> createState() => _BoxFormBottomSheetState();
}

class _BoxFormBottomSheetState extends State<BoxFormBottomSheet> {
  String? _boxId;
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _controllers = [];
  final List<ProductEntity?> _selectedProducts = [];
  final TextEditingController _boxNumberController =
      TextEditingController(text: '0');

  final duration = const Duration(milliseconds: 700);

  final Debouncer _debouncer = Debouncer();

  void _onBoxNumberChanged() {
    // Only trigger the event if boxEntity's id is null
    if (widget.boxEntity?.id != null &&
        _boxNumberController.text.isNotEmpty &&
        widget.boxEntity?.boxNumber != _boxNumberController.text) {
      final boxEntity = BoxEntity(
        id: widget.boxEntity?.id,
        boxNumber: _boxNumberController.text,
        suppliesId: widget.suppliesEntity.id,
        productEntities: _selectedProducts
            .where((el) => el != null)
            .cast<ProductEntity>()
            .toList(), // Adjust based on your logic
      );

      _debouncer.debounce(
          duration: duration,
          onDebounce: () {
            // Dispatch events to the Bloc
            context.read<BoxBloc>().add(BoxCreateEvent(boxEntity: boxEntity));
            context
                .read<SuppliesBloc>()
                .add(BoxesBySuppliesIdEvent(suppliesEntity: widget.suppliesEntity));
          });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    for (var map in _controllers) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    _boxNumberController.removeListener(_onBoxNumberChanged);
    _boxNumberController.dispose();

    // if (widget.boxEntity?.id == null) {
    //   BoxEntity boxEntity = BoxEntity(
    //     id: widget.boxEntity?.id,
    //     boxNumber: _boxNumberController.text,
    //     suppliesId: widget.suppliesId,
    //     productEntities: _selectedProducts
    //         .where((el) => el != null)
    //         .cast<ProductEntity>()
    //         .toList(),
    //   );
    //
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     context.read<BoxBloc>().add(BoxCreateEvent(boxEntity: boxEntity));
    //     context.read<SuppliesBloc>().add(
    //         BoxesBySuppliesIdEvent(suppliesId: widget.suppliesId));
    //   });
    // }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _controllers.add({
    //     'text': TextEditingController(),
    //     'size': TextEditingController(),
    //   });
    //   _selectedProducts.add(null);
    // });
    // Set initial value if needed
    // if (widget.boxEntity?.boxNumber != null) {
    //   _boxNumberController.text = widget.boxEntity!.boxNumber!;
    // }

    // Add listener to TextEditingController
    _boxNumberController.addListener(_onBoxNumberChanged);

    if (widget.boxEntity?.id == null) {
      context.read<BoxBloc>().add(
            BoxCreateEvent(
              boxEntity: BoxEntity(
                  boxNumber: _boxNumberController.text,
                  suppliesId: widget.suppliesEntity.id),
            ),
          );
      context
          .read<SuppliesBloc>()
          .add((BoxesBySuppliesIdEvent(suppliesEntity: widget.suppliesEntity)));
    } else {
      setState(() {
        _boxId = widget.boxEntity!.id;
        _boxNumberController.text = widget.boxEntity!.boxNumber.toString();
        if (widget.boxEntity?.productEntities != null) {
          _selectedProducts.addAll(widget.boxEntity!.productEntities!);

          widget.boxEntity?.productEntities?.forEach((p) {
            _controllers.add({
              'text': TextEditingController(),
              'size': TextEditingController(),
            });
          });
        }
      });
    }
  }

  void _addSearchField() {
    setState(() {
      _controllers.add({
        'text': TextEditingController(),
        'size': TextEditingController(),
      });
      _selectedProducts.add(null);
    });
  }

  void _onProductSelected(int index, ProductEntity? product) {
    setState(() {
      _selectedProducts[index] = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_boxId $_boxId');
    // print('_selectedProducts $_selectedProducts');
    double sheetHeight = MediaQuery.of(context).size.height;
    return BlocListener<BoxBloc, BoxState>(
      listener: (context, state) {
        if (state is BoxCreatedSuccess) {
          // Save the result to local state
          setState(() {
            _boxId = state.boxId; // Adjust as needed
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, top: 80),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600]?.withOpacity(0.5),
                  border: Border.all(color: Colors.black26, width: 0.5),
                ),
                height: sheetHeight / 1.5,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                _boxId != null
                                    ? 'Коробка создана можете добавить товары'
                                    : 'Создание коробки',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text('Короб №'),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 31,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _boxNumberController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      cursorHeight: 10,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 5),
                                        border: UnderlineInputBorder(),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ])
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              BlocBuilder<BoxBloc, BoxState>(
                                builder: (context, state) {
                                  if (state is BoxCreatedSuccess) {
                                    // print('state.boxId ${state.boxId}');
                                    // WidgetsBinding.instance
                                    //     .addPostFrameCallback((_) {
                                    //   setState(() {
                                    //     _boxId = state.boxId;
                                    //   });
                                    // });
                                  }

                                  if (state is BoxError) {
                                    // Show an error dialog and also return a sliver widget
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                          content: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(.6),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12.0))),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              state.message,
                                              style: const TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                      );
                                    });

                                    // Return an empty sliver as fallback
                                    return const SizedBox.shrink();
                                  }

                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _controllers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final controllers = _controllers[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: BoxSearchInputSelector(
                                          textController: controllers['text']!,
                                          sizeController: controllers['size']!,
                                          initialProduct:
                                              _selectedProducts[index],
                                          onProductSelected: (p) {
                                            if (_boxId == null) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    insetPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 12),
                                                    content: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(.6),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius.circular(
                                                                      12.0))),
                                                      child: const Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Что то пошло не так коробка не смогла создаться попробуйте заново',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                              return;
                                            }

                                            _onProductSelected(index, p);

                                            BoxEntity boxEntity = BoxEntity(
                                              id: _boxId,
                                              boxNumber:
                                                  _boxNumberController.text,
                                              suppliesId: widget.suppliesEntity.id,
                                              productEntities: _selectedProducts
                                                  .where((el) => el != null)
                                                  .cast<ProductEntity>()
                                                  .toList(),
                                            );

                                            // context.read<BoxBloc>().add(
                                            //       BoxCreateAndFetchedBySuppliesIdEvent(
                                            //         boxEntity: boxEntity,
                                            //         suppliesId: widget.suppliesId,
                                            //       ),
                                            //     );
                                            context.read<BoxBloc>().add(
                                                  BoxCreateEvent(
                                                      boxEntity: boxEntity),
                                                );
                                            context.read<SuppliesBloc>().add(
                                                (BoxesBySuppliesIdEvent(
                                                    suppliesEntity:
                                                        widget.suppliesEntity)));
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // ...List.generate(_controllers.length, (index) {
                              //   final controllers = _controllers[index];
                              //   return Padding(
                              //     padding: const EdgeInsets.only(bottom: 8),
                              //     child: BoxSearchInputSelector(
                              //       textController: controllers['text']!,
                              //       sizeController: controllers['size']!,
                              //       onProductSelected: (p) =>
                              //           _onProductSelected(index, p),
                              //     ),
                              //   );
                              // }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addSearchField,
                        child: const Text('Добавить товар для этой коробки'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
