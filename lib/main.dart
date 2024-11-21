import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wb_supplieses/features/supplieses/bloc/supplies_tab_index_cubit.dart';
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
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => SuppliesTabIndexCubit(),
    ),
    BlocProvider(
      create: (_) => SuppliesBloc(suppliesRepository),
    ),
  ], child: const App()));
}
