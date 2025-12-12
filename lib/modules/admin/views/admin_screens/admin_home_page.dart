import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../controller/admin_home_controller.dart';
import 'admin_widgets/admin_homepage_widgets.dart';
import '../../../../../widgets/refresh_screen_widget/icecream_indicator.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  AdminHomeController get _admin => Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: RefreshIndicator(
          onRefresh: () => _admin.refreshHome(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildStatsSection(),
              const SizedBox(height: 20),
              _buildQuickActionsSection(),
              const SizedBox(height: 5),
              Expanded(child: _buildRecentActivitySection()),
            ],
          ),
        ),
      );
    });
  }

  // ------------------------------
  // HEADER (Title + Summary)
  // ------------------------------
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.large(
          'Admin Dashboard',
          color: AppThemeColors.textPrimaryColor,
        ),
        const SizedBox(height: 4),
        AppTextWidget.small(
          'Overview of today’s attendance & activities',
          color: AppThemeColors.textSecondaryColor,
        ),
      ],
    );
  }

  // ------------------------------
  // STATS SECTION (New clean design)
  // ------------------------------
  Widget _buildStatsSection() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.5,
      ),
      children: [
        _statCard(
          title: "Total Employees",
          value: _admin.totalEmployees.toString(),
          icon: Icons.people_alt_rounded,
          color: Colors.blue,
        ),
        _statCard(
          title: "Present Today",
          value: _admin.presentToday.toString(),
          icon: Icons.check_circle_rounded,
          color: Colors.green,
        ),
        _statCard(
          title: "On Leave",
          value: _admin.onLeaveToday.toString(),
          icon: Icons.beach_access_rounded,
          color: Colors.orange,
        ),
        _statCard(
          title: "Late Arrivals",
          value: _admin.lateArrivalsToday.toString(),
          icon: Icons.schedule_rounded,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
      ),
      child: CommonCardWidget(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.verySmall(
                    title,
                    color: AppThemeColors.textSecondaryColor,
                  ),
                  const SizedBox(height: 4),
                  AppTextWidget.large(
                    value,
                    color: AppThemeColors.textPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // QUICK ACTIONS (New modern style)
  // ------------------------------
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.medium(
          "Quick Actions",
          color: AppThemeColors.textPrimaryColor,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _quickActionCard(
                icon: Icons.person_add_alt_1_rounded,
                title: "Add Employee",
                color: AppThemeColors.primaryColor,
                onTap: () => Get.toNamed('/add-employee'),
              ),
              _quickActionCard(
                icon: Icons.calendar_month_rounded,
                title: "Manage Leaves",
                color: Colors.green,
                onTap: () => Get.toNamed('/admin-leaves'),
              ),
              _quickActionCard(
                icon: Icons.bar_chart_rounded,
                title: "Reports",
                color: Colors.purple,
                onTap: () {},
              ),
              _quickActionCard(
                icon: Icons.settings_rounded,
                title: "Settings",
                color: Colors.blueGrey,
                onTap: () => Get.toNamed('/settings'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              AppTextWidget.small(
                title,
                color: AppThemeColors.textPrimaryColor,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // RECENT ACTIVITY LIST
  // ------------------------------
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextWidget.medium(
              "Recent Activity",
              color: AppThemeColors.textPrimaryColor,
            ),
            TextButton(
              onPressed: () => null,
              child: AppTextWidget.small(
                "View All",
                color: AppThemeColors.primaryColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: Obx(() {
            final items = _admin.recentActivityList;

            if (items.isEmpty) {
              return Center(
                child: AppTextWidget.small(
                  "No recent activity found.",
                  color: AppThemeColors.muted,
                ),
              );
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                return ActivityItem.fromActivity(items[i]); // Uses your updated navigation logic
              },
            );
          }),
        )
      ],
    );
  }
}
