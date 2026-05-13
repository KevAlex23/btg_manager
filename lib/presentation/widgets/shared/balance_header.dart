import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../blocs/balance_bloc.dart';

class BalanceHeader extends StatelessWidget {
  const BalanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) {
          if (state is BalanceLoading || state is BalanceInitial) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            );
          } else if (state is BalanceLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo Disponible',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${state.balance.amount.toStringAsFixed(0)} COP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else if (state is BalanceError) {
            return Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.white),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
