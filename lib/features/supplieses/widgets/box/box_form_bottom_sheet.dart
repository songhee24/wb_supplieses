import 'dart:ui';

import 'package:flutter/material.dart';

class BoxFormBottomSheet extends StatelessWidget {
  const BoxFormBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
