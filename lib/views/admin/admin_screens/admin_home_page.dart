import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/refresh_screen_widget/icecream_indicator.dart';
import '../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';

// Import the new common dashboard widgets
import 'admin_widgets/admin_homepage_widgets.dart';


class AdminHomePage extends StatelessWidget {
  AdminHomePage({Key? key}) : super(key: key);

  // Get the controller instance
  final AdminController _admin = Get.find<AdminController>();

  Future<void> _refreshData() async {
    print('refresh called');
    // await _admin.refreshAllData(); // Use the central refresh function
    print('refresh called after data update');
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorWidget(
      onRefresh: _refreshData,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards Grid (Dynamic)
            Obx(() => _buildStatsGrid()),
            const SizedBox(height: 15),

            // Quick Actions Section (Static for now, onTap can be dynamic)
            _buildQuickActions(),
            const SizedBox(height: 10),

            // Recent Activity Section (Dynamic)
            Expanded(
              child: _buildRecentActivity(),
            ),
          ],
        ),
      ),
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
        StatCard(
          title: 'Total Employees',
          value: _admin.totalEmployees.toString(),
          subtitle: 'Total registered staff',
          icon: Icons.people_alt_rounded,
        ),
        StatCard(
          title: 'Present Today',
          value: _admin.presentToday.toString(),
          // Calculate percentage: (Present / Total) * 100
          subtitle: '${(_admin.totalEmployees > 0 ? (_admin.presentToday / _admin.totalEmployees) * 100 : 0).toStringAsFixed(1)}% attendance',
          icon: Icons.check_circle_rounded,
        ),
        StatCard(
          title: 'On Leave',
          value: _admin.onLeaveToday.toString(),
          subtitle: '${_admin.pendingLeaves} pending approval',
          icon: Icons.beach_access_rounded,
        ),
        StatCard(
          title: 'Late Arrivals',
          value: _admin.lateArrivalsToday.toString(),
          subtitle: 'Attendance issues today',
          icon: Icons.schedule_rounded,
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
              ActionCard(
                icon: Icons.person_add_alt_1_rounded,
                title: 'Add Employee',
                color: AppThemeColors.primaryColor,
                onTap: () => Get.toNamed('/add-employee'), // Example navigation
              ),
              const SizedBox(width: 12),
              ActionCard(
                icon: Icons.calendar_today_rounded,
                title: 'Manage Leaves',
                color: Colors.green,
                onTap: () => Get.toNamed('/admin-leaves'), // Example navigation
              ),
              const SizedBox(width: 12),
              ActionCard(
                icon: Icons.bar_chart_rounded,
                title: 'Reports',
                color: Colors.purple,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              ActionCard(
                icon: Icons.settings_rounded,
                title: 'Settings',
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
            AppTextWidget.medium(
              'Recent Activity',
              color: AppThemeColors.textPrimaryColor,
            ),
            TextButton(
              onPressed: () => Get.toNamed('/activity-log'), // Example navigation
              child: AppTextWidget.small(
                'View All',
                color: AppThemeColors.primaryColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: Obx(() {
            final list = _admin.recentActivityList;
            if (_admin.loading.value && list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (list.isEmpty) {
              return Center(
                child: AppTextWidget.small('No recent activity found.', color: AppThemeColors.muted),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (_, idx) {
                final activity = list[idx];
                return ActivityItem.fromActivity(activity); // Use the smart factory constructor
              },
            );
          }),
        ),
      ],
    );
  }
}