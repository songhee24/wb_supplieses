import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/presentation/widgets/box/box_search_input_selector.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxFormBottomSheet extends StatefulWidget {
  final String suppliesId;

  const BoxFormBottomSheet({super.key, required this.suppliesId});

  @override
  State<BoxFormBottomSheet> createState() => _BoxFormBottomSheetState();
}

class _BoxFormBottomSheetState extends State<BoxFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _controllers = [];
  final List<ProductEntity?> _selectedProducts = [];
  final TextEditingController _boxNumberController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    for (var map in _controllers) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    _boxNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _controllers.add({
        'text': TextEditingController(),
        'size': TextEditingController(),
      });
      _selectedProducts.add(null);
    });
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
    double sheetHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
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
                          const Text(
                            'Создание коробки',
                            style: TextStyle(fontSize: 16),
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
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _controllers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final controllers = _controllers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BoxSearchInputSelector(
                                      textController: controllers['text']!,
                                      sizeController: controllers['size']!,
                                      onProductSelected: (p) {
                                        _onProductSelected(index, p);
                                        BoxEntity boxEntity = BoxEntity(
                                            boxNumber:
                                                _boxNumberController.text,
                                            suppliesId: widget.suppliesId,
                                            productEntities: _selectedProducts
                                                .where((el) => el != null)
                                                .cast<ProductEntity>()
                                                .toList());

                                        context.read<BoxBloc>().add(
                                              BoxCreateEvent(
                                                  boxEntity: boxEntity),
                                            );
                                        context.read<BoxBloc>().add(
                                            (BoxesBySuppliesIdEvent(suppliesId: widget.suppliesId)));
                                      }),
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
    );
  }
}
