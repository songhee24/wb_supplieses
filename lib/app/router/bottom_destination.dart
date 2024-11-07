import 'package:flutter/material.dart';

class BottomDestination {
  final String label;
  final IconData icon;

  const BottomDestination({required this.label, required this.icon});
}

const destinations = [
  BottomDestination(label: 'Коробки', icon: Icons.widgets),
  BottomDestination(label: 'Обновить Карточки', icon: Icons.storage),
];