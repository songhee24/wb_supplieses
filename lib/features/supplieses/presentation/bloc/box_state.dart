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

class BoxGetByIdSuccess extends BoxState {
  final BoxEntity? boxEntity;

  const BoxGetByIdSuccess({required this.boxEntity});

  @override
  List<Object?> get props => [boxEntity];
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

class BoxDeleteSuccess extends BoxState {}

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