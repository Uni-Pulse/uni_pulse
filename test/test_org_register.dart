import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/organizations/org_register.dart';

void main() {
  testWidgets('RegisterOrganisationScreen renders and validates required fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterOrganisationScreen(),
        ),
      ),
    );

    // Should show all main input fields
    expect(find.byType(TextFormField), findsNWidgets(6));
    expect(find.text('Register'), findsOneWidget);

    // Try to submit without filling required fields
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Should show validation errors
    expect(find.textContaining('enter'), findsWidgets);
  });

  testWidgets('RegisterOrganisationScreen shows password mismatch error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterOrganisationScreen(),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Org');
    await tester.enterText(find.byType(TextFormField).at(1), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(2), '+12345678901');
    await tester.enterText(find.byType(TextFormField).at(3), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(4), 'password1');
    await tester.enterText(find.byType(TextFormField).at(5), 'password2');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
