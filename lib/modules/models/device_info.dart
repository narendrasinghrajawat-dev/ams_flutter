



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
      os: json["os"] ?? "",
      version: json["version"] ?? "",
      sdkInt: json["sdkInt"] ?? 0,
      model: json["model"] ?? "",
      brand: json["brand"] ?? "",
      device: json["device"] ?? "",
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