import '../../data/models/product_model.dart';
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

    List<ProductModel> products = excelData.sublist(0).map((row) {
      print('row $row');
      // TODO need to update or check
      return ProductModel.fromExcelRow(row);
    }).toList();

    // Load data through repository
    await repository.loadExcelData(products);

    // Fetch and return loaded products
    return await repository.getAllProducts();
  }
}