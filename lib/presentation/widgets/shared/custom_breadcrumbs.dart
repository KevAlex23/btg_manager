import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomBreadcrumbs extends StatelessWidget {
  final List<String> paths;
  const CustomBreadcrumbs({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(const Icon(Icons.home, color: AppColors.secondary, size: 16));
    children.add(const SizedBox(width: 4));

    for (int i = 0; i < paths.length; i++) {
      final isFirst = i == 0;
      final isLast = i == paths.length - 1;

      children.add(
        Text(
          paths[i],
          style: TextStyle(
            color: isFirst ? AppColors.secondary : AppColors.slate600,
            fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      );

      if (!isLast) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '/',
              style: TextStyle(color: AppColors.slate400, fontSize: 14),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
