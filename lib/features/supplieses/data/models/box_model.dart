import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/shared/models/product_model.dart';

class BoxModel extends BoxEntity {
  final List<ProductModel?> productModels;

  const BoxModel({required super.id, required this.productModels}) : super(productEntity: productModels);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productEntity': productModels.map((product) => product?.toMap()).toList(),
    };
  }

  BoxModel copyWith({String? id, List<ProductModel?>? productModels}) {
    return BoxModel(
      id: id ?? this.id,
      productModels: productModels ?? this.productModels,
    );
  }

  factory BoxModel.fromMap(Map<String, dynamic> map) {
    return BoxModel(
      id: map['id'] as String?,
      productModels: (map['productEntity'] as List<dynamic>)
          .map((productMap) => ProductModel.fromMap(productMap as Map<String, dynamic>))
          .toList(),
    );
  }

  BoxEntity toEntity() {
    return BoxEntity(
      id: id,
      productEntity: productModels,
    );
  }
}