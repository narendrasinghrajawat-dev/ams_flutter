class AddLeavesByAdmin {
  // 🔹 Request fields
  final String adminKey;
  final int addedLeaves;       // renamed from addLeaves (API response uses addedLeaves)
  final String leaveTypeId;
  final String actionDate;     // ISO string

  // 🔹 Response-only fields
  final String? key;            // _key from ArangoDB
  final String? monthKey;      // "2025-12"
  final String? createdAt;     // ISO string

  AddLeavesByAdmin({
    required this.adminKey,
    required this.addedLeaves,
    required this.leaveTypeId,
    required this.actionDate,
    this.key,
    this.monthKey,
    this.createdAt,
  });

  // 🔁 From JSON (API → App)
  factory AddLeavesByAdmin.fromJson(Map<String, dynamic> json) {
    return AddLeavesByAdmin(
      key: json['_key'] as String?,
      adminKey: json['adminKey'] as String,
      monthKey: json['monthKey'] as String?,
      leaveTypeId: json['leaveTypeId'] as String,
      addedLeaves: json['addedLeaves'] is int
          ? json['addedLeaves']
          : (json['addedLeaves'] as num).toInt(),
      actionDate: json['actionDate'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }

  // 🔼 To JSON (App → API)
  /// Used ONLY when calling addLeavesByAdmin API
  Map<String, dynamic> toJson() {
    return {
      'adminKey': adminKey,
      'addLeaves': addedLeaves,   // backend expects addLeaves
      'leaveTypeId': leaveTypeId,
      'actionDate': actionDate,
    };
  }

  // 🕒 Helper – create request with current date
  factory AddLeavesByAdmin.request({
    required String adminKey,
    required int addLeaves,
    required String leaveTypeId,
  }) {
    return AddLeavesByAdmin(
      adminKey: adminKey,
      addedLeaves: addLeaves,
      leaveTypeId: leaveTypeId,
      actionDate: DateTime.now().toUtc().toIso8601String(),
    );
  }
}
