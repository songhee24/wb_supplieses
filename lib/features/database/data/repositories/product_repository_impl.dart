import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_database_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalDatabaseDatasource localDatasource;

  ProductRepositoryImpl({required this.localDatasource});

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final products = await localDatasource.getAllProducts();
      return products
          .map<ProductEntity>((p) => ProductEntity(
              groupId: p.groupId,
              sellersArticle: p.sellersArticle,
              articleWB: p.articleWB,
              productName: p.productName,
              category: p.category,
              brand: p.brand,
              barcode: p.barcode,
              size: p.size,
              russianSize: p.russianSize))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<void> loadExcelData(List<ProductModel> excelData) async {
    try {
      // Skip header row, start from index 1
      List<ProductModel> products = excelData.sublist(1).map((row) {
        return ProductModel.fromExcelRow(excelData);
      }).toList();

      // Clear existing data and insert new products
      await localDatasource.deleteAllProducts();
      await localDatasource.insertBulkProducts(products);
    } catch (e) {
      throw Exception('Failed to load Excel data: ${e.toString()}');
    }
  }
}
