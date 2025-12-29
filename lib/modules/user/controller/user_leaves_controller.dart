import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/models/leave_balance.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

import '../../common/controller/loading_controller.dart';
import '../../models/apply_leave_request.dart';
import '../services/user_leaves_service.dart';

class UserLeavesController extends GetxController {
  final UserLeavesService _service = UserLeavesService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxBool applyingLeave = false.obs;
  final RxBool isCancelling = false.obs;

  final RxList<ApplyLeaveRequest> appliedLeaves = <ApplyLeaveRequest>[].obs;
  final RxList<LeaveBalance> leaveBalance = <LeaveBalance>[].obs;

  List<ApplyLeaveRequest> get filteredAppliedLeavesList => appliedLeaves;
  List<LeaveBalance> get filteredLeaveBalanceList => leaveBalance;




  @override
  void onReady() {
    super.onReady();
    final user = AppHelper.getProfileUser();
    if (user.key != null) {
      // loadLeavesStatus(user.key!);
      // loadLeavesBalance(user.key!);
    }
  }

  Future<void> refreshLeaves() async {
    final userKey = AppHelper.getProfileUser().key!;
    await loadLeavesStatus(userKey);
    await loadLeavesBalance(userKey);

  }

  // Controller Class Method

  Future<void> loadLeavesBalance(String userKey) async {
    _loadingController.start();

    try {
      // This line now correctly receives a List<Map<String, dynamic>>
      final List<Map<String, dynamic>> res = await _service.fetchLeavesBalance(userKey);

      leaveBalance
        ..clear()
      // Mapping from the correct List is now successful
        ..addAll(res.map((e) => LeaveBalance.fromJson(e)));
      leaveBalance.refresh();
    } catch (e) {
      // The print line has a typo in the original code, corrected here.
      print('UserLeavesController.loadLeavesBalance error: $e');
    } finally {
      _loadingController.hide();
    }
  }

  Future<void> loadLeavesStatus(String userKey) async {
    _loadingController.start();

    try {
      final List<Map<String, dynamic>> res =
      await _service.fetchLeavesStatus(userKey);
      appliedLeaves
        ..clear()
        ..addAll(res.map((e) => ApplyLeaveRequest.fromJson(e)));
      appliedLeaves.refresh();
    } catch (e) {
      print('UserLeavesController.loadLeavesStatus error: $e');
    } finally {
      _loadingController.hide();
    }
  }

  Future<bool> applyLeave(ApplyLeaveRequest request) async {
    _loadingController.start();
    applyingLeave.value = true;

    try {
      final res = await _service.applyLeave(request);
      if (res != null) {
        appliedLeaves.add(ApplyLeaveRequest.fromJson(res));
        appliedLeaves.refresh();
        return true;
      }
      return false;
    } catch (e) {
      print('UserLeavesController.applyLeave error: $e');
      return false;
    } finally {
      applyingLeave.value = false;
      _loadingController.hide();
    }
  }

  Future<void> onCancelLeave(ApplyLeaveRequest leave) async {

    final confirm = await Get.defaultDialog<bool>(
      contentPadding: EdgeInsets.all(10),
      backgroundColor: AppThemeColors.whiteColor,
      title: 'Cancel Leave',
      middleText: 'Do you really want to cancel this leave request?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm != true) return;

    if (leave.key == null) {
      Get.snackbar('Error', 'Invalid leave id');
      return;
    }

    isCancelling.value = true;
    _loadingController.start();

    try {
      await _service.cancelLeave(leave.key!);

      appliedLeaves.removeWhere((l) => l.key == leave.key);
      appliedLeaves.refresh();
      UIHelper.showSnackbar("Success", 'Leave request cancelled');
    } catch (e) {
      UIHelper.showSnackbar("Error", 'Failed to cancel leave request', type: SnackbarType.error);
    } finally {
      isCancelling.value = false;
      _loadingController.hide();

    }
  }
}
