
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'user'
  final String? deptId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.deptId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'user',
    deptId: json['dept_id']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'dept_id': deptId,
  };
}
