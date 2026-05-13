import '../../domain/entities/transaction.dart';
import '../../domain/entities/user_balance.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../adapters/mock_api_adapter.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final MockApiAdapter apiAdapter;

  TransactionRepositoryImpl({required this.apiAdapter});

  @override
  Future<List<Transaction>> getTransactions() async {
    final data = await apiAdapter.getTransactions();
    return data.map((json) => TransactionModel.fromJson(json)).toList();
  }

  @override
  Future<UserBalance> getUserBalance() async {
    final balance = await apiAdapter.getUserBalance();
    return UserBalance(amount: balance);
  }
}
