// The main data model for a leave request, using the AppJsonHelper for safe type conversions.

import '../../data/utils/app_json_helper.dart';

class ApplyLeaveRequest {
  // Optional fields for database/backend identification
  final String? key;
  final String? id;
  final String? rev;

  // Required fields for creating a new leave request
  String userKey;
  String? userName;

  String startDate;     // e.g. "2025-11-21"
  String endDate;       // e.g. "2025-11-23"
  String reason;
  String leaveType;     // e.g. "Sick", "Casual"
  double numberOfLeaves;
  String leaveDurationsType; // e.g., "Full Day", "Half Day"
  String? halfDayShiftType; // e.g., "Full Day", "Half Day"

  bool isActive;
  String? modifiedDate;
  String? createdDate;

  // Fields set by the system/approver (optional upon creation, present upon retrieval)
  String? leaveStatus;     // e.g. "Pending", "Approved", "Rejected"
  String? actionDate;      // Date status was set, e.g. "2025-11-23"
  String? approverByName;  // Name of the approver
  String? approverByKey;   // Key/ID of the approver

  // --- Constructor ---

  ApplyLeaveRequest({
    this.key,
    this.id,
    this.rev,
    required this.userKey,
    this.userName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveType,
    required this.numberOfLeaves,
    required this.leaveDurationsType,
    required this.isActive,
     this.modifiedDate,
     this.createdDate,
    this.leaveStatus,
    this.actionDate,
    this.approverByName,
    this.approverByKey,
    this.halfDayShiftType
  });

  // --- Factory Constructor for fromJson ---

  factory ApplyLeaveRequest.fromJson(Map<String, dynamic> json) {
    print('ApplyLeaveRequest json is the $json');

    // Use AppJsonHelper methods for safe and consistent type conversion

    return ApplyLeaveRequest(
      // DB fields - using safeNullableString to allow nulls
      key: AppJsonHelper.safeNullableString(json['_key'] ?? json['key']),
      id: AppJsonHelper.safeNullableString(json['_id'] ?? json['id']),
      rev: AppJsonHelper.safeNullableString(json['_rev'] ?? json['rev']),

      // Core request fields - using safeString or safeDouble
      userKey: AppJsonHelper.safeString(json['userKey']),
      userName: AppJsonHelper.safeString(json['userName']),

      startDate: AppJsonHelper.safeString(json['fromDate'] ?? json['startDate']),
      endDate: AppJsonHelper.safeString(json['toDate'] ?? json['endDate']),
      reason: AppJsonHelper.safeString(json['reason']),
      leaveType: AppJsonHelper.safeString(json['type'] ?? json['leaveType']),

      // Use safeDouble to handle int or string number inputs
      numberOfLeaves: AppJsonHelper.safeDouble(json['numberOfLeaves']),

      // Duration Type
      leaveDurationsType: AppJsonHelper.safeString(
          json['leaveDurationsType'] ?? json['durationType'],
          defaultValue: 'Full Day'),

      // Duration Type
      halfDayShiftType: AppJsonHelper.safeString(json['halfDayShiftType'] ?? json['halfDayShiftType']),

      // System/Metadata fields
      isActive: AppJsonHelper.safeBool(json['isActive']),
      modifiedDate: AppJsonHelper.safeString(json['modifiedDate'], defaultValue: 'N/A'),
      createdDate: AppJsonHelper.safeString(json['createdDate'] ?? json['appliedAt'], defaultValue: 'N/A'),

      // Status / Approval fields - using safeNullableString for optional fields
      leaveStatus: AppJsonHelper.safeNullableString(json['leaveStatus'] ?? json['status']),
      actionDate: AppJsonHelper.safeNullableString(json['actionDate']),
      approverByName: AppJsonHelper.safeNullableString(json['approverByName']),
      approverByKey: AppJsonHelper.safeNullableString(json['approverByKey']),
    );
  }

  // --- Method for toJson ---

  // Includes all fields, even the optional ones, for saving/updating the object.
  Map<String, dynamic> toJson() {

    return {
      // Optional database/backend fields
     'key': key,
     'id': id,
     'rev': rev,

      // Core Request fields
      'userKey': userKey,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'leaveType': leaveType,
      'numberOfLeaves': numberOfLeaves,
      'leaveDurationsType': leaveDurationsType,
      'halfDayShiftType': halfDayShiftType,
      "leaveStatus" : leaveStatus,
      // System/Metadata fields
      'isActive': isActive,
      'modifiedDate': modifiedDate,
      'createdDate': createdDate,
      'actionDate': actionDate,
      'approverByName': approverByName,
      'approverByKey': approverByKey,

    };
  }
}