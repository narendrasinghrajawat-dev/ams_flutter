





  import '../model/add_leaves_by_admin.dart';

class AdminEmployeeHelper {
  /// Returns TRUE if Add Leaves button should be ACTIVE
  /// Returns FALSE if leaves already added for current month
  static bool isActiveAddLeavesButtonForThisMonth(
  List<AddLeavesByAdmin> addedLeavesList,
  ) {
  if (addedLeavesList.isEmpty) return true;

  final now = DateTime.now().toUtc();
  final currentMonthKey =
  '${now.year}-${now.month.toString().padLeft(2, '0')}';

  /// Check if any entry already exists for current month
  final existsForCurrentMonth = addedLeavesList.any(
  (e) => e.monthKey == currentMonthKey,
  );

  /// Button active ONLY if NOT exists
  return !existsForCurrentMonth;
  }
  }
