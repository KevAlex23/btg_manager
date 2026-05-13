import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/theme/app_colors.dart';
import '../blocs/transaction_bloc.dart';

import '../widgets/history/transaction_header.dart';
import '../widgets/history/transaction_table.dart';
import '../widgets/history/summary_card.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading || state is TransactionInitial) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: 50,
            ),
          );
        } else if (state is TransactionLoaded) {
          final transactions = state.transactions;

          double totalAbonos = 0;
          double totalRetiros = 0;

          for (var tx in transactions) {
            final isSub = tx.type.toString().contains('subscription');
            if (isSub) {
              totalRetiros += tx.amount;
            } else {
              totalAbonos += tx.amount;
            }
          }
          final balanceNeto = totalAbonos - totalRetiros;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TransactionHeader(),
                SizedBox(height: isMobile ? 24 : 32),

                LayoutBuilder(
                  builder: (context, constraints) {
                    // Define breakpoints for mobile, tablet, and desktop
                    final isMobile = constraints.maxWidth < 600;
                    final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
                    final isDesktop = constraints.maxWidth >= 1024;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TransactionTable(transactions: transactions),

                        SizedBox(height: isMobile ? 24 : isTablet ? 28 : 32),

                        if (isMobile || isTablet)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SummaryCard(
                                title: 'BALANCE NETO',
                                amount: balanceNeto,
                                subtitle: 'Este período (30 días)',
                                isPrimary: true,
                              ),
                              const SizedBox(height: 16),
                              SummaryCard(
                                title: 'TOTAL ABONOS',
                                amount: totalAbonos,
                                indicatorColor: AppColors.success,
                              ),
                              const SizedBox(height: 16),
                              SummaryCard(
                                title: 'TOTAL RETIROS',
                                amount: totalRetiros,
                                indicatorColor: AppColors.error,
                              ),
                            ],
                          ),

                        if (isDesktop)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  title: 'BALANCE NETO',
                                  amount: balanceNeto,
                                  subtitle: 'Este período (30 días)',
                                  isPrimary: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SummaryCard(
                                  title: 'TOTAL ABONOS',
                                  amount: totalAbonos,
                                  indicatorColor: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SummaryCard(
                                  title: 'TOTAL RETIROS',
                                  amount: totalRetiros,
                                  indicatorColor: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is TransactionError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
