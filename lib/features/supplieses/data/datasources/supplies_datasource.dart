import 'package:sqflite/sqflite.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

class SuppliesDatasource {
  final Database db;

  SuppliesDatasource({required this.db});


  Future<List<ProductModel>> searchProducts(String query) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: '''
        sellers_article LIKE ? OR 
        article_wb LIKE ? OR 
        product_name LIKE ?
      ''',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }
}