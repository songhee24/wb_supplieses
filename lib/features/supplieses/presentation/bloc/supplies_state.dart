part of 'supplies_bloc.dart';

enum SuppliesStatus { initial, loading, success, successEdit, failure }

final class SuppliesState extends Equatable {
  final SuppliesStatus suppliesStatus;
  final List<SuppliesEntity> supplieses;
  final List<BoxEntity>? boxEntities;
  final SuppliesEntity? selectedSupply;
  final DateTime? createdAt;

  const SuppliesState({
    this.createdAt,
    this.suppliesStatus = SuppliesStatus.initial,
    this.supplieses = const <SuppliesEntity>[],
    this.selectedSupply,
    this.boxEntities = const <BoxEntity>[],
  });

  SuppliesState copyWith({
    SuppliesStatus? suppliesStatus,
    List<SuppliesEntity>? supplieses,
    DateTime? createdAt,
    SuppliesEntity? selectedSupply,
    List<BoxEntity>? boxEntities,
  }) {
    return SuppliesState(
      suppliesStatus: suppliesStatus ?? this.suppliesStatus,
      supplieses: supplieses ?? this.supplieses,
      createdAt: createdAt ?? this.createdAt,
      selectedSupply: selectedSupply ?? this.selectedSupply,
      boxEntities: boxEntities ?? this.boxEntities
    );
  }

  @override
  List<Object?> get props => [suppliesStatus, supplieses, createdAt, selectedSupply, boxEntities];

  @override
  String toString() {
    return 'SuppliesState{suppliesStatus: $suppliesStatus, supplieses: $supplieses} createdAt: $createdAt selectedSupply: $selectedSupply} boxEntities $boxEntities';
  }
}