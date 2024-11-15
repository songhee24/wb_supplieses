import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/data/repositories/supplies_firestore_repository.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

part 'supplies_event.dart';

part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesGetEvent, SuppliesState> {
  final SuppliesFirestoreRepository suppliesRepository;

  SuppliesBloc(this.suppliesRepository) : super(const SuppliesState()) {
    on<SuppliesGetEvent>(_onGetSupplies);
    on<SuppliesCreateNewEvent>(_onAddNewSupplies);
  }

  Future<void> _onAddNewSupplies(
      SuppliesCreateNewEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));
      final newSupply = Supplies(
          createdAt: DateTime.timestamp(),
          name: event.name,
          boxCount: event.boxCount);
      await suppliesRepository.addSupply(newSupply);

      final suppliesList = await suppliesRepository.getSupplies();
      emit(state.copyWith(
          suppliesStatus: SuppliesStatus.success, supplieses: suppliesList));
    } catch (e) {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.failure));
    }
  }

  Future<void> _onGetSupplies(
      SuppliesGetEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));
      final suppliesList = await suppliesRepository.getSupplies();
      emit(state.copyWith(
          suppliesStatus: SuppliesStatus.success, supplieses: suppliesList));
    } catch (e) {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.failure));
    }
  }
}
