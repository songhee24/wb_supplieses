import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxFormBottomSheet extends StatelessWidget {
  const BoxFormBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    double sheetHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600]?.withOpacity(0.5),
                  border: Border.all(color: Colors.black26, width: 0.5),
                ),
                height: sheetHeight / 1.5,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Создание коробки', style: TextStyle(fontSize: 16)),
                      Flexible(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Кол-во',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
