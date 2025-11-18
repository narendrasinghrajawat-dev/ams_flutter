import 'package:get/get.dart';
import '../../data/models/leave_request.dart';
import '../../data/models/user.dart';

class AdminController extends GetxController {
  final RxList<User> users = <User>[].obs;
  final RxList<LeaveRequest> leaveRequests = <LeaveRequest>[].obs;

  final RxBool loading = false.obs;
  final RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    // Replace with actual repo calls later.
    users.addAll([
      User(id: '1', name: 'Amit Sharma', email: 'amit@example.com', role: 'user', deptId: 'D1'),
      User(id: '3', name: 'Rahul Jain', email: 'rahul@example.com', role: 'admin', deptId: 'D1'),
    ]);

    leaveRequests.addAll([
      LeaveRequest(
        id: 'L1',
        userId: '1',
        userName: 'Amit Sharma',
        from: DateTime.now().subtract(Duration(days: 1)),
        to: DateTime.now().add(Duration(days: 1)),
        status: 'pending',
        reason: 'Medical',
      ),
      LeaveRequest(
        id: 'L2',
        userId: '2',
        userName: 'Priya Singh',
        from: DateTime.now().add(Duration(days: 5)),
        to: DateTime.now().add(Duration(days: 7)),
        status: 'approved',
        reason: 'Personal',
      ),
    ]);
  }

  List<User> get filteredUsers {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return users;
    return users.where((u) => u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q)).toList();
  }

  void addUser({required String name, required String email, String role = 'user', String? deptId}) {
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
      deptId: deptId,
    );
    users.insert(0, newUser);
  }

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
