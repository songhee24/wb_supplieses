import '../../data/models/product_model.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<void> loadExcelData(List<ProductModel> products);
}