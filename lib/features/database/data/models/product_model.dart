import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    required super.groupId,
    required super.sellersArticle,
    required super.articleWB,
    required super.productName,
    required super.category,
    required super.brand,
    required super.barcode,
    required super.size,
    required super.russianSize,
  });

  // Convert ProductModel to ProductEntity if needed
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      groupId: groupId,
      sellersArticle: sellersArticle,
      articleWB: articleWB,
      productName: productName,
      category: category,
      brand: brand,
      barcode: barcode,
      size: size,
      russianSize: russianSize,
    );
  }

  factory ProductModel.fromExcelRow(List<dynamic> row) {
    return ProductModel(
      groupId: row[0] is int ? row[0] : null,
      sellersArticle: row[1]?.toString() ?? '',
      articleWB: row[2]?.toString() ?? '',
      productName: row[3]?.toString() ?? '',
      category: row[4]?.toString() ?? '',
      brand: row[5]?.toString() ?? '',
      barcode: row[6]?.toString() ?? '',
      size: row[7]?.toString() ?? '',
      russianSize: row[8]?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'sellers_article': sellersArticle,
      'article_wb': articleWB,
      'product_name': productName,
      'category': category,
      'brand': brand,
      'barcode': barcode,
      'size': size,
      'russian_size': russianSize,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      groupId: map['group_id'],
      sellersArticle: map['sellers_article'],
      articleWB: map['article_wb'],
      productName: map['product_name'],
      category: map['category'],
      brand: map['brand'],
      barcode: map['barcode'],
      size: map['size'],
      russianSize: map['russian_size'],
    );
  }
}



