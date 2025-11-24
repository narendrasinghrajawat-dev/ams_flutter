import 'package:attedance_management_system/models/device_info.dart';

class Login {
  final String email;
  final String password;
  final double lat;
  final double long;
  final DeviceInfo deviceInformation;

  // 1. Constructor
  Login({
    required this.email,
    required this.password,
    required this.lat,
    required this.long,
    required this.deviceInformation,
  });

  // 2. toJson() Method for API Requests
  /// Converts the Login object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "lat": lat,
      "long": long,
      "deviceInformation": deviceInformation.toJson(), // Call toJson on the nested object
    };
  }

  // 3. fromJson() Method (Optional but good practice for handling API responses)
  /// Creates a Login object from a JSON map.
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'] as String,
      password: json['password'] as String,
      lat: json['lat'] as double,
      long: json['long'] as double,
      deviceInformation: DeviceInfo.fromJson(json['deviceInformation'] as Map<String, dynamic>),
    );
  }
}