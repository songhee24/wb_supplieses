part of 'supplies_bloc.dart';

sealed class SuppliesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SuppliesCreateNewEvent extends SuppliesEvent {
  final int boxCount;
  final String name;

  SuppliesCreateNewEvent({required this.name, this.boxCount = 0});

  @override
  List<Object> get props => [name, boxCount];
}

final class SuppliesGetEvent extends SuppliesEvent {
  @override
  List<Object> get props => [];
}

