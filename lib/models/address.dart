
class Address {
  final String street;
  final String cityName;
  final String cityId;
  final String stateName;
  final String stateId;
  final String zipCode;
  final String countryName;
  final String countryId;

  Address({
    required this.street,
    required this.cityName,
    required this.cityId,
    required this.stateName,
    required this.stateId,
    required this.zipCode,
    required this.countryName,
    required this.countryId,
  });

  /// Factory method to create an [Address] object from a JSON map.
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      cityName: json['cityName'] as String,
      cityId: json['cityId'] as String,
      stateName: json['stateName'] as String,
      stateId: json['stateId'] as String,
      zipCode: json['zipCode'] as String,
      countryName: json['countryName'] as String,
      countryId: json['countryId'] as String,
    );
  }

  /// Converts the [Address] object back into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'cityName': cityName,
      'cityId': cityId,
      'stateName': stateName,
      'stateId': stateId,
      'zipCode': zipCode,
      'countryName': countryName,
      'countryId': countryId,
    };
  }
}