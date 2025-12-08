import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../widgets/refresh_screen_widget/icecream_indicator.dart';
import '../../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

import '../../controller/admin_home_controller.dart';
import 'admin_widgets/admin_homepage_widgets.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  // controller
  AdminHomeController get _admin => Get.find<AdminHomeController>();

  Future<void> _refreshData() async {
    await _admin.refreshHome();
  }

  @override
  Widget build(BuildContext context) {
    return
      // RefreshIndicatorWidget(
      // onRefresh: _refreshData,
      // child:
      Obx(() {
        final hasAnyData =
            _admin.users.isNotEmpty ||
                _admin.attendanceList.isNotEmpty ||
                _admin.leaveRequestsList.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(),
              const SizedBox(height: 15),
              _buildQuickActions(),
              const SizedBox(height: 10),
              Expanded(child: _buildRecentActivity()),
            ],
          ),
        );
      }
      // ),
    );
  }

  Widget _buildStatsGrid() {
    print('_admin.totalEmployees ${_admin.totalEmployees}');

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
          subtitle:
          '${(_admin.totalEmployees > 0 ? (_admin.presentToday / _admin.totalEmployees) * 100 : 0).toStringAsFixed(1)}% attendance',
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
                onTap: () => Get.toNamed('/add-employee'),
              ),
              const SizedBox(width: 12),
              ActionCard(
                icon: Icons.calendar_today_rounded,
                title: 'Manage Leaves',
                color: Colors.green,
                onTap: () => Get.toNamed('/admin-leaves'),
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
              onPressed: () => Get.toNamed('/activity-log'),
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

            if (list.isEmpty) {
              return Center(
                child: AppTextWidget.small(
                  'No recent activity found.',
                  color: AppThemeColors.muted,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (_, idx) {
                final activity = list[idx];
                return ActivityItem.fromActivity(activity);
              },
            );
          }),
        ),
      ],
    );
  }
}
