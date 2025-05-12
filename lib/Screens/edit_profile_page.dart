import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String userType;
  final String bio;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.userType,
    required this.bio,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  String _selectedUserType = 'Individual';
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _bioController = TextEditingController(text: widget.bio);
    _selectedUserType = widget.userType;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    // You can send this data to a backend or local storage
    print(
      "Saved: ${_nameController.text}, ${_emailController.text}, $_selectedUserType, ${_bioController.text}",
    );
  }

    void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Delete Account', style: Theme.of(context).textTheme.bodySmall),
        content:  Text('Are you sure you want to delete your account? This action cannot be undone.', style: Theme.of(context).textTheme.bodySmall,),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _deleteAccount();
            },
            child:  Text('Delete', style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

 void _deleteAccount() {
    // Add your account deletion logic here
    print('Account deleted'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                child:
                    _profileImage == null
                        ? const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white70,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedUserType,
              items:
                  ['Individual', 'Organization'].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'User Type'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _confirmDeleteAccount,
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

