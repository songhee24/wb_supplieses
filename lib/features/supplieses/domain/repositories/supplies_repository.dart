import '../entities/supplies_entity.dart';

abstract class SuppliesRepository {
  Future<void> addSupply(SuppliesEntity supply);
  Future<List<SuppliesEntity>> getSupplies({String? status});
  Future<SuppliesEntity?> getSupplyById(String suppliesId);
  Future<SuppliesEntity?> getSupplyBoxesById(String suppliesId);
  Future<void> editSupply(String suppliesId, SuppliesEntity updatedSupply);
  Future<void> updateStatus(String suppliesId, String newStatus);
  Future<void> deleteSupply(String suppliesId);
}