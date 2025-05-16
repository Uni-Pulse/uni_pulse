import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Screens/initializing/register_Screen.dart';


void main() {
  testWidgets('RegisterScreen displays and interacts correctly', (WidgetTester tester) async {
    // Build the RegisterScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // Verify that the screen contains expected widgets
    expect(find.text('Register'), findsOneWidget); // Example: Check for a title
    expect(find.byType(TextField), findsNWidgets(2)); // Example: Check for input fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Example: Check for a button

    // Interact with the widgets
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

   
    // Check for a success message or navigation
    expect(find.text('Registration Successful'), findsNothing); 
  });
}