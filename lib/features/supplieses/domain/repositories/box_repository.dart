import 'package:wb_supplieses/shared/entities/product_entity.dart';

import '../entities/box_entity.dart';

abstract class BoxRepository {
  Future<BoxEntity>? createBox(BoxEntity box);

  Future<List<ProductEntity?>> searchProducts({required String query, String? size});

  Future<void> addBox({required String suppliesId, required String boxNumber,
    required List<ProductEntity> productEntities});

  Future<List<BoxEntity>?> getSupplyBoxesById(String suppliesId);

  Future<List<BoxEntity>> getBoxesBySuppliesId(String suppliesId);
}