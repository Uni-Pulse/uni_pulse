import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Providers/events_provider.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override

  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreenState();
  }

}
class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String _name = '';
  String _lastname = '';
  String _email = '';
  int _phonenum = 0;
  final String _profileImageUrl = '';
  final bool _isEditing = false;
  File? _selectedImageFile;
  final DateTime _selectedDay = DateTime.now();
  final DateTime _focusedDay = DateTime.now();
  final List<String> _starredEvents = [];
  late Future<dynamic> currentUserFuture;

  @override
  void initState() {
    super.initState();

    currentUserFuture = Future.value(ref.read(accountsProvider.notifier).currentUser);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final currentUser = snapshot.data;
            _name = currentUser.firstName;
            _email = currentUser.email;
            _lastname = currentUser.lastName;
            _phonenum = currentUser.phoneNum;

            return Scaffold(
              appBar: AppBar(
                title: Text('Profile Details'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF0091DA),
                        child:
                            Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      SizedBox(height: 20),

                      // Name
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _name = value ?? '',
                      ),
                      SizedBox(height: 15),

                      // Last Name
                      TextFormField(
                        initialValue: _lastname,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _lastname = value ?? '',
                      ),
                      SizedBox(height: 15),

                      // Email
                      TextFormField(
                        initialValue: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _email = value ?? '',
                      ),
                      SizedBox(height: 15),

                      // Phone Number
                      TextFormField(
                        initialValue: _phonenum.toString(),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _lastname = value ?? '',
                      ),
                      SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF660099),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () async {
                          // Save the form data
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();

                            try {
                              // Get the current user's ID
                              final userEmail =
                                  FirebaseAuth.instance.currentUser!.email;

                              // Update the user's data in Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userEmail)
                                  .update({
                                'firstName': _name,
                                'lastName': _lastname,
                                'email': _email,
                                'phoneNum': _phonenum
                                    .toString(), // Ensure phoneNum is saved as a String
                              });

                              // Show a success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Profile updated successfully!')),
                              );
                            } catch (e) {
                              // Handle errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to update profile: $e')),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      SizedBox(height: 30),
                      Text(
                        '⭐ Starred Events',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Scrollable List of Starred Events
                      ...currentUser.favouriteEvents.map((event) => Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading:
                                  Icon(Icons.event, color: Color(0xFF0091DA)),
                              title: Text(event.eventName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${event.date} • ${event.ticketPrice}'),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          }
        });

  }
}
