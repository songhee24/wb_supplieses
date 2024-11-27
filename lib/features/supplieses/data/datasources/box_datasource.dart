import 'package:sqflite/sqflite.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

class BoxDatasource {
  final Database db;

  BoxDatasource({required this.db});


  Future<List<ProductModel>> searchProducts({required String query, String? size}) async {
    // Base query components
    String whereClause = '''
    (sellers_article LIKE ? OR 
     article_wb LIKE ? OR 
     product_name LIKE ?)
  ''';
    List<String> whereArgs = ['%$query%', '%$query%', '%$query%'];

    // If size is provided, add it as an additional condition
    if (size != null && size.isNotEmpty) {
      whereClause += ' AND size = ?';
      whereArgs.add(size); // Exact match for size
    }

    // Execute the query
    final List<Map<String, dynamic>> maps = await db.query(
      'exel_products',
      where: whereClause,
      whereArgs: whereArgs,
    );

    // Map results to ProductModel instances
    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }
}