import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/fetch_product_use_case.dart';
import '../../domain/usecases/load_excel_data_use_case.dart';
import '../../../../shared/entities/product_entity.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LoadExcelDataUseCase loadExcelDataUseCase;
  final FetchProductsUseCase fetchProductsUseCase;

  ProductBloc({
    required ProductRepository repository
  }) : this._(
      loadExcelDataUseCase: LoadExcelDataUseCase(repository),
      fetchProductsUseCase: FetchProductsUseCase(repository)
  );

  ProductBloc._({
    required this.loadExcelDataUseCase,
    required this.fetchProductsUseCase
  }) : super(ProductInitialState()) {
    on<LoadExcelDataEvent>(_onLoadExcelData);
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onLoadExcelData(
      LoadExcelDataEvent event,
      Emitter<ProductState> emit
      ) async {
    try {
      emit(ProductLoadingState());
      final entities = await loadExcelDataUseCase(event.excelData);
      // final products = entities.map((entity) {
      //     return ProductModel(
      //       id: entity.id,
      //       groupId: entity.groupId,
      //       sellersArticle: entity.sellersArticle,
      //       articleWB: entity.articleWB,
      //       productName: entity.productName,
      //       category: entity.category,
      //       brand: entity.brand,
      //       barcode: entity.barcode,
      //       size: entity.size,
      //       russianSize: entity.russianSize,
      //     );}
      // ).toList();
      emit(ProductLoadedState(entities));
    } catch (e) {
      emit(ProductErrorState('Failed to load Excel data: ${e.toString()}'));
    }
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event,
      Emitter<ProductState> emit
      ) async {
    try {
      emit(ProductLoadingState());
      final entities = await fetchProductsUseCase();
      // final products = entities.map((entity) {
      //     return ProductModel(
      //       id: entity.id,
      //       groupId: entity.groupId,
      //       sellersArticle: entity.sellersArticle,
      //       articleWB: entity.articleWB,
      //       productName: entity.productName,
      //       category: entity.category,
      //       brand: entity.brand,
      //       barcode: entity.barcode,
      //       size: entity.size,
      //       russianSize: entity.russianSize,
      //     );}
      // ).toList();
      emit(ProductLoadedState(entities));
    } catch (e) {
      emit(ProductErrorState('Failed to fetch products: ${e.toString()}'));
    }
  }
}