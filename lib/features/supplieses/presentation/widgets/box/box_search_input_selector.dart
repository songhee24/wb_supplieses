import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxSearchInputSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ProductEntity? initialProduct;
  final ValueChanged<ProductEntity?> onProductSelected;

  const BoxSearchInputSelector({
    super.key,
    required this.controller,
    this.validator,
    this.initialProduct,
    required this.onProductSelected,
  });

  @override
  State<BoxSearchInputSelector> createState() => _BoxSearchInputSelectorState();
}

class _BoxSearchInputSelectorState extends State<BoxSearchInputSelector> {
  ProductEntity? _selectedProduct;
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.initialProduct;
  }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      widget.onProductSelected(null);
      widget.controller.clear();
      _isDropdownVisible = false;
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    validator: widget.validator,
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          _isDropdownVisible = true;
                        });
                        context.read<BoxBloc>().add(
                          BoxSearchProductsEvent(query: query),
                        );
                      } else {
                        setState(() {
                          _isDropdownVisible = false;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Поиск товара для коробки',
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    validator: widget.validator,
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          _isDropdownVisible = true;
                        });
                        context.read<BoxBloc>().add(
                          BoxSearchProductsEvent(query: query),
                        );
                      } else {
                        setState(() {
                          _isDropdownVisible = false;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Поиск товара для коробки',
                    ),
                  ),
                ),
              ],),

              if (_isDropdownVisible)
                BlocBuilder<BoxBloc, BoxState>(
                  builder: (context, state) {
                    if (state is BoxSearchLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is BoxSearchSuccess) {
                      if (state.products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Товары не найдены'),
                        );
                      }
                      return Container(
                        height: 220,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration:  BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                    border: Border.all(color: Colors.white)
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildRow('Имя товара: ',
                                          product?.productName ?? 'N/A'),
                                      _buildRow('Артикул продавца: ',
                                          product?.sellersArticle ?? 'N/A'),
                                      _buildRow('Артикул WB: ',
                                          product?.articleWB ?? 'N/A'),
                                      _buildRow(
                                          'Размер: ', product?.size ?? 'N/A'),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedProduct = product;
                                      _isDropdownVisible = false;
                                      widget.onProductSelected(product);
                                      widget.controller.text =
                                          product!.productName;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state is BoxSearchError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ошибка: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          );
  }
}

Widget _buildRow(String label, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 120,
          child: Text(
            textAlign: TextAlign.left,
            label,
          ),
        ),
        Flexible(
          child: Text(
            textAlign: TextAlign.left,
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
