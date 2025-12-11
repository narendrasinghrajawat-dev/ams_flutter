import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../models/admin_action.dart';
import '../../models/apply_leave_request.dart';
import '../services/admin_leaves_service.dart';

class AdminLeavesController extends GetxController {
  final AdminLeavesService _service = AdminLeavesService();

  final RxList<ApplyLeaveRequest> leaveRequestsList =
      <ApplyLeaveRequest>[].obs;
  List<ApplyLeaveRequest> get filteredLeaveRequestsList =>
      leaveRequestsList;


  @override
  void onInit() {
    super.onInit();
    loadLeaves();
  }

  Future<void> refreshLeaves() async {
    await loadLeaves();
  }

  Future<void> loadLeaves() async {
    leaveRequestsList.clear();

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
    }
  }

  Future<void> approveLeave(AdminAction payload) async {
    final updatedRequest = await _service.adminActionOnLeave(payload);

    if (updatedRequest != null) {
      final idx = leaveRequestsList.indexWhere(
            (l) => l.key == payload.leavesId,
      );
      if (idx != -1) {
        leaveRequestsList[idx] = updatedRequest;
        leaveRequestsList.refresh();
      }
    }
  }

  Future<void> rejectLeave(AdminAction payload) async {
    final updatedRequest =
    await _service.adminActionOnLeave(payload);

    if (updatedRequest != null) {
      final idx = leaveRequestsList.indexWhere(
            (l) => l.key == payload.leavesId,
      );
      if (idx != -1) {
        leaveRequestsList[idx] = updatedRequest;
        leaveRequestsList.refresh();
      }
    }
  }

  int get pendingLeaves => leaveRequestsList
      .where((l) => l.leaveStatus == AppStrings.pendingLeavesStatusKey)
      .length;
}
