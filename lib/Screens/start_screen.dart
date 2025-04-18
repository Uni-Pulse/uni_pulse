import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/login.dart';
import 'package:uni_pulse/Screens/register_Screen.dart';
 
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            color: const Color(0xFFD8BFD8), // Light purple background
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(20),
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
                    'assets/logo.png', // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title & Subtitle
              Column(
                children: const [
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "unipulse",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A0DAD), // Dark purple
                        foregroundColor: Colors.white, // White text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const RegisterScreen() ));},
                      child: const Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A0DAD), // Dark purple
                        foregroundColor: Colors.white, // White text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AuthScreen() ));},
                      child: const Text("Login"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

