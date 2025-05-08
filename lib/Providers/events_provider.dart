
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
  
    // Add an event to Firestore and update the state
  Future<void> addEvent(
    String eventName, 
    Organisations organisation, 
    DateTime date, 
    double ticketPrice) async {
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final filename = path.basename(image.path);
    // final copiedImage = await image.copy('${appDir.path}/$filename');

    try {

      // Create a new event object
      final newEvent = EventData(
        eventName: eventName,
        organisation: organisation,
        date: date,
        ticketPrice: ticketPrice,
      );

      // Save the event to Firestore
      await firestore.collection('events').add({
        'eventName': eventName,
        'organisation': organisation.name, // Assuming Organisations has a 'name' property
        'date': date.toIso8601String(),
        'ticketPrice': ticketPrice,
      });

    state = [newEvent, ...state];
  } catch (e) {
      debugPrint('Error adding event: $e');
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
          organisation: Organisations.values.firstWhere((e) => e.name == data['organisation'] as String), // Adjust based on your Organisations enum
          date: DateTime.parse(data['date'] as String),
          ticketPrice: data['ticketPrice'] as double,
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
  AccountNotifier() : super([AccountData(firstName: 'user',lastName: '', email: 'user', isOrganisation: false, phoneNum: 54321, dob: DateTime(2005,05,12)),
    AccountData(firstName: 'org',lastName: '', email: 'org', isOrganisation: true, phoneNum: 54321, dob: DateTime(2005,05,12)),]);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      return AccountData(
        email: data['email'] as String,
        // password: data['password'] as String,
        isOrganisation: data['isOrganisation'] as bool,
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        phoneNum: data['phoneNum'] as int,
        dob: DateTime.parse(data['dob'] as String),
      );
    } else {
      debugPrint('No user details documents found in Firsetore for UID: $uid');
      return null;
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
    bool isOrganisation) async {
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
        phoneNum: int.parse(phoneNumber), // Assuming phone number is stored as an int
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
          email: data['email'] as String,
          // password: data['password'] as String,
          isOrganisation: data['isOrganisation'] as bool,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          phoneNum: data['phoneNum'] as int,
          dob: DateTime.parse(data['dob'] as String), // Assuming dob is stored as a string in ISO format
        );
      }).toList();

      state = users;
    } catch (e) {
      debugPrint('Error fetching users: $e');
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