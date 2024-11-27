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

class BoxCreateEvent extends BoxEvent {
  final BoxEntity boxEntity;

  BoxCreateEvent({required this.boxEntity});

  @override
  List<Object?> get props => [boxEntity];
}