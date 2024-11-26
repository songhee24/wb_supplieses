import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

import '../../domain/repositories/box_repository.dart';

part 'box_event.dart';
part 'box_state.dart';

class BoxBloc extends Bloc<BoxEvent, BoxState> {
  final BoxRepository boxRepository;
  Timer? _debounce;

  BoxBloc({required this.boxRepository}) : super(BoxInitial()) {
    on<BoxSearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onSearchProducts(
      BoxSearchProductsEvent event,
      Emitter<BoxState> emit,
      ) async {
    // Cancel any ongoing debounce
    _debounce?.cancel();

    // Start debounce timer
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      emit(BoxSearchLoading());

      try {
        final results = await boxRepository.searchProducts(event.query);
        emit(BoxSearchSuccess(results));
      } catch (error) {
        emit(BoxSearchError(error.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}