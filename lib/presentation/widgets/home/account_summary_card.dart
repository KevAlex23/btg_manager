import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/transaction_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/info_row.dart';

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Cuenta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 10),

          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              int activeInvestments = 0;
              if (state is TransactionLoaded) {
                final subs = state.transactions
                    .where((t) => t.type.toString().contains('subscription'))
                    .length;
                final cancels = state.transactions
                    .where((t) => t.type.toString().contains('cancellation'))
                    .length;
                activeInvestments = (subs - cancels) > 0
                    ? (subs - cancels)
                    : (subs > 0 ? 1 : 0);
              }

              return InfoRow(
                label: 'Inversiones Activas',
                value: activeInvestments.toString(),
                isBoldValue: true,
              );
            },
          ),

          const Divider(),

          const InfoRow(
            label: 'Rendimiento Mes',
            value: '+4.2%',
            valueColor: Colors.green,
            isBoldValue: true,
          ),

          const SizedBox(height: 16),

          const InfoRow(
            label: 'Próximo Vencimiento',
            value: '12 Oct 2026',
            isBoldValue: true,
          ),
        ],
      ),
    );
  }
}