
import 'dart:io';


import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
import 'package:uni_pulse/Models/acconts.dart';
import 'package:uni_pulse/Models/events.dart';  
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';

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

  // Add a new user account to Firestore
  Future<void> registerUser(String email, String password, bool isOrganisation) async {
    try {
      // Create a new account object
      final newAccount = AccountData(
<<<<<<< Updated upstream
=======
        firstName: firstName,
        lastName: lastName,
        phoneNum: int.parse(phoneNumber), // Assuming phone number
>>>>>>> Stashed changes
        email: email,
        password: password,
        isOrganisation: isOrganisation,
      );

      // Save the account to Firestore
      await firestore.collection('users').add({
        'email': email,
        'password': password, // Note: Storing plain text passwords is insecure. Use hashing instead.
        'isOrganisation': isOrganisation,
      });

      // Update the local state
      state = [newAccount, ...state];
    } catch (e) {
      debugPrint('Error registering user: $e');
    }
  }

    // Fetch all user accounts from Firestore
  Future<void> fetchUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return AccountData(
          email: data['email'] as String,
          password: data['password'] as String,
          isOrganisation: data['isOrganisation'] as bool,
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