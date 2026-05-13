import '../entities/transaction.dart';
import '../entities/user_balance.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<UserBalance> getUserBalance();
}
