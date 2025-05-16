import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Screens/users/user_home_page.dart';
import 'package:uni_pulse/Screens/users/list_events.dart';

void main() {
  group('UserHomePage Widget Tests', () {
    testWidgets('Renders UserHomePage with AppBar and ListEvents', (WidgetTester tester) async {
      // Build the UserHomePage widget
      await tester.pumpWidget(
        MaterialApp(
          home: UserHomePage(),
        ),
      );

      // Verify the AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify the AppBar title
      expect(find.text('Events'), findsOneWidget);

      // Verify the presence of the ListEvents widget
      expect(find.byType(ListEvents), findsOneWidget);
    });

    testWidgets('Displays a welcome message', (WidgetTester tester) async {
      // Build the UserHomePage widget
      await tester.pumpWidget(
        MaterialApp(
          home: UserHomePage(),
        ),
      );
          });

    testWidgets('Navigates to another page when a button is tapped', (WidgetTester tester) async {
      // Build the UserHomePage widget
      await tester.pumpWidget(
        MaterialApp(
          home: UserHomePage(),
        ),
      );


      // Tap the button
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify navigation occurred 
      expect(find.text('Profile'), findsOneWidget); 
    });
  });
}