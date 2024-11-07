import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/models/models.dart';

part 'supplies_event.dart';
part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState> {
  SuppliesBloc() : super(const SuppliesState()) {
    on<SuppliesEvent>(
     _onCreateSupplies,
    );
  }

  Future<void> _onCreateSupplies(SuppliesEvent event, Emitter<SuppliesState> emit) async {}
}