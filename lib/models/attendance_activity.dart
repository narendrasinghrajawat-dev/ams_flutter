import 'package:attedance_management_system/models/device_info.dart'; // Ensure correct path to DeviceInfo

class AttendanceActivity {
  // Document Metadata (Metadata is often nullable/optional from a client perspective)
  final String? key;
  final String? id;
  final String? rev;

  // Core Required Field
  final String userKey;

  // Optional Fields (Made nullable with '?')
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
    required this.userKey, // Still required
    this.punchType, // Now optional
    this.punchTime, // Now optional
    this.punchDate, // Now optional
    this.lat,       // Now optional
    this.long,      // Now optional
    this.createdDate, // Optional
    this.deviceInfo,  // Now optional
  });

  // 2. fromJson() Method (Handles null values from the server)
  /// Creates an AttendanceActivity object from a JSON map.
  factory AttendanceActivity.fromJson(Map<String, dynamic> json) {
    // Note: Use 'as String?' for nullable String fields
    // Use the null-aware spread operator or conditional logic for nested objects

    DeviceInfo? info;
    if (json['deviceInfo'] != null) {
      info = DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>);
    }

    return AttendanceActivity(
      key: json['_key'] as String?,
      id: json['_id'] as String?,
      rev: json['_rev'] as String?,

      // We assume userKey is always present (not marked with '?')
      userKey: json['userKey'] as String,

      // Optional fields
      punchType: json['punchType'] as String?,
      punchTime: json['punchTime'] as String?,
      punchDate: json['punchDate'] as String?,
      lat: json['lat'] as String?,
      long: json['long'] as String?,
      createdDate: json['createdDate'] as String?,

      deviceInfo: info, // Assigned the potentially null DeviceInfo object
    );
  }

  // 3. toJson() Method (For serializing to JSON)
  /// Converts the AttendanceActivity object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      "userKey": userKey,

      // We use the null-aware spread operator 'if (fieldName != null)'
      // or a simple check to only include fields if they are not null.

      if (punchType != null) "punchType": punchType,
      if (punchTime != null) "punchTime": punchTime,
      if (punchDate != null) "punchDate": punchDate,
      if (lat != null) "lat": lat,
      if (long != null) "long": long,

      // For the nested object, only include it if it's not null,
      // and call its toJson() method.
      if (deviceInfo != null) "deviceInfo": deviceInfo!.toJson(),

      // Metadata (Optional in requests)
      if (key != null) "_key": key,
      if (id != null) "_id": id,
      if (rev != null) "_rev": rev,
      if (createdDate != null) "createdDate": createdDate,
    };
  }
}