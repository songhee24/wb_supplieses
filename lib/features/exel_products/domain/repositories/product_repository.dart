import 'package:wb_supplieses/shared/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<void> loadExcelData(List<List<dynamic>> excelData);
}