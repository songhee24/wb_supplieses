import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSupply(Supplies supply) async {
    final docRef = await _firestore.collection('supplies').add(supply.toMap());
    supply.id = docRef.id;
  }
}