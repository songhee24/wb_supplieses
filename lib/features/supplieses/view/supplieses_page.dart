import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wb_supplieses/features/supplieses/widgets/supplies/supplies_app_bar.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SuppliesAppBar(onAddBox: () {
          showModalBottomSheet<void>(
            useRootNavigator: true,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.black26,
                        width: 0.5,
                      ),),
                    height: 300,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
