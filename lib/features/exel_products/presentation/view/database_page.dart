import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database.dart';
import '../../../../shared/entities/product_entity.dart';


class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  List<ProductEntity> _excelData = [];
  List<ProductEntity> _filteredData = [];
  bool _isPlatformFilePickupLoading = false;
  int _currentPage = 0;
  int _rowsPerPage = 10;

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  Future<void> pickAndReadExcelFile(BuildContext context) async {
    setState(() {
      _isPlatformFilePickupLoading = true;
    });

    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Read file
        List<List<dynamic>> data = await readExcelFile(result.files.first);
        if (context.mounted) {
          context.read<ProductBloc>().add(LoadExcelDataEvent(data));
        }

        // setState(() {
        //   _excelData = data;
        // });
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to read Excel file: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() {
        _isPlatformFilePickupLoading = false;
      });
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _excelData;
      } else {
        _filteredData = _excelData
            .where((row) => matchesQuery(_excelData, row, query))
            .toList();
      }
      _currentPage = 0; // Reset to the first page after filtering
    });
  }

  bool matchesQuery(
      List<ProductEntity> row, ProductEntity product, String query) {
    bool isMatched = product.productName
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ==
            true ||
        product.articleWB
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ==
            true;

    return isMatched;
  }

  Future<List<List<dynamic>>> readExcelFile(PlatformFile file) async {
    List<List<dynamic>> data = [];
    const int MAX_COLUMNS = 10;
    const int START_ROW = 2;

    try {
      late List<int> bytes;

      if (file.bytes != null) {
        bytes = file.bytes!;
      } else {
        bytes = File(file.path!).readAsBytesSync();
      }

      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];

      int columnCount =
          sheet!.maxColumns > MAX_COLUMNS ? MAX_COLUMNS : sheet.maxColumns;

      for (var row = START_ROW; row < sheet.maxRows; row++) {
        List<dynamic> rowData = [];
        bool isRowEmpty = true;

        for (var col = 0; col < columnCount; col++) {
          var cellValue = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
              .value;
          rowData.add(cellValue);

          if (cellValue != null) {
            isRowEmpty = false;
          }
        }

        if (isRowEmpty) {
          break;
        }

        data.add(rowData);
      }
    } catch (e) {
      print('Error reading Excel file: $e');
      rethrow;
    }

    return data;
  }

  Widget _buildDataTable() {
    // Determine the data to display
    List<ProductEntity> displayData =
        _searchController.text.isEmpty ? _excelData : _filteredData;

    if (displayData.isEmpty) {
      return const Center(child: Text('Карточки не найдены'));
    }

    // Calculate pagination
    int startIndex = _currentPage * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex > displayData.length ? displayData.length : endIndex;

    // Extract current page data
    List<ProductEntity> pageData = displayData.sublist(startIndex, endIndex);

    if (pageData.isNotEmpty) {
      pageData = pageData.sublist(1); // Skip the first index
    }

    // Helper method for generating DataColumns
    DataColumn _buildColumn(String label) {
      return DataColumn(
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    // Define table columns based on ProductModel attributes
    final firstProduct = _excelData.first;
    final columnLabels = [
      '${firstProduct.groupId}',
      firstProduct.sellersArticle,
      firstProduct.articleWB,
      firstProduct.productName,
      firstProduct.category,
      firstProduct.brand,
      firstProduct.barcode,
      firstProduct.size,
      firstProduct.russianSize,
    ];

    // Convert product attributes to a list for easier mapping
    List<String Function(ProductEntity)> productAttributes = [
      (p) => p.groupId.toString(),
      (p) => p.sellersArticle,
      (p) => p.articleWB,
      (p) => p.productName,
      (p) => p.category,
      (p) => p.brand,
      (p) => p.barcode,
      (p) => p.size,
      (p) => p.russianSize,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
        child: DataTable(
          dataRowMaxHeight: double.infinity,
          showCheckboxColumn: false,
          columns: columnLabels.map(_buildColumn).toList(),
          rows: pageData.map((product) {
            return DataRow(
              cells: productAttributes
                  .map((attr) => DataCell(
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 80),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                attr(product),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    if (_excelData.isEmpty) return const SizedBox.shrink();

    int totalPages = (_excelData.length / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 35,
          height: 35,
          child: IconButton(
            iconSize: 25,
            padding: const EdgeInsets.all(5),
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
          ),
        ),
        Text(
          'Страница ${_currentPage + 1} из $totalPages',
          style: const TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 35,
          height: 35,
          child: IconButton(
            iconSize: 25,
            padding: const EdgeInsets.all(5),
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages - 1
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        DropdownButton<int>(
          value: _rowsPerPage,
          items: [10, 20, 50, 100].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value рядов'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setState(() {
                _rowsPerPage = newValue;
                _currentPage = 0;
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductLoadingState) {
          // showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //         contentPadding: EdgeInsets.zero,
          //         backgroundColor: Colors.transparent,
          //         insetPadding: const EdgeInsets.symmetric(horizontal: 175),
          //         content: Container(
          //             decoration: BoxDecoration(
          //                 color: Colors.black.withOpacity(.6),
          //                 borderRadius:
          //                     const BorderRadius.all(Radius.circular(12.0))),
          //             width: 40,
          //             height: 40,
          //             child: const CupertinoActivityIndicator())));
        }

        if (state is ProductLoadedState) {
          // Navigator.of(context, rootNavigator: true).pop('dialog');
          setState(() {
            _excelData = state.products;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ваша база товаров'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                if (_excelData.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Статистика данных'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Кол-во Рядов: ${_excelData.length}'),
                          // Text('Total Columns: ${_excelData[0].length}'),
                          const Text('Начальный ряд: 3'),
                          Text('Рядов на странице: $_rowsPerPage'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isPlatformFilePickupLoading
                        ? null
                        : () => pickAndReadExcelFile(context),
                    child: _excelData.isNotEmpty
                        ? const Text('Обновить Exel данные')
                        : Text(_isPlatformFilePickupLoading
                            ? 'Загрузка...'
                            : 'Загрузить Exel файл'),
                  ),
                  const SizedBox(width: 10),
                  if (_excelData.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterData,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(right: 16, left: 5),child: _buildPagination(),),
            Expanded(
              child: _isPlatformFilePickupLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : _buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _buildVirtualizedTable() {
//   if (_excelData.isEmpty) return Center(child: Text('No data loaded'));
//
//   final columnCount = _excelData[0].length;
//   final rowCount = _excelData.length;
//
//   return Column(
//     children: [
//       // Header Row
//       Container(
//         height: 50,
//         child: ListView.builder(
//           controller: _horizontalController,
//           scrollDirection: Axis.horizontal,
//           itemCount: columnCount,
//           itemBuilder: (context, col) {
//             return Container(
//               width: 150,
//               decoration: const BoxDecoration(
//                 color: Colors.grey,
//                 // border: BoxBorder.all(color: Colors.grey.shade300),
//               ),
//               padding: EdgeInsets.all(8),
//               alignment: Alignment.center,
//               child: Text(
//                 _excelData[1][0]?.toString() ?? '',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             );
//           },
//         ),
//       ),
//       // Data Rows
//       Expanded(
//         child: ListView.builder(
//           controller: _verticalController,
//           itemCount: rowCount,
//           itemBuilder: (context, row) {
//             return Container(
//               height: 50,
//               child: ListView.builder(
//                 controller: _horizontalController,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: columnCount,
//                 itemBuilder: (context, col) {
//                   return Container(
//                     width: 150,
//                     decoration: BoxDecoration(
//                       // border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     padding: EdgeInsets.all(8),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       _excelData[row][col]?.toString() ?? '',
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }

// DataTable(
// showCheckboxColumn: false,
// columns: List<DataColumn>.generate(
// displayData[0].length,
// (index) => DataColumn(
// label: Text(
// '${displayData[0][index]}',
// style: const TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// rows: pageData.map((rowData) {
// return DataRow(
// cells: rowData.map((cellData) {
// return DataCell(
// SingleChildScrollView(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 200), child: Text(cellData?.toString() ?? ''))),
// );
// }).toList(),
// );
// }).toList(),
// )
