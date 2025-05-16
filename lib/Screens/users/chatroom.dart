import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(ChatApp());
// }

// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FirebaseAuth.instance.currentUser == null
//           ? LoginScreen()
//           : ChatRoom(),
//     );
//   }

// }

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void login(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ChatRoom()),
//       );
//     } catch (e) {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ChatRoom()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login to Chat')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
//             TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => login(context),
//               child: Text('Login / Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChatRoom extends StatelessWidget {
  final String eventTitle;
  final String eventId;
  final TextEditingController _messageController = TextEditingController();
  final String username;
  final bool isOrganisation;
  // final CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  ChatRoom({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.username,
    required this.isOrganisation,
  });

  @override
  Widget build(BuildContext context) {
    final CollectionReference messages = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('messages');

    void sendMessage() {
      if (_messageController.text.trim().isEmpty) return;
      messages.add({
        'text': _messageController.text.trim(),
        'sender': username,
        'isOrganisation': isOrganisation,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room: $eventTitle', style: Theme.of(context).textTheme.titleLarge),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () async {
        //       await FirebaseAuth.instance.signOut();
        //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  messages.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
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
                          color: isOrg ? Colors.blue : Colors.green,
                        ),
                      ),
                      trailing: isOrg
                          ? Icon(Icons.business, color: Colors.blue)
                          : Icon(Icons.person, color: Colors.green),
                      subtitle: Text(
                        text, style: TextStyle(color: Colors.white)
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
