part of 'box_bloc.dart';

sealed class BoxEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoxSearchProductsEvent extends BoxEvent {
  final String query;
  final String? size;

  BoxSearchProductsEvent({required this.query, this.size});

  @override
  List<Object> get props => [query];
}

// class BoxesBySuppliesIdEvent extends BoxEvent {
//   final String suppliesId;
//
//   BoxesBySuppliesIdEvent({required this.suppliesId});
// }

class BoxCreateEvent extends BoxEvent {
  final BoxEntity? boxEntity;

  BoxCreateEvent({this.boxEntity});

  @override
  List<Object?> get props => [boxEntity];
}

class BoxEditEvent extends BoxEvent {
  final String boxId;

  BoxEditEvent({required this.boxId});

  @override
  List<Object?> get props => [boxId];
}

// class BoxCreateAndFetchedBySuppliesIdEvent extends BoxEvent {
//   final String suppliesId;
//   final BoxEntity? boxEntity;
//   final bool isGetBoxesEnabled;
//
//   BoxCreateAndFetchedBySuppliesIdEvent({this.boxEntity, required this.suppliesId, this.isGetBoxesEnabled = false});
//
//   @override
//   List<Object?> get props => [boxEntity, suppliesId];
// }