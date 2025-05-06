import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _course = '';
  String _studentID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF660099),
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
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              SizedBox(height: 20),

              // Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value ?? '',
              ),
              SizedBox(height: 15),

              // Email
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'University Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
              ),
              SizedBox(height: 15),

              // Course
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _course = value ?? '',
              ),
              SizedBox(height: 15),

              // Student ID
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _studentID = value ?? '',
              ),
              SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF660099),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Profile Saved'),
                      content: Text(
                        'Name: $_name\nEmail: $_email\nCourse: $_course\nID: $_studentID',
                      ),
                      actions: [
                        TextButton(
                          child: Text('OK', style: TextStyle(color: Color(0xFF660099))),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                },
                child: Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
