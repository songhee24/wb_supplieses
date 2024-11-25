import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

class BoxModel extends BoxEntity {
  final List<ProductModel?> productModels;

  const BoxModel(
      {required super.id,
      required this.productModels,
      super.suppliesId,
      required super.boxNumber})
      : super(productEntities: productModels);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productEntity':
          productModels.map((product) => product?.toMap()).toList(),
    };
  }

  BoxModel copyWith({String? id, List<ProductModel?>? productModels}) {
    return BoxModel(
        id: id ?? this.id,
        productModels: productModels ?? this.productModels,
        boxNumber: boxNumber,
        suppliesId: suppliesId);
  }

  factory BoxModel.fromMap(Map<String, dynamic> map) {
    return BoxModel(
        id: map['id'] as String?,
        productModels: (map['productEntity'] as List<dynamic>)
            .map((productMap) =>
                ProductModel.fromMap(productMap as Map<String, dynamic>))
            .toList(),
        boxNumber: map['boxNumber'],
        suppliesId: map['suppliesId']);
  }

  BoxEntity toEntity() {
    return BoxEntity(
      suppliesId: suppliesId,
      id: id,
      productEntities: productModels,
      boxNumber: boxNumber,
    );
  }
}
