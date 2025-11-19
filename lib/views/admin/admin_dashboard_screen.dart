import 'package:attedance_management_system/views/admin/admin_screens/admin_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/admin_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../widgets/app_text_type.dart';
import 'admin_screens/admin_employees_list.dart';
import 'admin_screens/admin_home_page.dart';
import 'admin_screens/admin_leaves_screen.dart';
import 'user_form_screen.dart';

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
    AdminProfileScreen()
  ];

  final List<String> _titles = [
    'Home',
    'Employees',
    'Leaves',
    'Profile'
  ];

  void _openAddUser() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserForm(
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _currentIndex == 1; // show FAB only on Employees tab

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppThemeColors.appbarBackgroundColor,
        title: AppTextWidget.large(_titles[_currentIndex], color: AppThemeColors.whiteColor,),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
        onPressed: _openAddUser,
        backgroundColor: AppThemeColors.primaryColor,
        icon: Icon(Icons.person_add, color: Colors.white),
        label: AppTextWidget.medium('Add User', color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppThemeColors.whiteColor,
        selectedItemColor: AppThemeColors.primaryColor,

        unselectedItemColor: AppThemeColors.muted,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Employees'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access_outlined), label: 'Leaves'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'.tr),
        ],
      ),
    );
  }
}
