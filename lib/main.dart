import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wb_supplieses/features/supplieses/presentation/bloc/supplies_tab_index_cubit.dart';
import 'package:wb_supplieses/shared/database/local_database_datasource.dart';
import 'features/exel_products/data/datasources/product_datasource.dart';
import 'features/exel_products/data/repositories/product_repository_impl.dart';
import 'features/exel_products/presentation/bloc/product_bloc.dart';
import 'features/supplieses/data/repositories/supplies_firestore_repository_impl.dart';
import 'firebase_options.dart';

import 'package:wb_supplieses/app/app.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final suppliesRepository = SuppliesFirestoreRepositoryImpl();

  final localDatabaseDatasource = await LocalDatabaseDatasource.instance.database;
  print('localDatabaseDatasource $localDatabaseDatasource');
  final productDatasource = ProductDatasource(db: localDatabaseDatasource);
  final productRepositoryImpl = ProductRepositoryImpl(productDatasource: productDatasource);

  final boxDatasource = BoxDatasource(db: localDatabaseDatasource);
  final boxFirestoreRepositoryImpl = BoxFirestoreRepositoryImpl(boxDatasource: boxDatasource);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => SuppliesTabIndexCubit(),
    ),
    BlocProvider(
      create: (_) => SuppliesBloc(suppliesRepository: suppliesRepository, boxRepository: boxFirestoreRepositoryImpl),
    ),
    BlocProvider(
      create: (_) => BoxBloc(boxRepository: boxFirestoreRepositoryImpl),
    ),
    BlocProvider(create: (_) => ProductBloc(repository: productRepositoryImpl))
  ], child: const App()));
}
