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
  bool _isLoading = false;
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
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


  Future<List<List<dynamic>>> readExcelFile(PlatformFile file) async {
    List<List<dynamic>> data = [];
    const int MAX_COLUMNS = 10;  // Limit to 10 columns
    const int START_ROW = 3;     // Start from row 3

    try {
      late List<int> bytes;

      if (file.bytes != null) {
        bytes = file.bytes!;
      } else {
        bytes = File(file.path!).readAsBytesSync();
      }

      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];

      // Get actual number of columns (limited to 10)
      int columnCount = sheet!.maxColumns > MAX_COLUMNS ? MAX_COLUMNS : sheet.maxColumns;

      // Process rows starting from row 3
      for (var row = START_ROW; row < sheet.maxRows; row++) {
        List<dynamic> rowData = [];
        bool isRowEmpty = true;

        // Read only up to 10 columns
        for (var col = 0; col < columnCount; col++) {
          var cellValue = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
              .value;
          rowData.add(cellValue);

          // Check if cell has data
          if (cellValue != null) {
            isRowEmpty = false;
          }
        }

        // If row is empty, stop reading further rows
        if (isRowEmpty) {
          break;
        }

        // Add non-empty row to data
        data.add(rowData);
      }
    } catch (e) {
      print('Error reading Excel file: $e');
      rethrow;
    }

    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Reader'),
      ),
      body: Column(
        children: [
          // Pick file button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : pickAndReadExcelFile,
              child: Text(_isLoading ? 'Loading...' : 'Pick Excel File'),
            ),
          ),

          // Data display
          Expanded(
            child: _excelData.isEmpty
                ? Center(
              child: Text('No data loaded'),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: List<DataColumn>.generate(
                    _excelData[0].length,
                        (index) => DataColumn(
                      label: Text('Column ${index + 1}'),
                    ),
                  ),
                  rows: _excelData.map((rowData) {
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
            ),
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