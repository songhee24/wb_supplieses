part of 'box_bloc.dart';

abstract class BoxState extends Equatable {
  const BoxState();

  @override
  List<Object?> get props => [];
}


class BoxInitial extends BoxState {}

class BoxSearchLoading extends BoxState {}

class BoxManageLoading extends BoxState {}

class BoxSearchSuccess extends BoxState {
  final List<ProductEntity?> products;

  const BoxSearchSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

// class BoxesBySuppliesIdSuccess extends BoxState {
//   final List<BoxEntity>? boxEntities;
//
//   const BoxesBySuppliesIdSuccess({required this.boxEntities});
//
//   @override
//   List<Object?> get props => [boxEntities];
// }

class BoxCreatedSuccess extends BoxState {
  final String boxId;
  const BoxCreatedSuccess(this.boxId);
}


class BoxError extends BoxState {
  final String message;

  const BoxError(this.message);

  @override
  List<Object?> get props => [message];
}


// class BoxCreateAndFetchedSuppliesIdSuccess extends BoxState {
//   final List<BoxEntity>? boxEntities;
//   final String? boxId;
//
//   const BoxCreateAndFetchedSuppliesIdSuccess({this.boxId, this.boxEntities});
//
//   @override
//   List<Object?> get props => [boxId, boxEntities];
// }