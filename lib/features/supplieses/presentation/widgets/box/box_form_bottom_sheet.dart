import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wb_supplieses/features/supplieses/presentation/widgets/box/box_search_input_selector.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxFormBottomSheet extends StatefulWidget {
  const BoxFormBottomSheet({super.key});

  @override
  State<BoxFormBottomSheet> createState() => _BoxFormBottomSheetState();
}

class _BoxFormBottomSheetState extends State<BoxFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _controllers = [];
  final List<ProductEntity?> _selectedProducts = [];

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    for (var map in _controllers) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
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
      child: SingleChildScrollView(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600]?.withOpacity(0.5),
                  border: Border.all(color: Colors.black26, width: 0.5),
                ),
                height: sheetHeight / 1.5,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Создание коробки',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...List.generate(
                                _controllers.length,
                                (index) {
                                  final controllers = _controllers[index];
                                  return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BoxSearchInputSelector(
                                    textController: controllers['text']!,
                                    sizeController: controllers['size']!,
                                    onProductSelected: (p) =>
                                        _onProductSelected(index, p),
                                  ),
                                );}
                              ),
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
