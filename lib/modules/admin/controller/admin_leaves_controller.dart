import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../common/controller/loading_controller.dart';
import '../../models/admin_action.dart';
import '../../models/apply_leave_request.dart';
import '../services/admin_leaves_service.dart';

class AdminLeavesController extends GetxController {
  final AdminLeavesService _service = AdminLeavesService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxList<ApplyLeaveRequest> leaveRequestsList =
      <ApplyLeaveRequest>[].obs;
  List<ApplyLeaveRequest> get filteredLeaveRequestsList =>
      leaveRequestsList;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadLeaves();
    });
  }

  Future<void> refreshLeaves() async {
    await loadLeaves();
  }

  Future<void> loadLeaves() async {
    leaveRequestsList.clear();
    _loadingController.show();

    try {
      final res = await _service.fetchLeavesList();
      if (!AppHelper.isEmptyOrNull(res)) {
        leaveRequestsList.addAll(
          res.map((e) => ApplyLeaveRequest.fromJson(e)),
        );
        leaveRequestsList.refresh();
      }
    } catch (e) {
      print('AdminLeavesController.loadLeaves error: $e');
    } finally {
      _loadingController.hide();

    }
  }

  Future<void> approveLeave(AdminAction payload) async {
    _loadingController.start();
    try {
      final updatedRequest = await _service.adminActionOnLeave(payload);

      if (updatedRequest != null) {
        final idx = leaveRequestsList.indexWhere((l) => l.key == payload.leavesId);
        if (idx != -1) {
          leaveRequestsList[idx] = updatedRequest;
          leaveRequestsList.refresh();
        }
      }
    } catch (e, st) {
      // show a friendly error and log stacktrace for debugging
      Get.snackbar('Error', 'Unable to approve leave: ${e.toString()}');
      // optional: print/stash stacktrace
      debugPrint('approveLeave error: $e\n$st');
    } finally {
      _loadingController.hide();
    }
  }

  Future<void> rejectLeave(AdminAction payload) async {
    _loadingController.start();
    try {
      final updatedRequest = await _service.adminActionOnLeave(payload);

      if (updatedRequest != null) {
        final idx = leaveRequestsList.indexWhere((l) => l.key == payload.leavesId);
        if (idx != -1) {
          leaveRequestsList[idx] = updatedRequest;
          leaveRequestsList.refresh();
        }
      }
    } catch (e, st) {
      Get.snackbar('Error', 'Unable to reject leave: ${e.toString()}');
      debugPrint('rejectLeave error: $e\n$st');
    } finally {
      _loadingController.hide();
    }
  }



  int get pendingLeaves => leaveRequestsList
      .where((l) => l.leaveStatus == AppStrings.pendingLeavesStatusKey)
      .length;
}
