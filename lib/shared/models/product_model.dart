import '../entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel(
      {super.id,
      super.boxId,
      required super.groupId,
      required super.sellersArticle,
      required super.articleWB,
      required super.productName,
      required super.category,
      required super.brand,
      required super.barcode,
      required super.size,
      required super.russianSize,
      super.count});

  // Convert ProductModel to ProductEntity if needed
  ProductEntity toEntity() {
    return ProductEntity(
        id: id,
        boxId: boxId,
        groupId: groupId,
        sellersArticle: sellersArticle,
        articleWB: articleWB,
        productName: productName,
        category: category,
        brand: brand,
        barcode: barcode,
        size: size,
        russianSize: russianSize,
        count: count);
  }

  factory ProductModel.fromExcelRow(List<dynamic> row) {
    return ProductModel(
        groupId: row[0] == null ? '' : row[0].toString(),
        // groupId: row[0],
        sellersArticle: row[1]?.toString() ?? '',
        articleWB: row[2]?.toString() ?? '',
        productName: row[3]?.toString() ?? '',
        category: row[4]?.toString() ?? '',
        brand: row[5]?.toString() ?? '',
        barcode: row[6]?.toString() ?? '',
        size: row[7]?.toString() ?? '',
        russianSize: row[8]?.toString() ?? '',
        count: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId == null ? '' : groupId.toString(),
      'box_id': boxId,
      'sellers_article': sellersArticle,
      'article_wb': articleWB,
      'product_name': productName,
      'category': category,
      'brand': brand,
      'barcode': barcode,
      'size': size,
      'russian_size': russianSize,
      'count': count
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        id: map['id'],
        boxId: map['boxId'],
        groupId: map['group_id'].toString(),
        sellersArticle: map['sellers_article'],
        articleWB: map['article_wb'],
        productName: map['product_name'],
        category: map['category'],
        brand: map['brand'],
        barcode: map['barcode'],
        size: map['size'],
        russianSize: map['russian_size'],
        count: map['count']);
  }

  ProductModel copyWith({int? count}) {
    return ProductModel(
        groupId: groupId,
        sellersArticle: sellersArticle,
        articleWB: articleWB,
        productName: productName,
        category: category,
        brand: brand,
        barcode: barcode,
        size: size,
        russianSize: russianSize,
        count: count ?? this.count);
  }
}
