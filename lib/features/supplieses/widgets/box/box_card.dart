import 'dart:ui';

import 'package:flutter/material.dart';

class BoxCard extends StatelessWidget {
  final int id;

  const BoxCard({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.black54,
                ],
              ),
              color: Colors.grey[350]!.withOpacity(0.7),
            ),
          ),
        ),
      )
    ]);
  }
}
