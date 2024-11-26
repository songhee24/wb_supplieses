import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxSearchInputSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onSearch;
  final ProductEntity? initialProduct;
  final ValueChanged<ProductEntity?> onProductSelected;

  const BoxSearchInputSelector(
      {super.key,
      required this.controller,
      this.validator,
      this.onSearch,
      this.initialProduct,
      required this.onProductSelected});

  @override
  State<BoxSearchInputSelector> createState() => _BoxSearchInputSelectorState();
}

class _BoxSearchInputSelectorState extends State<BoxSearchInputSelector> {
  ProductEntity? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.initialProduct;
  }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      widget.onProductSelected(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedProduct != null
        ? Card(
            child: ListTile(
              title: Text('Выбранный товар: ${_selectedProduct!.productName}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _clearSelection,
              ),
            ),
          )
        : TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onSearch,
            decoration: const InputDecoration(
              labelText: 'Поиск товара для коробки (Наименование, WB артикул)',
            ),
          );
  }
}
