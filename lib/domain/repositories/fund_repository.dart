import '../entities/fund.dart';

abstract class FundRepository {
  Future<List<Fund>> getAvailableFunds();
  Future<List<Fund>> getSubscribedFunds();
  Future<void> subscribeToFund(
    String fundId,
    double amount, {
    bool notifyEmail = false,
    bool notifySms = false,
  });
  Future<void> cancelFundSubscription(String fundId);
}
