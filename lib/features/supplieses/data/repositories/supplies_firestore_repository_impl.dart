import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/data/models/box_model.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/domain/repositories/supplies_repository.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

import '../../domain/entities/supplies_entity.dart';
import '../models/supplies_model.dart';


class SuppliesFirestoreRepositoryImpl implements SuppliesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<SuppliesEntity> addSupply(SuppliesEntity supply) async {
    final docRef = _firestore.collection('supplies').doc();
    final SuppliesModel model = SuppliesModel(
      id: docRef.id,
      boxCount: supply.boxCount,
      createdAt: supply.createdAt,
      name: supply.name,
      status: supply.status,
    );

    await docRef.set(model.toMap());
    return model.toEntity();
    // model.id = docRef.id;
  }

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
  Future<void> editSupply(String suppliesId, SuppliesEntity updatedSupply) async {
    try {
      final SuppliesModel model = SuppliesModel(
        boxCount: updatedSupply.boxCount,
        createdAt: updatedSupply.createdAt,
        name: updatedSupply.name,
        status: updatedSupply.status,
      );

      await _firestore
          .collection('supplies')
          .doc(suppliesId)
          .update(model.toMap());
    } catch (e) {
      throw Exception('Failed to edit supply: $e');
    }
  }

  @override
  Future<List<SuppliesModel>> getSupplies({String? status}) async {
    Query query = _firestore.collection('supplies');

    // Add a filter for the status if it's provided
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SuppliesModel.fromMap(data).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<SuppliesModel?> getSupplyById(String suppliesId) async {
    final docSnapshot = await _firestore.collection('supplies').doc(suppliesId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return SuppliesModel.fromMap(data).copyWith(id: docSnapshot.id);
    }
    return null;
  }

  @override
  Future<void> updateStatus(String suppliesId, String newStatus) async {
    await _firestore.collection('supplies').doc(suppliesId).update({'status': newStatus});
  }

  @override
  Future<void> deleteSupply(String suppliesId) async {
    try {
      // Get a new batch
      final WriteBatch batch = _firestore.batch();

      // Get all boxes that reference this supply
      final boxesSnapshot = await _firestore
          .collection('boxes')
          .where('suppliesId', isEqualTo: suppliesId)
          .get();

      // Add delete operations for all boxes to the batch
      for (final box in boxesSnapshot.docs) {
        batch.delete(box.reference);
      }

      // Add delete operation for the supply itself
      batch.delete(_firestore.collection('supplies').doc(suppliesId));

      // Commit the batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete supply: $e');
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
}