
// class AccountData {
//   const AccountData({
//     required this.firstName,
//     required this.lastName,
//     required this.phoneNum,
//     required this.email,
//     required this.pass,
//   });

//   final String firstName;
//   final String lastName;
//   final int phoneNum;
//   final String email;
//   final String pass;
// }

class AccountData {
  final String email;
  // final String password; // Added password field
  final bool isOrganisation;
  final String firstName;
  final String lastName;
  final int phoneNum;
  final DateTime dob; // Added dob field

  AccountData({
    required this.email,
    // required this.password, // Added password to constructor
    required this.isOrganisation,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.dob, // Added dob to constructor
  });
}