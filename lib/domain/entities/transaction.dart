import 'package:equatable/equatable.dart';

enum TransactionType { subscription, cancellation }

class Transaction extends Equatable {
  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, fundId, fundName, type, amount, date];
}
