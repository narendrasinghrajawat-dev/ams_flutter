class DeviceInfo {
  // ---- Common ----
  final String? os;
  final String? uniqueId;
  final bool? isPhysicalDevice;

  // ---- Android ----
  final String? version;
  final int? sdkInt;
  final String? model;
  final String? brand;
  final String? manufacturer;
  final String? device;
  final String? androidId;
  final String? fingerprint;

  // ---- iOS ----
  final String? identifierForVendor;

  // ---- Web ----
  final String? browserName;
  final String? appVersion;
  final String? userAgent;
  final String? platform;
  final String? vendor;
  final String? language;

  DeviceInfo({
    this.os,
    this.uniqueId,
    this.isPhysicalDevice,

    // Android
    this.version,
    this.sdkInt,
    this.model,
    this.brand,
    this.manufacturer,
    this.device,
    this.androidId,
    this.fingerprint,

    // iOS
    this.identifierForVendor,

    // Web
    this.browserName,
    this.appVersion,
    this.userAgent,
    this.platform,
    this.vendor,
    this.language,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      // Common
      os: json["os"],
      uniqueId: json["uniqueId"],
      isPhysicalDevice: json["isPhysicalDevice"] is bool
          ? json["isPhysicalDevice"]
          : false,

      // Android
      version: json["version"],
      sdkInt: json["sdkInt"] is int ? json["sdkInt"] : null,
      model: json["model"],
      brand: json["brand"],
      manufacturer: json["manufacturer"],
      device: json["device"],
      androidId: json["androidId"],
      fingerprint: json["fingerprint"],

      // iOS
      identifierForVendor: json["identifierForVendor"],

      // Web
      browserName: json["browserName"],
      appVersion: json["appVersion"],
      userAgent: json["userAgent"],
      platform: json["platform"],
      vendor: json["vendor"],
      language: json["language"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Common
      "os": os,
      "uniqueId": uniqueId,
      "isPhysicalDevice": isPhysicalDevice,

      // Android
      "version": version,
      "sdkInt": sdkInt,
      "model": model,
      "brand": brand,
      "manufacturer": manufacturer,
      "device": device,
      "androidId": androidId,
      "fingerprint": fingerprint,

      // iOS
      "identifierForVendor": identifierForVendor,

      // Web
      "browserName": browserName,
      "appVersion": appVersion,
      "userAgent": userAgent,
      "platform": platform,
      "vendor": vendor,
      "language": language,
    };
  }
}
