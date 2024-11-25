import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';
import 'package:wb_supplieses/features/supplieses/domain/repositories/supplies_repository.dart';

part 'supplies_event.dart';
part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState> {
  final SuppliesRepository suppliesRepository;

  SuppliesBloc(this.suppliesRepository) : super(const SuppliesState()) {
    on<SuppliesGetEvent>(_onGetSupplies);
    on<SuppliesDeleteEvent>(_onDeleteSupplies);
    on<SuppliesGetByIdEvent>(_onGetSupplyById);
    on<SuppliesEditEvent>(_onEditSupply);
    on<SuppliesCreateNewEvent>(_onAddNewSupplies);
  }

  Future<void> _onAddNewSupplies(
      SuppliesCreateNewEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));
      final newSupply = SuppliesEntity(
        id: null, // ID will be assigned by Firestore
        createdAt: DateTime.now(),
        name: event.name,
        boxCount: event.boxCount,
        status: "created",
      );
      await suppliesRepository.addSupply(newSupply);

      final suppliesList = await suppliesRepository.getSupplies();
      emit(state.copyWith(
          suppliesStatus: SuppliesStatus.success, supplieses: suppliesList));
    } catch (e) {
      emit(const SuppliesState(suppliesStatus: SuppliesStatus.failure));
    }
  }


  Future<void> _onEditSupply(
      SuppliesEditEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));

      await suppliesRepository.editSupply(event.suppliesId, event.updatedSupply);

      final suppliesList = await suppliesRepository.getSupplies();
      emit(state.copyWith(
        suppliesStatus: SuppliesStatus.successEdit,
        supplieses: suppliesList,
      ));
    } catch (e) {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.failure));
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

  Future<void> _onDeleteSupplies(
      SuppliesDeleteEvent event,
      Emitter<SuppliesState> emit,
      ) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));

      await suppliesRepository.deleteSupply(event.suppliesId);

      // Refresh the supplies list after deletion
      final suppliesList = await suppliesRepository.getSupplies();

      emit(state.copyWith(
        suppliesStatus: SuppliesStatus.success,
        supplieses: suppliesList,
      ));
    } catch (e) {
      emit(state.copyWith(
        suppliesStatus: SuppliesStatus.failure,
        // errorMessage: 'Failed to delete supply: $e',
      ));
    }
  }

  Future<void> _onGetSupplyById(
      SuppliesGetByIdEvent event, Emitter<SuppliesState> emit) async {
    try {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.loading));
      final supply = await suppliesRepository.getSupplyById(event.suppliesId);

      if (supply != null) {
        emit(state.copyWith(
          suppliesStatus: SuppliesStatus.success,
          selectedSupply: supply,
        ));
      } else {
        emit(state.copyWith(suppliesStatus: SuppliesStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(suppliesStatus: SuppliesStatus.failure));
    }
  }
}