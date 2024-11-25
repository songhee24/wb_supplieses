import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';

class ProductDatasource {
  final Database db;

  ProductDatasource({required this.db});

  Future<int> insertProduct(ProductModel product) async {
    return await db.insert('products', product.toMap());
  }

  Future<List<ProductModel>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<void> insertBulkProducts(List<ProductModel> products) async {
    final batch = db.batch();

    for (var product in products) {
      batch.insert('products', product.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteAllProducts() async {
    await db.delete('products');
  }

}
