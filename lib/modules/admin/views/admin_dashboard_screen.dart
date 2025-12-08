import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/modules/admin/views/user_form_screen.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_theme_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';

// Screens
import '../controller/admin_employees_controller.dart';
import '../controller/admin_home_controller.dart';
import '../controller/admin_leaves_controller.dart';
import 'admin_screens/admin_employees_list.dart';
import 'admin_screens/admin_home_page.dart';
import 'admin_screens/admin_leaves_screen.dart';
import 'admin_screens/admin_profile_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AdminHomePage(),
    AdminEmployeesList(),
    AdminLeavesScreen(),
    const AdminProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Employees',
    'Leaves',
    'Profile',
  ];

  void _openAddUser() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UserForm(),
    );
  }

  /// 🔹 Called whenever bottom nav tab is changed
  Future<void> _onTabChanged(int index) async {
    setState(() => _currentIndex = index);

    switch (index) {
    // HOME TAB
      case 0:
        if (Get.isRegistered<AdminHomeController>()) {
          await Get.find<AdminHomeController>().refreshHome();
        }
        break;

    // EMPLOYEES TAB
      case 1:
        if (Get.isRegistered<AdminEmployeesController>()) {
          await Get.find<AdminEmployeesController>().refreshEmployees();
        }
        break;

    // LEAVES TAB
      case 2:
        if (Get.isRegistered<AdminLeavesController>()) {
          await Get.find<AdminLeavesController>().refreshLeaves();
        }
        break;

    // PROFILE TAB
      case 3:
      // Add AdminProfileController refresh here later if needed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _currentIndex == 1; // show FAB only on Employees tab

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppThemeColors.appbarBackgroundColor,
        title: AppTextWidget.large(
          _titles[_currentIndex],
          color: AppThemeColors.whiteColor,
        ),
        actions: [
          AppIconButtonWidget.large(
            icon: AppConstIcons.settingsIcon,
            color: Colors.white,
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.toNamed(AppRoutes.settingsScreen);
              });
            },
          ).marginOnly(right: 10),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide(color: AppThemeColors.primaryColor),
        ),
        backgroundColor: AppThemeColors.primaryColor,
        onPressed: _openAddUser,
        child: AppIconWidget.large(
          AppConstIcons.addIcon,
          color: AppThemeColors.whiteColor,
        ),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppThemeColors.whiteColor,
        selectedItemColor: AppThemeColors.primaryColor,
        unselectedItemColor: AppThemeColors.muted,
        onTap: _onTabChanged, // 👈 controller-based handler
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined), label: 'Home'.tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.group_outlined), label: 'Employees'.tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.beach_access_outlined), label: 'Leaves'.tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: 'Profile'.tr),
        ],
      ),
    );
  }
}
