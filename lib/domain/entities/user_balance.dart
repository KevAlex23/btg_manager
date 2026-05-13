import 'package:equatable/equatable.dart';

class UserBalance extends Equatable {
  final double amount;

  const UserBalance({required this.amount});

  bool canSubscribe(double requiredAmount) => amount >= requiredAmount;

  UserBalance copyWith({double? amount}) {
    return UserBalance(amount: amount ?? this.amount);
  }

  @override
  List<Object?> get props => [amount];
}
