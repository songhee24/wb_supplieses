import 'package:wb_supplieses/shared/entities/product_entity.dart';

import '../entities/box_entity.dart';
import '../entities/supplies_entity.dart';

abstract class SuppliesRepository {
  Future<void> addSupply(SuppliesEntity supply);
  Future<List<SuppliesEntity>> getSupplies({String? status});
  Future<SuppliesEntity?> getSupplyById(String suppliesId);
  Future<void> editSupply(String suppliesId, SuppliesEntity updatedSupply);
  Future<void> updateStatus(String suppliesId, String newStatus);
  Future<void> deleteSupply(String suppliesId);

  Future<void> addBox({required String suppliesId, required String boxNumber,
    required List<ProductEntity> productEntities});

  Future<List<BoxEntity>?> getSupplyBoxesById(String suppliesId);
}