import 'dart:ui';

import 'package:flutter/material.dart';

class SuppliesCard extends StatelessWidget {
  final int id;

  const SuppliesCard({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(25))),
            ),
          ),
        ),
      )
    ]);
  }
}
