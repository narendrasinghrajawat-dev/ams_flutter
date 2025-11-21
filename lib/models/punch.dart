class Punch {
  // ArangoDB system fields
  final String? key;   // _key
  final String? id;    // id
  final String? rev;   // _rev

  // Punch details
  final String? userKey;
  final String? punchType;
  final String? punchTime;
  final String? punchDate;
  final String? lat;
  final String? long;
  final DeviceInfo? deviceInformation;

  Punch({
    this.key,
    this.id,
    this.rev,
    this.userKey,
    this.punchType,
    this.punchTime,
    this.punchDate,
    this.lat,
    this.long,
    this.deviceInformation,
  });

  factory Punch.fromJson(Map<String, dynamic> json) {
    return Punch(
      key: json["_key"],
      id: json["id"],
      rev: json["_rev"],

      userKey: json["userKey"],
      punchType: json["punchType"],
      punchTime: json["punchTime"],
      punchDate: json["punchDate"],
      lat: json["lat"],
      long: json["long"],
      deviceInformation: json["deviceInformation"] != null
          ? DeviceInfo.fromJson(json["deviceInformation"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (key != null) "_key": key,
      if (id != null) "id": id,
      if (rev != null) "_rev": rev,

      "userKey": userKey,
      "punchType": punchType,
      "punchTime": punchTime,
      "punchDate": punchDate,
      "lat": lat,
      "long": long,
      "deviceInformation": deviceInformation?.toJson(),
    };
  }
}

class DeviceInfo {
  final String? os;
  final String? version;
  final int? sdkInt;
  final String? model;
  final String? brand;
  final String? device;

  DeviceInfo({
    this.os,
    this.version,
    this.sdkInt,
    this.model,
    this.brand,
    this.device,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      os: json["os"],
      version: json["version"],
      sdkInt: json["sdkInt"],
      model: json["model"],
      brand: json["brand"],
      device: json["device"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "os": os,
      "version": version,
      "sdkInt": sdkInt,
      "model": model,
      "brand": brand,
      "device": device,
    };
  }
}
