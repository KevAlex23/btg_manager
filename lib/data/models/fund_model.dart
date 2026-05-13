import '../../domain/entities/fund.dart';

class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.minimumAmount,
    required super.category,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'],
      name: json['name'],
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minimumAmount': minimumAmount,
      'category': category,
    };
  }
}
