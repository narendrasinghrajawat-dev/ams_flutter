class Attendance {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? deviceId;

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.deviceId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'].toString(),
    userId: json['user_id'].toString(),
    date: DateTime.parse(json['date']),
    checkIn:
    json['check_in'] != null ? DateTime.parse(json['check_in']) : null,
    checkOut:
    json['check_out'] != null ? DateTime.parse(json['check_out']) : null,
    deviceId: json['device_id']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'date': date.toIso8601String(),
    'check_in': checkIn?.toIso8601String(),
    'check_out': checkOut?.toIso8601String(),
    'device_id': deviceId,
  };
}
