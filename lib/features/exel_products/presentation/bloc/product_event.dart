
part of 'product_bloc.dart';
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadExcelDataEvent extends ProductEvent {
  final List<List<dynamic>> excelData;

  const LoadExcelDataEvent(this.excelData);

  @override
  List<Object> get props => [excelData];
}

class FetchProductsEvent extends ProductEvent {}