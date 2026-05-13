import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial de Movimientos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Consulta el detalle de tus transacciones recientes y estados de cuenta.',
            style: TextStyle(fontSize: 14, color: AppColors.slate600),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Movimientos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta el detalle de tus transacciones recientes y estados de cuenta.',
              style: TextStyle(fontSize: 16, color: AppColors.slate600),
            ),
          ],
        ),
      ],
    );
  }
}
