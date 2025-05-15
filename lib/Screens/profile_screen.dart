import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String _name = '';
  String _lastname = '';
  String _email = '';
  int _phonenum = 0;
  String _profileImageUrl = '';
  bool _isEditing = false;
  File? _selectedImageFile;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<String> _starredEvents = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.email).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _name = data['firstName'];
          _lastname = data['lastName'];
          _email = data['email'];
          _phonenum = int.parse(data['phoneNum']);
          _profileImageUrl = data['profileImageUrl'] ?? '';
          _starredEvents = List<String>.from(data['starredEvents'] ?? []);
          _nameController.text = _name;
          _lastNameController.text = _lastname;
          _emailController.text = _email;
          _phoneController.text = _phonenum.toString();
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _profileImageUrl = '';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final userEmail = FirebaseAuth.instance.currentUser!.email;
        await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
          'firstName': _name,
          'lastName': _lastname,
          'email': _email,
          'phoneNum': _phonenum.toString(),
          'starredEvents': _starredEvents,
        });
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  void _toggleStarredEvent(String eventName) {
    setState(() {
      if (_starredEvents.contains(eventName)) {
        _starredEvents.remove(eventName);
      } else {
        _starredEvents.add(eventName);
      }
    });
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;
      if (email != null) {
        await FirebaseFirestore.instance.collection('users').doc(email).delete();
      }
      await user?.delete();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
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
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      child: _selectedImageFile != null
                          ? ClipOval(child: Image.file(_selectedImageFile!, fit: BoxFit.cover, width: 120, height: 120))
                          : _profileImageUrl.isNotEmpty
                          ? ClipOval(child: Image.network(_profileImageUrl, fit: BoxFit.cover, width: 120, height: 120))
                          : const Icon(Icons.person, size: 60),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                onSaved: (value) => _name = value ?? '',
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _lastNameController,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                onSaved: (value) => _lastname = value ?? '',
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phonenum = int.tryParse(value ?? '') ?? 0,
              ),
              const SizedBox(height: 20),

              if (_isEditing)
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF660099),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _saveProfile,
                      child: const Text('Save Profile', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _confirmDeleteAccount,
                      child: const Text('Delete Account', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

              const Text('Starred Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              for (var event in _starredEvents)
                ListTile(
                  title: Text(event),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => _toggleStarredEvent(event),
                  ),
                ),
              const SizedBox(height: 30),

              const Text('Your Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TableCalendar(
                firstDay: DateTime.utc(2022, 01, 01),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}