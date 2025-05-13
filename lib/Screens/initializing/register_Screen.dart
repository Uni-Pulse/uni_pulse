import 'package:flutter/material.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isOrganisation = false;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final String? errorMessage = await ref.read(accountsProvider.notifier).registerUser(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneNumberController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _selectedDate!,
      isOrganisation,
      _usernameController.text.trim(),
    );

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $errorMessage")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!")),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: _buildInputDecoration("Username"),
                validator: (value) => value == null || value.isEmpty || value.length < 3
                    ? "Username must be at least 3 characters"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _firstNameController,
                decoration: _buildInputDecoration("First Name"),
                validator: (value) => value == null || value.isEmpty ? "Please enter your first name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _lastNameController,
                decoration: _buildInputDecoration("Last Name"),
                validator: (value) => value == null || value.isEmpty ? "Please enter your last name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneNumberController,
                decoration: _buildInputDecoration("Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || !RegExp(r'^\+?\d{10,13}$').hasMatch(value)
                    ? "Please enter a valid phone number"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration("Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                    ? "Please enter a valid email"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                decoration: _buildInputDecoration("Password"),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: _buildInputDecoration("Confirm Password"),
                obscureText: true,
                validator: (value) =>
                    value != _passwordController.text ? "Passwords do not match" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dobController,
                decoration: _buildInputDecoration("Date of Birth"),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (_) =>
                    _selectedDate == null ? "Please select a date of birth" : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Make it an organisation"),
                  const Spacer(),
                  Switch(
                    value: isOrganisation,
                    onChanged: (val) => setState(() => isOrganisation = val),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
