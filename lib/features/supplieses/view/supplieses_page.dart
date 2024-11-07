import 'package:flutter/material.dart';

class SuppliesesPage extends StatelessWidget {
  const SuppliesesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Stack(
          children: [
            Positioned.fill(
                child: Align(alignment: Alignment.center, child: Text('0'))),
            Icon(Icons.check_box_outline_blank, size: 48)
          ],
        ),
      ),
      body: const Center(
        child: Text('Test'),
      ),
    );
  }
}
