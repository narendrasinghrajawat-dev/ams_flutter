class ApplyLeaveRequest {
  final String userKey;
  final String startDate;     // e.g. "2025-11-21"
  final String endDate;       // e.g. "2025-11-23"
  final String reason;
  final String leaveType;     // e.g. "Sick", "Casual"
  final int numberOfLeaves;
  final bool isFullDay;
  final bool isHalfDay;

  ApplyLeaveRequest({
    required this.userKey,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveType,
    required this.numberOfLeaves,
    required this.isFullDay,
    required this.isHalfDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'userKey': userKey,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'leaveType': leaveType,
      'numberOfLeaves': numberOfLeaves,
      'isFullDay': isFullDay,
      'isHalfDay': isHalfDay,
    };
  }
}
