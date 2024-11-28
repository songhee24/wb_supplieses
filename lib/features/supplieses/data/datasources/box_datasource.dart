import 'package:sqflite/sqflite.dart';
import 'package:wb_supplieses/features/supplieses/data/models/box_model.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

class BoxDatasource {
  final Database db;

  BoxDatasource({required this.db});

  Future<int> insertBox(BoxModel box) async {
    // Start a transaction to ensure atomic operations
    return await db.transaction((txn) async {
      // If a `boxId` exists, clear previous products for this box
      // if (box.id != null) {
      //   await txn.delete(
      //     'box_products',
      //     where: 'box_id = ?',
      //     whereArgs: [box.id],
      //   );
      // }
      //
      // // Insert the Box if it doesn't already exist
      // int boxId;
      // if (box.id == null) {
      //   boxId = await txn.insert('box', {
      //     'supplies_id': box.suppliesId,
      //     'box_number': int.parse(box.boxNumber),
      //   });
      // } else {
      //   boxId = int.parse(box.id!);
      // }

      int boxId;

      if (box.id != null) {
        // If a `boxId` exists, update the box_number
        await txn.update(
          'box',
          {'box_number': int.parse(box.boxNumber)},
          where: 'id = ?',
          whereArgs: [box.id],
        );

        // Clear previous products for this box
        await txn.delete(
          'box_products',
          where: 'box_id = ?',
          whereArgs: [box.id],
        );

        // Use the existing boxId
        boxId = int.parse(box.id!);
      } else {
        // Insert a new Box if `box.id` is null
        boxId = await txn.insert('box', {
          'supplies_id': box.suppliesId,
          'box_number': int.parse(box.boxNumber),
        });
      }

      // Insert the associated product models into the `box_products` table
      // print('insertBox box $box |. boxId $boxId');
      if (box.productModels != null && box.productModels!.isNotEmpty) {
        for (var product in box.productModels!) {
          await txn.insert('box_products', {
            'box_id': boxId,
            'group_id': product.groupId,
            'sellers_article': product.sellersArticle,
            'article_wb': product.articleWB,
            'product_name': product.productName,
            'category': product.category,
            'brand': product.brand,
            'barcode': product.barcode,
            'size': product.size,
            'russian_size': product.russianSize,
            'count': product.count,
          });
        }
      } else {

      }

      return boxId;
    });
  }

  // Future<int> insertBox(BoxModel box) async {
  //   return await db.transaction((txn) async {
  //     // Insert the box and get its generated ID
  //     final boxId = await txn.insert('box', {
  //       'supplies_id': box.suppliesId,
  //       'box_number': box.boxNumber,
  //     });
  //
  //     // Insert each product associated with the box
  //     if (box.productEntities != null && box.productEntities!.isNotEmpty) {
  //       for (var product in box.productEntities!) {
  //         await txn.insert('box_products', {
  //           'box_id': boxId,
  //           'group_id': product.groupId,
  //           'sellers_article': product.sellersArticle,
  //           'article_wb': product.articleWB,
  //           'product_name': product.productName,
  //           'category': product.category,
  //           'brand': product.brand,
  //           'barcode': product.barcode,
  //           'size': product.size,
  //           'russian_size': product.russianSize,
  //         });
  //       }
  //     }
  //
  //     return boxId; // Return the newly created box's ID
  //   });
  // }

  Future<List<ProductModel>> searchProducts(
      {required String query, String? size}) async {
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

  Future<List<BoxModel>> getBoxesBySuppliesId(String suppliesId) async {
    // Fetch all boxes for the given supplies_id
    final boxRows = await db.query(
      'box',
      where: 'supplies_id = ?',
      whereArgs: [suppliesId],
    );

    // If no boxes are found, return an empty list
    if (boxRows.isEmpty) return [];

    // Fetch products for each box and construct the entities
    List<BoxModel> boxes = [];
    for (var boxRow in boxRows) {
      final boxId = boxRow['id'] as int;
      // print('boxId $boxId');
      // Fetch associated products for the current box
      final productRows = await db.query(
        'box_products',
        where: 'box_id = ?',
        whereArgs: [boxId],
      );

      // print('productRows $productRows');

      // Map the product rows to ProductEntity
      final productModels = productRows.map((productRow) {
        return ProductModel(
          id: productRow['id'] as int?,
          groupId: productRow['group_id'] as String?,
          boxId: productRow['box_id'] as String?,
          sellersArticle: productRow['sellers_article'] as String,
          articleWB: productRow['article_wb'] as String,
          productName: productRow['product_name'] as String,
          category: productRow['category'] as String,
          brand: productRow['brand'] as String,
          barcode: productRow['barcode'] as String,
          size: productRow['size'] as String,
          russianSize: productRow['russian_size'] as String,
          count: productRow['count'] as int,
        );
      }).toList();

      // Add the box entity with its products
      boxes.add(BoxModel(
        id: boxId.toString(),
        suppliesId: boxRow['supplies_id'] as String?,
        boxNumber: boxRow['box_number'].toString(),
        productModels: productModels,
      ));
    }

    return boxes;
  }


  Future<BoxModel?> getBoxById(int boxId) async {
    // Query the box table to get the box details
    final boxResult = await db.query(
      'box',
      where: 'id = ?',
      whereArgs: [boxId],
    );

    if (boxResult.isEmpty) {
      return null; // No box found for the given boxId
    }

    // Extract the box data
    final boxData = boxResult.first;

    // Query the box_products table to get the related products
    final productResults = await db.query(
      'box_products',
      where: 'box_id = ?',
      whereArgs: [boxId],
    );

    // Map the products to a list of ProductModel
    final productModels = productResults.map((productData) {
      return ProductModel(
        groupId: productData['group_id'] as String?,
        sellersArticle: productData['sellers_article'] as String,
        articleWB: productData['article_wb'] as String,
        productName: productData['product_name'] as String,
        category: productData['category'] as String,
        brand: productData['brand'] as String,
        barcode: productData['barcode'] as String,
        size: productData['size'] as String,
        russianSize: productData['russian_size'] as String,
        count: productData['count'] as int,
      );
    }).toList();

    // Return the BoxModel
    return BoxModel(
      id: boxData['id'].toString(),
      suppliesId: boxData['supplies_id'] as String,
      boxNumber: (boxData['box_number'] as int).toString(),
      productModels: productModels,
    );
  }

  Future<void> deleteBoxById(int boxId) async {
    await db.transaction((txn) async {
      // Delete all products related to the box
      await txn.delete(
        'box_products',
        where: 'box_id = ?',
        whereArgs: [boxId],
      );

      // Delete the box itself
      await txn.delete(
        'box',
        where: 'id = ?',
        whereArgs: [boxId],
      );
    });
  }

}
