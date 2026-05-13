import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBoldValue;

  const InfoRow({super.key, 
    required this.label,
    required this.value,
    this.valueColor,
    this.isBoldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.slate600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.slate900,
              fontSize: 14,
              fontWeight: isBoldValue ? FontWeight.w900 : FontWeight.normal,
              overflow: TextOverflow.ellipsis
            ),
          ),
        ),
      ],
    );
  }
}
