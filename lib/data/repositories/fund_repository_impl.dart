import 'dart:developer';
import '../../domain/entities/fund.dart';
import '../../domain/repositories/fund_repository.dart';
import '../adapters/mock_api_adapter.dart';
import '../models/fund_model.dart';

class FundRepositoryImpl implements FundRepository {
  final MockApiAdapter apiAdapter;

  FundRepositoryImpl({required this.apiAdapter});

  @override
  Future<List<Fund>> getAvailableFunds() async {
    final data = await apiAdapter.getFunds();
    return data.map((json) => FundModel.fromJson(json)).toList();
  }

  @override
  Future<List<Fund>> getSubscribedFunds() async {
    final data = await apiAdapter.getFunds();
    final subscribedIds = await apiAdapter.getSubscribedFundIds();
    final allFunds = data.map((json) => FundModel.fromJson(json)).toList();
    return allFunds.where((fund) => subscribedIds.contains(fund.id)).toList();
  }

  @override
  Future<void> subscribeToFund(
    String fundId,
    double amount, {
    bool notifyEmail = false,
    bool notifySms = false,
  }) async {
    await apiAdapter.subscribe(fundId, amount);
    if (notifyEmail) {
      log(
        'Simulación de Envío Email: Suscrito exitosamente al fondo $fundId',
      );
    }
    if (notifySms) {
      log('Simulación de Envío SMS: Suscrito exitosamente al fondo $fundId');
    }
  }

  @override
  Future<void> cancelFundSubscription(String fundId) async {
    await apiAdapter.cancelSubscription(fundId);
  }
}
