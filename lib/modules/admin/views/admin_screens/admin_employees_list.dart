import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/helper/admin_employee_helper.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/employee/add_leaves_by_admin_sheet.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/employee/employee_tile.dart';
import 'package:attedance_management_system/widgets/common/common_confirmation_dialog.dart';
import 'package:attedance_management_system/widgets/common/common_dialong_box.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../models/user.dart';
import '../../controller/admin_employees_controller.dart';
import '../user_form_screen.dart';

class AdminEmployeesList extends StatelessWidget {
  const AdminEmployeesList({Key? key}) : super(key: key);

  AdminEmployeesController get _adminEmployeesController =>
      Get.find<AdminEmployeesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Obx(() {
        final users = _adminEmployeesController.filteredUsers;
        final isLoaded =
            _adminEmployeesController.isLeavesHistoryLoaded.value;

        /// 🚫 Default: DO NOT SHOW button
        bool isShowButton = false;

        /// ✅ Only evaluate AFTER data is loaded
        if (isLoaded) {
          isShowButton =
              AdminEmployeeHelper.isActiveAddLeavesButtonForThisMonth(
                _adminEmployeesController.filteredAddedLeavesByAdmin,
              );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header
            Row(
              children: [
                AppTextWidget.medium(
                  'Employees'.tr,
                  color: AppThemeColors.textPrimaryColor,
                ),
                const Spacer(),
                AppTextWidget.small(
                  'Showing ${users.length}',
                  color: AppThemeColors.muted,
                ),

                /// ➕ Add Leaves Button
                if (isShowButton)
                  AppIconButtonWidget.large(
                    icon: AppConstIcons.addIcon,
                    onPressed: () {
                      Get.bottomSheet(
                        const AddLeavesByAdminSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 USERS LIST (Responsive)
            Expanded(
              child: users.isEmpty
                  ? Center(
                child: AppTextWidget.small(
                  'No users found'.tr,
                  color: AppThemeColors.muted,
                ),
              )
                  : LayoutBuilder(
                builder: (context, constraints) {
                  /// 🧠 Responsive columns
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kIsWeb ? 2 : 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: kIsWeb ? 5.2 : 4.2,
                    ),
                    itemBuilder: (_, idx) {
                      final u = users[idx];
                      return _UserTile(user: u);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}



class _UserTile extends StatelessWidget {
  final User user;
  _UserTile({required this.user, Key? key}) : super(key: key);

  final AdminEmployeesController _adminEmployeesControllerController = Get.find<AdminEmployeesController>();

  @override
  Widget build(BuildContext context) {
    return EmployeeTile(
      user: user,
      onEdit: () {
        showCommonDialog(
          context: context,
          child: UserForm(initialData: user),
        );
      },
      onChangePassword: () {
        _showChangePasswordDialog(context, user, _adminEmployeesControllerController);
      },
      onDelete: () async {
        final confirm = await showCommonConfirmationDialog(
          context,
          string: "Are you sure want to delete",
        );
        if (confirm == true && user.key != null) {
          await _adminEmployeesControllerController.deleteUser(user.key!);
        }
      },
    );

  }



  Future<void> _showChangePasswordDialog(
      BuildContext context,
      User user,
      AdminEmployeesController ctrl,
      ) async {
    final newPassCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (user.key == null || user.key!.isEmpty) {
      UIHelper.showSnackbar(
        "Key Not found",
        "User Data not found please refresh page",
      );
      return;
    }

    await showDialog(
      context: context,

      builder: (_) => AlertDialog(
        backgroundColor: AppThemeColors.popupBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        title: AppTextWidget.medium('Change Password'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newPassCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  validator: (v) =>
                  v == null || v.trim().length < 6
                      ? 'Minimum 6 characters'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  validator: (v) =>
                  v != newPassCtrl.text.trim()
                      ? 'Passwords do not match'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Get.back();
                await ctrl.changeUserPasswordByAdmin(
                  user.key!,
                  newPassCtrl.text.trim(),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }


}
