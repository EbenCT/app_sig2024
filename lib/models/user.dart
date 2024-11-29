class User {
  final String status;
  final String role;
  final int userId;
  final int companyId;

  User({
    required this.status,
    required this.role,
    required this.userId,
    required this.companyId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'],
      role: json['role'],
      userId: int.parse(json['userId']),
      companyId: int.parse(json['companyId']),
    );
  }
}
