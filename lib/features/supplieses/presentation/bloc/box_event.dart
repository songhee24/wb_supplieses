import 'package:equatable/equatable.dart';

sealed class BoxEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoxSearchProducts extends BoxEvent {
  final String query;

  BoxSearchProducts({required this.query});

  @override
  List<Object> get props => [query];
}