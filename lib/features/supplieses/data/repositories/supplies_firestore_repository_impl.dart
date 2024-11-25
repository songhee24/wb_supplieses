import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/domain/repositories/supplies_repository.dart';

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
}