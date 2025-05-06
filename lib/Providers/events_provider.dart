


import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
import 'package:uni_pulse/Models/acconts.dart';
import 'package:uni_pulse/Models/events.dart';  
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventNotifier extends StateNotifier<List<EventData>> {
  EventNotifier() : super(const []);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
    // Add an event to Firestore and update the state
  Future<void> addEvent(String eventName, Organisations organisation, DateTime date, double ticketPrice) async {
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
  AccountNotifier() : super(const []);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Add a new user account to Firestore
  Future<void> registerUser(String firstName, String lastName, String phoneNumber,String email, String password, DateTime dob, bool isOrganisation) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create a new account object
      final newAccount = AccountData(



        firstName: firstName,
        lastName: lastName,
        phoneNum: int.parse(phoneNumber), // Assuming phone number
        email: email,
        password: password,
        dob: dob,
        isOrganisation: isOrganisation,
      );

      // Save the account to Firestore
      await firestore.collection('users').add({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNum': int.parse(phoneNumber),
        'email': email,
        'password': password, // Note: Storing plain text passwords is insecure. Use hashing instead.
        'dob': dob.toIso8601String(),
        'isOrganisation': isOrganisation,
         // Store date as a string in ISO format
      });

      // Update the local state
      state = [newAccount, ...state];
    } on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use'){
        debugPrint('Email already in use. Please use a different email.');
      } else if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        debugPrint('The email address is not valid.');
      } else {
        debugPrint('Error registering user: ${e.message}');
      }
    }catch (e) {
      debugPrint('Error registering user: $e');
    }
  }

    // Fetch all user accounts from Firestore
  Future<void> fetchUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        debugPrint('Fetched user data: $data'); // Debug print to check fetched data
        return AccountData(
          email: data['email'] as String,
          password: data['password'] as String,
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