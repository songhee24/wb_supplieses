part of 'box_bloc.dart';

abstract class BoxState extends Equatable {
  const BoxState();

  @override
  List<Object?> get props => [];
}

class BoxInitial extends BoxState {}

class BoxSearchLoading extends BoxState {}

class BoxSearchSuccess extends BoxState {
  final List<ProductEntity?> products;

  const BoxSearchSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class BoxSearchError extends BoxState {
  final String message;

  const BoxSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
