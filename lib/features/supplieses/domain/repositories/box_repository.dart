import 'package:wb_supplieses/shared/entities/product_entity.dart';

abstract class BoxRepository {
  Future<List<ProductEntity>> searchProducts(String query);
}