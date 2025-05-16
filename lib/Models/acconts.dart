import 'package:uni_pulse/Models/events.dart'; 


class AccountData {
  final String email;
  // final String password; // Added password field
  final bool isOrganisation;
  final String firstName;
  final String lastName;
  final int phoneNum;
  final String userName;
  final DateTime? dob; 
  List<EventData> favouriteEvents;// Added dob field
  // final String? profileImage; // Added profileImageUrl field


  AccountData({
    required this.email,
    // required this.password, // Added password to constructor
    required this.isOrganisation,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.userName,
    required this.dob, // Added dob to constructor
    required this.favouriteEvents,
    // this.profileImage = '', // Added profileImageUrl to constructor
  });


  //converting account data so compatible with firebase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'isOrganisation': isOrganisation,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNum': phoneNum,
      'dob': dob?.toIso8601String() ?? '', // Convert DateTime to String or use an empty string if null
      'favouriteEvents': favouriteEvents.map((event)=> event.toMap()).toList(),
      'username' : userName,
      // 'profileImage': profileImage ?? '', // Added profileImageUrl to map
    };
  }

  factory AccountData.fromMap(Map<String, dynamic> map) {
    return AccountData(
      email: map['email'],
      isOrganisation: map['isOrganisation'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNum: map['phoneNum'],
      dob: DateTime.parse(map['dob']), // Convert String back to DateTime
      favouriteEvents: (map['favouriteEvents'] as List)
          .map((event) => EventData.fromMap(event))
          .toList(),
      userName: map['username'] ?? '', // Added username field
      // profileImage: map['profileImage'] ?? '', // Added profileImageUrl field
    );
  }
}

