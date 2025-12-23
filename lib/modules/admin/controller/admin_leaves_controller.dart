import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../../core/constants/app_theme_colors.dart';
import '../../common/controller/loading_controller.dart';
import '../../models/admin_action.dart';
import '../../models/apply_leave_request.dart';
import '../services/admin_leaves_service.dart';

class AdminLeavesController extends GetxController {
  final AdminLeavesService _service = AdminLeavesService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxList<ApplyLeaveRequest> leaveRequestsList = <ApplyLeaveRequest>[].obs;
  final RxInt selectedFilter = 0.obs;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // loadLeaves();
    });
  }

  Future<void> refreshLeaves() async {
    selectedFilter.value = 0;

    await loadLeaves();
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  List<ApplyLeaveRequest> get filteredLeaveRequestsList {
    final all = leaveRequestsList;

    switch (selectedFilter.value) {
      case 1:
        return all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.approvedLeavesStatusKey)
            .toList();

      case 2:
        return all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.pendingLeavesStatusKey)
            .toList();

      case 3:
        return all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.rejectedLeavesStatusKey)
            .toList();

      default:
        return all;
    }
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
    final confirmed = await UIHelper.showConfirmationDialog(
      title: 'Approve Leave',
      message: 'Are you sure you want to approve this leave request?',
      confirmText: 'Approve',
      confirmColor: AppThemeColors.successColor,
    );

    if (confirmed != true) return;

    _loadingController.start();
    try {
      final updatedRequest =
      await _service.adminActionOnLeave(payload);

      if (updatedRequest != null) {
        final idx = leaveRequestsList
            .indexWhere((l) => l.key == payload.leavesId);

        if (idx != -1) {
          leaveRequestsList[idx] = updatedRequest;
          leaveRequestsList.refresh();
        }
      }

      Get.snackbar(
        'Success',
        'Leave approved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, st) {
      Get.snackbar(
        'Error',
        'Unable to approve leave',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
      );
      debugPrint('approveLeave error: $e\n$st');
    } finally {
      _loadingController.hide();
    }
  }

  Future<void> rejectLeave(AdminAction payload) async {
    final confirmed = await UIHelper.showConfirmationDialog(
      title: 'Reject Leave',
      message: 'Are you sure you want to reject this leave request?',
      confirmText: 'Reject',
      confirmColor: AppThemeColors.errorColor,
    );

    if (confirmed != true) return;

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

      Get.snackbar(
        'Success',
        'Leave rejected successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, st) {
      Get.snackbar(
        'Error',
        'Unable to reject leave',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
      );
      debugPrint('rejectLeave error: $e\n$st');
    } finally {
      _loadingController.hide();
    }
  }



  int get pendingLeaves => leaveRequestsList
      .where((l) => l.leaveStatus == AppStrings.pendingLeavesStatusKey)
      .length;
}
