import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

part 'supplies_event.dart';
part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState> {
  SuppliesBloc() : super(const SuppliesState()) {
    on<SuppliesAddNewEvent>(
     _onAddNewSupplies,
    );
  }

  Future<void> _onAddNewSupplies(SuppliesAddNewEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.initial));
      final newSupply = Supplies(id: event.id, suppliesCount: event.suppliesCount);
      final updatedSupplies = List<Supplies>.from(state.supplieses)..add(newSupply);
      emit(SuppliesState(supplieses: updatedSupplies, suppliesStatus: SuppliesStatus.success, createdAt: DateTime.now()));
    } catch(e) {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.failure));
    }
  }
}