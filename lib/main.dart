import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wb_supplieses/features/database/data/repositories/product_repository_impl.dart';
import 'package:wb_supplieses/features/database/presentation/bloc/product_bloc.dart';
import 'package:wb_supplieses/features/supplieses/bloc/supplies_tab_index_cubit.dart';
import 'package:wb_supplieses/shared/database/local_database_datasource.dart';
import 'features/database/data/datasources/product_datasource.dart';
import 'features/supplieses/data/repositories/supplies_firestore_repository.dart';
import 'firebase_options.dart';

import 'package:wb_supplieses/app/app.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final suppliesRepository = SuppliesFirestoreRepository();

  final localDatabaseDatasource = await LocalDatabaseDatasource.instance.database;
  final productDatasource = ProductDatasource(db: localDatabaseDatasource);
  final productRepositoryImpl = ProductRepositoryImpl(productDatasource: productDatasource);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => SuppliesTabIndexCubit(),
    ),
    BlocProvider(
      create: (_) => SuppliesBloc(suppliesRepository),
    ),
    BlocProvider(create: (_) => ProductBloc(repository: productRepositoryImpl))
  ], child: const App()));
}
