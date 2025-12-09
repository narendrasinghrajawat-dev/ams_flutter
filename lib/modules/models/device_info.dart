class DeviceInfo {
  final String? os;
  final String? version;
  final int? sdkInt; // Android Only
  final String? model;
  final String? brand;
  final String? manufacturer; // New: Manufacturer name
  final String? device;

  // --- New Core Fields for Identification & Security ---
  final String? uniqueId; // The best persistent ID available (Android ID or Vendor ID)
  final bool? isPhysicalDevice; // True if it's a real device, not an emulator/simulator

  // --- Platform-Specific IDs (Optional but informative) ---
  final String? androidId; // Android only ID
  final String? fingerprint; // Android only unique build ID
  final String? identifierForVendor; // iOS only unique ID

  DeviceInfo({
    this.os,
    this.version,
    this.sdkInt,
    this.model,
    this.brand,
    this.manufacturer, // Added
    this.device,
    this.uniqueId, // Added
    this.isPhysicalDevice, // Added
    this.androidId, // Added
    this.fingerprint, // Added
    this.identifierForVendor, // Added
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    // Helper to safely cast SDK Int
    final sdkIntValue = json["sdkInt"] is int ? json["sdkInt"] : (json["sdkInt"] ?? 0);

    // Helper to safely cast boolean
    final isPhysicalDeviceValue = json["isPhysicalDevice"] is bool ? json["isPhysicalDevice"] : false;

    return DeviceInfo(
      os: json["os"] ?? "",
      version: json["version"] ?? "",
      sdkInt: sdkIntValue,
      model: json["model"] ?? "",
      brand: json["brand"] ?? "",
      manufacturer: json["manufacturer"] ?? "", // Mapped
      device: json["device"] ?? "",

      uniqueId: json["uniqueId"] ?? "", // Mapped
      isPhysicalDevice: isPhysicalDeviceValue, // Mapped

      androidId: json["androidId"] ?? "", // Mapped
      fingerprint: json["fingerprint"] ?? "", // Mapped
      identifierForVendor: json["identifierForVendor"] ?? "", // Mapped
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "os": os,
      "version": version,
      "sdkInt": sdkInt,
      "model": model,
      "brand": brand,
      "manufacturer": manufacturer,
      "device": device,

      "uniqueId": uniqueId,
      "isPhysicalDevice": isPhysicalDevice,

      "androidId": androidId,
      "fingerprint": fingerprint,
      "identifierForVendor": identifierForVendor,
    };
  }
}