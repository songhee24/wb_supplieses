import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

import '../../bloc/supplies_bloc.dart';

class SuppliesFormBottomSheet extends StatefulWidget {
  final String? suppliesId;

  const SuppliesFormBottomSheet({super.key, this.suppliesId});

  @override
  State<SuppliesFormBottomSheet> createState() =>
      _SuppliesFormBottomSheetState();
}

class _SuppliesFormBottomSheetState extends State<SuppliesFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.suppliesId != null) {
      context
          .read<SuppliesBloc>()
          .add(SuppliesGetByIdEvent(suppliesId: widget.suppliesId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.suppliesId != null;
    return BlocListener<SuppliesBloc, SuppliesState>(
      listener: (context, state) {
        if (state.suppliesStatus == SuppliesStatus.success &&
            state.selectedSupply != null &&
            isEdit) {
          _nameController.text = state.selectedSupply!.name;
          _countController.text =
              state.selectedSupply!.boxCount?.toString() ?? '';
        } else if (state.suppliesStatus == SuppliesStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не получилось загрузить поставку!')),
          );
        } else if (state.suppliesStatus == SuppliesStatus.successEdit || state.suppliesStatus == SuppliesStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Успех!'),
            ),
          );
        }
      },
      child: Padding(
        padding: MediaQuery
            .of(context)
            .viewInsets,
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
                    BlocBuilder<SuppliesBloc, SuppliesState>(
                        builder: (context, state) {
                          final isLoading =
                              state.suppliesStatus == SuppliesStatus.loading;

                          return Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity,
                                    40), // fromHeight use double.infinity as width and 40 is the height
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  final suppliesName = _nameController.text;
                                  final boxCount = _countController.text == ''
                                      ? 0
                                      : int.parse(_countController.text);
                                  // Call SuppliesAddNew event with the entered values
                                  if (isEdit) {
                                    BlocProvider.of<SuppliesBloc>(context)
                                        .add(
                                      SuppliesEditEvent(
                                          suppliesId: widget.suppliesId!,
                                          updatedSupply: SuppliesEntity(
                                            name: suppliesName,
                                            boxCount: boxCount,
                                            createdAt: DateTime.timestamp(),
                                          )),
                                    );
                                  } else {
                                    BlocProvider.of<SuppliesBloc>(context)
                                        .add(
                                      SuppliesCreateNewEvent(
                                        name: suppliesName,
                                        boxCount: boxCount,
                                      ),
                                    );
                                  }
                                  BlocListener<SuppliesBloc, SuppliesState>(
                                      listener: (context, state)
                                      {
                                        bool isSuccess = state.suppliesStatus ==
                                            SuppliesStatus.success;
                                      });
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                                  : isEdit
                                  ? const Text('Изменить Поставку')
                                  : const Text('Создать Поставку'),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
