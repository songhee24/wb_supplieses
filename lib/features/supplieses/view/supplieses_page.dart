import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      BlocBuilder<SuppliesBloc, SuppliesState>(
                        builder: (context, state) {
                          return Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('${state.supplieses.length}')));
                        },
                      ),
                      const Icon(Icons.check_box_outline_blank, size: 40)
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add_box_rounded, size: 24),
                        SizedBox(
                          width: 12,
                        ),
                        Text('Создать Короб'),
                      ],
                    ),
                  ),
                ])),
        body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SuppliesCard(id: 1),
            )),
      ),
    );
  }
}
