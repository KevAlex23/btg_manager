import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.type,
    required super.amount,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      fundId: json['fundId'],
      fundName: json['fundName'],
      type: json['type'] == 'subscription'
          ? TransactionType.subscription
          : TransactionType.cancellation,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'type': type == TransactionType.subscription
          ? 'subscription'
          : 'cancellation',
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
