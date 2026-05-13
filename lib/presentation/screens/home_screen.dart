import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/theme/app_colors.dart';
import '../blocs/fund_bloc.dart';
import '../blocs/balance_bloc.dart';
import '../blocs/transaction_bloc.dart';

import '../widgets/funds/fund_card.dart';
import '../widgets/home/balance_card.dart';
import '../widgets/home/account_summary_card.dart';
import 'subscription_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSubscriptionDialog(BuildContext context, fund) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<FundBloc>(),
        child: SubscriptionDialog(fund: fund),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return BlocListener<FundBloc, FundState>(
      listener: (context, state) {
        if (state is FundOperationSuccess) {
          context.read<BalanceBloc>().add(LoadBalance());
          context.read<TransactionBloc>().add(LoadTransactions());
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<FundBloc>().add(LoadFunds());
          context.read<BalanceBloc>().add(LoadBalance());
          context.read<TransactionBloc>().add(LoadTransactions());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fondos BTG',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fondos BTG',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: isMobile ? 24 : 32),

              if (isMobile)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BalanceCard(),
                    SizedBox(height: 16),
                    AccountSummaryCard(),
                  ],
                )
              else
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: BalanceCard()),
                    SizedBox(width: 24),
                    Expanded(flex: 1, child: AccountSummaryCard()),
                  ],
                ),

              SizedBox(height: isMobile ? 32 : 48),

              SizedBox(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Define breakpoints for mobile, tablet, and desktop
                    if (constraints.maxWidth < 600) {
                      // Mobile layout
                      return _buildContent(
                        context,
                        fontSize: 16,
                        chipSpacing: 4,
                      );
                    } else if (constraints.maxWidth < 1024) {
                      // Tablet layout
                      return _buildContent(
                        context,
                        fontSize: 20,
                        chipSpacing: 8,
                      );
                    } else {
                      // Desktop layout
                      return _buildContent(
                        context,
                        fontSize: 24,
                        chipSpacing: 12,
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: isMobile ? 16 : 24),

              BlocBuilder<FundBloc, FundState>(
                builder: (context, state) {
                  if (state is FundLoading || state is FundInitial) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.primary,
                          size: 50,
                        ),
                      ),
                    );
                  } else if (state is FundLoaded) {
                    final funds = state.availableFunds;
                    final subscribedIds = state.subscribedFunds
                        .map((e) => e.id)
                        .toSet();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isMobile ? 500 : 350,
                        crossAxisSpacing: isMobile ? 16 : 24,
                        mainAxisSpacing: isMobile ? 16 : 24,
                        mainAxisExtent: 350,
                      ),
                      itemCount: funds.length,
                      itemBuilder: (context, index) {
                        final fund = funds[index];
                        final isSubscribed = subscribedIds.contains(fund.id);

                        return FundCard(
                          fund: fund,
                          isSubscribed: isSubscribed,
                          onSubscribe: () =>
                              _showSubscriptionDialog(context, fund),
                          onCancel: () {
                            context.read<FundBloc>().add(
                              CancelSubscription(fundId: fund.id),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('Algo salió mal cargando los fondos.'),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required double fontSize,
    required double chipSpacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fondos Disponibles',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.slate900,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
