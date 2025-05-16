import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:table_calendar/table_calendar.dart';
import 'package:uni_pulse/Screens/event_details.dart';
// import 'package:uni_pulse/Models/events.dart';
import 'package:uni_pulse/Providers/events_provider.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  // bool _isLoading = true;

  String _username = '';
  String _name = '';
  String _lastname = '';
  String _email = '';
  int _phonenum = 0;
  bool _isEditing = false;

  // DateTime _selectedDay = DateTime.now();
  // DateTime _focusedDay = DateTime.now();

  List<String> _starredEvents = [];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    debugPrint('ProfileScreen: currentUser is ${currentUser?.uid ?? "null"}');
    // setState(() => _isLoading = true);
    if (currentUser == null) {
      await Future.delayed(const Duration(milliseconds: 300));
      final retryUser = FirebaseAuth.instance.currentUser;
      debugPrint('ProfileScreen: retryUser is ${retryUser?.uid ?? "null"}');
      if (retryUser == null) {
        // setState(() => _isLoading = false);
        return;
      }
    }
    if (currentUser == null) {
      // setState(() => _isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        _username = data['username'] ?? '';
        _name = data['firstName'] ?? '';
        _lastname = data['lastName'] ?? '';
        _email = data['email'] ?? '';
        _phonenum = data['phoneNum'] is int
            ? data['phoneNum']
            : int.tryParse(data['phoneNum']?.toString() ?? '') ?? 0;
        _starredEvents = List<String>.from(data['starredEvents'] ?? []);
        _usernameController.text = _username;
        _nameController.text = _name;
        _lastNameController.text = _lastname;
        _emailController.text = _email;
        _phoneController.text = _phonenum.toString();
        // _isLoading = false;
      });
    } else {
      // setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {

        final userUid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .update({
          'firstName': _name,
          'lastName': _lastname,
          'email': _email,
          'phoneNum': _phonenum,
          'starredEvents': _starredEvents,
        });

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        debugPrint('Failed to update profile: $e'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  // void _toggleStarredEvent(String eventName) {
  //   setState(() {
  //     if (_starredEvents.contains(eventName)) {
  //       _starredEvents.remove(eventName);
  //     } else {
  //       _starredEvents.add(eventName);
  //     }
  //   });
  // }

  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Delete user document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete user from Firebase Authentication
      await user.delete();

      // Optionally, sign out and navigate to login screen
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const StartScreen()),
          (route) => false,
        ); // or your AuthScreen
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  // void _confirmDeleteAccount() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Account'),
  //       content: const Text(
  //           'Are you sure you want to delete your account? This action cannot be undone.'),
  //       actions: [
  //         TextButton(
  //           child: const Text('Cancel'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //         TextButton(
  //           child: const Text('Delete', style: TextStyle(color: Colors.red)),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             _deleteAccount();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: const Color(0xFF660099),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _usernameController,
                enabled: false,
                decoration: const InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder()),
                onSaved: (value) => _username = value ?? '',
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                    labelText: 'First Name', border: OutlineInputBorder()),
                onSaved: (value) => _name = value ?? '',
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _lastNameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                    labelText: 'Last Name', border: OutlineInputBorder()),
                onSaved: (value) => _lastname = value ?? '',
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                    labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phonenum = int.tryParse(value ?? '') ?? 0,
              ),
              const SizedBox(height: 20),
              if (_isEditing)
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 32),
                        minimumSize:
                            const Size(180, 50), // <-- Make button bigger
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium, // Bigger text
                      ),
                      onPressed: _saveProfile,

                      child: Text(
                        'Save Profile',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                'Are you sure you want to delete your account? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _deleteAccount();
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete Account'),

                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              const Text('Starred Events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: _starredEvents.isEmpty
                    ? Center(
                        child: Text(
                          'No events found.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            _starredEvents.length, // Use filtered events here
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    // You need to fetch or construct the EventData object here.
                                    // For demonstration, replace this with your actual event fetching logic.
                                    // Example assumes you have a method getEventDataByName(String name)
                                    final event = ref
                                        .watch(eventsProvider.notifier)
                                        .getEventByName(_starredEvents[index]);
                                    if (event == null) {
                                      return const Scaffold(
                                        body: Center(
                                            child: Text('Event not found')),
                                      );
                                    }
                                    return EventDetailsScreen(event: event);
                                  },
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Text(
                                      _starredEvents[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    // You may add a subtitle if you have more event info
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              for (var event in _starredEvents)
                ListTile(
                  title: Text(event),
                  trailing: IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber),
                      onPressed: () => {} //_toggleStarredEvent(event),
                      ),
                ),

              // const SizedBox(height: 30),
              // const Text('Your Calendar',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // const SizedBox(height: 10),
              // TableCalendar(
              //   firstDay: DateTime.utc(2022, 01, 01),
              //   lastDay: DateTime.utc(2025, 12, 31),
              //   focusedDay: _focusedDay,
              //   selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              //   onDaySelected: (selectedDay, focusedDay) {
              //     setState(() {
              //       _selectedDay = selectedDay;
              //       _focusedDay = focusedDay;
              //     });
              //   },
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
