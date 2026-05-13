import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_balance.dart';
import '../../domain/repositories/transaction_repository.dart';

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();
  @override
  List<Object> get props => [];
}

class LoadBalance extends BalanceEvent {}

abstract class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object> get props => [];
}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState {
  final UserBalance balance;
  const BalanceLoaded(this.balance);
  @override
  List<Object> get props => [balance];
}

class BalanceError extends BalanceState {
  final String message;
  const BalanceError(this.message);
  @override
  List<Object> get props => [message];
}

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final TransactionRepository transactionRepository;

  BalanceBloc({required this.transactionRepository}) : super(BalanceInitial()) {
    on<LoadBalance>(_onLoadBalance);
  }

  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<BalanceState> emit,
  ) async {
    emit(BalanceLoading());
    try {
      final balance = await transactionRepository.getUserBalance();
      emit(BalanceLoaded(balance));
    } catch (e) {
      emit(BalanceError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
