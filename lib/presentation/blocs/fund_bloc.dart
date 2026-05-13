import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/fund.dart';
import '../../domain/repositories/fund_repository.dart';

abstract class FundEvent extends Equatable {
  const FundEvent();
  @override
  List<Object> get props => [];
}

class LoadFunds extends FundEvent {}

class SubscribeToFund extends FundEvent {
  final String fundId;
  final double amount;
  final bool notifyEmail;
  final bool notifySms;

  const SubscribeToFund({
    required this.fundId,
    required this.amount,
    this.notifyEmail = false,
    this.notifySms = false,
  });

  @override
  List<Object> get props => [fundId, amount, notifyEmail, notifySms];
}

class CancelSubscription extends FundEvent {
  final String fundId;

  const CancelSubscription({required this.fundId});

  @override
  List<Object> get props => [fundId];
}

abstract class FundState extends Equatable {
  const FundState();
  @override
  List<Object> get props => [];
}

class FundInitial extends FundState {}

class FundLoading extends FundState {}

class FundLoaded extends FundState {
  final List<Fund> availableFunds;
  final List<Fund> subscribedFunds;

  const FundLoaded({
    required this.availableFunds,
    required this.subscribedFunds,
  });

  @override
  List<Object> get props => [availableFunds, subscribedFunds];
}

class FundOperationSuccess extends FundState {
  final String message;
  const FundOperationSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class FundError extends FundState {
  final String message;
  const FundError(this.message);
  @override
  List<Object> get props => [message];
}

class FundBloc extends Bloc<FundEvent, FundState> {
  final FundRepository fundRepository;

  FundBloc({required this.fundRepository}) : super(FundInitial()) {
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeToFund>(_onSubscribeToFund);
    on<CancelSubscription>(_onCancelSubscription);
  }

  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundState> emit) async {
    emit(FundLoading());
    try {
      final available = await fundRepository.getAvailableFunds();
      final subscribed = await fundRepository.getSubscribedFunds();
      emit(FundLoaded(availableFunds: available, subscribedFunds: subscribed));
    } catch (e) {
      emit(FundError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSubscribeToFund(
    SubscribeToFund event,
    Emitter<FundState> emit,
  ) async {
    emit(FundLoading());
    try {
      await fundRepository.subscribeToFund(
        event.fundId,
        event.amount,
        notifyEmail: event.notifyEmail,
        notifySms: event.notifySms,
      );
      emit(const FundOperationSuccess('Suscripción exitosa'));
      add(LoadFunds());
    } catch (e) {
      emit(FundError(e.toString().replaceAll('Exception: ', '')));
      add(LoadFunds());
    }
  }

  Future<void> _onCancelSubscription(
    CancelSubscription event,
    Emitter<FundState> emit,
  ) async {
    emit(FundLoading());
    try {
      await fundRepository.cancelFundSubscription(event.fundId);
      emit(const FundOperationSuccess('Suscripción cancelada exitosamente'));
      add(LoadFunds());
    } catch (e) {
      emit(FundError(e.toString().replaceAll('Exception: ', '')));
      add(LoadFunds());
    }
  }
}
