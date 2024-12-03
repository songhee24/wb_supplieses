import 'dart:io';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';

class SuppliesCard extends StatelessWidget {
  final SuppliesEntity supplies;

  const SuppliesCard({super.key, required this.supplies});

  Future<void> _onGetSuppliesById(BuildContext context) async {
    if (supplies.id != null) {
      BlocProvider.of<SuppliesBloc>(context).add(
        SuppliesGetByIdEvent(suppliesId: supplies.id!),
      );
      showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SuppliesFormBottomSheet(
              suppliesId: supplies.id,
            );
          });
    }
  }



  Future<void> exportToExcel(String suppliesId, List<ProductEntity> products) async {
    // Create a new Excel workbook
    final excel = Excel.createExcel();

    // Create a sheet and add headers
    final sheet = excel['Products'];

    sheet.appendRow([
      TextCellValue('Group ID'),
      TextCellValue('Box ID'),
      TextCellValue('Sellers Article'),
      TextCellValue('Article WB'),
      TextCellValue('Product Name'),
      TextCellValue('Category'),
      TextCellValue('Brand'),
      TextCellValue('Size'),
      TextCellValue('Russian Size'),
      TextCellValue('Barcode'),
      TextCellValue('Count'),
    ]);

    // Add products to the sheet
    for (final product in products) {
      sheet.appendRow([
        TextCellValue(product.groupId ?? ""),
        TextCellValue(product.boxId ?? ""),
        TextCellValue(product.sellersArticle),
        TextCellValue(product.articleWB),
        TextCellValue(product.productName),
        TextCellValue(product.category),
        TextCellValue(product.brand),
        TextCellValue(product.size),
        TextCellValue(product.russianSize),
        TextCellValue(product.barcode),
        IntCellValue(product.count.toInt()),
      ]);
    }

    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final fileName = '${suppliesId}_products.xlsx';
    final filePath = join(tempDir.path, fileName);

    // Save the file
    final fileBytes = excel.save();
    if (fileBytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      // Share the file using share_plus
      await Share.shareXFiles([XFile(filePath)], text: 'Here is your Excel file: $fileName');
      print('Excel file shared: $filePath');
    } else {
      throw Exception('Failed to generate Excel file');
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить Поставку'),
          content: const Text(
              'А вы уверены что хотите удалить поставку? Удаление приведет к удалению всех коробок!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отменить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && supplies.id != null) {
      // ignore: use_build_context_synchronously
      context.read<SuppliesBloc>().add(
            SuppliesDeleteEvent(suppliesId: supplies.id!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(supplies.createdAt);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: supplies.status == 'created'
              ? () {
                  // context.read<SuppliesTabIndexCubit>().setTabIndex(-1);
                  context.push<bool>(
                      '${PathKeys.supplieses()}/${supplies.id}/boxes',
                      extra: supplies);
                }
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  // border: Border.all(color: Color(0xFF235F75), width: 1),
                  gradient: supplies.status == 'created'
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.black54,
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black54,
                            Colors.deepPurple,
                          ],
                        ),
                  color: Colors.grey[350]!.withOpacity(0.4),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  supplies.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${supplies.boxCount}'),
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
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  supplies.status == 'created'
                                      ? 'Cоздано:'
                                      : 'Отправлено',
                                  style: TextStyle(
                                      fontWeight: supplies.status == 'created'
                                          ? FontWeight.w400
                                          : FontWeight.bold,
                                      color: supplies.status == 'created'
                                          ? Colors.grey
                                          : Colors.green[200])),
                              Text(
                                  '${formattedDate.split(" ")[0]} '
                                  ' ${formattedDate.split(" ")[1]}',
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          if (supplies.status == 'created')
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteConfirmation(context);
                                  }
                                  if (value == 'edit') {
                                    _onGetSuppliesById(context);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                        value: 'delete',
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Text('Удалить')),
                                    const PopupMenuItem(
                                        value: 'edit',
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Text('Изменить'))
                                  ];
                                },
                              ),
                            )
                          else
                            BlocListener<BoxBloc,BoxState>(
                              listener: (context, state) async {
                                if(state is BoxError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.pink),)),
                                  );
                                }

                                if (state is BoxCombinedProductsSuccess) {
                                  final products = state.products.whereType<ProductEntity>().toList();

                                  await exportToExcel(supplies.id!, products);

                                  // Show success notification
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Excel file has been exported successfully!')),
                                  );
                                }
                              },
                              child: BlocBuilder<BoxBloc,BoxState>(
                                builder: (context, state) {
                                  print(state);
                                  return SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25,
                                      onPressed: () {
                                        // Dispatch the event to fetch products
                                        context.read<BoxBloc>().add(BoxGetCombinedProductsBySuppliesIdEvent(suppliesId: '${supplies.id}'));

                                      },
                                      icon: const Icon(Icons.file_download),
                                    ),
                                  );
                                }
                              ),
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
    );
  }
}
