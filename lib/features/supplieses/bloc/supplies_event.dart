 part of 'supplies_bloc.dart';

sealed class SuppliesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

 final class SuppliesCreateNewEvent extends SuppliesEvent {
   final int id;
   final int suppliesCount;

   SuppliesCreateNewEvent({required this.id, required this.suppliesCount});

   @override
   List<Object> get props => [id, suppliesCount];
 }