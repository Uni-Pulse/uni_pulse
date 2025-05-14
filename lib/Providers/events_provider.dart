
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
import 'package:uni_pulse/Models/acconts.dart';
import 'package:uni_pulse/Models/events.dart';  
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
 // Import for firstWhereOrNull
import 'package:firebase_auth/firebase_auth.dart';


class EventNotifier extends StateNotifier<List<EventData>> {
  EventNotifier() : super(const []);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

     Future<void> deleteEvent(EventData event) async {
    try {
      // Delete the event from Firestore
      final eventDoc = await firestore
          .collection('events')
          .where('eventName', isEqualTo: event.eventName)
          .where('date', isEqualTo: event.date)
          .limit(1)
          .get();

      if (eventDoc.docs.isNotEmpty) {
        await firestore.collection('events').doc(eventDoc.docs.first.id).delete();
      }

      // Update the local state
      state = state.where((e) => e != event).toList();
    } catch (e) {
      debugPrint('Error deleting event: $e');
    }
  }
    // Add an event to Firestore and update the state
Future<String> addEvent(
  String eventName, 
  String organisation, 
  DateTime date, 
  String ticketPrice,
  EventType eventType,
  String description) async {
  
  // final appDir = await syspaths.getApplicationDocumentsDirectory();
  // final filename = path.basename(image.path);
  // final copiedImage = await image.copy('${appDir.path}/$filename');

  try {

    // Save the event to Firestore
    DocumentReference docRef = await firestore.collection('events').add({
      'eventName': eventName,
      'organisation': organisation,
      'date': date.toIso8601String(),
      'ticketPrice': ticketPrice,
      'eventType': eventType.name,
      'description' : description
    });

    // Get the generated document ID
    String eventId = docRef.id;
    debugPrint('New Event added with ID: $eventId');

    // Create a new event object
    final newEvent = EventData(
      eventName: eventName,
      organisation: organisation,
      date: date,
      ticketPrice: ticketPrice,
      eventType: eventType,
      description: description,
      eventId: eventId
    );
    debugPrint('New event added with ID: $eventId');

    //update the local state

    // await firestore.collection('events').add({
    //   'eventName': eventName,
    //   'organisation': organisation,
    //   'date': date.toIso8601String(),
    //   'ticketPrice': ticketPrice,
    //   'eventType': eventType.name,
    //   'desription' : description// Assuming EventType has a 'name' property
    // });

    state = [newEvent, ...state];
    return eventId; // Return the event ID
  } catch (e) {
    debugPrint('Error adding event: $e');
    rethrow;
  }
}

 // Fetch events from Firestore and update the state
  Future<void> fetchEvents() async {
    try {
      final querySnapshot = await firestore.collection('events').get();
      final events = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return EventData(
          
          eventName: data['eventName'] as String,
          organisation: data['organisation'] as String, 
          date: DateTime.parse(data['date'] as String),
          ticketPrice: data['ticketPrice'] ,
          eventType: EventType.values.firstWhere((e) => e.name == data['eventType'] as String), // Adjust based on your EventType enum
          description: data['description'] as String, // Assuming description is stored in Firestore
          eventId: doc.id, // Use the document ID as the event ID
        );
      }).toList();

      state = events;
    } catch (e) {
      debugPrint('Error fetching events: $e');
    }
  }
}

// <> used to add extra type annotation, knows what type it will be expecting
final eventsProvider =
    StateNotifierProvider<EventNotifier, List<EventData>>(
  (ref) => EventNotifier(),
);






class AccountNotifier extends StateNotifier<List<AccountData>> {
  AccountNotifier() : super([AccountData(userName: 'user', firstName: 'user',lastName: '', email: 'user', isOrganisation: false, phoneNum: 54321, dob: DateTime(2005,05,12)),
    AccountData(userName: 'org',firstName: 'org',lastName: '', email: 'org', isOrganisation: true, phoneNum: 54321, dob: DateTime(2005,05,12)),]);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNum,
    required bool isOrganisation,
    required String userName,
  }) async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's data in Firestore
      await firestore.collection('users').doc(userId).update({
        'userName': userName, // Assuming userName is the same as email
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNum': int.parse(phoneNum), // Assuming phoneNum is stored as an int
        'isOrganisation': isOrganisation,
      });

      // Update the local state for the current user
      if (currentUser != null) {
        currentUser = AccountData(
          userName: currentUser!.userName, // Keep the existing username
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNum: int.parse(phoneNum),
          isOrganisation: isOrganisation,
          dob: currentUser!.dob, // Keep the existing DOB
        );
      }
      
      // Notify listeners by updating the state
      state = state.map((user) {
        if (user.email == email) {
          return currentUser!;
        }
        return user;
      }).toList();
    } catch (e) {
      debugPrint('Error updating user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  AccountData? currentUser; // To store the currently logged-in user
  Future<AccountData?> authenticate(String email, String password) async {
  try {
    // Authenticate the user with Firebase Authentication
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String? uid = userCredential.user?.uid;

    // Check if the UID actually was gotten
    if (uid == null) {
      debugPrint('Error: User ID is null after successful login.');
      return null;
    }

    // Fetch the user's details from Firestore
    final userDoc = await firestore.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      final data = userDoc.data()!;
      final loggedInUser = AccountData(
        email: data['email'] as String,
        userName: data['username'] as String,
        isOrganisation: data['isOrganisation'] as bool? ?? false,
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        phoneNum: data['phoneNum'] as int,
        dob: DateTime.parse(data['dob'] as String),
      );

      currentUser = loggedInUser;
      return loggedInUser; // Return the logged-in user's details
    } else {
    // Try organisations collection
    final orgDoc = await firestore.collection('organisations').doc(uid).get();
    if (orgDoc.exists && orgDoc.data() != null) {
      final data = orgDoc.data()!;
      final loggedInOrg = AccountData(
        email: data['email'] as String,
        userName: data['username'] as String,
        isOrganisation: true,
        firstName: data['orgName'] as String,
        lastName: '',
        phoneNum: data['phoneNumber'] as int,
        dob: null,
      );
      currentUser = loggedInOrg;
      return loggedInOrg;}
      else {
      debugPrint('No user or organisation details found in Firestore for UID: $uid');
      return null;
    }
}
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      debugPrint('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      debugPrint('Wrong password provided.');
    }else if (e.code == 'user-diabled'){
      debugPrint('User account is disabled.');
    } 
    else {
      debugPrint('FirebaseAuthException: ${e.message}');
    }
    return null;
  } catch (e) {
    debugPrint('Error during authentication: $e');
    return null;
  }
}

  // Add a new user account to Firestore
  Future<String?> registerUser(
    String firstName, 
    String lastName, 
    String phoneNumber,
    String email, 
    String password, 
    DateTime dob, 
    bool isOrganisation,
    String userName) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String? uid = userCredential.user?.uid;

      if (uid == null) {
        debugPrint('Error: User ID is null after registration.');
        return 'An unexpected error occured: UID not fouund';
      }
      // if authentication succeeds, create a new user account
      final newAccount = AccountData(


        firstName: firstName,
        lastName: lastName,
        userName: userName, // Pass the userName parameter here
        phoneNum: int.parse(phoneNumber),
        email: email,
        // password: password,
        dob: dob,
        isOrganisation: isOrganisation,
      );

      // Save the account to Firestore
      await firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNum': int.parse(phoneNumber),
        'email': email,
        'dob': dob.toIso8601String(),
        'isOrganisation': isOrganisation,
        'uid': uid,
        'username': userName,
         // Store date as a string in ISO format
      });

      // Update the local state
      state = [newAccount, ...state];
      return null; // Return null if registration is successful
    } on FirebaseAuthException catch (e){
      debugPrint('FirebaseAuthException during registeration: ${e.code}');
      String errorMessage;
      if (e.code == 'email-already-in-use'){
        errorMessage = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else {
        errorMessage = 'Authentication error: ${e.message}';
      }
      return errorMessage; // Return the error message if registration fails
    }catch (e) {
      debugPrint('Genereal error during registration: $e');
      return 'An unexpected error occurred: $e'; // Return a generic error message
    }
  }


    // Fetch all user accounts from Firestore
  Future<void> fetchUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        debugPrint('Fetched user: $data');
        return AccountData(
          userName: data['username'] as String? ?? '', // Assuming username is stored in Firestore
          email: data['email'] as String? ?? '',
          // password: data['password'] as String,
          isOrganisation: data['isOrganisation'] as bool? ?? false,
          firstName: data['firstName'] as String? ?? '',
          lastName: data['lastName'] as String? ?? '',
          phoneNum: data['phoneNum'] as int? ?? 0,
          dob: data['dob'] != null ? DateTime.tryParse(data['dob']) : null,);
      }).toList();

      state = users;
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  Future<String?> registerOrganisation({
  required String orgName,
  required String email,
  required String password,
  required String phoneNumber,
  required String userName,
}) async {
  try {
    // Create a new user in Firebase Authentication
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save the organisation data to Firestore
    await firestore.collection('organisations').doc(userCredential.user!.uid).set({
      'orgName': orgName,
      'username': userName,
      'email': email,
      'phoneNumber': int.parse(phoneNumber),
      'isOrganisation': true,
      'createdAt': FieldValue.serverTimestamp(),
      // Add more organisation-specific fields here if needed
    });

    return null; // Success, no error
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return 'The email address is already in use.';
    } else if (e.code == 'weak-password') {
      return 'The password is too weak.';
    } else {
      return e.message;
    }
  } catch (e) {
    return 'An unexpected error occurred: $e';
  }
}

  // Fetch all organisations from Firestore
  Future<List<AccountData>> fetchOrganisations() async {
    try {
      final querySnapshot = await firestore.collection('organisations').get();
      final organisations = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return AccountData(
          userName: data['username'] as String,
          email: data['email'] as String,
          isOrganisation: true,
          firstName: data['orgName'] as String,
          lastName: '', // Assuming no last name for organisations
          phoneNum: data['phoneNumber'] as int,
          dob:  null, // Assuming no DOB for organisations
        );
      }).toList();

      return organisations;
    } catch (e) {
      debugPrint('Error fetching organisations: $e');
      return [];
    }
  }
}


//   void addAccount(AccountData account) {
//     state = [account, ...state];
//   }
// }

 final accountsProvider = 
    StateNotifierProvider<AccountNotifier, List<AccountData>>(
  (ref) => AccountNotifier(),
);