import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni_pulse/Models/events.dart';
import 'package:uni_pulse/Screens/users/chatroom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_pulse/Providers/events_provider.dart';

// ...existing imports...

class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({super.key, required this.event});

  final EventData event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate =
        DateFormat('EEEE, MMMM d, yyyy – h:mm a').format(event.date);
    final ticketPrice =
        event.ticketPrice == '0' ? 'Free' : '£${event.ticketPrice}';

    Future<Map<String, dynamic>> _getUserOrOrgInfo() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      String username = 'Unknown User';
      bool isOrganisation = false;

      if (currentUser != null) {
        // Try users collection
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data()!;
          username = (userData['username'] as String?) ?? 'Unknown User';
          isOrganisation = (userData['isOrganisation'] as bool?) ?? false;
        } else {
          // Try organisations collection
          final orgDoc = await FirebaseFirestore.instance
              .collection('organisations')
              .doc(currentUser.uid)
              .get();
          if (orgDoc.exists && orgDoc.data() != null) {
            final orgData = orgDoc.data()!;
            username = (orgData['username'] as String?) ?? 'Unknown Organisation';
            isOrganisation = (orgData['isOrganisation'] as bool?) ?? true;
          }
        }
      }
      return {
        'username': username,
        'isOrganisation': isOrganisation,
        'loggedIn': currentUser != null,
      };
    }

    void _joinChatRoom(BuildContext context) async {
      final info = await _getUserOrOrgInfo();
      if (!info['loggedIn']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to join the chatroom.'),
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoom(
            eventTitle: event.eventName,
            eventId: event.eventId,
            username: info['username'],
            isOrganisation: info['isOrganisation'],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text('Event Details', style: Theme.of(context).textTheme.titleLarge),
        elevation: 0,
        actions: [
            IconButton(
              icon: const Icon(Icons.star_border_outlined),
              onPressed: () async {
                try{
                  await ref.read(accountsProvider.notifier).addFavouriteEvent(event);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event added to favourites')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error adding event to favourites')),
                  );
                }
              },
            
            ),
          ],
      ),
      body: Column(
        children: [
          // Hero Banner
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/event_banner.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: Text(
                event.eventName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 700;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description Box (Sidebar)
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                             
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'About This Event',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                     
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    event.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Event Details
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailCard(context, Icons.calendar_today,
                                        'Date & Time', formattedDate),
                                    _buildDetailCard(context, Icons.monetization_on,
                                        'Ticket Price', ticketPrice),
                                    _buildDetailCard(context, Icons.category,
                                        'Event Type', event.eventType.name),
                                    _buildDetailCard(context, Icons.apartment,
                                        'Organisation', event.organisation),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _joinChatRoom(context),
                                        icon: const Icon(
                                            Icons.chat_bubble_outline),
                                        label: const Text('Join Chat Room'),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 14),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Description box in full-width mode for mobile
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(243, 51, 28, 58),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    const Text(
                                      'About This Event',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                     
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      event.description,
                                      style:Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                              _buildDetailCard(context, Icons.calendar_today,
                                  'Date & Time', formattedDate),
                              _buildDetailCard(context, Icons.monetization_on,
                                  'Ticket Price', ticketPrice),
                              _buildDetailCard(context, Icons.category, 'Event Type',
                                  event.eventType.name),
                              _buildDetailCard(context, Icons.apartment, 'Organisation',
                                  event.organisation),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () => _joinChatRoom(context),
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  label:  Text('Join Chat Room', style: Theme.of(context).textTheme.bodyMedium),
                                  style: ElevatedButton.styleFrom(
                                    iconColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
        iconColor: Colors.white,
      ),
    );
  }
}