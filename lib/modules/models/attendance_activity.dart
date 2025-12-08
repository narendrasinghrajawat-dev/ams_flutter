import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../data/utils/app_json_helper.dart';
import 'device_info.dart';


class AttendanceActivity {
  // Document Metadata (Metadata is often nullable/optional from a client perspective)
  final String? key;
  final String? id;
  final String? rev;

  // Core Required Field
  final String userKey;
  final String? userName; // Added back, often needed for display


  // Optional Fields
  final String? punchType;
  final String? punchTime;
  final String? punchDate;
  final String? lat;
  final String? long;
  final String? createdDate;

  // Optional Nested Object
  final DeviceInfo? deviceInfo;

  // 1. Constructor
  AttendanceActivity({
    this.key,
    this.id,
    this.rev,
    required this.userKey,
    this.userName,
    // Optional fields
    this.punchType,
    this.punchTime,
    this.punchDate,
    this.lat,
    this.long,
    this.createdDate,
    this.deviceInfo,
  });

  // 2. fromJson() Method (Handles null values and uses safe helper)
  /// Creates an AttendanceActivity object from a JSON map.
  factory AttendanceActivity.fromJson(Map<String, dynamic> json) {

    // --- Safe String Parsing using AppJsonHelper ---
    // Handle both '_key' (from DB) and 'key' (potential API response)
    final key = AppJsonHelper.safeNullableString(json['_key'] ?? json['key']);
    final id = AppJsonHelper.safeNullableString(json['_id'] ?? json['id']);
    final rev = AppJsonHelper.safeNullableString(json['_rev'] ?? json['rev']);
    final userKey = AppJsonHelper.safeNullableString(json['userKey']);
    final punchTime = AppJsonHelper.safeNullableString(json['punchTime']);

    // --- Nested Object Parsing ---
    DeviceInfo? info;
    if (json['deviceInfo'] is Map<String, dynamic>) {
      info = DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>);
    }

    return AttendanceActivity(
      key: key,
      id: id,
      rev: rev,

      // Handle null userKey with a fallback if needed, though typically required
      userKey: userKey ?? '',
      userName: AppJsonHelper.safeNullableString(json['userName']),

      // Optional fields
      punchType: AppJsonHelper.safeNullableString(json['punchType']),
      punchTime: punchTime,
      punchDate: AppJsonHelper.safeNullableString(json['punchDate']),
      lat: AppJsonHelper.safeNullableString(json['lat']),
      long: AppJsonHelper.safeNullableString(json['long']),
      createdDate: AppJsonHelper.safeNullableString(json['createdDate']),

      deviceInfo: info,
    );
  }

  // 3. toJson() Method (For serializing to JSON)
  /// Converts the AttendanceActivity object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      "userKey": userKey,

      // Include optional fields only if they are not null
      if (userName != null) "userName": userName,
      if (punchType != null) "punchType": punchType,
      if (punchTime != null) "punchTime": punchTime,
      if (punchDate != null) "punchDate": punchDate,
      if (lat != null) "lat": lat,
      if (long != null) "long": long,

      // Nested object
      if (deviceInfo != null) "deviceInfo": deviceInfo!.toJson(),

      // Metadata (Optional in requests)
      if (key != null) "_key": key,
      if (id != null) "_id": id,
      if (rev != null) "_rev": rev,
      if (createdDate != null) "createdDate": createdDate,

      // We don't typically send computed fields back
    };
  }
}