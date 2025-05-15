import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:uni_pulse/Screens/organizations/org_home.dart';
import 'package:uni_pulse/Screens/users/user_home_page.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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

  void handleAuth(WidgetRef ref) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog("All fields are required.");
      return;
    }

    try {
      final account = await ref
          .read(accountsProvider.notifier)
          .authenticate(email, password);

      if (account != null) {
        Navigator.pop(context);
        if (account.isOrganisation) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => OrgHomePage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => HomePage()),
          );
        }
      } else {
        showErrorDialog("Invalid credentials. Please try again.");
      }
    } catch (e) {
      showErrorDialog("An error occurred during login. Please try again.");
      debugPrint('Error during login: $e');
    }
  }

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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
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
                      
                    ),
                    child: Text("LOGIN", style: Theme.of(context).textTheme.bodyMedium),
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
