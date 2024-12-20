import '../entities/box_entity.dart';
import '../entities/supplies_entity.dart';

abstract class SuppliesRepository {
  Future<void> addSupply(SuppliesEntity supply);
  Future<List<SuppliesEntity>> getSupplies({String? status});
  Future<SuppliesEntity?> getSupplyById(String suppliesId);
  Future<void> editSupply(String suppliesId, SuppliesEntity updatedSupply);
  Future<void> updateStatus(String suppliesId, String newStatus);
  Future<void> deleteSupply(String suppliesId);
  Future<void> sendSupplyToExtension({
    required String suppliesId,
    required List<BoxEntity> boxes,
  });
}