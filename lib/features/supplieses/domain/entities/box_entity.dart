import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

class BoxEntity extends Equatable {
  final String? id;
  final List<ProductEntity?> productEntity;

  const BoxEntity({required this.id, required this.productEntity});

  @override
  List<Object?> get props => [id, productEntity];
}