import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxSearchInputSelector extends StatefulWidget {
  final TextEditingController textController;
  final TextEditingController sizeController;
  final String? Function(String?)? validator;
  final ProductEntity? initialProduct;
  final ValueChanged<ProductEntity?> onProductSelected;

  const BoxSearchInputSelector({
    super.key,
    required this.textController,
    this.validator,
    this.initialProduct,
    required this.onProductSelected,
    required this.sizeController,
  });

  @override
  State<BoxSearchInputSelector> createState() => _BoxSearchInputSelectorState();
}

class _BoxSearchInputSelectorState extends State<BoxSearchInputSelector> {
  final Debouncer _debouncer = Debouncer();

  ProductEntity? _selectedProduct;
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    print('widget.initialProduct, ${widget.initialProduct}');
    _selectedProduct = widget.initialProduct;
    // for (int i = 0; i < widget.productCount; i++) {
    //   _productControllers[i] = TextEditingController();
    // }
  }

  // @override
  // void dispose() {
  //   for (var controller in _productControllers.values) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      widget.onProductSelected(null);
      widget.textController.clear();
      _isDropdownVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 500);

    if (_selectedProduct != null) {
      return Card(
        child: ListTile(
          dense: true,
          minTileHeight: 0,
          minVerticalPadding: 0,
          titleAlignment: ListTileTitleAlignment.top,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Имя товара: ', _selectedProduct?.productName ?? 'N/A'),
              _buildRow('Артикул продавца: ',
                  _selectedProduct?.sellersArticle ?? 'N/A'),
              _buildRow('Артикул WB: ', _selectedProduct?.articleWB ?? 'N/A'),
              _buildRow('Размер: ', _selectedProduct?.size ?? 'N/A'),
              _buildRow('Кол-во: ', '${_selectedProduct?.count} шт'),
            ],
          ),
          contentPadding:
              const EdgeInsets.only(left: 12, right: 6, top: 12, bottom: 0),
          trailing: SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: const EdgeInsets.all(2),
              iconSize: 28,
              icon: const Icon(Icons.delete),
              onPressed: _clearSelection,
            ),
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  controller: widget.textController,
                  validator: widget.validator,
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      setState(() {
                        _isDropdownVisible = true;
                      });
                      _debouncer.debounce(
                          duration: duration,
                          onDebounce: () {
                            context.read<BoxBloc>().add(
                                  BoxSearchProductsEvent(query: query),
                                );
                          });
                    } else {
                      setState(() {
                        _isDropdownVisible = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Поиск товара для коробки',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: TextFormField(
                  controller: widget.sizeController,
                  validator: widget.validator,
                  onChanged: (query) {
                    // print('widget.textController.text ${widget.textController.text}.    query:${query}');
                    if (query.isNotEmpty &&
                        widget.textController.text.isNotEmpty) {
                      setState(() {
                        _isDropdownVisible = true;
                      });
                      _debouncer.debounce(
                          duration: duration,
                          onDebounce: () {
                            context.read<BoxBloc>().add(
                                  BoxSearchProductsEvent(
                                      query: widget.textController.text,
                                      size: query),
                                );
                          });
                    } else {
                      setState(() {
                        _isDropdownVisible = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Поиск по размеру',
                      labelStyle: TextStyle(fontSize: 9)),
                ),
              ),
            ],
          ),
          if (_isDropdownVisible)
            BlocBuilder<BoxBloc, BoxState>(
              builder: (context, state) {
                if (state is BoxSearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                } else if (state is BoxSearchSuccess) {
                  if (state.products.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Товары не найдены'),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 220,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                          final Map<int, TextEditingController>
                              _productControllers = {};
                          for (int i = 0; i < state.products.length; i++) {
                            _productControllers[i] = TextEditingController();
                          }
                          final product = state.products[index];
                          final productSizeController =
                              _productControllers[index]!;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              // border: Border.all(color: Colors.white),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  titleAlignment: ListTileTitleAlignment.top,
                                  trailing: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(2),
                                      iconSize: 28,
                                      icon: const Icon(Icons.add_box_rounded),
                                      onPressed: () {
                                        setState(() {
                                          if (productSizeController
                                                  .text.isEmpty ||
                                              int.parse(productSizeController
                                                      .text) ==
                                                  0) {
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
                                                  insetPadding: const EdgeInsets
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
                                                      'Пожалуйста добавьте количество продукта',
                                                      style: TextStyle(
                                                          color: Colors.orange),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                            return;
                                          }

                                          final selectedProductModel =
                                              ProductEntity(
                                            groupId: product?.groupId,
                                            sellersArticle:
                                                product?.sellersArticle ?? '',
                                            articleWB: product?.articleWB ?? '',
                                            productName:
                                                product?.productName ?? '',
                                            category: product?.category ?? '',
                                            brand: product?.brand ?? '',
                                            barcode: product?.barcode ?? '',
                                            size: product?.size ?? '',
                                            russianSize:
                                                product?.russianSize ?? '',
                                            count: int.parse(
                                                productSizeController.text),
                                          );
                                          _selectedProduct =
                                              selectedProductModel;
                                          _isDropdownVisible = false;
                                          widget.onProductSelected(
                                              selectedProductModel);
                                          widget.textController.text =
                                              product!.productName;
                                        });
                                      },
                                    ),
                                  ),
                                  dense: true,
                                  minTileHeight: 0,
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 6, top: 12, bottom: 0),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildRow('Имя товара: ',
                                          product?.productName ?? 'N/A'),
                                      _buildRow('Артикул продавца: ',
                                          product?.sellersArticle ?? 'N/A'),
                                      // _buildRow('Артикул WB: ',
                                      //     product?.articleWB ?? 'N/A'),
                                      // _buildRow('Размер: ', product?.size ?? 'N/A'),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 0,
                                  minTileHeight: 0,
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 16, top: 0, bottom: 0),
                                  title: Column(
                                    children: [
                                      _buildRow('Артикул WB: ',
                                          product?.articleWB ?? 'N/A'),
                                      _buildRow(
                                          'Размер: ', product?.size ?? 'N/A'),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 82,
                                    height: 40,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'кол-во',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 31,
                                            height: 20,
                                            child: TextFormField(
                                              controller: productSizeController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorHeight: 12,
                                              decoration: const InputDecoration(
                                                hintText: "0",
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 0, left: 2),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius.zero),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.zero),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is BoxError) {
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
