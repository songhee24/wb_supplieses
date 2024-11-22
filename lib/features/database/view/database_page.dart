import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  List<List<dynamic>> _excelData = [];
  List<List<dynamic>> _filteredData = [];
  bool _isLoading = false;
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
  Future<void> pickAndReadExcelFile() async {
    setState(() {
      _isLoading = true;
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

        setState(() {
          _excelData = data;
        });
      }
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to read Excel file: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _excelData;
      } else {
        _filteredData = _excelData
            .where((row) => row.any(
              (cell) =>
          cell?.toString().toLowerCase().contains(query.toLowerCase()) ?? false,
        ))
            .toList();
      }
      _currentPage = 0; // Reset to the first page after filtering
    });
  }


  Future<List<List<dynamic>>> readExcelFile(PlatformFile file) async {
    List<List<dynamic>> data = [];
    final int MAX_COLUMNS = 10;
    final int START_ROW = 3;

    try {
      late List<int> bytes;

      if (file.bytes != null) {
        bytes = file.bytes!;
      } else {
        bytes = File(file.path!).readAsBytesSync();
      }

      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];

      int columnCount = sheet!.maxColumns > MAX_COLUMNS ? MAX_COLUMNS : sheet.maxColumns;

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
    if (_excelData.isEmpty) return Center(child: Text('No data loaded'));

    // Calculate pagination
    int startIndex = _currentPage * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > _excelData.length) endIndex = _excelData.length;

    // Get current page data
    List<List<dynamic>> pageData = _excelData.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 60),
        child: DataTable(
          showCheckboxColumn: false,
          columns: List<DataColumn>.generate(
            _excelData[0].length,
                (index) => DataColumn(
              label: Text(
                'Column ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          rows: pageData.map((rowData) {
            return DataRow(
              cells: rowData.map((cellData) {
                return DataCell(
                  Text(cellData?.toString() ?? ''),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    if (_excelData.isEmpty) return SizedBox.shrink();

    int totalPages = (_excelData.length / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
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
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () {
            setState(() {
              _currentPage++;
            });
          }
              : null,
        ),
        SizedBox(width: 20),
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
        title: Text('Excel Reader'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              if (_excelData.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Data Statistics'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Rows: ${_excelData.length}'),
                        Text('Total Columns: ${_excelData[0].length}'),
                        Text('Starting Row: 3'),
                        Text('Rows per page: $_rowsPerPage'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : pickAndReadExcelFile,
              child: Text(_isLoading ? 'Loading...' : 'Pick Excel File'),
            ),
          ),
          _buildPagination(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
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