
import 'address.dart';

class User {
  final String? key; // Renamed to 'key' to follow Dart conventions
  final String? rev; // Renamed to 'rev'
  final String? id; // This might conflict with Firestore 'id', kept for this structure
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNo;
  final String username;
  final String dob;
  final String? genderId;
  final String? departmentId;
  final String? roleId;
  final String password;
  final String? profileImageS3Key;
  final String? profileImageNetworkKey;
  final String? address;
  final String? createdAt;
  final String? joinedDate;
  final String? employeeId;

  User({
    this.key,
    this.rev,
    this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNo,
    required this.username,
    required this.dob,
    this.genderId,
    this.departmentId,
    this.roleId,
    required this.password,
    this.address,
    this.profileImageS3Key,
    this.profileImageNetworkKey,
    this.createdAt,
    this.joinedDate,
    this.employeeId,
  });

  factory User.empty() => User.fromJson({});

  /// Factory method to create a [User] object from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {

    print('user from json si the $json');

    return User(
      // Database fields (using original JSON keys for mapping)
      key: json['_key'] ?? "",
      rev: json['_rev'] ?? "",
      id: json['id'] ?? "",

      firstName: json['firstName'] ?? "",
      middleName: json['middleName'] ?? "",
      lastName: json['lastName'] ?? "",
      email: json['email'] ?? "",
      countryCode: json['countryCode'] ?? "",
      phoneNo: json['phoneNo'] ?? "",
      username: json['username'] ?? "",
      dob: json['dob'] ?? "",
      genderId: json['genderId'] ?? "",
      departmentId: json['departmentId'] ?? "",
      roleId: json['roleId'] ?? "",
      password: json['password'] ?? "",
      profileImageS3Key: json['profileImageS3Key'] ?? "",
      profileImageNetworkKey: json['profileImageNetworkKey'] ?? "",

      // Nested model instantiation
      address: json['address'],
      joinedDate: json['joinedDate'] ?? "",
      createdAt: json['createdAt'] ?? "",
      employeeId : json['employeeId'],


    );
  }

  /// Converts the [User] object back into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      // Database fields (using original JSON keys for output)
      '_key': key,
      '_rev': rev,
      'id': id,

      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'countryCode': countryCode,
      'phoneNo': phoneNo,
      'username': username,
      'dob': dob,
      'genderId': genderId,
      'departmentId': departmentId,
      'roleId': roleId,
      "password" : password,
      // Converts the nested Address object to JSON
      'address': address,
      "createdAt" : createdAt,
      "joinedDate" : joinedDate,

    };
  }
}