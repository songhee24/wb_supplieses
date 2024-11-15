 part of 'supplies_bloc.dart';

sealed class SuppliesGetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

 final class SuppliesCreateNewEvent extends SuppliesGetEvent {
   final int boxCount;
   final String name;

   SuppliesCreateNewEvent({required this.name,  this.boxCount = 0});

   @override
   List<Object> get props => [name, boxCount];
 }