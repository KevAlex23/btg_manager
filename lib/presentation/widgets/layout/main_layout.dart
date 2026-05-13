import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    String currentPath = '/';
    try {
      currentPath = GoRouterState.of(context).uri.toString();
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text(
                'Fondos BTG',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.slate900,
              elevation: 0,
            ),
      drawer: isDesktop ? null : _buildDrawer(context, currentPath),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context, currentPath),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String currentPath) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: _buildSidebarMenu(context, currentPath, isDrawer: true),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, String currentPath) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: _buildSidebarMenu(context, currentPath, isDrawer: false),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BTG',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.slate900,
                  ),
                ),
                Text(
                  'Fondos',
                  style: TextStyle(fontSize: 11, color: AppColors.slate500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarMenu(
    BuildContext context,
    String currentPath, {
    bool isDrawer = false,
  }) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _SidebarItem(
          icon: Icons.grid_view_rounded,
          title: 'Dashboard',
          isActive: currentPath == '/',
          onTap: () {
            if (isDrawer) context.pop();
            context.go('/');
          },
        ),
        const SizedBox(height: 8),
        _SidebarItem(
          icon: Icons.history,
          title: 'Historial',
          isActive: currentPath.startsWith('/history'),
          onTap: () {
            if (isDrawer) context.pop();
            context.go('/history');
          },
        ),
      ],
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.slate100)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.slate200,
            child: Text(
              'DT',
              style: TextStyle(
                color: AppColors.slate900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEV TEST',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.secondary : AppColors.slate500;
    final bgColor = isActive ? AppColors.secondaryLight : Colors.transparent;
    final fontWeight = isActive ? FontWeight.bold : FontWeight.w600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
