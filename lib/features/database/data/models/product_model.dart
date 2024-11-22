class ProductModel {
  final int? id;
  final int? groupId;
  final String sellersArticle;
  final String articleWB;
  final String productName;
  final String category;
  final String brand;
  final String barcode;
  final String size;
  final String russianSize;

  ProductModel({
    this.id,
    required this.groupId,
    required this.sellersArticle,
    required this.articleWB,
    required this.productName,
    required this.category,
    required this.brand,
    required this.barcode,
    required this.size,
    required this.russianSize,
  });

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