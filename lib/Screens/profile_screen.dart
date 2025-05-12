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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor:Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:Theme.of(context).colorScheme.surface,
                child: Icon(Icons.person, size: 60, color:Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: 20),

              // Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: Theme.of(context).textTheme.bodySmall
                ),
                onSaved: (value) => _name = value ?? '',
              ),
              SizedBox(height: 15),

              // Email
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'University Email',
                  labelStyle: Theme.of(context).textTheme.bodySmall
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
              ),
              SizedBox(height: 15),

              // Course
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Course',
                  labelStyle: Theme.of(context).textTheme.bodySmall
                ),
                onSaved: (value) => _course = value ?? '',
              ),
              SizedBox(height: 15),

              // Student ID
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Student ID', 
                  labelStyle: Theme.of(context).textTheme.bodySmall
                ),
                onSaved: (value) => _studentID = value ?? '',
              ),
              SizedBox(height: 25),

              ElevatedButton(
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
                          child: Text('OK', style: Theme.of(context).textTheme.bodySmall),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                },
                child: Text(
                  'Save Profile',
                  style:Theme.of(context).textTheme.bodySmall),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
