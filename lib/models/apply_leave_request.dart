class ApplyLeaveRequest {
  // Optional fields for database/backend identification
  final String? key;
  final String? id;
  final String? rev;

  // Required fields for creating a new leave request
  final String userKey;
  final String startDate;     // e.g. "2025-11-21"
  final String endDate;       // e.g. "2025-11-23"
  final String reason;
  final String leaveType;     // e.g. "Sick", "Casual"
  final double numberOfLeaves; // Changed to double to handle half days (e.g., 0.5, 1.5)
  final bool isFullDay;
  final bool isHalfDay;

  // Fields set by the system/approver (optional upon creation, present upon retrieval)
  final String? leaveStatus;     // e.g. "Pending", "Approved", "Rejected"
  final String? actionDate;      // Date status was set, e.g. "2025-11-23"

  final String? approverByName;  // Name of the approver
  final String? approverByKey;   // Key/ID of the approver

  // --- Constructor ---

  // Main constructor to initialize all fields. Optional fields should be nullable.
  ApplyLeaveRequest({
    this.key,
    this.id,
    this.rev,
    required this.userKey,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveType,
    required this.numberOfLeaves,
    required this.isFullDay,
    required this.isHalfDay,
    this.leaveStatus,
    this.actionDate,
    this.approverByName,
    this.approverByKey,
  });

  // --- Factory Constructor for fromJson ---

  factory ApplyLeaveRequest.fromJson(Map<String, dynamic> json) {
    print('ApplyLeaveRequest json is the $json');

    // Helper for safe string
    String _s(dynamic v) => v?.toString() ?? '';

    // Helper for optional string
    String? _sOrNull(dynamic v) => v == null ? null : v.toString();

    return ApplyLeaveRequest(
      // DB fields
      key: _sOrNull(json['_key'] ?? json['key']),
      id: _sOrNull(json['_id'] ?? json['id']),
      rev: _sOrNull(json['_rev'] ?? json['rev']),

      // Core request fields (non-nullable in most models -> give defaults)
      userKey: _s(json['userKey']),
      startDate: _s(json['fromDate'] ?? json['startDate']),
      endDate: _s(json['toDate'] ?? json['endDate']),
      reason: _s(json['reason']),
      leaveType: _s(json['type'] ?? json['leaveType']),

      // If backend doesn’t send numberOfLeaves, default to 0.0
      numberOfLeaves: (json['numberOfLeaves'] is num)
          ? (json['numberOfLeaves'] as num).toDouble()
          : 0.0,

      // Booleans (API uses `ishalfDay` and `isFullDay`)
      isFullDay: (json['isFullDay'] ?? json['isfullDay'] ?? false) as bool,
      isHalfDay: (json['isHalfDay'] ?? json['ishalfDay'] ?? false) as bool,

      // Status / metadata
      leaveStatus: _sOrNull(json['status'] ?? json['leaveStatus']),
      actionDate: _sOrNull(json['appliedAt'] ?? json['actionDate']),
      approverByName: _sOrNull(json['approverByName']),
      approverByKey: _sOrNull(json['approverByKey']),
    );
  }

  // --- Method for toJson ---

  // Includes all fields, even the optional ones, for saving/updating the object.
  Map<String, dynamic> toJson() {
    return {
      // Optional database/backend fields
      if (key != null) 'key': key,
      if (id != null) 'id': id,
      if (rev != null) 'rev': rev,

      // Core Request fields
      'userKey': userKey,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'leaveType': leaveType,
      'numberOfLeaves': numberOfLeaves,
      'isFullDay': isFullDay,
      'isHalfDay': isHalfDay,

      // Status/Approval fields - only include if not null
      if (leaveStatus != null) 'leaveStatus': leaveStatus,
      if (actionDate != null) 'actionDate': actionDate,
      if (approverByName != null) 'approverByName': approverByName,
      if (approverByKey != null) 'approverByKey': approverByKey,
    };
  }
}