

import 'package:attedance_management_system/data/utils/app_json_helper.dart';


// --- 3. MasterData (Main Model for the Entire Response) ---
class MasterData {
  // Database fields
  final String? key;
  final String? id;
  final String? rev;

  // Configuration lists
  final List<MasterDataItem> leaveStatus;
  final List<MasterDataItem> leaveDurationsType;
  final List<MasterDataItem> leaveType;
  final List<MasterDataItem> halfDayShiftType;
  final List<MasterDataItem> role;
  final List<MasterDataItem> gender;

  final String? officeLat;
  final String? officeLong;
  final int? officeRadius;

  final int? maxWFHInSingleMonth;

  MasterData({
    this.key,
    this.id,
    this.rev,
    required this.leaveStatus,
    required this.leaveDurationsType,
    required this.halfDayShiftType,
    required this.leaveType,
    required this.role,
    required this.gender,

    this.officeLat,
    this.officeLong,
    this.officeRadius,
    this.maxWFHInSingleMonth,
  });

  factory MasterData.fromJson(Map<String, dynamic> json) {

    print('master json si the $json');

    // Helper function to safely parse a list of maps into a List<MasterDataItem>
    List<MasterDataItem> _parseList(dynamic listData) {
      if (listData is List) {
        return listData
            .map((itemJson) => MasterDataItem.fromJson(itemJson))
            .toList();
      }
      return []; // Return an empty list if data is null or not a List
    }

    return MasterData(
      // Optional database fields
      key: AppJsonHelper.safeNullableString(json['_key'] ?? json['key']),
      id: AppJsonHelper.safeNullableString(json['_id'] ?? json['id']),
      rev: AppJsonHelper.safeNullableString(json['_rev'] ?? json['rev']),
      officeLat: AppJsonHelper.safeNullableString(json['officeLat'] ?? json['officeLat']),
      officeLong: AppJsonHelper.safeNullableString(json['officeLong'] ?? json['officeLong']),
      officeRadius: AppJsonHelper.safeNullableInt(json['officeRadius'] ?? json['officeRadius']),


      // Parsing the nested lists
      leaveStatus: _parseList(json['leaveStatus']),
      leaveDurationsType: _parseList(json['leaveDurationsType']),
      halfDayShiftType: _parseList(json['halfDayShiftType']),

      leaveType: _parseList(json['leaveType']),
      role: _parseList(json['role']),
      gender: _parseList(json['gender']),
      maxWFHInSingleMonth : AppJsonHelper.safeNullableInt(json['maxWFHInSingleMonth']),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Database fields (optional)
      if (key != null) '_key': key,
      if (id != null) '_id': id,
      if (rev != null) '_rev': rev,
      // Configuration lists (converting item models back to JSON maps)
      'leaveStatus': leaveStatus.map((item) => item.toJson()).toList(),
      'leaveDurationsType': leaveDurationsType.map((item) => item.toJson()).toList(),
      'halfDayShiftType': halfDayShiftType.map((item) => item.toJson()).toList(),
      'leaveType': leaveType.map((item) => item.toJson()).toList(),
      'role': role.map((item) => item.toJson()).toList(),
      'gender': gender.map((item) => item.toJson()).toList(),

      'officeLat': officeLat,
      'officeLong': officeLong,
      'officeRadius': officeRadius,


    };
  }
}

class MasterDataItem {
  final String id;
  final String name;

  MasterDataItem({required this.id, required this.name});

  factory MasterDataItem.fromJson(Map<String, dynamic> json) {
    return MasterDataItem(
      // Use safeString to convert potentially non-string IDs (like int) to String
      id: AppJsonHelper.safeString(json['id']),
      name: AppJsonHelper.safeString(json['name']),
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
    };
}
