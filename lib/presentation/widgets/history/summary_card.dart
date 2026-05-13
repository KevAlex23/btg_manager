import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? subtitle;
  final bool isPrimary;
  final Color? indicatorColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.isPrimary = false,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final sign = amount > 0 ? '+' : (amount < 0 ? '-' : '');
    final amountColor = isPrimary ? AppColors.secondary : AppColors.slate900;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.secondaryLight : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary ? AppColors.infoBorder : AppColors.slate200,
        ),
        boxShadow: isPrimary
            ? []
            : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isPrimary ? AppColors.secondary : AppColors.slate500,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$sign\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w900,
              fontSize: 28,
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: isPrimary
                    ? AppColors.secondary.withValues(alpha: 0.7)
                    : AppColors.slate400,
                fontSize: 13,
              ),
            ),
          ],
          if (indicatorColor != null) ...[
            const SizedBox(height: 16),
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
