import 'package:uni_pulse/Models/events.dart'; 

// Model class to represent a user's account data
class AccountData {
  final String email;               // User's email address
  final bool isOrganisation;       // Indicates if the user is an organization
  final String firstName;          // First name of the user
  final String lastName;           // Last name of the user
  final int phoneNum;              // User's phone number
  final String userName;           // Unique username
  final DateTime? dob;             // Date of birth (nullable)
  List<EventData> favouriteEvents; // List of user's favorite events

  // Constructor for AccountData
  AccountData({
    required this.email,
    required this.isOrganisation,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.userName,
    required this.dob,
    required this.favouriteEvents,
  });

  // Converts AccountData to a Map<String, dynamic> for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'isOrganisation': isOrganisation,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNum': phoneNum,
      'dob': dob?.toIso8601String() ?? '', // Safely convert DateTime to String
      'favouriteEvents': favouriteEvents.map((event) => event.toMap()).toList(), // Convert list of EventData to list of maps
      'username': userName,
    };
  }

  // Factory constructor to create AccountData from a Firebase map
  factory AccountData.fromMap(Map<String, dynamic> map) {
    return AccountData(
      email: map['email'],
      isOrganisation: map['isOrganisation'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNum: map['phoneNum'],
      dob: DateTime.parse(map['dob']), // Convert stored string back to DateTime
      favouriteEvents: (map['favouriteEvents'] as List)
          .map((event) => EventData.fromMap(event))
          .toList(), // Convert list of maps to list of EventData
      userName: map['username'] ?? '', // Provide default empty string if username is missing
    );
  }
}
