class User {
  final String username;
  final String fullName;
  final String role;
  final String? email;
  final String? phone;

  User({required this.username, required this.fullName, required this.role, this.email, this.phone});

  Map<String, dynamic> toMap() => {
    'username': username, 'fullName': fullName, 'role': role, 'email': email, 'phone': phone,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    username: map['username'] ?? '',
    fullName: map['fullName'] ?? '',
    role: map['role'] ?? 'user',
    email: map['email'],
    phone: map['phone'],
  );
}
