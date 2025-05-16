import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/organizations/org_list_events.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsNotifier extends Mock implements EventNotifier {}

void main() {
  testWidgets('OrgListEvents displays events and handles empty state', (WidgetTester tester) async {
    // Mock provider setup
    final mockNotifier = MockEventsNotifier();
    // Provide a fake current user and events
    final container = ProviderContainer(overrides: [
      eventsProvider.overrideWith((ref) => mockNotifier),
      // You may need to override accountsProvider if OrgListEvents uses it
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: OrgListEvents(),
        ),
      ),
    );

    // Should show search bar and 'No events found.' if no events
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('No events found.'), findsOneWidget);
  });
}
