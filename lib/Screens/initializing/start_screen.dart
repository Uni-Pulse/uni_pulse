import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';
import 'package:uni_pulse/Screens/initializing/register_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Image
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.PNG',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Title & Subtitle
            Column(
              children: [
                // Text(
                //   "Title",
                //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                //         fontWeight: FontWeight.bold,
                //       ),
                // ),
                Text(
                  "UNI Pulse",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AuthScreen(),
                        ),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
