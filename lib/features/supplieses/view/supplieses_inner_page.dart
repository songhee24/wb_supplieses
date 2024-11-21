import 'package:flutter/material.dart';

class SuppliesesInnerPage extends StatelessWidget {
  final String suppliesId;
  const SuppliesesInnerPage({super.key, required this.suppliesId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text('test $suppliesId'),
      ),
    );
  }
}
