import 'dart:math';
import 'package:uuid/uuid.dart';

import '../datasources/local_storage_mock.dart';

class MockApiAdapter {
  final LocalStorageMock _storage = LocalStorageMock();
  final Uuid _uuid = const Uuid();

  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));
  }

  Future<List<Map<String, dynamic>>> getFunds() async {
    await _delay();
    return _storage.availableFunds;
  }

  Future<List<String>> getSubscribedFundIds() async {
    await _delay();
    return _storage.subscribedFundIds.toList();
  }

  Future<double> getUserBalance() async {
    await _delay();
    return _storage.userBalance;
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    await _delay();
    return List<Map<String, dynamic>>.from(_storage.transactions.reversed);
  }

  Future<void> subscribe(String fundId, double amount) async {
    await _delay();

    final fund = _storage.availableFunds.firstWhere(
      (f) => f['id'] == fundId,
      orElse: () => throw Exception('Fondo no encontrado'),
    );

    if (amount < (fund['minimumAmount'] as double)) {
      throw Exception(
        'El monto mínimo para suscribirse al fondo ${fund["name"]} es de \$${fund["minimumAmount"]}',
      );
    }

    if (_storage.userBalance < amount) {
      throw Exception(
        'No tiene saldo disponible para suscribirse al fondo ${fund["name"]}',
      );
    }

    if (_storage.subscribedFundIds.contains(fundId)) {
      throw Exception('Ya está suscrito a este fondo');
    }

    _storage.userBalance -= amount;
    _storage.subscribedFundIds.add(fundId);

    _storage.transactions.add({
      'id': _uuid.v4(),
      'fundId': fundId,
      'fundName': fund['name'],
      'type': 'subscription',
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> cancelSubscription(String fundId) async {
    await _delay();

    if (!_storage.subscribedFundIds.contains(fundId)) {
      throw Exception('No está suscrito a este fondo');
    }

    final originalTx = _storage.transactions.lastWhere(
      (tx) => tx['fundId'] == fundId && tx['type'] == 'subscription',
      orElse: () => throw Exception('Transacción original no encontrada'),
    );

    final refundAmount = originalTx['amount'] as double;
    final fundName = originalTx['fundName'] as String;

    _storage.userBalance += refundAmount;
    _storage.subscribedFundIds.remove(fundId);

    _storage.transactions.add({
      'id': _uuid.v4(),
      'fundId': fundId,
      'fundName': fundName,
      'type': 'cancellation',
      'amount': refundAmount,
      'date': DateTime.now().toIso8601String(),
    });
  }
}
