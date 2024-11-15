import 'package:cloud_firestore/cloud_firestore.dart';

final class Supplies {
  String? id;
  final int? boxCount;
  final DateTime createdAt;
  final String name;

  Supplies({this.id, required this.name, this.boxCount = 0, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'boxCount': boxCount,
      'created_at': createdAt,
      'name': name,
    };
  }

  factory Supplies.fromMap(Map<String, dynamic> map) {
    return Supplies(
      name: map['name'],
      boxCount: map['boxCount'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }


}