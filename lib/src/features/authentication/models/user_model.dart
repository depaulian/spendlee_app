class UserModel {
  final String? id;
  final String surName;
  final String givenName;
  final String email;
  final String dob;
  final String gender;
  final String phoneNo;
  final String password;

  /// Constructor
  const UserModel(
      {
        this.id,
        required this.email,
        required this.password,
        required this.surName,
        required this.givenName,
        required this.dob,
        required this.gender,
        required this.phoneNo
      });

  toJson() {
    return {
      "Surname": surName,
      "Given Name": givenName,
      "Email": email,
      "Date of Birth": dob,
      "Gender": gender,
      "Phone": phoneNo,
      "Password": password,
    };
  }
}
