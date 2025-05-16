import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Screens/organizations/org_home.dart';

void main() {
  testWidgets('OrgHomePage displays OrgListEvents and ProfileScreen, and switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrgHomePage()));

    // Should show 'My Events' (from OrgListEvents)
    expect(find.text('My Events'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.account_circle), findsOneWidget);

    // Tap the Profile tab
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    // Should show 'Profile Details' (from ProfileScreen)
    expect(find.text('Profile Details'), findsOneWidget);
    // Should still have navigation icons
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.account_circle), findsOneWidget);

    // Tap back to Events tab
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('My Events'), findsOneWidget);
  });
}
