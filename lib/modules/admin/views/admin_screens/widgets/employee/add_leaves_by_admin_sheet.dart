import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/controller/admin_employees_controller.dart';
import 'package:attedance_management_system/modules/common/controller/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../widgets/form_widgets/dropdown_field_widget.dart';
import '../../../../../../widgets/form_widgets/text_field_widget.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_icon_button.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../model/add_leaves_by_admin.dart';


class AddLeavesByAdminSheet extends StatefulWidget {
  const AddLeavesByAdminSheet({super.key});

  @override
  State<AddLeavesByAdminSheet> createState() =>
      _AddLeavesByAdminSheetState();
}

class _AddLeavesByAdminSheetState extends State<AddLeavesByAdminSheet> {
  final _formKey = GlobalKey<FormState>();
  final CommonController _commonController = Get.find<CommonController>();

  final AdminEmployeesController _adminEmployeesController = Get.find<AdminEmployeesController>();

  String? _leaveTypeId;
  final TextEditingController _leavesCtrl =
  TextEditingController(text: '2');

  List leaveTypes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leaveTypes = _commonController.getMasterData.value?.leaveType.map((item) => item.toJson()).toList() ?? [];
    _leaveTypeId = leaveTypes[0]['id'];

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SizedBox(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.large('Add Monthly Leaves'),
                  const SizedBox(height: 12),

                  /// 🔹 Leave Type
                  DropdownFieldWidget(
                    labelText: 'Leave Type',
                    value: _leaveTypeId,
                    items: leaveTypes,
                    onChanged: (val) => setState(() => _leaveTypeId = val),
                    validator: (val) =>
                    val == null ? 'Please select leave type' : null,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Number of Leaves
                  TextFieldWidget(
                    controller: _leavesCtrl,
                    labelText: 'Number of Leaves',
                    keyboardInputType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter number of leaves';
                      }
                      final count = int.tryParse(val);
                      if (count == null || count <= 0) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppIconButtonWidget.small(
                        icon: Icons.close,
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 12),
                      AppIconButtonWidget.medium(
                        icon: Icons.check,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          Get.back();

                          final request = AddLeavesByAdmin(
                            adminKey: AppHelper.getProfileUser().key!, // logged-in admin key
                            addedLeaves: int.parse(_leavesCtrl.text),
                            leaveTypeId: _leaveTypeId!,
                            actionDate: DateTime.now().toUtc().toIso8601String(),
                          );

                          await _adminEmployeesController.addLeavesByAdmin(request);

                        },
                      ),

                    ],
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}
