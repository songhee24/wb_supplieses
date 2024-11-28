import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';
import 'package:wb_supplieses/features/supplieses/presentation/bloc/box_bloc.dart';
import 'package:wb_supplieses/features/supplieses/presentation/bloc/supplies_bloc.dart';
import 'package:wb_supplieses/features/supplieses/presentation/widgets/box/box_form_bottom_sheet.dart';

class SuppliesInnerBoxCard extends StatefulWidget {
  final String? suppliesId;
  final BoxEntity boxEntity;

  const SuppliesInnerBoxCard(
      {super.key, required this.boxEntity, this.suppliesId});

  @override
  State<SuppliesInnerBoxCard> createState() => _SuppliesInnerBoxCardState();
}

class _SuppliesInnerBoxCardState extends State<SuppliesInnerBoxCard> {
  Future<void> _onGetBoxById(BuildContext context) async {
    if (widget.boxEntity.id != null && widget.suppliesId != null) {
      BlocProvider.of<BoxBloc>(context).add(
        BoxEditEvent(boxId: widget.boxEntity.id!),
      );
      showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return BoxFormBottomSheet(
              suppliesId: widget.suppliesId!,
              boxEntity: widget.boxEntity,
            );
          });
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить Коробку'),
          content: const Text(
              'А вы уверены что хотите удалить Коробку? Удаление приведет к удалению всех Товаров!'),
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

    if (confirmed == true && widget.boxEntity.id != null && context.mounted) {
      context.read<BoxBloc>().add(
            BoxDeleteEvent(boxId: widget.boxEntity.id!),
          );
      context.read<SuppliesBloc>().add(BoxesBySuppliesIdEvent(suppliesId: widget.suppliesId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuantity = widget.boxEntity.productEntities?.fold<int>(
      0,
      (sum, product) => sum + product.count,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        // border: Border.all(color: const Color(0xFF3C006A), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.black12,
          ],
        ),
        color: Colors.grey[350]!.withOpacity(0.4),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Короб № ${widget.boxEntity.boxNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteConfirmation(context);
                            }
                            if (value == 'edit') {
                              _onGetBoxById(context);
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
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Общ кол-во товаров: ',
                      style: const TextStyle(fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$totalQuantity',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                margin: const EdgeInsets.only(top: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: widget.boxEntity.productEntities?.length,
                    itemBuilder: (context, index) {
                      final product = widget.boxEntity.productEntities?[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3)
                            // border: Border(
                            //   top: BorderSide(width: 1, color: Colors.grey[300]!),
                            //   bottom: BorderSide(width: 1, color: Colors.grey[300]!),
                            // ),
                            ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 1,
                          minTileHeight: 0,
                          minLeadingWidth: 0,
                          dense: true,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RichText(
                              text: TextSpan(
                                text: 'Кол-во: ',
                                style: const TextStyle(fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${product?.count}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(text: '          '),
                                  const TextSpan(text: 'Размер: '),
                                  TextSpan(
                                      text: '${product?.size}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${product?.sellersArticle}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text: 'Имя: ',
                                  style: const TextStyle(fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${product?.productName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  text: 'Арт Wb: ',
                                  style: const TextStyle(fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${product?.articleWB}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text: 'Barcode: ',
                                  style: const TextStyle(fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${product?.barcode}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 12),
                                  children: <TextSpan>[],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// SizedBox(
// width: 300,
// height: 305,
// child: Card(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(25.0),
// ),
// elevation: 10.0,
// child: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// height: 200.0,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10.0),
// image: const DecorationImage(
// image: AssetImage(
// 'lib/assets/cargo-box.png',
// ),
// fit: BoxFit.fitWidth),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(10.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// '№ ${boxEntity.boxNumber}',
// maxLines: 1,
// overflow: TextOverflow.ellipsis,
// style: const TextStyle(
// color: Colors.redAccent,
// fontWeight: FontWeight.w800),
// ),
// const Text(
// 'desc',
// maxLines: 3,
// overflow: TextOverflow.ellipsis,
// style: TextStyle(fontWeight: FontWeight.w500),
// ),
// ]),
// ),
// ],
// )));
