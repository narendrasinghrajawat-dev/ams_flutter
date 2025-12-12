class LeaveBalance {
  // Fields to match the JSON keys
  final String id;
  final String name;
  final int balance;
  final int total;

  // Constructor
  LeaveBalance({
    required this.id,
    required this.name,
    required this.balance,
    required this.total,

  });

  // Factory method to create a LeaveBalance object from a JSON map
  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      id: json['id'] as String,
      name: json['name'] as String,
      // Ensure 'balance' is parsed as an integer. It might be a double
      // in some JSONs, so using toInt() is safer if the source allows it.
      balance: (json['balance'] as num).toInt(),
      total: (json['total'] as num).toInt(),

    );
  }

  // Optional: Method to convert the object back to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'total' : total,
    };
  }
}