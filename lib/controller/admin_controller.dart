import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/services/admin/admin_services.dart';
import 'package:get/get.dart';
import '../models/leave_request.dart';
import '../models/user.dart';

class AdminController extends GetxController {
  RxList<User> users = <User>[].obs;
  final RxList<LeaveRequest> leaveRequests = <LeaveRequest>[].obs;
  final AdminServices _adminServices = AdminServices();

  final RxBool loading = false.obs;


  @override
  void onInit() {
    super.onInit();
    // _loadMockData();
    _loadUsersList();

  }


  _loadUsersList() async {
    final List<Map<String, dynamic>> res = await _adminServices.fetchUsersList();
    print('fech users list si teh ');
    print(res);

    if(!AppHelper.isEmptyOrNull(res)){
      for(var item in res){
        User user = User.fromJson(item);
        users.add(user);
      }
    }
  }

  // Assuming this function is inside a class with access to 'users' and 'leaveRequests' (RxList).
// The User and Address models must be imported.

  void _loadMockData() {
    leaveRequests.addAll([
      LeaveRequest(
        id: 'L1',
        userId: '1',
        userName: 'Amit Sharma', // Corrected field name
        from: DateTime.now().subtract(const Duration(days: 1)),
        to: DateTime.now().add(const Duration(days: 1)),
        status: 'pending',
        reason: "Due to Fever"
      ),
      LeaveRequest(
        id: 'L2',
        userId: '2',
        userName: 'Priya Singh', // Corrected field name
        from: DateTime.now().add(const Duration(days: 5)),
        to: DateTime.now().add(const Duration(days: 7)),
        status: 'approved',
        reason: "Due to Fever"

      ),
    ]);
  }

  List<User> get filteredUsers => users;

  void approveLeave(String id) {
    final idx = leaveRequests.indexWhere((l) => l.id == id);
    if (idx != -1) {
      leaveRequests[idx].status = 'approved';
      leaveRequests.refresh();
    }
  }

  void rejectLeave(String id) {
    final idx = leaveRequests.indexWhere((l) => l.id == id);
    if (idx != -1) {
      leaveRequests[idx].status = 'rejected';
      leaveRequests.refresh();
    }
  }
}
