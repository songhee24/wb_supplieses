import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxEntity extends Equatable {
  final String? id;
  final String? suppliesId;
  final String boxNumber;
  final List<ProductEntity>? productEntities;

  const BoxEntity({required this.id,  required this.boxNumber, this.productEntities, required this.suppliesId,});

  @override
  List<Object?> get props => [id, productEntities, suppliesId, boxNumber];
}