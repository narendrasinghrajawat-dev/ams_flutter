class LeaveRequest {
  String id;
  String userId;
  String userName;
  DateTime from;
  DateTime to;
  String status; // pending/approved/rejected
  String reason;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.from,
    required this.to,
    required this.status,
    required this.reason,
  });
}
