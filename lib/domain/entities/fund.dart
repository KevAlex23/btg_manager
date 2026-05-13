import 'package:equatable/equatable.dart';

class Fund extends Equatable {
  final String id;
  final String name;
  final double minimumAmount;
  final String category;

  const Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, minimumAmount, category];
}
