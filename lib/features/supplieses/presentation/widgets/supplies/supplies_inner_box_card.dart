import 'package:flutter/material.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';

class SuppliesInnerBoxCard extends StatefulWidget {
  final BoxEntity boxEntity;

  const SuppliesInnerBoxCard({super.key, required this.boxEntity});

  @override
  State<SuppliesInnerBoxCard> createState() => _SuppliesInnerBoxCardState();
}

class _SuppliesInnerBoxCardState extends State<SuppliesInnerBoxCard> {
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
                  Text(
                    'Короб № ${widget.boxEntity.boxNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Общ кол-во товаров: ',
                      style: const TextStyle(fontSize: 12),
                      children:  <TextSpan>[
                        TextSpan(text: '$totalQuantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                margin: const EdgeInsets.only(top: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric( vertical: 4),
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
                          contentPadding:  EdgeInsets.zero,
                          minVerticalPadding: 1,
                          minTileHeight: 0,
                          minLeadingWidth: 0,
                          dense: true,
                          title:
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RichText(
                              text: TextSpan(
                                text: 'Кол-во: ',
                                style: const TextStyle(fontSize: 12),
                                children:  <TextSpan>[
                                  TextSpan(text: '${product?.count}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: '          '),
                                  const TextSpan(text: 'Размер: '),
                                  TextSpan(text: '${product?.size}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${product?.sellersArticle}', style: const TextStyle(fontWeight: FontWeight.bold),),
                              RichText(
                                text: TextSpan(
                                  text: 'Имя: ',
                                  style: const TextStyle(fontSize: 12),
                                  children:  <TextSpan>[
                                    TextSpan(text: '${product?.productName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),

                              RichText(
                                text: TextSpan(
                                  text: 'Арт Wb: ',
                                  style: const TextStyle(fontSize: 12),
                                  children:  <TextSpan>[
                                    TextSpan(text: '${product?.articleWB}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Barcode: ',
                                  style: const TextStyle(fontSize: 12),
                                  children:  <TextSpan>[
                                    TextSpan(text: '${product?.barcode}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 12),
                                  children:  <TextSpan>[

                                  ],
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
