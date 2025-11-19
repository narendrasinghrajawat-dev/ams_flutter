import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/admin_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            // _buildHeaderSection(),
            // const SizedBox(height: 24),

            // Statistics Cards Grid
            _buildStatsGrid(),
            const SizedBox(height: 15),

            // Quick Actions Section
            _buildQuickActions(),
            const SizedBox(height: 10),

            // Recent Activity Section
            Expanded(
              child: _buildRecentActivity(),
            ),
          ],
        ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.veryLarge(
          'Dashboard',
          color: AppThemeColors.textPrimaryColor,
        ),
        const SizedBox(height: 8),
        AppTextWidget.medium(
          'Welcome back, Admin! Here\'s your overview',
          color: AppThemeColors.textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _StatCard(
          title: 'Total Employees',
          value: '48',
          subtitle: '+2 this week',
          icon: Icons.people_alt_rounded,
          color: AppThemeColors.primaryColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemeColors.primaryColor.withOpacity(0.8),
              AppThemeColors.primaryColor,
            ],
          ),
        ),
        _StatCard(
          title: 'Present Today',
          value: '42',
          subtitle: '87.5% attendance',
          icon: Icons.check_circle_rounded,
          color: Colors.green,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.withOpacity(0.8),
              Colors.green,
            ],
          ),
        ),
        _StatCard(
          title: 'On Leave',
          value: '4',
          subtitle: '2 pending approval',
          icon: Icons.beach_access_rounded,
          color: AppThemeColors.warningColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemeColors.warningColor.withOpacity(0.8),
              AppThemeColors.warningColor,
            ],
          ),
        ),
        _StatCard(
          title: 'Late Arrivals',
          value: '2',
          subtitle: '-50% from last week',
          icon: Icons.schedule_rounded,
          color: Colors.orange,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.withOpacity(0.8),
              Colors.orange,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.large(
          'Quick Actions',
          color: AppThemeColors.textPrimaryColor,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ActionCard(
                icon: Icons.add_circle_outline_rounded,
                title: 'Add Employee',
                subtitle: 'Register new staff',
                color: AppThemeColors.primaryColor,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ActionCard(
                icon: Icons.calendar_today_rounded,
                title: 'Manage Leaves',
                subtitle: 'Approve/reject requests',
                color: Colors.green,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ActionCard(
                icon: Icons.bar_chart_rounded,
                title: 'Reports',
                subtitle: 'View analytics',
                color: Colors.purple,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ActionCard(
                icon: Icons.settings_rounded,
                title: 'Settings',
                subtitle: 'System configuration',
                color: Colors.blueGrey,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextWidget.large(
              'Recent Activity',
              color: AppThemeColors.textPrimaryColor,
            ),
            TextButton(
              onPressed: () {},
              child: AppTextWidget.small(
                'View All',
                color: AppThemeColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppThemeColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView(
              children: [
                _ActivityItem(
                  icon: Icons.login_rounded,
                  title: 'John Doe checked in',
                  subtitle: 'Today at 08:45 AM',
                  color: Colors.green,
                ),
                _ActivityItem(
                  icon: Icons.logout_rounded,
                  title: 'Jane Smith checked out',
                  subtitle: 'Today at 05:30 PM',
                  color: Colors.blue,
                ),
                _ActivityItem(
                  icon: Icons.beach_access_rounded,
                  title: 'Mike Johnson applied for leave',
                  subtitle: '2 hours ago',
                  color: Colors.orange,
                ),
                _ActivityItem(
                  icon: Icons.warning_rounded,
                  title: 'Late arrival - Sarah Wilson',
                  subtitle: 'Today at 09:15 AM',
                  color: Colors.red,
                ),
                _ActivityItem(
                  icon: Icons.check_circle_rounded,
                  title: 'Leave approved - Robert Brown',
                  subtitle: 'Yesterday at 03:20 PM',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Gradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    AppTextWidget.veryLarge(
                      value,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppTextWidget.small(
                  title,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 2),
                AppTextWidget.verySmall(
                  subtitle,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppThemeColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            AppTextWidget.small(
              title,
              color: AppThemeColors.textPrimaryColor,
            ),
            // const SizedBox(height: 4),
            // AppTextWidget.small(
            //   subtitle,
            //   color: AppThemeColors.textSecondaryColor,
            // ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.medium(
                  title,
                  color: AppThemeColors.textPrimaryColor,
                ),
                const SizedBox(height: 4),
                AppTextWidget.small(
                  subtitle,
                  color: AppThemeColors.textSecondaryColor,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}