import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:get/get.dart';

import '../../models/apply_leave_request.dart';
import '../services/user_leaves_service.dart';

class UserLeavesController extends GetxController {
  final UserLeavesService _service = UserLeavesService();

  final RxBool isLoading = false.obs;
  final RxBool applyingLeave = false.obs;
  final RxBool isCancelling = false.obs;

  final RxList<ApplyLeaveRequest> appliedLeaves = <ApplyLeaveRequest>[].obs;

  List<ApplyLeaveRequest> get filteredAppliedLeavesList => appliedLeaves;




  @override
  void onReady() {
    super.onReady();
    final user = AppHelper.getProfileUser();
    if (user.key != null) {
      loadLeavesStatus(user.key!);
    }
  }

  Future<void> refreshLeaves() async {
    final userKey = AppHelper.getProfileUser().key!;
    await loadLeavesStatus(userKey);
  }



  Future<void> loadLeavesStatus(String userKey) async {
    try {
      isLoading.value = true;
      final List<Map<String, dynamic>> res =
      await _service.fetchLeavesStatus(userKey);
      appliedLeaves
        ..clear()
        ..addAll(res.map((e) => ApplyLeaveRequest.fromJson(e)));
      appliedLeaves.refresh();
    } catch (e) {
      print('UserLeavesController.loadLeavesStatus error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> applyLeave(ApplyLeaveRequest request) async {
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
    }
  }

  Future<void> onCancelLeave(ApplyLeaveRequest leave) async {
    final confirm = await Get.defaultDialog<bool>(
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
    try {
      await _service.cancelLeave(leave.key!);

      appliedLeaves.removeWhere((l) => l.key == leave.key);
      appliedLeaves.refresh();

      Get.snackbar(
        'Success',
        'Leave request cancelled',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel leave request',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCancelling.value = false;
    }
  }
}
