part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductEntity> products;

  const ProductLoadedState(this.products);

  @override
  List<Object> get props => [products];
}

class ProductErrorState extends ProductState {
  final String errorMessage;

  const ProductErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}