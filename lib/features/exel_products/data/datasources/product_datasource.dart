import 'package:sqflite/sqflite.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';


class ProductDatasource {
  final Database db;

  ProductDatasource({required this.db});

  Future<int> insertProduct(ProductModel product) async {
    return await db.insert('exel_products', product.toMap());
  }

  Future<List<ProductModel>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await db.query('exel_products');
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<void> insertBulkProducts(List<ProductModel> products) async {
    try {
      if (products.isEmpty) {
        return;
      }

      final batch = db.batch();

      for (var product in products) {
        final productMap = product.toMap();
        batch.insert('exel_products', productMap);
      }

      await batch.commit(noResult: true);
    } catch(e) {
      throw Exception('Failed to insert bulk products: ${e.toString()}');
    }
  }

  Future<void> deleteAllProducts() async {
    await db.delete('exel_products');
  }

}
