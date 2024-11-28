import 'package:equatable/equatable.dart';
import 'package:wb_supplieses/features/supplieses/domain/entities/box_entity.dart';

class SuppliesEntity extends Equatable {
  final String? id;
  final int? boxCount;
  final DateTime createdAt;
  final String name;
  final String status;

  final List<BoxEntity>? boxes;

  const SuppliesEntity({this.id, this.boxCount, this.boxes = const <BoxEntity>[],  required this.createdAt, required this.name, this.status = 'created'});

  @override
  List<Object?> get props  => [id, boxCount, createdAt, status];
}