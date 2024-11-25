
import '../../../../shared/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
// import '../datasources/local_database_datasource.dart';
import '../datasources/product_datasource.dart';
import '../../../../shared/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource productDatasource;

  ProductRepositoryImpl({required this.productDatasource});

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final products = await productDatasource.getAllProducts();
      print('products $products');
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
  Future<void> loadExcelData(List<List<dynamic>> excelData) async {
    try {

      // print('excelData $excelData');
      // Skip header row, start from index 1 if you need
      List<ProductModel> products = excelData.sublist(0).map((row) {
        // print("row $row");
        return ProductModel.fromExcelRow(row);
      }).toList();


      // Clear existing data and insert new products
      await productDatasource.deleteAllProducts();
      await productDatasource.insertBulkProducts(products);
    } catch (e) {
      throw Exception('Failed to load Excel data: ${e.toString()}');
    }
  }
}
