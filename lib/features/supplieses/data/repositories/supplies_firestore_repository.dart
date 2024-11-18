import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

class SuppliesFirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSupply(Supplies supply) async {
    final docRef = await _firestore.collection('supplies').add(supply.toMap());
    supply.id = docRef.id;
  }

  Future<List<Supplies>> getSupplies() async {
    final querySnapshot = await _firestore.collection('supplies').get();
    return querySnapshot.docs.map((doc) {
      return Supplies.fromMap(doc.data() as Map<String, dynamic>)..id = doc.id;
    }).toList();
  }

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