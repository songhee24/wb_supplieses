import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxSearchInputSelector extends StatelessWidget {
  final TextEditingController controller;
  const BoxSearchInputSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Поиск товара для коробки (Наименование, WB артикул)',
        ),
      ),
    );
  }
}
