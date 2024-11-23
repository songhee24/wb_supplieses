import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/database/database.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  List<List<dynamic>> _excelData = [];
  List<List<dynamic>> _filteredData = [];
  bool _isPlatformFilePickupLoading = false;
  int _currentPage = 0;
  int _rowsPerPage = 10;

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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

        setState(() {
          _excelData = data;
        });
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
        _filteredData =
            _excelData.where((row) => matchesQuery(row, query)).toList();
        print('_filteredData $_filteredData');
      }
      _currentPage = 0; // Reset to the first page after filtering
    });
  }

  bool matchesQuery(List<dynamic> row, String query) {
    if (row.length > 1 &&
        row[1]?.toString().toLowerCase().contains(query.toLowerCase()) ==
            true) {
      return true;
    }
    if (row.length > 3 &&
        row[3]?.toString().toLowerCase().contains(query.toLowerCase()) ==
            true) {
      return true;
    }
    return false;
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
    // List<List<dynamic>> displayData = _searchController.text.isEmpty
    //     ? _excelData
    //     : _filteredData;
    //
    // if (displayData.isEmpty) return const Center(child: Text('No data found'));
    //
    // // Calculate pagination
    // int startIndex = _currentPage * _rowsPerPage + 1;
    // int endIndex = startIndex + _rowsPerPage;
    // if (endIndex > displayData.length) endIndex = displayData.length;
    //
    // // Get current page data
    // List<List<dynamic>> pageData = displayData.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if(state is ProductLoadedState) {
          // print('state ${state.products}');
        }
        return const SingleChildScrollView(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
          child: Text('data'),
        );
      }),
    );
  }

  Widget _buildPagination() {
    if (_excelData.isEmpty) return SizedBox.shrink();

    int totalPages = (_excelData.length / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text(
          'Page ${_currentPage + 1} of $totalPages',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
        const SizedBox(width: 20),
        DropdownButton<int>(
          value: _rowsPerPage,
          items: [10, 20, 50, 100].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value rows'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              if (_excelData.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Data Statistics'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Rows: ${_excelData.length}'),
                        Text('Total Columns: ${_excelData[0].length}'),
                        const Text('Starting Row: 3'),
                        Text('Rows per page: $_rowsPerPage'),
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
                  child: Text(_isPlatformFilePickupLoading
                      ? 'Loading...'
                      : 'Pick Excel File'),
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
          _buildPagination(),
          Expanded(
            child: _isPlatformFilePickupLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _buildDataTable(),
          ),
        ],
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
