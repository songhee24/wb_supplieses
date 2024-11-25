import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/domain/repositories/box_repository.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

import '../models/box_model.dart';

class BoxFirestoreRepositoryImpl implements BoxRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addBox({required String suppliesId, required String boxNumber,
    required List<ProductEntity> productEntities}) async {
    try {

      final initialBox = BoxModel(
        id: null, // ID will be assigned after saving
        suppliesId: suppliesId,
        boxNumber: boxNumber,
        productModels: [],
      );

      final boxDocRef = await _firestore.collection('boxes').add(initialBox.toMap());
      final boxId = boxDocRef.id;

      final boxWithId = initialBox.copyWith(id: boxId);

      // Map ProductEntities to ProductModels and then to Firestore-friendly format
      // Step 2: Save Product Models
      final productModels = productEntities.map((productEntity) {
        final productModel = ProductModel(
          id: productEntity.id,
          groupId: productEntity.groupId,
          sellersArticle: productEntity.sellersArticle,
          articleWB: productEntity.articleWB,
          productName: productEntity.productName,
          category: productEntity.category,
          brand: productEntity.brand,
          barcode: productEntity.barcode,
          size: productEntity.size,
          russianSize: productEntity.russianSize,
        );
        return productModel.toMap();
      }).toList();

      for (final product in productModels) {
        await _firestore.collection('products').add({
          ...product,
          'boxId': boxId, // Link the product to the box
        });
      }

      // Step 3: Increment Box Count in the Related Supply
      final supplyDocRef = _firestore.collection('supplies').doc(suppliesId);

      await _firestore.runTransaction((transaction) async {
        final supplySnapshot = await transaction.get(supplyDocRef);

        if (!supplySnapshot.exists) {
          throw Exception('Supply with ID $suppliesId not found');
        }

        final currentBoxCount = supplySnapshot.data()?['boxCount'] ?? 0;

        // Increment the box count
        transaction.update(supplyDocRef, {
          'boxCount': currentBoxCount + 1,
        });
      });
    } catch (e) {
      // Handle and throw an error if something goes wrong
      throw Exception('Failed to add box: $e');
    }
  }

  @override
  Future<List<BoxEntity>?> getSupplyBoxesById(String suppliesId) async {
    try {
      // Step 1: Fetch related boxes from the 'boxes' collection
      final boxQuerySnapshot = await _firestore
          .collection('boxes')
          .where('suppliesId', isEqualTo: suppliesId)
          .get();

      // Step 2: Map each box and fetch its associated products
      final boxes = await Future.wait(boxQuerySnapshot.docs.map((boxDoc) async {
        final boxData = boxDoc.data();

        // Step 2.1: Fetch products for the current box
        final productQuerySnapshot = await _firestore
            .collection('products')
            .where('boxId', isEqualTo: boxDoc.id)
            .get();

        final productEntities = productQuerySnapshot.docs.map((productDoc) {
          final productData = productDoc.data();
          return ProductModel.fromMap(productData).toEntity();
        }).toList();

        // Step 2.2: Map the box with its products
        return BoxModel.fromMap({
          'id': boxDoc.id,
          'suppliesId': boxData['suppliesId'],
          'boxNumber': boxData['boxNumber'],
          'productEntities': productEntities,
        }).toEntity();
      }).toList());


      return boxes;
    } catch(e) {
      throw Exception('Failed to get supply boxes: $e');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }
}