import 'package:attedance_management_system/modules/user/views/user_screens/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/appbar/appbar_widget.dart';

// User screens
import 'package:attedance_management_system/modules/user/views/user_screens/user_leaves_screen.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/user_activity_screen.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/user_profile_screen.dart';

// Controllers

import '../../models/user.dart';
import '../controller/user_activity_controller.dart';
import '../controller/user_home_controller.dart';
import '../controller/user_leaves_controller.dart';
import '../controller/user_profile_controller.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState
    extends State<UserDashboardScreen> {
  int _currentIndex = 0;
  final User user = AppHelper.getProfileUser();

  final List<Widget> _pages = const [
    UserHomeScreen(),
    UserLeavesScreen(),
    UserActivityScreen(),
    UserProfileScreen(),
  ];

  // optional: avoid double-calling when coming back to same tab
  final Set<int> _initializedTabs = {0}; // home already loaded by onInit

  Future<void> _onTabChanged(int index) async {
    setState(() => _currentIndex = index);

    // Get userKey if needed
    final userKey = AppHelper.getProfileUser().key;

    // If somehow no userKey, just skip network
    if (userKey == null) return;

    // Decide which controller to refresh
    switch (index) {
      case 0:
      // Home tab
        await Get.find<UserHomeController>().refreshHome();
        await Get.find<UserActivityController>().getActivityByDate(DateTime.now().toIso8601String());

        break;
      case 1:
      // Leaves tab
        await Get.find<UserLeavesController>().refreshLeaves();
        break;
      case 2:
      // Activity tab
        await Get.find<UserActivityController>().refreshActivity();
        break;
      case 3:
      // Profile tab (if you want live refresh)
        if (Get.isRegistered<UserProfileController>()) {
          await Get.find<UserProfileController>().refreshProfile();
        }
        break;
    }

    _initializedTabs.add(index);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
        const Size.fromHeight(80.0),
        child: UserAppBar(user: user),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor:
        AppThemeColors.primaryColor,
        unselectedItemColor:
        AppThemeColors.muted,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.beach_access_outlined),
              label: 'Leaves'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined),
              label: 'Activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
