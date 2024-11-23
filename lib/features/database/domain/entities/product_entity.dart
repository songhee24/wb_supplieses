import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? groupId;
  final String sellersArticle;
  final String articleWB;
  final String productName;
  final String category;
  final String brand;
  final String barcode;
  final String size;
  final String russianSize;

  const ProductEntity({
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

  @override
  List<Object?> get props => [
    id,
    groupId,
    sellersArticle,
    articleWB,
    productName,
    category,
    brand,
    barcode,
    size,
    russianSize,
  ];
}