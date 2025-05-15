import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:uni_pulse/Screens/organizations/org_home.dart';
import 'package:uni_pulse/Screens/users/user_home_page.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthScreen is the main login interface.
/// It allows both users and organisations to log in using their credentials
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // Text controllers to control email and password input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Displays an error dialog with the provided [message]
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text("OK")),
        ],
      ),
    );
  }
  
  ///Handles user authentication
  ///Uses the [accountsProvider] to validate login details
  ///Redirects user to either the organisation or user homepage upon success.
  void handleAuth(WidgetRef ref) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate input fields
    if (email.isEmpty || password.isEmpty) {
      showErrorDialog("All fields are required.");
      return;
    }

    try {
      // Attempt to authenticate using the provider
      final account = await ref
          .read(accountsProvider.notifier)
          .authenticate(email, password);

      if (account != null) {
        Navigator.pop(context);
        if (account.isOrganisation) {
          // Redirect to organisation homepage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => OrgHomePage()),
          );
        } else {
          //Redirect to user homepage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => HomePage()),
          );
        }
      } else {
        // Authentication failed
        showErrorDialog("Invalid credentials. Please try again.");
      }
    } catch (e) {
      // Catch any unexpected errors
      showErrorDialog("An error occurred during login. Please try again.");
      debugPrint('Error during login: $e');
    }
  }
  
  /// Builds the login UI.
  /// Contains fields for email and password, and a login button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email", prefixIcon: Icon(Icons.email)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password", prefixIcon: Icon(Icons.lock)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => handleAuth(ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text("LOGIN"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
