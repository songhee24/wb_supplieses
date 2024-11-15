import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/app/layout/layout_scaffold.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesFormBottomSheet extends StatefulWidget {
  const SuppliesFormBottomSheet({super.key});

  @override
  State<SuppliesFormBottomSheet> createState() =>
      _SuppliesFormBottomSheetState();
}

class _SuppliesFormBottomSheetState extends State<SuppliesFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[600]?.withOpacity(0.5),
              border: Border.all(color: Colors.black26, width: 0.5),
            ),
            height: 200,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Укажите название поставки',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста не оставляйте поле пустым';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextFormField(
                          controller: _countController,
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
                  const SizedBox(height: 8),
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity,
                                40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final suppliesName = _nameController.text;
                              final boxCount = _countController.text == ''
                                  ? 0
                                  : int.parse(_countController.text);
                              // Call SuppliesAddNew event with the entered values
                              BlocProvider.of<SuppliesBloc>(context).add(
                                SuppliesCreateNewEvent(
                                  name: suppliesName,
                                  boxCount: boxCount,
                                ),
                              );

                              // Close the bottom sheet after submitting
                              // Navigator.of(context).pop();
                            } else {}
                          },
                          child: const Text('Создать Поставку')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
