import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class LoadExcelDataUseCase {
  final ProductRepository repository;

  LoadExcelDataUseCase(this.repository);

  Future<List<ProductEntity>> call(List<List<dynamic>> excelData) async {
    // Validate data
    if (excelData.length <= 1) {
      throw Exception('No valid data in Excel file');
    }

    // List<ProductModel> products = excelData.sublist(0).map((row) {
    //   return ProductModel.fromExcelRow(row);
    // }).toList();
    //
    // print('products $products');

    // Load data through repository
    await repository.loadExcelData(excelData);

    // Fetch and return loaded products
    return await repository.getAllProducts();
  }
}