import 'package:flutter/material.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SuppliesAppBar(
          onAddBox: () {
            showModalBottomSheet<void>(
              useRootNavigator: true,
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return const BoxFormBottomSheet();
              },
            );
          },
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoxCard(id: 0),
                SizedBox(height: 8),
                BoxCard(id: 0),
                SizedBox(height: 8),
                BoxCard(id: 0),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
