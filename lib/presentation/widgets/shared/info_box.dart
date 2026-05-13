import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoBox extends StatelessWidget {
  final String text;

  const InfoBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.infoText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
