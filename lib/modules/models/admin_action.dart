
class AdminAction {
  // Fields based on the request body (AdminLeaveActionDto)
  final String leavesId;
  final String leavesStatus;
  final String approveByKey;

  // Optional fields that may be returned in the response or used internally
  final String? actionDate;
  final String? approverByName;

  AdminAction({
    required this.leavesId,
    required this.leavesStatus,
    required this.approveByKey,
    this.actionDate,
    this.approverByName,
  });

  /// Factory constructor to create an AdminAction instance from a JSON map
  /// (e.g., when reading the approved/rejected document from the database response).
  factory AdminAction.fromJson(Map<String, dynamic> json) {
    return AdminAction(
      // The leavesId corresponds to the document's _key or similar unique ID
      leavesId: json['leavesId'] as String? ?? json['_key'] as String,
      leavesStatus: json['leavesStatus'] as String,
      approveByKey: json['approveByKey'] as String,
      actionDate: json['actionDate'] as String?,
      approverByName: json['approverByName'] as String?,
    );
  }

  /// Helper method to convert the object back to a JSON map
  /// (e.g., for sending to the API).
  Map<String, dynamic> toJson() {
    return {
      'leavesId': leavesId,
      'leavesStatus': leavesStatus,
      'approveByKey': approveByKey,
      // Include optional fields only if they have values
      if (actionDate != null) 'actionDate': actionDate,
      if (approverByName != null) 'approverByName': approverByName,
    };
  }
}