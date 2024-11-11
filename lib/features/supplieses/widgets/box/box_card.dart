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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 20),
                  blurRadius: 50,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.5),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black,
                      Colors.black,
                    ],
                  ),
                  color: Colors.grey[350]!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
            ),
          ),
        ),
      )
    ]);
  }
}
