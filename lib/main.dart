import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/app/app.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => SuppliesBloc(),
    ),
  ], child: const App()));
}
