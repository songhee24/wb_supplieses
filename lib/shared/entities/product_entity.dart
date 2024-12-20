import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? groupId;
  final String? boxId;
  final String sellersArticle;
  final String articleWB;
  final String productName;
  final String category;
  final String brand;
  final String barcode;
  final String size;
  final String russianSize;
  final int count;

  const ProductEntity({
    this.id,
    this.boxId,
    required this.groupId,
    required this.sellersArticle,
    required this.articleWB,
    required this.productName,
    required this.category,
    required this.brand,
    required this.barcode,
    required this.size,
    required this.russianSize,
    this.count = 0
  });

  @override
  List<Object?> get props => [
    id,
    boxId,
    groupId,
    sellersArticle,
    articleWB,
    productName,
    category,
    brand,
    barcode,
    size,
    russianSize,
    count,
  ];
}