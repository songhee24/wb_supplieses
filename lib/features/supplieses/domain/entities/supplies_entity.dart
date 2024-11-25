import 'package:equatable/equatable.dart';

class SuppliesEntity extends Equatable {
  final String? id;
  final int? boxCount;
  final DateTime createdAt;
  final String name;
  final String status;

  const SuppliesEntity({this.id, this.boxCount, required this.createdAt, required this.name, this.status = 'created'});

  @override
  List<Object?> get props  => [id, boxCount, createdAt, status];
}