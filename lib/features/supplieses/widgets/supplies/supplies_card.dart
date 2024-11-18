import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wb_supplieses/features/supplieses/supplieses.dart';

class SuppliesCard extends StatelessWidget {
  final Supplies supplies;

  const SuppliesCard({super.key, required this.supplies});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(supplies.createdAt);
    return Stack(children: [
      ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: double.infinity,
            height: 90,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        supplies.name,
                        style: TextStyle(fontSize: 16),
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
                  const Text('Cозданно:', style: TextStyle(color: Colors.grey)),
                  Text(
                      '${formattedDate.split(" ")[0]}'
                      '${formattedDate.split(" ")[1]}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
