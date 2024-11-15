part of 'supplies_bloc.dart';

enum SuppliesStatus { initial, loading, success, failure }

final class SuppliesState extends Equatable {
  final SuppliesStatus suppliesStatus;
  final List<Supplies> supplieses;
  final DateTime? createdAt;

  const SuppliesState({this.createdAt, this.suppliesStatus = SuppliesStatus.initial,  this.supplieses = const <Supplies>[]});

  SuppliesState copyWith({SuppliesStatus? suppliesStatus, List<Supplies>? supplieses, DateTime? createdAt, }) {
    return SuppliesState(suppliesStatus: suppliesStatus ?? this.suppliesStatus, supplieses: supplieses ?? this.supplieses,  createdAt: createdAt ?? this.createdAt,);
  }

  @override
  List<Object?> get props => [suppliesStatus, supplieses, createdAt];

  @override
  String toString() {
    return 'SuppliesState{suppliesStatus: $suppliesStatus, supplieses: $supplieses} createdAt: $createdAt}';
  }
}