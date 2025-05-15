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
                width: 150,
                height: 150,
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
              const SizedBox(height: 70),
              Text("UNI Pulse",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const RegisterScreen()));
                  },
                  child: Text(
                    "Register As Individual",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Register Organisation Button
              SizedBox(
                width: 250,
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
                  child: Text(
                    "Register As Organisation",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const AuthScreen()));
                  },
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
