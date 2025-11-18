import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth/auth_controller.dart';

class UserDashboard extends StatelessWidget {
  final AuthController _auth = Get.find<AuthController>();

  UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user_dashboard'.tr),
        actions: [IconButton(onPressed: _auth.logout, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text('Welcome, ${_auth.currentUser.value?.name ?? ''}')),
    );
  }
}
