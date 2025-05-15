import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:uni_pulse/Screens/initializing/utils.dart';

class RegisterOrganisationScreen extends ConsumerStatefulWidget {
  const RegisterOrganisationScreen({super.key});

  @override
  ConsumerState<RegisterOrganisationScreen> createState() =>
      _RegisterOrganisationScreenState();
}

class _RegisterOrganisationScreenState extends ConsumerState<RegisterOrganisationScreen> {

Uint8List? _image;
void selectImage() async{
  Uint8List img = await pickImage(ImageSource.gallery);
  setState(() {
    _image = img;
  });
}

  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Add more controllers for organisation-specific fields if needed

  void _saveOrganisationAccount() async {
    if (_orgNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    // Call a provider method for registering an organisation
    final String? errorMessage =
        await ref.read(accountsProvider.notifier).registerOrganisation(
              orgName: _orgNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              userName: _usernameController.text.trim(),
            );

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $errorMessage")),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Organisation Registration Successful!")),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const AuthScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Register Organisation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               Center(
                 child: Stack(
                  children: [
                    _image != null ?
                         CircleAvatar(
                            radius: 65,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                                'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'),
                          ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                               ),
               ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _orgNameController,
                decoration:
                    const InputDecoration(labelText: "Organisation Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the organisation name";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  if (value.length < 3) {
                    return "Username must be at least 3 characters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  if (!RegExp(r'^\+?\d{10,13}$').hasMatch(value)) {
                    return "Please enter a valid phone number";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOrganisationAccount,
                child: const Text("Register Organisation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
