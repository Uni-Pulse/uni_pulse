import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatelessWidget {
  final String eventTitle; // Title of the event for the chat room
  final String eventId; // Unique ID of the event to fetch the corresponding chat messages
  final TextEditingController _messageController = TextEditingController(); // Controller for the message input
  final String username; // Username of the currently logged-in user
  final bool isOrganisation; // Whether the user is an organisation

  ChatRoom({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.username,
    required this.isOrganisation,
  });

  @override
  Widget build(BuildContext context) {
    // Reference to the messages subcollection under the specific event
    final CollectionReference messages = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('messages');

    // Function to send a message
    void sendMessage() {
      if (_messageController.text.trim().isEmpty) return; // Prevent sending empty messages
      messages.add({
        'text': _messageController.text.trim(), // Message content
        'sender': username,                     // Sender's username
        'isOrganisation': isOrganisation,       // Sender type
        'timestamp': FieldValue.serverTimestamp(), // Server-side timestamp for sorting
      });
      _messageController.clear(); // Clear input after sending
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room: $eventTitle', style: Theme.of(context).textTheme.titleLarge),
        // You can optionally add a logout button here if login is implemented
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messages.orderBy('timestamp', descending: true).snapshots(), // Real-time chat stream
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true, // Newest messages at the bottom
                  children: snapshot.data!.docs.map((doc) {
                    // Extract sender and message
                    final sender = doc['sender'] ?? 'Unknown Sender';
                    final text = doc['text'] ?? 'No Text';
                    final data = doc.data() as Map<String, dynamic>;
                    final isOrg = data.containsKey('isOrganisation')
                        ? data['isOrganisation']
                        : false;

                    return ListTile(
                      title: Text(
                        sender,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOrg ? Colors.blue : Colors.green, // Differentiate user types
                        ),
                      ),
                      trailing: isOrg
                          ? const Icon(Icons.business, color: Colors.blue)
                          : const Icon(Icons.person, color: Colors.green),
                      subtitle: Text(
                        text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Message input and send button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
