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

class SuppliesEditEvent extends SuppliesEvent {
  final String suppliesId;
  final SuppliesEntity updatedSupply;

  SuppliesEditEvent({required this.suppliesId, required this.updatedSupply});

  @override
  List<Object> get props => [suppliesId, updatedSupply];
}

final class SuppliesGetEvent extends SuppliesEvent {
  final String status;

  SuppliesGetEvent({required this.status});

  @override
  List<Object> get props => [status];
}

final class SuppliesGetByIdEvent extends SuppliesEvent {
  final String suppliesId;

  SuppliesGetByIdEvent({required this.suppliesId});
  @override
  List<Object> get props => [suppliesId];
}

final class SuppliesDeleteEvent extends SuppliesEvent {
  final String suppliesId;

  SuppliesDeleteEvent({required this.suppliesId});

  @override
  List<Object> get props => [suppliesId];
}
