import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/supplies_entity.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';
import 'package:wb_supplieses/shared/lib/router/config.dart';


class SuppliesCard extends StatelessWidget {
  final SuppliesEntity supplies;

  const SuppliesCard({super.key, required this.supplies});

  Future<void> _onGetSuppliesById(BuildContext context) async {
    if (supplies.id != null) {
      BlocProvider.of<SuppliesBloc>(context).add(
        SuppliesGetByIdEvent(suppliesId: supplies.id!),
      );
      showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SuppliesFormBottomSheet(
              suppliesId: supplies.id,
            );
          });
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить Поставку'),
          content: const Text(
              'А вы уверены что хотите удалить поставку? Удаление приведет к удалению всех коробок!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отменить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && supplies.id != null) {
      // ignore: use_build_context_synchronously
      context.read<SuppliesBloc>().add(
            SuppliesDeleteEvent(suppliesId: supplies.id!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(supplies.createdAt);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            // context.read<SuppliesTabIndexCubit>().setTabIndex(-1);
            context.push<bool>('${PathKeys.supplieses()}/${supplies.id}/boxes', extra: supplies);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  // border: Border.all(color: Color(0xFF235F75), width: 1),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.black54,
                    ],
                  ),
                  color: Colors.grey[350]!.withOpacity(0.4),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  supplies.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${supplies.boxCount}'),
                                const SizedBox(width: 4),
                                Image.asset(
                                  'lib/assets/box.png',
                                  width: 28,
                                  height: 28,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Cозданно:',
                                    style: TextStyle(color: Colors.grey)),
                                Text(
                                    '${formattedDate.split(" ")[0]} '
                                    ' ${formattedDate.split(" ")[1]}',
                                    style: const TextStyle(color: Colors.grey)),
                              ]),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _showDeleteConfirmation(context);
                                }
                                if (value == 'edit') {
                                  _onGetSuppliesById(context);
                                }
                              },
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem(
                                      value: 'delete',
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text('Удалить')),
                                  const PopupMenuItem(
                                      value: 'edit',
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text('Изменить'))
                                ];
                              },
                            ),
                          )
                        ],
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
