class User {
  final String username;
  final String fullName;
  final String role;
  final String? email;
  final String? phone;

  User({
    required this.username,
    required this.fullName,
    required this.role,
    this.email,
    this.phone,
  });

  User copyWith({
    String? username,
    String? fullName,
    String? role,
    String? email,
    String? phone,
  }) {
    return User(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
