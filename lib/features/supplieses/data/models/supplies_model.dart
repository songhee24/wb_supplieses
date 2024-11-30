import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wb_supplieses/features/supplieses/data/models/box_model.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';

final class SuppliesModel extends SuppliesEntity {
  const SuppliesModel({super.boxes, super.id, super.boxCount, required super.createdAt, required super.name, required super.status,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'boxes': boxes,
      'boxCount': boxCount,
      'created_at': createdAt,
      'name': name,
      'status': status,
    };
  }

  SuppliesModel copyWith({String? id,  List<BoxEntity>? boxes}) {
    return SuppliesModel(
      id: id ?? this.id,
      boxCount: boxCount,
      createdAt: createdAt,
      name: name,
      status: status,
      boxes: boxes ?? this.boxes
    );
  }

  factory SuppliesModel.fromMap(Map<String, dynamic> map) {
    return SuppliesModel(
      name: map['name'],
      boxCount: map['boxCount'],
      boxes:map['boxes'] != null ? (map['boxes'] as List<dynamic>)
          .map((box) => BoxModel.fromMap(box as Map<String, dynamic>))
          .toList() : [],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      status: map['status'],
    );
  }

  SuppliesEntity toEntity() {
    return SuppliesEntity(id: id, boxCount: boxCount, boxes: boxes, createdAt: createdAt, name: name, status: status,);
  }
}
