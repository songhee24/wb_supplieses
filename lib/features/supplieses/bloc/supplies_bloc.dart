import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/data/repositories/supplies_firestore_repository.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

part 'supplies_event.dart';

part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState> {
  final SuppliesFirestoreRepository suppliesRepository;

  SuppliesBloc(this.suppliesRepository) : super(const SuppliesState()) {
    on<SuppliesCreateNewEvent>(
      _onAddNewSupplies,
    );
  }

  Future<void> _onAddNewSupplies(
      SuppliesCreateNewEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.loading));
      final newSupply =
          Supplies(createdAt: DateTime.timestamp(), name: event.name, boxCount: event.boxCount);
      await suppliesRepository.addSupply(newSupply);
      // Optionally, fetch updated list to reflect the change
      // add(SuppliesFetch());
    } catch (e) {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.failure));
    } finally {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.initial));
    }
  }
}
