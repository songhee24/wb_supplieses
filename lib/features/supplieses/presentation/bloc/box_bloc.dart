import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/shared/entities/product_entity.dart';

import '../../domain/repositories/box_repository.dart';

part 'box_event.dart';

part 'box_state.dart';

class BoxBloc extends Bloc<BoxEvent, BoxState> {
  final BoxRepository boxRepository;
  // Timer? _debounce;

  BoxBloc({required this.boxRepository}) : super(BoxInitial()) {
    on<BoxSearchProductsEvent>(_onSearchProducts);
    // on<BoxCreateAndFetchedBySuppliesIdEvent>(
    //     _onBoxCreateAndFetchedBySuppliesId);
    // on<BoxesBySuppliesIdEvent>(_onGetBoxesBySuppliesId);
    on<BoxCreateEvent>(_onBoxCreate);
  }


  // Future<void> _onBoxCreateAndFetchedBySuppliesId (BoxCreateAndFetchedBySuppliesIdEvent event, Emitter<BoxState> emit) async {
  //   try {
  //     emit(BoxManageLoading());
  //     if (event.boxEntity != null) {
  //       throw Exception(
  //           'Failed to create box: the event.boxEntity is ${event.boxEntity}');
  //     }
  //     BoxEntity? boxEntity = await boxRepository.createBox(event.boxEntity!);
  //       List<BoxEntity> boxEntities =
  //           await boxRepository.getBoxesBySuppliesId(event.suppliesId);
  //
  //       emit(BoxCreateAndFetchedSuppliesIdSuccess(
  //           boxId: boxEntity!.id!, boxEntities: boxEntities));
  //   } catch(e) {
  //     emit(BoxError(e.toString()));
  //   }
  // }

  // Future<void> _onGetBoxesBySuppliesId(
  //     BoxesBySuppliesIdEvent event, Emitter<BoxState> emit) async {
  //   try {
  //     List<BoxEntity> boxEntities =
  //         await boxRepository.getBoxesBySuppliesId(event.suppliesId);
  //     emit(BoxesBySuppliesIdSuccess(boxEntities: boxEntities));
  //   } catch (e) {
  //     emit(BoxError(e.toString()));
  //   }
  // }

  Future<void> _onBoxCreate(BoxCreateEvent event,
      Emitter<BoxState> emit) async {
    try {
      emit(BoxManageLoading());

      if (event.boxEntity == null) {
        throw Exception(
            'Failed to create box: the event.boxEntity is ${event.boxEntity}');
      } else {
        BoxEntity? boxEntity = await boxRepository.createBox(event.boxEntity!);
        if (boxEntity != null) {
          emit(BoxCreatedSuccess(boxEntity.id!));
          // if (event.isGetBoxesEnabled) {
          //   List<BoxEntity> boxEntities =
          //       await boxRepository.getBoxesBySuppliesId(event.suppliesId);
          //   emit(BoxCreateAndFetchedSuppliesIdSuccess(
          //       boxId: boxEntity.id!, boxEntities: boxEntities));
          // } else {
          //   emit(BoxCreateAndFetchedSuppliesIdSuccess(boxId: boxEntity.id));
          // }
        }
        // List<BoxEntity> boxEntities =
        //     await boxRepository.getBoxesBySuppliesId(event.suppliesId);

        // emit(BoxCreateAndFetchedSuppliesIdSuccess(boxEntities: boxEntities));
      }
    } catch (error) {
      emit(BoxError(error.toString()));
    }
  }

  Future<void> _onSearchProducts(BoxSearchProductsEvent event,
      Emitter<BoxState> emit,) async {
    // Cancel any ongoing debounce
    // _debounce?.cancel();
    //
    // // Wrap the debounce logic in a Completer to ensure the handler does not complete prematurely
    // final completer = Completer<void>();
    //
    // _debounce = Timer(const Duration(milliseconds: 300), () async {
    //   emit(BoxSearchLoading());

    try {
      final results = await boxRepository.searchProducts(
          query: event.query, size: event.size);
      emit(BoxSearchSuccess(results));
    } catch (error) {
      emit(BoxError(error.toString()));
    }

    // completer.complete(); // Signal the completion of the debounce logic
    // });

    // Wait for the debounce logic to complete before exiting the handler
    // await completer.future;
  }

//   @override
//   Future<void> close() {
//     _debounce?.cancel();
//     return super.close();
//   }
// }
}