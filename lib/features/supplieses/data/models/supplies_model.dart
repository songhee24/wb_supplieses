import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';

final class SuppliesModel extends SuppliesEntity {
  const SuppliesModel({super.id, super.boxCount, required super.createdAt, required super.name, required super.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'boxCount': boxCount,
      'created_at': createdAt,
      'name': name,
      'status': status,
    };
  }

  SuppliesModel copyWith({String? id}) {
    return SuppliesModel(
      id: id ?? this.id,
      boxCount: boxCount,
      createdAt: createdAt,
      name: name,
      status: status,
    );
  }

  factory SuppliesModel.fromMap(Map<String, dynamic> map) {
    return SuppliesModel(
      name: map['name'],
      boxCount: map['boxCount'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      status: map['status'],
    );
  }

  SuppliesEntity toEntity() {
    return SuppliesEntity(id: id, boxCount: boxCount, createdAt: createdAt, name: name, status: status,);
  }
}
