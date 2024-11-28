import 'package:flutter_bloc/flutter_bloc.dart';

class SuppliesTabIndexCubit extends Cubit<int> {
  SuppliesTabIndexCubit() : super(0);

  void setTabIndex(int index) => emit(index);
}