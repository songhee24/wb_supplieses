import 'package:cloud_firestore/cloud_firestore.dart';

final class Supplies {
  String? id;
  final int boxCount;
  final DateTime createdAt;

  Supplies({this.id, required this.boxCount, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'boxCount': boxCount,
      'created_at': createdAt,
    };
  }

  factory Supplies.fromMap(Map<String, dynamic> map) {
    return Supplies(
      boxCount: map['boxCount'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }


}