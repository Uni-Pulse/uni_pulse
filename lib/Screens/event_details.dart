import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:uni_pulse/Screens/users/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});

  final EventData event;
  // add a constructipor to show deleye button for only the event owner
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: Text('Event Details')),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              event.eventName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              event.description,
              style: const TextStyle(fontSize: 16),
            ),   //Event description might needs saving in the database
            const SizedBox(height: 10),
            Text(
              'Date: ${event.date}',
              style: const TextStyle(fontSize: 16),
            ),


            const SizedBox(height: 10),
            Text(
              'Ticket Price: ${event.ticketPrice}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Event Type: ${event.eventType}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Organisation: ${event.organisation}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            

            ElevatedButton(
              onPressed: () async{
                final currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
              // Fetch additional user details from Firestore
                  final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .get();

                  String username;
                  bool isOrganisation;

                  if (userDoc.exists && userDoc.data() != null) {
                   final userData = userDoc.data()!;
                   username = (userData['username'] as String?) ?? 'Unknown User';
                   isOrganisation = (userData['isOrganisation'] as bool?) ?? false;
                  }else{
                    debugPrint('Firestore document for user ${currentUser.uid} not found');
                    username = 'Unknown User';
                    isOrganisation = false;
                  }

              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(
                eventTitle: event.eventName, 
                eventId: event.eventId, 
                username: username, // Replace with the actual username
                isOrganisation: isOrganisation, // Replace with the actual value
              ),),);
                }else{
                  debugPrint('No user is currently logged in.');
                }
              },
              child: const Text('Open Room'),
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                

                // Text([type.name, ':', Icons.cabin_outlined].toString()),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                // Text([type.name, ':', Icons.cabin_outlined].toString()),
              ],
            ),
         

            
          ],
        ));
  }
}
