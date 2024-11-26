import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

enum BoxProductSearchStatus { initial, loading, success, successEdit, failure }

final class BoxState extends Equatable {
  final BoxProductSearchStatus boxProductSearchStatus;
  final String boxNumber;
  final List<ProductEntity> productEntities;

  const BoxState({
    required this.boxProductSearchStatus,
    required this.boxNumber,
    this.productEntities = const <ProductEntity>[],
  });

  @override
  List<Object?> get props => [boxProductSearchStatus, productEntities];
}
