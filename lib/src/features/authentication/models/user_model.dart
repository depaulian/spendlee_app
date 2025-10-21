class UserModel {
  final String email;
  final String username;
  final String password;
  final String? firstName;
  final String? lastName;

  /// Constructor
  const UserModel({
    required this.email,
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
  });
}