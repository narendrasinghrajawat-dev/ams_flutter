import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/views/user/user_screens/user_activity_screen.dart';
import 'package:attedance_management_system/views/user/user_screens/user_home_page.dart';
import 'package:attedance_management_system/views/user/user_screens/user_leaves_screen.dart';
import 'package:attedance_management_system/views/user/user_screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../models/user.dart';
import '../../widgets/appbar/appbar_widget.dart';

// design reference (if needed): /mnt/data/d2050a7b-a516-429c-9ce0-e2ccd1bb3b90.png

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {



  int _currentIndex = 0;
  User user = AppHelper.getProfileUser();

  final List<Widget> _pages = const [
    UserHomePage(),
    UserLeavesScreen(),
    UserActivityScreen(),
    UserProfileScreen(),
  ];

  final List<String> _titles = ['Home', 'Leaves', 'Activity', 'Profile'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Adjust height as needed
        child: UserAppBar(user: user,)
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // floatingActionButton: _currentIndex == 0
      //     ? FloatingActionButton(
      //   onPressed: () {
      //     // primary quick action on Home (example)
      //     Get.snackbar('Action', 'Quick action tapped', snackPosition: SnackPosition.BOTTOM);
      //   },
      //   backgroundColor: AppThemeColors.primaryColor,
      //   child: const Icon(Icons.add),
      // )
      //     : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppThemeColors.primaryColor,
        unselectedItemColor: AppThemeColors.muted,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access_outlined), label: 'Leaves'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline_outlined), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
