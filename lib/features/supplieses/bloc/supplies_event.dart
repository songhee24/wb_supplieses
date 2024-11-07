 part of 'supplies_bloc.dart';

sealed class SuppliesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SuppliesAdd extends SuppliesEvent {}