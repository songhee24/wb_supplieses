import 'package:flutter/material.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Stack(
              children: [
                Positioned.fill(
                    child: Align(alignment: Alignment.center, child: Text('0'))),
                Icon(Icons.check_box_outline_blank, size: 40)
              ],
            ),
              ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box_rounded, size: 24),
                    SizedBox(width: 12,),
                    Text('Создать Короб'),
                  ],
                ),
              ),
            ]
          )
        ),
        body: const Center(
          child: Text('Test'),
        ),
      ),
    );
  }
}
