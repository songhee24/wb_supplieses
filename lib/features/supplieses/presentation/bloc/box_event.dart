part of 'box_bloc.dart';

sealed class BoxEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoxSearchProductsEvent extends BoxEvent {
  final String query;

  BoxSearchProductsEvent({required this.query});

  @override
  List<Object> get props => [query];
}