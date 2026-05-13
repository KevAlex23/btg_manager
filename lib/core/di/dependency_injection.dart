import 'package:get_it/get_it.dart';
import '../../domain/repositories/fund_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../data/adapters/mock_api_adapter.dart';
import '../../data/repositories/fund_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../presentation/blocs/balance_bloc.dart';
import '../../presentation/blocs/fund_bloc.dart';
import '../../presentation/blocs/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<MockApiAdapter>(() => MockApiAdapter());

  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(apiAdapter: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(apiAdapter: sl()),
  );

  sl.registerFactory(() => BalanceBloc(transactionRepository: sl()));
  sl.registerFactory(() => FundBloc(fundRepository: sl()));
  sl.registerFactory(() => TransactionBloc(transactionRepository: sl()));
}
