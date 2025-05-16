// Flutter widget test for StartScreen.
//
// This test verifies that StartScreen renders all buttons correctly
// and navigates to the appropriate screens when tapped.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Screens/initializing/start_screen.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';
import 'package:uni_pulse/Screens/initializing/register_screen.dart';
import 'package:uni_pulse/Screens/organizations/org_register.dart';

void main() {
  testWidgets('TC1 - StartScreen UI renders with all buttons and title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StartScreen(),
      ),
    );

    // Check for the title
    expect(find.text('UNI Pulse'), findsOneWidget);

    // Check for all three buttons
    expect(find.text('Register As Individual'), findsOneWidget);
    expect(find.text('Register As Organisation'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('TC2 - Tapping "Register As Individual" navigates to RegisterScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const StartScreen(),
        routes: {
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );

    await tester.tap(find.text('Register As Individual'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('TC3 - Tapping "Register As Organisation" navigates to RegisterOrganisationScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const StartScreen(),
        routes: {
          '/orgRegister': (context) => const RegisterOrganisationScreen(),
        },
      ),
    );

    await tester.tap(find.text('Register As Organisation'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterOrganisationScreen), findsOneWidget);
  });

  testWidgets('TC4 - Tapping "Login" navigates to AuthScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const StartScreen(),
        routes: {
          '/login': (context) => const AuthScreen(),
        },
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
