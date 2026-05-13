import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/balance_bloc.dart';
import 'presentation/blocs/fund_bloc.dart';
import 'presentation/blocs/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BalanceBloc>()..add(LoadBalance())),
        BlocProvider(create: (_) => sl<FundBloc>()..add(LoadFunds())),
        BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(LoadTransactions()),
        ),
      ],
      child: MaterialApp.router(
        title: 'BTG Funds Manager',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
