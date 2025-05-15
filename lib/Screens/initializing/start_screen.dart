import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';
import 'package:uni_pulse/Screens/initializing/register_screen.dart';
import 'package:uni_pulse/Screens/organizations/org_register.dart'; // Make sure this path is correct

/// The StartScreen is the entry point of the app where users can:
/// - Register as an individual
/// - Register as an organisation
/// - Login if they already have an account
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  /// Builds the UI for the Start Screen.
  /// Displays logo, title, and navigation buttons for user actions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sets the background color to match the current theme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        // Allows scrolling on smaller screens
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Logo Image
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.PNG', // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title & Subtitle
              const SizedBox(height: 20),
              const Text(
                "UNI Pulse",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const RegisterScreen()));
                  },
                  child: const Text("Register-Individual"),
                ),
              ),
              const SizedBox(height: 15),
              // Register Organisation Button
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegisterOrganisationScreen()),
                    );
                  },
                  child: const Text("Register Organisation"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const AuthScreen()));
                  },
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
